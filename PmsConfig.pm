#!/usr/bin/perl -w

package PmsConfig;

use strict;

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