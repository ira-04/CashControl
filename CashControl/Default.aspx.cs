using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PersonalFinanceManager
{
    public partial class Default : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["FinanceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTransactions();
                LoadCategories();
                UpdateFinalAmount(); // Update final amount when the page loads
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

        private void LoadTransactions()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT t.*, c.Name AS CategoryName FROM Transactions t INNER JOIN Categories c ON t.CategoryId = c.Id";
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }

        protected void gvTransactions_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvTransactions.EditIndex = e.NewEditIndex;
            LoadTransactions();
        }

        protected void gvTransactions_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Get the ID of the row being updated
            int id = Convert.ToInt32(gvTransactions.DataKeys[e.RowIndex].Value);

            // Retrieve updated values from the GridView controls
            GridViewRow row = gvTransactions.Rows[e.RowIndex];
            TextBox txtDate = (TextBox)row.FindControl("txtDateEdit");  // Date cell
            TextBox txtDescription = (TextBox)row.FindControl("txtDescriptionEdit");  // Description cell
            TextBox txtAmount = (TextBox)row.FindControl("txtAmountEdit");  // Amount cell
            DropDownList ddlType = (DropDownList)row.FindControl("ddlTypeEdit");  // Type dropdown in edit mode

            if (txtDate != null && txtDescription != null && txtAmount != null && ddlType != null)
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Determine the amount based on the type
                    decimal amount = decimal.Parse(txtAmount.Text);
                    string type = ddlType.SelectedValue;

                    // Adjust amount based on type (Expense or Income)
                    if (type == "Expense")
                    {
                        amount = -Math.Abs(amount); // Make amount negative for expenses
                    }
                    else
                    {
                        amount = Math.Abs(amount); // Ensure amount is positive for income
                    }

                    string query = "UPDATE Transactions SET Date = @Date, Description = @Description, Amount = @Amount, Type = @Type WHERE Id = @Id";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Date", DateTime.Parse(txtDate.Text));
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Type", type);
                    cmd.Parameters.AddWithValue("@Id", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvTransactions.EditIndex = -1;
            LoadTransactions();
            UpdateFinalAmount(); // Update final amount after a transaction is updated
        }


        protected void gvTransactions_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvTransactions.DataKeys[e.RowIndex].Value);
            DeleteTransaction(id);
            LoadTransactions();
            UpdateFinalAmount();
        }

        protected void gvTransactions_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvTransactions.EditIndex = -1;
            LoadTransactions();
        }

        private void DeleteTransaction(int id)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Transactions WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", id);
                con.Open();
                cmd.ExecuteNonQuery();
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

        private void UpdateFinalAmount()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT SUM(Amount) FROM Transactions";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != DBNull.Value)
                {
                    decimal finalAmount = Convert.ToDecimal(result);
                    lblFinalAmount.Text = "Total Balance: " + finalAmount.ToString("C");
                }
            }
        }
    }
}
