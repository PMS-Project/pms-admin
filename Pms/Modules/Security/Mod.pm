#!/usr/bin/perl

package Pms::Modules::Security::Mod;

use strict;
use warnings;
use JSON;

use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::BaseModule;
use Pms::Session;
use HTML::Template;
use Data::Dumper;

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
  return "";
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
  }elsif($view eq "userRoles"){
    push(@scripts,{
      LOCATION => "Pms/Modules/Security/js/roles.js"
    });
  }elsif($view eq "userRoles"){
    push(@scripts,{
      LOCATION => "Pms/Modules/Security/js/channelRoles.js"
    });
  }
  return \@scripts;
}

sub dataRequest{
  my $self = shift or die "Need Ref";
  my $cgi  = shift or die "Need CGI";
  
  my $action = $cgi->url_param('action');
  if($action eq 'saveUser'){
    
    my $user = decode_json($cgi->param('POSTDATA'));
    
    my $dbh = Pms::Session::databaseConnection();
    if($user->{id} >= 0){
      my $sth = $dbh->prepare("UPDATE mod_security_users SET username = ?,forename = ?,name = ? where id = ?;");
      if($sth->execute($user->{nickName},$user->{firstName},$user->{name},$user->{id})){
        my $id = $user->{id};
        my %result = (
          result => 1,
          id => $id
        );
        return encode_json(\%result);
      }
    }else{
      my $sth = $dbh->prepare("INSERT into mod_security_users (username,forename,name) VALUES (?,?,?);");
      if($sth->execute($user->{nickName},$user->{firstName},$user->{name})){
        my $id = $dbh->last_insert_id(undef, undef, qw(mod_security_users id));
        my %result = (
          result => 1,
          id => $id
        );
        return encode_json(\%result);
      }
    }
    return encode_json({
      result => 0,
      error  => $DBI::errstr
    });
    
  }elsif($action eq 'delUser'){
    my $dbh  = Pms::Session::databaseConnection();
    my $user = decode_json($cgi->param('POSTDATA'));
    my $sth  = $dbh->prepare("DELETE from mod_security_users where id = ?;");
    if($sth->execute($user->{id})){
      my $id = $user->{id};
      return encode_json({
        result => 1
      });
    }else{
      return encode_json({
        result => 0,
        error  => $DBI::errstr
      });      
    }    
  }elsif($action eq 'getUsers'){
    my $dbh = Pms::Session::databaseConnection();
    my $sth = $dbh->prepare("SELECT id,username,forename,name from mod_security_users;");
    if($sth->execute()){
      my @users = ();
      while(my @val = $sth->fetchrow_array){
        my $hash = {
          id        => $val[0],
          nickName  => $val[1],
          name      => $val[3],
          firstName => $val[2]
        };
        push(@users,$hash);
      }
      return encode_json(\@users);
    }else{
      return encode_json({
        result => 0,
        error  => $DBI::errstr
      });      
    }
  }
  return encode_json({
    result => 0,
    error  => "Unknown Action"
  });
}
1;