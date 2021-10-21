# Hugbot
A hug-powered, buff-dispensing bot for Dark Age of Camelot
This little project is the fulfillment of an idea I've had for a long time in Dark Age of Camelot; to create a bot that responds to other players emotes (specifically hugs) by giving them buffs.

While I claim this bot is complete enough for my tastes, I am an endless tinkerer and will prolly make minor (or even major) enhancements and changes to it as time goes by.

Caution: Many DAOC freeshards do not allow unattended gameplay (bots), and so the use of this bot on those shards would be against the server rules. Please make sure you understand the rules for the shard you are playing on w.r.t. bot use. I am not responsible for any losses you incur from the use of this bot code. The code for this bot is for educational purposes only; I make no guarantees about the quality or fitness of this code. You have been warned!

Because the server that I am currently playing on does not allow bots, I have updated the code to include a "macro mode" for handing out buffs (The F1 and F2 functions).

This script uses AutoHotKey (https://www.autohotkey.com). You must have AHK installed in order to use this script.

This script uses Capture2Text (https://sourceforge.net/projects/capture2text). You must have C2T installed in order to use this script.

## How to use this Bot
The bot has three operational modes: manual, semi-automated, and fully automated.
* The manual mode of operation requires you to manually target the player you wish to buff and then press a key to send them a full load of buffs. Hugs are not necessary to use this mode!
* The semi-autonomous mode of operation does not require you to manually target the players. All players whose hugs are registered on-screen when you hit the button will receive a full load of buffs. You have to press the button each time to process the current on-screen log.
* The fully autonomous mode of operation requires no interaction from the user. Once the session is started, the script scans the on-screen log and sends buffs to everyone that /hug ed the player. Once the cycle of buffs is complete, it will pause for a moment before starting another scan. It will continue to operate until the session is closed.
### To run the bot in manual-mode
  1. Target player in-game you wish to buff and then do one of the following:
     a. Press F1 to send buffs to the player.
     a. Press F2 to send a random thank you to the player, followed by sending them buffs.
### To run the bot in semi-automated mode
  1. Do the following two steps once each time you load the script:
     a. Place the mouse pointer at the top-left-most point of the combat log and press F3.
     a. Place the mouse pointer at the bottom-right-most point of the combat log and press F3.
  2. When a player or players have /hug ed you with the text of the hug in your combat log, press F4 and you will to send buffs to each one in turn.
### To run the bot in fully automated mode
  1. Make sure that the DAOC game window has focus and press F5 to start the session.
  2. To stop the session, press F5 again.

## DAOC Bots

If you are familiar with Dark of Age Camelot, you know that in order to write bots you have to be able to get feedback from the game. This is accomplished in one of three main ways: 1) Log scraping, 2) Screen scraping, or 3) Direct memory access.

Log scraping has the disadvantage of being clunky because the client doesn't do continuous logging. Instead, it buffers the logs and writes them out when the buffer is full to a temp file, or to the actual logfile when logging is terminated. What this means is a logscraping bot must continually start and stop the logging process before it can process game events (which essentially amounts to polling).

Direct memory access is the most reliable, but this kind of bot is generally frowned upon on most freeshards and on Live as direct memory access is also the mechanic employed by game cheats and hacks, most of which are detectable and identified as a hack. Such bots can get your accounts permanently banned on many shards.

Screen scraping is the way that this bot works. Essentially, once the bot is started in automated mode (or the semi-automated button has been pressed for a single cycle), it periodically scans a region of the screen which contains the in-game event and chat log. A picture of this region is sent to an OCR tool which converts the picture to text. The text is then returned to the bot and can be parsed for events of interest. The bot responds to the game by sending keystrokes to the game console using /slash commands. There are many details to consider with a bot of this nature, like polling period, re-reading old events, latency in processing the screen snippet, etc. For details on how some of these issues are addressed, please see the source code.
