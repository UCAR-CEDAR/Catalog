#include <sys/types.h>
#include <sys/stat.h>

#include <string>
#include <iostream>
#include <vector>

using std::string ;
using std::cerr ;
using std::cout ;
using std::endl ;
using std::vector ;
using std::ostream ;
using std::ios ;

#include "CedarFile.h"
#include "CedarVersion.h"
#include "CedarValidDate.h"
#include "CedarArray.cc"
#include "CedarException.h"
#include "CedarRecordType.h"
#include "CedarDataRecord.h"

#define FILE_DELIMITER "/"
#define CEDARINVENTORY_VERSION ": version 1.6.2"

string program_name ;
bool debug = false ;
bool debug_created = false ;
string debugfile ;
ostream *dstrm = 0 ;
string cedar_file ;

void
usage()
{
    cerr << program_name << " - Takes a CEDAR/Madrigal file, parses it, and"
         << " enters the appropriate data into the CEDAR MySQL Database"
	 << endl ;
    cerr << program_name << " [-d filename] -v | -V | filename" << endl ;
    cerr << endl << "-d filename - send debug output to the specified"
         << " filename, cerr to send to stderr" << endl ;
    cerr << "-v - version" << endl ;
    cerr << "-V - detailed version information" << endl ;
    cerr << "filename - the file to read" << endl ;
}

void
cleanup()
{
    if( dstrm && debug_created )
    {
	delete dstrm ;
	dstrm = 0 ;
	debug_created = false ;
    }
}

class name_path
{
    string _my;
public:
    string get_file_name( string &path )
    {
        if( path.empty() )
	{
            _my = "" ;
	}
	else
	{
	    int slash_place = path.rfind( FILE_DELIMITER ) ;
	    int dot_place = path.rfind( "." ) ;
	    _my = string( path,slash_place+1,dot_place-slash_place-1 ) ;
	}
	return _my ;
    }
};

static int nrecords = 0 ;

typedef unsigned short int CEDARDB_date_type ;

class CEDARDB_date
{
    CEDARDB_date_type my_year ;
    CEDARDB_date_type my_month ;
    CEDARDB_date_type my_day ;
public:
    CEDARDB_date()
    {
	my_year = 1950;
	my_month = 1 ;
	my_day = 1 ;
    }
    CEDARDB_date( CEDARDB_date_type year,
                  CEDARDB_date_type month,
		  CEDARDB_date_type day )
    {
	my_year =year ;
	my_month = month ;
	my_day = day ;
    }
    int operator==( const CEDARDB_date &x ) ;
    CEDARDB_date_type get_year() { return my_year ; }
    CEDARDB_date_type get_month() { return my_month ; }
    CEDARDB_date_type get_day(){ return my_day ; }
    int operator<=( CEDARDB_date &dt ) ;
    CEDARDB_date operator++( int x ) ;
} ;


int CEDARDB_date::operator<=( CEDARDB_date &dt )
{
    if( my_year < dt.my_year ) return 1 ;
    else
    {
	if( my_year > dt.my_year ) return 0 ;
	else //same year
	{
	    if( my_month < dt.my_month ) return 1 ;
	    else
	    {
		if( my_month > dt.my_month ) return 0 ;
		else //same month
		{
		    if( my_day < dt.my_day ) return 1 ;
		    else
		    {
			if( my_day > dt.my_day ) return 0 ;
			else //same day
			{
			    return 1 ;
			}
		    }
		}
	    }
	}
    }
}

CEDARDB_date CEDARDB_date::operator++(int x)
{
    if( ( my_month == 1 ) || ( my_month == 3 ) || ( my_month == 5 )
        || ( my_month == 7 ) || ( my_month == 8 ) || ( my_month == 10 )
	|| ( my_month == 12 ) )
    {
	if( my_day < 31 )
	{
	    my_day++ ;
	    return *this ;
	}
	else // Last day of December
	{
	    my_day=1;
	    if( my_month < 12 )
		my_month++ ;
	    else
	    {
		my_month = 1 ;
		my_year++ ;
	    }
	    return *this ;
	}
    }
    else if( ( my_month == 4 ) || ( my_month == 6 )
             || ( my_month == 9 ) || ( my_month == 11 ) )
    {
	if(my_day<30)
	{
	    my_day++ ;
	    return *this ;
	}
	else 
	{
	    my_day = 1 ;
	    my_month++ ;
	    return *this ;
	}
    }
    else if( my_month == 2 )
    {
	if( CedarValidDate::is_leap_year( my_year ) )
	{
	    if( my_day < 29 )
	    {
		my_day++ ;
		return *this ;
	    }
	    else 
	    {
		my_day = 1 ;
		my_month++ ;
		return *this ;
	    }
	}
	else
	{
	    if( my_day < 28 )
	    {
		my_day++ ;
		return *this ;
	    }
	    else 
	    {
		my_day = 1 ;
		my_month++ ;
		return *this ;
	    }
	}
    }
}

int CEDARDB_date::operator==( const CEDARDB_date &x )
{
    if( ( my_year == x.my_year ) && ( my_month == x.my_month )
        && ( my_day == x.my_day ) )
	return 1 ;
    else
	return 0 ;
}

class record_type
{
    field my_kinst ;
    field my_kindat ;
public:
    record_type() { my_kinst = 0; my_kindat = 0 ; }
    record_type( field ki, field kd ) ;
    int operator==( const record_type &x ) ;
    field get_kindat() { return my_kindat ; }
    field get_kinst() { return my_kinst ; }
} ;

record_type::record_type( field ki, field kd )
{
    my_kinst = ki ;
    my_kindat = kd ;
}

int record_type::operator==( const record_type &x )
{
    if( ( my_kinst == x.my_kinst ) && ( my_kindat == x.my_kindat ) )
	return 1 ;
    else
	return 0 ;
}

template class CedarArray<record_type> ;
template class CedarArray<CEDARDB_date> ;

//Functions declarations
void update_number_of_records( string &filename ) ;
void get_record_type_data( CedarDataRecord *cdr ) ;
void get_file_data( string &filename ) ;
int get_records_in_this_file( string &filename ) ;
void load_date_info( CedarDataRecord *cdr ) ;
int get_dates_in_this_file( string &filename ) ;
void check_first_last( CedarDataRecord *cdr, string &filename ) ;
void write_header( string &filename ) ;
void deal_with_record( const CedarLogicalRecord *clr ) ;

// Globals
struct record_type_dates_TAG
{
    CEDARDB_date date ;
    int kinst ;
    int kindat ;
} ;
typedef record_type_dates_TAG record_type_dates ;

static CedarArray<record_type>reg( 1, 0 ) ;
static CedarArray<record_type_dates>dates( 1, 0 ) ;

int main(int argc, char *argv[])
{
    program_name = argv[0] ;

    // should have at least 1 argument, and possibly 3 arguments
    // not including the program name
    if( argc < 2 || argc > 5 )
    {
	cerr << "Too few or too many arguments specified" << endl ;
	usage() ;
        return 1;
    }

    // check arguments for -v (version), -V (verbose version),
    // -d (debug), -c (no checksum)
    int currarg = 1 ;
    int checksum = CEDAR_DO_CHECK_SUM ;
    bool done = false ;
    while( !done )
    {
	if( !strcmp( argv[currarg], "-v" ) )
	{
	    cout << program_name << CEDARINVENTORY_VERSION << endl ;
	    cleanup() ;
	    exit( 0 ) ;
	}
	else if( !strcmp( argv[currarg], "-V" ) )
	{
	    cout << program_name << CEDARINVENTORY_VERSION << endl ;
	    cout << "Cedar: " << CedarVersion::get_version_number() << endl ;
	    string str = CedarVersion::get_version_info() ;
	    cout << str << endl ;
	    cleanup() ;
	    exit( 0 ) ;
	}
	else if( !strcmp( argv[currarg], "-c" ) )
	{
	    checksum = 0 ;
	    currarg++ ;
	}
	else if( !strcmp( argv[currarg], "-d" ) )
	{
	    currarg++ ;
	    if( !argv[currarg] )
	    {
		cerr << "No debug file was specified" << endl ;
		usage() ;
		return 1 ;
	    }
	    if( argv[currarg][0] == '-' )
	    {
		cerr << "No debug file was specified" << endl ;
		usage() ;
		return 1 ;
	    }
	    debugfile = argv[currarg] ;
	    debug = true ;
	    currarg++ ;
	}
	else
	{
	    done = true ;
	}
    }

    // get the debug stream set up if there is one
    if( debug )
    {
	if( debugfile == "cerr" )
	{
	    dstrm = &cerr ;
	    debug_created = false ;
	}
	else
	{
	    dstrm = new ofstream( debugfile.c_str(), ios::out|ios::app ) ;
	    debug_created = true ;
	    if( !dstrm )
	    {
		cerr << "Unable to open the debug file" << endl ;
		usage() ;
		return 1 ;
	    }
	}
    }

    if( !argv[currarg] )
    {
	cerr << "No Cedar or Madrigal file was specified" << endl ;
	usage() ;
	cleanup() ;
	return 1 ;
    }

    cedar_file = argv[currarg] ;

    if( cedar_file.length() < 5 )
    {
	cerr << cedar_file << " is not a valid file name" << endl ;
	usage() ;
	cleanup() ;
	return 1 ;
    }

    if( dstrm ) (*dstrm) << endl << "working on " << cedar_file ;

    try
    {
        CedarFile file( checksum ) ;
        time_t t1 = time( NULL ) ;
	if( dstrm ) (*dstrm) << "  opening " << cedar_file << endl ;
        file.open_file( cedar_file.c_str() ) ;
	if( dstrm ) (*dstrm) << "  getting first logical record for "
	                     << cedar_file << endl ;
        const CedarLogicalRecord *p = file.get_first_logical_record() ;
        if( p )
	{
	    if( dstrm ) (*dstrm) << "  writing header for "
	                         << cedar_file << endl ;
	    write_header( cedar_file ) ;
	    if( dstrm ) (*dstrm) << "  getting the file data for "
	                         << cedar_file << endl ;
	    get_file_data( cedar_file ) ;
	    if( dstrm ) (*dstrm) << "  dealing with records "
	                         << cedar_file << endl ;
	    deal_with_record( p ) ;
	    while( p = file.get_next_logical_record() )
	        deal_with_record( p ) ;

	    if( dstrm ) (*dstrm) << "  get the records for "
	                         << cedar_file << endl ;
	    get_records_in_this_file( cedar_file ) ;
	    if( dstrm ) (*dstrm) << "  get the dates for "
	                         << cedar_file << endl ;
	    get_dates_in_this_file( cedar_file ) ;
	    if( dstrm ) (*dstrm) << "  get the number of records for "
	                         << cedar_file << endl ;
	    update_number_of_records( cedar_file ) ;
	    name_path pf ;
	    string filename = pf.get_file_name( cedar_file ) ;
	    if( dstrm ) (*dstrm) << "  get first last for "
	                         << cedar_file << endl ;
	    check_first_last( 0, filename ) ;
	    time_t t2 = time( NULL ) ;
	    cout << endl << "# Total process time " << t2 - t1 << " sec."
	         << endl ;
	    if( dstrm ) (*dstrm) << endl << "  # Total process time "
	                         << t2 - t1 << " sec." << endl ;
	    if( dstrm ) (*dstrm) << "done with " << cedar_file << endl ;
	    cleanup() ;
	    return 0 ;
	}
        else
	{
	    cerr << program_name << ": can not get connected to file "
	         << cedar_file << ".\n" ;
	    if( dstrm )
	    {
		(*dstrm) << "  can not get connected to file "
			 << cedar_file << ".\n" ;
		(*dstrm) << "done with " << cedar_file << endl ;
	    }
	}
	cleanup() ;
        return 1 ;
    }
    catch( CedarException &ex )
    {
        cerr << program_name << ": reporting Cedar++ exception "
	     << ex.get_error_code() << ": "
	     << ex.get_description() << endl ;
        cerr << program_name << ": exiting program." << endl ;
	if( dstrm )
	{
	    (*dstrm) << "  reporting Cedar++ exception "
		     << ex.get_error_code() << ": "
		     << ex.get_description() << endl ;
	    (*dstrm) << "done with " << cedar_file << endl ;
	}
	cleanup() ;
        return ex.get_error_code() ;
    }
    catch(...)
    {
        cerr << program_name
	     << ": reporting unknown exception, exiting program."
	     << endl ;
	if( dstrm )
	{
	    (*dstrm) << "  reporting unknown exception" << endl ;
	    (*dstrm) << "done with " << cedar_file << endl ;
	}
	cleanup() ;
        return 1 ;
    }
    return 0 ;
}

/********************************************
 *
 * Functions definition
 *
 *******************************************/

int get_records_in_this_file( string &filename )
{
    name_path pf ;
    int max_elem = reg.get_size() ;
    for( int i = 0; i < max_elem - 1; i++ )
    {
	cout << "insert ignore into tbl_file_info (file_id, record_type_id)"
	     << " select t1.file_id, t2.record_type_id from"
	     << " tbl_cedar_file as t1, tbl_record_type as t2"
	     << " where t1.file_name = \"" << pf.get_file_name( filename )
	     << "\" and t2.kindat = " << reg[i].get_kindat()
	     << " and t2.kinst = " << reg[i].get_kinst() << ';' << endl ;
    }
    return 1 ;
}

int get_dates_in_this_file( string &filename )
{
    name_path pf ;
    int max_elem = dates.get_size() ;
    for( int i = 0; i < max_elem - 1 ; i++ )
    {
	cout << "insert ignore into tbl_date_in_file " ;
	cout << "select t1.date_id, t2.record_in_file_id " ;
	cout << "from tbl_date as t1, tbl_file_info as t2, " ;
	cout << "tbl_cedar_file as t3, tbl_record_type as t4 " ;
	cout << "where t3.file_name = \"" << pf.get_file_name( filename ) ;
	cout << "\" and t3.file_id=t2.file_id and " ;
	cout << "t4.record_type_id = t2.record_type_id and " ;
	cout << "t4.kinst =" <<dates[i].kinst << " and " ;
	cout << "t4.kindat =" <<dates[i].kindat << " and " ;
	cout << "t1.year =" <<dates[i].date.get_year() << " and " ;
	cout << "t1.month =" <<dates[i].date.get_month() << " and " ;
	cout << "t1.day =" <<dates[i].date.get_day() << ';' << endl ;
    }
    return 1 ;
}

void deal_with_record( const CedarLogicalRecord *pLogRec )
{
    if( pLogRec )
    {
	nrecords++ ;
	switch( pLogRec->get_type() )
	{
	    case 1:
		{
		    string filename ;
		    check_first_last( (CedarDataRecord *)pLogRec, filename ) ;
		    get_record_type_data( (CedarDataRecord *)pLogRec ) ;
		}
		break;
	    default:
		break;
	}
    }
}

int logged_record_type( field ki, field kd )
{
    record_type re( ki,kd ) ;
    int max_elem = reg.get_size() ;
    for( int i = 0; i < max_elem - 1; i++ )
    {
	if( re == reg[i] )
	    return 1 ;
    }
    reg.set_size( max_elem + 1 ) ;
    reg[max_elem-1] = re ;
    return 0 ;
}

void get_file_data( string &filename )
{
    struct stat my_buf ;
    if( stat( filename.c_str(), &my_buf ) )
    {
	cerr << "There are problems getting the data corresponding to file "
	     << filename << endl ;
	exit( 1 ) ;
    }
    name_path pf ;
    cout << "insert ignore into tbl_cedar_file "
         << "(FILE_NAME, FILE_SIZE, FILE_MARK) VALUES (\"";
    cout << pf.get_file_name( filename ) << "\", " << my_buf.st_size << ", \""
         << my_buf.st_mtime << "\");" << endl ;
}

struct precision_record_type
{
    CedarRecordType rt ;
    CedarDate first_dt ;
    CedarDate last_dt ;
} ;

void check_first_last( CedarDataRecord* pDat, string &filename )
{
    // This is an array that storages record types with the last date
    static CedarArray <struct precision_record_type> first_and_last( 1, 1 ) ;

    if( pDat )
    {
	static bool first_record( true ) ;

	struct precision_record_type pres ;
	pres.rt.set_kinst( pDat->get_record_kind_instrument() ) ;
	pres.rt.set_kindat( pDat->get_record_kind_data() ) ;
	CedarDate somedt ;
	if( pDat->get_record_begin_date( somedt ) )
	{
	    pres.first_dt.set_date ( somedt.get_year(),
				     somedt.get_month_day(),
				     somedt.get_hour_min(),
				     somedt.get_second_centisecond() ) ;
	}
	else
	{
	    cerr << "Invalid begin date for this record" << endl ;
	    exit( 1 ) ;
	}
	if( pDat->get_record_end_date( somedt ) )
	{
	    pres.last_dt.set_date ( somedt.get_year(),
				    somedt.get_month_day(),
				    somedt.get_hour_min(),
				    somedt.get_second_centisecond() ) ;
	}
	else
	{
	    cerr << program_name << "{\nInvalid end date for this record"
	         << endl ;
	    cerr << "}\n" ;
	    exit( 1 ) ;
	}

	if( first_record )
	{
	    first_and_last[0] = pres ;
	    first_record = false ;
	}
	// Check to see if this struct precision_record_type should
	// replace any date element in the array
	else
	{
	    bool exist( false ) ;
	    for( int i = 0; i < first_and_last.get_size(); i++ )
	    {
		if( pres.rt == first_and_last[i].rt )
		{
		    if( pres.first_dt < first_and_last[i].first_dt )
			first_and_last[i].first_dt = pres.first_dt ;
		    if( pres.last_dt > first_and_last[i].last_dt )
			first_and_last[i].last_dt = pres.last_dt ;
		    exist = true ;
		    break ;
		}
	    }
	    if( !exist ) // add it!
		first_and_last[first_and_last.get_size()] = pres ;
	}
    }
    else
    {
	cout << "\n# For each record type in this file this are the"
	     << " first and last date..." << endl ;
	for( int i = 0; i < first_and_last.get_size(); i++ )
	{
	    cout << "insert into tbl_record_in_file_first_last "
	         << "("
	         << "RECORD_IN_FILE_ID, "
	         << "FIRST_YEAR, "
	         << "FIRST_MONTH, "
	         << "FIRST_DAY, "
	         << "FIRST_HOUR, "
	         << "FIRST_MINUTE, "
	         << "FIRST_MILISECOND, "
	         << "LAST_YEAR, "
	         << "LAST_MONTH, "
	         << "LAST_DAY, "
	         << "LAST_HOUR, "
	         << "LAST_MINUTE, "
	         << "LAST_MILISECOND "
	         << ")"
	         << " select t1.RECORD_IN_FILE_ID, "
	         << first_and_last[i].first_dt.get_year() << ", " 
	         << first_and_last[i].first_dt.get_month() << ", "  
	         << first_and_last[i].first_dt.get_day() << ", "  
	         << first_and_last[i].first_dt.get_hour() << ", "  
	         << first_and_last[i].first_dt.get_minute() << ", "  
	         << first_and_last[i].first_dt.get_second_centisecond()
		 << ", "  
	         << first_and_last[i].last_dt.get_year() << ", "  
	         << first_and_last[i].last_dt.get_month() << ", "  
	         << first_and_last[i].last_dt.get_day() << ", "  
	         << first_and_last[i].last_dt.get_hour() << ", "  
	         << first_and_last[i].last_dt.get_minute() << ", "  
	         << first_and_last[i].last_dt.get_second_centisecond() << " "
	         << "from "
	         << "tbl_file_info as t1, "
	         << "tbl_record_type as t2, "
	         << "tbl_cedar_file as t3 "
	         << "where "
	         << "t2.KINST = " << first_and_last[i].rt.get_kinst() << " "
	         << "and "
	         << "t2.KINDAT = " << first_and_last[i].rt.get_kindat() << " " 
	         << "and "
	         << "t3.FILE_NAME= " << "\"" << filename << "\" "
	         << "and "
	         << "t3.FILE_ID = t1.FILE_ID "
	         << "and "
	         << "t2.RECORD_TYPE_ID = t1.RECORD_TYPE_ID;"
	         << endl ;
	}
    }
}

void get_record_type_data( CedarDataRecord* pDat )
{
    int j ;
    if( !logged_record_type( pDat->get_record_kind_instrument(),
                             pDat->get_record_kind_data() ) )
    {
	cout << "insert ignore into tbl_instrument set KINST = "
	     << pDat->get_record_kind_instrument() << ';' << endl ;
	cout << "insert ignore into tbl_record_type (KINDAT,KINST) values (" ;
	cout << pDat->get_record_kind_data() << ','
	     << pDat->get_record_kind_instrument() << ");" << endl ; 
	unsigned int jpar_value = pDat->get_jpar() ;
	vector<short int> pJparData( jpar_value ) ;
	pDat->load_JPAR_vars( pJparData ) ;
	for( j = 0; j < jpar_value; j++ )
	{
	    cout << "insert ignore into tbl_record_info"
	         << " select t1.RECORD_TYPE_ID, " << pJparData[j] ;
	    cout << " from tbl_record_type as t1 where t1.KINDAT = "
	         << pDat->get_record_kind_data() << " and " ;
	    cout << "t1.KINST = " << pDat->get_record_kind_instrument()
	         << ';' << endl ;
	    cout << "insert ignore into tbl_parameter_code set PARAMETER_ID = "
	         << pJparData[j] << ';' << endl ;
	}
	unsigned int mpar_value = pDat->get_mpar() ;
	vector<short int> pMparData( mpar_value ) ;
	pDat->load_MPAR_vars( pMparData ) ;
	for( j = 0; j < mpar_value; j++ )
	{
	    cout << "insert ignore into tbl_record_info"
	         << " select t1.RECORD_TYPE_ID, " << pMparData[j] ;
	    cout << " from tbl_record_type as t1 where t1.KINDAT = "
	         << pDat->get_record_kind_data() ;
	    cout << " and t1.KINST = " << pDat->get_record_kind_instrument()
	         << ';' << endl ;	 	
	    cout << "insert ignore into tbl_parameter_code"
	         << " set PARAMETER_ID = " << pMparData[j] << ';' << endl ;
	}
    }
    load_date_info( pDat ) ;
}

int log_date( int kinst, int kindat, CEDARDB_date &my_date )
{
    int max_elem = dates.get_size() ;
    for( int i = 0; i < max_elem - 1; i++ )
    {
	if( (kinst == dates[i].kinst)
	    && (kindat == dates[i].kindat)
	    && (my_date == dates[i].date) )
	{
	    return 1 ;
	}
    }
    dates.set_size( max_elem + 1 ) ;
    dates[max_elem-1].date = my_date ;
    dates[max_elem-1].kinst = kinst ;
    dates[max_elem-1].kindat = kindat ;
    return 0 ;
}

void load_date_info( CedarDataRecord* pDat )
{
    CedarDate begin_Date, end_Date ;
    pDat->get_record_begin_date( begin_Date ) ;
    pDat->get_record_end_date( end_Date ) ;
    CEDARDB_date date1( begin_Date.get_year(),
                        begin_Date.get_month(),
			begin_Date.get_day() ) ;
    CEDARDB_date date2( end_Date.get_year(),
                        end_Date.get_month(),
			end_Date.get_day() ) ;
    while( date1 <= date2 )
    {
	log_date( pDat->get_record_kind_instrument(),
	          pDat->get_record_kind_data(), date1 ) ;
	date1++ ;
    }
}

void write_header( string &filename )
{
    cout << "# This is a SQL script corresponding to the metadata for file "
         << filename << endl ;
    cout << "# Do not modify!!!" << endl << endl << endl ;
}

void update_number_of_records( string &filename )
{
    name_path pf;
    cout << "update tbl_cedar_file set NRECORDS=" << nrecords
         << " where FILE_NAME=\""<< pf.get_file_name( filename ) << "\";"
	 << endl ;
}

