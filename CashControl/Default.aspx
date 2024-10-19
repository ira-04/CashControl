<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PersonalFinanceManager.Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Personal Finance Manager</title>
    <link rel="stylesheet" type="text/css" href="styles.css" />
</head>
<body>
    <div>
    <form id="form1" runat="server">
        <div>
            <h2 class="title">Personal Finance Manager</h2>

            <div class="form-field">
                <asp:Label ID="lblDate" runat="server" Text="Date:"></asp:Label>
                <asp:TextBox ID="txtDate" runat="server" TextMode="Date" OnTextChanged="txtDate_TextChanged"></asp:TextBox>
            </div>

            <div class="form-field">
                <asp:Label ID="lblDescription" runat="server" Text="Description:"></asp:Label>
                <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
            </div>

            <div class="form-field">
                <asp:Label ID="lblAmount" runat="server" Text="Amount:"></asp:Label>
                <asp:TextBox ID="txtAmount" runat="server"></asp:TextBox>
            </div>

            <div class="form-field">
                <asp:Label ID="lblType" runat="server" Text="Type:"></asp:Label>
                <asp:DropDownList ID="ddlType" runat="server">
                    <asp:ListItem Text="Income" Value="Income"></asp:ListItem>
                    <asp:ListItem Text="Expense" Value="Expense"></asp:ListItem>
                </asp:DropDownList>
            </div>
            
            <div class="form-field">
                <asp:Label ID="lblCategory" runat="server" Text="Category:"></asp:Label>
                <asp:DropDownList ID="ddlCategory" runat="server"></asp:DropDownList>
            </div>

            <asp:Button ID="btnAdd" runat="server" Text="Add Transaction" OnClick="btnAddTransaction_Click" CssClass="btn-add"/><br /><br />

            <!-- Error message label -->
            <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label><br /><br />

            <!-- Label for displaying the final amount -->
            <asp:Label ID="lblFinalAmount" runat="server" CssClass="final-amount"></asp:Label><br /><br />


    </div>
            <!-- Search and Sort functionality -->
            <div class="search-sort-container">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" placeholder="Search transactions..." OnTextChanged="txtSearch_TextChanged" AutoPostBack="True" />
                <asp:Button ID="btnFind" runat="server" Text="Find" OnClick="btnFind_Click" CssClass="btn-find" />
            </div>
            <br /><br />

            <asp:Button ID="btnExport" runat="server" Text="Export to CSV" OnClick="btnExport_Click" CssClass="btn-export" />

            <!-- GridView for transactions -->
            <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                OnRowEditing="gvTransactions_RowEditing" OnRowUpdating="gvTransactions_RowUpdating" 
                OnRowDeleting="gvTransactions_RowDeleting" OnRowCancelingEdit="gvTransactions_RowCancelingEdit"
                OnSorting="gvTransactions_Sorting" AllowSorting="True" CssClass="table">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" Visible="false" />
                    <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date" />
                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" SortExpression="Amount" />
                    <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" SortExpression="CategoryName" />

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Text="Edit" CssClass="btn-edit"/>
                            <asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" CssClass="btn-delete" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtDateEdit" runat="server" Text='<%# Bind("Date", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="edit-input"  />
                            <asp:TextBox ID="txtDescriptionEdit" runat="server" Text='<%# Bind("Description") %>' CssClass="edit-input"  />
                            <asp:TextBox ID="txtAmountEdit" runat="server" Text='<%# Bind("Amount") %>'  CssClass="edit-input" />
                            <asp:DropDownList ID="ddlTypeEdit" runat="server">
                                <asp:ListItem Text="Income" Value="Income"></asp:ListItem>
                                <asp:ListItem Text="Expense" Value="Expense"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" Text="Update" CssClass="btn-update" />
                            <asp:LinkButton ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" CssClass="btn-cancel" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

            <asp:Label ID="lblNoResults" runat="server" CssClass="error-message" Visible="false"></asp:Label> <!-- Message for no results -->
            <div style = "margin-top:50px;">
                 <asp:HyperLink ID="lnkVisualPage" runat="server" NavigateUrl="~/Visual.aspx" CssClass="btn-chart">View Chart</asp:HyperLink>
            </div>
        </div>
    </form>
    <br/>
    <br/>
    <br/>
    <br/>
</body>
</html>
