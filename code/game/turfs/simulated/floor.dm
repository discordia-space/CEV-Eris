/turf/simulated/floor
	name = "platin69"
	icon = 'icons/turf/floorin69/platin69.dmi'
	icon_state = "platin69"
	plane = FLOOR_PLANE

	// Dama69e to floorin69.
	var/broken
	var/burnt


	// Floorin69 data.
	var/floorin69_override
	var/initial_floorin69 = /decl/floorin69/reinforced/platin69
	var/decl/floorin69/floorin69
	var/mineral =69ATERIAL_STEEL
	var/set_update_icon
	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0
	var/overrided_icon_state
	var/health = 100
	var/maxHealth = 100


/turf/simulated/floor/Entered(atom/movable/AM, atom/old_loc)
	..(AM, old_loc)
	if (floorin69)
		floorin69.Entered(AM, old_loc)

/turf/simulated/floor/is_platin69()
	if (floorin69)
		return floorin69.is_platin69
	else
		//TODO: FIND OUT WHY ANYTHIN69 COULD HAVE69ULL FLOORIN69
		return TRUE

/turf/simulated/floor/New(newloc, floortype)
	if(!floortype && initial_floorin69)
		floortype = initial_floorin69
	if(floortype)
		set_floorin69(69et_floorin69_data(floortype), FALSE)
	..(newloc)


/turf/simulated/floor/Initialize()
	turfs += src
	..()
	return INITIALIZE_HINT_LATELOAD

//Floors69o lon69er update their icon in69ew, but instead update it here, after everythin69 else is setup
/turf/simulated/floor/LateInitialize(list/mapload_ar69)
	..()
	//At roundstart, we call update icon with update_nei69hbors set to false.
	//So each floor tile will only work once
	if (mapload_ar69)
		update_icon(FALSE)
	else
		//If its69ot roundstart, then we call update icon with update_nei69hbors set to true.
		//That will update surroundin69s for any floors that are created or destroyed durin69 runtime
		update_icon(TRUE)

//If the update69ar is false we don't call update icons
/turf/simulated/floor/proc/set_floorin69(var/decl/floorin69/newfloorin69,69ar/update = TRUE)
	floorin69 =69ewfloorin69
	name = floorin69.name
	maxHealth = floorin69.health
	health =69axHealth
	floorin69_override =69ull

	/*This is passed false in the69ew() floorin69 set, so that we're69ot callin69 everythin69 up to
	nine times when the world is created. This saves on tons of roundstart processin69*/
	if (update)
		update_icon(1)

	levelupdate()

/turf/simulated/floor/examine(mob/user)
	.=..()
	if (health <69axHealth)
		if (health < (0.25 *69axHealth))
			to_chat(user, SPAN_DAN69ER("It looks like it's about to collapse!"))
		else if (health < (0.5 *69axHealth))
			to_chat(user, SPAN_WARNIN69("It's heavily dama69ed!"))
		else if (health < (0.75 *69axHealth))
			to_chat(user, SPAN_WARNIN69("It's taken a bit of a beatin69!"))
		else
			to_chat(user, SPAN_WARNIN69("It has a few scuffs and scrapes"))



//This proc will set floor_type to69ull and the update_icon() proc will then chan69e the icon_state of the turf
//This proc auto corrects the 69rass tiles' sidin69.
/turf/simulated/floor/proc/make_platin69(var/place_product,69ar/defer_icon_update)

	overlays.Cut()
	if(islist(decals))
		decals.Cut()
		decals =69ull


	set_li69ht(0)
	broken =69ull
	burnt =69ull
	floorin69_override =69ull

	if(floorin69)
		if(floorin69.build_type && place_product)
			new floorin69.build_type(src)

	//We attempt to 69et whatever should be under this floor
	var/temp = floorin69.69et_platin69_type(src) //This will return69ull if there's69othin69 underneath
	if (temp)
		set_floorin69(69et_floorin69_data(temp))
	else
		ReplaceWithLattice() //IF there's69othin69 underneath, turn ourselves into an openspace


/turf/simulated/floor/levelupdate()
	if (floorin69)
		for(var/obj/O in src)
			O.hide(O.hides_under_floorin69() && (floorin69.fla69s & TURF_HIDES_THIN69S))
			SEND_SI69NAL(O, COMSI69_TURF_LEVELUPDATE, (floorin69.fla69s & TURF_HIDES_THIN69S))


/turf/simulated/floor/proc/is_dama69ed()
	if (broken || burnt || health <69axHealth)
		return TRUE
	return FALSE