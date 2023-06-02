#define NEIGHBOR_REFRESH_TIME 100
#define MIN_LIGHT_LIMIT 0.5

/obj/effect/plant/proc/get_cardinal_neighbors()
	var/list/cardinal_neighbors = list()
	for(var/check_dir in cardinal)
		var/turf/simulated/T = get_step(get_turf(src), check_dir)
		if(istype(T))
			cardinal_neighbors |= T
	return cardinal_neighbors

/obj/effect/plant/proc/update_neighbors()
	// Update our list of valid neighboring turfs.
	neighbors = list()
	var/list/tocheck = get_cardinal_neighbors()
	for(var/turf/simulated/floor in tocheck)
		var/turf/zdest = get_connecting_turf(floor, loc)//Handling zlevels
		if(get_dist(parent, floor) > spread_distance)
			continue

		//We check zdest, not floor, for existing plants
		if((locate(/obj/effect/plant) in zdest.contents) || (locate(/obj/effect/dead_plant) in zdest.contents))
			if(!(seed.get_trait(TRAIT_INVASIVE)))//Invasive ones can invade onto other tiles
				continue
			var/obj/effect/plant/neighbor_plant = (locate(/obj/effect/plant) in zdest.contents)
			if(neighbor_plant.seed.get_trait(TRAIT_INVASIVE))//If it's also invasive, don't invade (for better performance and plants not eating at itself)
				continue

		//We dont want to melt external walls and cause breaches
		if(!near_external && floor.density)
			if(!isnull(seed.chems["pacid"]))
				spawn(rand(5,25)) floor.explosion_act(100, null)
			continue
		if(!Adjacent(floor))
			continue

		//Space vines can grow through airlocks by forcing their way into tiny gaps
		//There also can be special conditions handling
		if (!floor.Enter(src))

			//Maintshooms cannot, spread trait must be 3 or more
			if(seed.get_trait(TRAIT_SPREAD) < 3)
				continue

			//If these two are not the same then we're attempting to enter a portal or stairs
			//We will allow it
			if (zdest == floor)
				var/obj/machinery/door/found_door = null
				for (var/obj/machinery/door/D in floor)
					if (!D || !istype(D) || !D.density || D.welded) //Can't grow through doors that are welded shut
						continue

					found_door = D

				if (!found_door)
					continue

				var/can_pass = door_interaction(found_door, floor)
				if(!can_pass)
					continue


		neighbors |= floor
	// Update all of our friends.
	var/turf/T = get_turf(src)
	for(var/obj/effect/plant/neighbor in range(1,src))
		neighbor.neighbors -= T


/obj/effect/plant/proc/door_interaction(obj/machinery/door/door, turf/simulated/floor)
	//We have to make sure that nothing ELSE aside from the door is blocking us
	var/blocked = FALSE
	for (var/obj/O in floor)
		if (O == door)
			continue

		if (!O.CanPass(src, floor))
			blocked = TRUE
			break

	if (blocked)
		return FALSE
	return TRUE

//This silly special case override is needed to make vines work with portals.
//Code is copied from /atoms_movable.dm, but a spawn call is removed, making it completely synchronous
/obj/effect/plant/Bump(var/atom/A, yes)
	if (A && yes)
		A.last_bumped = world.time
		A.Bumped(src)

/obj/effect/plant/Process()
	// Something is very wrong, kill ourselves.
	if(!seed || !loc)
		die_off()
		return PROCESS_KILL

	for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.has_reagent("plantbgone"))
			die_off()
			return

	// Handle life.
	life()

	if(buckled_mob)
		seed.do_sting(buckled_mob,src)
		if(seed.get_trait(TRAIT_CARNIVOROUS))
			seed.do_thorns(buckled_mob,src)

	if(world.time >= last_tick+NEIGHBOR_REFRESH_TIME)
		last_tick = world.time
		update_neighbors()

	if(sampled)
		//Should be between 2-7 for given the default range of values for TRAIT_PRODUCTION
		var/chance = max(1, round(30/seed.get_trait(TRAIT_PRODUCTION)))
		if(prob(chance))
			sampled = 0

	if(is_mature() && neighbors.len && prob(spread_chance))
		spawn()
			spread()

	// We shouldn't have spawned if the controller doesn't exist.
	check_health(FALSE)//Dont want to update the icon every process
	if(neighbors.len || health != max_health)
		plant_controller.add_plant(src)

	if (seed.get_trait(TRAIT_CHEM_SPRAYER) && !spray_cooldown)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(1,mainloc))
			if(A.move_speed < 12)
				HasProximity(A)
				A.visible_message(SPAN_WARNING("[src] sprays something on [A.name]!"), SPAN_WARNING("[src] sprays something on you!"))
				spray_cooldown = TRUE
				spawn(10)
					spray_cooldown = FALSE

	if(seed.get_trait(TRAIT_CHEMS) && reagents.get_free_space() && !chem_regen_cooldown)
		for (var/reagent in seed.chems)
			src.reagents.add_reagent(reagent, 1)
		chem_regen_cooldown = TRUE
		spawn(600)
			chem_regen_cooldown = FALSE


/obj/effect/plant/proc/life()
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		health -= seed.handle_environment(T,T.return_air(),null,1)

	// Maintshrooms will not grow in the light
	if(seed.type == /datum/seed/mushroom/maintshroom && T.get_lumcount() > MIN_LIGHT_LIMIT)
		return

	if(health < max_health)
		//Plants can grow through closed airlocks, but more slowly, since they have to force metal to make space
		var/obj/machinery/door/D = (locate(/obj/machinery/door) in loc)
		if (D)
			health += RAND_DECIMAL(0,0.5)
		else
			health += RAND_DECIMAL(1,2.5)
		refresh_icon()
		if(health > max_health)
			health = max_health
	else if(health == max_health && !plant && (seed.type != /datum/seed/mushroom/maintshroom))
		plant = new(T,seed)
		plant.dir = src.dir
		plant.transform = src.transform
		plant.age = seed.get_trait(TRAIT_MATURATION)-1
		plant.update_icon()
		if(growth_type==0) //Vines do not become invisible.
			invisibility = INVISIBILITY_MAXIMUM
		else
			plant.layer = layer + 0.1


/obj/effect/plant/proc/spread()
	//spread to 1-3 adjacent turfs depending on yield trait.
	var/max_spread = between(1, round(seed.get_trait(TRAIT_YIELD)*3/14), 3)
	max_spread = rand(1, max_spread)
	for(var/i in 1 to max_spread)
		sleep(rand(3,5))
		if(!neighbors.len)
			break
		var/turf/target_turf = pick(neighbors)
		target_turf = get_connecting_turf(target_turf, loc)
		var/obj/effect/neighbor_plant = (locate(/obj/effect/plant) in target_turf.contents)
		if(!neighbor_plant)
			neighbor_plant = (locate(/obj/effect/dead_plant) in target_turf.contents)
		if(neighbor_plant)//Not else, because if there's no dead plant either, it shouldn't run the check at all
			visible_message("[src] takes over [neighbor_plant]!")
			qdel(neighbor_plant)
		var/obj/effect/plant/child = new type(get_turf(src),seed,src)
		after_spread(child, target_turf)
		// Update neighboring squares.
		for(var/obj/effect/plant/neighbor in range(1,target_turf))
			neighbor.neighbors -= target_turf


//after creation act
//by default, there goes an animation code
/obj/effect/plant/proc/after_spread(obj/effect/plant/child, turf/target_turf)
	spawn(1) // This should do a little bit of animation.
		child.forceMove(target_turf)
		child.update_icon()


//Once created, the new vine moves to destination turf
/obj/effect/plant/proc/handle_move(var/turf/origin, var/turf/destination)
	//First of all lets ensure we still exist.
	//We may have been deleted by another vine doing postmove cleanup
	if (QDELETED(src))
		return

	//And lets make sure we haven't already moved
	if (loc != origin)
		return

	//We un-anchor ourselves, so that we're exposed to effects like gravity and teleporting
	anchored = FALSE

	//Now we will attempt a normal movement, obeying all the normal rules
	//This allows us to bump into portals and get teleported
	Move(destination)

	/*Now we check if we went anywhere. We don't care about the return value of move, we do our own check
	In the case of a portal, or falling through an openspace, or moving along stairs, Move may return false
	but we've still gone somewhere. We will only consider it a failure if we're still where we started
	*/
	if (loc == origin)
		//That failed, okay this time we're not asking
		forceMove(destination)
		//forceMove won't work properly with portals, so we only do it as a backup option


	//Ok now we should definitely be somewhere
	if (loc == origin)
		//Welp, we give up.
		//This shouldn't be possible, but if it somehow happens then this vine is toast
		qdel(src)
		return

	//Ok we got somewhere, hooray
	//Now we settle down
	anchored = TRUE

	//And do this
	handle_postmove()

//Now we clean up our arrival tile
/obj/effect/plant/proc/handle_postmove()
	for (var/obj/effect/plant/Bl in loc)
		if (Bl != src)
			qdel(Bl) //Lets make sure we don't get doubleblobs


/obj/effect/plant/proc/die_off()
	// Kill off our plant.
	if(plant)
		plant.die()

	//Nearby plants suffer a bit too, so they won't immediately grow back
	spawn(2)
		if (!QDELETED(src))
			for (var/obj/effect/plant/P in orange(1, src))
				P.health -= (P.max_health * 0.5)
				P.check_health()

	// This turf is clear now, let our buddies know.
	for(var/turf/simulated/check_turf in get_cardinal_neighbors())
		if(!istype(check_turf))
			continue
		for(var/obj/effect/plant/neighbor in check_turf.contents)
			neighbor.neighbors |= check_turf
			plant_controller.add_plant(neighbor)

	spawn(1)
		qdel(src)

#undef MIN_LIGHT_LIMIT
#undef NEIGHBOR_REFRESH_TIME
