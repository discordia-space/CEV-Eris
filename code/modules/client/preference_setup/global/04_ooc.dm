//this needs port of communication datums
/datum/preferences
	// OOC Metadata:
	var/list/ignored_players = list()

/datum/category_item/player_setup_item/player_global/ooc
	name = "OOC"
	sort_order = 4

/datum/category_item/player_setup_item/player_global/ooc/load_preferences(savefile/S)
	S["ignored_players"]	>> pref.ignored_players


/datum/category_item/player_setup_item/player_global/ooc/save_preferences(savefile/S)
	S["ignored_players"]	<< pref.ignored_players


/datum/category_item/player_setup_item/player_global/ooc/sanitize_preferences()
	if(!islist(pref.ignored_players))
		pref.ignored_players = list()

/datum/category_item/player_setup_item/player_global/ooc/content(mob/user)
	. += "<b>OOC:</b><br>"
	. += "Ignored Players<br>"
	for(var/ignored_player in pref.ignored_players)
		. += "[ignored_player] (<a href='byond://?src=\ref[src];unignore_player=[ignored_player]'>Unignore</a>)<br>"
	. += "(<a href='byond://?src=\ref[src];ignore_player=1'>Ignore Player</a>)"

/datum/category_item/player_setup_item/player_global/ooc/OnTopic(href,list/href_list, mob/user)
	if(href_list["unignore_player"])
		pref.ignored_players -= href_list["unignore_player"]
		return TOPIC_REFRESH

	if(href_list["ignore_player"])
		var/input_name = input(user, "Who do you want to ignore?","Ignore") as null|text
		if (!input_name)
			return TOPIC_REFRESH
		input_name = ckey(trim(input_name))
		if(input_name == "")
			to_chat(user, span_danger("You must enter a valid player name to ignore."))
			return TOPIC_REFRESH
		var/player_to_ignore = ckey(input_name)
		//input() sleeps while waiting for the user to respond, so we need to check CanUseTopic() again here
		if(player_to_ignore && CanUseTopic(user))
			pref.ignored_players |= player_to_ignore
		return TOPIC_REFRESH

	return ..()
