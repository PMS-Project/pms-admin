package Pms::Modules::Security::ChannelRoles;

use strict;
use warnings;
use JSON;

use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI::Session ( '-ip_match' );

use Pms::BaseModule;
use Pms::Session;
use HTML::Template;

sub render{
  my $cgi   = shift or die "Need CGI";
  
  my $baseTemplate = HTML::Template->new(filename => 'Pms/Modules/Security/tmpl/channelRoles.tmpl',die_on_bad_params => 0);
  return $baseTemplate->output;
}

sub ajaxGetAvailableChannelRoles{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $sth = $dbh->prepare("SELECT id,name,description from mod_security_channelRoles;");
  if($sth->execute()){
    my @roles = ();
    while(my @val = $sth->fetchrow_array){
      my $hash = {
        id          => $val[0],
        name        => $val[1],
        description => $val[2]
      };
      push(@roles,$hash);
    }
    return encode_json(\@roles);
  }else{
    return encode_json({
      result => 0,
      error  => $DBI::errstr
    });      
  }
}

sub ajaxGetChannelRoles{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $req = decode_json($cgi->param('POSTDATA'));
  my $sth = $dbh->prepare("SELECT roleRef from mod_security_user_to_channelRole where userRef = ? and channelRef = ?;");
  if($sth->execute($req->{userRef},$req->{channelRef})){
    my @roles = ();
    while(my @val = $sth->fetchrow_array){
      my $hash = {
        roleRef => $val[0]
      };
      push(@roles,$hash);
    }
    return encode_json(\@roles);
  }else{
    return encode_json({
      result => 0,
      error  => $DBI::errstr
    });      
  }  
}

sub ajaxAddChannelRole{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $req = decode_json($cgi->param('POSTDATA'));
  my $sth = $dbh->prepare("INSERT into mod_security_user_to_channelRole (userRef,channelRef,roleRef) VALUES (?,?,?);");
  if($sth->execute($req->{userRef},$req->{channelRef},$req->{roleRef})){
    my %result = (
      result => 1
    );
    return encode_json(\%result);
  }
  return encode_json({
      result => 0,
      error  => $DBI::errstr
  });
}

sub ajaxRemoveChannelRole{
  my $cgi  = shift or die "Need CGI";
  
  my $dbh = Pms::Session::databaseConnection();
  my $req = decode_json($cgi->param('POSTDATA'));
  my $sth = $dbh->prepare("DELETE from mod_security_user_to_channelRole where userRef=? and roleRef=? and channelRef=?;");
  if($sth->execute($req->{userRef},$req->{roleRef},$req->{channelRef})){
    my %result = (
      result => 1
    );
    return encode_json(\%result);
  }
  return encode_json({
      result => 0,
      error  => $DBI::errstr
  });  
}
1;