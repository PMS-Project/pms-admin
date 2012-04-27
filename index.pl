#!/usr/bin/perl
=begin nd

  Script: index.pl
  
  Description:
  Renders the welcome page, has no other function
  than saying hello to the user and let him choose
  what we wants to do from the navigation bars.
=cut

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
  my $url = 'login.pl';
  if(defined $Pms::Session::lastError){
    $url .= "?error=$Pms::Session::lastError";
  }
  print $q->header(-location=>$url);
}
else
{
  my $view = Pms::MainView->new();
  $view->render("Welcome",$q,$session);
}