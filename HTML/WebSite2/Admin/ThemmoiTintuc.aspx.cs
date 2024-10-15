using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DataAccess;

public partial class Admin_Default : System.Web.UI.Page
{
     DAO_TIN_TUC DAO_TIN_TUC = new DAO_TIN_TUC();
    protected void Page_Load(object sender, EventArgs e)
    
    {
        DataSet ds;
        try
        {
            ds = DAO_TIN_TUC.NHOM_TIN();
            DRLNTin.DataSource = ds;
            DRLNTin.DataTextField = "TennhomTin";
            DRLNTin.DataValueField = "ID_nhomTin";
            DRLNTin.DataBind();
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

    

    
    
}
