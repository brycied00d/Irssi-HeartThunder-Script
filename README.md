Irssi HeartThunder Script
=========================

This Irssi script handles all the formatting/spacing needed for the #<3thunder IRC channel (on Foonetic). Just chat as normal and everything that gets sent to the channel will be appropriately spaced and prefixed with the 15-length(nick) and `<3 thunder`.

If you have problems, open an issue (or fork/patch/pull-request) :)


Install
-------
To install, just drop the script (the `heartthunder.pl` file) into your Irssi scripts folder (e.g. `$HOME/.irssi/scripts/`). Then load it with
    
    /load script heartthunder.pl

You should be good to go with the default settings (explained below). Just start chatting in #<3thunder and everything will be formatted automatically.

### Auto load
To automatically load the script with irssi, create a symbolic link to the script file in your `$HOME/.irssi/scripts/autorun/` directory

    ln -s $HOME/.irssi/scripts/heartthunder.pl $HOME/.irssi/scripts/autorun/heartthunder.pl


Settings
--------
There are several settings that you can modify, although the defaults should be perfect.

* _heartthunder\_channels_ - What channel to act upon. Separate multiple with a | (pipe)
                           - Default: `#<3thunder`
* _heartthunder\_prefix_ - What to prefix your messages with
                         - Default: `<3 thunder`
* _heartthunder\_spacing_ - The spacing rule. This is used in "spacing-length(nick)"
                          - Default: `15`
* _heartthunder\_me\_as\_action_ - Whether to send /me messages as /me (ACTION) or as a regular message with "/me" inserted.
                                 - Default: `Yes (ACTION)`
* _heartthunder\_debug_ - Turn on debugging messages to your window. You probably shouldn't care, unless heartthunder_channels isn't working/matching right.
                        - Default: `Off`

To change a setting, use the `/set` Irssi command. 

    /set heartthunder_channels #<3hunder|#otherchannel


Footnote
--------
For more information, specifically on what "<3 thunder" means, its origins, and silly little things like that, please consult the XKCD wiki: http://wiki.xkcd.com/irc/Heart_Thunder

