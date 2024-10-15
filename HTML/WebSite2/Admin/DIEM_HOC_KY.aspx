<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin_MasterPage.master" AutoEventWireup="true" CodeFile="DIEM_HOC_KY.aspx.cs" Inherits="Admin_Default3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2 style="text-align:center; text-transform:uppercase;">tra cuu diem thi</h2>
    ten lop:<asp:DropDownList ID="drl_lop" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
        Height="18px" OnSelectedIndexChanged="drl_lop_SelectedIndexChanged" Width="228px">
        <asp:ListItem Selected="True" Value="0">::Lua chon ten lop::</asp:ListItem>
            </asp:DropDownList>
    <br /><br />
    ten mon:<asp:DropDownList ID="drl_monhoc" runat="server" Height="16px" Width="267px"></asp:DropDownList>
    <br /><br />
    <asp:Button ID="btn_tracuu" runat="server" OnClick="btn_tracuu_Click" Text="Tra cuu" />
    <br /><br />
    <asp:Image ID="img_diemthi" runat="server" />
    <br /><br />
    <asp:Label ID="lb_thongbao" runat="server" ForeColor="Red"></asp:Label>
</asp:Content>

