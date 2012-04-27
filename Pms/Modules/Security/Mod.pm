#!/usr/bin/perl -w
=begin nd

  Package: Pms::Modules::Security::Mod
  
  Description:
  
  This is the Main Object of the Admin-Interface Security Module. 
  
  It has 4 different Views, every View  is implemented in its own Backend, 
  
  and it uses Hashes to map the backend function names to the action and view
  parameters that are passed in the URL.
  
=cut

package Pms::Modules::Security::Mod;

use strict;
use warnings;
use JSON;

use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::BaseModule;
use Pms::Session;
use Pms::Modules::Security::User;
use Pms::Modules::Security::Channel;
use Pms::Modules::Security::UserRoles;
use Pms::Modules::Security::ChannelRoles;

our @ISA = ("Pms::BaseModule");

=begin nd
  hash: 
  maps the view names to the backend render callback functions
=cut
our %viewToBackend = (
  addUser    => \&Pms::Modules::Security::User::render,
  addChannel => \&Pms::Modules::Security::Channel::render,
  userRoles  => \&Pms::Modules::Security::UserRoles::render,
  channelRoles  => \&Pms::Modules::Security::ChannelRoles::render
);

=begin nd
  hash: 
  maps the view names to required javascript files
=cut
our %viewToScripts = (
  addUser    => [{
      LOCATION => "Pms/Modules/Security/js/user.js"
  }],
  addChannel => [{
      LOCATION => "Pms/Modules/Security/js/channel.js"
  }],
  userRoles  => [{
      LOCATION => "Pms/Modules/Security/js/userRoles.js"
  }],
  channelRoles  => [{
      LOCATION => "Pms/Modules/Security/js/channelRoles.js"
  }],  
);

=begin nd
  hash: 
  maps the action names, to the backend callback functions
=cut
our %actionToBackend = (
  saveUser   => \&Pms::Modules::Security::User::ajaxSaveUser,
  delUser    => \&Pms::Modules::Security::User::ajaxDelUser,
  changePass => \&Pms::Modules::Security::User::ajaxChangePass,
  getUsers   => \&Pms::Modules::Security::User::ajaxGetUsers,
  saveChannel=> \&Pms::Modules::Security::Channel::ajaxSaveChannel,
  delChannel => \&Pms::Modules::Security::Channel::ajaxDelChannel,
  getChannels => \&Pms::Modules::Security::Channel::ajaxGetChannels,
  getAvailableUserRoles => \&Pms::Modules::Security::UserRoles::ajaxGetAvailableUserRoles,
  getUserRoles => \&Pms::Modules::Security::UserRoles::ajaxGetUserRoles,
  addUserRole  => \&Pms::Modules::Security::UserRoles::ajaxAddUserRole,
  removeUserRole => \&Pms::Modules::Security::UserRoles::ajaxRemoveUserRole,
  getAvailableChannelRoles => \&Pms::Modules::Security::ChannelRoles::ajaxGetAvailableChannelRoles,
  getChannelRoles => \&Pms::Modules::Security::ChannelRoles::ajaxGetChannelRoles,
  addChannelRole  => \&Pms::Modules::Security::ChannelRoles::ajaxAddChannelRole,
  removeChannelRole => \&Pms::Modules::Security::ChannelRoles::ajaxRemoveChannelRole
);

=begin nd
  Constructor: new
  Initializes the Object , no arguments
=cut
sub new{
  my $class = shift;
  my $self  = $class->SUPER::new();
  bless($self,$class);
  
  $self->{m_connection} = undef;
  return $self;
}

=begin nd

  Function: name
  
  Reimplemented:
  See <Pms::BaseModule::name>
=cut
sub name{
  return "Sicherheit";
}

=begin nd

  Function: renderContent
  
  Reimplemented:
  See <Pms::BaseModule::renderContent>
=cut
sub renderContent{
  my $self = shift or die "Need Ref";
  my $cgi  = shift or die "Need CGI";
  
  my $view = $cgi->url_param("view");
  if(defined $view){
    if(!defined $viewToBackend{$view}){
      return "Unknown View";
    }
    return $viewToBackend{$view}->($cgi);
  }
  return "";
}

=begin nd

  Function: navbarElements
  
  Reimplemented:
  See <Pms::BaseModule::navbarElements>
=cut
sub navbarElements{
  return [{
    NAME => "User bearbeiten",
    HREF => "module.pl?mod=Security;view=addUser"
  },{
    NAME => "Userrechte verwalten",
    HREF => "module.pl?mod=Security;view=userRoles"
  },{
    NAME => "Channel verwalten",
    HREF => "module.pl?mod=Security;view=addChannel"
  },{
    NAME => "Channelrechte verwalten",
    HREF => "module.pl?mod=Security;view=channelRoles"
  }];
}

=begin nd

  Function: javascripts
  
  Reimplemented:
  See <Pms::BaseModule::javascripts>
=cut
sub javascripts{
  my $self = shift or die "Need Ref";
  my $view = shift;
  
  if(defined $viewToScripts{$view}){
    return $viewToScripts{$view};
  }
  return [];
}

=begin nd

  Function: dataRequest
  
  Reimplemented:
  See <Pms::BaseModule::dataRequest>
=cut
sub dataRequest{
  my $self = shift or die "Need Ref";
  my $cgi  = shift or die "Need CGI";
  
  my $action = $cgi->url_param('action');
  if(!defined $actionToBackend{$action}){
    return encode_json({
      result => 0,
      error  => "Unknown Action"
    });
  }
  return $actionToBackend{$action}->($cgi);
}
1;