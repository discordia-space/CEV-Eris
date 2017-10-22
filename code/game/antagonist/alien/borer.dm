/datum/antagonist/borer
	id = ROLE_BORER
	role_text = "Cortical Borer"
	role_text_plural = "Cortical Borers"
	mob_path = /mob/living/simple_animal/borer/roundstart
	bantype = "Borer"
	welcome_text = "Use your Infest power to crawl into the ear of a host and fuse with their brain. You can only take control temporarily, and at risk of hurting your host, so be clever and careful; your host is encouraged to help you however they can. Talk to your fellow borers with :x."
	weight = 18

	outer = TRUE

/datum/antagonist/borer/reproduced	//This antag datum will prevent all borers be rounstart
	id = ROLE_BORER_REPRODUCED
	selectable = FALSE
	mob_path = /mob/living/simple_animal/borer

/datum/antagonist/borer/create_objectives()
	new /datum/objective/borer_survive (src)
	new /datum/objective/borer_reproduce (src)
	new /datum/objective/escape (src)

/datum/antagonist/borer/place_antagonist()
	if(owner.current)
		owner.current.forceMove(get_turf(pick(get_vents())))

