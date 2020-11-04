/datum/preferences
	var/flavor_text
	var/list/flavour_texts_robot = list()

/datum/category_item/player_setup_item/physical/flavor
	name = "Flavor"
	sort_order = 3

/datum/category_item/player_setup_item/physical/flavor/load_character(var/savefile/S)
	from_file(S["flavor_text"], pref.flavor_text)

	//Flavour text for robots.
	from_file(S["flavour_texts_robot_Default"], pref.flavour_texts_robot["Default"])
	for(var/module in robot_modules)
		from_file(S["flavour_texts_robot_[module]"], pref.flavour_texts_robot[module])

/datum/category_item/player_setup_item/physical/flavor/save_character(var/savefile/S)
	to_file(S["flavor_text"], pref.flavor_text)

	to_file(S["flavour_texts_robot_Default"], pref.flavour_texts_robot["Default"])
	for(var/module in robot_modules)
		to_file(S["flavour_texts_robot_[module]"], pref.flavour_texts_robot[module])

/datum/category_item/player_setup_item/physical/flavor/sanitize_character()
	if(!pref.flavor_text)
		pref.flavor_text = ""
	if(!istype(pref.flavour_texts_robot))
		pref.flavour_texts_robot = list()

/datum/category_item/player_setup_item/physical/flavor/content(var/mob/user)
	. = list()
	. += "<b>Flavor:</b><br>"
	. += "<a href='?src=\ref[src];flavor_text=open'>Set Flavor Text</a><br/>"
	. += "<a href='?src=\ref[src];flavour_text_robot=open'>Set Robot Flavor Text</a><br/>"
	return jointext(.,null)

/datum/category_item/player_setup_item/physical/flavor/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["flavor_text"] && href_list["flavor_text"] == "open")
		var/msg = sanitize(input(usr,"Give a general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text", pref.flavor_text, "message"), extra = 0)
		if(CanUseTopic(user))
			if(msg)
				pref.flavor_text = msg
		return TOPIC_HANDLED

	else if(href_list["flavour_text_robot"])
		switch(href_list["flavour_text_robot"])
			if("open")
			if("Default")
				var/msg = sanitize(input(usr,"Set the default flavour text for your robot. It will be used for any module without individual setting.","Flavour Text",html_decode(pref.flavour_texts_robot["Default"]), "message"), extra = 0)
				if(CanUseTopic(user))
					pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
			else
				var/msg = sanitize(input(usr,"Set the flavour text for your robot with [href_list["flavour_text_robot"]] module. If you leave this empty, default flavour text will be used for this module.","Flavour Text",html_decode(pref.flavour_texts_robot[href_list["flavour_text_robot"]]), "message"), extra = 0)
				if(CanUseTopic(user))
					pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
		SetFlavourTextRobot(user)
		return TOPIC_HANDLED

	return ..()

/datum/category_item/player_setup_item/physical/flavor/proc/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Robot Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavour_text_robot=Default'>Default:</a> "
	HTML += TextPreview(pref.flavour_texts_robot["Default"])
	HTML += "<hr />"
	for(var/module in robot_modules)
		HTML += "<a href='?src=\ref[src];flavour_text_robot=[module]'>[module]:</a> "
		HTML += TextPreview(pref.flavour_texts_robot[module])
		HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavour_text_robot;size=430x300")
	return
