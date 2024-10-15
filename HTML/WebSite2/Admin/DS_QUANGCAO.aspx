<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DS_QUANGCAO.aspx.cs" Inherits="DS_QUANGCAO" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:GridView ID="grv_quangcao" runat="server" BackColor="White" BorderColor="White" BorderStyle="Ridge" BorderWidth="2px" CellPadding="3" CellSpacing="1" GridLines="None" AutoGenerateColumns="False" OnSelectedIndexChanged="grv_quangcao_SelectedIndexChanged">
            <Columns>
                <asp:ImageField HeaderText="Ảnh" DataImageUrlField="Anh" DataImageUrlFormatString="..{0}">
                </asp:ImageField>
                <asp:HyperLinkField DataNavigateUrlFields="Link" DataNavigateUrlFormatString="{0}" DataTextField="Link" DataTextFormatString="{0}" HeaderText="Link" />
                <asp:TemplateField HeaderText="Sửa">
                    <ItemTemplate>
                        <asp:ImageButton ID="ImageButton1" runat="server" Height="167px" ImageUrl="~/img/d.png" Width="382px" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Xóa">
                    <ItemTemplate>
                        <asp:ImageButton ID="ImageButton1" runat="server" Height="42px" ImageUrl="~/img/e.jpg" Width="47px" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="#C6C3C6" ForeColor="Black" />
            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#E7E7FF" />
            <PagerStyle BackColor="#C6C3C6" ForeColor="Black" HorizontalAlign="Right" />
            <RowStyle BackColor="#DEDFDE" ForeColor="Black" />
            <SelectedRowStyle BackColor="#9471DE" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F1F1F1" />
            <SortedAscendingHeaderStyle BackColor="#594B9C" />
            <SortedDescendingCellStyle BackColor="#CAC9C9" />
            <SortedDescendingHeaderStyle BackColor="#33276A" />
        </asp:GridView>
    
    </div>
    </form>
</body>
</html>
