//By Carnwennan

//This system was69ade as an alternative to all the in-game lists and69ariables used to log stuff in-game.
//lists and69ariables are great. However, they have several69ajor flaws:
//Firstly, they use69emory. TGstation has one of the highest69emory usage of all the ss13 branches.
//Secondly, they are usually stored in an object. This69eans that they aren't centralised. It also69eans that
//the data is lost when the object is deleted! This is especially annoying for things like the singulo engine!
#define INVESTIGATE_DIR "data/investigate/"
#define INVESTIGATE_CIRCUIT "circuit"

//SYSTEM
/proc/investigate_subject2file(var/subject)
	return file("69INVESTIGATE_DIR6969subject69.html")

/hook/startup/proc/resetInvestigate()
	investigate_reset()
	return 1

/proc/investigate_reset()
	if(fdel(INVESTIGATE_DIR))	return 1
	return 0

/atom/proc/investigate_log(var/message,69ar/subject)
	if(!message)	return
	var/F = investigate_subject2file(subject)
	if(!F)	return
	F << "<small>69time2text(world.timeofday,"hh:mm")69 \ref69src69 (69x69,69y69,69z69)</small> || 69src69 69message69<br>"

//ADMINVERBS
ADMIN_VERB_ADD(/client/proc/investigate_show, R_ADMIN, TRUE)
//various admintools for investigation. Such as a singulo grief-log
/client/proc/investigate_show( subject in list("hrefs","notes","singulo","telesci","atmos","chemistry", INVESTIGATE_CIRCUIT) )
	set name = "Investigate"
	set category = "Admin"
	if(!holder)	return
	switch(subject)
		if("singulo", "telesci", "atmos", "chemistry")			//general one-round-only stuff
			var/F = investigate_subject2file(subject)
			if(!F)
				to_chat(src, "<font color='red'>Error: admin_investigate: 69INVESTIGATE_DIR6969subject69 is an invalid path or cannot be accessed.</font>")
				return
			src << browse(F,"window=investigate69subject69;size=800x300")

		if("hrefs")				//persistant logs and stuff
			if(config && config.log_hrefs)
				if(href_logfile)
					src << browse(href_logfile,"window=investigate69subject69;size=800x300")
				else
					to_chat(src, "<font color='red'>Error: admin_investigate: No href logfile found.</font>")
					return
			else
				to_chat(src, "<font color='red'>Error: admin_investigate: Href Logging is not on.</font>")
				return
