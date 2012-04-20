#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::Session;
use HTML::Template;

my $q = CGI->new();

my $usr = $q->param('user');
my $pwd = $q->param('password');
my $error = $q->param('error');


if($usr ne '')
{
    # process the form
    my $dbh = Pms::Session::databaseConnection();
    
    my $sth = $dbh->prepare("SELECT COUNT(*) from pms_admins where username = ? and password = ?");
    if($sth->execute($usr,$pwd)){
      my @val = $sth->fetchrow_array;
      if($val[0] > 0){
        my $session = CGI::Session->new();
        $session->param('user',$usr);
        print $session->header(-location=>'index.pl');
        exit(0);
      }
    }
     print $q->header(-type=>"text/html",-location=>"login.pl?error=2");
}
elsif($q->param('action') eq 'logout')
{
    my $session = CGI::Session->load() or die CGI::Session->errstr;
    $session->delete();
    print $session->header(-location=>'login.pl');
}
else
{
  # open the html template
  my $template = HTML::Template->new(filename => 'tmpl/login.tmpl');
  
  if(defined $error){
    $template->param(HAS_ERROR => 1,
                     ERROR => Pms::Session::errorMessage($error)
    );
  }
  
  my $baseTemplate = HTML::Template->new(filename => 'tmpl/base.tmpl');
  $baseTemplate->param(CONTENT => $template->output);
  $baseTemplate->param(MODULE_SCRIPTS => [{
      LOCATION => "js/login.js"
  }]);
  
  # send the obligatory Content-Type and print the template output
  print "Content-type: text/html\n\n";
  print $baseTemplate->output;
}