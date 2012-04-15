#!/usr/bin/perl

#this script will render module pages and invoke
#functions as they are available from the script
#it uses the following GET informations:
#  http://localhost/pms-admin/module.pl?mod=Security;view=addUser
#  The mod variable tells module.pl which module it should load
#  The view variable tells module.pl that it should render a page, if this variable is not present
#      the script assumes that we did a data-request which means it will call BaseModule::dataRequest()
#      this can be used for ajax-based requests


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
  if(!defined $q->url_param('view')){
    print "Content-type: application/json\n\n";
    print '{"error" : true, "code" : '.$Pms::Session::lastError.'}';
    exit(0);
  }else{
    my $url = 'login.pl';
    if(defined $Pms::Session::lastError){
      $url .= "?error=$Pms::Session::lastError";
    }
    print $q->header(-location=>$url);
  }
}
else
{
  my $modname = $q->url_param('mod');
  my $packagename = "Pms::Modules::".$modname."::Mod";
  
  eval "require $packagename" or die "$@"; #print $q->header(-location=>"index.pl");
  my $mod = $packagename->new();
  
  if(defined $q->url_param('view')){
    my $baseView = Pms::MainView->new();
    $baseView->render($mod,$q,$session);
  }else{
    print "Content-type: application/json\n\n";
    print $mod->dataRequest($q);
  }
}