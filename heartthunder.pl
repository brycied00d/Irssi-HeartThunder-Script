#!/usr/bin/perl

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

$VERSION = "1.1";
%IRSSI = (
    authors     => 'Bryce Chidester',
    contact     => 'bryce@cobryce.com',
    name        => 'heartthunder',
    description => 'Will prefix all messages with the prescribed "<3 thunder" when joined to #<3thunder',
    license     => 'GNU GPLv2',
    url         => 'http://www.cobryce.com/heartthunder',
    changed     => 'Sun Jan 1 18:18:55 2012',
);

#
# README:
# I originally wrote this script to make #<3thunder dead-simple. Any message you send in #<3thunder
# will be appropriately spaced and prefixed with the 15-length(nick) and <3 thunder.
#
# Settings:
# There are several settings that you can modify, although the defaults should be perfect.
# heartthunder_channels - What channel(s) to act upon. Separate multiple with a | (pipe)
#                         Default: #<3thunder
# heartthunder_prefix - What to prefix your messages with
#                       Default: <3 thunder
# heartthunder_spacing - The spacing rule. This is used in "spacing-length(nick)"
#                        Default: 15
# heartthunder_me_as_action - Whether to send /me messages as /me (ACTION) or as a regular
#                             message with "/me" inserted. 
#                             Default: Yes (ACTION)
# heartthunder_debug - Turn on debugging messages to your window. You probably shouldn't care,
#                      unless heartthunder_channels isn't working/matching right.
#                      Default: Off
#
# TODO:
# I don't know... what's left to do?
#
# Changelog:
# v1.1
# * Change heartthunder_channels into a pipe-separated list, matched regex-style
# * Support /me ACTION as well. (Either as a /me, or just "<3 thunder /me ...")
#

# flag variable
my $spaced=0;

sub sig_command_msg {
	my ($cmd, $server, $winitem) = @_;
	my ( $param, $target, $data) = $cmd =~ /^(-\S*\s)?(\S*)\s(.*)/;
	return unless $winitem;
	# $winitem (window item) may be undef.
	$winitem->print('sig_command_msg called, spaced='.$spaced) if Irssi::settings_get_bool('heartthunder_debug');

	# Super-debug
	#$winitem->print('<3thunder settings: debug='.Irssi::settings_get_bool('heartthunder_debug'));
	#$winitem->print('<3thunder settings: channels='.Irssi::settings_get_str('heartthunder_channels'));
	
	$winitem->print('<3thunder test: channels='.Irssi::settings_get_str('heartthunder_channels').' target='.$target) if Irssi::settings_get_bool('heartthunder_debug');
	return unless ($target =~ Irssi::settings_get_str('heartthunder_channels'));
	
	if(!$spaced)
	{
		$winitem->print('Spaced is un-set, spacing...') if Irssi::settings_get_bool('heartthunder_debug');
		# Save off the signal we were called with, then calculate the spacing.
		my $emitted_signal = Irssi::signal_get_emitted();
		my $spaces = Irssi::settings_get_int('heartthunder_spacing') - length($server->{nick});
		if(Irssi::settings_get_bool('heartthunder_debug'))
		{
			$winitem->print('HeartThunder! Raw cmd='.$cmd);
			$winitem->print('HeartThunder! emitted_signal='.$emitted_signal);
			$winitem->print('HeartThunder! Parsed param='.$param);
			$winitem->print('HeartThunder! Parsed target='.$target);
			$winitem->print('HeartThunder! Parsed data='.$data);
			$winitem->print('HeartThunder! Calculated spaces='.$spaces);
		}
		# Flag the flag
		$spaced=1;
		# Re-emit the signal...
		Irssi::signal_emit("$emitted_signal", "$target ".sprintf("%".$spaces."s", " ").Irssi::settings_get_str('heartthunder_prefix')." $data", $server, $winitem);
		# Reset the flag after we've re-emitted the modified signal
		$spaced=0;
		# Everything done.
		Irssi::signal_stop();
	}
}


sub sig_command_me {
	my ($data, $server, $winitem) = @_;
	# $data is everything after /me
	my $target = $winitem->{name};	# This is the channel name
	return unless $winitem;
	# $winitem (window item) may be undef.
	$winitem->print('sig_command_me called, spaced='.$spaced) if Irssi::settings_get_bool('heartthunder_debug');
	$winitem->print('sig_command_me called: data='.$data) if Irssi::settings_get_bool('heartthunder_debug');

	# Super-debug
	#$winitem->print('<3thunder settings: debug='.Irssi::settings_get_bool('heartthunder_debug'));
	#$winitem->print('<3thunder settings: channels='.Irssi::settings_get_str('heartthunder_channels'));
	
	$winitem->print('<3thunder test: channels='.Irssi::settings_get_str('heartthunder_channels').' data="'.$data.'" target='.$target) if Irssi::settings_get_bool('heartthunder_debug');
	return unless ($target =~ Irssi::settings_get_str('heartthunder_channels'));
	
	if(!$spaced)
	{
		$winitem->print('Spaced is un-set, spacing...') if Irssi::settings_get_bool('heartthunder_debug');
		# Save off the signal we were called with, then calculate the spacing.
		my $emitted_signal = Irssi::signal_get_emitted();
		my $spaces = Irssi::settings_get_int('heartthunder_spacing') - length($server->{nick});
		if(Irssi::settings_get_bool('heartthunder_debug'))
		{
			$winitem->print('HeartThunder! Raw data='.$data);
			$winitem->print('HeartThunder! emitted_signal='.$emitted_signal);
			$winitem->print('HeartThunder! Parsed target='.$target);
			$winitem->print('HeartThunder! Calculated spaces='.$spaces);
		}
		# Flag the flag
		$spaced=1;
		# Re-emit the signal...
		if(Irssi::settings_get_bool('heartthunder_me_as_action'))
		{
			Irssi::signal_emit("$emitted_signal", sprintf("%".$spaces."s", " ").Irssi::settings_get_str('heartthunder_prefix')." $data", $server, $winitem);
		} else
		{
			Irssi::signal_emit("command msg", "$target ".sprintf("%".$spaces."s", " ").Irssi::settings_get_str('heartthunder_prefix')." /me $data", $server, $winitem);
		}
		# Reset the flag after we've re-emitted the modified signal
		$spaced=0;
		# Everything done.
		Irssi::signal_stop();
	}
}


# Normal "blah blah" messages
Irssi::command_bind('msg', 'sig_command_msg');
# Action messages, e.g. "/me ate a cantaloupe"
Irssi::command_bind('me', 'sig_command_me');

# Default debug=0
Irssi::settings_add_bool('heartthunder', 'heartthunder_debug', 0);
# Default channels=#<3thunder
Irssi::settings_add_str('heartthunder', 'heartthunder_channels', '#<3thunder');
# Default prefix="<3 thunder"
Irssi::settings_add_str('heartthunder', 'heartthunder_prefix', '<3 thunder');
# Default spacing=15
Irssi::settings_add_int('heartthunder', 'heartthunder_spacing', 15);
# Default /me as ACTION
Irssi::settings_add_bool('heartthunder', 'heartthunder_me_as_action', 1);
