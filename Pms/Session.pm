#!/usr/bin/perl

package Pms::Session;

use strict;
use warnings;

use CGI::Session ( '-ip_match' );

our $lastError;

sub restore {
  my $session = CGI::Session->load();
  
  $lastError = undef;
  
  if($session->is_expired){
    $lastError = 0;
    return undef;
  }
  elsif($session->is_empty){
    $lastError = 1;
    return undef;
  }
  else
  {
    return $session;
  }
  
}

sub errorMessage {
  my $code = shift or die "Need Error Code";
  
  if($code == 0){
    return "Session Timeout";    
  }elsif($code == 1){
    return "Wrong username or password";
  }
  return "Unknown Error happened";
}
1;