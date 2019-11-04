GLOBAL_LIST_EMPTY(late_spawntypes)
GLOBAL_LIST_EMPTY(spawntypes)
/obj/landmark/join
	delete_me = FALSE
	var/join_tag = "latejoin"

	var/spawn_datum_type = /datum/spawnpoint //What kind of datum we'll create for this landmark.
	//Make sure all landmarks that share a name also share the same datum type!

/obj/landmark/join/New()
	if(join_tag)
		var/datum/spawnpoint/SP = get_spawn_point(name)
		if (!SP)
			SP = create_spawn_point(name)
			SP.turfs += src.loc
			SP.display_name = name
		else
			SP.turfs += src.loc
		GLOB.spawntypes[name] = SP
	..()

/obj/landmark/join/late
	name = "late"
	icon_state = "player-blue-cluster"
	join_tag = ""
	var/message = "has completed cryogenic revival"
	var/restrict_job = null
	var/disallow_job = null

/obj/landmark/join/late/New()
	if(join_tag)
		landmark_create_spawn_point(src, TRUE, TRUE)
	..()

/obj/landmark/join/late/cryo
	name = "Aft Cryogenic Storage"
	icon_state = "player-blue-cluster"
	join_tag = "aft_late_cryo"
	message = "has completed cryogenic revival"
	spawn_datum_type = /datum/spawnpoint/cryo
	disallow_job = list("Robot")

/obj/landmark/join/late/cryo/starboard
	name = "Starboard Cryogenic Storage"
	icon_state = "player-blue-cluster"
	join_tag = "starboard_late_cryo"
	message = "has completed cryogenic revival"
	spawn_datum_type = /datum/spawnpoint/cryo/starboard
	disallow_job = list("Robot")

/obj/landmark/join/late/dormitory
	name = "Dormitory"
	icon_state = "player-blue-cluster"
	join_tag = "late_dormitory"
	message = "has awoken in the dormitory"
	spawn_datum_type = /datum/spawnpoint/dormitory
	disallow_job = list("Robot")

/obj/landmark/join/late/cyborg
	name = "Cyborg Storage"
	icon_state = "synth-cyan"
	join_tag = "late_cyborg"
	message = "has been activated from storage"
	restrict_job = list("Robot")

/obj/landmark/join/observer
	name = "Observer"
	icon_state = "player-grey-cluster"
	join_tag = /mob/observer

/obj/landmark/join/start
	name = "start"
	icon_state = "player-grey"
	anchored = TRUE
	alpha = 124
	invisibility = 101
	join_tag = null