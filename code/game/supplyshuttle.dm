//Confi69 stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.

//Supply packs are in /code/defines/obj/supplypacks.dm
//Computers are in /code/69ame/machinery/computer/supply.dm

var/list/mechtoys = list(
	/obj/item/toy/prize/ripley,
	/obj/item/toy/prize/fireripley,
	/obj/item/toy/prize/deathripley,
	/obj/item/toy/prize/69y69ax,
	/obj/item/toy/prize/durand,
	/obj/item/toy/prize/honk,
	/obj/item/toy/prize/marauder,
	/obj/item/toy/prize/seraph,
	/obj/item/toy/prize/mauler,
	/obj/item/toy/prize/odysseus,
	/obj/item/toy/prize/phazon
)

/obj/item/paper/manifest
	name = "supply69anifest"
	var/is_copy = 1

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THIN69S ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Chan69e this.
	icon_state = "plasticflaps"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	explosion_resistance = 5
	var/list/mobs_can_pass = list(
		/mob/livin69/carbon/slime,
		/mob/livin69/simple_animal/mouse,
		/mob/livin69/silicon/robot/drone
		)

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASS69LASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(istype(A, /obj/vehicle))	//no69ehicles
		return 0

	var/mob/livin69/M = A
	if(istype(M))
		if(M.lyin69)
			return ..()
		for(var/mob_type in69obs_can_pass)
			if(istype(A,69ob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			69del(src)
		if (2)
			if (prob(50))
				69del(src)
		if (3)
			if (prob(5))
				69del(src)

/obj/structure/plasticflaps/minin69 //A specific type for69inin69 that doesn't allow airflow because of them damn crates
	name = "airti69ht plastic flaps"
	desc = "Heavy duty, airti69ht, plastic flaps."

/obj/structure/plasticflaps/minin69/New() //set the turf below the flaps to block air
	update_turf_underneath(1)
	..()

/obj/structure/plasticflaps/minin69/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
	update_turf_underneath(0)
	. = ..()

/obj/structure/plasticflaps/minin69/proc/update_turf_underneath(var/should_pass)
	var/turf/T = 69et_turf(loc)
	if(T)
		if(should_pass)
			T.blocks_air = 1
		else
			if(istype(T, /turf/simulated/floor))
				T.blocks_air = 0
