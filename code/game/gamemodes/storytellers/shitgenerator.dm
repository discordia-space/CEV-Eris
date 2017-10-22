/datum/storyteller/shitgenerator
	config_tag = STORYTELLER_BASE
	name = "Shitgenerator"
	welcome = "Prepare to fun! Try to survive as long as you can."
	description = "Shitgenerator is basic storyteller. Requires one technomancer and captain to start."

/datum/storyteller/shitgenerator/can_start(var/announce = FALSE)
	var/engineer = FALSE
	var/captain = FALSE
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.mind)
			if(player.mind.assigned_role == "Captain")
				captain = TRUE
			if(player.mind.assigned_role in list("Technomancer Exultant","Technomancer"))
				engineer = TRUE
			if(captain && engineer)
				return TRUE

	if(announce)
		if(!engineer && !captain)
			world << "<b><font color='red'>Captain and technomancer are required to start round.</font></b>"
		else if(!engineer)
			world << "<b><font color='red'>Technomancer is required to start round.</font></b>"
		else if(!captain)
			world << "<b><font color='red'>Captain is required to start round.</font></b>"

	return FALSE