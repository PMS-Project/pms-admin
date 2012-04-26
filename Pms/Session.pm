#!/usr/bin/perl -w
=begin nd

  Package: Pms::Session
  
  Description:
  
  This Package implements some helper functions for the 
  Session handling. 
  It uses some global Variables that are
  shared by all of the code anyway. 
  Also this variables
  live only as long as the request does.
  
  This Module is not object-oriented
  
=cut

package Pms::Session;

use strict;
use warnings;

use DBI;
use DBD::mysql;
use CGI::Session ( '-ip_match' );
use PmsConfig;

=begin nd
  variable:
  The last error-code
=cut
our $lastError = undef;

=begin nd
  variable:
  The current session object
=cut
my $session   = undef;

=begin nd
  variable:
  The current database connection
=cut
my $dbh       = undef;

=begin nd

  Function: get
  Returns the session object.
  If there is no current session object it tries to load 
  the session. If the loading fails the function will
  set the <$lastError> variable to a error code.
  
  Access: 
    Public
  
  Returns:
    *undef* in case of a error or 
    the CGI::Session object.
=cut
sub get {
  if(!defined $session){
    $session = CGI::Session->load(); 
    $lastError = undef;
    
    if($session->is_expired){
      $lastError = 1;
      return undef;
    }elsif($session->is_empty){
      $lastError = 3;
      return undef;
    }else{
      return $session;
    }
  }
  return $session;
}

=begin nd

  Function: databaseConnection
  Returns the dbh object.
  If there is no current database connection
  the function tries to create one.
  
  Access: 
    Public
  
  Returns:
    a DBI object
=cut
sub databaseConnection{
  if(!defined $dbh){
    # CONFIG VARIABLES
    my $platform = $PmsConfig::database{platform} or "mysql";
    my $database = $PmsConfig::database{database} or "pms";
    my $host     = $PmsConfig::database{host} or "localhost";
    my $port     = $PmsConfig::database{port} or "3306";
    my $user     = $PmsConfig::database{user} or "pms";
    my $pw       = $PmsConfig::database{password} or "secret";

    #DATA SOURCE NAME
    my $dsn = "dbi:$platform:$database:$host:$port";

    # PERL DBI CONNECT (RENAMED HANDLE)
    $dbh = DBI->connect($dsn, $user, $pw,{mysql_enable_utf8 => 1}) or die "Unable to connect: $DBI::errstr\n";
  }
  return $dbh;
}

=begin nd

  Function: errorMessage
  Converts the current error code in
  the <$lastError> var into a string.
  
  Access: 
    Public
  
  Returns:
    a string containing the last error message
=cut
sub errorMessage {
  my $code = shift or die "Need Error Code";
  
  if($code == 1){
    return "Session Timeout";    
  }elsif($code == 2){
    return "Wrong username or password";
  }elsif($code == 3){
    return "You  have to login first";
  }
  return "Unknown Error happened";
}
1;