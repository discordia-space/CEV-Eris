/*
	The mighty bluespace bears.
	Teleporting hunters that roam the ship in search of prey, and dance rings around ironhammer troops
	in combat.

	Civilians can avoid them by playing dead, hiding in lockers, or just running away before they get mad
*/
/datum/storyevent/bear_attack
	id = "bear_attack"
	name = "bear attack"

	weight = 1

	event_type = /datum/event/bear_attack
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR)
	tags = list(TAG_COMBAT, TAG_SCARY, TAG_COMMUNAL)
	var/spawncount = 0

////////////////////////////////////////////////////////////////////////////
/datum/event/bear_attack
	announceWhen	= 0
	var/spawncount = 1


/datum/event/bear_attack/setup()

	//Randomised start times.
	startWhen = rand(5,40)

	spawncount = rand(4,7)


/datum/event/bear_attack/start()

	while(spawncount >= 1)
		var/area/A = random_ship_area()
		var/turf/T = A.random_space()
		if (T)
			var/mob/M = new /mob/living/carbon/superior_animal/bear/tele(T)
			log_and_message_admins("Telebear spawned [followlink(M)]")
			spawncount--