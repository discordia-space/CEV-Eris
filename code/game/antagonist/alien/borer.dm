/datum/antagonist/borer
	id = ROLE_BORER
	role_text = "Cortical Borer"
	role_text_plural = "Cortical Borers"
	mob_path = /mob/living/simple_animal/borer
	bantype = "Borer"
	welcome_text = "Use your Infest power to crawl into the ear of a host and fuse with their brain. You can only take control temporarily, and at risk of hurting your host, so be clever and careful; your host is encouraged to help you however they can. Talk to your fellow borers with :x."

	faction_type = /datum/faction/borer

	outer = TRUE

/datum/antagonist/borer/get_extra_panel_options(var/datum/mind/player)
	return "<a href='?src=\ref[src];move_to_spawn=\ref[player.current]'>\[put in host\]</a>"

/datum/antagonist/borer/create_objectives()
	new /datum/objective/borer_survive (owner)
	new /datum/objective/borer_reproduce (owner)
	new /datum/objective/escape (owner)

/datum/antagonist/borer/place_antagonist()
	if(owner.current)
		owner.current.forceMove(get_turf(pick(get_vents())))

/datum/faction/borer
	id = FACTION_BORERS
	name = "Borers"
	description = "Cortical borers."
	welcome_text = "Use your Infest power to crawl into the ear of a host and fuse with their brain. You can only take control temporarily, and at risk of hurting your host, so be clever and careful; your host is encouraged to help you however they can. Talk to your fellow borers with :x."
	antag = "Cortical Borer"
	antag_plural = "Cortical Borers"

	possible_antags = list(ROLE_BORER)

