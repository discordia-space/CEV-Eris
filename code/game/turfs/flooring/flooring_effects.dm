/obj/effect/damagedfloor

/obj/effect/damagedfloor/fire


/obj/effect/damagedfloor/New(loc)
	var/turf/simulated/floor/F = loc
	if(istype(F))
		if(istype(src, /obj/effect/damagedfloor/fire))
			F.burn_tile()
	qdel(src)