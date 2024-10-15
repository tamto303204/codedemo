using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DataAccess;
using System.Data;

/// <summary>
/// Summary description for DAO_QUANG_CAO
/// </summary>
public class DAO_QUANG_CAO : BasePage
{
    public DataSet LIST_QUANGCAO()
    {
        try
        {
            return SqlDataAccess.ExecuteDataset(Connection, "sp_LIST_QUANGCAO", null);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

}