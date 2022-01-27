/datum/admin_secret_item/admin_secret/show_game_mode
	name = "Show Game69ode"

/datum/admin_secret_item/admin_secret/show_game_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	if (get_storyteller())
		alert("The storyteller is 69get_storyteller().name69")
	else
		alert("For some reason there's a ticker, but not a game69ode")
