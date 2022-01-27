/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'
	opacity = 0 // NOTE currently lighting broken for smokes (actually for any similar feature - its okay with a single cloud, but not when "millions" of them created at once) -
	// - with opacity and until someone comes with proper fix, setting this to TRUE69ust be avoided.
	layer = 6
	time_to_live = 300
	pass_flags = PASSTABLE | PASSGRILLE | PASSGLASS //PASSGLASS is fine here, it's just so the69isual effect can "flow" around glass
	var/splash_amount = 10 //atoms69oving through a smoke cloud get splashed with up to 10 units of reagent
	var/turf/destination

/obj/effect/effect/smoke/chem/New(var/newloc, smoke_duration, turf/dest_turf = null, icon/cached_icon = null)
	time_to_live = smoke_duration

	..()

	create_reagents(500)

	if(cached_icon)
		icon = cached_icon

	set_dir(pick(cardinal))
	pixel_x = -32 + rand(-8, 8)
	pixel_y = -32 + rand(-8, 8)

	//float over to our destination, if we have one
	destination = dest_turf
	if(destination)
		walk_to(src, destination)


/obj/effect/effect/smoke/chem/Destroy()
	if (reagents)
		reagents.my_atom = null
		69DEL_NULL(reagents)
	walk(src, 0)
	return ..()

/obj/effect/effect/smoke/chem/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	var/list/oldlocs =69iew(1, src)
	. = ..()
	if(.)
		for(var/turf/T in69iew(1, src) - oldlocs)
			for(var/atom/movable/AM in T)
				if(!istype(AM, /obj/effect/effect/smoke/chem))
					reagents.splash(AM, splash_amount, copy = 1)
		if(loc == destination)
			bound_width = 96
			bound_height = 96

/obj/effect/effect/smoke/chem/Crossed(atom/movable/AM)
	..()
	if(!istype(AM, /obj/effect/effect/smoke) && reagents)
		reagents.splash(AM, splash_amount, copy = 1)

/obj/effect/effect/smoke/chem/proc/initial_splash()
	for(var/turf/T in69iew(1, src))
		for(var/atom/movable/AM in T)
			if(!istype(AM, /obj/effect/effect/smoke/chem))
				reagents.splash(AM, splash_amount, copy = 1)



/////////////////////////////////////////////
// Chem Smoke Effect System
/////////////////////////////////////////////
/datum/effect/effect/system/smoke_spread/chem
	smoke_type = /obj/effect/effect/smoke/chem
	var/obj/chemholder
	var/range
	var/list/targetTurfs
	var/list/wallList
	var/density
	var/show_log = 1

/datum/effect/effect/system/smoke_spread/chem/spores
	show_log = 0
	var/datum/seed/seed

/datum/effect/effect/system/smoke_spread/chem/spores/New(seed_name)
	if(seed_name && plant_controller)
		seed = plant_controller.seeds69seed_name69
	if(!seed)
		69del(src)
	..()

/datum/effect/effect/system/smoke_spread/chem/New()
	..()
	chemholder = new/obj()
	chemholder.create_reagents(500)

//Sets up the chem smoke effect
// Calculates the69ax range smoke can travel, then gets all turfs in that69iew range.
// Culls the selected turfs to a (roughly) circle shape, then calls smokeFlow() to69ake
// sure the smoke can actually path to the turfs. This culls any turfs it can't reach.
/datum/effect/effect/system/smoke_spread/chem/set_up(var/datum/reagents/carry = null, n = 10, c = 0, loca, direct)
	range = n * 0.3
	cardinals = c
	carry.trans_to_obj(chemholder, carry.total_volume, copy = 1)

	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(!location)
		return

	targetTurfs = new()

	//build affected area list
	for(var/turf/T in69iew(range, location))
		//cull turfs to circle
		if(s69rt((T.x - location.x)**2 + (T.y - location.y)**2) <= range)
			targetTurfs += T

	wallList = new()

	smokeFlow() //pathing check

	//set the density of the cloud - for diluting reagents
	density =69ax(1, targetTurfs.len / 4) //clamp the cloud density69inimum to 1 so it cant69ultiply the reagents

	//Admin69essaging
	var/contained = carry.log_list()
	var/area/A = get_area(location)

	var/where = "69A.name69 | 69location.x69, 69location.y69"
	var/whereLink = "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69location.x69;Y=69location.y69;Z=69location.z69'>69where69</a>"

	if(show_log)
		if(carry.my_atom.fingerprintslast)
			var/mob/M = get_mob_by_key(carry.my_atom.fingerprintslast)
			var/more = ""
			if(M)
				more = "(<A HREF='?_src_=holder;adminmoreinfo=\ref69M69'>?</a>)"
			message_admins("A chemical smoke reaction has taken place in (69whereLink69)69contained69. Last associated key is 69carry.my_atom.fingerprintslast6969more69.", 0, 1)
			log_game("A chemical smoke reaction has taken place in (69where69)69contained69. Last associated key is 69carry.my_atom.fingerprintslast69.")
		else
			if(ismob(carry.my_atom)) // less admin log spam from smoke created by69obs (for now this is against roaches gas log spam or something similar).
				return
			message_admins("A chemical smoke reaction has taken place in (69whereLink69). No associated key.", 0, 1)
			log_game("A chemical smoke reaction has taken place in (69where69)69contained69. No associated key.")

//Runs the chem smoke effect
// Spawns damage over time loop for each reagent held in the cloud.
// Applies reagents to walls that affect walls (only thermite and plant-b-gone at the69oment).
// Also calculates target locations to spawn the69isual smoke effect on, so the whole area
// is covered fairly evenly.
/datum/effect/effect/system/smoke_spread/chem/start()
	if(!location)
		return

	if(chemholder.reagents.reagent_list.len) //reagent application - only run if there are extra reagents in the smoke
		for(var/turf/T in wallList)
			chemholder.reagents.touch_turf(T)
		for(var/turf/T in targetTurfs)
			chemholder.reagents.touch_turf(T)
			for(var/atom/A in T.contents)
				if(istype(A, /obj/effect/effect/smoke/chem))
					continue
				else if (ismob(A))
					chemholder.reagents.touch_mob(A)
				else if(isobj(A) && !A.simulated)
					chemholder.reagents.touch_obj(A)

	var/color = chemholder.reagents.get_color() //build smoke icon
	var/icon/I
	if(color)
		I = icon('icons/effects/chemsmoke.dmi')
		I += color
	else
		I = icon('icons/effects/96x96.dmi', "smoke")

	//Calculate smoke duration
	var/smoke_duration = 150

	var/pressure = 0
	var/datum/gas_mixture/environment = location.return_air()
	if(environment) pressure = environment.return_pressure()
	smoke_duration = between(5, smoke_duration*pressure/(ONE_ATMOSPHERE/3), smoke_duration)

	var/const/arcLength = 2.3559 //distance between each smoke cloud

	for(var/i = 0, i < range, i++) //calculate positions for smoke coverage - then spawn smoke
		var/radius = i * 1.5
		if(!radius)
			spawn(0)
				spawnSmoke(location, I, 1, 1)
			continue

		var/offset = 0
		var/points = round((radius * 2 *69_PI) / arcLength)
		var/angle = round(TODEGREES(arcLength / radius), 1)

		if(!ISINTEGER(radius))
			offset = 45		//degrees

		for(var/j = 0, j < points, j++)
			var/a = (angle * j) + offset
			var/x = round(radius * cos(a) + location.x, 1)
			var/y = round(radius * sin(a) + location.y, 1)
			var/turf/T = locate(x,y,location.z)
			if(!T)
				continue
			if(T in targetTurfs)
				spawn(0)
					spawnSmoke(T, I, range)

//------------------------------------------
// Randomizes and spawns the smoke effect.
// Also handles deleting the smoke once the effect is finished.
//------------------------------------------
/datum/effect/effect/system/smoke_spread/chem/proc/spawnSmoke(var/turf/T,69ar/icon/I,69ar/smoke_duration,69ar/dist = 1,69ar/splash_initial=0,69ar/obj/effect/effect/smoke/chem/passed_smoke)

	var/obj/effect/effect/smoke/chem/smoke
	if(passed_smoke)
		smoke = passed_smoke
	else
		smoke = new(location, smoke_duration + rand(0, 20), T, I)

	if(chemholder.reagents.reagent_list.len)
		chemholder.reagents.trans_to_obj(smoke, chemholder.reagents.total_volume / dist, copy = 1) //copy reagents to the smoke so69ob/breathe() can handle inhaling the reagents

	//Kinda ugly, but needed unless the system is reworked
	if(splash_initial)
		smoke.initial_splash()


/datum/effect/effect/system/smoke_spread/chem/spores/spawnSmoke(var/turf/T,69ar/smoke_duration,69ar/icon/I,69ar/dist = 1)
	var/obj/effect/effect/smoke/chem/spores = new(location)
	spores.name = "cloud of 69seed.seed_name69 69seed.seed_noun69"
	..(T, I, smoke_duration, dist, spores)


/datum/effect/effect/system/smoke_spread/chem/proc/smokeFlow() // Smoke pathfinder. Uses a flood fill69ethod based on zones to 69uickly check what turfs the smoke (airflow) can actually reach.

	var/list/pending = new()
	var/list/complete = new()

	pending += location

	while(pending.len)
		for(var/turf/current in pending)
			for(var/D in cardinal)
				var/turf/target = get_step(current, D)
				if(wallList)
					if(istype(target, /turf/simulated/wall))
						if(!(target in wallList))
							wallList += target
						continue

				if(target in pending)
					continue
				if(target in complete)
					continue
				if(!(target in targetTurfs))
					continue
				if(current.c_airblock(target)) //this is needed to stop chemsmoke from passing through thin window walls
					continue
				if(target.c_airblock(current))
					continue
				pending += target

			pending -= current
			complete += current

	targetTurfs = complete

	return
