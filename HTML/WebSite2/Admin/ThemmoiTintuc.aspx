<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin_MasterPage.master" AutoEventWireup="true" CodeFile="ThemmoiTintuc.aspx.cs" Inherits="Admin_Default" %><%@ Register assembly="FreeTextBox" namespace="FreeTextBoxControls" tagprefix="FTB" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
    .auto-style5 {
        width: 323px;
    }
    .auto-style6 {
        width: 323px;
        height: 26px;
    }
    .auto-style7 {
        height: 26px;
    }
    .auto-style8 {
        width: 383px;
    }
    .auto-style9 {
        height: 26px;
        width: 383px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table style="width: 100%;">
    <tr>
        <td class="auto-style5">THEM MOI TIN TUC</td>
        <td class="auto-style8">&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style6"></td>
        <td class="auto-style9"></td>
        <td class="auto-style7"></td>
    </tr>
    <tr>
        <td class="auto-style5">lua chon nhom tin</td>
        <td class="auto-style8">
            <asp:DropDownList ID="DRLNTin" runat="server" Width="267px" >
            </asp:DropDownList>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style5">Ten tin</td>
        <td class="auto-style8">
            <asp:TextBox ID="Txt_Name" runat="server" Width="356px"></asp:TextBox>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style5">Anh dai dien</td>
        <td class="auto-style8">
            <asp:FileUpload ID="Ful_Anh" runat="server" Width="371px" />
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style5">tom tat</td>
        <td class="auto-style8">
            <FTB:FreeTextBox ID="ftb_tomtat" runat="server">
            </FTB:FreeTextBox>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style6">noi dung</td>
        <td class="auto-style9">
            <FTB:FreeTextBox ID="ftb_noidung" runat="server">
            </FTB:FreeTextBox>
        </td>
        <td class="auto-style7"></td>
    </tr>
    <tr>
        <td class="auto-style5">&nbsp;</td>
        <td class="auto-style8">&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style5">&nbsp;</td>
        <td class="auto-style8">&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style5">&nbsp;</td>
        <td class="auto-style8">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
        <td>&nbsp;</td>
    </tr>
</table>
</asp:Content>

