using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
/// <summary>
/// Summary description for BasePage
/// </summary>
public class BasePage
{
    public string Connection = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
	public BasePage()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}