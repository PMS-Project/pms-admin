#!/usr/bin/perl -w
=begin nd

  Package: Pms::UserView
  
  Description:
  
  Implements the modulepage, for the administration-interface
  users. They are seperated from the chat users.
=cut

package Pms::UserView;

use strict;
use warnings;
use JSON;

use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::BaseModule;
use Pms::Session;

our @ISA = ("Pms::BaseModule");

our %actionToBackend = (
  saveUser   => \&ajaxSaveUser,
  delUser    => \&ajaxDelUser,
  changePass => \&ajaxChangePass,
  getUsers   => \&ajaxGetUsers,
);

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

  Function: name
  
  Reimplemented:
  See <Pms::BaseModule::name>
=cut
sub name{
  return "Userverwaltung";
}

=begin nd

  Function: renderContent
  
  Reimplemented:
  See <Pms::BaseModule::renderContent>
=cut
sub renderContent{
  my $baseTemplate = HTML::Template->new(filename => 'tmpl/addUser.tmpl',die_on_bad_params => 0);
  return $baseTemplate->output;
}

=begin nd

  Function: navbarElements
  
  Reimplemented:
  See <Pms::BaseModule::navbarElements>
=cut
sub navbarElements{
  return [];
}

=begin nd

  Function: javascripts
  
  Reimplemented:
  See <Pms::BaseModule::javascripts>
=cut
sub javascripts{
  return [{
      LOCATION => "js/userview.js"
  }];
}

=begin nd

  Function: dataRequest
  
  Reimplemented:
  See <Pms::BaseModule::dataRequest>
=cut
sub dataRequest{
  my $self = shift or die "Need Ref";
  my $cgi  = shift or die "Need CGI";
  
  my $action = $cgi->url_param('action');
  if(!defined $actionToBackend{$action}){
    return encode_json({
      result => 0,
      error  => "Unknown Action"
    });
  }
  return $actionToBackend{$action}->($cgi);
}

=begin nd

  Function: ajaxGetUsers
  Returns all currently available users in a json document
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxGetUsers {
    my $cgi  = shift or die "Need CGI";
    
    my $dbh = Pms::Session::databaseConnection();
    my $sth = $dbh->prepare("SELECT id,username,forename,name from pms_admins;");
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

=begin nd

  Function: ajaxDelUser
  Removes a user from the database.
  Returns a result json document.
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxDelUser {
    my $cgi  = shift or die "Need CGI";
    
    my $dbh  = Pms::Session::databaseConnection();
    my $user = decode_json($cgi->param('POSTDATA'));
    my $sth  = $dbh->prepare("DELETE from pms_admins where id = ?;");
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
}

=begin nd

  Function: ajaxSaveUser
  Inserts or Updates a user in the database.
  Returns the id of the user and a return value 
  as a JSON document.
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxSaveUser {
    my $cgi  = shift or die "Need CGI";
    my $user = decode_json($cgi->param('POSTDATA'));
    
    my $dbh = Pms::Session::databaseConnection();
    if($user->{id} >= 0){
      my $sth = $dbh->prepare("UPDATE pms_admins SET username = ?,forename = ?,name = ? where id = ?;");
      if($sth->execute($user->{nickName},$user->{firstName},$user->{name},$user->{id})){
        my $id = $user->{id};
        my %result = (
          result => 1,
          id => $id
        );
        return encode_json(\%result);
      }
    }else{
      my $sth = $dbh->prepare("INSERT into pms_admins (username,forename,name) VALUES (?,?,?);");
      if($sth->execute($user->{nickName},$user->{firstName},$user->{name})){
        my $id = $dbh->last_insert_id(undef, undef, qw(pms_admins id));
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
}

=begin nd

  Function: ajaxChangePass
  Changes the password of a user in the database.
  Returns a JSON document containing the result
  of the operation.
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxChangePass{
    my $cgi  = shift or die "Need CGI";
    my $dbh  = Pms::Session::databaseConnection();
    my $pass = decode_json($cgi->param('POSTDATA'));
    my $sth  = $dbh->prepare("UPDATE pms_admins set password = ? where id = ?;");
    my $rowsAffected = $sth->execute($pass->{password},$pass->{id});
    if($rowsAffected){
      if($rowsAffected > 0){
        return encode_json({
          result => 1
        });
      }else{
        return encode_json({
        result => 0,
        error  => "Record not found"
        });
      }
    }else{
      return encode_json({
        result => 0,
        error  => $DBI::errstr
      });      
    }
}