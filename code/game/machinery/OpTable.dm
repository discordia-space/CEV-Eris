/obj/machinery/optable
	name = "Operatin69 Table"
	desc = "Used for advanced69edical procedures."
	icon = 'icons/obj/sur69ery.dmi'
	icon_state = "optable-idle"

	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 1
	active_power_usa69e = 5

	var/mob/livin69/carbon/victim

	var/obj/machinery/computer/operatin69/computer
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lyin69 = TRUE //bed-like behavior, forces69ob.lyin69 = buckle_lyin69 if != -1

	var/y_offset = 0
/obj/machinery/optable/New()
	..()
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operatin69, 69et_step(src, dir))
		if (computer)
			computer.table = src
			break
//	spawn(100) //Wont the69C just call this process() before and at the 10 second69ark anyway?
//		Process()

/obj/machinery/optable/ex_act(severity)

	switch(severity)
		if(1)
			//SN src = null
			69del(src)
			return
		if(2)
			if (prob(50))
				//SN src = null
				69del(src)
				return
		if(3)
			if (prob(25))
				density = FALSE
		else
	return

/obj/machinery/optable/attack_hand(mob/user as69ob)
	if (user.incapacitated(INCAPACITATION_DEFAULT))
		return
	if (victim)
		user_unbuckle_mob(user)
		return
	if (HULK in usr.mutations)
		visible_messa69e(SPAN_DAN69ER("\The 69usr69 destroys \the 69src69!"))
		density = FALSE
		69del(src)

/obj/machinery/optable/unbuckle_mob()
	. = ..()
	check_victim()

/obj/machinery/optable/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(air_69roup || (hei69ht==0)) return 1

	if(istype(mover) &&69over.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/optable/proc/check_victim()
	if (istype(buckled_mob,/mob/livin69/carbon))
		victim = buckled_mob
		if(ishuman(buckled_mob))
			var/mob/livin69/carbon/human/M = buckled_mob
			icon_state =69.pulse() ? "optable-active" : "optable-idle"
		return 1

	victim = null
	icon_state = "optable-idle"
	return 0

/obj/machinery/optable/Process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/livin69/carbon/C,69ob/livin69/carbon/user as69ob)
	if (C == user)
		user.visible_messa69e("69user69 climbs on \the 69src69.","You climb on \the 69src69.")
	else
		visible_messa69e(SPAN_NOTICE("\The 69C69 has been laid on \the 69src69 by 69user69."), 3)
		if (user.pullin69 == C)
			user.stop_pullin69() //Lets not dra69 your patient off the table after you just put them there
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.loc = loc
	for(var/obj/O in src)
		O.loc = loc
	add_fin69erprint(user)
	buckle_mob(C)


/obj/machinery/optable/MouseDrop_T(mob/tar69et,69ob/user)

	var/mob/livin69/M = user
	if(user.stat || user.restrained() || !check_table(user) || !iscarbon(tar69et))
		return
	if(istype(M))
		take_victim(tar69et,user)
	else
		return ..()

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set cate69ory = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return

	take_victim(usr,usr)

/obj/machinery/optable/affect_69rab(var/mob/user,69ar/mob/tar69et)
	take_victim(tar69et,user)
	return TRUE

/obj/machinery/optable/proc/check_table(mob/livin69/carbon/patient as69ob)
	check_victim()
	if(victim)
		to_chat(usr, SPAN_WARNIN69("\The 69src69 is already occupied!"))
		return 0
	if(patient.buckled)
		to_chat(usr, SPAN_NOTICE("Unbuckle \the 69patient69 first!"))
		return 0
	return 1

/obj/machinery/optable/post_buckle_mob(mob/livin69/M as69ob)
	if(M == buckled_mob)
		M.pixel_y = y_offset
	else
		M.pixel_y = 0

	check_victim()
