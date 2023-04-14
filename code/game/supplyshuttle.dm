//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.

//Supply packs are in /code/modules/cargo/packs.dm


/obj/item/paper/manifest
	name = "supply manifest"
	var/is_copy = 1

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	explosion_resistance = 5
	matter = list(MATERIAL_PLASTIC = 4)
	var/list/mobs_can_pass = list(
		/mob/living/carbon/slime,
		/mob/living/simple_animal/mouse,
		/mob/living/silicon/robot/drone
		)

	atmos_canpass = CANPASS_PROC

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(istype(A, /obj/vehicle))	//no vehicles
		return 0

	var/mob/living/M = A
	if(istype(M))
		if(M.lying)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(A, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/attackby(obj/item/I, mob/user)
	if((QUALITY_BOLT_TURNING in I.tool_qualities) && (!istype(src, /obj/structure/plasticflaps/mining)))
		user.visible_message(
				SPAN_NOTICE("\The [user] start disassembling \the [src]."),
				SPAN_NOTICE("You start disassembling \the [src].")
		)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			user.visible_message(
				SPAN_NOTICE("\The [user] disassembled \the [src]!"),
				SPAN_NOTICE("You disassembled \the [src]!")
			)
			drop_materials(drop_location(), user)
			qdel(src)
	return ..()

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

/obj/structure/plasticflaps/mining/New() //set the turf below the flaps to block air
	update_turf_underneath(1)
	..()

/obj/structure/plasticflaps/mining/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
	update_turf_underneath(0)
	. = ..()

/obj/structure/plasticflaps/mining/proc/update_turf_underneath(var/should_pass)
	var/turf/T = get_turf(loc)
	if(T)
		if(should_pass)
			T.blocks_air = 1
		else
			if(istype(T, /turf/simulated/floor))
				T.blocks_air = 0
