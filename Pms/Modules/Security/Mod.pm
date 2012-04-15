#!/usr/bin/perl

package Pms::Modules::Security::Mod;

use strict;
use warnings;

use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::BaseModule;
use Pms::Session;
use HTML::Template;

our @ISA = ("Pms::BaseModule");

sub new{
  my $class = shift;
  my $self  = $class->SUPER::new();
  bless($self,$class);
  
  $self->{m_connection} = undef;
  return $self;
}

sub name{
  return "Sicherheit";
}

sub renderContent{
  my $self = shift or die "Need Ref";
  my $cgi  = shift or die "Need CGI";
  
  my $view = $cgi->param("view");
  if(defined $view){
    if($view == "addUser"){
      return $self->renderUserPage($cgi);
    }
    return $view;
  }
  return "YEEEEHAAA";
}

sub renderUserPage{
  my $self = shift or die "Need Ref";
  my $cgi  = shift or die "Need CGI";
  
  my $baseTemplate = HTML::Template->new(filename => 'Pms/Modules/Security/tmpl/addUser.tmpl');
  return $baseTemplate->output;
  
}

sub navbarElements{
  return [{
    NAME => "User bearbeiten",
    HREF => "module.pl?mod=Security;view=addUser"
  },{
    NAME => "Userrechte verwalten",
    HREF => "module.pl?mod=Security;view=userRoles"
  },{
    NAME => "Channelrechte verwalten",
    HREF => "module.pl?mod=Security;view=channelRoles"
  }];
}

1;