#!/usr/bin/perl -w
=begin nd
  Package: Pms::Modules::Security::UserRoles
  
  Description:
  This is the Implementation of the UserEdit View Backend. 
  This module is not Object based. All Methods can be used 
  directly. 
=cut

package Pms::Modules::Security::UserRoles;

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
  Creates the html code of the user-roles-edit view
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *html-string*
=cut
sub render{
  my $cgi   = shift or die "Need CGI";
  
  my $baseTemplate = HTML::Template->new(filename => 'Pms/Modules/Security/tmpl/userRoles.tmpl',die_on_bad_params => 0);
  return $baseTemplate->output;
}

=begin nd

  Function: ajaxGetAvailableUserRoles
  Returns all currently available user roles in a
  json document.
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxGetAvailableUserRoles{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $sth = $dbh->prepare("SELECT id,name,description from mod_security_roles;");
  if($sth->execute()){
    my @roles = ();
    while(my @val = $sth->fetchrow_array){
      my $hash = {
        id          => $val[0],
        name        => $val[1],
        description => $val[2]
      };
      push(@roles,$hash);
    }
    return encode_json(\@roles);
  }else{
    return encode_json({
      result => 0,
      error  => $DBI::errstr
    });      
  }
}

=begin nd

  Function: ajaxGetUserRoles
  Returns all user roles currently assigned to 
  a user in a json document
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxGetUserRoles{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $req = decode_json($cgi->param('POSTDATA'));
  my $sth = $dbh->prepare("SELECT roleRef from mod_security_user_to_roles where userRef = ?;");
  if($sth->execute($req->{userRef})){
    my @roles = ();
    while(my @val = $sth->fetchrow_array){
      my $hash = {
        roleRef => $val[0]
      };
      push(@roles,$hash);
    }
    return encode_json(\@roles);
  }else{
    return encode_json({
      result => 0,
      error  => $DBI::errstr
    });      
  }  
}

=begin nd

  Function: ajaxAddUserRole
  Adds a user-role to the roleset of a user
  and returns the result as a JSON document
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxAddUserRole{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $req = decode_json($cgi->param('POSTDATA'));
  my $sth = $dbh->prepare("INSERT into mod_security_user_to_roles (userRef,roleRef) VALUES (?,?);");
  if($sth->execute($req->{userRef},$req->{roleRef})){
    my %result = (
      result => 1
    );
    return encode_json(\%result);
  }
  return encode_json({
      result => 0,
      error  => $DBI::errstr
  });
}

=begin nd

  Function: ajaxRemoveUserRole
  Removes a user-role from the roleset of a user
  and returns the result as a JSON document
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxRemoveUserRole{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $req = decode_json($cgi->param('POSTDATA'));
  my $sth = $dbh->prepare("DELETE from mod_security_user_to_roles where userRef=? and roleRef=?;");
  if($sth->execute($req->{userRef},$req->{roleRef})){
    my %result = (
      result => 1
    );
    return encode_json(\%result);
  }
  return encode_json({
      result => 0,
      error  => $DBI::errstr
  });  
}


1;