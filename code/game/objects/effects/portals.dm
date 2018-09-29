/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	anchored = TRUE

/obj/effect/portal/Bumped(mob/M as mob|obj)
	spawn(0)
		src.teleport(M)
		return
	return

/obj/effect/portal/Crossed(AM as mob|obj)
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/effect/portal/attack_hand(mob/user as mob)
	spawn(0)
		src.teleport(user)
		return
	return

/obj/effect/portal/New(loc, lifetime = 300)
	..(loc)
	spawn(lifetime)
		qdel(src)

/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			on_fail(M)
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon

/obj/effect/portal/proc/on_fail(atom/movable/M as mob|obj)
	src.icon_state = "portal1"
	do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)


/obj/effect/portal/wormhole
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	name = "wormhole"
	failchance = 0

/obj/effect/portal/wormhole/New(loc, exit, lifetime)
	..(loc, lifetime)
	target = exit


/obj/effect/portal/unstable

/obj/effect/portal/unstable/on_fail(atom/movable/M as mob|obj)
	src.icon_state = "portal1"
	if(istype(M, /mob/living))
		var/mob/living/victim = M
		victim.apply_damage(20+rand(60), BRUTE, pick(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG))
	do_teleport(M, target, 1)