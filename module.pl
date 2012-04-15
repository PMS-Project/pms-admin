#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use HTML::Template;
use Pms::Session;

my $session = Pms::Session::get();
my $q = CGI->new();

if(!defined $session)
{
  my $url = 'login.pl';
  if(defined $Pms::Session::lastError){
    $url .= "?error=$Pms::Session::lastError";
  }
  print $q->header(-location=>$url);
}
else
{
  my $modname = $q->url_param('mod');
  my $packagename = "Pms::Modules::".$modname."::Mod";
  
  eval "require $packagename" or print $q->header(-location=>"index.pl");
  my $mod = $packagename->new();
  
  my @nav = $mod->navbarElements();
  print $mod->render($q);
}