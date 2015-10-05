#include <stdio.h>
#include <unistd.h>

#include <mysql++.h>

using namespace::mysqlpp ;

#ifdef __cplusplus
extern "C" {
// IDL include.
#include "export.h"
}
#endif

#define CEDAR_USE_IDL_COPY 1

#include <iostream>
#include <string>
#include <fstream>

using std::string ;
using std::cout ;
using std::endl ;
using std::cerr ;
using std::ofstream ;
using std::ios ;

ofstream dbgstrm( "./cedar_catalog.dbg", ios::trunc ) ;

bool debug=false;
bool use_tcp=false;

#define MYSQL_USER "madrigal"
#define MYSQL_PASSWORD "c3d4r!er"
#define MYSQL_DATABASE "CEDARCATALOG"
#define MYSQL_HOST "localhost"
#define MYSQL_HOME getenv("MYSQL_HOME")
#define MYSQL_UNIX_SOCKET "/tmp/mysql.sock"

extern "C" void toggle_debug()
{
  if(debug)
    dbgstrm<<"setting debug to false"<<endl;
  else
    dbgstrm<<"setting debug to true"<<endl;
  
  debug=!debug;
  
}

unsigned long execute_query(const char *q, Result *res) 
{ 

    try 
    { 
	Connection con ;
	if( use_tcp )
	{
	    if(debug)
	    {
		dbgstrm << "opening connection type TCP/IP" << endl ;
	    }
	    con.connect( MYSQL_DATABASE, MYSQL_HOST, MYSQL_USER,
			 MYSQL_PASSWORD, 3306 ) ;
	}
	else
	{
	    string mysql_socket ;

	    char *mysql_home = MYSQL_HOME ;
	    if( mysql_home )
	    {
		mysql_socket = (string)mysql_home + "/mysql.sock" ;
	    }
	    else
	    {
		mysql_socket = MYSQL_UNIX_SOCKET ;
	    }
	    if(debug)
	    {
		dbgstrm << "opening connection via unix socket" << endl ;
		dbgstrm << "database = " << MYSQL_DATABASE << endl ;
		dbgstrm << "host = " << MYSQL_HOST << endl ;
		dbgstrm << "user = " << MYSQL_USER << endl ;
		dbgstrm << "password = " << MYSQL_PASSWORD << endl ;
		dbgstrm << "unix socket = " << mysql_socket << endl ;
	    }
	    con.connect( MYSQL_DATABASE, MYSQL_HOST, MYSQL_USER,
			 MYSQL_PASSWORD, 0, 0, 5, mysql_socket.c_str() ) ;
	}

      if(debug)
	dbgstrm << "query = " << q << endl ;

      Query query = con.query(); 
      query << q;

      *res= query.store(); 
      
      if(debug)
	dbgstrm<<__FILE__<<":"<<__LINE__<<": query executed successfully"<<endl;

      return 0; 
    
    } 
    catch (BadConversion &er) // handle bad conversions 
    { 
	dbgstrm << "bad conversion" << endl ;
	cerr << "Error: Tried to convert \"" << er.data << "\" to a \"" 
	     << er.type_name << "\"." << endl; 
	return 2 ; 
    } 
    catch (Exception &er) 
    { 
	dbgstrm << "Error: " << er.what() << endl ;
	cerr << "Error: " << er.what() << endl; 
	return 1 ; 
    }
    catch(...)
    {
	dbgstrm << "Unknown exception..." << endl ;
	cerr << "Unknown exception..." << endl ;
	return 3 ;
    }
} 


extern "C" IDL_VPTR load_catalog_query(int argc, IDL_VPTR argv[]) 
{
  
  IDL_VPTR lReturn;
  lReturn = IDL_Gettmp(); // Allocate memory for return variable.
  lReturn->type = IDL_TYP_ULONG;
  lReturn->value.ul = 0ul;
  
  if(argc!=4)
    {
      lReturn->value.ul = 4ul;
      return lReturn;
    }
  
  
  if(argv[0]->type != IDL_TYP_STRING)
    {
      cerr<<__FILE__<<":"<<__LINE__<<" Expected a string as argument 0\n"; 
      lReturn->value.ul = 5ul;
      return lReturn;
    }
  if(argv[1]->type != IDL_TYP_ULONG)
    {
      cerr<<__FILE__<<":"<<__LINE__<<" Expected an unsigned long as argument 1\n"; 
      lReturn->value.ul = 5ul;
      return lReturn;
    }
  if(argv[2]->type != IDL_TYP_ULONG)
    {
      cerr<<__FILE__<<":"<<__LINE__<<" Expected an unsigned long as argument 2\n"; 
      lReturn->value.ul = 5ul;
      return lReturn;
    }
  if(argv[3]->type != IDL_TYP_ULONG)
    {
      cerr<<__FILE__<<":"<<__LINE__<<" Expected an unsigned long as argument 3\n"; 
      lReturn->value.ul = 5ul;
      return lReturn;
    }
  
  char *_q=(char *) argv[0]->value.str.s;

  if (!argv[0]->value.str.s)
    cerr<<__FILE__<<":"<<__LINE__<<" the incoming union is not right!!!\n"; 
      
  if(!_q)
    {
      cerr<<__FILE__<<":"<<__LINE__<<" Null pointer, where is the query???\n"; 
      lReturn->value.ul = 5ul;
      return lReturn;
    }
  
  Result *r=new Result;

  lReturn->value.ul=execute_query(_q,r);

  if(lReturn->value.ul!=0)
    return lReturn;

  argv[1]->value.ul = (IDL_ULONG) r->size();
  argv[2]->value.ul = (IDL_ULONG) r->columns();
  argv[3]->value.ul = (IDL_ULONG) r;
  
  if(debug)
    dbgstrm<<"The results are at: "<<r<<endl;

  return lReturn;
}


extern "C" IDL_VPTR get_cell(int argc, IDL_VPTR argv[])
{
  IDL_VPTR lReturn;
  lReturn = IDL_Gettmp(); // Allocate memory for return variable.
  try
    {
      lReturn->type = IDL_TYP_ULONG;
      lReturn->value.ul = 0ul;
      
      if(argc!=4)
	{
	  lReturn->value.ul = 4ul;
	  return lReturn;
	}
      
      if(argv[0]->type != IDL_TYP_ULONG)
	{
	  cerr<<__FILE__<<":"<<__LINE__<<" Expected an unsigned long as argument 0\n"; 
	  lReturn->value.ul = 5ul;
	  return lReturn;
	}
      if(argv[1]->type != IDL_TYP_ULONG)
	{
	  cerr<<__FILE__<<":"<<__LINE__<<" Expected an unsigned long as argument 1\n"; 
	  lReturn->value.ul = 5ul;
	  return lReturn;
	}
      if(argv[2]->type != IDL_TYP_ULONG)
	{
	  cerr<<__FILE__<<":"<<__LINE__<<" Expected an unsigned long as argument 2\n"; 
	  lReturn->value.ul = 5ul;
	  return lReturn;
	}
      if(argv[3]->type != IDL_TYP_STRING)
	{
	  cerr<<__FILE__<<":"<<__LINE__<<" Expected an string as argument 3\n"; 
	  lReturn->value.ul = 5ul;
	  return lReturn;
	}
      
      IDL_VPTR temp_string;
      
      string *str = new string ;
      
      
      Result *res= (Result *) argv[0]->value.ul;
      
      if(!res)
	{
	  cerr<<__FILE__<<":"<<__LINE__<<" Null pointer???\n"; 
	  lReturn->value.ul = 5ul;
	  return lReturn;
	}
      
      if(debug)
	dbgstrm<<"Result pointer is: "<<res<<endl;
      
      int access_row=argv[1]->value.ul;
      int access_column=argv[2]->value.ul;
      
      if(debug)
	dbgstrm<<"Requested row, column: "<<access_row<<", "<<access_column<<endl;
      
      Result::iterator i;
      
      if(debug)
	{
	  dbgstrm<<"Using the incoming pointer statistics are: "<<endl;
	  dbgstrm<<"Number of rows: "<<res->size()<<endl;
	  dbgstrm<<"Number of columns: "<<res->columns()<<endl;
	}
      
      if(access_row<res->size())
	{
	  i = res->begin();
	  for (int p=0; p<access_row; p++)
	    i++;
	}
      else
	{
	  // row beyond the result set
	  lReturn->value.ul = 1ul;
	  return lReturn;
	}
      
      Row row; 
      row = *i;
      
      if (access_column < res->columns())
	*str = (const char *)row.at(access_column);
      else
	{
	  // column beyond the row number of fields
	  lReturn->value.ul = 2ul;
	  return lReturn;
	}
      
      if(debug)
	dbgstrm<<"The requested cell is: "<<*str<<endl;
      
      
#ifdef CEDAR_USE_IDL_COPY    
      temp_string = IDL_Gettmp();
      temp_string->type = IDL_TYP_STRING;
      temp_string->value.str.slen = str->length();
      temp_string->value.str.stype = 0;
      temp_string->value.str.s = (char *) str->c_str();
      IDL_VarCopy(temp_string, argv[3]);
#else
      argv[3]->value.str.slen=str.length();
      argv[3]->value.str.s=new char [str.length()];
      strcpy(argv[3]->value.str.s,str.c_str());
      argv[3]->value.str.stype = 0;
#endif
      
      
      return lReturn;
    }
  catch(...)
    {
      lReturn->value.ul=3ul;
      return lReturn;
    }
}

extern "C" IDL_VPTR destroy_result_set(int argc, IDL_VPTR argv[])
{
  IDL_VPTR lReturn;
  lReturn = IDL_Gettmp(); // Allocate memory for return variable.
  lReturn->type = IDL_TYP_ULONG;
  lReturn->value.ul = 0ul;

  if(argc!=1)
    {
      lReturn->value.ul = 1ul;
      return lReturn;
    }
  
  if(argv[0]->type != IDL_TYP_ULONG)
    {
      cerr<<__FILE__<<":"<<__LINE__<<" Expected an unsigned long as argument 0\n"; 
      lReturn->value.ul = 2ul;
      return lReturn;
    }
  
  Result *res= (Result *) argv[0]->value.ul;

  if(!res)
    {
      lReturn->value.ul = 3ul;
      return lReturn;
    }
  
  if(debug)
    dbgstrm<<"Destroying results at: "<<res<<endl;

  // Destroy it
  delete res;
  
  return lReturn;
}
