/obj/structure/scrap_beacon
	name = "Scrap Beacon"
	desc = "This machine generates directional gravity rays which catch trash orbiting around."
	icon = 'icons/obj/structures/scrap/scrap_beacon.dmi'
	icon_state = "beacon0"
	volumeClass = ITEM_SIZE_TITANIC
	anchored = TRUE
	density = TRUE
	layer = MOB_LAYER + 1
	var/summon_cooldown = 1200
	var/impact_speed = 3
	var/impact_prob = 100
	var/impact_range = 2
	var/last_summon = -3000
	var/active = 0

/obj/structure/scrap_beacon/attack_hand(mob/user)
	.=..()
	if((last_summon + summon_cooldown) >= world.time)
		to_chat(user, "<span class='notice'>[name] not charged yet.</span>")
		return
	last_summon = world.time
	if(!active)
		start_scrap_summon()

/obj/structure/scrap_beacon/proc/start_scrap_summon()
	set waitfor = FALSE

	active = TRUE
	icon_state = "beacon1"
	sleep(30)
	var/list/flooring_near_beacon = list()
	for(var/turf/T in RANGE_TURFS(impact_range, src))
		if(!istype(T,/turf/simulated/floor))
			continue
		if((locate(/obj/structure/scrap_spawner) in T))
			continue
		if(!prob(impact_prob))
			continue
		flooring_near_beacon += T
	flooring_near_beacon -= loc
	while(flooring_near_beacon.len > 0)
		sleep(impact_speed)
		var/turf/newloc = pick(flooring_near_beacon)
		flooring_near_beacon -= newloc
		if(prob(30))
			new /obj/effect/falling_effect(newloc, /obj/spawner/scrap/sparse)
		else
			new /obj/effect/falling_effect(newloc, /obj/spawner/scrap/beacon)
	active = FALSE
	icon_state = "beacon0"
