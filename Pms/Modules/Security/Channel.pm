#!/usr/bin/perl -w
=begin nd

  Package: Pms::Modules::Security::Channel
  
  Description:
  
  This is the Implementation of the ChannelEdit View Backend. 
  This module is not Object based. All Methods can be used 
  directly.
  
=cut

package Pms::Modules::Security::Channel;

use strict;
use warnings;
use JSON;

use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::BaseModule;
use Pms::Session;
use HTML::Template;

=begin nd

  Function: render
  Creates the html code of the channel-edit view
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *html-string*
=cut
sub render{
  my $cgi   = shift or die "Need CGI";
  
  my $baseTemplate = HTML::Template->new(filename => 'Pms/Modules/Security/tmpl/addChannel.tmpl',die_on_bad_params => 0);
  return $baseTemplate->output;
}

=begin nd

  Function: ajaxGetChannels
  Returns all currently available channels in a
  json document.
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxGetChannels {
    my $cgi  = shift or die "Need CGI";
    
    my $dbh = Pms::Session::databaseConnection();
    my $sth = $dbh->prepare("SELECT id,name,topic from mod_security_channels;");
    if($sth->execute()){
      my @channels = ();
      while(my @val = $sth->fetchrow_array){
        my $hash = {
          id        => $val[0],
          name      => $val[1],
          topic     => $val[2]
        };
        push(@channels,$hash);
      }
      return encode_json(\@channels);
    }else{
      return encode_json({
        result => 0,
        error  => $DBI::errstr
      });      
    }
}

=begin nd

  Function: ajaxDelChannel
  Removes a channel from the database,
  it requires a JSON document in the POSTDATA
  element of the CGI request
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxDelChannel {
    my $cgi  = shift or die "Need CGI";
    
    my $dbh  = Pms::Session::databaseConnection();
    my $channel = decode_json($cgi->param('POSTDATA'));
    my $sth  = $dbh->prepare("DELETE from mod_security_channels where id = ?;");
    if($sth->execute($channel->{id})){
      my $id = $channel->{id};
      return encode_json({
        result => 1
      });
    }else{
      return encode_json({
        result => 0,
        error  => $DBI::errstr
      });      
    }   
}

=begin nd

  Function: ajaxSaveChannel
  Inserts or updates a chennel record in the 
  database, depending on the id field in the request.
  
  Access: 
    Public
  
  Parameters:
    $cgi - reference to the current CGI request object
    
  Returns:
    a *json-string*
=cut
sub ajaxSaveChannel {
    my $cgi  = shift or die "Need CGI";
    my $channel = decode_json($cgi->param('POSTDATA'));
    
    my $dbh = Pms::Session::databaseConnection();
    if($channel->{id} >= 0){
      my $sth = $dbh->prepare("UPDATE mod_security_channels SET name = ?,topic = ? where id = ?;");
      if($sth->execute($channel->{name},$channel->{topic},$channel->{id})){
        my $id = $channel->{id};
        my %result = (
          result => 1,
          id => $id
        );
        return encode_json(\%result);
      }
    }else{
      my $sth = $dbh->prepare("INSERT into mod_security_channels (name,topic) VALUES (?,?);");
      if($sth->execute($channel->{name},$channel->{topic})){
        my $id = $dbh->last_insert_id(undef, undef, qw(mod_security_channels id));
        my %result = (
          result => 1,
          id => $id
        );
        return encode_json(\%result);
      }
    }
    return encode_json({
      result => 0,
      error  => $DBI::errstr
    });
}

1;