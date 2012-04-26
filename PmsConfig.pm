#!/usr/bin/perl -w

=begin nd

  Package: PmsConfig
  
  Description:
  This is the configuration file of the pms-admin interface.
  It is written and perl and is directly interpreted by the
  application.
  
  You can configure the database connection, and which modules are 
  loaded into the UI.
=cut

package PmsConfig;

use strict;

=begin nd
  variable: %database
  
  A hash containing the database connection
  informations
=cut
our %database = (
    platform => "mysql",
    database => "pms",
    host     => "localhost",
    port     => "3306",
    user     => "pms",
    password => "secret"
);

=begin nd
  variable: @modules
  
  A array of hashes, each hash describes a 
  other module that is loaded into the 
  Interface.
  
  A module hash needs the following elements:
  fqn  - the directory of the module
  name - the name of the module shown in the UI
  view - the start view of the module, if the module is choosen in 
         the gui this will be the first rendered page
=cut
our @modules = (
  {
    fqn      => "Security",
    name     => "Sicherheit",
    view     => "addUser"
  }
); 
return 1;