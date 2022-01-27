//this needs port of communication datums
/datum/preferences
	// OOC69etadata:
	var/list/ignored_players = list()

/datum/category_item/player_setup_item/player_global/ooc
	name = "OOC"
	sort_order = 4

/datum/category_item/player_setup_item/player_global/ooc/load_preferences(var/savefile/S)
	S69"ignored_players"69	>> pref.ignored_players


/datum/category_item/player_setup_item/player_global/ooc/save_preferences(var/savefile/S)
	S69"ignored_players"69	<< pref.ignored_players


/datum/category_item/player_setup_item/player_global/ooc/sanitize_preferences()
	if(!islist(pref.ignored_players))
		pref.ignored_players = list()

/datum/category_item/player_setup_item/player_global/ooc/content(var/mob/user)
	. += "<b>OOC:</b><br>"
	. += "Ignored Players<br>"
	for(var/ignored_player in pref.ignored_players)
		. += "69ignored_player69 (<a href='?src=\ref69src69;unignore_player=69ignored_player69'>Unignore</a>)<br>"
	. += "(<a href='?src=\ref69src69;ignore_player=1'>Ignore Player</a>)"

/datum/category_item/player_setup_item/player_global/ooc/OnTopic(var/href,var/list/href_list,69ar/mob/user)
	if(href_list69"unignore_player"69)
		pref.ignored_players -= href_list69"unignore_player"69
		return TOPIC_REFRESH

	if(href_list69"ignore_player"69)
		var/player_to_ignore = sanitize(ckey(input(user, "Who do you want to ignore?","Ignore") as null|text))
		//input() sleeps while waiting for the user to respond, so we need to check CanUseTopic() again here
		if(player_to_ignore && CanUseTopic(user))
			pref.ignored_players |= player_to_ignore
		return TOPIC_REFRESH

	return ..()
