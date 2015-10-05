sub get_database_version
{
    print "Trying to get database version...";
    $proc="$mysql_client -u $user -p$pass --host=$host --port=$port -e\"select VERSION from tbl_version\" -s --skip-column-names $cedardb";
    if( $dfile )
    {
	print DEBUG "\nValidating database version: $proc\n" ;
    }
    $database_version=`$proc`;
    if(($?>>8) !=0)
    {
	do_exit ("can not get database version!\n");
    }
    else
    {
	print "OK!\n";
    }
    chop($database_version);
    if( $dfile )
    {
	print DEBUG "    Database version is: $database_version\n" ;
    }
} 

sub get_data_from_user
{
    open (CACHE, "< ./.cache") || print "Could not find cache file\n";
    $i=1;
    while ($line =<CACHE>)
    {
	chop($line);
	if ($i == 1)
	{
	    $cdir1=$line; 
	}
	if ($i == 2)
	{
	    $mdir1=$line; 
	}
	if ($i == 3)
	{
	    $user1=$line; 
	}
	if ($i == 4)
	{
	    $pass1=$line; 
	}
	if ($i == 5)
	{
	    $host1=$line; 
	}
	if ($i == 6)
	{
	    $port1=$line; 
	}
	if ($i == 7)
	{
	    $cedardb1=$line; 
	}
	if ($i == 8)
	{
	    $mysql_home1=$line;
	}
	$i=$i+1;
	
    }    
    close (CACHE);
    
    if ($cdir1 eq "")
    {
	while($cdir eq "")
	{
	    print "Directory containing cbf files to be load into mysql? ";
	    $cdir=<STDIN>;
	    chop($cdir);
	}
    }
    else
    {
	print "Directory containing cbf files to be load into mysql ($cdir1)? ";
	$cdir=<STDIN>;
	chop($cdir);
	if ($cdir eq "")
	{
	    $cdir=$cdir1;
	}
    }
    if ($mdir1 eq "")
    {
	while($mdir eq "")
	{
	    print "Directory containing cbf files to be load into mysql? ";
	    $mdir=<STDIN>;
	    chop($mdir);
	}
    }
    else
    {
	print "Directory containing cbf files to be load into mysql ($mdir1)? ";
	$mdir=<STDIN>;
	chop($mdir);
	if ($mdir eq "")
	{
	    $mdir=$mdir1;
	}
    }
    if ($user1 eq "")
    {
	while($user eq "")
	{
	    print "User to access mysql server? ";
	    $user=<STDIN>;
	    chop($user);
	}
    }
    else
    {
	print "User to access mysql server ($user1)? ";
	$user=<STDIN>;
	chop($user);
	if ($user eq "")
	{
	    $user=$user1;
	}
    }   
    if ($pass1 eq "")
    {
	while($pass eq "")
	{
	    print "Password to access mysql server? ";
	    $pass=<STDIN>;
	    chop($pass);
	}
    }
    else
    {
	print "Password to access mysql server ($pass1)? ";
	$pass=<STDIN>;
	chop($pass);
	if ($pass eq "")
	{
	    $pass=$pass1;
	}
    }   	
    if($host1 eq "")
    {
	while ($host eq "")
	{
	    print "Host where mysql server is running? ";
	    $host=<STDIN>;
	    chop($host);
	}
    }
    else
    {
	print "Host where mysql server is running ($host1)? ";
	$host=<STDIN>;
	chop($host);
	if ($host eq "")
	{
	    $host=$host1;
	}
    }  	
    if($port1 eq "")
    {
	while ($port eq "")
	{
	    print "Port where mysql server is running? ";
	    $port=<STDIN>;
	    chop($port);
	}
    }
    else
    {
	print "Port where mysql server is running ($port1)? ";
	$port=<STDIN>;
	chop($port);
	if ($port eq "")
	{
	    $port=$port1;
	}
    }  	
    if($cedardb1 eq "")
    {
	while ($cedardb eq "")
	{
	    print "Database name you wish to create? ";
	    $cedardb=<STDIN>;
	    chop($cedardb);
	}
    }
    else
    {
	print "Database name you wish to create ($cedardb1)? ";
	$cedardb=<STDIN>;
	chop($cedardb);
	if ($cedardb eq "")
	{
	    $cedardb=$cedardb1;
	}
    }  	
    if($mysql_home1 eq "")
    {
	while ($mysql_home eq "")
	{
	    print "Directory where the mysql client resides?";
	    $mysql_home=<STDIN>;
	    chop($mysql_home);
	}
    }
    else
    {
	print "Directory where the mysql client resides($mysql_home1)?";
	$mysql_home=<STDIN>;
	chop($mysql_home);
	if ($mysql_home eq "")
	{
	    $mysql_home=$mysql_home1;
	}
    }  	

    $mysql_client=$mysql_home."/mysql";
    $mysql_admin=$mysql_home."/mysqladmin";

    if (!-d "$mysql_home")
    {
	do_exit ("$mysql_home does not exist!\n");
    }
    if (!-x "$mysql_client")
    {
	do_exit ("$mysql_client not executable\n") ;
    }
    if (!-x "$mysql_admin")
    {
	do_exit ("$mysql_admin not executable\n") ;
    }

    open (CACHE, "> ./.cache ") || print "Could not open cache file for writing\n";
    print CACHE "$cdir\n";
    print CACHE "$mdir\n";
    print CACHE "$user\n";
    print CACHE "$pass\n";
    print CACHE "$host\n";
    print CACHE "$port\n";
    print CACHE "$cedardb\n";
    print CACHE "$mysql_home\n";
    close (CACHE);
    `chmod go-rw ./.cache`;

    if( $dfile )
    {
	print DEBUG "CEDAR DIR: $cdir\n";
	print DEBUG "MADRIGAL DIR: $mdir\n";
	print DEBUG "User: $user\n";
	print DEBUG "Pass: $pass\n";
	print DEBUG "DB Host: $host\n";
	print DEBUG "DB Port: $port\n";
	print DEBUG "DB Name: $cedardb\n";
	print DEBUG "MySQL Home: $mysql_home\n";
	print DEBUG "MySQL Client: $mysql_client\n";
	print DEBUG "MySQL Admin: $mysql_admin\n";
    }
}

sub get_cbf_files
{
    print "Trying to get list of cbf files...";
    my $proc="ls $cdir" . "/*.cbf";
    @cfiles=`$proc`;
    if(($?>>8) !=0)
    {
	do_exit ("there are 0 cbf files in the specified directory!\n");
    }
    else
    {
	my $number= @cfiles;
	print "working with $number files!\n";
	if( $dfile )
	{
	    print DEBUG "\nWorking with $number cbf files\n" ;
	    print DEBUG "CEDAR Files:\n" ;
	    foreach $file(@cfiles)
	    {
		print DEBUG "    $file" ;
	    }
	}
    } 
}

sub get_mad_files
{
    print "Trying to get list of madrigal files...";
    my $proc="find $mdir" . " \\( -name \"*.001\" -or -name \"*.cbf\" \\) -print";
    @mfiles=`$proc`;
    if(($?>>8) !=0)
    {
	do_exit ("there are 0 madrigal files in the specified directory!\n");
    }
    else
    {
	my $number= @mfiles;
	print "\nWorking with $number files!\n";
	if( $dfile )
	{
	    print DEBUG "working with $number madrigal files\n" ;
	    print DEBUG "MADRIGAL Files:\n" ;
	    foreach $file(@mfiles)
	    {
		print DEBUG "    $file" ;
	    }
	}
    }
}

sub validate_connection_data
{
    my $valid="";
    print "Trying to contact mysql server with $mysql_admin...";
    $proc="$mysql_admin -u$user -p$pass --host=$host --port=$port ping";
    if( $dfile )
    {
	print DEBUG "\nValidating mysql with:\n$proc\n" ;
    }
    $valid=`$proc`;
    chop ($valid);
    if( $dfile )
    {
	print DEBUG "Validating mysql returned: $valid\n" ;
    }
    if ($valid eq "mysqld is alive")
    {
	print "OK!\n";
    }
    else
    {
	print STDERR "Got following message: " . $valid ."\n";
	do_exit ("Can not validate user/password!\n");
    }
}


sub verify_cedarinventory 
{
    print "Trying to contact cedarinventory...";
    $dbversion="./cedarinventory: version $database_version" ;
    $version=`./cedarinventory -v`;
    chop ($version);
    if( $dfile )
    {
	print DEBUG "\nValidating cedarinventory returned: $version\n" ;
	print DEBUG "                      Comparing to: $dbversion\n" ;
    }
    if ($version eq "$dbversion")
    {
	print "OK!\n";
    }
    else
    {
	print STDERR ("Incompatible versions; $version but the database is version $database_version\n");
	do_exit("Can not contact cedarinventory!\n");
    }
}

sub do_exit
{
    my $what = shift;
    print $what;
    print $program_name,": more details of the problem may be seen on the error log ($log_file)";
    if( $dfile )
    {
	print " and debug file ($dfile)" ;
	print DEBUG "\n$what" ;
    }
    print "\n" ;
    exit(1);
}

sub drop_generated_tables
{
    print "Trying to create the database...";
    my $proc="$mysql_client -u $user -p$pass --host=$host --port=$port $cedardb";
    if( $dfile )
    {
	print DEBUG "\nConnecting to database to drop tables:\n$proc\n" ;
    }
    open (PROC, "|$proc") || do_exit ("There is a problem connecting to the database!\n");
    if( $dfile )
    {
	print DEBUG "    Dropping tables\n" ;
    }
    print PROC "DROP TABLE IF EXISTS tbl_version;";
    if( $dfile )
    {
	print DEBUG "    Dropped tbl_version\n" ;
    }
    print PROC "DROP TABLE IF EXISTS tbl_date;";
    if( $dfile )
    {
	print DEBUG "    Dropped tbl_date\n" ;
    }
    print PROC "DROP TABLE IF EXISTS tbl_date_in_file;";
    if( $dfile )
    {
	print DEBUG "    Dropped tbl_date_in_file\n" ;
    }
    print PROC "DROP TABLE IF EXISTS tbl_record_in_file_first_last;";
    if( $dfile )
    {
	print DEBUG "    Dropped tbl_record_in_file_first_last\n" ;
    }
    print PROC "DROP TABLE IF EXISTS tbl_cedar_file;";
    if( $dfile )
    {
	print DEBUG "    Dropped tbl_cedar_file\n" ;
    }
    print PROC "DROP TABLE IF EXISTS tbl_file_info;";
    if( $dfile )
    {
	print DEBUG "    Dropped tbl_file_info\n" ;
    }
    print PROC "DROP TABLE IF EXISTS tbl_record_info;";
    if( $dfile )
    {
	print DEBUG "    Dropped tbl_record_info\n" ;
    }
    close (PROC);
    print "OK!\n";
}

sub load_schema
{
    print "Trying to load the database schema...";
    $proc="$mysql_client -u$user -p$pass --host=$host --port=$port $cedardb < CEDARDB_create_database.sql";
    if( $dfile )
    {
	print DEBUG "\nLoading database schema:\n$proc\n" ;
    }
    `$proc`;
    if(($?>>8) !=0)
    {
	do_exit ("failed to load the schema!\n");
    }
    else
    {
	print "OK!\n";
    }
}

sub load_tbl_dates
{
    print "Loading all valid dates into mysql...";
    my $proc="$mysql_client -u $user -p$pass --host=$host --port=$port $cedardb";

    if( $dfile )
    {
	print DEBUG "\nLoading all valid dates from 1950 to 2011:\n$proc\n" ;
    }

    open (PROC, "|$proc") || do_exit ("there is a problem loading tbl_dates data!\n");
    for ($year=1950; $year<2011; $year++)
    {
	for ($month=1; $month<13; $month++)
	{
	    for ($day=1; $day<32; $day++)
	    {
		if ((is_leap_year($year)) && ($month==2) && ($day==30))
		{
		    $day=32;
		}
		elsif ((!is_leap_year($year))&& ($month==2) && ($day==29))
		{
		    $day=32;
		}
		elsif (($month==4 || $month==6 || $month==9 || $month==11) && ($day==31))
		{
		    $day=32;
		}
		else
		{
		    print PROC "INSERT INTO tbl_date SET YEAR=$year, MONTH=$month, DAY=$day;\n";
		}
	    }
	}
    }
    print "OK!\n";
    close (PROC);
}

sub is_leap_year
{
     my $year = shift;
     my $leap = ($year%4 == 0 && $year%100 != 0 || $year%400 == 0) ;
     return $leap;
}

sub cedar_inventory_driver
{
    my $file="";
    my $line="";

    if( $dfile )
    {
	print DEBUG "\nRunning inventory on files\n" ;
    }

    @filelist = (@cfiles, @mfiles) ;
    foreach $file(@filelist)
    {
	chop($file);
	print "Trying to get metadata out of ",$file,"...";
	my $proc="./cedarinventory $dfile_passed $checksum $file";
	if( $dfile )
	{
	    print DEBUG "    Running inventory $proc\n"
	}
	my @script=`$proc`;
	$ret=$?>>8;
	if($ret!=0)
	{
	    print "cedarinventory failed with return value $ret!\n";
	    if( $dfile )
	    {
		print DEBUG "cedarinventory failed for $file with $ret\n" ;
		#
		# see if we got anything back
		#
		foreach $line(@script)
		{
		    print DEBUG "$line\n"
		}
	    }
	}
	else
	{
	    my $proc="$mysql_client -u $user -p$pass --host=$host --port=$port $cedardb";
	    open (PROC, "|$proc") || do_exit ("there is a problem loading data into mysql!\n");
	    foreach $line(@script)
	    {
		print PROC $line;
	    }
	    close (PROC);
	    print "OK!\n";
	}
    }
}

sub set_last_modified
{
    print "Updating the table tbl_version...";
    my $proc="$mysql_client -u $user -p$pass --host=$host --port=$port $cedardb";
    if( $dfile )
    {
	print DEBUG "\nUpdating tbl_version date:\n$proc\n" ;
    }
    open (PROC, "|$proc") || do_exit ("there is a problem updating tbl_version!\n"); 
    print PROC "update tbl_version set LAST_MODIFIED=CURRENT_TIMESTAMP();\n";
    close (PROC);
    print "OK!\n";
}

1; #return true
