//Don't69eeded because of69is_contents feature

/mob  // TODO: rewrite as obj.
	var/mob/shadow/shadow

/mob/shadow
	name = "shadow"
	desc = "Z-level shadow"
	anchored = TRUE
	unacidable = 1
	density = FALSE
	alpha = 0
	original_plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	vis_flags =69IS_HIDE // Prevents69ob shadows from stacking on open spaces when the69ob is69ore than 1 z-level below
	var/mob/owner =69ull

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
	shadow =69ull
	. = ..()

/mob/shadow/examine(mob/user, distance, infix, suffix)
	return owner.examine(user, distance, infix, suffix)

/mob/shadow/proc/sync_icon(var/mob/M)
	name =69.name
	icon =69.icon
	icon_state =69.icon_state
	color =69.color
	overlays =69.overlays
	transform =69.transform
	dir =69.dir
	if(shadow)
		shadow.sync_icon(src)

/mob/living/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	. = ..()
	check_shadow()

/mob/living/forceMove(atom/destination,69ar/special_event, glide_size_override=0)
	. = ..()
	check_shadow()

/mob/living/proc/check_shadow()
	var/mob/M = src
	if(isturf(M.loc))
		var/turf/T = GetAbove(src)
		while(T && T.isTransparent)
			if(!M.shadow)
				M.shadow =69ew(M)
			M.shadow.forceMove(T)
			M =69.shadow
			T = GetAbove(M)

	if(M.shadow)
		qdel(M.shadow)
		M.shadow =69ull
		var/client/C =69.client
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
