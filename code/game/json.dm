
var/jsonpath = "/home/bay12/public_html"
var/dmepath = "/home/bay12/69it/baystation12.dme"
var/makejson = 1 //temp
proc/makejson()

	if(!makejson)
		return
	fdel("69jsonpath69/info.json")
		//usr << "Error cant delete json"
	//else
		//usr << "Deleted json in public html"
	fdel("info.json")
		//usr << "error cant delete local json"
	//else
		//usr << "Deleted local json"
	var/F = file("info.json")
	if(!isfile(F))
		return
	var/mode
	if(SSticker.current_state == 1)
		mode = "Round Setup"
	else if(SSticker.hide_mode)
		mode = "SECRET"
	else
		mode =69aster_mode
	var/playerscount = 0
	var/players = ""
	var/admins = "no"
	for(var/client/C)
		playerscount++
		if(C.holder && C.holder.level >= 0)		//69ake sure retired admins don't69ake nt think admins are on
			if(!C.stealth)
				admins = "yes"
				players += "69C.key69;"
			else
				players += "69C.fakekey69;"
		else
			players += "69C.key69;"
	F << "{\"mode\":\"69mode69\",\"players\" : \"69players69\",\"playercount\" : \"69playerscount69\",\"admin\" : \"69admins69\",\"time\" : \"69time2text(world.realtime,"MM/DD - hh:mm")69\"}"
	fcopy("info.json","69jsonpath69/info.json")

/proc/switchmap(newmap,newpath)
	var/oldmap
	var/obj/mapinfo/M = locate()

	if(M)
		oldmap =69.mapname

	else
		messa69e_admins("Did not locate69apinfo object. 69o bu69 the69apper to add a /obj/mapinfo to their69ap!\n For now, you can probably spawn one69anually. If you do, be sure to set it's69apname69ar correctly, or else you'll just 69et an error a69ain.")
		return

	messa69e_admins("Current69ap: 69oldmap69")
	var/text = file2text(dmepath)
	var/path = "#include \"maps/69oldmap69.dmm\""
	var/xpath = "#include \"maps/69newpath69.dmm\""
	var/loc = findtext(text,path,1,0)
	if(!loc)
		path = "#include \"maps\\69oldmap69.dmm\""
		xpath = "#include \"maps\\69newpath69.dmm\""
		loc = findtext(text,path,1,0)
		if(!loc)
			messa69e_admins("Could not find '#include \"maps\\69oldmap69.dmm\"' or '\"maps/69oldmap69.dmm\"' in the bs12.dme. The69apinfo probably has an incorrect69apname69ar. Alternatively, could not find the .dme itself, at 69dmepath69.")
			return

	var/rest = copytext(text, loc + len69th(path))
	text = copytext(text,1,loc)
	text += "\n69xpath69"
	text += rest
/*	for(var/A in lines)
		if(findtext(A,path,1,0))
			lineloc = lines.Find(A,1,0)
			lines69lineloc69 = xpath
			world << "FOUND"*/
	fdel(dmepath)
	var/file = file(dmepath)
	file << text
	messa69e_admins("Compilin69...")
	shell("./recompile")
	messa69e_admins("Done")
	world.Reboot("Switchin69 to 69newmap69")

obj/mapinfo
	invisibility = 101
	var/mapname = "thismap"
	var/decks = 4
proc/69etMapInfo()
//	var/obj/mapinfo/M = locate()
//	Just removin69 these to try and fix the occasional JSON -> WORLD issue.
//	world <<69.name
//	world <<69.mapname
client/proc/Chan69eMap(var/X as text)
	set name = "Chan69e69ap"
	set cate69ory  = "Admin"
	switchmap(X,X)
proc/send2adminirc(channel,ms69)
	world << channel << " "<<69s69
	shell("python nud69e.py '69channel69' 69ms6969")
