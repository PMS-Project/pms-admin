#!perl

# Aufgabe des Skripts
# Argumente, Ein- Ausgabe
# Thorsten Schwalb
# Datum

use strict;
use warnings; 
use DBI;
use CGI;
use CGI::Session;
use CGI::Carp qw(fatalsToBrowser);



my $html_query ="";
my $dbpassword = "";
my $dbuser;
my @pairs;
my $dummy;





###################Post Parameter Processing ###################################

read(STDIN, $html_query, $ENV{'CONTENT_LENGTH'});  
@pairs = split(/&/, $html_query);

($dummy,$dbuser)  = split(/=/, $pairs[0]);
($dummy, $dbpassword) = split(/=/, $pairs[1]);
#$dbuser = "ilu";
#$dbpassword = "test";

#################################################################################

##################### Session Generation ##########################################
my $session;
my $cgi = new CGI;
eval { $session = new CGI::Session("driver:File",$cgi, {Directory=>'c:\xampp\tmp'})};
if ($@){print "Fehler";}
 	#Neues Session Objekt anlegen
my $sid = $session->id();													#SessionId an $sid zuweisen
my $cookie = $cgi->cookie(CGISESSID => $session->id);
$session->param("user", $dbuser);
$session->param("password", $dbpassword);
#################################################################################




###################Database Connection############################################
my $database = "dbi:mysql:pms";
my $hostname = "localhost";

my $dbh;
my ($sth,$sth1);

eval {$dbh = DBI->connect($database,$dbuser,$dbpassword,{RaiseError =>1, AutoCommit =>1})}; 
##################################################################################



																					 		
if($@){	print $cgi->header(-cookie =>$cookie);
		
		open (DATEI, "<", "../htdocs/bootstrap_login_false.html") or warn "Kann die Datei nicht öffnen";
		while (read DATEI, my $buf, 16384){
			print $buf;
		}
		close DATEI;
	
	}

 
else {	
		
		print $cgi->header(-cookie =>$cookie);	
		
		open (DATEI, "<", "../htdocs/bootstrap_template.html") or warn;
		while (read DATEI, my $buf, 16384){
			print $buf;
		}
	 }

