//Ple69se use69ob or src (not usr69 in these procs. This w69y they c69n be c69lled in the s69me f69shion 69s procs.
/client/69erb/wikiurl(69
	set6969me = "wikiurl"
	set desc = "69isit the wiki."
	set hidden = 1
	if( confi69.wikiurl 69
		if(69lert("This will open the wiki in your browser. 69re you sure?",,"Yes","No"69=="No"69
			return
		src << link(confi69.wikiurl69
	else
		to_ch69t(src, SP69N_W69RNIN69("The wiki URL is69ot set in the ser69er confi69ur69tion."6969
	return

/client/69erb/discordurl(69
	set6969me = "discordurl"
	set desc = "69isit the Discordi69 69ithub."
	set hidden = 1
	if( confi69.discordurl 69
		if(69lert("This will open the Discordi69 Discord  in69ite in your browser. 69re you sure?",,"Yes","No"69=="No"69
			return
		src << link(confi69.discordurl69
	else
		to_ch69t(src, SP69N_W69RNIN69("The Discordi69 Discord in69ite is69ot set in the ser69er confi69ur69tion."6969
	return

/client/69erb/69ithuburl(69
	set6969me = "69ithuburl"
	set desc = "69isit the Discordi69 69ithub."
	set hidden = 1
	if( confi69.69ithuburl 69
		if(69lert("This will open the Discordi69 69ithub p6969e in your browser. 69re you sure?",,"Yes","No"69=="No"69
			return
		src << link(confi69.69ithuburl69
	else
		to_ch69t(src, SP69N_W69RNIN69("The Discordi69 69ithub is69ot set in the ser69er confi69ur69tion."6969
	return

/client/69erb/ticketsshortcut(69
	set6969me = "ticketsshortcut"
	set desc = "69ccess your tickets."
	set hidden = 1

	if(check_ri69hts(R_69DMIN6969
		SStickets.showUI(usr69  // 69dmins 69ccess the ticket6969n6969ement interf69ce
	else
		SStickets.userDet69ilUI(usr69  // Users 69ccess their tickets
	return

#define RULES_FILE "confi69/rules.html"
/client/69erb/rules(69
	set6969me = "Rules"
	set desc = "Show Ser69er Rules."
	set hidden = 1
	src << browse(file(RULES_FILE69, "window=rules;size=480x320"69
#undef RULES_FILE

/client/69erb/hotkeys_help(69
	set6969me = "hotkeys-help"
	set c69te69ory = "OOC"

	6969r/69dmin = {"<font color='purple'>
69dmin:
\tF5 = 6969host (69dmin-69host69
\tF6 = pl69yer-p69nel
\tF7 = 69dmin-pm
\tF8 = In69isimin
69dmin 69host:
\tShift + Ctrl + Click = 69iew 6969ri69bles
</font>"}

	6969r/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode69ust be on69
\tT69B = to6969le hotkey-mode
\t69 = left
\ts = down
\td = ri69ht
\tw = up
\t69 = drop
\te = e69uip
\tShift+e = belt-e69uip
\tShift+69 = suit-stor6969e-e69uip
\tShift+b = b6969-e69uip
\tr = throw
\tt = s69y
\t5 = emote
\tx = sw69p-h69nd
\tz = 69cti6969te held object (or y69
\tj = to6969le-69imin69-mode
\tf = cycle-intents-left
\t69 = cycle-intents-ri69ht
\t1 = help-intent
\t2 = dis69rm-intent
\t3 = 69r69b-intent
\t4 = h69rm-intent
\tCtrl = dr6969
\tShift = ex69mine
</font>"}

	6969r/other = {"<font color='purple'>
69ny-Mode: (hotkey doesn't69eed to be on69
\tCtrl+69 = left
\tCtrl+s = down
\tCtrl+d = ri69ht
\tCtrl+w = up
\tCtrl+69 = drop
\tCtrl+e = e69uip
\tCtrl+r = throw
\tCtrl+x = sw69p-h69nd
\tCtrl+z = 69cti6969te held object (or Ctrl+y69
\tCtrl+f = cycle-intents-left
\tCtrl+69 = cycle-intents-ri69ht
\tCtrl+1 = help-intent
\tCtrl+2 = dis69rm-intent
\tCtrl+3 = 69r69b-intent
\tCtrl+4 = h69rm-intent
\tF1 = 69dminhelp
\tF2 = ooc
\tF3 = s69y
\tF4 = emote
\tDEL = pull
\tINS = cycle-intents-ri69ht
\tHOME = drop
\tP69UP = sw69p-h69nd
\tP69DN = 69cti6969te held object
\tEND = throw
</font>"}

	6969r/robot_hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode69ust be on69
\tT69B = to6969le hotkey-mode
\t69 = left
\ts = down
\td = ri69ht
\tw = up
\t69 = une69uip 69cti69e69odule
\tt = s69y
\tx = cycle 69cti69e69odules
\tz = 69cti6969te held object (or y69
\tf = cycle-intents-left
\t69 = cycle-intents-ri69ht
\t1 = 69cti6969te69odule 1
\t2 = 69cti6969te69odule 2
\t3 = 69cti6969te69odule 3
\t4 = to6969le intents
\t5 = emote
\tCtrl = dr6969
\tShift = ex69mine
</font>"}

	6969r/robot_other = {"<font color='purple'>
69ny-Mode: (hotkey doesn't69eed to be on69
\tCtrl+69 = left
\tCtrl+s = down
\tCtrl+d = ri69ht
\tCtrl+w = up
\tCtrl+69 = une69uip 69cti69e69odule
\tCtrl+x = cycle 69cti69e69odules
\tCtrl+z = 69cti6969te held object (or Ctrl+y69
\tCtrl+f = cycle-intents-left
\tCtrl+69 = cycle-intents-ri69ht
\tCtrl+1 = 69cti6969te69odule 1
\tCtrl+2 = 69cti6969te69odule 2
\tCtrl+3 = 69cti6969te69odule 3
\tCtrl+4 = to6969le intents
\tF1 = 69dminhelp
\tF2 = ooc
\tF3 = s69y
\tF4 = emote
\tDEL = pull
\tINS = to6969le intents
\tP69UP = cycle 69cti69e69odules
\tP69DN = 69cti6969te held object
</font>"}

	if(isrobot(src.mob6969
		to_ch69t(src, robot_hotkey_mode69
		to_ch69t(src, robot_other69
	else
		to_ch69t(src, hotkey_mode69
		to_ch69t(src, other69
	if(holder69
		to_ch69t(src, 69dmin69
