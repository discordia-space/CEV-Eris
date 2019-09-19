/obj/structure/cryopod_spawner/proc/justequip(var/mob/living/carbon/human/H, var/title, var/alt_title, var/outfit_type)
	var/decl/hierarchy/outfit/outfit = outfit_type
	. = outfit.equip(H, title, alt_title)

/obj/structure/cryopod_spawner
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "cryopod"
	desc = "It looks like ancient cryopod."
	var/mob/spawnmob
	var/spawn_role
	var/spawn_faction
	var/outfit_type // The outfit the employee will be dressed in, if any
	var/stat_modifiers = list(
		STAT_MEC = 25,
		STAT_COG = 40,
		STAT_BIO = 25,
	)

/obj/structure/cryopod_spawner/proc/add_stats(var/mob/living/carbon/human/target)
	if(!ishuman(target))
		return FALSE
	for(var/name in src.stat_modifiers)
		target.stats.changeStat(name, stat_modifiers[name])

	return TRUE


/obj/structure/cryopod_spawner/attack_hand(mob/living/user as mob)
	if(!spawnmob)
		for(var/mob/observer/O in world)
			if(!spawnmob)
				var/response = alert(O, "Are you -sure- you want to become a [spawn_faction] [spawn_role]?.","Are you sure?","Yes","Cancel",)
				if(response == "Cancel") continue  //Hit the wrong key...again.

				if(!spawnmob)
					spawnmob = new /mob/living/carbon/human(src.loc)
					spawnmob.ckey = O.ckey
					justequip(spawnmob, spawn_faction, spawn_role, outfit_type)
					add_stats(spawnmob)
		if(!spawnmob)
			spawnmob = new /mob/living/carbon/superior_animal/roach(src.loc)

/obj/structure/cryopod_spawner/ironhammer
	outfit_type = /decl/hierarchy/outfit/job/security/ihoper
	spawn_faction = "Ironhammer"
	spawn_role = "Marine"

	stat_modifiers = list(
		STAT_ROB = 40,
		STAT_TGH = 30,
		STAT_VIG = 40,
	)

/obj/structure/cryopod_spawner/medical
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	spawn_faction = "Moebius"
	spawn_role = "Doctor"

	stat_modifiers = list(
		STAT_MEC = 25,
		STAT_COG = 40,
		STAT_BIO = 25,
	)

/obj/structure/cryopod_spawner/technomancer
	outfit_type = /decl/hierarchy/outfit/job/engineering/exultant
	spawn_faction = "Technomancer"
	spawn_role = "Exultant"

	stat_modifiers = list(
		STAT_MEC = 40,
		STAT_COG = 20,
		STAT_TGH = 15,
		STAT_VIG = 10,
	)

/obj/structure/cryopod_spawner/serbian
	outfit_type = /decl/hierarchy/outfit/antagonist/mercenary/equipped
	spawn_faction = "Serbian"
	spawn_role = "Operative"

	stat_modifiers = list(
		STAT_ROB = 40,
		STAT_TGH = 30,
		STAT_VIG = 40,
	)