// filler object for visual stuff
/atom/movable/overlay/door
	name = ""
	icon = DOOR_MISC_ICON
	icon_state = ""
	density = FALSE
	anchored = TRUE

/atom/movable/overlay/door/proc/flick_door(icon_flick)
	if(!icon_flick)
		return
	flick(icon_flick, src)
