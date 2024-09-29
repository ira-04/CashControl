﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PersonalFinanceManager.Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Personal Finance Manager</title>
    <link rel="stylesheet" type="text/css" href="styles.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2 class="title">Personal Finance Manager</h2>

            <div class="form-field">
                <asp:Label ID="lblDate" runat="server" Text="Date:"></asp:Label>
                <asp:TextBox ID="txtDate" runat="server" TextMode="Date"></asp:TextBox>
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

            <asp:Button ID="btnAdd" runat="server" Text="Add Transaction" OnClick="btnAddTransaction_Click" /><br /><br />

            <!-- Error message label -->
            <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label><br /><br />

            <!-- Label for displaying the final amount -->
            <asp:Label ID="lblFinalAmount" runat="server" CssClass="final-amount"></asp:Label><br /><br />

            <!-- GridView for transactions -->
            <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                OnRowEditing="gvTransactions_RowEditing" OnRowUpdating="gvTransactions_RowUpdating" 
                OnRowDeleting="gvTransactions_RowDeleting" OnRowCancelingEdit="gvTransactions_RowCancelingEdit">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" Visible="false" />
                    <asp:BoundField DataField="Date" HeaderText="Date" />
                    <asp:BoundField DataField="Description" HeaderText="Description" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="Type" HeaderText="Type" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" />

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtDateEdit" runat="server" Text='<%# Bind("Date", "{0:yyyy-MM-dd}") %>' TextMode="Date" />
                            <asp:TextBox ID="txtDescriptionEdit" runat="server" Text='<%# Bind("Description") %>' />
                            <asp:TextBox ID="txtAmountEdit" runat="server" Text='<%# Bind("Amount") %>' />
                            <asp:DropDownList ID="ddlTypeEdit" runat="server">
                                <asp:ListItem Text="Income" Value="Income"></asp:ListItem>
                                <asp:ListItem Text="Expense" Value="Expense"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
                            <asp:LinkButton ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ShowDeleteButton="True" />
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
