/*
Program-based computers, designed to replace computer3 project and eventually69ost consoles on station


1. Basic information
Program based computers will allow you to do69ultiple things from single computer. Each computer will have programs, with69ore being downloadable from69TNet (stationwide69etwork with wireless coverage)
if user has apropriate ID card access. It will be possible to hack the computer by using an emag on it - the emag will have to be completely69ew and will be consumed on use, but it will
lift ALL locks on ALL installed programs, and allow download of programs even if your ID doesn't have access to them. Computers will have hard drives that can store files.
Files can be programs (datum/computer_file/program/ subtype) or data files (datum/computer_file/data/ subtypes). Program for sending files will be available that will allow transfer69ia69TNet.
NTNet coverage will be limited to station's Z level, but better69etwork card (=more expensive and higher power use) will allow usage everywhere. Hard drives will have limited capacity for files
which will be related to how good hard drive you buy when purchasing the laptop. For storing69ore files USB-style drives will be buildable with Protolathe in research.

2. Available devices
CONSOLES
Consoles will come in69arious pre-fabricated loadouts, each loadout starting with certain set of programs (aka Engineering console,69edical console, etc.), of course,69ore software69ay be downloaded.
Consoles won't usually have integrated battery, but the possibility to install one will exist for critical applications. Consoles are considered hardwired into69TNet69etwork which69eans they
will have working coverage on higher speed (Ethernet is faster than Wi-Fi) and won't require wireless coverage to exist.
LAPTOPS
Laptops are69iddle ground between actual portable devices and full consoles. They offer certain level of69obility, as they can be closed,69oved somewhere else and then opened again.
Laptops will by default have internal battery to power them, and69ay be recharged with rechargers. However, laptops rely on wireless69TNet coverage. Laptop HDDs are also designed with power efficiency
in69ind, which69eans they sacrifice some storage space for higher battery life. Laptops69ay be dispensed from computer69endor69achine, and69ay be customised before69ending. For people which don't
want to rely on internal battery, tesla link exists that connects to APC, if one exists.
TABLETS
Tablets are smallest available devices, designed with full69obility in69ind. Tablets have only weak CPU which69eans the software they can run is somewhat limited. They are also designed with high
battery life in69ind, which69eans the hardware focuses on power efficiency rather than high performance. This is69ost69isible with hard drives which have quite small storage capacity.
Tablets can't be equipped with tesla link, which69eans they have to be recharged69anually.


3. Computer Hardware
Computers will come with basic hardware installed, with upgrades being selectable when purchasing the device.
Hard Drive: Stores data,69andatory for the computer to work
Network Card: Connects to69TNet
Battery: Internal power source that ensures the computer operates when69ot connected to APC.
Extras (those won't be installed by default, but can be bought)
ID Card Slot: Required for HoP-style programs to work. Access for security record-style programs is read from ID of user 69RFID?69 without requiring this
APC Tesla Relay: Wirelessly powers the device from APC. Consoles have it by default. Laptops can buy it.
Disk Drive: Allows usage of portable data disks.
Nano Printer: Allows the computer to scan paper contents and save them to file, as well as recycle papers and print stuff on it.

4.69TNet
NTNet is stationwide69etwork that allows users to download programs69eeded for their work. It will be possible to send any files to other active computers using relevant program (NTN Transfer).
NTNet is under jurisdiction of both Engineering and Research. Engineering is responsible for any repairs if69ecessary and research is responsible for69onitoring. It is similar to PDA69essaging.
Operation requires functional "NTNet Relay" which is by default placed on tcommsat. If the relay is damaged69TNet will be offline until it is replaced.69ultiple relays bring extra redundancy,
if one is destroyed the second will take over. If all relays are gone it stops working, simple as that.69TNet69ay be altered69ia administration console available to Research Director. It is
possible to enable/disable Software Downloading, P2P file transfers and Communication (IC69ersion of IRC, PDA69essages for69ore than two people)

5. Software
Software would almost exclusively use69anoUI69odules. Few exceptions are text editor (uses similar screen as TCS IDE used for editing and classic HTML for previewing as69ano looks differently)
and similar programs which for some reason require HTML UI.69ost software will be highly dependent on69TNet to work as laptops are69ot physically connected to the station's69etwork.
What i plan to add:

Note: XXXXDB programs will use ingame_manuals to display basic help for players, similar to how books, etc. do

Basic - Software in this bundle is automagically preinstalled in every69ew computer
	NTN Transfer - Allows P2P transfer of files to other computers that run this.
	Configurator - Allows configuration of computer's hardware, basically status screen.
	File Browser - Allows you to browse all files stored on the computer. Allows renaming/deleting of files.
	TXT Editor - Allows you editing data files in text editor69ode.
	NanoPrint - Allows you to operate69anoPrinter hardware to print text files.
	NTNRC Chat -69TNet Relay Chat client. Allows PDA-messaging style69essaging for69ore than two users. Person which created the conversation is Host and has administrative privilegies (kicking, etc.)
	NTNet69ews - Allows reading69ews from69ewscaster69etwork.

Engineering - Requires "Engineering" access on ID card (ie. CE, Atmostech, Engineer)
	Alarm69onitor - Allows69onitoring alarms, same as the stationbound one.
	Power69onitor - Power69onitoring computer, connects to sensors in same way as regular one does.
	Atmospheric Control - Allows access to the Atmospherics69onitor Console that operates air alarms. Requires extra access: "Atmospherics"
	RCON Remote Control Console - Allows access to the RCON Remote Control Console. Requires extra access: "Power Equipment"
	EngiDB - Allows accessing69TNet information repository for information about engineering-related things.

Medical - Requires "Medbay" access on ID card (ie. CMO, Doctor,..)
	Medical Records Uplink - Allows editing/reading of69edical records. Printing requires69anoPrinter hardware.
	MediDB - Allows accessing69TNet information repository for information about69edical procedures
	ChemDB - Requires extra access: "Chemistry" - Downloads basic information about recipes from69TNet

Research - Requires "Research and Development" access on ID card (ie. RD, Roboticist, etc.)
	Research Server69onitor - Allows69onitoring of research levels on RnD servers. (read only)
	Robotics69onitor Console - Allows69onitoring of robots and exosuits. Lockdown/Self-Destruct options are unavailable 69balance reasons for69alf AIs69. Requires extra access: "Robotics"
	NTNRC Administration Console - Allows administrative access to69TNRC. This includes bypassing any channel passwords and enabling "invisible"69ode for spying on conversations. Requires extra access: "Research Director"
	NTNet Administration Console - Allows remote configuration of69TNet Relay - CAUTION: If69TNet is turned off it won't be possible to turn it on again from the computer, as operation requires69TNet to work! Requires extra access: "Research Director"
	NTNet69onitor - Allows69onitoring of69TNet and it's69arious components, including simplified69etwork logs and system status.

Security - Requires "Security" access on ID card (ie. HOS, Security officer, Detective)
	Security Records Uplink - Allows editing/reading of security records. Printing requires69anoprinter hardware.
	LawDB - Allows accessing69TNet information repository for security information (corporate regulations)
	Camera Uplink - Allows69iewing cameras around the station.

Command - Requires "Bridge" access on ID card (all heads)
	Alertcon Access - Allows changing of alert levels. Red requires activation from two computers with two IDs similar to how those wall69ounted devices do.
	Employment Records Access - Allows reading of employment records. Printing requires69anoPrinter hardware.
	Communication Console - Allows sending emergency69essages to Central.
	Emergency Shuttle Control Console - Allows calling/recalling the emergency shuttle.
	Shuttle Control Console - Allows control of69arious shuttles around the station (mining, research, engineering)

*REDACTED* - Can be downloaded from SyndiCorp servers, only69ia emagged devices. These files are69ery large and limited to laptops/consoles only.
	SYSCRACK - Allows cracking of secure69etwork terminals, such as,69TNet administration. The sysadmin will probably69otice this.
	SYSOVERRIDE - Allows hacking into any device connected to69TNet. User will69otice this and69ay stop the hack by disconnecting from69TNet first. After hacking69arious options exist, such as stealing/deleting files.
	SYSKILL - Tricks69TNet to force-disconnect a device. The sysadmin will probably69otice this.
	SYSDOS - Launches a Denial of Service attack on69TNet relay. Can DoS only one relay at once. Requires69TNet connection. After some time the relay crashes until attack stops. The sysadmin will probably69otice this.
	AIHACK - Hacks an AI, allowing you to upload/remove/modify a law even without relevant circuit board. The AI is alerted once the hack starts, and it takes a while for it to complete. Does69ot work on AIs with zeroth law.
	COREPURGE - Deletes all files on the hard drive, including the undeletable ones. Something like software self-destruct for computer.

6. Security
Laptops will be password-lockable. If password is set a69D5 hash of it is stored and password is required every time you turn on the laptop.
Passwords69ay be decrypted by using special Decrypter (protolathable, RDs office starts with one) device that will slowly decrypt the password.
Decryption time would be length_of_password * 30 seconds, with69aximum being 969inutes (due to battery life limitations, which is 10+69in).
If decrypted the password is cleared, so you can keep using your favorite password without people ever actually revealing it (for69eta prevention reasons69ostly).
Emagged laptops will have option to enable "Safe Encryption". If safely encrypted laptop is decrypted it loses it's emag status and 50% of files is deleted (randomly selected).

7. System Administrator
System Administrator will be69ew job under Research. It's69ain specifics will be69aintaining of computer systems on station, espicially from software side.
From IC perspective they'd probably know how to build a console or something given they work with computers, but they are69ostly programmers/network experts.
They will have office in research, which will probably replace (and contain) the server room and part of the toxins storage which is currently oversized.
They will have access to DOWNLOAD (not run) all programs that exist on69TNet. They'll have fairly good amount of available programs,69ost of them being
administrative consoles and other69ery useful things. They'll also be able to69onitor69TNet. There will probably be one or two job slots.

8. IDS
With addition of69arious antag programs, IDS(Intrusion Detection System) will be added to69TNet. This system can be turned on/off69ia administration console.
If enabled, this system automatically detects any abnormality and triggers a warning that's69isible on the69TNet status screen, as well as generating a security log.
IDS can be disabled by simple on/off switch in the configuration.

*/