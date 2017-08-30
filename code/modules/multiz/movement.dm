/obj/item/weapon/tank/jetpack/verb/moveup()
	set name = "Move Upwards"
	set category = "Object"

	. = 1
	if(!allow_thrust(0.01, usr))
		usr << "<span class='warning'>\The [src] is disabled.</span>"
		return

	var/turf/above = GetAbove(src)
	if(!istype(above))
		usr << SPAN_NOTICE("There is nothing of interest in this direction.")
		return

	if(!istype(above, /turf/space) && !istype(above, /turf/simulated/open))
		usr << "<span class='warning'>You bump against \the [above].</span>"
		return

	for(var/atom/A in above)
		if(A.density)
			usr << "<span class='warning'>\The [A] blocks you.</span>"
			return

	usr.Move(above)
	usr << SPAN_NOTICE("You move upwards.")

/obj/item/weapon/tank/jetpack/verb/movedown()
	set name = "Move Downwards"
	set category = "Object"

	. = 1
	if(!allow_thrust(0.01, usr))
		usr << "<span class='warning'>\The [src] is disabled.</span>"
		return

	var/turf/below = GetBelow(src)
	if(!istype(below))
		usr << SPAN_NOTICE("There is nothing of interest in this direction.")
		return

	if(below.density)
		usr << "<span class='warning'>You bump against \the [below].</span>"
		return

	for(var/atom/A in below)
		if(A.density)
			usr << "<span class='warning'>\The [A] blocks you.</span>"
			return

	usr.Move(below)
	usr << SPAN_NOTICE("You move downwards.")


/mob/observer/ghost/verb/moveup()
	set name = "Move Upwards"
	set category = null
	var/turf/T = GetAbove(src)
	if(T)
		src.Move(T)


/mob/observer/ghost/verb/movedown()
	set name = "Move Downwards"
	set category = null
	var/turf/T = GetBelow(src)
	if(T)
		src.Move(T)
