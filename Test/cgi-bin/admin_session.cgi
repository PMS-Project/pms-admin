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

##################### Session erzeugen ##########################################
my $cgi = new CGI;
my $session = new CGI::Session("driver:File",$cgi, {Directory=>'/tmp'}); #Neues Session Objekt anlegen
my $sid = $session->id();													#SessionId an $sid zuweisen
my $cookie = $cgi->cookie(CGISESSID => $session->id);
$session->param("user", $dbuser);
$session->param("password", $dbpassword);
##################################################################################




###################Database Connection############################################
my $database = "dbi:mysql:pms";
my $hostname = "localhost";

my $dbh;
my ($sth,$sth1);

eval {$dbh = DBI->connect($database,$dbuser,$dbpassword,{RaiseError =>1, AutoCommit =>1})}; 

##################################################################################



																					 		
if($@){print "Content-type:text/html\r\n\r\n"; 
  	  print "
			<html>
			<head>
			<title>PMS - Administrationsinterface </title>
			</head>
			<body bgcolor = \"#2f4f4f\">
				<font color = \"#ffffff\">
				<h1 align =\"center\">Perl Messaging System - Administration</h1>
				
				<h2 align = \"center\">Login fehlgeschlagen</h2><br><br>
					<form align =\"center\" action=\"/cgi-bin/admin.cgi\" method=\"POST\" enctype=\" text/plain\">
						<br>Username<input type=\"text\" size=\"30\" maxlength=\"30\" name =\"user\">
						<br>Password<input type=\"password\" size =\"30\" maxlength =\"30\" name=\"password\">
						<br><input align =\"center\" color =\"#80000\" type=\"submit\" name =\"submit\" value =\"Submit\">
					</form>	
		
				
				
			</body>
			</html>";
	}

 
else {	
		#print "Content-type:text/html\r\n\r\n";
		print $cgi->header(-cookie =>$cookie);
		close DATEI;
		open (DATEI, "<", "../htdocs/admin_login_ok.html") or warn;
		while (read DATEI, my $buf, 16384){
			print $buf;
		}
	 }

