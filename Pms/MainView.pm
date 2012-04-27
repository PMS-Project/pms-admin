#!/usr/bin/perl -w
=begin nd

  Package: Pms::MainView
  
  Description:
  
  The MainView of the admin interface. This
  class renders the navigation containers and does
  the basic layout of the UI. 
  It can either render a string, or the contents
  of a BaseModule into a container defined in the
  HTML index.tmpl template file.
=cut

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

=begin nd
  Constructor: new
  Initializes the Object , no arguments
=cut
sub new{
  my $class = shift;
  my $self = {};
  bless($self,$class);
  
  return $self;
}

=begin nd

  Function: render
  Renders the page into HTML and writes it into a string
  
  Access: 
    Public
  
  Parameters:
    $content - a string containing the content HTML code, 
               or a module reference to a <Pms::BaseModule> subclass
    
  Returns:
    a string containing HTML code
=cut
sub render{
  my $self = shift or die "Need Ref";
  my $content = shift or die "Need Content Module";
  my $q       = shift or die "Need CGI Query";
  
  my $session = Pms::Session::get();
  #this should never happen just to be shure
  if(!$session){
    print $session->header(-location=>'index.pl');
    return;
  }
  
  print $q->header(-cache_control=>"no-cache, no-store, must-revalidate");
  
  my $baseTemplate = HTML::Template->new(filename => 'tmpl/base.tmpl');
  my $template     = HTML::Template->new(filename => 'tmpl/index.tmpl');
  
  my @modules = ();
  foreach my $curr (@PmsConfig::modules){
    my $modConf = {
      NAME => $curr->{name},
      HREF => "module.pl?mod=".$curr->{fqn}.";view=".$curr->{view}
    };
    push(@modules,$modConf);
  }
  
  my %templParams = (
    USERNAME    => $session->param('user'),
    MODULE_NAVS => \@modules,
  );
  
  #check if we got a Pms::BaseModule subclass
  if (blessed($content) && $content->isa( 'Pms::BaseModule')) {
    $templParams{CONTENT}         = $content->renderContent($q);
    $templParams{MODULE_SUB_NAVS} = $content->navbarElements();
    $templParams{MODULE_SUB_NAME} = $content->name();
    $baseTemplate->param(MODULE_SCRIPTS => $content->javascripts($q->url_param('view')));
  }else{
    $templParams{CONTENT} = $content;
  }
  
  $template->param(\%templParams);
  $baseTemplate->param(CONTENT => $template->output);
  print $baseTemplate->output;
}


1;