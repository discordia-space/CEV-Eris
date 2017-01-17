#ifdef USE_OPENSPACE

/mob
	var/mob/shadow/shadow

/mob/shadow
	name = "shadow"
	desc = "Z-level shadow"
	layer = OPENSPACE_LAYER + 0.5
	var/mob/owner = null

/mob/shadow/New(var/mob/L)
	if(!istype(L))
		qdel(src)
		return
	//..()
	owner = L
	sync_icon(L)

/mob/Destroy()
	qdel(shadow)
	shadow = null
	. = ..()

/mob/shadow/examine(mob/user, distance, infix, suffix)
	return owner.examine(user, distance, infix, suffix)

/mob/shadow/proc/sync_icon(var/mob/M)
	name = M.name
	icon = M.icon
	icon_state = M.icon_state
	color = M.color
	overlays = M.overlays
	transform = M.transform
	dir = M.dir
	if(shadow)
		shadow.sync_icon(src)

/mob/living/Move()
	..()
	check_shadow()

/mob/living/forceMove()
	..()
	check_shadow()

/mob/living/proc/check_shadow()
	var/mob/M = src
	if(isturf(M.loc))
		var/turf/simulated/open/OS = GetAbove(src)
		while(OS && istype(OS))
			if(!M.shadow)
				M.shadow = PoolOrNew(/mob/shadow, M)
			M.shadow.forceMove(OS)
			OS = GetAbove(M)
			M = M.shadow

	if(M.shadow)
		qdel(M.shadow)
		M.shadow = null

/mob/living/update_icons()
	..()
	if(shadow)
		shadow.sync_icon(src)

/mob/set_dir(new_dir)
	..()
	if(shadow)
		shadow.set_dir(new_dir)

#endif