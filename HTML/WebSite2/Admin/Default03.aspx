<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default03.aspx.cs" Inherits="Admin_Default03" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../css/Style.css" rel="stylesheet" />
</head>
<body>

    <form id="form1" runat="server">
    <div>
    <div class="grid">
  <header class="page-header">
    <div class="content">
      <p>Header</p>
    </div>
  </header>
  <aside class="page-rightbar">
    <div class="content">
      <p>
          <asp:DataList ID="dl_quangcao" runat="server" style="margin-right: 0px" Width="974px" CellPadding="4" ForeColor="#333333" DataKeyField="ID_QC">
                    <AlternatingItemStyle BackColor="White" />
                    <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                    <ItemStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <ItemTemplate>
            <a href='<%#Eval("Link") %>' >
            <td rowspan="2" class="auto-style19">
                <img alt="" src='<%#Eval("Anh") %>' style="margin-right:15px; margin-top:10px;
                                width:180px; height:135px;" align:"left" hspace:"0" vspace:"" /></td>
            </a>
        </ItemTemplate>

                    <SelectedItemStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
    </asp:DataList>
      </p>
    </div>
  </aside>
  <main class="page-main">
    <div class="content">
      <p>Main</p>
    </div>
  </main>
  <footer class="page-footer">
    <div class="content">
      <p>Footer</p>
    </div>
  </footer>
</div>
    </div>
    </form>
</body>
</html>
