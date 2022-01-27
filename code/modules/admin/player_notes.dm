//This stuff was originally intended to be integrated into the ban-system I was working on
//but it's safe to say that'll never be finished. So I've69erged it into the current player panel.
//enjoy				~Carn

#define NOTESFILE "data/player_notes.sav"	//where the player notes are saved

datum/admins/proc/notes_show(var/ckey)
	usr << browse("<head><title>Player Notes</title></head><body>69notes_gethtml(ckey)69</body>","window=player_notes;size=700x400")


datum/admins/proc/notes_gethtml(var/ckey)
	var/savefile/notesfile = new(NOTESFILE)
	if(!notesfile)	return "<font color='red'>Error: Cannot access 69NOTESFILE69</font>"
	if(ckey)
		. = "<b>Notes for <a href='?src=\ref69src69;notes=show'>69ckey69</a>:</b> <a href='?src=\ref69src69;notes=add;ckey=69ckey69'>\69+\69</a> <a href='?src=\ref69src69;notes=remove;ckey=69ckey69'>\69-\69</a><br>"
		notesfile.cd = "/69ckey69"
		var/index = 1
		while( !notesfile.eof )
			var/note
			notesfile >> note
			. += "69note69 <a href='?src=\ref69src69;notes=remove;ckey=69ckey69;from=69index69'>\69-\69</a><br>"
			index++
	else
		. = "<b>All Notes:</b> <a href='?src=\ref69src69;notes=add'>\69+\69</a> <a href='?src=\ref69src69;notes=remove'>\69-\69</a><br>"
		notesfile.cd = "/"
		for(var/dir in notesfile.dir)
			. += "<a href='?src=\ref69src69;notes=show;ckey=69dir69'>69dir69</a><br>"
	return


//handles adding notes to the end of a ckey's buffer
//originally had seperate entries such as69ar/by to record who left the note and when
//but the current bansystem is a heap of dung.
/proc/notes_add(var/ckey,69ar/note)
	if(!ckey)
		ckey = ckey(input(usr,"Who would you like to add notes for?","Enter a ckey",null) as text|null)
		if(!ckey)	return

	if(!note)
		note = html_encode(input(usr,"Enter your note:","Enter some text",null) as69essage|null)
		if(!note)	return

	var/savefile/notesfile = new(NOTESFILE)
	if(!notesfile)	return
	notesfile.cd = "/69ckey69"
	notesfile.eof = 1		//move to the end of the buffer
	notesfile << "69time2text(world.realtime,"DD-MMM-YYYY")69 | 69note6969(usr && usr.ckey)?" ~69usr.ckey69":""69"
	return

//handles removing entries from the buffer, or removing the entire directory if no start_index is given
/proc/notes_remove(var/ckey,69ar/start_index,69ar/end_index)
	var/savefile/notesfile = new(NOTESFILE)
	if(!notesfile)	return

	if(!ckey)
		notesfile.cd = "/"
		ckey = ckey(input(usr,"Who would you like to remove notes for?","Enter a ckey",null) as null|anything in notesfile.dir)
		if(!ckey)	return

	if(start_index)
		notesfile.cd = "/69ckey69"
		var/list/noteslist = list()
		if(!end_index)	end_index = start_index
		var/index = 0
		while( !notesfile.eof )
			index++
			var/temp
			notesfile >> temp
			if( (start_index <= index) && (index <= end_index) )
				continue
			noteslist += temp

		notesfile.eof = -2		//Move to the start of the buffer and then erase.

		for(69ar/note in noteslist )
			notesfile << note
	else
		notesfile.cd = "/"
		if(alert(usr,"Are you sure you want to remove all their notes?","Confirmation","No","Yes - Remove all notes") == "Yes - Remove all notes")
			notesfile.dir.Remove(ckey)
	return

#undef NOTESFILE