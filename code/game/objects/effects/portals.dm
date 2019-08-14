/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	var/mask = "portal_mask"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/atom/target = null
	anchored = TRUE
	var/lifetime = 0
	var/birthtime = 0
	var/next_teleport
	var/origin_turf //The last mob thing that attempted to enter this portal came from thus turf

/obj/effect/portal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover)) // if mover is not null, e.g. mob
		return FALSE
	return TRUE // if mover is null (air movement)

/obj/effect/portal/Bumped(var/atom/movable/M)
	origin_turf = get_turf(M)
	src.teleport(M)

/obj/effect/portal/Crossed(var/atom/movable/AM)
	origin_turf = get_turf(AM)
	src.teleport(AM)

/obj/effect/portal/attack_hand(mob/user as mob)
	origin_turf = get_turf(user)
	src.teleport(user)

/obj/effect/portal/proc/set_target(var/atom/A)
	target = A
	if(mask)
		blend_icon(get_turf(target))

/obj/effect/portal/New(loc, _lifetime = 300)
	..(loc)
	birthtime = world.time
	lifetime = _lifetime
	addtimer(CALLBACK(src, .proc/close,), lifetime)

var/list/portal_cache = list()

/obj/effect/portal/proc/blend_icon(var/turf/T)
	if(!("icon[initial(T.icon)]_iconstate[T.icon_state]_[type]" in portal_cache))//If the icon has not been added yet
		var/icon/I1 = icon(icon,mask)//Generate it.
		var/icon/I2 = icon(initial(T.icon),T.icon_state)
		I1.Blend(I2,ICON_MULTIPLY)
		portal_cache["icon[initial(T.icon)]_iconstate[T.icon_state]_[type]"] = I1 //And cache it!

	overlays += portal_cache["icon[initial(T.icon)]_iconstate[T.icon_state]_[type]"]



//Given an adjacent origin tile, finds a destination which is the opposite side of the target
/obj/effect/portal/proc/get_destination(var/turf/origin)
	if (!target)
		return null
		//Major error!
	var/turf/T = get_turf(target)
	. = T

	if (origin && Adjacent(origin))
		var/dir = get_dir(origin, loc)
		return get_step(T, dir)

/obj/effect/portal/proc/close()
	qdel(src)

/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	if (world.time < next_teleport)
		return
	if (M == src)
		return
	if (istype(M, /obj/effect/sparks)) //sparks don't teleport
		return
	if (istype(M, /obj/effect/effect/light)) //lights from flashlights too.
		return
	if (M.anchored && !istype(M, /obj/mecha))
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			on_fail(M)
		else
			do_teleport(M, get_destination(origin_turf), 0) ///You will appear adjacent to the beacon
			next_teleport = world.time + 3 //Tiny cooldown to prevent doubleporting
			return TRUE

/obj/effect/portal/proc/on_fail(atom/movable/M as mob|obj)
	src.icon_state = "portal1"
	do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)

/*
	Wormholes come in linked pairs and can be traversed freely from either end.
	They gain some instability after being used, and should be left to settle or risk mishaps
*/
/obj/effect/portal/wormhole
	icon = 'icons/obj/objects.dmi'
	icon_state = "wormhole"
	name = "wormhole"
	mask = null
	failchance = 0
	var/obj/effect/portal/wormhole/partner
	var/processing = FALSE

/obj/effect/portal/wormhole/New(loc, lifetime, exit)
	message_admins("Wormhole with lifetime [time2text(lifetime, "hh hours, mm minutes and ss seconds")] created at ([jumplink(src)])", 0, 1)
	..(loc, lifetime)
	set_target(exit)
	pair()

/obj/effect/portal/wormhole/teleport(atom/movable/M as mob|obj)
	.=..(M)

	//Parent returns true if someone was successfully teleported
	if (.)
		//In that case, we'll gain some instability
		failchance += 3.5
		if (!processing)
			START_PROCESSING(SSobj, src)
			processing = TRUE
		update_icon()

/obj/effect/portal/wormhole/Process()
	//We will gradually stabilize
	failchance -= 0.1
	update_icon()

	//If we become fully stable, we stop processing
	if (failchance <= 0)
		failchance = 0
		STOP_PROCESSING(SSobj, src)
		processing = FALSE

/obj/effect/portal/wormhole/update_icon()
	if (failchance > 0)
		icon_state = "wormhole_unstable"
		desc = "It is whirling violently. Going into this thing might be a bad idea."
	else
		icon_state = "wormhole"
		desc = "It spins gently and calmly. It's probably safe, right?"

//Links this wormhole up with its target destination, creating another if necessary
/obj/effect/portal/wormhole/proc/pair()
	partner = null
	if (!target)
		return

	var/turf/T = get_turf(target)
	partner = (locate(/obj/effect/portal/wormhole) in T)

	//There's no wormhole in the target tile yet. We shall make one
	if (!partner)
		partner = new /obj/effect/portal/wormhole(T, lifetime, loc)



/obj/effect/portal/unstable

/obj/effect/portal/unstable/on_fail(atom/movable/M as mob|obj)
	src.icon_state = "portal1"
	if(istype(M, /mob/living))
		var/mob/living/victim = M
		//Portals ignore armor when messing you up, it's logical
		victim.apply_damage(20+rand(60), BRUTE, pick(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG))
	do_teleport(M, get_destination(get_turf(M)), 1)
