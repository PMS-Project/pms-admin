#!perl

# Aufgabe des Skripts
# Argumente, Ein- Ausgabe
# Thorsten Schwalb
# Datum

use strict;
use warnings;


use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use HTML::Template;


my $cgi_obj = CGI->new();
my @keys = param();
my $templ = HTML::Template->new(filename=> 'table.tmpl');
my @loop_data = ();








print $cgi_obj->header();
print $cgi_obj->start_html("Perl Messaging System");
# print $cgi_obj->h1();

if(! @keys){print "Keine übergebenen Parameter";}

else {	my $index = 0;
		foreach my $key (@keys){
					my %row_data;
					
					$row_data{KEY} = $index;
					$row_data{VALUE} = $key;
					push(@loop_data, \%row_data);
					$index++;
					}
	}
$templ->param(TABLE_HASH => \@loop_data);
$templ->param(TITLE => "Backlog");
print $templ->output();

