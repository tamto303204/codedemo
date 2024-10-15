using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using DataAccess;

/// <summary>
/// Summary description for _10_4
/// </summary>
public class DIEM_HOC_KY:BasePage
{
    public DataSet DIEM_HP(int idmon, int idlop)
    {
        return SqlDataAccess.ExecuteDataset(Connection, "sp_DIEM_HP", idmon, idlop);
    }
    public DataSet DANHSACH_LOP()
    {
        return SqlDataAccess.ExecuteDataset(Connection, "sp_DANHSACH_LOP", null);
    }
    public DataSet DS_MON_THEO_LOP(int idlop)
    {
        return SqlDataAccess.ExecuteDataset(Connection, "sp_DS_MON_THEO_LOP",   idlop);
    }
	public _10_4()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}