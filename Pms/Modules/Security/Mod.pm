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
      return $self->renderUserPage($cgi,'Pms/Modules/Security/tmpl/addUser.tmpl');
    }
    return $view;
  }
  return "YEEEEHAAA";
}

sub renderUserPage{
  my $self  = shift or die "Need Ref";
  my $cgi   = shift or die "Need CGI";
  my $templ = shift or die "Need Template Path";
  
  my $baseTemplate = HTML::Template->new(filename => $templ,die_on_bad_params => 0);
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

sub dataRequest{
  my $self = shift or die "Need Ref";
  my $cgi  = shift or die "Need CGI";
  
  my $action = $cgi->url_param('action');
  if($action eq 'saveUser'){
    
  }elsif($action eq 'delUser'){
    
  }elsif($action eq 'getUsers'){
      my $baseTemplate = HTML::Template->new(filename => 'Pms/Modules/Security/tmpl/GetUsers.tmpl.json',
                                             die_on_bad_params => 0
      );
  
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
            LAST_ELEMENT  => 0
          };
          push(@users,$hash);
        }
        if(@users){
          $users[-1]->{LAST_ELEMENT} = 1;
        }
      }
      $baseTemplate->param(USERS => \@users);
      return $baseTemplate->output;
  }
  return "{}";
}
1;