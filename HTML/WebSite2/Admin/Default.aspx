<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin_MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Admin_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:DataList ID="dl_tinmoinhat" runat="server">
        <ItemTemplate>
            <div style="display:table; text-align:justify; width=100%;" align="left">
                <span style="font-size:10px;">
                    <em><%#Eval("Ngay dang") %></em>
                </span>
                <br />
                <img alt="" src='<%#Eval("Anh") %>' style="margin-right:15px; margin-top:10px;
                                width:180px; height:135px;" align="left" hspace="0" vspace="" />
                <span style="color:blue; font-size:20px">
                    <strong> <%#Eval("Ten tin") %></strong>
                </span><br />
                <br style="line-height:2px; color:black;" />
                <%#Eval("Tom tat") %>
            </div>
            <span style="margin-left: 450px"> xem tiep....</span>
        </ItemTemplate>
    </asp:DataList>
</asp:Content>

