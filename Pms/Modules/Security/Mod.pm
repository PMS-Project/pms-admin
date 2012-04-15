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
  
  my $view = $cgi->url_param("view");
  if(defined $view){
    if($view eq "addUser"){
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
  
  my @users = ();
  my $dbh = Pms::Session::databaseConnection();
  my $sth = $dbh->prepare("SELECT id,username,forename,name from mod_security_users;");
  if($sth->execute()){
    while(my @val = $sth->fetchrow_array){
      my $hash = {
        USER_ID       => $val[0],
        USER_NICKNAME => $val[1],
        USER_NAME     => $val[2],
        USER_FORENAME => $val[3],
      };
      push(@users,$hash);
    }
  }
  $baseTemplate->param(USERS => \@users);
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

sub javascripts{
  my $self = shift or die "Need Ref";
  my $view = shift;
  
  my @scripts = ();
  
  if($view eq "addUser"){
    push(@scripts,{
      LOCATION => "Pms/Modules/Security/js/user.js"
    });
  }
  return \@scripts;
}

1;