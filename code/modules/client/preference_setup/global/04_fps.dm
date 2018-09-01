/datum/preferences
	var/fps = 60						//Personal Player FPS. Will be send to client var


/datum/category_item/player_setup_item/player_global/fps
	name = "FPS"
	sort_order = 4

/datum/category_item/player_setup_item/player_global/fps/load_preferences(var/savefile/S)
	S["fps"]	>> pref.fps

/datum/category_item/player_setup_item/player_global/fps/save_preferences(var/savefile/S)
	S["fps"]	<< pref.fps

/datum/category_item/player_setup_item/player_global/fps/sanitize_preferences()
	if(!isnum(pref.fps))
		set_fps(initial(pref.fps))
	else
		set_fps( max(min(pref.fps, 60), 1) )

/datum/category_item/player_setup_item/player_global/fps/content(var/mob/user)
	. += "<b>FPS</b><br>"
	. += " <a href='?src=\ref[src];change_fps=1'>[pref.client.fps]</a> <a href='?src=\ref[src];reset_fps=1'>Reset</a><br>"

/datum/category_item/player_setup_item/player_global/fps/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["change_fps"])
		var/FPS = input("Set your FPS", "FPS", pref.fps) as num
		if(!FPS)
			return
		FPS = max(min(FPS, 60), 0)
		set_fps(FPS)
		return TOPIC_REFRESH

	else if(href_list["reset_fps"])
		set_fps(60)
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/fps/proc/set_fps(var/FPS = 60)
	pref.fps = FPS
	pref.client.fps = pref.fps
