/datum/preferences
	var/list/relations
	var/list/relations_info

/datum/category_item/player_setup_item/relations
	name = "Matchmaking"
	sort_order = 1

/datum/category_item/player_setup_item/relations/load_character(var/savefile/S)
	S69"relations"69	>> pref.relations
	S69"relations_info"69	>> pref.relations_info

/datum/category_item/player_setup_item/relations/save_character(var/savefile/S)
	S69"relations"69	<< pref.relations
	S69"relations_info"69	<< pref.relations_info

/datum/category_item/player_setup_item/relations/sanitize_character()
	if(!pref.relations)
		pref.relations = list()
	if(!pref.relations_info)
		pref.relations_info = list()

/datum/category_item/player_setup_item/relations/content(mob/user)
	.=list()
	. += "Characters with enabled relations are paired up randomly after spawn. You can terminate relations when you first open relations info window, but after that it's final."
	. += "<hr>"
	. += "<br><b>What do they know about you?</b> This is the general info that all kinds of your connections would know. <a href='?src=\ref69src69;relation_info=69"general"69'>Edit</a>"
	. += "<br><i>69pref.relations_info69"general"69 ? pref.relations_info69"general"69 : "Nothing specific."69</i>"
	. += "<hr>"
	for(var/T in subtypesof(/datum/relation))
		var/datum/relation/R = T
		. += "<b>69initial(R.name)69</b>\t"
		if(initial(R.name) in pref.relations)
			. += "<span class='linkOn'>On</span>"
			. += "<a href='?src=\ref69src69;relation=69initial(R.name)69'>Off</a>"
		else
			. += "<a href='?src=\ref69src69;relation=69initial(R.name)69'>On</a>"
			. += "<span class='linkOn'>Off</span>"
		. += "<br><i>69initial(R.desc)69</i>"
		. += "<br><b>What do they know about you?</b><a href='?src=\ref69src69;relation_info=69initial(R.name)69'>Edit</a>"
		. += "<br><i>69pref.relations_info69initial(R.name)69 ? pref.relations_info69initial(R.name)69 : "Nothing specific."69</i>"
		. += "<hr>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/relations/OnTopic(var/href,var/list/href_list,69ar/mob/user)
	if(href_list69"relation"69)
		var/R = href_list69"relation"69
		pref.relations ^= R
		return TOPIC_REFRESH
	if(href_list69"relation_info"69)
		var/R = href_list69"relation_info"69
		var/info = sanitize(input("Character info", "What would you like the other party for this connection to know about your character?",pref.relations_info69R69) as69essage|null)
		if(info)
			pref.relations_info69R69 = info
		return TOPIC_REFRESH
	return ..()

/datum/category_item/player_setup_item/relations/update_setup(var/savefile/preferences,69ar/savefile/character)
	if(preferences69"version"69 < 18)
		// Remove old relation types
		for(var/i in pref.relations)
			var/f = FALSE
			for(var/T in subtypesof(/datum/relation))
				var/datum/relation/R = T
				if(initial(R.name) == i)
					f = TRUE
					break
			if(!f)
				pref.relations -= i
				. = TRUE
		for(var/i in pref.relations_info)
			var/f = FALSE
			for(var/T in subtypesof(/datum/relation))
				var/datum/relation/R = T
				if(initial(R.name) == i)
					f = TRUE
					break
			if(!f)
				pref.relations_info -= i
				. = TRUE
