/////////////////CRYOPODS
////////////////////////////////
proc/justequip(var/mob/living/carbon/human/H, var/title, var/alt_title, var/outfit_type)
	var/decl/hierarchy/outfit/outfit = outfit_type
	. = outfit.equip(H, title, alt_title)

/obj/structure/cryopod_spawner
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "cryopod"
	var/mob/spawnmob
	var/spawnname
	var/spawnsurname
	var/outfit_type // The outfit the employee will be dressed in, if any
	var/stat_modifiers = list(
		STAT_MEC = 25,
		STAT_COG = 40,
		STAT_BIO = 25,
	)

	proc/add_stats(var/mob/living/carbon/human/target)
		if(!ishuman(target))
			return FALSE
		for(var/name in src.stat_modifiers)
			target.stats.changeStat(name, stat_modifiers[name])

		return TRUE


	attack_hand(mob/living/user as mob)
		if(!spawnmob)
			for(var/mob/observer/O in world)
				if(!spawnmob)
					//var/turf/T = get_turf(src.loc)
					var/response = alert(O, "Are you -sure- you want to become a [spawnname] [spawnsurname]?.","Are you sure?","Near Ghost", "Random","Cancel")
					if(response == "Cancel") return  //Hit the wrong key...again.

					if(!spawnmob)
						spawnmob = new /mob/living/carbon/human(src.loc)
						spawnmob.ckey = O.ckey
						justequip(spawnmob, spawnname, spawnsurname, outfit_type)
						add_stats(spawnmob)
			if(!spawnmob)
				spawnmob = new /mob/living/carbon/superior_animal/roach(src.loc)

	ironhammer
		outfit_type = /decl/hierarchy/outfit/job/security/ihoper
		spawnname = "Ironhammer"
		spawnsurname = "Marine"

		stat_modifiers = list(
			STAT_ROB = 40,
			STAT_TGH = 30,
			STAT_VIG = 40,
		)

	medical
		outfit_type = /decl/hierarchy/outfit/job/medical/doctor
		spawnname = "Moebius"
		spawnsurname = "Doctor"

		stat_modifiers = list(
			STAT_MEC = 25,
			STAT_COG = 40,
			STAT_BIO = 25,
		)

	technomancer
		outfit_type = /decl/hierarchy/outfit/job/engineering/exultant
		spawnname = "Technomancer"
		spawnsurname = "Exultant"

		stat_modifiers = list(
			STAT_MEC = 40,
			STAT_COG = 20,
			STAT_TGH = 15,
			STAT_VIG = 10,
		)

	serbian
		outfit_type = /decl/hierarchy/outfit/antagonist/mercenary/equipped
		spawnname = "Serbian"
		spawnsurname = "Operative"

		stat_modifiers = list(
			STAT_ROB = 40,
			STAT_TGH = 30,
			STAT_VIG = 40,
		)

/////////////////CRYOPODS
////////////////////////////////