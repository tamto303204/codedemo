using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using DataAccess;

/// <summary>
/// Summary description for DAO_TIN_TUC
/// </summary>
public class DAO_TIN_TUC:BasePage
{
    public void INSERT_NEW(string tieude, string tomtat, string noidung, string hinhanh, int idnhom)
    {
        try
        {
            SqlDataAccess.ExecuteNonQuery(Connection, "sp_INSERT_NEW", 1m);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

    public DataSet NHOM_TIN()
    {
        try
        {
            return SqlDataAccess.ExecuteDataset(Connection, "sp_NHOM_TIN", null);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
    

    public DataSet NHOM_3_TIN(int id_tin)
    {
        try
        {
            return SqlDataAccess.ExecuteDataset(Connection, "sp_NHOM_3_TIN", id_tin);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
    public DataSet NHOM_TIN12()
    {
        try
        {
            return SqlDataAccess.ExecuteDataset(Connection, "sp_LOAI_TIN", null);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
    public DataSet NHOM_1_TIN(int id_nhom)
    {
        try
        {
            return SqlDataAccess.ExecuteDataset(Connection, "sp_NHOM_1_TIN", id_nhom);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

	public DAO_TIN_TUC()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}