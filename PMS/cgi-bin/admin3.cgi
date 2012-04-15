#!perl

# Aufgabe des Skripts
# Argumente, Ein- Ausgabe
# Thorsten Schwalb
# Datum

use strict;
use warnings; 
use DBI;
use CGI::Session;
use CGI;


# my $html_query ="";
# my $user_insert="";
# my @pairs;
# my $dummy;

my @backlog;


###################Post Parameter Processing #######################
#
#read(STDIN, $html_query, $ENV{'CONTENT_LENGTH'});  
#@pairs = split(/&/, $html_query);

#($dummy,$user_insert)  = split(/=/, $pairs[0]);
#($dummy, $password_insert) = split(/=/, $pairs[1]);


############################ Session abfragen #########################################
my $cgi = new CGI;
my $sid = $cgi->cookie("CGISESSID") || undef;
my $session    = new CGI::Session(undef, $sid, {Directory=>'/tmp'});

my $dbuser = $session->param("user");
my $dbpassword = $session->param("password");


###################Database Connection############################################

# my $dbuser ="ilu";
# my $dbpassword = "test";
my $database = "dbi:mysql:pms";
my $hostname = "localhost";
my $dbh;
my ($sth,$sth1);
eval {$dbh = DBI->connect($database,$dbuser,$dbpassword,{RaiseError =>1, AutoCommit =>1})};

if($@){
		print $cgi->header();
		print "fehler";
		}
##################################################################################


$sth = $dbh->prepare("call backlog(50)");
$sth->execute();

print $cgi->header();
print $cgi->start_html(	-title=>"PMS-Backlog",
						-bgcolor => "gray",
						-TEXT=>"#ffffff",
						-align=>"center");
						
	while(@backlog = $sth->fetchrow_array()){
		foreach(@backlog){
			print "$_"."<br>";
			}
		}
print $cgi->end_html();







