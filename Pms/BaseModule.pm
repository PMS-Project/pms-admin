#!/usr/bin/perl -w
=begin nd

  Interface: Pms::BaseModule
  
  Description:
  
  This is the Baseclass for all moduls/plugins that want
  to integrate into the PMS admin interface.
  It defines a unified API to make the implementation easy.
  
=cut

package Pms::BaseModule;

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::Session;
use HTML::Template;

=begin nd
  Constructor: new
  Initializes the Object , no arguments
=cut
sub new{
  my $class = shift;
  my $self = {};
  bless($self,$class);
  
  return $self;
}


=begin nd

  Function: name
  Returns the name of the Module.
  This is used as the Header of the Navbar created for the module.
  
  Note:
    Its required to reimplement this function or the application will die
  
  Access: 
    Public
  
  Parameters:
    none
    
  Returns:
    a string containing the module name
=cut
sub name{
  die "Abstract Function";
}

=begin nd

  Function: renderContent
  Creates and returns the Views HTML code, which will be 
  embedded by the calling View.
 
  Note:
    Its required to reimplement this function or the application will die
  
  Access: 
    Public
  
  Parameters:
    $cgi - the current CGI request object
    
  Returns:
    a string containing HTML code
=cut
sub renderContent{
  die "Abstract Function";
}

=begin nd

  Function: navbarElements
  This method should returns a array of hashes containing all navbar
  elements needed by the module:
  (start code)
  sub navbarElements{
    return [{
      NAME => "User bearbeiten",
      HREF => "module.pl?mod=Security;view=addUser"
    },{
      NAME => "Userrechte verwalten",
      HREF => "module.pl?mod=Security;view=userRoles"
    }];
  }
  (end code)
 
  Note:
    Its required to reimplement this function or the application will die
  
  Access: 
    Public
  
  Parameters:
    none
    
  Returns:
    a *array* reference
=cut
sub navbarElements{
  die "Abstract Function";
}

=begin nd

  Function: javascripts
  This method should return a array of hashes containing all javascript
  files required by the module.
  (start code)
  sub javascripts{
    my $self = shift or die "Need Ref";
    my $view = shift;
    if($view eq "view1"){
      return [{
        LOCATION => "view1.js"
      }];
    }
  }
  (end code)
 
  Note:
    Its required to reimplement this function or the application will die
  
  Access: 
    Public
  
  Parameters:
    $view - the name of the requested module-view
    
  Returns:
    a *array* reference
=cut
sub javascripts{
  die "Abstract Function";
}

=begin nd

  Function: dataRequest
  This method is called if the action parameter is set in the URL.
  It should return a string containing a JSON document with the requested 
  data. 
 
  Note:
    Its required to reimplement this function or the application will die
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *array* reference
=cut
sub dataRequest{
  die "Abstract Function";
}

1;