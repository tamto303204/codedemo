<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin_MasterPage.master" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Admin_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:DataList ID="dl_nhomtinmoi" runat="server" Width="939px" CellPadding="4" ForeColor="#333333">
                <ItemTemplate>
                <%--Bảng ở đây --%>
     <table border="0" cellpadding="0" cellspacing="0" width="100%">
     <tr>
     <td class="nhom" colspan="3" style="background-image: url(images/TITLE1.jpg); width: 425px; background-repeat:no-repeat;
                                height: 16px; " valign="middle">
        <span style="color:black; margin-left:10px; padding-bottom:3px;">
             <strong><%#Eval("TenNhomtin") %></strong>
                                        </span>
         </td>
          <td colspan="1" style="height: 16px">
          </td>
          </tr>
          <tr>
            <td colspan="3" style="height: 151px; width: 100%;">
              <asp:DataList ID="dl_tinmoi" runat="server" Width="99%" RepeatColumns="2" RepeatDirection="Horizontal">
                <ItemTemplate>
                   <table style="width: 100%">
                      <tr>
                       <td class="ls_text1" colspan="3" rowspan="3" style="text-align: right; width:100%" >
                      <div style="display: table; text-align: justify; width:100%;" align="left"><span style="font-size:10px;">
                          <%#Eval("NgayDang") %></em></span><br />
                          <img alt="" src='<%#Eval("Anh") %>' style="margin-right: 16px; margin-top:10px; width: 180px; height: 135px;" align="left" hspace="0" vspace="0">
			       <a href='Chitiettin.aspx?idtin=<%#Eval("Id_Tin") %>'>
	                     <strong ><%#Eval("TenTin") %></strong></span></a><br>
	               <br style="line-height: 2px; color:Black;"><%#Eval("Tomtat") %>
                                                        
                        </div>
             <a style="color:black" href='Chitiettin.aspx?idtin=<%#Eval("Id_Tin") %>'>Xem tiếp...</a></td>
             </tr>
      <tr>
      </tr>
      <tr>
      </tr>
      </table> 
      </ItemTemplate>
      </asp:DataList>
                             </td>                            
                        </tr>
                        
                        <tr>
                            <td colspan="3" style="text-decoration: none; width: 485px; text-align: left;">
                                 ---------------------------------------------<br />
                                <asp:DataList ID="dl_tincungloai" runat="server" Width="485px">
                                    <ItemTemplate>
                                        <a href='Chitiettin.aspx?idtin=<%#Eval ("Id_Tin") %>'>
                                      <em><span style=" font-family:Times New Roman; font-size:14px; text-decoration:none; text-align:left;"><%#Eval("TenTin") %></span></em>
                                        </a>
                                    </ItemTemplate>
                                </asp:DataList></td>
                        </tr>
                        <tr>
                            <td>
                                
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:DataList>

</asp:Content>

