#!perl.exe

use strict;
use warnings;
use DBI;

my $dbuser = "ilu";
my $dbpassword = "test";


###################Database Connection############################################
my $database = "dbi:mysql:pms";
my $hostname = "localhost";

my $dbh;
my ($sth,$sth1);

eval {$dbh = DBI->connect($database,$dbuser,$dbpassword,{RaiseError =>1, AutoCommit =>1})}; 
if ($@) {print "VErbindungsfehler"}

##################################################################################



open (FILE,"<gedicht.txt");
while (<FILE>){
		#my $insert = "Juhuhuhuhuhu";
		$sth = $dbh->prepare("Insert into backlog(message) values (\"$_\")") or die $sth->errstr;
		print $_;
		$sth->execute;
		}
		$sth->finish;