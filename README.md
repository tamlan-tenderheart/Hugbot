# Hugbot
A hug-powered, buff-dispensing bot for Dark Age of Camelot
This little project is the fulfillment of an idea I've had for a long time in Dark Age of Camelot; to create a bot that responds to other players emotes (specifically hugs) by giving them buffs.

While I claim this bot is complete enough for my tastes, I am an endless tinkerer and will prolly make minor (or even major) enhancements and changes to it as time goes by.

Caution: Many DAOC freeshards do not allow unattended gameplay (bots), and so the use of this bot on those shards would be against the server rules. Please make sure you understand the rules for the shard you are playing on w.r.t. bot use. I am not responsible for any losses you incur from the use of this bot code. The code for this bot is for educational purposes only; I make no guarantees about the quality or fitness of this code. You have been warned!

This script uses AutoHotKey (https://www.autohotkey.com). You must have AHK installed in order to use this script.

This script uses Capture2Text (https://sourceforge.net/projects/capture2text). You must have C2T installed in order to use this script.

## DAOC Bots

If you are familiar with Dark of Age Camelot, you know that in order to write bots you have to be able to get feedback from the game. This is accomplished in one of three main ways: 1) Log scraping, 2) Screen scraping, or 3) Direct memory access.

Log scraping has the disadvantage of being clunky because the client doesn't do continuous logging. Instead, it buffers the logs and writes them out when the buffer is full to a temp file, or to the actual logfile when logging is terminated. What this means is a logscraping bot must continually start and stop the logging process before it can process game events (which essentially amounts to polling).

Direct memory access is the most reliable, but this kind of bot is generally frowned upon on most freeshards and on Live as direct memory access is also the mechanic employed by game cheats and hacks, most of which are detectable and identified as a hack. Such bots can get your accounts permanently banned on many shards.

Screen scraping is the way that this bot works. Essentially, once the bot is started, it periodically scans a region of the screen which contains the in-game event and chat log. A picture of this region is sent to an OCR tool which converts the picture to actual text. The text is then returned to the bot and can be parsed for events of interest. There are many details to consider with a bot of this nature, like polling period, re-reading old events, latency in processing the screen snippet, etc. For details on how some of these issues are addressed, please see the source code.
