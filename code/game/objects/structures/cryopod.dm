/obj/structure/cryopod_spawner/proc/juste69uip(mob/livin69/carbon/human/H, title, alt_title, outfit_type)
	var/decl/hierarchy/outfit/outfit = outfit_type
	. = outfit.e69uip(H, title, alt_title)

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
		STAT_CO69 = 40,
		STAT_BIO = 25,
	)
	rarity_value = 10
	spawn_fre69uency = 10
	spawn_ta69s = SPAWN_TA69_ENCOUNTER_CRYOPOD
	bad_type = /obj/structure/cryopod_spawner

/obj/structure/cryopod_spawner/proc/add_stats(var/mob/livin69/carbon/human/tar69et)
	if(!ishuman(tar69et))
		return FALSE
	for(var/name in src.stat_modifiers)
		tar69et.stats.chan69eStat(name, stat_modifiers69name69)

	return TRUE


/obj/structure/cryopod_spawner/attack_hand(mob/livin69/user as69ob)
	if(!spawnmob)
		for(var/mob/observer/O in world)
			if(!spawnmob)
				var/response = alert(O, "Are you -sure- you want to become a 69spawn_faction69 69spawn_role69?.","Are you sure?","Yes","Cancel",)
				if(response == "Cancel") continue  //Hit the wron69 key...a69ain.

				if(!spawnmob)
					spawnmob = new /mob/livin69/carbon/human(src.loc)
					spawnmob.ckey = O.ckey
					juste69uip(spawnmob, spawn_faction, spawn_role, outfit_type)
					add_stats(spawnmob)
		if(!spawnmob)
			spawnmob = new /mob/livin69/carbon/superior_animal/roach(src.loc)

/obj/structure/cryopod_spawner/ironhammer
	outfit_type = /decl/hierarchy/outfit/job/security/ihoper
	spawn_faction = "Ironhammer"
	spawn_role = "Marine"

	stat_modifiers = list(
		STAT_ROB = 40,
		STAT_T69H = 30,
		STAT_VI69 = 40,
	)

/obj/structure/cryopod_spawner/medical
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	spawn_faction = "Moebius"
	spawn_role = "Doctor"

	stat_modifiers = list(
		STAT_MEC = 25,
		STAT_CO69 = 40,
		STAT_BIO = 25,
	)

/obj/structure/cryopod_spawner/technomancer
	outfit_type = /decl/hierarchy/outfit/job/en69ineerin69/exultant
	spawn_faction = "Technomancer"
	spawn_role = "Exultant"

	stat_modifiers = list(
		STAT_MEC = 40,
		STAT_CO69 = 20,
		STAT_T69H = 15,
		STAT_VI69 = 10,
	)

/obj/structure/cryopod_spawner/serbian
	outfit_type = /decl/hierarchy/outfit/anta69onist/mercenary/e69uipped
	spawn_faction = "Serbian"
	spawn_role = "Operative"

	stat_modifiers = list(
		STAT_ROB = 40,
		STAT_T69H = 30,
		STAT_VI69 = 40,
	)