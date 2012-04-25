#!/usr/bin/perl -w

package PmsConfig;

use strict;

our %database = (
    platform => "mysql",
    database => "pms",
    host     => "localhost",
    port     => "3306",
    user     => "pms",
    password => "secret"
);

our @modules = (
  {
    fqn      => "Security",
    name     => "Sicherheit",
    view     => "addUser"
  }
); 
return 1;