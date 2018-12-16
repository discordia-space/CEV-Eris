GLOBAL_LIST_EMPTY(late_spawntypes)
GLOBAL_LIST_EMPTY(spawntypes)
/obj/landmark/join
	delete_me = FALSE
	var/join_tag = "latejoin"

/obj/landmark/join/New()
	if(join_tag)
		var/datum/spawnpoint/SP = getSpawnPoint(name, silenced = TRUE)
		if (!SP)
			SP = createSpawnPoint(name)
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
		var/datum/spawnpoint/SP = getSpawnPoint(name, late = TRUE, silenced = TRUE)
		if (!SP)
			SP = createSpawnPoint(name, late = TRUE)
			SP.turfs += src.loc
			SP.display_name = name
			SP.restrict_job = restrict_job
			SP.disallow_job = disallow_job
			SP.message = message
		else
			SP.turfs += src.loc
		GLOB.late_spawntypes[name] = SP	
	..()

/obj/landmark/join/late/cryo
	name = "Cryogenic Storage"
	icon_state = "player-blue-cluster"
	join_tag = "late_cryo"
	message = "has completed cryogenic revival"

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