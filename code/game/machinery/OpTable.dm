/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "optable-idle"

	layer = TABLE_LAYER
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5

	var/mob/living/carbon/human/victim = null

	var/obj/machinery/computer/operating/computer = null
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = TRUE //bed-like behavior, forces mob.lying = buckle_lying if != -1

	var/y_offset = 0
/obj/machinery/optable/New()
	..()
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break
//	spawn(100) //Wont the MC just call this process() before and at the 10 second mark anyway?
//		Process()

/obj/machinery/optable/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				src.density = 0
		else
	return

/obj/machinery/optable/attack_hand(mob/user as mob)
	if (HULK in usr.mutations)
		visible_message(SPAN_DANGER("\The [usr] destroys \the [src]!"))
		src.density = 0
		qdel(src)
	if (victim && !user.incapacitated(INCAPACITATION_DEFAULT))
		user_unbuckle_mob(user)
	return

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/optable/proc/check_victim()
	if (istype(buckled_mob,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = buckled_mob
		if (buckled_mob.lying)
			src.victim = M
			icon_state = M.pulse() ? "optable-active" : "optable-idle"
			return 1

	src.victim = null
	icon_state = "optable-idle"
	return 0

/obj/machinery/optable/Process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if (C == user)
		user.visible_message("[user] climbs on \the [src].","You climb on \the [src].")
	else
		visible_message(SPAN_NOTICE("\The [C] has been laid on \the [src] by [user]."), 3)
		if (user.pulling == C)
			user.stop_pulling() //Lets not drag your patient off the table after you just put them there
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.loc = src.loc
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
	buckle_mob(C)


/obj/machinery/optable/MouseDrop_T(mob/target, mob/user)

	var/mob/living/M = user
	if(user.stat || user.restrained() || !check_table(user) || !iscarbon(target))
		return
	if(istype(M))
		take_victim(target,user)
	else
		return ..()

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return

	take_victim(usr,usr)

/obj/machinery/optable/affect_grab(var/mob/user, var/mob/target)
	take_victim(target,user)
	return TRUE

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient as mob)
	check_victim()
	if(victim)
		usr << SPAN_WARNING("\The [src] is already occupied!")
		return 0
	if(patient.buckled)
		usr << SPAN_NOTICE("Unbuckle \the [patient] first!")
		return 0
	return 1

/obj/machinery/optable/post_buckle_mob(mob/living/M as mob)
	if(M == buckled_mob)
		M.pixel_y = y_offset
	else
		M.pixel_y = 0

	check_victim()
