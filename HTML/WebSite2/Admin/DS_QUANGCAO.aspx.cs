using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataAccess;
using System.Web.Configuration;
using System.Data;

public partial class DS_QUANGCAO : System.Web.UI.Page
{
    DAO_QUANG_CAO DAO_QUANG_CAO = new DAO_QUANG_CAO();
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            Hienthi();
        }
    }
    protected void Hienthi()
    {
        DataSet ds;
        try
        {
            ds = DAO_QUANG_CAO.LIST_QUANGCAO();
            grv_quangcao.DataSource = ds;
            grv_quangcao.DataBind();
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
    protected void grv_quangcao_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}

    
