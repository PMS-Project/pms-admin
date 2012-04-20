#!/usr/bin/perl

package Pms::BaseModule;

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::Session;
use HTML::Template;

sub new{
  my $class = shift;
  my $self = {};
  bless($self,$class);
  
  return $self;
}

sub name{
  die "Abstract Function";
}

sub renderContent{
  die "Abstract Function";
}

sub navbarElements{
  die "Abstract Function";
}

sub javascripts{
  die "Abstract Function";
}

sub dataRequest{
  die "Abstract Function";
}

1;