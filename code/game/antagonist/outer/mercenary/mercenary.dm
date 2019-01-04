/datum/antagonist/mercenary
	id = ROLE_MERCENARY
	bantype = ROLE_MERCENARY
	faction_id = "Serbia"
	role_text = "Serbian Mercenary"
	welcome_text = WELCOME_SERBS
	landmark_id = "mercenary-spawn"
	outer = TRUE

	default_access = list(access_mercenary,//This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels) //Mercs get maintenance access on eris, because being an antag without it is hell
	//They got forged assistant IDs or somesuch
	id_type = /obj/item/weapon/card/id/merc


	appearance_editor = FALSE



	survive_objective = null





/datum/antagonist/mercenary/equip()
	.=..()
	if (.)
		var/mob/living/L = owner.current

		//Put on the fatigues. Armor not included, they equip that manually from the merc base
		var/decl/hierarchy/outfit/O = outfit_by_type(/decl/hierarchy/outfit/antagonist/mercenary/casual)
		O.equip(L)

		//Set their language, This also adds it to their list
		L.set_default_language(LANGUAGE_SERBIAN)

		//Normal mercs can't speak common
		L.remove_language(LANGUAGE_COMMON)

		//And we'll give them a random serbian name to start off with
		var/datum/language/lang = all_languages[LANGUAGE_SERBIAN]
		lang.set_random_name(L)


		create_id("Soldier")


/obj/item/weapon/card/id/merc
	icon_state = "syndicate"

/obj/item/weapon/card/id/merc/New()
	access = list(access_mercenary,//This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels)



#undef WELCOME_SERBS