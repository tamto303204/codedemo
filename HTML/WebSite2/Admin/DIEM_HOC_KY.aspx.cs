using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataAccess;
using System.Data;

public partial class Admin_Default3 : System.Web.UI.Page
{
    DIEM_HOC_KY DIEM_HOC_KY = new DIEM_HOC_KY();
    protected void HienThiLop()
    {
        DataSet ds;
        ds = DIEM_HOC_KY.DANHSACH_LOP();
        drl_lop.DataSource = ds;
        drl_lop.DataTextField = "Ten_Lop";
        drl_lop.DataValueField = "ID_Lop";
        drl_lop.DataBind();
        ds.Tables.Clear();
        ds.Clear();
    }
    protected void btn_tracuu_Click(object sender, EventArgs e)
    {
        int idlop = Convert.ToInt32(drl_lop.SelectedValue.ToString());
        int idmon = Convert.ToInt32(drl_monhoc.SelectedValue.ToString());
        DataSet ds;
        ds = DIEM_HOC_KY.DIEM_HP(idlop, idmon);
        if(ds.Tables[0].Rows.Count>0)
        {
            img_diemthi.ImageUrl=ds.Tables[0].Rows
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!Page.IsPostBack)
        {
            HienThiLop();
        }
    }
    
}