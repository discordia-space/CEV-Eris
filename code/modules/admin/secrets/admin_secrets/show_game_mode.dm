/datum/admin_secret_item/admin_secret/show_game_mode
	name = "Show Game Mode"

/datum/admin_secret_item/admin_secret/show_game_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	if (get_storyteller())
		alert("The storyteller is [get_storyteller().name]")
	else
		alert("For some reason there's a ticker, but not a game mode")
