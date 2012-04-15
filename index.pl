#!/usr/bin/perl

# index.pl
use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use HTML::Template;
use Pms::Session;

my $session = Pms::Session::restore();
my $q = CGI->new();

if(!defined $session)
{
  my $url = 'login.pl';
  if(defined $Pms::Session::lastError){
    $url .= $Pms::Session::lastError;
  }
  print $q->header(-location=>$url);
}
else
{
    print $q->header(-cache_control=>"no-cache, no-store, must-revalidate");
    
    my $baseTemplate = HTML::Template->new(filename => 'tmpl/base.tmpl');
    my $template     = HTML::Template->new(filename => 'tmpl/index.tmpl');
    
    $baseTemplate->param(CONTENT => $template->output);
    print $baseTemplate->output;
}