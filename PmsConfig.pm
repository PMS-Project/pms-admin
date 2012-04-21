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
    fqn      => "Database",
    name     => "Datenbank",
    view     => ""
  },
  {
    fqn      => "Backlog",
    name     => "Backlog",
    view     => ""
  },
  {
    fqn      => "Motd",
    name     => "Motd",
    view     => ""
  },
  {
    fqn      => "Security",
    name     => "Sicherheit",
    view     => "addUser"
  }
); 
return 1;