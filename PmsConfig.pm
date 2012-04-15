#!/usr/bin/perl -w

package PmsConfig;

use strict;

our @modules = (
  {
    fqn      => "Database",
    name     => "Datenbank"
  },
  {
    fqn      => "Backlog::Mod",
    name     => "Backlog"
  },
  {
    fqn      => "Pms::Modules::Motd::Mod",
    name     => "Motd"
  },
  {
    fqn      => "Pms::Modules::Security::Mod",
    name     => "Sicherheit"
  }
); 
return 1;