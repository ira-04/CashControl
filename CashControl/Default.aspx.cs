using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.Json;
using System.Text;

namespace PersonalFinanceManager
{
    public partial class Default : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["FinanceDB"].ConnectionString;


        protected void btnExport_Click(object sender, EventArgs e)
        {
            // Clear any previous output
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Transactions.csv");
            Response.Charset = "";
            Response.ContentType = "application/text";

            StringBuilder sb = new StringBuilder();

            // Add column headers
            for (int i = 0; i < gvTransactions.Columns.Count; i++)
            {
                if (gvTransactions.Columns[i].Visible) // Only export visible columns
                {
                    sb.Append(gvTransactions.Columns[i].HeaderText + ',');
                }
            }
            sb.Append("\r\n");

            // Add rows
            foreach (GridViewRow row in gvTransactions.Rows)
            {
                for (int i = 0; i < gvTransactions.Columns.Count; i++)
                {
                    if (gvTransactions.Columns[i].Visible) // Only export visible columns
                    {
                        sb.Append(row.Cells[i].Text.Replace(",", "") + ','); // Avoid extra commas in CSV
                    }
                }
                sb.Append("\r\n");
            }

            // Output the CSV file
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTransactions();
                LoadCategories();
                UpdateFinalAmount(); // Update final amount when the page loads
                LoadChartData();
            }
        }

        protected void btnAddTransaction_Click(object sender, EventArgs e)
        {
            string date = txtDate.Text;
            string description = txtDescription.Text;
            decimal amount;
            if (!decimal.TryParse(txtAmount.Text, out amount))
            {
                lblError.Text = "Invalid amount. Please enter a valid number.";
                lblError.Visible = true;
                return;
            }

            string type = ddlType.SelectedValue;
            int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);

            // Adjust amount based on type (Expense or Income)
            if (type == "Expense")
            {
                amount = -amount; // Make amount negative for expenses
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Transactions (Date, Description, Amount, Type, CategoryId) VALUES (@Date, @Description, @Amount, @Type, @CategoryId)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Date", DateTime.Parse(date));
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@Amount", amount);
                cmd.Parameters.AddWithValue("@Type", type);
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadTransactions();
            ClearFields();
            UpdateFinalAmount(); // Update final amount after a new transaction is added
        }

        private void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Categories";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlCategory.DataSource = reader;
                ddlCategory.DataTextField = "Name";
                ddlCategory.DataValueField = "Id";
                ddlCategory.DataBind();
            }
            ddlCategory.Items.Insert(0, new ListItem("Select a category", "0"));
        }

        private void LoadTransactions(string sortExpression = null, string sortDirection = "ASC", string searchQuery = null)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT t.*, c.Name AS CategoryName FROM Transactions t JOIN Categories c ON t.CategoryId = c.Id";

                if (!string.IsNullOrEmpty(searchQuery))
                {
                    query += " WHERE t.Description LIKE @SearchQuery";
                }

                if (!string.IsNullOrEmpty(sortExpression))
                {
                    query += " ORDER BY " + sortExpression + " " + sortDirection;
                }

                SqlCommand cmd = new SqlCommand(query, con);
                if (!string.IsNullOrEmpty(searchQuery))
                {
                    cmd.Parameters.AddWithValue("@SearchQuery", "%" + searchQuery + "%");
                }

                con.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();

                lblNoResults.Visible = dt.Rows.Count == 0;
                if (lblNoResults.Visible)
                {
                    lblNoResults.Text = string.IsNullOrEmpty(searchQuery) ? "No data found." : "No transactions found matching the search criteria.";
                }
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            string searchQuery = txtSearch.Text.Trim();
            LoadTransactions(searchQuery: searchQuery);
        }

        protected void btnFind_Click(object sender, EventArgs e)
        {
            string searchQuery = txtSearch.Text.Trim();
            LoadTransactions(searchQuery: searchQuery);
        }

        private void UpdateFinalAmount()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT SUM(Amount) AS FinalAmount FROM Transactions";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                object result = cmd.ExecuteScalar();

                if (result != DBNull.Value)
                {
                    decimal finalAmount = Convert.ToDecimal(result);
                    lblFinalAmount.Text = "Final Balance: " + finalAmount.ToString("C");
                }
            }
        }

        private void ClearFields()
        {
            txtDate.Text = "";
            txtDescription.Text = "";
            txtAmount.Text = "";
            ddlType.SelectedIndex = 0;
            ddlCategory.SelectedIndex = 0;
        }

        protected void gvTransactions_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvTransactions.EditIndex = e.NewEditIndex;
            LoadTransactions();
        }

        protected void gvTransactions_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvTransactions.Rows[e.RowIndex];
            int transactionId = Convert.ToInt32(gvTransactions.DataKeys[e.RowIndex].Values[0]);
            DateTime date = DateTime.Parse((row.FindControl("txtDateEdit") as TextBox).Text);
            string description = (row.FindControl("txtDescriptionEdit") as TextBox).Text;
            decimal amount = Convert.ToDecimal((row.FindControl("txtAmountEdit") as TextBox).Text);
            string type = (row.FindControl("ddlTypeEdit") as DropDownList).SelectedValue;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Transactions SET Date=@Date, Description=@Description, Amount=@Amount, Type=@Type WHERE Id=@TransactionId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Date", date);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@Amount", amount);
                cmd.Parameters.AddWithValue("@Type", type);
                cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            UpdateFinalAmount();
            gvTransactions.EditIndex = -1;
            LoadTransactions();
        }

        protected void gvTransactions_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int transactionId = Convert.ToInt32(gvTransactions.DataKeys[e.RowIndex].Values[0]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Transactions WHERE Id=@TransactionId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadTransactions();
            UpdateFinalAmount(); // Update final amount after deletion
        }

        protected void gvTransactions_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvTransactions.EditIndex = -1;
            LoadTransactions();
        }

        protected void gvTransactions_Sorting(object sender, GridViewSortEventArgs e)
        {
            // Determine the current sort direction
            string sortDirection = "ASC";
            string previousSortExpression = ViewState["SortExpression"] as string;

            if (previousSortExpression != null)
            {
                if (previousSortExpression == e.SortExpression)
                {
                    sortDirection = ViewState["SortDirection"].ToString() == "ASC" ? "DESC" : "ASC";
                }
            }

            ViewState["SortExpression"] = e.SortExpression;
            ViewState["SortDirection"] = sortDirection;

            LoadTransactions(e.SortExpression, sortDirection, txtSearch.Text); // Load transactions with sorting
        }

        private void LoadChartData()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT c.Name AS Category, SUM(t.Amount) AS TotalAmount FROM Transactions t JOIN Categories c ON t.CategoryId = c.Id GROUP BY c.Name";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                var labels = new System.Collections.Generic.List<string>();
                var data = new System.Collections.Generic.List<decimal>();

                while (reader.Read())
                {
                    labels.Add(reader["Category"].ToString());
                    data.Add(Convert.ToDecimal(reader["TotalAmount"]));
                }

                var chartData = new
                {
                    labels = labels,
                    data = data
                };

                string serializedChartData = JsonSerializer.Serialize(chartData);

                // Register chart data as a startup script to make it accessible in the front-end
                ClientScript.RegisterStartupScript(this.GetType(), "ChartData", $"var chartData = {serializedChartData};", true);
            }
        }

        protected void txtDate_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
