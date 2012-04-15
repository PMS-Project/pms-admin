#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use HTML::Template;
use Pms::Session;
use Pms::MainView;

my $session = Pms::Session::get();
my $q = CGI->new();

if(!defined $session)
{
  warn "Redir";
  exit(0);
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
  
  eval "require $packagename" or die "$@"; #print $q->header(-location=>"index.pl");
  my $mod = $packagename->new();
  
  my $baseView = Pms::MainView->new();
  $baseView->render($mod,$q,$session);
}