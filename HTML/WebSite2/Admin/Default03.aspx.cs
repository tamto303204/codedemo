using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataAccess;
using System.Data;

public partial class Admin_Default03 : System.Web.UI.Page
{
    Default03 Default03 = new Default03();
    protected void Hienthi()
    {
        DataSet ds;
        try
        {
            ds = Default03.ANH_QC();
            dl_quangcao.DataSource = ds;
            dl_quangcao.DataBind();
            ds.Tables.Clear();
            ds.Clear();

        }
        catch (Exception ex)
        {

            throw ex;
        }

        finally
        {
            ds = null;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Hienthi();
    }
}