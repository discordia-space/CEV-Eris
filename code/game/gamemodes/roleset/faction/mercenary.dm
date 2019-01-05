/datum/storyevent/roleset/faction/mercenary
	id = "mercenary"
	name = "serbian mercenaries"
	role_id = ROLE_MERCENARY
	weight = 0.4
	ocurrences_max = 1
	//Until we code some way to reset the merc base, can't allow this to happen more than once per round

	base_quantity = 2
	scaling_threshold = 5

	leaders = 1

	faction_id = FACTION_SERBS
	faction_type = /datum/faction/mercenary


