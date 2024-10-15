using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataAccess;
using System.Data;

public partial class Admin_Default2 : System.Web.UI.Page
{
    DAO_TIN_TUC DAO_TIN_TUC = new DAO_TIN_TUC();

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
            ds = DAO_TIN_TUC.NHOM_TIN12();
            
            
            dl_nhomtinmoi.DataSource = ds;
            dl_nhomtinmoi.DataBind();

            
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

    protected void dl_nhomtinmoi_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        DataRowView r = (DataRowView)e.Item.DataItem;
        int idtin = Convert.ToInt32(r["Id_Nhomtin"].ToString());
        DataSet ds1; DataSet ds2;
        if (idtin > 0)
        {
            try
            {
                ds1 = DAO_TIN_TUC.NHOM_3_TIN(idtin);
                ((DataList)e.Item.FindControl("dl_tincungloai")).DataSource = ds1;
                ((DataList)e.Item.FindControl("dl_tincungloai")).DataBind();
                ds1.Tables[0].Rows[0].Delete();
                ds1.Tables[0].Rows[1].Delete();

                ds2 = DAO_TIN_TUC.NHOM_1_TIN(idtin);
                ((DataList)e.Item.FindControl("dl_tinmoi")).DataSource = ds2;
                ((DataList)e.Item.FindControl("dl_tinmoi")).DataBind();
                ds1.Tables.Clear();
                ds1.Clear();
                ds2.Tables.Clear();
                ds2.Clear();
            }
            catch (Exception ex)
            {
                
                throw ex;
            }
            finally
            {
                ds1 = null;
                ds2 = null;
            }

        }
    }

    
}