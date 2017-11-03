/obj/landmark/join
	delete_me = TRUE


/obj/landmark/join/late
	name = "late-spawn"
	icon_state = "player-blue-cluster"

/obj/landmark/join/late/New()
	..()
	latejoin += loc


/obj/landmark/join/cyborg
	name = "late-cyborg-spawn"
	icon_state = "synth-cyan"

/obj/landmark/join/cyborg/New()
	..()
	latejoin_cyborg += loc


/obj/landmark/join/observer
	name = "observer-spawn"
	icon_state = "player-grey-cluster"

/obj/landmark/join/observer/New()
	..()
	tag = "observer-spawn"


/obj/landmark/start
	name = "start"
	icon_state = "player-grey"
	anchored = TRUE
	alpha = 124
	invisibility = 101
	var/datum/job/job = null

/obj/landmark/start/New()
	..()
	if(job)
		name = initial(job.title)

/obj/landmark/start/triai
	icon_state = "ai-green"
	name = "tripai"