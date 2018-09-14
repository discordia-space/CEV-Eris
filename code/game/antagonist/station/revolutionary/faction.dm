/datum/faction/revolutionary
	id = null
	faction_invisible = FALSE
	hud_indicator = "rev"

/datum/faction/revolutionary/create_objectives()
	objectives.Cut()

	var/has = FALSE
	for(var/datum/mind/M in SSticker.minds)
		if(M.assigned_role in list(JOBS_COMMAND))
			has = TRUE
			var/datum/objective/faction/rev/excelsior/O = new(src)
			O.set_target(M)

	if(!has)
		new /datum/objective/faction/rev/excelsior(src)
