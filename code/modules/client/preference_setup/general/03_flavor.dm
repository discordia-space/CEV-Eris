/datum/preferences
	var/flavor_text
	var/list/flavour_texts_robot = list()

/datum/category_item/player_setup_item/physical/flavor
	name = "Flavor"
	sort_order = 3

/datum/category_item/player_setup_item/physical/flavor/load_character(var/savefile/S)
	from_file(S69"flavor_text"69, pref.flavor_text)

	//Flavour text for robots.
	from_file(S69"flavour_texts_robot_Default"69, pref.flavour_texts_robot69"Default"69)
	for(var/module in robot_modules)
		from_file(S69"flavour_texts_robot_69module69"69, pref.flavour_texts_robot69module69)

/datum/category_item/player_setup_item/physical/flavor/save_character(var/savefile/S)
	to_file(S69"flavor_text"69, pref.flavor_text)

	to_file(S69"flavour_texts_robot_Default"69, pref.flavour_texts_robot69"Default"69)
	for(var/module in robot_modules)
		to_file(S69"flavour_texts_robot_69module69"69, pref.flavour_texts_robot69module69)

/datum/category_item/player_setup_item/physical/flavor/sanitize_character()
	if(!pref.flavor_text)
		pref.flavor_text = ""
	if(!istype(pref.flavour_texts_robot))
		pref.flavour_texts_robot = list()

/datum/category_item/player_setup_item/physical/flavor/content(var/mob/user)
	. = list()
	. += "<b>Flavor:</b><br>"
	. += "<a href='?src=\ref69src69;flavor_text=open'>Set Flavor Text</a><br/>"
	. += "<a href='?src=\ref69src69;flavour_text_robot=open'>Set Robot Flavor Text</a><br/>"
	return jointext(.,null)

/datum/category_item/player_setup_item/physical/flavor/OnTopic(var/href,var/list/href_list,69ar/mob/user)
	if(href_list69"flavor_text"69 && href_list69"flavor_text"69 == "open")
		var/msg = sanitize(input(usr,"Give a general description of your character. This will be shown regardless of clothing, and69ay include OOC notes and preferences.","Flavor Text", pref.flavor_text, "message"), extra = 0)
		if(CanUseTopic(user))
			if(msg)
				pref.flavor_text =69sg
		return TOPIC_HANDLED

	else if(href_list69"flavour_text_robot"69)
		switch(href_list69"flavour_text_robot"69)
			if("open")
			if("Default")
				var/msg = sanitize(input(usr,"Set the default flavour text for your robot. It will be used for any69odule without individual setting.","Flavour Text",html_decode(pref.flavour_texts_robot69"Default"69), "message"), extra = 0)
				if(CanUseTopic(user))
					pref.flavour_texts_robot69href_list69"flavour_text_robot"6969 =69sg
			else
				var/msg = sanitize(input(usr,"Set the flavour text for your robot with 69href_list69"flavour_text_robot"696969odule. If you leave this empty, default flavour text will be used for this69odule.","Flavour Text",html_decode(pref.flavour_texts_robot69href_list69"flavour_text_robot"6969), "message"), extra = 0)
				if(CanUseTopic(user))
					pref.flavour_texts_robot69href_list69"flavour_text_robot"6969 =69sg
		SetFlavourTextRobot(user)
		return TOPIC_HANDLED

	return ..()

/datum/category_item/player_setup_item/physical/flavor/proc/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Robot Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref69src69;flavour_text_robot=Default'>Default:</a> "
	HTML += TextPreview(pref.flavour_texts_robot69"Default"69)
	HTML += "<hr />"
	for(var/module in robot_modules)
		HTML += "<a href='?src=\ref69src69;flavour_text_robot=69module69'>69module69:</a> "
		HTML += TextPreview(pref.flavour_texts_robot69module69)
		HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavour_text_robot;size=430x300")
	return
