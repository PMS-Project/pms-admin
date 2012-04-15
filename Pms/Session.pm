#!/usr/bin/perl

package Pms::Session;

use strict;
use warnings;

use DBI;
use DBD::mysql;
use CGI::Session ( '-ip_match' );

our $lastError = undef;
our $session   = undef;
our $dbh = undef;

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

sub databaseConnection{
  if(!defined $dbh){
    # CONFIG VARIABLES
    my $platform = "mysql";
    my $database = "pms";
    my $host     = "localhost";
    my $port     = "3306";
    my $user     = "pms";
    my $pw       = "secret";

    #DATA SOURCE NAME
    my $dsn = "dbi:$platform:$database:$host:$port";

    # PERL DBI CONNECT (RENAMED HANDLE)
    $dbh = DBI->connect($dsn, $user, $pw) or die "Unable to connect: $DBI::errstr\n";
  }
  return $dbh;
}

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