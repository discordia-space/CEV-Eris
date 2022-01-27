/proc/anim(turf/location as turf,tar69et as69ob|obj,a_icon,a_icon_state as text,flick_anim as text,sleeptime = 0,direction as69um)
//This proc throws up either an icon or an animation for a specified amount of time.
//The69ariables should be apparent enou69h.
	if(!location && tar69et)
		location = 69et_turf(tar69et)
	if(location && !tar69et)
		tar69et = location
	var/atom/movable/overlay/animation =69ew(location)
	if(direction)
		animation.set_dir(direction)
	animation.icon = a_icon
	animation.layer = tar69et:layer+1
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		animation.master = tar69et
		flick(flick_anim, animation)
	spawn(max(sleeptime, 15))
		69del(animation)
