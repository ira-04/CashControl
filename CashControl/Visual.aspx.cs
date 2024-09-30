using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Text.Json;

namespace PersonalFinanceManager
{
    public partial class Visual : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["FinanceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadChartData();
            }
        }

        private void LoadChartData()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Load category chart data
                string categoryQuery = "SELECT c.Name AS Category, SUM(t.Amount) AS TotalAmount FROM Transactions t JOIN Categories c ON t.CategoryId = c.Id GROUP BY c.Name";
                SqlCommand categoryCmd = new SqlCommand(categoryQuery, con);
                con.Open();
                SqlDataReader categoryReader = categoryCmd.ExecuteReader();

                var labels = new System.Collections.Generic.List<string>();
                var data = new System.Collections.Generic.List<decimal>();

                while (categoryReader.Read())
                {
                    labels.Add(categoryReader["Category"].ToString());
                    data.Add(Convert.ToDecimal(categoryReader["TotalAmount"]));
                }

                var chartData = new
                {
                    labels = labels,
                    data = data
                };

                string serializedChartData = JsonSerializer.Serialize(chartData);
                ClientScript.RegisterStartupScript(this.GetType(), "ChartData", $"var chartData = {serializedChartData};", true);

                // Close the first DataReader before opening another
                categoryReader.Close();

                // Load income and expense data
                string incomeExpenseQuery = "SELECT SUM(CASE WHEN t.Amount > 0 THEN t.Amount ELSE 0 END) AS TotalIncome, SUM(CASE WHEN t.Amount < 0 THEN t.Amount ELSE 0 END) AS TotalExpense FROM Transactions t";
                SqlCommand incomeExpenseCmd = new SqlCommand(incomeExpenseQuery, con);
                var incomeExpenseReader = incomeExpenseCmd.ExecuteReader();

                decimal totalIncome = 0;
                decimal totalExpense = 0;

                if (incomeExpenseReader.Read())
                {
                    totalIncome = Convert.ToDecimal(incomeExpenseReader["TotalIncome"]);
                    totalExpense = Math.Abs(Convert.ToDecimal(incomeExpenseReader["TotalExpense"])); // Ensure expense is positive
                }

                string incomeExpenseData = JsonSerializer.Serialize(new { income = totalIncome, expense = totalExpense });
                ClientScript.RegisterStartupScript(this.GetType(), "IncomeExpenseData", $"var incomeExpenseData = {incomeExpenseData};", true);
            }
        }
    }
}
