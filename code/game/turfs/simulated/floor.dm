/turf/simulated/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	plane = FLOOR_PLANE

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/base_icon_state = "plating"

	// Flooring data.
	var/flooring_override
	var/initial_flooring = /decl/flooring/reinforced/plating
	var/decl/flooring/flooring
	var/mineral = MATERIAL_STEEL
	var/set_update_icon
	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0
	var/overrided_icon_state
	var/health = 100
	var/maxHealth = 100


/turf/simulated/floor/is_plating()
	if (flooring)
		return flooring.is_plating
	else
		//TODO: FIND OUT WHY ANYTHING COULD HAVE NULL FLOORING
		return TRUE

/turf/simulated/floor/New(var/newloc, var/floortype)
	..(newloc)
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(get_flooring_data(floortype))

/turf/simulated/floor/proc/set_flooring(var/decl/flooring/newflooring)
	flooring = newflooring
	name = flooring.name
	maxHealth = flooring.health
	health = maxHealth
	update_icon(1)
	levelupdate()


//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)

	overlays.Cut()
	if(islist(decals))
		decals.Cut()
		decals = null

	name = base_name
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state
	set_light(0)
	broken = null
	burnt = null
	flooring_override = null

	if(flooring)
		if(flooring.build_type && place_product)
			new flooring.build_type(src)

		set_flooring(get_flooring_data(flooring.get_plating_type(src)))


/turf/simulated/floor/levelupdate()
	if (flooring)
		for(var/obj/O in src)
			O.hide(O.hides_under_flooring() && (flooring.flags & TURF_HIDES_THINGS))


/turf/simulated/floor/proc/is_damaged()
	if (broken || burnt || health < maxHealth)
		return TRUE
	return FALSE