/*69orgue stuff
 * Contains:
 *		Morgue
 *		Morgue trays
 *		Creamatorium
 *		Creamatorium trays
 */

/*
 *69orgue
 */

/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in untill someone fetches them."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = TRUE
	var/obj/structure/m_tray/connected
	var/open = FALSE
	anchored = TRUE
	var/mob/living/occupant
	var/max_capacity = 150
	var/current_storage = 0
	var/next_toggle = 0 //World time we're allowed to next open/close this drawer, used to prevent spam
	layer = ABOVE_MOB_LAYER

/obj/structure/morgue/Destroy()
	if(connected)
		69del(connected)
		connected = null
	return ..()

/obj/structure/morgue/update_icon()
	if (open)
		icon_state = "morgue0"
	else
		if (current_storage > 0)
			icon_state = "morgue2"
		else
			icon_state = "morgue1"
	return

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as69ob|obj in src)
				A.forceMove(loc)
				ex_act(severity)
			69del(src)
			return
		if(2)
			if (prob(50))
				for(var/atom/movable/A as69ob|obj in src)
					A.forceMove(loc)
					ex_act(severity)
				69del(src)
				return
		if(3)
			if (prob(5))
				for(var/atom/movable/A as69ob|obj in src)
					A.forceMove(loc)
					ex_act(severity)
				69del(src)
				return
	return


//No network connection. Robots can physically open it, but not remotely
//AI can't open it at all, anything inside a69orgue drawer is hidden from the AI
/obj/structure/morgue/attack_ai(var/mob/living/user)
	if(Adjacent(user))
		toggle(user)

/obj/structure/morgue/attack_hand(var/mob/living/user)
	toggle(user)
	add_fingerprint(user)

/obj/structure/morgue/proc/toggle(var/mob/living/user)
	if(world.time < next_toggle)
		return
	next_toggle = world.time + 15 //Throttle toggling to reduce lag and potential exploits
	playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
	if (connected)
		close(user)
	else
		open(user)

	update_icon()


/obj/structure/morgue/proc/open()
	if (!anchored)
		//No opening while unanchored
		return

	var/turf/T = get_step(src, dir)
	if (!(turf_clear(T)))
		return

	open = TRUE
	connected = new /obj/structure/m_tray( loc )
	connected.connected = src
	connected.set_dir(dir)
	for(var/atom/movable/A in src)
		A.forceMove(loc)

	sleep(1)//Things need to exist for some time, in order to animate correctly

	var/glidesize = DELAY2GLIDESIZE(5)
	connected.forceMove(T, glide_size_override=glidesize)
	for(var/atom/movable/A in loc)
		if (!A.anchored)
			A.forceMove(T,glide_size_override=glidesize)



	current_storage = 0

/obj/structure/morgue/proc/close(var/mob/living/user)
	//We only allow one69ob or bodybag containing a69ob, per69orgue drawer
	occupant = null
	var/glidesize = DELAY2GLIDESIZE(5)
	for(var/atom/movable/A in connected.loc)
		if (!A.anchored)
			A.forceMove(loc,glide_size_override=glidesize)

	connected.forceMove(loc,glide_size_override=glidesize)
	69DEL_IN(connected, 5)
	sleep(5)//Give them time to slide in before storing
	for(var/atom/movable/A in loc)
		store_atom(A)


	connected = null
	open = FALSE

	//If this drawer contains a corpse that used to be a player..
	if (occupant && occupant.mind && occupant.mind.key && occupant.stat == DEAD)
		//Whoever inhabited this body is long gone, we need some black69agic to find where and who they are now
		var/mob/M = key2mob(occupant.mind.key)
		if (!M)
			return
		if (M.stat != DEAD)
			return // no69ore bonuses for alive69obs
		if (M.get_respawn_bonus("CORPSE_HANDLING"))
			return // we got this one already
		//We send a69essage to the occupant's current69ob - probably a ghost, but who knows.
		to_chat(M, SPAN_NOTICE("Your remains have been collected and properly stored. Your crew respawn time is reduced by 1069inutes."))
		
		M << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever their respawn time gets reduced

		M.set_respawn_bonus("CORPSE_HANDLING", 1069INUTES)
		to_chat(user, SPAN_NOTICE("The corpse's spirit feels soothed and pleased."))



/obj/structure/morgue/proc/store_atom(var/atom/movable/AM)
	if (AM.anchored)
		return
		//Allowing it to suck up any non anchored object is probably open to exploits,
		//But fixing that is beyond69y scope for now.

	var/newcap
	var/mob/living/foundmob

	if (ismob(AM))
		if (!isliving(AM))
			//Don't eat ghosts and AI eyes please
			return
		if (occupant)
			//Only one69ob per drawer
			return
		foundmob = AM
		newcap = foundmob.mob_size
	else
		//Not a69ob,69ust be an object

		if (isitem(AM))
			var/obj/item/I = AM
			newcap = I.get_storage_cost()

		else if (istype(AM, /obj/structure/closet))
			//Closet includes coffins and deployed bodybags
			if (occupant)
				//One of these is allowed in if it contains a69ob and we dont already have a69ob
				return
			//Try to find a69ob inside it
			foundmob = locate(/mob/living) in AM.contents
			if (foundmob)
				newcap = 80 //These will take up69ost of the space
			else
				return
		else
			//Objects don't have w_class atm
			//Any unanchored object which isn't an item, is probably a bulky thing like a69achine or canister
			newcap = 30 //So lets just give it a fairly big number and be done with it

	//Minimum69alue to69itigate the effect of spamming69any small items
	newcap =69ax(newcap, 2)

	//Make sure we have space to fit it
	if ((current_storage + newcap) >69ax_capacity)
		return

	//Ok once we get here, we've confirmed that we can store the thing
	if (foundmob)
		occupant = foundmob
	current_storage += newcap
	AM.forceMove(src)

/obj/structure/morgue/attackby(P as obj,69ob/user as69ob)
	if (istype(P, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("6969", name), null)  as text
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, usr) && loc != user))
			return
		t = sanitizeSafe(t,69AX_NAME_LEN)
		if (t)
			name = text("Morgue- '6969'", t)
		else
			name = "Morgue"
	add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user as69ob)
	if (user.stat)
		return
	connected = new /obj/structure/m_tray( loc )
	step(connected, EAST)
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(connected))
		connected.connected = src
		icon_state = "morgue0"
		for(var/atom/movable/A as69ob|obj in src)
			A.forceMove(connected.loc)
	else
		69del(connected)
		connected = null
	return


/*
 *69orgue tray
 */
/obj/structure/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morguet"
	density = TRUE
	layer = LOW_OBJ_LAYER
	var/obj/structure/morgue/connected
	anchored = TRUE
	throwpass = 1

/obj/structure/m_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/m_tray/attack_hand(mob/user as69ob)
	if (connected)
		connected.attack_hand(user)

/obj/structure/m_tray/MouseDrop_T(atom/movable/O as69ob|obj,69ob/user as69ob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(loc)
	if (user != O)
		for(var/mob/B in69iewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, SPAN_WARNING("\The 69user69 stuffs 69O69 into 69src69!"))
	return


/*
 * Crematorium
 */

/obj/structure/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbe69ue nights."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "crema1"
	density = TRUE
	var/obj/structure/c_tray/connected
	anchored = TRUE
	var/cremating = 0
	var/id = 1
	var/locked = 0
	var/_wifi_id
	var/datum/wifi/receiver/button/crematorium/wifi_receiver

/obj/structure/crematorium/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/structure/crematorium/Destroy()
	if(connected)
		69del(connected)
		connected = null
	if(wifi_receiver)
		69del(wifi_receiver)
		wifi_receiver = null
	return ..()

/obj/structure/crematorium/proc/update()
	if (connected)
		icon_state = "crema0"
	else
		if (contents.len)
			icon_state = "crema2"
		else
			icon_state = "crema1"
	return

/obj/structure/crematorium/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as69ob|obj in src)
				A.forceMove(loc)
				ex_act(severity)
			69del(src)
			return
		if(2)
			if (prob(50))
				for(var/atom/movable/A as69ob|obj in src)
					A.forceMove(loc)
					ex_act(severity)
				69del(src)
				return
		if(3)
			if (prob(5))
				for(var/atom/movable/A as69ob|obj in src)
					A.forceMove(loc)
					ex_act(severity)
				69del(src)
				return
	return

/obj/structure/crematorium/attack_hand(mob/user as69ob)
//	if (cremating) AWW69AN! THIS WOULD BE SO69UCH69ORE FUN ... TO WATCH
//		user.show_message(SPAN_WARNING("Uh-oh, that was a bad idea."), 1)
//		//usr << "Uh-oh, that was a bad idea."
//		src:loc:poison += 20000000
//		src:loc:firelevel = src:loc:poison
//		return
	if (cremating)
		to_chat(usr, SPAN_WARNING("It's locked."))
		return
	if ((connected) && (locked == 0))
		for(var/atom/movable/A as69ob|obj in connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		//connected = null
		69del(connected)
	else if (locked == 0)
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		connected = new /obj/structure/c_tray( loc )
		step(connected, SOUTH)
		connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, SOUTH)
		if (T.contents.Find(connected))
			connected.connected = src
			icon_state = "crema0"
			for(var/atom/movable/A as69ob|obj in src)
				A.forceMove(connected.loc)
			connected.icon_state = "cremat"
		else
			//connected = null
			69del(connected)
	add_fingerprint(user)
	update()

/obj/structure/crematorium/attackby(P as obj,69ob/user as69ob)
	if (istype(P, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("6969", name), null)  as text
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, usr) > 1 && loc != user))
			return
		t = sanitizeSafe(t,69AX_NAME_LEN)
		if (t)
			name = text("Crematorium- '6969'", t)
		else
			name = "Crematorium"
	add_fingerprint(user)
	return

/obj/structure/crematorium/relaymove(mob/user as69ob)
	if (user.stat || locked)
		return
	connected = new /obj/structure/c_tray( loc )
	step(connected, SOUTH)
	connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, SOUTH)
	if (T.contents.Find(connected))
		connected.connected = src
		icon_state = "crema0"
		for(var/atom/movable/A as69ob|obj in src)
			A.forceMove(connected.loc)
		connected.icon_state = "cremat"
	else
		69del(connected)
		connected = null
	return

/obj/structure/crematorium/proc/cremate(atom/A,69ob/user as69ob)
//	for(var/obj/machinery/crema_switch/O in src) //trying to figure a way to call the switch, too drunk to sort it out atm
//		if(var/on == TRUE)
//		return
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		for (var/mob/M in69iewers(src))
			M.show_message(SPAN_WARNING("You hear a hollow crackle."), 1)
			return

	else
		if(!isemptylist(search_contents_for(/obj/item/disk/nuclear)))
			to_chat(usr, "You get the feeling that you shouldn't cremate one of the items in the cremator.")
			return

		for (var/mob/M in69iewers(src))
			M.show_message(SPAN_WARNING("You hear a roar as the crematorium activates."), 1)

		cremating = 1
		locked = 1

		for(var/mob/living/M in contents)
			if (M.stat!=2)
				if (!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C =69
					if (!(C.species && (C.species.flags & NO_PAIN)))
						C.emote("scream")

			//Logging for this causes runtimes resulting in the cremator locking up. Commenting it out until that's figured out.
			//M.attack_log += "\6969time_stamp()69\69 Has been cremated by <b>69user69/69user.ckey69</b>" //No point in this when the69ob's about to be deleted
			//user.attack_log +="\6969time_stamp()69\69 Cremated <b>69M69/69M.ckey69</b>"
			//log_attack("\6969time_stamp()69\69 <b>69user69/69user.ckey69</b> cremated <b>69M69/69M.ckey69</b>")
			M.death(1)
			M.ghostize()
			69del(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			69del(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = 0
		locked = 0
		playsound(loc, 'sound/machines/ding.ogg', 50, 1)
	return


/*
 * Crematorium tray
 */
/obj/structure/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "cremat"
	density = TRUE
	layer = 2
	var/obj/structure/crematorium/connected
	anchored = TRUE
	throwpass = 1

/obj/structure/c_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/c_tray/attack_hand(mob/user as69ob)
	if (connected)
		for(var/atom/movable/A as69ob|obj in loc)
			if (!( A.anchored ))
				A.forceMove(connected)
			//Foreach goto(26)
		connected.connected = null
		connected.update()
		add_fingerprint(user)
		//SN src = null
		69del(src)
		return
	return

/obj/structure/c_tray/MouseDrop_T(atom/movable/O as69ob|obj,69ob/user as69ob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(loc)
	if (user != O)
		for(var/mob/B in69iewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, (SPAN_WARNING("69user69 stuffs 69O69 into 69src69!")))
			//Foreach goto(99)
	return

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	re69_access = list(access_crematorium)
	id = 1

/obj/machinery/button/crematorium/update_icon()
	return

/obj/machinery/button/crematorium/attack_hand(mob/user as69ob)
	if(..())
		return
	if(allowed(user))
		for (var/obj/structure/crematorium/C in world)
			if (C.id == id)
				if (!C.cremating)
					C.cremate(user)
	else
		to_chat(usr, SPAN_WARNING("Access denied."))
