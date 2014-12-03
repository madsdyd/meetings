# Managing Meetings from the Command Line

A very simple system to manage agendas and minutes for (recurring) meetings.

These scripts are meant for managing recurring meetings.

## Basic Idea

The basic idea is to save time in setting up agendas and minutes for meetings: Every agenda is based on the last minutes, and edited to reflect changes. Annex document is handled somewhat automatically, etc.

## Requirements

I use these scripts in Linux, running bash. Really, any kind of Unix like environment (such as MacOS X) should suffice. Windows may work with Cygwin or similar.

## What makes up a meeting then

A meeting has an agenda (in one or more versions), some additional annex documents (Annex are called Bilag in danish, they are in their own directory), and the minutes (in one or more versions). 

The agendas are named like this (the word dagsorden means agenda in danish - this can be changed in `inc-agenda.sh`): `dagsorden-yyyy-mm-dd-vN.odt` where yyyy-mm-dd is the year, month and date, and N is the version of the agenda. Similarily, the minutes is named (referat means minutes in danish, again, this can be changed): `referat-yyyy-mm-dd-vN.odt`.

## Meetings layout

In order to work well, your meetings should be organized in directories, either as YYYY/MMDD or YYYYMMDD

### YYYY/MMDD example
```
.
|-- 2013
|   |-- 0828
|   |   `-- Bilag
|   |-- 0911
|   |   `-- Bilag
|   |-- 1002
|   |   `-- Bilag
|   `-- 1204
|       `-- Bilag
`-- 2014
    |-- 0507
    |   `-- Bilag
    |-- 1114
    |   `-- Bilag
    |-- 1126
    |   `-- Bilag
    `-- 1203
        `-- Bilag
```
        
### YYYYMMDD example
```    
.
|-- 20110406
|   `-- Bilag
|-- 20110504
|   `-- Bilag
|-- 20111005
|   `-- Bilag
|-- 20111102
|   `-- Bilag
`-- 20111207
    `-- Bilag
```

There are currently no way to create the initial state of a meeting, but I may be adding a script to do that, soon.

### Meeting states

Every meeting starts out with an agenda and the minutes from last meeting. 

#### Updating an agenda

If you need an updated agenda, you can use the `agenda-update.sh` script. This will copy the newest (highest numbered) agenda to a new agenda, and open it for editing.

#### Making minutes

When you need to make minutes, run the `create-minutes.sh` script. This will copy the newest agenda to the minutes format and open it for editing.

#### Setting up for the next meeting

When a meeting is done, you can create the next meeting using the script `create-meeting.sh`. This accepts the name of a directory containing the last meeting, and a name for the next meeting to create. An example is in order. Say you had a meeting at the 26th of November in a year, and that meeting contains this:

```
.
`-- 1126
    |-- Bilag
    |   |-- Bilag 1.2.1 - some-document.pdf
    |   |-- Bilag 1.3.1 - Some-other-document.pdf
    |   `-- Bilag 1 - referat-2014-11-19-v1.pdf
    |-- dagsorden-2014-11-26-v1.odt
    |-- dagsorden-2014-11-26-v1.pdf
    |-- dagsorden-2014-11-26-v2.odt
    |-- dagsorden-2014-11-26-v2.pdf
    |-- referat-2014-11-26-v1.odt
    `-- referat-2014-11-26-v1.pdf
```

You want to setup a meeting at the 3rd of December, based on the meeting at 26th of November. Here is how to do it:

```
$ create-meeting.sh 
Usage: create-meeting.sh [--nopdf] <clonefrom> <cloneto>
$ $ create-meeting.sh 1126 1203
Using 1126/referat-2014-11-26-v1.odt and 1126/referat-2014-11-26-v1.pdf as sources
Using 1203/dagsorden-2014-12-03-v1.odt as destination
Bilag 1 - referat-2014-11-26-v1.pdf
1203
.
|-- Bilag
|   `-- Bilag 1 - referat-2014-11-26-v1.pdf
`-- dagsorden-2014-12-03-v1.odt
1 directory, 2 files
Hit Return to edit 1203/dagsorden-2014-12-03-v1.odt - or Ctrl+C to abort
```

`create-meeting.sh` uses the minutes file in .pdf format from 1126 to create the minutes file in Bilag (the last minutes are often distributed with the new agenda for a meeting). And, it uses the minutes file in .odt format from 1126 to crate the agendafile for 1203, which you then have to edit; delete old items, update recurring, add new, etc.

#### Managing Annex Documents

There is a script called `create-bilag.sh` that can be used to number files according to item numbers, etc. This can also be used to update the numbers.

#### Template and Macros

In the `TemplateAndMacros` directory is a template that can be used to start a meeting sequence, as well as some macros used by this template. This is all for Libreoffice/OpenOffice, and you will probably have to import the macros into your global Macros in order to make it work. You may also import the macros into the document.

The document runs the macros on startup events, to update fields, etc. You can also set up keybindings to run some of the commands to insert standard texts with the date of the document, etc.