#!/usr/bin/perl -w
=begin nd

  Package: Pms::Modules::Security::User
  
  Description:
  This is the Implementation of the UserEdit View Backend. 
  This module is not Object based. All Methods can be used 
  directly. 
=cut

package Pms::Modules::Security::User;

use strict;
use warnings;
use JSON;

use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::BaseModule;
use Pms::Session;
use HTML::Template;

=begin nd

  Function: render
  Creates the html code of the user-edit view
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *html-string*
=cut
sub render{
  my $cgi   = shift or die "Need CGI";
  
  my $baseTemplate = HTML::Template->new(filename => 'Pms/Modules/Security/tmpl/addUser.tmpl',die_on_bad_params => 0);
  return $baseTemplate->output;
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
    my $sth  = $dbh->prepare("UPDATE mod_security_users set password = ? where id = ?;");
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

1;