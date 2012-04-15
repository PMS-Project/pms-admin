#!/usr/bin/perl

package Pms::MainView;

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::Session;
use HTML::Template;

sub new{
  my $class = shift;
  my $self = {};
  bless($self,$class);
  
  return $self;
}


sub render{
  my $self = shift or die "Need Ref";
  my $content = shift or die "Need Content";
  my $q       = shift or die "Need CGI Query";
  
  my $session = Pms::Session::get();
  #this should never happen just to be shure
  if(!$session){
    print $session->header(-location=>'index.pl');
    return;
  }
  my $modNavElems = shift;
  
  
  print $q->header(-cache_control=>"no-cache, no-store, must-revalidate");
  
  my $baseTemplate = HTML::Template->new(filename => 'tmpl/base.tmpl');
  my $template     = HTML::Template->new(filename => 'tmpl/index.tmpl');
  
  $template->param(USERNAME => $session->param('user'),
                   CONTENT  => $content #,
                   #MODULE_NAVS => [{
                   # NAME => "Cool Stuff",
                   # HREF => "someRef"
                   #}]
  );
  $baseTemplate->param(CONTENT => $template->output);
  print $baseTemplate->output;
}


1;