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
use CGI::Carp qw(fatalsToBrowser);


my $html_query ="";
my $password_insert = "";
my $user_insert="";
my @pairs;
my $dummy;


###################Post Parameter Processing #######################

read(STDIN, $html_query, $ENV{'CONTENT_LENGTH'});  
@pairs = split(/&/, $html_query);

($dummy,$user_insert)  = split(/=/, $pairs[0]);
($dummy, $password_insert) = split(/=/, $pairs[1]);


############################ Session abfragen #########################################
my $cgi = new CGI;
my $sid = $cgi->cookie("CGISESSID") || undef;
my $session    = new CGI::Session(undef, $sid, {Directory=>'/tmp'});

my $dbuser = $session->param("user");
my $dbpassword = $session->param("password");


###################Database Connection############################################
my $database = "dbi:mysql:pms";
my $hostname = "localhost";
my $dbh;
my ($sth,$sth1);
eval {$dbh = DBI->connect($database,$dbuser,$dbpassword,{RaiseError =>1, AutoCommit =>1})};

if($@){
		print $cgi->header();
		#print $dbh->errstr;
		}
##################################################################################

$sth = $dbh->prepare("call UserInsert(\"$user_insert\",\"$password_insert\")");
$sth->execute;

print $cgi->header();
open (DATEI, "<admin_admin_ok.html");
		while (read DATEI, my $buf, 16384){
		print $buf;
		}












