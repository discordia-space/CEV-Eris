/datum/antagonist/borer
	id = ROLE_BORER
	landmark_id = "hidden-vent-antag"
	role_text = "Cortical Borer"
	role_text_plural = "Cortical Borers"
	mob_path = /mob/living/simple_animal/borer/roundstart
	bantype = ROLE_BANTYPE_BORER
	welcome_text = "Use your Infest power to crawl into the ear of a host and fuse with their brain. You can only take control temporarily, and at risk of hurting your host, so be clever and careful; your host is encouraged to help you however they can. Talk to your fellow borers with :x."
	antaghud_indicator = "hudborer"

	outer = TRUE
	only_human = FALSE

/datum/antagonist/borer/reproduced	//This antag datum will prevent all borers be rounstart
	id = ROLE_BORER_REPRODUCED
	selectable = FALSE
	mob_path = /mob/living/simple_animal/borer

/datum/antagonist/borer/create_objectives(var/survive = FALSE)
	new /datum/objective/borer_survive (src)
	new /datum/objective/borer_reproduce (src)

/datum/antagonist/borer/create_survive_objective()
	return
