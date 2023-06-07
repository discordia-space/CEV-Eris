/turf/simulated/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	plane = FLOOR_PLANE

	// Damage to flooring.
	var/broken
	var/burnt


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


/turf/simulated/floor/Entered(atom/movable/AM, atom/old_loc)
	..(AM, old_loc)
	if (flooring)
		flooring.Entered(AM, old_loc)

/turf/simulated/floor/is_plating()
	if (flooring)
		return flooring.is_plating
	else
		//TODO: FIND OUT WHY ANYTHING COULD HAVE NULL FLOORING
		return TRUE

/turf/simulated/floor/New(newloc, floortype)
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(get_flooring_data(floortype), FALSE)
	..(newloc)


/turf/simulated/floor/Initialize()
	turfs += src
	..()
	return INITIALIZE_HINT_LATELOAD

//Floors no longer update their icon in New, but instead update it here, after everything else is setup
/turf/simulated/floor/LateInitialize(list/mapload_arg)
	..()
	//At roundstart, we call update icon with update_neighbors set to false.
	//So each floor tile will only work once
	if (mapload_arg)
		update_icon(FALSE)
	else
		//If its not roundstart, then we call update icon with update_neighbors set to true.
		//That will update surroundings for any floors that are created or destroyed during runtime
		update_icon(TRUE)

//If the update var is false we don't call update icons
/turf/simulated/floor/proc/set_flooring(var/decl/flooring/newflooring, var/update = TRUE)
	flooring = newflooring
	name = flooring.name
	maxHealth = flooring.health
	health = maxHealth
	flooring_override = null

	/*This is passed false in the New() flooring set, so that we're not calling everything up to
	nine times when the world is created. This saves on tons of roundstart processing*/
	if (update)
		update_icon(1)

	levelupdate()

/turf/simulated/floor/examine(mob/user)
	.=..()
	if (health < maxHealth)
		if (health < (0.25 * maxHealth))
			to_chat(user, SPAN_DANGER("It looks like it's about to collapse!"))
		else if (health < (0.5 * maxHealth))
			to_chat(user, SPAN_WARNING("It's heavily damaged!"))
		else if (health < (0.75 * maxHealth))
			to_chat(user, SPAN_WARNING("It's taken a bit of a beating!"))
		else
			to_chat(user, SPAN_WARNING("It has a few scuffs and scrapes"))



//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)

	overlays.Cut()
	if(islist(decals))
		decals.Cut()
		decals = null


	set_light(0)
	broken = null
	burnt = null
	flooring_override = null

	if(flooring)
		if(flooring.build_type && place_product)
			new flooring.build_type(src)

	//We attempt to get whatever should be under this floor
	if(flooring)
		var/temp = flooring.get_plating_type(src) //This will return null if there's nothing underneath
		if (temp)
			set_flooring(get_flooring_data(temp))
			return
	ReplaceWithLattice() //IF there's nothing underneath, turn ourselves into an openspace


/turf/simulated/floor/levelupdate()
	if (flooring)
		for(var/obj/O in src)
			O.hide(O.hides_under_flooring() && (flooring.flags & TURF_HIDES_THINGS))
			SEND_SIGNAL_OLD(O, COMSIG_TURF_LEVELUPDATE, (flooring.flags & TURF_HIDES_THINGS))


/turf/simulated/floor/proc/is_damaged()
	if (broken || burnt || health < maxHealth)
		return TRUE
	return FALSE
