/datum/antagonist/dcrew
	id = ROLE_DCREW
	bantype = ROLE_DCREW
	faction_id = FACTION_DCREW
	role_text = "Derelict crew member"
	welcome_text = WELCOME_DCREW
	antaghud_indicator = ""   //// PLACCCEEE HOOOOLDERRRRR DU NUT FOGET here look at this don't skip it over
	landmark_id = "dcrew-spawn"
	outer = TRUE

	default_access = list(access_dcrew,//This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels) //Mercs get maintenance access on eris,eris without maint.. for basically what is a hard vagabond.? no no. give em maint
	id_type = /obj/item/weapon/card/id/merc


	appearance_editor = TRUE


	possible_objectives = list()
	survive_objective = null

	stat_modifiers = list( // if you need to fix you ship lets give you the tools
		STAT_ROB = 0,   //noodle man. fighting is hard
		STAT_TGH = 25,   //but you can take a punch as a survivor
		STAT_VIG = 10,  //noodle man. fighting is hard
		STAT_BIO = 10, 
		STAT_MEC = 25    //well fixing will need some tool handling
	)



/datum/antagonist/dcrew	/equip()
	var/mob/living/L = owner.current

	//Put on the fatigues. Armor not included, they equip that manually from the merc base
	var/decl/hierarchy/outfit/O = outfit_by_type(/decl/hierarchy/outfit/antagonist/mercenary/casual)
	O.equip(L)

	L.set_default_language(LANGUAGE_JIVE)   //so they can talk in space. might not be the most lore friendly and might be somewhat hugboxy but lets start with this

	for(var/name in stat_modifiers) //give em the stats
		L.stats.changeStat(name, stat_modifiers[name])

	create_id("Derelict crew member")
	..()


/obj/item/weapon/card/id/merc
	icon_state = "syndicate"

/obj/item/weapon/card/id/merc/New()
	access = list(access_mercenary,//This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels)

#undef WELCOME_DCREW
