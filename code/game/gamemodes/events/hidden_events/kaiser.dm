/*
A powerful 64x64 roach can spawn in any burrow in maints.
While emerging from it, it will bring a rich trash piles with him (gun and science loot),
that will populate floors around burrow itself.
It will also bring a hoard of roaches with it.
*/

/datum/storyevent/kaiser
	id = "kaiser"
	name = "kaiser"

	weight = 1

	event_type = /datum/event/kaiser
	event_pools = list(
		EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR * 1.2)
	tags = list(TAG_COMBAT, TAG_NEGATIVE)

/datum/event/kaiser
	startWhen = 1
	announceWhen = 0
	endWhen = 0
	var/failure = FALSE
	var/list/reward = list(
		/obj/structure/scrap_spawner/vehicle,
		/obj/structure/scrap_spawner/guns,
		/obj/structure/scrap_spawner/science,
	)
	var/list/kaiser_rutinue = list(
		/obj/spawner/mob/roaches/cluster,
		/obj/spawner/mob/roaches/cluster,
		/obj/spawner/mob/roaches/cluster,
		/obj/spawner/mob/roaches/cluster
	)
	var/obj/structure/burrow/enter_burrow
	var/obj/structure/burrow/exit_burrow

/datum/event/kaiser/can_trigger()
	if(!GLOB.all_burrows.len)
		log_and_message_admins("Kaiser spawn failed: no burrows detected.")
		return FALSE
	return TRUE

/datum/event/kaiser/setup()
	enter_burrow = SSmigration.choose_burrow_target(null, TRUE, 100)
	exit_burrow = SSmigration.choose_burrow_target(enter_burrow, TRUE, 100)

	if(!enter_burrow || !exit_burrow)
		failure = TRUE

/datum/event/kaiser/start()
	spawn_mobs()

/datum/event/kaiser/proc/spawn_mobs()
	new /mob/living/carbon/superior_animal/roach/kaiser(enter_burrow)
	for(var/R in kaiser_rutinue)
		new R(enter_burrow)

	var/list/floors = list()
	for(var/turf/floor/F in dview(2, exit_burrow.loc))
		if(!F.is_wall && !F.is_hole)
			floors.Add(F)

	var/i = floors.len
	for(i, i>0, i--)
		var/obj/structure/scrap_spawner/scrap = pick(reward)
		var/turf/floor/floor = pick(floors)
		new scrap(floor)
		floors.Remove(floor) // To avoid multiple scrap piles on one tile

	enter_burrow.migrate_to(exit_burrow, 1, 0)
	log_and_message_admins("Sending Kaiser to [jumplink(exit_burrow)]")
