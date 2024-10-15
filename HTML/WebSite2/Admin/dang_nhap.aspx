<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dang_nhap.aspx.cs" Inherits="Admin_dang_nhap" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <h2>quan tri he thong</h2>
        ten dang nhap: <asp:TextBox ID="txt_user" runat="server"></asp:TextBox>
        mat khau: <asp:TextBox ID="txt_pass" runat="server"></asp:TextBox>
        <asp:Button ID="btn_dangnhap" runat="server" Text="dang nhap" />
    </div>
    </form>
</body>
</html>
