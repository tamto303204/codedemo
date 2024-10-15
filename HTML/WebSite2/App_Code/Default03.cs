using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DataAccess;
using System.Data;

/// <summary>
/// Summary description for Admin_Default03
/// </summary>
public class Default03:BasePage
{
    public DataSet ANH_QC()
    {
        try
        {
            return SqlDataAccess.ExecuteDataset(Connection, "sp_ANH_QUANG_CAO", null);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

	public Default03()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}