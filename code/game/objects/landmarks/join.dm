/obj/landmark/join
	delete_me = TRUE
	var/join_tag = "latejoin"

/obj/landmark/join/late
	name = "late"
	icon_state = "player-blue-cluster"
	join_tag = ""
	var/disallow_job = null

/obj/landmark/join/late/New()
	switch(join_tag)
		if("late_cryo")
			GLOB.latejoin_cryo += loc
		if("late_cyborg")
			GLOB.latejoin_cyborg += loc
	..()

/obj/landmark/join/late/cryo
	name = "Cryogenic Storage"
	icon_state = "player-blue-cluster"
	join_tag = "late_cryo"

/obj/landmark/join/late/cyborg
	name = "Cyborg Storage"
	icon_state = "synth-cyan"
	join_tag = "late_cyborg"

/obj/landmark/join/observer
	name = "Observer spawn"
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
