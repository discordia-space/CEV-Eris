/datum/antagonist/mercenary
	id = ROLE_MERCENARY
	bantype = ROLE_MERCENARY
	role_text = "Serbian Mercenary"
	welcome_text = "You are a serbian mercenary, part of a team of professional soldiers. You are currently aboard your base preparing for a mission targeting the CEV Eris.<br>\
	<br>\
	In your base you will find your armoury full of weapon crates and the EVA capable SCAF armour. It is advised that you take a pistol, a rifle, a knife and a SCAF suit for basic equipment.<br>\
	Once you have your basic gear, you may also wish to take along a specialist weapon, like the RPG-7 or the L6 SAW LMG. Each of the specialist weapons is powerful but very bulky, you will need to wear it over your back.<br>\
	<br>\
	Discuss your specialties with your team, choose a broad range of weapons that will allow your group to overcome a variety of obstacles. Search the base and load up everything onto your ship which may be useful, you will not be able to return here once you depart.<br>\
	When ready, use the console on your shuttle bridge to depart for Eris. Your arrival will be detected on sensors, stealth is not an option."
	landmark_id = "mercenary-spawn"
	outer = TRUE

	default_access = list(access_mercenary,//This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels) //Mercs get maintenance access on eris, because being an antag without it is hell
	//They got forged assistant IDs or somesuch
	id_type = /obj/item/weapon/card/id/merc

	var/speaks_english = FALSE


/datum/antagonist/mercenary/equip()
	.=..()
	if (.)
		var/mob/living/L = owner.current

		//Put on the fatigues. Armor not included, they equip that manually from the merc base
		var/decl/hierarchy/outfit/O = outfit_by_type(/decl/hierarchy/outfit/antagonist/mercenary/casual)
		O.equip(L)

		//Set their language, This also adds it to their list
		L.set_default_language(LANGUAGE_SERBIAN)


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