/datum/preferences
	var/list/relations = list()
	var/list/relations_info = list()

/datum/category_item/player_setup_item/matchmaking
	name = "Matchmaking"
	sort_order = 7

/datum/category_item/player_setup_item/matchmaking/load_character(var/savefile/S)
	S["relations"]			>> pref.relations
	S["relations_info"]		>> pref.relations_info

/datum/category_item/player_setup_item/matchmaking/save_character(var/savefile/S)
	S["relations"]			<< pref.relations
	S["relations_info"]		<< pref.relations_info

/datum/category_item/player_setup_item/matchmaking/sanitize_character()
	if(!pref.relations_info)
		pref.relations_info = list()

	if(!pref.relations)
		pref.relations = list()

	if(!pref.relations_info["general"])
		pref.relations_info["general"] = 0

	for(var/T in subtypesof(/datum/relation))
		var/datum/relation/R = T
		if(!pref.relations_info[initial(R.name)])
			pref.relations_info[initial(R.name)] = 0

/datum/category_item/player_setup_item/matchmaking/content(mob/user)
	.=list()
	. += "<div>"
	. += "Characters with enabled relations are paired up randomly after spawn. You can terminate relations when you first open relations info window, but after that it's final."
	. += "<hr>"
	. += "<br><b>What do they know about you?</b> This is the general info that all kinds of your connections would know. <a href='?src=\ref[src];relation_info=["general"]'>Edit</a>"
	. += "<br><i>[pref.relations_info["general"] ? pref.relations_info["general"] : "Nothing specific."]</i>"
	. += "<hr>"
	for(var/T in subtypesof(/datum/relation))
		var/datum/relation/R = T
		. += "<b>[initial(R.name)]</b>\t"
		if(initial(R.name) in pref.relations)
			. += "<a href='?src=\ref[src];relation=[initial(R.name)]'>Off</a>"
		else
			. += "<a href='?src=\ref[src];relation=[initial(R.name)]'>On</a>"
		. += "<br><i>[initial(R.desc)]</i>"
		. += "<br><b>What do they know about you?</b><a href='?src=\ref[src];relation_info=[initial(R.name)]'>Edit</a>"
		. += "<br><i>[pref.relations_info[initial(R.name)] ? pref.relations_info[initial(R.name)] : "Nothing specific."]</i>"
		. += "<hr>"
	. += "</div>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/matchmaking/OnTopic(var/href,var/list/href_list,var/mob/user)
	if(href_list["relation"])
		var/R = href_list["relation"]
		pref.relations ^= R
		return TOPIC_REFRESH
	if(href_list["relation_info"])
		var/R = href_list["relation_info"]
		var/info = input_utf8(user, "Character info", "What would you like the other party for this connection to know about your character?", pref.relations_info[R], "message")
		if(info)
			pref.relations_info[R] = info
		return TOPIC_REFRESH
	return ..()
