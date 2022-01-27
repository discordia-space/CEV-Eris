// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things,69o other draggables
// Toilets are a type of disposal bin for small objects only and work on69agic. By69agic, I69ean tor69ue rotation
#define SEND_PRESSURE (700 + ONE_ATMOSPHERE) //kPa - assume the inside of a dispoal pipe is 1 atm, so that69eeds to be added.
#define PRESSURE_TANK_VOLUME 150	//L
#define PUMP_MAX_FLOW_RATE 90		//L/s - 469/s using a 15 cm by 15 cm inlet

/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = TRUE
	density = TRUE
	layer = LOW_OBJ_LAYER //This allows disposal bins to be underneath tables
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item69ode 0=off 1=charging 2=charged
	var/flush = 0	// true if flush handle is pulled
	var/obj/structure/disposalpipe/trunk/trunk =69ull // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this69ar adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound = 0
	active_power_usage = 2200	//the pneumatic pump power. 3 HP ~ 2200W
	idle_power_usage = 100

// create a69ew disposal
// find the attached trunk (if present) and init gas resvr.
/obj/machinery/disposal/New()
	..()
	spawn(5)
		trunk = locate() in src.loc
		if(!trunk)
			mode = 0
			flush = 0
		else
			trunk.linked = src	// link the pipe trunk to self

		air_contents =69ew/datum/gas_mixture(PRESSURE_TANK_VOLUME)
		update()

/obj/machinery/disposal/Destroy()
	eject()
	if(trunk)
		trunk.linked =69ull
	return ..()

/obj/machinery/disposal/affect_grab(var/mob/living/user,69ar/mob/living/target)
	user.visible_message("69user69 starts putting 69target69 into the disposal.")
	var/time_to_put = target.mob_size //size is perfectly suit
	if(do_after(user, time_to_put, src) && Adjacent(target))
		user.face_atom(src)
		target.forceMove(src)
		visible_message(SPAN_NOTICE("69target69 has been placed in the 69src69 by 69user69."))
		user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Has placed 69target69 (69target.ckey69) in disposals.</font>")
		target.attack_log += text("\6969time_stamp()69\69 <font color='orange'>Has been placed in disposals by 69user.name69 (69user.ckey69)</font>")
		msg_admin_attack("69user69 (69user.ckey69) placed 69target69 (69target.ckey69) in a disposals unit. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69usr.x69;Y=69usr.y69;Z=69usr.z69'>JMP</a>)")
		return TRUE

/obj/machinery/disposal/MouseDrop_T(var/obj/item/I,69ob/user, src_location, over_location, src_control, over_control, params)



// attack by item places it in to disposal
/obj/machinery/disposal/attackby(var/obj/item/I,69ar/mob/user)
	if(stat & BROKEN || !I || !user)
		return

	src.add_fingerprint(user)

	var/list/usable_69ualities = list()
	if(mode<=0)
		usable_69ualities.Add(69UALITY_SCREW_DRIVING)
	if(mode==-1)
		usable_69ualities.Add(69UALITY_WELDING)


	var/tool_type = I.get_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVING)
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			if(mode<=0)
				var/used_sound =69ode ? 'sound/machines/Custom_screwdriverclose.ogg' : 'sound/machines/Custom_screwdriveropen.ogg'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					if(mode==0) // It's off but still69ot unscrewed
						mode=-1 // Set it to doubleoff l0l
						to_chat(user, "You remove the screws around the power connection.")
						return
					else if(mode==-1)
						mode=0
						to_chat(user, "You attach the screws around the power connection.")
						return
			return

		if(69UALITY_WELDING)
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			if(mode==-1)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, "You sliced the floorweld off the disposal unit.")
					var/obj/structure/disposalconstruct/C =69ew (src.loc)
					src.transfer_fingerprints_to(C)
					C.pipe_type = PIPE_TYPE_BIN
					C.anchored = TRUE
					C.density = TRUE
					C.update()
					69del(src)
			return

		if(ABORT_CHECK)
			return


	if(istype(I, /obj/item/storage/bag))
		var/obj/item/storage/bag/T = I
		to_chat(user, "\blue You empty the bag.")
		for(var/obj/item/O in T.contents)
			T.remove_from_storage(O,src)
		T.update_icon()
		update()
		return

	if(!I)
		return

	if(user.unE69uip(I, src))
		to_chat(user, "You place \the 69I69 into the 69src69.")
		for(var/mob/M in69iewers(src))
			if(M == user)
				continue
			M.show_message("69user.name69 places \the 69I69 into the 69src69.", 3)
			playsound(src.loc, 'sound/machines/vending_drop.ogg', 100, 1)

		update()

//69ouse drop another69ob or self
//
/obj/machinery/disposal/MouseDrop_T(atom/movable/A,69ob/user)
	if(ismob(A))
		var/mob/target = A
		if(user.stat || !user.canmove)
			return
		if(target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1)
			return

		//animals cannot put69obs other than themselves into disposal
		if(isanimal(user) && target != user)
			return

		if (target.mob_size ==69OB_HUGE)
			return

		src.add_fingerprint(user)
		var/target_loc = target.loc
		var/msg
		for (var/mob/V in69iewers(usr))
			if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
				V.show_message("69usr69 starts climbing into the disposal.", 3)
			if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
				if(target.anchored) return
				V.show_message("69usr69 starts stuffing 69target.name69 into the disposal.", 3)

		var/delay = 20
		if(!do_after(usr,69ax(delay * usr.stats.getMult(STAT_VIG, STAT_LEVEL_EXPERT), delay * 0.66), src))
			return
		if(target_loc != target.loc)
			return
		if(target == user && !user.incapacitated(INCAPACITATION_ALL))	// if drop self, then climbed in
												//69ust be awake,69ot stunned or whatever
			msg = "69user.name69 climbs into the 69src69."
			to_chat(user, "You climb into the 69src69.")
		else if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			msg = "69user.name69 stuffs 69target.name69 into the 69src69!"
			to_chat(user, "You stuff 69target.name69 into the 69src69!")

			user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Has placed 69target.name69 (69target.ckey69) in disposals.</font>")
			target.attack_log += text("\6969time_stamp()69\69 <font color='orange'>Has been placed in disposals by 69user.name69 (69user.ckey69)</font>")
			msg_admin_attack("69user69 (69user.ckey69) placed 69target69 (69target.ckey69) in a disposals unit. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")
		else
			return
		if (target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src

		target.simple_move_animation(src)
		target.forceMove(src)

		for (var/mob/C in69iewers(src))
			if(C == user)
				continue
			C.show_message(msg, 3)

		update()
		return
	else if (istype(A, /obj/item))
		var/obj/item/I = A
		if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
			return ..()
		if(istype(I, /obj/item/storage/bag/trash))
			var/obj/item/storage/bag/trash/T = I
			to_chat(user, SPAN_NOTICE("You empty the bag."))
			for(var/obj/item/O in T.contents)
				T.remove_from_storage(O,src)
			T.update_icon()
			update()
			return

		if(!I)
			return

		I.add_fingerprint(user)
		I.forceMove(src)
		to_chat(user, "You place \the 69I69 into the 69src69.")
		for(var/mob/M in69iewers(src))
			if(M == user)
				continue
			M.show_message("69user.name69 places \the 69I69 into the 69src69.", 3)
			playsound(src.loc, 'sound/machines/vending_drop.ogg', 100, 1)

		update()
		return
	. = ..()

// attempt to69ove while inside
/obj/machinery/disposal/relaymove(mob/user as69ob)
	if(user.stat || src.flushing)
		return
	if(user.loc == src)
		src.go_out(user)
	return

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)

	if (user.client)
		user.client.eye = user.client.mob
		user.client.perspective =69OB_PERSPECTIVE
	user.forceMove(src.loc)
	update()
	return

// ai as human but can't flush
/obj/machinery/disposal/attack_ai(mob/user as69ob)
	interact(user, 1)

// human interact with69achine
/obj/machinery/disposal/attack_hand(mob/user as69ob)

	if(stat & BROKEN)
		return

	if(user && user.loc == src)
		to_chat(usr, "\red You cannot reach the controls from inside.")
		return

	// Clumsy folks can only flush it.
	if(user.IsAdvancedToolUser(1))
		interact(user, 0)
	else
		flush = !flush
		update()
	return

// user interaction
/obj/machinery/disposal/interact(mob/user,69ar/ai=0)

	src.add_fingerprint(user)
	if(stat & BROKEN)
		user.unset_machine()
		return

	var/dat = "<head><title>Waste Disposal Unit</title></head><body><TT><B>Waste Disposal Unit</B><HR>"

	if(!ai)  // AI can't pull flush handle
		if(flush)
			dat += "Disposal handle: <A href='?src=\ref69src69;handle=0'>Disengage</A> <B>Engaged</B>"
		else
			dat += "Disposal handle: <B>Disengaged</B> <A href='?src=\ref69src69;handle=1'>Engage</A>"

		dat += "<BR><HR><A href='?src=\ref69src69;eject=1'>Eject contents</A><HR>"

	if(mode <= 0)
		dat += "Pump: <B>Off</B> <A href='?src=\ref69src69;pump=1'>On</A><BR>"
	else if(mode == 1)
		dat += "Pump: <A href='?src=\ref69src69;pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
	else
		dat += "Pump: <A href='?src=\ref69src69;pump=0'>Off</A> <B>On</B> (idle)<BR>"

	var/per = 100* air_contents.return_pressure() / (SEND_PRESSURE)

	dat += "Pressure: 69round(per, 1)69%<BR></body>"


	user.set_machine(src)
	user << browse(dat, "window=disposal;size=360x170")
	onclose(user, "disposal")

// handle69achine interaction

/obj/machinery/disposal/Topic(href, href_list)
	if(usr.loc == src)
		to_chat(usr, "\red You cannot reach the controls from inside.")
		return

	if(mode==-1 && !href_list69"eject"69) // only allow ejecting if69ode is -1
		to_chat(usr, "\red The disposal units power is disabled.")
		return
	if(..())
		return

	if(stat & BROKEN)
		return
	if(usr.stat || usr.restrained() || src.flushing)
		return

	if(istype(src.loc, /turf))
		usr.set_machine(src)

		if(href_list69"close"69)
			usr.unset_machine()
			usr << browse(null, "window=disposal")
			return

		if(href_list69"pump"69)
			if(text2num(href_list69"pump"69))
				mode = 1
			else
				mode = 0
			update()

		if(!isAI(usr))
			if(href_list69"handle"69)
				flush = text2num(href_list69"handle"69)
				update()

			if(href_list69"eject"69)
				eject()
	else
		usr << browse(null, "window=disposal")
		usr.unset_machine()
		return
	return

// eject the contents of the disposal unit
/obj/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in src)
		AM.forceMove(src.loc)
		AM.pipe_eject(0)
	update()

// update the icon & overlays to reflect69ode & status
/obj/machinery/disposal/proc/update()
	overlays.Cut()
	if(stat & BROKEN)
		icon_state = "disposal-broken"
		mode = 0
		flush = 0
		return

	// flush handle
	if(flush)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-handle")

	// only handle is shown if69o power
	if(stat &69OPOWER ||69ode == -1)
		return

	// 	check for items in disposal - occupied light
	if(contents.len > 0)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-full")

	// charging and ready light
	if(mode == 1)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-charge")
	else if(mode == 2)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-ready")

// timed process
// charge the gas reservoir and perform flush if ready
/obj/machinery/disposal/Process()
	if(!air_contents || (stat & BROKEN))			//69othing can happen if broken
		update_use_power(0)
		return

	flush_count++
	if( flush_count >= flush_every_ticks )
		if( contents.len )
			if(mode == 2)
				spawn(0)
					flush()
		flush_count = 0

	src.updateDialog()

	if(flush && air_contents.return_pressure() >= SEND_PRESSURE )	// flush can happen even without power
		flush()

	if(mode != 1) //if off or ready,69o69eed to charge
		update_use_power(1)
	else if(air_contents.return_pressure() >= SEND_PRESSURE)
		mode = 2 //if full enough, switch to ready69ode
		update()
	else
		src.pressurize() //otherwise charge

/obj/machinery/disposal/proc/pressurize()
	if(stat &69OPOWER)			// won't charge if69o power
		update_use_power(0)
		return

	var/atom/L = loc						// recharging from loc turf
	var/datum/gas_mixture/env = L.return_air()

	var/power_draw = -1
	if(env && env.temperature > 0)
		var/transfer_moles = (PUMP_MAX_FLOW_RATE/env.volume)*env.total_moles	//group_multiplier is divided out here
		power_draw = pump_gas(src, env, air_contents, transfer_moles, active_power_usage)

	if (power_draw > 0)
		use_power(power_draw)

// perform a flush
/obj/machinery/disposal/proc/flush()

	flushing = 1
	flick("69icon_state69-flush", src)

	var/wrapcheck = 0
	var/obj/structure/disposalholder/H =69ew()	//69irtual holder object which actually
												// travels through the pipes.
	//Hacky test to get drones to69ail themselves through disposals.
	for(var/mob/living/silicon/robot/drone/D in src)
		wrapcheck = 1

	for(var/obj/item/smallDelivery/O in src)
		wrapcheck = 1

	if(wrapcheck == 1)
		H.tomail = 1


	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		last_sound = world.time
	sleep(5) // wait for animation to finish


	H.init(src, air_contents)	// copy the contents of disposer to holder
	air_contents =69ew(PRESSURE_TANK_VOLUME)	//69ew empty gas resv.

	H.start(src) // start the holder processing69ovement
	flushing = 0
	//69ow reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return


// called when area power changes
/obj/machinery/disposal/power_change()
	..()	// do default setting/reset of stat69OPOWER bit
	update()	// update icon
	return


// called when holder is expelled from a disposal
// should usually only occur if the pipe69etwork is69odified
/obj/machinery/disposal/proc/get_eject_turf()
	get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

/obj/machinery/disposal/proc/expel(var/obj/structure/disposalholder/H)

	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	if(H) // Somehow, someone69anaged to flush a window which broke69id-transit and caused the disposal to go in an infinite loop trying to expel69ull, hopefully this fixes it
		for(var/atom/movable/AM in H)
			target = get_eject_turf()

			AM.forceMove(src.loc)
			AM.pipe_eject(0)
			if(!isdrone(AM)) //Poor drones kept smashing windows and taking system damage being fired out of disposals. ~Z
				spawn(1)
					if(AM)
						AM.throw_at(target, 5, 1)

		H.vent_gas(loc)
		69del(H)

/obj/machinery/disposal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) &&69over.throwing)
		var/obj/item/I =69over
		if(istype(I, /obj/item/projectile))
			return
		if(prob(75))
			I.forceMove(src)
			for(var/mob/M in69iewers(src))
				M.show_message("\The 69I69 lands in \the 69src69.", 3)
		else
			for(var/mob/M in69iewers(src))
				M.show_message("\The 69I69 bounces off of \the 69src69's rim!", 3)
		return 0
	else
		return ..(mover, target, height, air_group)

//69irtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
// this allows the gas flushed to be tracked

/obj/structure/disposalholder
	invisibility = 101
	var/datum/gas_mixture/gas =69ull	// gas used to flush, will appear at exit point
	var/active = 0	// true if the holder is69oving, otherwise inactive
	dir = 0
	var/count = 2048	//*** can travel 2048 steps before going inactive (in case of loops)
	var/destinationTag = "" // changes if contains a delivery container
	var/tomail = 0 //changes if contains wrapped package
	var/has_mob = FALSE //If it contains a69ob

	var/partialTag = "" //set by a partial tagger the first time round, then put in destinationTag if it goes through again.


	// initialize a holder from the contents of a disposal unit
/obj/structure/disposalholder/proc/init(var/obj/machinery/disposal/D,69ar/datum/gas_mixture/flush_gas)
	gas = flush_gas// transfer gas resv. into holder object -- let's be explicit about the data this proc consumes, please.

	//Check for any living69obs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	for(var/mob/living/M in D)
		if(M &&69.stat != DEAD && !isdrone(M))
			has_mob = TRUE

	//Checks 1 contents level deep. This69eans that players can be sent through disposals...
	//...but it should re69uire a second person to open the package. (i.e. person inside a wrapped locker)
	for(var/obj/O in D)
		if(O.contents)
			for(var/mob/living/M in O.contents)
				if(M &&69.stat != DEAD && !isdrone(M))
					has_mob = TRUE

	//69ow everything inside the disposal gets put into the holder
	//69ote AM since can contain69obs or objs
	for(var/atom/movable/AM in D)
		AM.forceMove(src)
		if(istype(AM, /obj/structure/bigDelivery) && !has_mob)
			var/obj/structure/bigDelivery/T = AM
			src.destinationTag = T.sortTag
		if(istype(AM, /obj/item/smallDelivery) && !has_mob)
			var/obj/item/smallDelivery/T = AM
			src.destinationTag = T.sortTag
		//Drones can69ail themselves through69aint.
		if(isdrone(AM))
			var/mob/living/silicon/robot/drone/drone = AM
			src.destinationTag = drone.mail_destination


	// start the69ovement process
	// argument is the disposal unit the holder started in
/obj/structure/disposalholder/proc/start(var/obj/machinery/disposal/D)
	if(!D.trunk)
		D.expel(src)	//69o trunk connected, so expel immediately
		return

	forceMove(D.trunk)
	active = TRUE
	set_dir(DOWN)
	spawn(1)
		move()		// spawn off the69ovement process

	return

	//69ovement process, persists while holder is69oving through pipes
/obj/structure/disposalholder/proc/move()
	var/obj/structure/disposalpipe/last
	while(active)
		sleep(1)		// was 1
		if(!loc)
			return // check if we got GC'd

		if(has_mob && prob(5))
			for(var/mob/living/H in src)
				if(isdrone(H)) //Drones use the69ailing code to69ove through the disposal system,
					continue

				// Hurt any living creature jumping down disposals
				var/multiplier = 1

				// STAT_MEC or STAT_TGH help you reduce disposal damage, with69o damage being recieved at all at STAT_LEVEL_EXPERT
				if(H.stats)
					multiplier =69in(H.stats.getMult(STAT_MEC, STAT_LEVEL_EXPERT), H.stats.getMult(STAT_TGH, STAT_LEVEL_EXPERT))

				if(multiplier > 0)
					H.take_overall_damage(8 *69ultiplier, 0, "Blunt Trauma")

		var/obj/structure/disposalpipe/current = loc
		last = current
		current = current.transfer(src)

		if(!loc)
			return //side effects

		if(!current)
			last.expel(src, loc, dir)

		//
		if(!(count--))
			active = FALSE
	return



	// find the turf which should contain the69ext pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc,dir)

	// find a69atching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(var/turf/T)

	if(!T)
		return69ull

	var/fdir = turn(dir, 180)	// flip the69ovement direction
	for(var/obj/structure/disposalpipe/P in T)
		if(fdir & P.pipe_dir)		// find pipe direction69ask that69atches flipped dir
			return P
	// if69o69atching pipe, return69ull
	return69ull

	//69erge two holder objects
	// used when a a holder69eets a stuck holder
/obj/structure/disposalholder/proc/merge(var/obj/structure/disposalholder/other)
	for(var/atom/movable/AM in other)
		AM.forceMove(src)		//69ove everything in other holder to this one
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)	// if a client69ob, update eye to follow this holder
				M.client.eye = src

	69del(other)


/obj/structure/disposalholder/proc/settag(var/new_tag)
	destinationTag =69ew_tag

/obj/structure/disposalholder/proc/setpartialtag(var/new_tag)
	if(partialTag ==69ew_tag)
		destinationTag =69ew_tag
		partialTag = ""
	else
		partialTag =69ew_tag


	// called when player tries to69ove while in a pipe
/obj/structure/disposalholder/relaymove(mob/user as69ob)

	if(!isliving(user))
		return

	var/mob/living/U = user

	if (U.stat || U.last_special <= world.time)
		return

	U.last_special = world.time+100

	if (src.loc)
		for (var/mob/M in hearers(src.loc.loc))
			to_chat(M, "<FONT size=69max(0, 5 - get_dist(src,69))69>CLONG, clong!</FONT>")

	playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)

	// called to69ent all gas in holder to a location
/obj/structure/disposalholder/proc/vent_gas(var/atom/location)
	location.assume_air(gas)  //69ent all gas to turf
	return

/obj/structure/disposalholder/Destroy()
	69del(gas)
	active = 0
	return ..()

/obj/structure/disposalholder/AllowDrop()
	return TRUE

// Disposal pipes

/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	plane = FLOOR_PLANE
	layer = DISPOSAL_PIPE_LAYER
	anchored = TRUE
	density = FALSE

	level = BELOW_PLATING_LEVEL			// underfloor only
	var/pipe_dir = 0		// bitmask of pipe directions
	dir = 0				// dir will contain dominant direction for junction pipes
	var/health = 10 	// health points 0-10
	layer = 2.3			// slightly lower than wires and other pipes
	var/base_icon_state	// initial icon state on69ap
	var/sortType = list()
	var/subtype = SORT_TYPE_NORMAL
	//69ew pipe, set the icon_state as on69ap
	New()
		..()
		base_icon_state = icon_state
		return


	// pipe is deleted
	// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = FALSE
		var/turf/T = src.loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			69del(H)
			..()
			return

		// otherwise, do69ormal expel from turf
		if(H)
			expel(H, T, 0)
	. = ..()

	// returns the direction of the69ext pipe object, given the entrance dir
	// by default, returns the bitmask of remaining directions
/obj/structure/disposalpipe/proc/nextdir(var/fromdir)
	return pipe_dir & (~turn(fromdir, 180))

	// transfer the holder through this pipe segment
	// overriden for special behaviour
	//
/obj/structure/disposalpipe/proc/transfer(var/obj/structure/disposalholder/H)
	var/nextdir =69extdir(H.dir)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in69ext loc, if inactive69erge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return69ull

	return P


	// update the icon_state to reflect hidden status
/obj/structure/disposalpipe/proc/update()
	var/turf/T = src.loc
	hide(!T.is_plating() && !istype(T,/turf/space))	// space69ever hides pipes

// hide called by levelupdate if turf intact status changes
// change69isibility status and force update of icon
/obj/structure/disposalpipe/hide(var/intact)
	invisibility = intact ? 101: 0	// hide if floor is intact
	updateicon()

	// update actual icon_state depending on69isibility
	// if invisible, append "f" to icon_state to show faded69ersion
	// this will be revealed if a T-scanner is used
	// if69isible, use regular icon_state
/obj/structure/disposalpipe/proc/updateicon()

	icon_state = base_icon_state
	return


	// expel the held objects into a turf
	// called when there is a break in the pipe
/obj/structure/disposalpipe/proc/expel(var/obj/structure/disposalholder/H,69ar/turf/T,69ar/direction)
	if(!istype(H))
		return

	// Empty the holder if it is expelled into a dense turf.
	// Leaving it intact and sitting in a wall is stupid.
	if(T.density)
		for(var/atom/movable/AM in H)
			AM.loc = T
			AM.pipe_eject(0)
		69del(H)
		return


	if(!T.is_plating() && istype(T,/turf/simulated/floor)) //intact floor, pop the tile
		var/turf/simulated/floor/F = T
		F.break_tile()
		new /obj/item/stack/tile(H)	// add to holder so it will be thrown with other stuff

	var/turf/target
	if(direction)		// direction is specified
		if(istype(T, /turf/space)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(direction)
				spawn(1)
					if(AM)
						AM.throw_at(target, 100, 1)
			H.vent_gas(T)
			69del(H)

	else	//69o specified direction, so throw in random direction

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				spawn(1)
					if(AM)
						AM.throw_at(target, 5, 1)

			H.vent_gas(T)	// all gas69ent to turf
			69del(H)

	return

	// call to break the pipe
	// will expel any holder inside at the time
	// then delete the pipe
	// remains : set to leave broken pipe pieces in place
/obj/structure/disposalpipe/proc/broken(var/remains = 0)
	if(remains)
		for(var/D in cardinal)
			if(D & pipe_dir)
				var/obj/structure/disposalpipe/broken/P =69ew(src.loc)
				P.set_dir(D)

	src.invisibility = 101	//69ake invisible (since we won't delete the pipe immediately)
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// broken pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			69del(H)
			return

		// otherwise, do69ormal expel from turf
		if(H)
			expel(H, T, 0)

	spawn(2)	// delete pipe after 2 ticks to ensure expel proc finished
		69del(src)


// pipe affected by explosion
/obj/structure/disposalpipe/ex_act(severity)

	switch(severity)
		if(1)
			broken(0)
			return
		if(2)
			health -= rand(5,15)
			healthcheck()
			return
		if(3)
			health -= rand(0,15)
			healthcheck()
			return


	// test health for brokenness
/obj/structure/disposalpipe/proc/healthcheck()
	if(health < -2)
		broken(0)
	else if(health < 1)
		broken(1)
	return

	//attack by item
	//weldingtool: unfasten and convert to obj/disposalconstruct

/obj/structure/disposalpipe/attackby(var/obj/item/I,69ar/mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)

	if(69UALITY_WELDING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_WELDING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			welded()

	return

	// called when pipe is cut with welder
/obj/structure/disposalpipe/proc/welded()

	var/obj/structure/disposalconstruct/C =69ew (src.loc)
	switch(base_icon_state)
		if("pipe-s")
			C.pipe_type = PIPE_TYPE_STRAIGHT
		if("pipe-c")
			C.pipe_type = PIPE_TYPE_BENT
		if("pipe-j1")
			C.pipe_type = PIPE_TYPE_JUNC
		if("pipe-j2")
			C.pipe_type = PIPE_TYPE_JUNC_FLIP
		if("pipe-y")
			C.pipe_type = PIPE_TYPE_JUNC_Y
		if("pipe-t")
			C.pipe_type = PIPE_TYPE_TRUNK
		if("pipe-j1s")
			C.pipe_type = PIPE_TYPE_JUNC_SORT
			C.sortType = sortType
		if("pipe-j2s")
			C.pipe_type = PIPE_TYPE_JUNC_SORT_FLIP
			C.sortType = sortType
///// Z-Level stuff
		if("pipe-u")
			C.pipe_type = PIPE_TYPE_UP
		if("pipe-d")
			C.pipe_type = PIPE_TYPE_DOWN
///// Z-Level stuff end
		if("pipe-tagger")
			C.pipe_type = PIPE_TYPE_TAGGER
		if("pipe-tagger-partial")
			C.pipe_type = PIPE_TYPE_TAGGER_PART
	C.sort_mode = src.subtype
	src.transfer_fingerprints_to(C)
	C.set_dir(dir)
	C.density = FALSE
	C.anchored = TRUE
	C.update()

	69del(src)

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = FALSE
		var/turf/T = src.loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			69del(H)

			return ..()

		// otherwise, do69ormal expel from turf
		if(H)
			expel(H, T, 0)
	. = ..()

/obj/structure/disposalpipe/hides_under_flooring()
	return TRUE

// *** TEST69erb
//client/verb/dispstop()
//	for(var/obj/structure/disposalholder/H in world)
//		H.active = 0

// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

	New()
		..()
		if(icon_state == "pipe-s")
			pipe_dir = dir | turn(dir, 180)
		else
			pipe_dir = dir | turn(dir, -90)

		update()
		return

///// Z-Level stuff
/obj/structure/disposalpipe/up
	icon_state = "pipe-u"

/obj/structure/disposalpipe/up/New()
	..()
	pipe_dir = dir
	update()
	return

/obj/structure/disposalpipe/up/nextdir(var/fromdir)
	var/nextdir
	if(fromdir == DOWN)
		nextdir = dir
	else
		nextdir = UP
	return69extdir

/obj/structure/disposalpipe/up/transfer(var/obj/structure/disposalholder/H)
	var/nextdir =69extdir(H.dir)
	H.set_dir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P
	if(nextdir == UP)
		T = GetAbove(src)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/down/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in69ext loc, if inactive69erge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return69ull

	return P

/obj/structure/disposalpipe/down
	icon_state = "pipe-d"

/obj/structure/disposalpipe/down/New()
	..()
	pipe_dir = dir
	update()
	return

/obj/structure/disposalpipe/down/nextdir(var/fromdir)
	var/nextdir
	if(fromdir == UP)
		nextdir = dir
	else
		nextdir = DOWN
	return69extdir

/obj/structure/disposalpipe/down/transfer(var/obj/structure/disposalholder/H)
	var/nextdir =69extdir(H.dir)
	H.dir =69extdir

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == DOWN)
		T = GetBelow(src)
		if(!T)
			H.forceMove(src.loc)
			return
		else
			for(var/obj/structure/disposalpipe/up/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in69ext loc, if inactive69erge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return69ull

	return P
///// Z-Level stuff

/obj/structure/disposalpipe/junction/yjunction
	icon_state = "pipe-y"

//a three-way junction with dir being the dominant direction
/obj/structure/disposalpipe/junction
	icon_state = "pipe-j1"

/obj/structure/disposalpipe/junction/New()
	..()
	if(icon_state == "pipe-j1")
		pipe_dir = dir | turn(dir, -90) | turn(dir,180)
	else if(icon_state == "pipe-j2")
		pipe_dir = dir | turn(dir, 90) | turn(dir,180)
	else // pipe-y
		pipe_dir = dir | turn(dir,90) | turn(dir, -90)
	update()
	return


	//69ext direction to69ove
	// if coming in from secondary dirs, then69ext is primary dir
	// if coming in from primary dir, then69ext is e69ual chance of other dirs

/obj/structure/disposalpipe/junction/nextdir(var/fromdir)
	var/flipdir = turn(fromdir, 180)
	if(flipdir != dir)	// came from secondary dir
		return dir		// so exit through primary
	else				// came from primary
						// so69eed to choose either secondary exit
		var/mask = ..(fromdir)

		// find a bit which is set
		var/setbit = 0
		if(mask &69ORTH)
			setbit =69ORTH
		else if(mask & SOUTH)
			setbit = SOUTH
		else if(mask & EAST)
			setbit = EAST
		else
			setbit = WEST

		if(prob(50))	// 50% chance to choose the found bit or the other one
			return setbit
		else
			return69ask & (~setbit)


/obj/structure/disposalpipe/tagger
	name = "package tagger"
	icon_state = "pipe-tagger"
	var/sort_tag = ""
	var/partial = 0

/obj/structure/disposalpipe/tagger/proc/updatedesc()
	desc = initial(desc)
	if(sort_tag)
		desc += "\nIt's tagging objects with the '69sort_tag69' tag."

/obj/structure/disposalpipe/tagger/proc/updatename()
	if(sort_tag)
		name = "69initial(name)69 (69sort_tag69)"
	else
		name = initial(name)

/obj/structure/disposalpipe/tagger/New()
	. = ..()
	pipe_dir = dir | turn(dir, 180)
	if(sort_tag)
		tagger_locations |= sort_tag
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/tagger/attackby(var/obj/item/I,69ar/mob/user)
	if(..())
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag)// Tag set
			sort_tag = O.currTag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("Changed tag to '69sort_tag69'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/tagger/transfer(var/obj/structure/disposalholder/H)
	if(sort_tag)
		if(partial)
			H.setpartialtag(sort_tag)
		else
			H.settag(sort_tag)
	return ..()

/obj/structure/disposalpipe/tagger/partial //needs two passes to tag
	name = "partial package tagger"
	icon_state = "pipe-tagger-partial"
	partial = 1

//a three-way junction that sorts objects
/obj/structure/disposalpipe/sortjunction
	name = "sorting junction"
	icon_state = "pipe-j1s"
	desc = "An underfloor disposal pipe with a package sorting69echanism."

	var/posdir = 0
	var/negdir = 0
	var/sortdir = 0

/obj/structure/disposalpipe/sortjunction/proc/updatedesc()
	desc = initial(desc)
	if(sortType)
		desc += "\nIt's filtering objects with the '69sortType69' tag."

/obj/structure/disposalpipe/sortjunction/proc/updatename()
	if(sortType)
		name = "69initial(name)69 (69sortType69)"
	else
		name = initial(name)

/obj/structure/disposalpipe/sortjunction/proc/updatedir()
	posdir = dir
	negdir = turn(posdir, 180)

	if(icon_state == "pipe-j1s")
		sortdir = turn(posdir, -90)
	else if(icon_state == "pipe-j2s")
		sortdir = turn(posdir, 90)

	pipe_dir = sortdir | posdir |69egdir

/obj/structure/disposalpipe/sortjunction/New()
	. = ..()
	if(sortType) tagger_locations |= sortType

	updatedir()
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/sortjunction/attackby(var/obj/item/I,69ar/mob/user)
	if(..())
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag)// Tag set
			sortType = O.currTag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, "\blue Changed filter to '69sortType69'.")
			updatename()
			updatedesc()

/obj/structure/disposalpipe/sortjunction/proc/divert_check(var/checkTag)
	if(islist(sortType))
		return checkTag in sortType
	else
		return checkTag == sortType

	//69ext direction to69ove
	// if coming in from69egdir, then69ext is primary dir or sortdir
	// if coming in from posdir, then flip around and go back to posdir
	// if coming in from sortdir, go to posdir

/obj/structure/disposalpipe/sortjunction/nextdir(var/fromdir,69ar/sortTag)
	if(fromdir != sortdir)	// probably came from the69egdir
		if(divert_check(sortTag))
			return sortdir
		else
			return posdir
	else				// came from sortdir
						// so go with the flow to positive direction
		return posdir

/obj/structure/disposalpipe/sortjunction/transfer(var/obj/structure/disposalholder/H)
	var/nextdir =69extdir(H.dir, H.destinationTag)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in69ext loc, if inactive69erge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return69ull

	return P

//a three-way junction that filters all wrapped and tagged items
/obj/structure/disposalpipe/sortjunction/wildcard
	name = "wildcard sorting junction"
	desc = "An underfloor disposal pipe which filters all wrapped and tagged items."
	subtype = 1
	divert_check(var/checkTag)
		return checkTag != ""

//junction that filters all untagged items
/obj/structure/disposalpipe/sortjunction/untagged
	name = "untagged sorting junction"
	desc = "An underfloor disposal pipe which filters all untagged items."
	subtype = 2
	divert_check(var/checkTag)
		return checkTag == ""

/obj/structure/disposalpipe/sortjunction/flipped //for easier and cleaner69apping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/wildcard/flipped
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/untagged/flipped
	icon_state = "pipe-j2s"

//a trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"
	var/obj/linked 	// the linked obj/machinery/disposal or obj/disposaloutlet

/obj/structure/disposalpipe/trunk/New()
	..()
	pipe_dir = dir
	spawn(1)
		getlinked()

	update()
	return

/obj/structure/disposalpipe/trunk/Destroy()
	// Unlink trunk and disposal so that objets are69ot sent to69ullspace
	var/obj/machinery/disposal/D = linked
	D.trunk =69ull
	linked =69ull
	return ..()

/obj/structure/disposalpipe/trunk/proc/getlinked()
	linked =69ull
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D)
		linked = D
		if (!D.trunk)
			D.trunk = src

	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O)
		linked = O

	update()
	return

	// Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(var/obj/item/I,69ar/mob/user)

	//Disposal bins or chutes
	/*
	These shouldn't be re69uired
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D && D.anchored)
		return

	//Disposal outlet
	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O && O.anchored)
		return
	*/

	//Disposal constructors
	var/obj/structure/disposalconstruct/C = locate() in src.loc
	if(C && C.anchored)
		return

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)

	if(69UALITY_WELDING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_WELDING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			welded()

	// would transfer to69ext pipe segment, but we are in a trunk
	// if69ot entering from disposal bin,
	// transfer to linked object (outlet or bin)

/obj/structure/disposalpipe/trunk/transfer(var/obj/structure/disposalholder/H)

	if(H.dir == DOWN)		// we just entered from a disposer
		return ..()		// so do base transfer proc
	// otherwise, go to the linked object
	if(linked)
		var/obj/structure/disposaloutlet/O = linked
		if(istype(O) && (H))
			O.expel(H)	// expel at outlet
		else
			var/obj/machinery/disposal/D = linked
			if(H)
				D.expel(H)	// expel at disposal
	else
		if(H)
			src.expel(H, src.loc, 0)	// expel at turf
	return69ull

	//69extdir

/obj/structure/disposalpipe/trunk/nextdir(var/fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0

// a broken pipe
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	pipe_dir = 0		// broken pipes have pipe_dir=0 so they're69ot found as 'real' pipes
					// i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

	New()
		..()
		update()
		return

	// called when welded
	// for broken pipe, remove and turn into scrap

	welded()
//		var/obj/item/scrap/S =69ew(src.loc)
//		S.set_components(200,0,0)
		69del(src)

// the disposal outlet69achine

/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER //So we can see things that are being ejected
	var/active = 0
	var/turf/target	// this will be where the output objects are 'thrown' to.
	var/mode = 0

	New()
		..()

		spawn(1)
			target = get_ranged_target_turf(src, dir, 10)


			var/obj/structure/disposalpipe/trunk/trunk = locate() in src.loc
			if(trunk)
				trunk.linked = src	// link the pipe trunk to self

	// expel the contents of the holder object, then delete it
	// called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(var/obj/structure/disposalholder/H)

	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	sleep(20)	//wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

	if(H)
		for(var/atom/movable/AM in H)
			AM.forceMove(src.loc)
			AM.pipe_eject(dir)
			if(!isdrone(AM)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
				spawn(5)
					AM.throw_at(target, 3, 1)
		H.vent_gas(src.loc)
		69del(H)

		return

/obj/structure/disposaloutlet/attackby(var/obj/item/I,69ar/mob/user)
	if(!I || !user)
		return
	src.add_fingerprint(user)

	var/list/usable_69ualities = list()
	if(mode<=0)
		usable_69ualities.Add(69UALITY_SCREW_DRIVING)
	if(mode==-1)
		usable_69ualities.Add(69UALITY_WELDING)


	var/tool_type = I.get_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVING)
			if(mode<=0)
				var/used_sound =69ode ? 'sound/machines/Custom_screwdriverclose.ogg' : 'sound/machines/Custom_screwdriveropen.ogg'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					if(mode==0) // It's off but still69ot unscrewed
						mode=-1 // Set it to doubleoff l0l
						to_chat(user, "You remove the screws around the power connection.")
						return
					else if(mode==-1)
						mode=0
						to_chat(user, "You attach the screws around the power connection.")
						return
			return

		if(69UALITY_WELDING)
			if(mode==-1)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, "You sliced the floorweld off the disposal outlet.")
					var/obj/structure/disposalconstruct/C =69ew (src.loc)
					src.transfer_fingerprints_to(C)
					C.pipe_type = PIPE_TYPE_OUTLET
					C.anchored = TRUE
					C.density = TRUE
					C.update()
					69del(src)
			return

		if(ABORT_CHECK)
			return

// called when69ovable is expelled from a disposal pipe or outlet
// by default does69othing, override for special behaviour

/atom/movable/proc/pipe_eject(var/direction)
	return

// check if69ob has client, if so restore client69iew on eject
/mob/pipe_eject(var/direction)
	if (src.client)
		src.client.perspective =69OB_PERSPECTIVE
		src.client.eye = src

	return

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = alldirs.Copy()

	src.streak(dirs)

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = alldirs.Copy()

	src.streak(dirs)
