
//The advanced pea-69reen69onochrome lcd of tomorrow.

var/69lobal/list/obj/item/device/pda/PDAs = list()

/obj/item/device/pda
	name = "\improper PDA"
	desc = "A portable69icrocomputer by Thinktronic Systems, LTD. Functionality determined by a prepro69rammed ROM cartrid69e."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL
	slot_fla69s = SLOT_ID | SLOT_BELT
	spawn_blacklisted = TRUE
	//Main69ariables
	var/owner
	var/default_cartrid69e = 0 // Access level defined by cartrid69e
	var/obj/item/cartrid69e/cartrid69e = null //current cartrid69e
	var/mode = 0 //Controls what69enu the PDA will display. 0 is hub; the rest are either built in or based on cartrid69e.

	var/lastmode = 0
	var/ui_tick = 0
	var/nanoUI69069

	//Secondary69ariables
	var/scanmode = 0 //1 is69edical scanner, 2 is forensics, 3 is rea69ent scanner.
	var/fon = 0 //Is the flashli69ht function on?
	var/f_lum = 2 //Luminosity for the flashli69ht function
	var/messa69e_silent = 0 //To beep or not to beep, that is the 69uestion
	var/news_silent = 1 //To beep or not to beep, that is the 69uestion.  The answer is No.
	var/toff = 0 //If 1,69essen69er disabled
	var/tnote69069  //Current Texts
	var/last_text //No text spammin69
	var/last_honk //Also no honk spammin69 that's bad too
	var/ttone = "beep" //The PDA rin69tone!
	var/newstone = "beep, beep" //The news rin69tone!
	var/lock_code = "" // Lockcode to unlock uplink
	var/honkamt = 0 //How69any honks left when infected with honk.exe
	var/mimeamt = 0 //How69any silence left when infected with69ime.exe
	var/note = "Con69ratulations, your ship has chosen the Thinktronic 5230 Personal Data Assistant!" //Current note in the notepad function
	var/notehtml = ""
	var/cart = "" //A place to stick cartrid69e69enu information
	var/detonate = 1 // Can the PDA be blown up?
	var/hidden = 0 // Is the PDA hidden from the PDA list?
	var/active_conversation = null // New69ariable that allows us to only69iew a sin69le conversation.
	var/list/conversations = list()    // For keepin69 up with who we have PDA69esssa69es from.
	var/new_messa69e = 0			//To remove hackish overlay check
	var/new_news = 0

	var/active_feed				// The selected feed
	var/list/warrant			// The warrant as we last knew it
	var/list/feeds = list()		// The list of feeds as we last knew them
	var/list/feed_info = list()	// The data and contents of each feed as we last knew them

	var/list/cartmodes = list(40, 42, 43, 433, 44, 441, 45, 451, 46, 48, 47, 49) // If you add69ore cartrid69e69odes add them to this list as well.
	var/list/no_auto_update = list(1, 40, 43, 44, 441, 45, 451)		     // These69odes we turn off autoupdate
	var/list/update_every_five = list(3, 41, 433, 46, 47, 48, 49)			     // These we update every 5 ticks

	var/obj/item/card/id/id = null //Makin69 it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above - this is assi69nment (potentially alt title)
	var/ownrank = null // this one is rank, never alt title

	var/obj/item/device/paicard/pai = null	// A slot for a personal AI device

/obj/item/device/pda/examine(mob/user)
	if(..(user, 1))
		var/turf/T = 69et_turf(src)
		to_chat(user, "The time 69stationtime2text()69, and Coordinates: 69T.x69,69T.y69,69T.z69 are displayed in the corner of the screen.")

/obj/item/device/pda/medical
	default_cartrid69e = /obj/item/cartrid69e/medical
	icon_state = "pda-m"

/obj/item/device/pda/viro
	default_cartrid69e = /obj/item/cartrid69e/medical
	icon_state = "pda-v"

/obj/item/device/pda/en69ineerin69
	default_cartrid69e = /obj/item/cartrid69e/en69ineerin69
	icon_state = "pda-e"

/obj/item/device/pda/security
	default_cartrid69e = /obj/item/cartrid69e/security
	icon_state = "pda-s"

/obj/item/device/pda/detective
	default_cartrid69e = /obj/item/cartrid69e/detective
	icon_state = "pda-det"

/obj/item/device/pda/warden
	default_cartrid69e = /obj/item/cartrid69e/security
	icon_state = "pda-warden"

/obj/item/device/pda/janitor
	default_cartrid69e = /obj/item/cartrid69e/janitor
	icon_state = "pda-j"
	ttone = "slip"

/obj/item/device/pda/science
	default_cartrid69e = /obj/item/cartrid69e/si69nal/science
	icon_state = "pda-tox"
	ttone = "boom"

/obj/item/device/pda/clown
	default_cartrid69e = /obj/item/cartrid69e/clown
	icon_state = "pda-clown"
	desc = "A portable69icrocomputer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippin69s."
	ttone = "honk"

/obj/item/device/pda/heads
	default_cartrid69e = /obj/item/cartrid69e/head
	icon_state = "pda-h"
	news_silent = 1

/obj/item/device/pda/heads/hop
	default_cartrid69e = /obj/item/cartrid69e/hop
	icon_state = "pda-hop"

/obj/item/device/pda/heads/hos
	default_cartrid69e = /obj/item/cartrid69e/hos
	icon_state = "pda-hos"

/obj/item/device/pda/heads/ce
	default_cartrid69e = /obj/item/cartrid69e/ce
	icon_state = "pda-ce"

/obj/item/device/pda/heads/cmo
	default_cartrid69e = /obj/item/cartrid69e/cmo
	icon_state = "pda-cmo"

/obj/item/device/pda/heads/rd
	default_cartrid69e = /obj/item/cartrid69e/rd
	icon_state = "pda-rd"

/obj/item/device/pda/captain
	default_cartrid69e = /obj/item/cartrid69e/captain
	icon_state = "pda-c"
	detonate = 0
	//toff = 1

/obj/item/device/pda/car69o
	default_cartrid69e = /obj/item/cartrid69e/69uartermaster
	icon_state = "pda-car69o"

/obj/item/device/pda/69uartermaster
	default_cartrid69e = /obj/item/cartrid69e/69uartermaster
	icon_state = "pda-69"

/obj/item/device/pda/shaftminer
	icon_state = "pda-miner"

/obj/item/device/pda/syndicate
	default_cartrid69e = /obj/item/cartrid69e/syndicate
	icon_state = "pda-syn"
	name = "Military PDA"
	owner = "John Doe"
	hidden = 1

/obj/item/device/pda/chaplain
	icon_state = "pda-holy"
	ttone = "holy"

/obj/item/device/pda/lawyer
	default_cartrid69e = /obj/item/cartrid69e/lawyer
	icon_state = "pda-lawyer"
	ttone = "..."

/obj/item/device/pda/botanist
	//default_cartrid69e = /obj/item/cartrid69e/botanist
	icon_state = "pda-hydro"

/obj/item/device/pda/roboticist
	icon_state = "pda-robot"

/obj/item/device/pda/clear
	icon_state = "pda-transp"
	desc = "A portable69icrocomputer by Thinktronic Systems, LTD. This is69odel is a special edition with a transparent case."
	note = "Con69ratulations, you have chosen the Thinktronic 5230 Personal Data Assistant Deluxe Special69ax Turbo Limited Edition!"

/obj/item/device/pda/chef
	icon_state = "pda-chef"

/obj/item/device/pda/bar
	icon_state = "pda-bar"

/obj/item/device/pda/atmos
	default_cartrid69e = /obj/item/cartrid69e/atmos
	icon_state = "pda-atmo"

/obj/item/device/pda/chemist
	default_cartrid69e = /obj/item/cartrid69e/chemistry
	icon_state = "pda-chem"


// Special AI/pAI PDAs that cannot explode.
/obj/item/device/pda/ai
	icon_state = "NONE"
	ttone = "data"
	newstone = "news"
	detonate = 0


/obj/item/device/pda/ai/proc/set_name_and_job(newname as text, newjob as text, newrank as null|text)
	owner = newname
	ownjob = newjob
	if(newrank)
		ownrank = newrank
	else
		ownrank = ownjob
	name = newname + " (" + ownjob + ")"


//AI69erb and proc for sendin69 PDA69essa69es.
/obj/item/device/pda/ai/verb/cmd_send_pdames69()
	set cate69ory = "AI IM"
	set name = "Send69essa69e"
	set src in usr
	if(usr.stat == 2)
		to_chat(usr, "You can't send PDA69essa69es because you are dead!")
		return
	var/list/plist = available_pdas()
	if (plist)
		var/c = input(usr, "Please select a PDA") as null|anythin69 in sortList(plist)
		if (!c) // if the user hasn't selected a PDA file we can't send a69essa69e
			return
		var/selected = plist69c69
		create_messa69e(usr, selected, 0)


/obj/item/device/pda/ai/verb/cmd_to6969le_pda_receiver()
	set cate69ory = "AI IM"
	set name = "To6969le Sender/Receiver"
	set src in usr
	if(usr.stat == 2)
		to_chat(usr, "You can't do that because you are dead!")
		return
	toff = !toff
	to_chat(usr, "<span class='notice'>PDA sender/receiver to6969led 69(toff ? "Off" : "On")69!</span>")


/obj/item/device/pda/ai/verb/cmd_to6969le_pda_silent()
	set cate69ory = "AI IM"
	set name = "To6969le Rin69er"
	set src in usr
	if(usr.stat == 2)
		to_chat(usr, "You can't do that because you are dead!")
		return
	messa69e_silent=!messa69e_silent
	to_chat(usr, "<span class='notice'>PDA rin69er to6969led 69(messa69e_silent ? "Off" : "On")69!</span>")


/obj/item/device/pda/ai/verb/cmd_show_messa69e_lo69()
	set cate69ory = "AI IM"
	set name = "Show69essa69e Lo69"
	set src in usr
	if(usr.stat == 2)
		to_chat(usr, "You can't do that because you are dead!")
		return
	var/HTML = "<html><head><title>AI PDA69essa69e Lo69</title></head><body>"
	for(var/index in tnote)
		if(index69"sent"69)
			HTML += addtext("<i><b>&rarr; To <a href='byond://?src=\ref69src69;choice=Messa69e;notap=1;tar69et=",index69"src"69,"'>", index69"owner"69,"</a>:</b></i><br>", index69"messa69e"69, "<br>")
		else
			HTML += addtext("<i><b>&larr; From <a href='byond://?src=\ref69src69;choice=Messa69e;notap=1;tar69et=",index69"tar69et"69,"'>", index69"owner"69,"</a>:</b></i><br>", index69"messa69e"69, "<br>")
	HTML +="</body></html>"
	usr << browse(HTML, "window=lo69;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")


/obj/item/device/pda/ai/can_use()
	return 1


/obj/item/device/pda/ai/attack_self(mob/user as69ob)
	if ((honkamt > 0) && (prob(60)))//For clown69irus.
		honkamt--
		playsound(loc, 'sound/items/bikehorn.o6969', 30, 1)
	return


/obj/item/device/pda/ai/pai
	ttone = "assist"


/*
 *	The Actual PDA
 */

/obj/item/device/pda/New()
	..()
	PDAs += src
	PDAs = sortNames(PDAs)
	if(default_cartrid69e)
		cartrid69e = new default_cartrid69e(src)
	new /obj/item/pen(src)
	update_icon()

/obj/item/device/pda/proc/can_use()

	if(!ismob(loc))
		return 0

	var/mob/M = loc
	if(M.stat ||69.restrained() ||69.paralysis ||69.stunned ||69.weakened)
		return 0
	if((src in69.contents) || ( istype(loc, /turf) && in_ran69e(src,69) ))
		return 1
	else
		return 0

/obj/item/device/pda/69etAccess()
	if(id)
		return id.69etAccess()
	else
		return ..()

/obj/item/device/pda/MouseDrop(obj/over_object, src_location, over_location)
	if((!istype(over_object, /obj/screen)) && can_use())
		return attack_self(usr)
	return ..()


/obj/item/device/pda/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	ui_tick++
	var/datum/nanoui/old_ui = SSnano.69et_open_ui(user, src, "main")
	var/auto_update = 1
	if(mode in no_auto_update)
		auto_update = 0
	if(old_ui && (mode == lastmode && ui_tick % 5 && (mode in update_every_five)))
		return

	lastmode =69ode

	var/title = "Personal Data Assistant"
	var/turf/T = 69et_turf(src) //The coordinates of the PDA will be displayed onscreen
	var/data69069  // This is the data that will be sent to the PDA

	data69"owner"69 = owner					// Who is your daddy...
	data69"ownjob"69 = ownjob					// ...and what does he do?

	data69"mode"69 =69ode					// The current69iew
	data69"scanmode"69 = scanmode				// Scanners
	data69"fon"69 = fon					// Flashli69ht on?
	data69"pai"69 = (isnull(pai) ? 0 : 1)			// pAI inserted?
	data69"note"69 = note					// current pda notes
	data69"messa69e_silent"69 =69essa69e_silent					// does the pda69ake noise when it receives a69essa69e?
	data69"news_silent"69 = news_silent					// does the pda69ake noise when it receives news?
	data69"toff"69 = toff					// is the69essen69er function turned off?
	data69"active_conversation"69 = active_conversation	// Which conversation are we followin69 ri69ht now?


	data69"idInserted"69 = (id ? 1 : 0)
	data69"idLink"69 = (id ? text("69id.re69istered_name69, 69id.assi69nment69") : "--------")

	data69"cart_loaded"69 = cartrid69e ? 1:0
	if(cartrid69e)
		var/cartdata69069
		cartdata69"access"69 = list(\
					"access_security" = cartrid69e.access_security,\
					"access_en69ine" = cartrid69e.access_en69ine,\
					"access_atmos" = cartrid69e.access_atmos,\
					"access_moebius" = cartrid69e.access_moebius,\
					"access_clown" = cartrid69e.access_clown,\
					"access_mime" = cartrid69e.access_mime,\
					"access_janitor" = cartrid69e.access_janitor,\
					"access_69uartermaster" = cartrid69e.access_69uartermaster,\
					"access_hydroponics" = cartrid69e.access_hydroponics,\
					"access_rea69ent_scanner" = cartrid69e.access_rea69ent_scanner,\
					"access_remote_door" = cartrid69e.access_remote_door,\
					"access_status_display" = cartrid69e.access_status_display,\
					"access_detonate_pda" = cartrid69e.access_detonate_pda\
			)

		if(mode in cartmodes)
			data69"records"69 = cartrid69e.create_NanoUI_values()

		if(mode == 0)
			cartdata69"name"69 = strip_improper(cartrid69e.name)
			if(isnull(cartrid69e.radio))
				cartdata69"radio"69 = 0
			else
				if(istype(cartrid69e.radio, /obj/item/radio/inte69rated/beepsky))
					cartdata69"radio"69 = 1
				if(istype(cartrid69e.radio, /obj/item/radio/inte69rated/si69nal))
					cartdata69"radio"69 = 2
				if(istype(cartrid69e.radio, /obj/item/radio/inte69rated/mule))
					cartdata69"radio"69 = 3

		if(mode == 2)
			cartdata69"char69es"69 = cartrid69e.char69es ? cartrid69e.char69es : 0
		data69"cartrid69e"69 = cartdata

	data69"location"69 = "69T.x69,69T.y69,69T.z69"
	data69"stationTime"69 = stationtime2text()
	data69"new_Messa69e"69 = new_messa69e
	data69"new_News"69 = new_news

	var/datum/reception/reception = 69et_reception(src, do_sleep = 0)
	var/has_reception = reception.telecomms_reception & TELECOMMS_RECEPTION_SENDER
	data69"reception"69 = has_reception

	if(mode==2)
		var/convopdas69069
		var/pdas69069
		var/count = 0
		for (var/obj/item/device/pda/P in PDAs)
			if (!P.owner||P.toff||P == src||P.hidden)       continue
			if(conversations.Find("\ref69P69"))
				convopdas.Add(list(list("Name" = "69P69", "Reference" = "\ref69P69", "Detonate" = "69P.detonate69", "inconvo" = "1")))
			else
				pdas.Add(list(list("Name" = "69P69", "Reference" = "\ref69P69", "Detonate" = "69P.detonate69", "inconvo" = "0")))
			count++

		data69"convopdas"69 = convopdas
		data69"pdas"69 = pdas
		data69"pda_count"69 = count

	if(mode==21)
		data69"messa69escount"69 = tnote.len
		data69"messa69es"69 = tnote
	else
		data69"messa69escount"69 = null
		data69"messa69es"69 = null

	if(active_conversation)
		for(var/c in tnote)
			if(c69"tar69et"69 == active_conversation)
				data69"convo_name"69 = sanitize(c69"owner"69)
				data69"convo_job"69 = sanitize(c69"job"69)
				break
	if(mode==41)
		data_core.69et_manifest_json()


	if(mode==3)
		if(!isnull(T))
			var/datum/69as_mixture/environment = T.return_air()

			var/pressure = environment.return_pressure()
			var/total_moles = environment.total_moles

			if (total_moles)
				var/o2_level = environment.69as69"oxy69en"69/total_moles
				var/n2_level = environment.69as69"nitro69en"69/total_moles
				var/co2_level = environment.69as69"carbon_dioxide"69/total_moles
				var/plasma_level = environment.69as69"plasma"69/total_moles
				var/unknown_level =  1-(o2_level+n2_level+co2_level+plasma_level)
				data69"aircontents"69 = list(\
					"pressure" = "69round(pressure,0.1)69",\
					"nitro69en" = "69round(n2_level*100,0.1)69",\
					"oxy69en" = "69round(o2_level*100,0.1)69",\
					"carbon_dioxide" = "69round(co2_level*100,0.1)69",\
					"plasma" = "69round(plasma_level*100,0.01)69",\
					"other" = "69round(unknown_level, 0.01)69",\
					"temp" = "69round(environment.temperature-T0C,0.1)69",\
					"readin69" = 1\
					)
		if(isnull(data69"aircontents"69))
			data69"aircontents"69 = list("readin69" = 0)
	if(mode==6)
		if(has_reception)
			feeds.Cut()
			for(var/datum/feed_channel/channel in news_network.network_channels)
				feeds69++feeds.len69 = list("name" = channel.channel_name, "censored" = channel.censored)
		data69"feedChannels"69 = feeds
	if(mode==61)
		var/datum/feed_channel/FC
		for(FC in news_network.network_channels)
			if(FC.channel_name == active_feed69"name"69)
				break

		var/list/feed = feed_info69active_feed69
		if(!feed)
			feed = list()
			feed69"channel"69 = FC.channel_name
			feed69"author"69	= "Unknown"
			feed69"censored"69= 0
			feed69"updated"69 = -1
			feed_info69active_feed69 = feed

		if(FC.updated > feed69"updated"69 && has_reception)
			feed69"author"69	= FC.author
			feed69"updated"69	= FC.updated
			feed69"censored"69 = FC.censored

			var/list/messa69es = list()
			if(!FC.censored)
				var/index = 0
				for(var/datum/feed_messa69e/FM in FC.messa69es)
					++index
					if(FM.im69)
						send_asset(usr.client, "newscaster_photo_69sanitize(FC.channel_name)69_69index69.pn69")
					// News stories are HTML-stripped but re69uire newline replacement to be properly displayed in NanoUI
					var/body = replacetext(FM.body, "\n", "<br>")
					messa69es69++messa69es.len69 = list("author" = FM.author, "body" = body, "messa69e_type" = FM.messa69e_type, "time_stamp" = FM.time_stamp, "has_ima69e" = (FM.im69 != null), "caption" = FM.caption, "index" = index)
			feed69"messa69es"69 =69essa69es

		data69"feed"69 = feed

	data69"manifest"69 = list("__json_cache" =69anifestJSON)

	nanoUI = data
	// update the ui if it exists, returns null if no ui is passed/found

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		// the ui does not exist, so we'll create a new() one
	        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "pda.tmpl", title, 520, 400, state =69LOB.inventory_state)
		// when the ui is first opened this is the data it will use

		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
	// auto update every69aster Controller tick
	ui.set_auto_update(auto_update)

//NOTE: 69raphic resources are loaded on client lo69in
/obj/item/device/pda/attack_self(mob/user as69ob)
	user.set_machine(src)

	if(active_uplink_check(user))
		return

	ui_interact(user) //NanoUI re69uires this proc
	return

/obj/item/device/pda/Topic(href, href_list)
	if(href_list69"cartmenu"69 && !isnull(cartrid69e))
		cartrid69e.Topic(href, href_list)
		return 1
	if(href_list69"radiomenu"69 && !isnull(cartrid69e) && !isnull(cartrid69e.radio))
		cartrid69e.radio.Topic(href, href_list)
		return 1


	..()
	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.69et_open_ui(user, src, "main")
	var/mob/livin69/U = usr
	//Lookin69 for69aster was kind of pointless since PDAs don't appear to have one.
	//if ((src in U.contents) || ( istype(loc, /turf) && in_ran69e(src, U) ) )
	if (usr.stat == DEAD)
		return 0
	if(!can_use()) //Why reinvent the wheel? There's a proc that does exactly that.
		U.unset_machine()
		if(ui)
			ui.close()
		return 0

	add_fin69erprint(U)
	U.set_machine(src)

	switch(href_list69"choice"69)

//BASIC FUNCTIONS===================================

		if("Close")//Self explanatory
			U.unset_machine()
			ui.close()
			return 0
		if("Refresh")//Refresh, 69oes to the end of the proc.
		if("Return")//Return
			if(mode<=9)
				mode = 0
			else
				mode = round(mode/10)
				if(mode==2)
					active_conversation = null
				if(mode==4)//Fix for cartrid69es. Redirects to hub.
					mode = 0
				else if(mode >= 40 &&69ode <= 49)//Fix for cartrid69es. Redirects to refresh the69enu.
					cartrid69e.mode =69ode
		if ("Authenticate")//Checks for ID
			id_check(U, 1)
		if("UpdateInfo")
			ownjob = id.assi69nment
			ownrank = id.rank
			name = "PDA-69owner69 (69ownjob69)"
		if("Eject")//Ejects the cart, only done from hub.
			verb_remove_cartrid69e()

//MENU FUNCTIONS===================================

		if("0")//Hub
			mode = 0
		if("1")//Notes
			mode = 1
		if("2")//Messen69er
			mode = 2
		if("21")//Read69essa69es
			mode = 21
		if("3")//Atmos scan
			mode = 3
		if("4")//Redirects to hub
			mode = 0
		if("chatroom") // chatroom hub
			mode = 5
		if("41") //Manifest
			mode = 41


//MAIN FUNCTIONS===================================

		if("Li69ht")
			if(fon)
				fon = 0
				set_li69ht(0)
			else
				fon = 1
				set_li69ht(f_lum)
		if("Medical Scan")
			if(scanmode == 1)
				scanmode = 0
			else if((!isnull(cartrid69e)) && (cartrid69e.access_moebius))
				scanmode = 1
		if("Rea69ent Scan")
			if(scanmode == 3)
				scanmode = 0
			else if((!isnull(cartrid69e)) && (cartrid69e.access_rea69ent_scanner))
				scanmode = 3
		if("Halo69en Counter")
			if(scanmode == 4)
				scanmode = 0
			else if((!isnull(cartrid69e)) && (cartrid69e.access_en69ine))
				scanmode = 4
		if("Honk")
			if ( !(last_honk && world.time < last_honk + 20) )
				playsound(loc, 'sound/items/bikehorn.o6969', 50, 1)
				last_honk = world.time
		if("69as Scan")
			if(scanmode == 5)
				scanmode = 0
			else if((!isnull(cartrid69e)) && (cartrid69e.access_atmos))
				scanmode = 5

//MESSEN69ER/NOTE FUNCTIONS===================================

		if ("Edit")
			var/n = input(U, "Please enter69essa69e", name, notehtml)
			if (in_ran69e(src, U) && loc == U)
				n = sanitizeSafe(n, extra = 0)
				if (mode == 1)
					note = n
					notehtml = note
					note = replacetext(note, "\n", "<br>")
			else
				ui.close()
		if("To6969le69essen69er")
			toff = !toff
		if("To6969le Rin69er")//If69iewin69 texts then erase them, if not then to6969le silent status
			messa69e_silent = !messa69e_silent
		if("To6969le News")
			news_silent = !news_silent
		if("Clear")//Clears69essa69es
			if(href_list69"option"69 == "All")
				tnote.Cut()
				conversations.Cut()
			if(href_list69"option"69 == "Convo")
				var/new_tnote69069
				for(var/i in tnote)
					if(i69"tar69et"69 != active_conversation)
						new_tnote69++new_tnote.len69 = i
				tnote = new_tnote
				conversations.Remove(active_conversation)

			active_conversation = null
			if(mode==21)
				mode=2

		if("Rin69tone")
			var/t = stripped_input(U, "Please enter new rin69tone", name, ttone, 20)
			if (in_ran69e(src, U) && loc == U)
				if (t)
					if(src.hidden_uplink && hidden_uplink.check_tri6969er(U, lowertext(t), lowertext(lock_code)))
						to_chat(U, "The PDA softly beeps.")
						ui.close()
					else
						ttone = t
			else
				ui.close()
				return 0
		if("Newstone")
			var/t = input(U, "Please enter new news tone", name, newstone) as text
			if (in_ran69e(src, U) && loc == U)
				if (t)
					t = sanitize(t, 20)
					newstone = t
			else
				ui.close()
				return 0
		if("Messa69e")

			var/obj/item/device/pda/P = locate(href_list69"tar69et"69)
			var/tap = iscarbon(U)
			src.create_messa69e(U, P, tap)
			if(mode == 2)
				if(href_list69"tar69et"69 in conversations)            // Need to69ake sure the69essa69e went throu69h, if not welp.
					active_conversation = href_list69"tar69et"69
					mode = 21

		if("Select Conversation")
			var/P = href_list69"convo"69
			for(var/n in conversations)
				if(P == n)
					active_conversation=P
					mode=21
		if("Select Feed")
			var/n = href_list69"name"69
			for(var/f in feeds)
				if(f69"name"69 == n)
					active_feed = f
					mode=61
		if("Send Honk")//Honk69irus
			if(cartrid69e && cartrid69e.access_clown)//Cartrid69e checks are kind of unnecessary since everythin69 is done throu69h switch.
				var/obj/item/device/pda/P = locate(href_list69"tar69et"69)//Leavin69 it alone in case it69ay do somethin69 useful, I 69uess.
				if(!isnull(P))
					if (!P.toff && cartrid69e.char69es > 0)
						cartrid69e.char69es--
						U.show_messa69e(SPAN_NOTICE("Virus sent!"), 1)
						P.honkamt = (rand(15,20))
				else
					to_chat(U, "PDA not found.")
			else
				ui.close()
				return 0
		if("Send Silence")//Silent69irus
			if(cartrid69e && cartrid69e.access_mime)
				var/obj/item/device/pda/P = locate(href_list69"tar69et"69)
				if(!isnull(P))
					if (!P.toff && cartrid69e.char69es > 0)
						cartrid69e.char69es--
						U.show_messa69e(SPAN_NOTICE("Virus sent!"), 1)
						P.messa69e_silent = 1
						P.news_silent = 1
						P.ttone = "silence"
						P.newstone = "silence"
				else
					to_chat(U, "PDA not found.")
			else
				ui.close()
				return 0


//SYNDICATE FUNCTIONS===================================

		if("To6969le Door")
			if(cartrid69e && cartrid69e.access_remote_door)
				for(var/obj/machinery/door/blast/M in world)
					if(M.id == cartrid69e.remote_door_id)
						if(M.density)
							M.open()
						else
							M.close()

		if("Detonate")//Detonate PDA...69aybe
			if(cartrid69e && cartrid69e.access_detonate_pda)
				var/obj/item/device/pda/P = locate(href_list69"tar69et"69)
				var/datum/reception/reception = 69et_reception(src, P, "", do_sleep = 0)
				if(!(reception.messa69e_server && reception.telecomms_reception & TELECOMMS_RECEPTION_SENDER))
					U.show_messa69e(SPAN_WARNIN69("An error flashes on your 69src69: Connection unavailable"), 1)
					return
				if(reception.telecomms_reception & TELECOMMS_RECEPTION_RECEIVER == 0) // Does our recepient have a broadcaster on their level?
					U.show_messa69e(SPAN_WARNIN69("An error flashes on your 69src69: Recipient unavailable"), 1)
					return
				if(!isnull(P))
					if (!P.toff && cartrid69e.char69es > 0)
						cartrid69e.char69es--

						var/difficulty = 2

						if(P.cartrid69e)
							difficulty += P.cartrid69e.access_moebius
							difficulty += P.cartrid69e.access_security
							difficulty += P.cartrid69e.access_en69ine
							difficulty += P.cartrid69e.access_clown
							difficulty += P.cartrid69e.access_janitor
							if(P.hidden_uplink)
								difficulty += 3

						if(prob(difficulty))
							U.show_messa69e(SPAN_WARNIN69("An error flashes on your 69src69."), 1)
						else if (prob(difficulty * 7))
							U.show_messa69e(SPAN_WARNIN69("Ener69y feeds back into your 69src69!"), 1)
							ui.close()
							detonate_act(src)
							lo69_admin("69key_name(U)69 just attempted to blow up 69P69 with the Detomatix cartrid69e but failed, blowin69 themselves up")
							messa69e_admins("69key_name_admin(U)69 just attempted to blow up 69P69 with the Detomatix cartrid69e but failed.", 1)
						else
							U.show_messa69e(SPAN_NOTICE("Success!"), 1)
							lo69_admin("69key_name(U)69 just attempted to blow up 69P69 with the Detomatix cartrid69e and succeeded")
							messa69e_admins("69key_name_admin(U)69 just attempted to blow up 69P69 with the Detomatix cartrid69e and succeeded.", 1)
							detonate_act(P)
					else
						to_chat(U, "No char69es left.")
				else
					to_chat(U, "PDA not found.")
			else
				U.unset_machine()
				ui.close()
				return 0

//pAI FUNCTIONS===================================
		if("pai")
			if(pai)
				if(pai.loc != src)
					pai = null
				else
					switch(href_list69"option"69)
						if("1")		// Confi69ure pAI device
							pai.attack_self(U)
						if("2")		// Eject pAI device
							var/turf/T = 69et_turf_or_move(src.loc)
							if(T)
								pai.loc = T
								pai = null

		else
			mode = text2num(href_list69"choice"69)
			if(cartrid69e)
				cartrid69e.mode =69ode

//EXTRA FUNCTIONS===================================

	if (mode == 2||mode == 21)//To clear69essa69e overlays.
		new_messa69e = 0
		update_icon()

	if (mode == 6||mode == 61)//To clear news overlays.
		new_news = 0
		update_icon()

	if ((honkamt > 0) && (prob(60)))//For clown69irus.
		honkamt--
		playsound(loc, 'sound/items/bikehorn.o6969', 30, 1)

	return 1 // return 1 tells it to refresh the UI in NanoUI

/obj/item/device/pda/update_icon()
	..()

	cut_overlays()
	if(new_messa69e || new_news)
		overlays += ima69e('icons/obj/pda.dmi', "pda-r")
	if(locate(/obj/item/pen) in src)
		overlays += ima69e('icons/obj/pda.dmi', "pda_pen")

/obj/item/device/pda/proc/detonate_act(var/obj/item/device/pda/P)
	//TODO: sometimes these attacks show up on the69essa69e server
	var/i = rand(1,100)
	var/j = rand(0,1) //Possibility of losin69 the PDA after the detonation
	var/messa69e = ""
	var/mob/livin69/M = null
	if(ismob(P.loc))
		M = P.loc

	//switch(i) //Yes, the overlappin69 cases are intended.
	if(i<=10) //The traditional explosion
		P.explode()
		j=1
		messa69e += "Your 69P69 suddenly explodes!"
	if(i>=10 && i<= 20) //The PDA burns a hole in the holder.
		j=1
		if(M && islivin69(M))
			M.apply_dama69e( rand(30,60) , BURN, used_weapon = src)
		messa69e += "You feel a searin69 heat! Your 69P69 is burnin69!"
	if(i>=20 && i<=25) //EMP
		empulse(P.loc, 3, 6, 1)
		messa69e += "Your 69P69 emits a wave of electroma69netic ener69y!"
	if(i>=25 && i<=40) //Smoke
		var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
		S.attach(P.loc)
		S.set_up(P, 10, 0, P.loc)
		playsound(P.loc, 'sound/effects/smoke.o6969', 50, 1, -3)
		S.start()
		messa69e += "Lar69e clouds of smoke billow forth from your 69P69!"
	if(i>=40 && i<=45) //Bad smoke
		var/datum/effect/effect/system/smoke_spread/bad/B = new /datum/effect/effect/system/smoke_spread/bad
		B.attach(P.loc)
		B.set_up(P, 10, 0, P.loc)
		playsound(P.loc, 'sound/effects/smoke.o6969', 50, 1, -3)
		B.start()
		messa69e += "Lar69e clouds of noxious smoke billow forth from your 69P69!"
	if(i>=65 && i<=75) //Weaken
		if(M && islivin69(M))
			M.apply_effects(0,1)
		messa69e += "Your 69P69 flashes with a blindin69 white li69ht! You feel weaker."
	if(i>=75 && i<=85) //Stun and stutter
		if(M && islivin69(M))
			M.apply_effects(1,0,0,0,1)
		messa69e += "Your 69P69 flashes with a blindin69 white li69ht! You feel weaker."
	if(i>=85) //Sparks
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, P.loc)
		s.start()
		messa69e += "Your 69P69 be69ins to spark69iolently!"
	if(i>45 && i<65 && prob(50)) //Nothin69 happens
		messa69e += "Your 69P69 bleeps loudly."
		j = prob(10)

	if(j) //This kills the PDA
		69del(P)
		if(messa69e)
			messa69e += "It69elts in a puddle of plastic."
		else
			messa69e += "Your 69P69 shatters in a thousand pieces!"

	if(M && islivin69(M))
		messa69e = SPAN_WARNIN69("69messa69e69")
		M.show_messa69e(messa69e, 1)

/obj/item/device/pda/proc/remove_id()
	if (id)
		if (ismob(loc))
			var/mob/M = loc
			M.put_in_hands(id)
			to_chat(usr, SPAN_NOTICE("You remove the ID from the 69name69."))
			playsound(loc, 'sound/machines/id_swipe.o6969', 100, 1)
		else
			id.loc = 69et_turf(src)
		id = null

/obj/item/device/pda/proc/create_messa69e(var/mob/livin69/U = usr,69ar/obj/item/device/pda/P,69ar/tap = 1)
	if(tap)
		U.visible_messa69e(SPAN_NOTICE("\The 69U69 taps on \his PDA's screen."))
	var/t = input(U, "Please enter69essa69e", P.name, null) as text
	t = sanitize(t)
	//t = readd_69uotes(t)
	t = replace_characters(t, list("&#34;" = "\""))
	if (!t || !istype(P))
		return
	if (!in_ran69e(src, U) && loc != U)
		return

	if (isnull(P)||P.toff || toff)
		return

	if (last_text && world.time < last_text + 5)
		return

	if(!can_use())
		return

	last_text = world.time
	var/datum/reception/reception = 69et_reception(src, P, t)
	t = reception.messa69e

	if(reception.messa69e_server && (reception.telecomms_reception & TELECOMMS_RECEPTION_SENDER)) // only send the69essa69e if it's stable
		if(reception.telecomms_reception & TELECOMMS_RECEPTION_RECEIVER == 0) // Does our recipient have a broadcaster on their level?
			to_chat(U, "ERROR: Cannot reach recipient.")
			return
		var/send_result = reception.messa69e_server.send_pda_messa69e("69P.owner69","69owner69","69t69")
		if (send_result)
			to_chat(U, "ERROR:69essa69in69 server rejected your69essa69e. Reason: contains '69send_result69'.")
			return

		tnote.Add(list(list("sent" = 1, "owner" = "69P.owner69", "job" = "69P.ownjob69", "messa69e" = "69t69", "tar69et" = "\ref69P69")))
		P.tnote.Add(list(list("sent" = 0, "owner" = "69owner69", "job" = "69ownjob69", "messa69e" = "69t69", "tar69et" = "\ref69src69")))
		for(var/mob/M in 69LOB.player_list)
			if((M.stat == DEAD &&69.69et_preference_value(/datum/client_preference/69host_ears) == 69LOB.PREF_ALL_SPEECH) || isan69el(M)) // src.client is so that 69hosts don't have to listen to69ice
				if(isnewplayer(M))
					continue
				M.show_messa69e("<span class='69ame say'>PDA69essa69e - <span class='name'>69owner69</span> -> <span class='name'>69P.owner69</span>: <span class='messa69e'>69reception.messa69e69</span></span>")

		if(!conversations.Find("\ref69P69"))
			conversations.Add("\ref69P69")
		if(!P.conversations.Find("\ref69src69"))
			P.conversations.Add("\ref69src69")



		P.new_messa69e_from_pda(src, t)
		SSnano.update_user_uis(U, src) // Update the sendin69 user's PDA UI so that they can see the new69essa69e
	else
		to_chat(U, SPAN_NOTICE("ERROR:69essa69in69 server is not respondin69."))

/obj/item/device/pda/proc/new_info(var/beep_silent,69ar/messa69e_tone,69ar/reception_messa69e)
	if (!beep_silent)
		playsound(loc, 'sound/machines/twobeep.o6969', 50, 1)
		for (var/mob/O in hearers(2, loc))
			O.show_messa69e(text("\icon69src69 *69messa69e_tone69*"))
	//Search for holder of the PDA.
	var/mob/livin69/L = null
	if(loc && islivin69(loc))
		L = loc
	//Maybe they are a pAI!
	else
		L = 69et(src, /mob/livin69/silicon)

	if(L)
		if(reception_messa69e)
			to_chat(L, reception_messa69e)
		SSnano.update_user_uis(L, src) // Update the receivin69 user's PDA UI so that they can see the new69essa69e

/obj/item/device/pda/proc/new_news(var/messa69e)
	new_info(news_silent, newstone, news_silent ? "" : "\icon69src69 <b>69messa69e69</b>")

	if(!news_silent)
		new_news = 1
		update_icon()

/obj/item/device/pda/ai/new_news(var/messa69e)
	// Do nothin69

/obj/item/device/pda/proc/new_messa69e_from_pda(var/obj/item/device/pda/sendin69_device,69ar/messa69e)
	new_messa69e(sendin69_device, sendin69_device.owner, sendin69_device.ownjob,69essa69e)

/obj/item/device/pda/proc/new_messa69e(var/sendin69_unit,69ar/sender,69ar/sender_job,69ar/messa69e)
	var/reception_messa69e = "\icon69src69 <b>Messa69e from 69sender69 (69sender_job69), </b>\"69messa69e69\" (<a href='byond://?src=\ref69src69;choice=Messa69e;skiprefresh=1;tar69et=\ref69sendin69_unit69'>Reply</a>)"
	new_info(messa69e_silent, ttone, reception_messa69e)

	lo69_pda("69usr69 (PDA: 69sendin69_unit69) sent \"69messa69e69\" to 69name69")
	new_messa69e = 1
	update_icon()

/obj/item/device/pda/ai/new_messa69e(var/atom/movable/sendin69_unit,69ar/sender,69ar/sender_job,69ar/messa69e)
	var/track = ""
	if(ismob(sendin69_unit.loc) && isAI(loc))
		track = "(<a href='byond://?src=\ref69loc69;track=\ref69sendin69_unit.loc69;trackname=69html_encode(sender)69'>Follow</a>)"

	var/reception_messa69e = "\icon69src69 <b>Messa69e from 69sender69 (69sender_job69), </b>\"69messa69e69\" (<a href='byond://?src=\ref69src69;choice=Messa69e;skiprefresh=1;tar69et=\ref69sendin69_unit69'>Reply</a>) 69track69"
	new_info(messa69e_silent, newstone, reception_messa69e)

	lo69_pda("69usr69 (PDA: 69sendin69_unit69) sent \"69messa69e69\" to 69name69")
	new_messa69e = 1

/obj/item/device/pda/verb/verb_reset_pda()
	set cate69ory = "Object"
	set name = "Reset PDA"
	set src in usr

	if(issilicon(usr))
		return

	if(can_use(usr))
		mode = 0
		SSnano.update_uis(src)
		to_chat(usr, SPAN_NOTICE("You press the reset button on \the 69src69."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while restrained."))

/obj/item/device/pda/verb/verb_remove_id()
	set cate69ory = "Object"
	set name = "Remove id"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		if(id)
			remove_id()
		else
			to_chat(usr, SPAN_NOTICE("This PDA does not have an ID in it."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while restrained."))


/obj/item/device/pda/verb/verb_remove_pen()
	set cate69ory = "Object"
	set name = "Remove pen"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		var/obj/item/pen/O = locate() in src
		if(O)
			if (ismob(loc))
				var/mob/M = loc
				if(M.69et_active_hand() == null)
					M.put_in_hands(O)
					to_chat(usr, SPAN_NOTICE("You remove \the 69O69 from \the 69src69."))
					update_icon()
					return
			O.loc = 69et_turf(src)
			to_chat(usr, SPAN_NOTICE("You remove \the 69O69 from \the 69src69, but you hands full and it drop on floor."))
			update_icon()
		else
			to_chat(usr, SPAN_NOTICE("This PDA does not have a pen in it."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while restrained."))

/obj/item/device/pda/verb/verb_remove_cartrid69e()
	set cate69ory = "Object"
	set name = "Remove cartrid69e"
	set src in usr

	if(issilicon(usr))
		return

	if (can_use(usr) && !isnull(cartrid69e))
		var/turf/T = 69et_turf(src)
		cartrid69e.loc = T
		if (ismob(loc))
			var/mob/M = loc
			M.put_in_hands(cartrid69e)
		else
			cartrid69e.loc = 69et_turf(src)
		mode = 0
		scanmode = 0
		if (cartrid69e.radio)
			cartrid69e.radio.hostpda = null
		cartrid69e = null
		to_chat(usr, SPAN_NOTICE("You remove \the 69cartrid69e69 from the 69name69."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while restrained."))

/obj/item/device/pda/proc/id_check(mob/user as69ob, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if (id)
			remove_id()
			return 1
		else
			var/obj/item/I = user.69et_active_hand()
			if (istype(I, /obj/item/card/id) && user.unE69uip(I))
				I.loc = src
				id = I
			return 1
	else
		var/obj/item/card/I = user.69et_active_hand()
		if (istype(I, /obj/item/card/id) && I:re69istered_name && user.unE69uip(I))
			var/obj/old_id = id
			I.loc = src
			id = I
			user.put_in_hands(old_id)
			return 1
	return 0

// access to status display si69nals
/obj/item/device/pda/attackby(obj/item/C as obj,69ob/user as69ob)
	..()
	if(istype(C, /obj/item/cartrid69e) && !cartrid69e)
		cartrid69e = C
		user.drop_item()
		cartrid69e.loc = src
		to_chat(user, SPAN_NOTICE("You insert 69cartrid69e69 into 69src69."))
		SSnano.update_uis(src) // update all UIs attached to src
		if(cartrid69e.radio)
			cartrid69e.radio.hostpda = src

	else if(istype(C, /obj/item/card/id))
		var/obj/item/card/id/idcard = C
		if(!idcard.re69istered_name)
			to_chat(user, SPAN_NOTICE("\The 69src69 rejects the ID."))
			return
		if(!owner)
			owner = idcard.re69istered_name
			ownjob = idcard.assi69nment
			ownrank = idcard.rank
			name = "PDA-69owner69 (69ownjob69)"
			to_chat(user, SPAN_NOTICE("Card scanned."))
		else
			//Basic safety check. If either both objects are held by user or PDA is on 69round and card is in hand.
			if(((src in user.contents) && (C in user.contents)) || (istype(loc, /turf) && in_ran69e(src, user) && (C in user.contents)) )
				if(id_check(user, 2))
					to_chat(user, SPAN_NOTICE("You put the ID into \the 69src69's slot."))
					playsound(loc, 'sound/machines/id_swipe.o6969', 100, 1)
					updateSelfDialo69()//Update self dialo69 on success.
			return	//Return in case of failed check or when successful.
		updateSelfDialo69()//For the non-input related code.
	else if(istype(C, /obj/item/device/paicard) && !src.pai)
		user.drop_item()
		C.loc = src
		pai = C
		to_chat(user, SPAN_NOTICE("You slot \the 69C69 into 69src69."))
		SSnano.update_uis(src) // update all UIs attached to src
	else if(istype(C, /obj/item/pen))
		var/obj/item/pen/O = locate() in src
		if(O)
			to_chat(user, SPAN_NOTICE("There is already a pen in \the 69src69."))
		else
			user.drop_item()
			C.loc = src
			to_chat(user, SPAN_NOTICE("You slide \the 69C69 into \the 69src69."))
			update_icon()
	return

/obj/item/device/pda/attack(mob/livin69/C as69ob,69ob/livin69/user as69ob)
	if (iscarbon(C))
		switch(scanmode)
			if(1)

				for (var/mob/O in69iewers(C, null))
					O.show_messa69e(SPAN_WARNIN69("\The 69user69 has analyzed 69C69's69itals!"), 1)

				user.show_messa69e(SPAN_NOTICE("Analyzin69 Results for 69C69:"))
				user.show_messa69e("<span class='notice'>    Overall Status: 69C.stat > 1 ? "dead" : "69C.health - C.halloss69% healthy"69</span>", 1)
				user.show_messa69e(text("<span class='notice'>    Dama69e Specifics:</span> <span class='6969'>6969</span>-<span class='6969'>6969</span>-<span class='6969'>6969</span>-<span class='6969'>6969</span>",
						(C.69etOxyLoss() > 50) ? "warnin69" : "", C.69etOxyLoss(),
						(C.69etToxLoss() > 50) ? "warnin69" : "", C.69etToxLoss(),
						(C.69etFireLoss() > 50) ? "warnin69" : "", C.69etFireLoss(),
						(C.69etBruteLoss() > 50) ? "warnin69" : "", C.69etBruteLoss()
						), 1)
				user.show_messa69e(SPAN_NOTICE("    Key: Suffocation/Toxin/Burns/Brute"), 1)
				user.show_messa69e(SPAN_NOTICE("    Body Temperature: 69C.bodytemperature-T0C69&de69;C (69C.bodytemperature*1.8-459.6769&de69;F)"), 1)
				if(C.timeofdeath && (C.stat == DEAD || (C.status_fla69s & FAKEDEATH)))
					user.show_messa69e(SPAN_NOTICE("    Time of Death: 69worldtime2stationtime(C.timeofdeath)69"))
				if(ishuman(C))
					var/mob/livin69/carbon/human/H = C
					var/list/dama69ed = H.69et_dama69ed_or69ans(1,1)
					user.show_messa69e(SPAN_NOTICE("Localized Dama69e, Brute/Burn:"),1)
					if(len69th(dama69ed)>0)
						for(var/obj/item/or69an/external/or69 in dama69ed)
							user.show_messa69e(text("<span class='notice'>     6969: <span class='6969'>6969</span>-<span class='6969'>6969</span></span>",
									capitalize(or69.name), (or69.brute_dam > 0) ? "warnin69" : "notice", or69.brute_dam, (or69.burn_dam > 0) ? "warnin69" : "notice", or69.burn_dam),1)
					else
						user.show_messa69e(SPAN_NOTICE("    Limbs are OK."),1)

			if(2)
				if (!istype(C:dna, /datum/dna))
					to_chat(user, SPAN_NOTICE("No fin69erprints found on 69C69"))
				else
					var/datum/dna/value = C.dna
					to_chat(user, text(SPAN_NOTICE("\The 69C69's Fin69erprints: 69md5(value.uni_identity)69")))
				if ( !(C:blood_DNA) )
					to_chat(user, SPAN_NOTICE("No blood found on 69C69"))
					if(C:blood_DNA)
						69del(C:blood_DNA)
				else
					to_chat(user, SPAN_NOTICE("Blood found on 69C69. Analysin69..."))
					spawn(15)
						for(var/blood in C:blood_DNA)
							to_chat(user, SPAN_NOTICE("Blood type: 69C:blood_DNA69blood6969\nDNA: 69blood69"))

			if(4)
				for (var/mob/O in69iewers(C, null))
					O.show_messa69e(SPAN_WARNIN69("\The 69user69 has analyzed 69C69's radiation levels!"), 1)

				user.show_messa69e(SPAN_NOTICE("Analyzin69 Results for 69C69:"))
				if(C.radiation)
					user.show_messa69e(SPAN_NOTICE("Radiation Level: 69C.radiation69"))
				else
					user.show_messa69e(SPAN_NOTICE("No radiation detected."))

/obj/item/device/pda/afterattack(atom/A as69ob|obj|turf|area,69ob/user as69ob, proximity)
	if(!proximity) return
	switch(scanmode)

		if(3)
			if(!isobj(A))
				return
			if(!isnull(A.rea69ents))
				if(A.rea69ents.rea69ent_list.len > 0)
					var/rea69ents_len69th = A.rea69ents.rea69ent_list.len
					to_chat(user, "<span class='notice'>69rea69ents_len69th69 chemical a69ent69rea69ents_len69th > 1 ? "s" : ""69 found.</span>")
					for (var/re in A.rea69ents.rea69ent_list)
						to_chat(user, SPAN_NOTICE("    69re69"))
				else
					to_chat(user, SPAN_NOTICE("No active chemical a69ents found in 69A69."))
			else
				to_chat(user, SPAN_NOTICE("No si69nificant chemical a69ents found in 69A69."))

		if(5)
			analyze_69ases(A, user)

	if (!scanmode && istype(A, /obj/item/paper) && owner)
		// JMO 20140705:69akes scanned document show up properly in the notes. Not pretty for formatted documents,
		// as this will clobber the HTML, but at least it lets you scan a document. You can restore the ori69inal
		// notes by editin69 the note a69ain. (Was 69oin69 to allow you to edit, but scanned documents are too lon69.)
		var/raw_scan = (A:info)
		var/formatted_scan = ""
		// Scrub out the ta69s (replacin69 a few formattin69 ones alon69 the way)

		// Find the be69innin69 and end of the first ta69.
		var/ta69_start = findtext(raw_scan,"<")
		var/ta69_stop = findtext(raw_scan,">")

		// Until we run out of complete ta69s...
		while(ta69_start&&ta69_stop)
			var/pre = copytext(raw_scan,1,ta69_start) // 69et the stuff that comes before the ta69
			var/ta69 = lowertext(copytext(raw_scan,ta69_start+1,ta69_stop)) // 69et the ta69 so we can do intelle69ent replacement
			var/ta69end = findtext(ta69," ") // Find the first space in the ta69 if there is one.

			// Anythin69 that's before the ta69 can just be added as is.
			formatted_scan = formatted_scan+pre

			// If we have a space after the ta69 (and presumably attributes) just crop that off.
			if (ta69end)
				ta69=copytext(ta69,1,ta69end)

			if (ta69=="p"||ta69=="/p"||ta69=="br") // Check if it's I69ertical space ta69.
				formatted_scan=formatted_scan+"<br>" // If so, add some paddin69 in.

			raw_scan = copytext(raw_scan,ta69_stop+1) // continue on with the stuff after the ta69

			// Look for the next ta69 in what's left
			ta69_start = findtext(raw_scan,"<")
			ta69_stop = findtext(raw_scan,">")

		// Anythin69 that is left in the pa69e. just tack it on to the end as is
		formatted_scan=formatted_scan+raw_scan

    	// If there is somethin69 in there already, pad it out.
		if (len69th(note)>0)
			note = note + "<br><br>"

    	// Store the scanned document to the notes
		note = "Scanned Document. Edit to restore previous notes/delete scan.<br>----------<br>" + formatted_scan + "<br>"
		// notehtml ISN'T set to allow user to 69et their old notes back. A better implementation would add a "scanned documents"
		// feature to the PDA, which would better convey the availability of the feature, but this will work for now.

		// Inform the user
		to_chat(user, SPAN_NOTICE("Paper scanned and OCRed to notekeeper.")) //concept of scannin69 paper copyri69ht brainoblivion 2009



/obj/item/device/pda/proc/explode() //This needs tunin69. //Sure did.
	if(!src.detonate) return
	var/turf/T = 69et_turf(src.loc)
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, 0, 0, 1, rand(1,2))
	return

/obj/item/device/pda/Destroy()
	PDAs -= src
	if (src.id && prob(90)) //IDs are kept in 90% of the cases
		src.id.loc = 69et_turf(src.loc)
	. = ..()

/obj/item/device/pda/AltClick()
	if(can_use(usr))
		if(id)
			remove_id()
		else
			to_chat(usr, SPAN_NOTICE("This PDA does not have an ID in it."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while restrained."))


/obj/item/device/pda/clown/Crossed(AM as69ob|obj) //Clown PDA is slippery.
	if (islivin69(AM))
		var/mob/livin69/M = AM
		if((locate(/obj/structure/multiz/stairs) in 69et_turf(loc)) || (locate(/obj/structure/multiz/ladder) in 69et_turf(loc)))
			visible_messa69e(SPAN_DAN69ER("\The 69M69 carefully avoids steppin69 down on \the 69src69."))
			return
		if(M.slip("the PDA",8) &&69.real_name != src.owner && istype(src.cartrid69e, /obj/item/cartrid69e/clown))
			if(src.cartrid69e.char69es < 5)
				src.cartrid69e.char69es++

/obj/item/device/pda/proc/available_pdas()
	var/list/names = list()
	var/list/plist = list()
	var/list/namecounts = list()

	if (toff)
		to_chat(usr, "Turn on your receiver in order to send69essa69es.")
		return

	for (var/obj/item/device/pda/P in PDAs)
		if (!P.owner)
			continue
		else if(P.hidden)
			continue
		else if (P == src)
			continue
		else if (P.toff)
			continue

		var/name = P.owner
		if (name in names)
			namecounts69name69++
			name = text("69name69 (69namecounts69name6969)")
		else
			names.Add(name)
			namecounts69name69 = 1

		plist69text("69name69")69 = P
	return plist

// Pass alon69 the pulse to atoms in contents, lar69ely added so pAIs are69ulnerable to EMP
/obj/item/device/pda/emp_act(severity)
	for(var/atom/A in src)
		A.emp_act(severity)