#!/usr/bin/perl -w

package PmsConfig;

use strict;

our @modules = (
  {
    fqn      => "Database",
    name     => "Datenbank"
  },
  {
    fqn      => "Backlog",
    name     => "Backlog"
  },
  {
    fqn      => "Motd",
    name     => "Motd"
  },
  {
    fqn      => "Security",
    name     => "Sicherheit"
  }
); 
return 1;