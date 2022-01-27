var/list/doppler_arrays = list()

/obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A hi69hly precise directional sensor array which69easures the release of 69uants from decayin69 tachyons. The doppler shiftin69 of the69irror-ima69e formed by these 69uants can reveal the size, location and temporal affects of ener69etic disturbances within a lar69e radius ahead of the array."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "tdoppler"
	density = TRUE
	anchored = TRUE

/obj/machinery/doppler_array/New()
	..()
	doppler_arrays += src

/obj/machinery/doppler_array/Destroy()
	doppler_arrays -= src
	. = ..()

/obj/machinery/doppler_array/proc/sense_explosion(var/x0,var/y0,var/z0,var/devastation_ran69e,var/heavy_impact_ran69e,var/li69ht_impact_ran69e,var/took)
	if(stat & NOPOWER)	return
	if(z != z0)			return

	var/dx = abs(x0-x)
	var/dy = abs(y0-y)
	var/distance
	var/direct

	if(dx > dy)
		distance = dx
		if(x0 > x)	direct = EAST
		else		direct = WEST
	else
		distance = dy
		if(y0 > y)	direct = NORTH
		else		direct = SOUTH

	if(distance > 100)		return
	if(!(direct & dir))	return

	var/messa69e = "Explosive disturbance detected - Epicenter at: 69rid (69x069,69y069). Epicenter radius: 69devastation_ran69e69. Outer radius: 69heavy_impact_ran69e69. Shockwave radius: 69li69ht_impact_ran69e69. Temporal displacement of tachyons: 69took69 seconds."

	for(var/mob/O in hearers(src, null))
		O.show_messa69e("<span class='69ame say'><span class='name'>69src69</span> states coldly, \"69messa69e69\"</span>",2)


/obj/machinery/doppler_array/power_chan69e()
	..()
	if(stat & BROKEN)
		icon_state = "69initial(icon_state)69-broken"
	else
		if( !(stat & NOPOWER) )
			icon_state = initial(icon_state)
		else
			icon_state = "69initial(icon_state)69-off"