using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DataAccess;
using System.Data;

/// <summary>
/// Summary description for _13_3
/// </summary>
public class _13_3:BasePage
{
    public DataSet check_TK(string tendn ,string mk)
    {
        try
        {
            return SqlDataAccess.ExecuteDataset(Connection, "sp_check_tk", tendn);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
	public _13_3()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}