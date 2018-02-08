/turf/simulated/open/update_icon()
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		return

	overlays.Cut()
	var/turf/below = GetBelow(src)
	if(below)
		if(below.is_space())
			plane = SPACE_PLANE
		else
			plane = OPENSPACE_PLANE
		icon = below.icon
		icon_state = below.icon_state
		dir = below.dir
		color = below.color//rgb(127,127,127)
		overlays += below.overlays

		if(!istype(below,/turf/simulated/open))
			// get objects
			var/image/o_img = list()
			for(var/obj/o in below)
				// ingore objects that have any form of invisibility
				if(o.invisibility) continue
				var/image/temp2 = image(o, dir=o.dir, layer = o.layer)
				temp2.plane = plane
				temp2.color = o.color//rgb(127,127,127)
				temp2.overlays += o.overlays
				o_img += temp2
			overlays += o_img

		var/image/over_OS_darkness = image('icons/turf/floors.dmi', "black_open")
		over_OS_darkness.plane = OVER_OPENSPACE_PLANE
		over_OS_darkness.layer = MOB_LAYER
		overlays += over_OS_darkness
		spawn()
			updateFallability()
	else
		ChangeTurf(/turf/space)

/turf/space/update_icon()
	if(!ticker || ticker.current_state < GAME_STATE_PLAYING)
		return

	overlays.Cut()
	var/turf/below = GetBelow(src)
	if(below)
		if(below.icon == 'icons/turf/space.dmi')
			plane = SPACE_PLANE
		else
			plane = OPENSPACE_PLANE
			var/image/over_OS_darkness = image('icons/turf/floors.dmi', "black_open")
			over_OS_darkness.plane = OVER_OPENSPACE_PLANE
			over_OS_darkness.layer = MOB_LAYER
			overlays += over_OS_darkness
		icon = below.icon
		icon_state = below.icon_state
		dir = below.dir
		color = below.color//rgb(127,127,127)
		overlays += below.overlays

		if(!istype(below,/turf/simulated/open))
			// get objects
			var/image/o_img = list()
			for(var/obj/o in below)
				// ingore objects that have any form of invisibility
				if(o.invisibility) continue
				var/image/temp2 = image(o, dir=o.dir, layer = o.layer)
				temp2.plane = plane
				temp2.color = o.color//rgb(127,127,127)
				temp2.overlays += o.overlays
				o_img += temp2
			overlays += o_img
	else
		icon = initial(icon)
		plane = initial(plane)
		if(!istype(src, /turf/space/transit))
			icon_state = "white"


/hook/roundstart/proc/init_openspace()
	var/turf/T
	for(var/elem in turfs)
		if(istype(elem, /turf/simulated/open) || istype(elem, /turf/space))
			T = elem
			T.update_icon()
	return TRUE


/atom/proc/update_openspace()
	var/turf/T = GetAbove(src)
	if(istype(T,/turf/simulated/open) || istype(T,/turf/space))
		T.update_icon()

/turf/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()

/turf/Exited(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()
