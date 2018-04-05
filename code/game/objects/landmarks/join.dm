/obj/landmark/join
	delete_me = TRUE
	var/join_tag = "latejoin"

/obj/landmark/join/New()
	if(join_tag)
		var/datum/spawnpoint/SP = getSpawnPoint(join_tag)
		SP.turfs += src.loc
		spawnpoints[join_tag] = SP
		//join_tag = null? do i need to nullify this?
	..()

/obj/landmark/join/late
	name = "late_cryo"
	icon_state = "player-blue-cluster"
	join_tag = "Cryogenic Storage"
	var/message = "has completed cryogenic revival"
	var/restrict_job = null
	var/disallow_job = null

/obj/landmark/join/late/New()
	if(join_tag)
		var/datum/spawnpoint/SP = getSpawnPoint(join_tag)
		SP.turfs += src.loc
		SP.display_name = join_tag
		SP.restrict_job = restrict_job
		SP.disallow_job = disallow_job
		SP.message = message
		spawnpoints_late[join_tag] = SP
		join_tag = null
	..()

/obj/landmark/join/late/cyborg
	name = "late_cybor"
	icon_state = "synth-cyan"
	join_tag = "Cyborg Storage"
	message = "has been activated from storage"
	restrict_job = list("Cyborg")

/obj/landmark/join/observer
	name = "observer-spawn"
	icon_state = "player-grey-cluster"
	join_tag = /mob/observer

/obj/landmark/join/start
	name = "start"
	icon_state = "player-grey"
	anchored = TRUE
	alpha = 124
	invisibility = 101
	join_tag = null
	delete_me = TRUE
