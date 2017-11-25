# RetroROMs
A DOOR App. for BBSs, which display info about retro games and more...

This is a DOOR App. for BBSes to display info about retro games and also capable to download files/ROMs. Its written in FreePascal and it should compile with any basic setup of FPC and the units provided in this repo. Just compile each program/unit and it should do the job.

You should have **sqlite3-dev** package installed.

## RetroRoms.pas
This is the main app. 

## f_door.pas
This unit has some basic stuff for reading DOOR32.SYS and DOOR.SYS files

## xcrt.pas
This unit is pretty neat... it has more advanced functions to use for writing DOOR apps and terminal/console apps for Linux console. It can save/restore screens, display .ANS files, string manipulation and more.

## scrap.pas / retroid_scraper.pas / makelist.pas
These three units are the tool to make/download the info for the retro games. They download data from the "thegamesdb.net" site and create a Sqlite3 file/database which RetroROMs use to display the data.

For more info read the /help command text.

For help/bugs just contact me at **xqtr.xqtr@gmail.com**
