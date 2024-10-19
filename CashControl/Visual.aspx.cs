//using System;
//using System.Data.SqlClient;
//using System.Configuration;
//using System.Text.Json;

//namespace PersonalFinanceManager
//{
//    public partial class Visual : System.Web.UI.Page
//    {
//        private string connectionString = ConfigurationManager.ConnectionStrings["FinanceDB"].ConnectionString;

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                LoadChartData();
//            }
//        }

//        private void LoadChartData()
//        {
//            using (SqlConnection con = new SqlConnection(connectionString))
//            {
//                // Load category chart data
//                string categoryQuery = "SELECT c.Name AS Category, SUM(t.Amount) AS TotalAmount FROM Transactions t JOIN Categories c ON t.CategoryId = c.Id GROUP BY c.Name";
//                SqlCommand categoryCmd = new SqlCommand(categoryQuery, con);
//                con.Open();
//                SqlDataReader categoryReader = categoryCmd.ExecuteReader();

//                var labels = new System.Collections.Generic.List<string>();
//                var data = new System.Collections.Generic.List<decimal>();

//                while (categoryReader.Read())
//                {
//                    labels.Add(categoryReader["Category"].ToString());
//                    data.Add(Convert.ToDecimal(categoryReader["TotalAmount"]));
//                }

//                var chartData = new
//                {
//                    labels = labels,
//                    data = data
//                };

//                string serializedChartData = JsonSerializer.Serialize(chartData);
//                ClientScript.RegisterStartupScript(this.GetType(), "ChartData", $"var chartData = {serializedChartData};", true);

//                // Close the first DataReader before opening another
//                categoryReader.Close();

//                // Load income and expense data
//                string incomeExpenseQuery = "SELECT SUM(CASE WHEN t.Amount > 0 THEN t.Amount ELSE 0 END) AS TotalIncome, SUM(CASE WHEN t.Amount < 0 THEN t.Amount ELSE 0 END) AS TotalExpense FROM Transactions t";
//                SqlCommand incomeExpenseCmd = new SqlCommand(incomeExpenseQuery, con);
//                var incomeExpenseReader = incomeExpenseCmd.ExecuteReader();

//                decimal totalIncome = 0;
//                decimal totalExpense = 0;

//                if (incomeExpenseReader.Read())
//                {
//                    totalIncome = Convert.ToDecimal(incomeExpenseReader["TotalIncome"]);
//                    totalExpense = Math.Abs(Convert.ToDecimal(incomeExpenseReader["TotalExpense"])); // Ensure expense is positive
//                }

//                string incomeExpenseData = JsonSerializer.Serialize(new { income = totalIncome, expense = totalExpense });
//                ClientScript.RegisterStartupScript(this.GetType(), "IncomeExpenseData", $"var incomeExpenseData = {incomeExpenseData};", true);
//            }
//        }
//    }
//}


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
                con.Open();

                // Load income by category
                string incomeQuery = "SELECT c.Name AS Category, SUM(t.Amount) AS TotalAmount FROM Transactions t JOIN Categories c ON t.CategoryId = c.Id WHERE t.Amount > 0 GROUP BY c.Name";
                SqlCommand incomeCmd = new SqlCommand(incomeQuery, con);
                SqlDataReader incomeReader = incomeCmd.ExecuteReader();

                var incomeLabels = new System.Collections.Generic.List<string>();
                var incomeData = new System.Collections.Generic.List<decimal>();

                while (incomeReader.Read())
                {
                    incomeLabels.Add(incomeReader["Category"].ToString());
                    incomeData.Add(Convert.ToDecimal(incomeReader["TotalAmount"]));
                }

                var incomeChartData = new
                {
                    labels = incomeLabels,
                    data = incomeData
                };

                string serializedIncomeChartData = JsonSerializer.Serialize(incomeChartData);
                ClientScript.RegisterStartupScript(this.GetType(), "IncomeChartData", $"var incomeChartData = {serializedIncomeChartData};", true);

                incomeReader.Close();

                // Load expense by category
                string expenseQuery = "SELECT c.Name AS Category, SUM(t.Amount) AS TotalAmount FROM Transactions t JOIN Categories c ON t.CategoryId = c.Id WHERE t.Amount < 0 GROUP BY c.Name";
                SqlCommand expenseCmd = new SqlCommand(expenseQuery, con);
                SqlDataReader expenseReader = expenseCmd.ExecuteReader();

                var expenseLabels = new System.Collections.Generic.List<string>();
                var expenseData = new System.Collections.Generic.List<decimal>();

                while (expenseReader.Read())
                {
                    expenseLabels.Add(expenseReader["Category"].ToString());
                    expenseData.Add(Math.Abs(Convert.ToDecimal(expenseReader["TotalAmount"])));
                }

                var expenseChartData = new
                {
                    labels = expenseLabels,
                    data = expenseData
                };

                string serializedExpenseChartData = JsonSerializer.Serialize(expenseChartData);
                ClientScript.RegisterStartupScript(this.GetType(), "ExpenseChartData", $"var expenseChartData = {serializedExpenseChartData};", true);

                expenseReader.Close();

                // Load income and expense totals
                string incomeExpenseQuery = "SELECT SUM(CASE WHEN t.Amount > 0 THEN t.Amount ELSE 0 END) AS TotalIncome, SUM(CASE WHEN t.Amount < 0 THEN t.Amount ELSE 0 END) AS TotalExpense FROM Transactions t";
                SqlCommand incomeExpenseCmd = new SqlCommand(incomeExpenseQuery, con);
                SqlDataReader incomeExpenseReader = incomeExpenseCmd.ExecuteReader();

                decimal totalIncome = 0;
                decimal totalExpense = 0;

                if (incomeExpenseReader.Read())
                {
                    totalIncome = Convert.ToDecimal(incomeExpenseReader["TotalIncome"]);
                    totalExpense = Math.Abs(Convert.ToDecimal(incomeExpenseReader["TotalExpense"]));
                }

                string incomeExpenseData = JsonSerializer.Serialize(new { income = totalIncome, expense = totalExpense });
                ClientScript.RegisterStartupScript(this.GetType(), "IncomeExpenseData", $"var incomeExpenseData = {incomeExpenseData};", true);
            }
        }
    }
}

