/mob  // TODO: rewrite as obj.
	var/mob/shadow/shadow

/mob/shadow
	plane = OPENSPACE_PLANE
	name = "shadow"
	desc = "Z-level shadow"
	anchored = 1
	unacidable = 1
	density = 0
	var/mob/owner = null

/mob/shadow/can_fall()
	return FALSE

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
	. = ..()
	check_shadow()

/mob/living/forceMove()
	. = ..()
	check_shadow()

/mob/living/proc/check_shadow()
	var/mob/M = src
	if(isturf(M.loc))
		var/turf/simulated/open/OS = GetAbove(src)
		while(OS && istype(OS))
			if(!M.shadow)
				M.shadow = PoolOrNew(/mob/shadow, M)
			M.shadow.forceMove(OS)
			M = M.shadow
			OS = GetAbove(M)

	if(M.shadow)
		qdel(M.shadow)
		M.shadow = null
		var/client/C = M.client
		if(C && C.eye == shadow)
			M.reset_view(0)

/mob/living/update_icons()
	. = ..()
	if(shadow)
		shadow.sync_icon(src)

/mob/set_dir(new_dir)
	. = ..()
	if(shadow)
		shadow.set_dir(new_dir)
