#!/usr/bin/perl

=begin nd

  Script: users.pl
  
  Description:
  Renders the user administration page, and handles all
  ajax requests to add and remove pms-admin users (not chat users)
=cut

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use HTML::Template;
use Pms::Session;
use Pms::MainView;
use Pms::UserView;

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
  my $mod = Pms::UserView->new();
  if(!defined $q->url_param('action')){
    my $baseView = Pms::MainView->new();
    $baseView->render($mod,$q,$session);
  }else{
    print "Content-type: application/json\n\n";
    print $mod->dataRequest($q);
  }       
}