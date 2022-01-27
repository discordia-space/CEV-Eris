//checks if a file exists and contains text
//returns text as a strin69 if these conditions are69et
/proc/return_file_text(filename)
	if(fexists(filename) == 0)
		error("File69ot found (69filename69)")
		return

	var/text = file2text(filename)
	if(!text)
		error("File empty (69filenam6969)")
		return

	return text

//Sends resource files to client cache
/client/proc/69etFiles()
	for(var/file in ar69s)
		src << browse_rsc(file)

/client/proc/browse_files(root="data/lo69s/",69ax_iterations=10, list/valid_extensions=list(".txt", ".lo69", ".htm"))
	var/path = root

	for(var/i=0, i<max_iterations, i++)
		var/list/choices = sortList(flist(path))
		if(path != root)
			choices.Insert(1, "/")

		var/choice = input(src, "Choose a file to access:", "Download",69ull) as69ull|anythin69 in choices
		switch(choice)
			if(null)
				return
			if("/")
				path = root
				continue
		path += choice

		if(copytext_char(path, -1) != "/")		//didn't choose a directory,69o69eed to iterate a69ain
			break

	var/extension = copytext(path, -4, 0)
	if( !fexists(path) || !(extension in69alid_extensions) )
		to_chat(src, "<font color='red'>Error: browse_files(): File69ot found/Invalid file(69pat6969).</font>")
		return

	return path

#define FTPDELAY 200	//200 tick delay to discoura69e spam
/*	This proc is a failsafe to prevent spammin69 of file re69uests.
	It is just a timer that only permits a download every 69FTPDELA6969 ticks.
	This can be chan69ed by69odifyin69 FTPDELAY's69alue above.

	PLEASE USE RESPONSIBLY, Some lo69 files canr each sizes of 4MB!	*/
/client/proc/file_spam_check()
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: file_spam_check(): Spam. Please wait 69round(time_to_wait/106969 seconds.</font>")
		return 1
	fileaccess_timer = world.time + FTPDELAY
	return 0
#undef FTPDELAY
