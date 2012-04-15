#!/usr/bin/perl

package Pms::MainView;

use strict;
use warnings;
use Scalar::Util qw(blessed);
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use PmsConfig;
use Pms::Session;
use Pms::BaseModule;
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
  
  my @modules = ();
  foreach my $curr (@PmsConfig::modules){
    my $modConf = {
      NAME => $curr->{name},
      HREF => "module.pl?mod=".$curr->{fqn}
    };
    push(@modules,$modConf);
  }
  
  my %templParams = (
    USERNAME    => $session->param('user'),
    MODULE_NAVS => \@modules,
  );
  
  if (blessed($content) && $content->isa( 'Pms::BaseModule')) {
    $templParams{CONTENT}         = $content->renderContent($q);
    $templParams{MODULE_SUB_NAVS} = $content->navbarElements();
    $templParams{MODULE_SUB_NAME} = $content->name();
  }else{
    $templParams{CONTENT} = $content;
  }
  
  $template->param(\%templParams);
  $baseTemplate->param(CONTENT => $template->output);
  print $baseTemplate->output;
}


1;