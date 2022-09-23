/*
	The migration subsystem handles burrows and the movement of various NPC mobs aboard Eris.

	It allows mobs to move between burrows, dispatches reinforcements to distress calls from mobs under attack,
	and keeps track of all the burrows, negating any need for them to process individually most of the time
	This subsystem also handles spreading plants through burrows

*/
var/list/global/populated_burrows = list()
var/list/global/unpopulated_burrows = list()
var/list/global/distressed_burrows = list()

SUBSYSTEM_DEF(migration)
	name = "Migration"
	init_order = INIT_ORDER_LATELOAD

	wait = 300 //Ticks once per 30 seconds

	var/burrow_scan_interval = 5 MINUTES //Every 5 minutes, they'll scan and catalogue the lifeforms around them
	var/burrow_plantspread_interval = 10 MINUTES //Every 10 minutes, plants near burrows will spread through them
	var/burrow_migrate_interval = 9 MINUTES //Every 9 minutes, some mobs will move from a populated burrow to a different place


	var/next_scan = 0 //We'll do a scan as soon as round starts
	var/next_migrate = 10 MINUTES
	var/next_plantspread = 10 MINUTES

	var/migrate_chance = 15 //The chance, during each migration, for each populated burrow, that mobs will move from there to somewhere else


	var/roundstart_burrows = 120
	var/migrate_time = 20 SECONDS //How long it takes to move mobs from one burrow to another
	var/reinforcement_time = 20 SECONDS //How long it takes for reinforcements to arrive
	var/plantspread_burrows_num = 3 //How many other burrows will each one with plants send them to



/*************************************************
	Burrow Creation
*************************************************/
/*
	On initialize, the migration system generates a large number of burrows spread across the ship
*/
/datum/controller/subsystem/migration/Initialize()
	. = ..()
	for (var/i = 0; i < roundstart_burrows; i++)
		var/area/A = random_ship_area(FALSE, FALSE, FALSE)
		var/turf/T = A.random_space() //Lets make sure the selected area is valid
		create_burrow(T)



/*
Called by roaches when they spawn.
This proc will attempt to create a burrow against a wall, within view of the target location
*/
/proc/create_burrow(var/turf/target)
	if (!isOnShipLevel(target))
		return

	//First of all lets get a list of everything in dview.
	//Dview is just a view call that ignores darkness. We're probably creating it in a dark maintenance tunnel
	var/list/viewlist = dview(10, target)

	var/list/possible_turfs = list()
	//Now lets look at all the floors
	for (var/turf/simulated/floor/F in viewlist)


		//No being under a low wall
		if (F.is_wall)
			continue

		// SPCR 2022 - added this to prevent them disconnecting pipes and cables , since , through magical means , it is impossible to find the code behind pipes being disconnected
		// on turfs with burrows.
		if(!turf_clear(F))
			continue

		//No stacking multiple burrows per tile
		if (locate(/obj/structure/burrow) in F)
			continue


		//No airlocks
		if (locate(/obj/machinery/door) in F)
			continue

		//No ladders or stairs
		if (locate(/obj/structure/multiz) in F)
			continue

		//No turfs in space
		if (turf_is_external(F))
			continue

		//To be valid, the floor needs to have a wall in a cardinal direction
		for (var/d in cardinal)
			var/turf/T = get_step(F, d)
			if (T.is_wall)
				//Its got a wall!
				possible_turfs[F] = T //We put this floor and its wall into the possible turfs list



	//This can happen, there's at least one room made of catwalks that has no floor, and thusly no burrow spots
	if (!possible_turfs.len)
		return


	//Alrighty, now we have a list of viable floors in view, lets pick one
	var/turf/floor = pick(possible_turfs)
	//And we create a burrow there, passing in the associated wall as its anchor
	var/obj/structure/burrow/B = new /obj/structure/burrow(floor, possible_turfs[floor])
	return B

//Looks for a burrow, and creates one if an existing burrow isnt found
/proc/find_or_create_burrow(var/turf/target)
	if (find_visible_burrow(target))
		return TRUE

	create_burrow(target)
	return FALSE



/datum/controller/subsystem/migration/fire()
	//Life scanning
	if (world.time > next_scan)
		do_scan()

	if (distressed_burrows.len)
		handle_distress_calls()

	if (world.time > next_migrate)
		do_migrate()

	if (world.time > next_plantspread)
		handle_plant_spreading()


//Tells all the burrows to refresh their population lists
/datum/controller/subsystem/migration/proc/do_scan()
	set waitfor = FALSE
	for (var/obj/structure/burrow/B in GLOB.all_burrows)
		B.life_scan()

	next_scan = world.time + burrow_scan_interval


//Some of the populated holes will migrate part or all of their population to a new burrow
/datum/controller/subsystem/migration/proc/do_migrate()
	for (var/obj/structure/burrow/B in populated_burrows)

		//Each populated burrow has a chance to send its population elsewhere
		if (!prob(migrate_chance))
			continue


		//But where? This proc has the answer
		var/obj/structure/burrow/target = choose_burrow_target(B)

		if (!target)
			//Something must have gone horribly wrong
			//This could only happen if all the burrows on the map were collapsed
			return

		if (!B.population.len)
			// There is no mob nearby for the migration
			// Avoid division by 0 in summon_mobs
			continue

		//Alright now we know where to go, next up, how many are we sending?
		var/percentage = migration_percentage()


		//We have all the data we need, lets go!
		B.migrate_to(target, migrate_time, percentage)

	next_migrate = world.time + burrow_migrate_interval



//Sends reinforcements to any burrow that requested backup
/datum/controller/subsystem/migration/proc/handle_distress_calls()
	for (var/obj/structure/burrow/B in distressed_burrows)
		//Each burrow can only be reinforced a certain number of times
		if (B.reinforcements <= 0)
			continue

		var/obj/structure/burrow/source = choose_burrow_source()

		//If we fail to find a source, then we must have run out of populated burrows to draw reinforcements from.
		//Sorry! nobody's coming to help
		if (!source)
			break

		B.reinforcements--

		source.migrate_to(B, reinforcement_time, migration_percentage())

	//Whether they got their reinforcements or not, all distress calls are handled. Clear the list
	distressed_burrows.Cut()









/*
	Picks a destination for migrating mobs.
	High chance to reroll burrows that are outside of maintenance areas, to minimise incursions into crew space
*/
/datum/controller/subsystem/migration/proc/choose_burrow_target(var/obj/structure/burrow/source, var/reroll_type = TRUE, var/reroll_prob = 99.5)
	var/obj/structure/burrow/candidate

	//Lets copy the list into a candidates buffer
	var/list/candidates = GLOB.all_burrows.Copy(1,0)

	//No picking the source burrow
	candidates -= source

	while(candidates.len)


		candidate = pick_n_take(candidates)


		if (!candidate)
			//If we get here both lists must have been empty
			return null

		if (candidate.target || candidate.recieving)
			continue

		// just nop.
		if (candidate.obelisk_around)
			continue

		//And a high chance to reroll it if its not what we want in terms of being in/out of maintenance
		if ((candidate.maintenance != reroll_type) && prob(reroll_prob))
			continue

		// if burrow was closed before it has chance to be ignored
		if (candidate.isSealed && candidate.isRevealed && prob(reroll_prob/3))
			continue

		break

	return candidate


/*
	Picks a source to pull reinforcements from. Used for distress calls
*/
/datum/controller/subsystem/migration/proc/choose_burrow_source()
	var/num_attempts = 100 //A sanity to prevent infinite loops
	var/obj/structure/burrow/candidate

	//Make a copy of populated burrows to work with
	var/list/candidates = populated_burrows.Copy(1,0)


	for (var/i = 0; i < num_attempts; i++)

		if (!candidates || !candidates.len)
			return null

		candidate = pick_n_take(candidates)

		//List must be empty?
		if (!candidate)
			return null

		//Burrow is already busy
		if (candidate.target || candidate.recieving)
			continue

		// Burrow is closed
		if(candidate.isSealed)
			continue

		//Lets not take mobs away from a burrow that's requesting more
		if (candidate in distressed_burrows)
			continue

		//Do a life scan to ensure it's still populated
		candidate.life_scan()

		//And then check the population
		if (!candidate.population.len)
			continue



		return candidate


/datum/controller/subsystem/migration/proc/migration_percentage()
	if (prob(20))
		return 1 //Significant chance to move the entire population of the burrow

	//Otherwise, generate a random number
	return rand()











/*************************************************
	Plant Handling
*************************************************/
/*
	This proc allows plants like maintshrooms to spread through burrows
	Run every 10 minutes
*/
/datum/controller/subsystem/migration/proc/handle_plant_spreading()
	next_plantspread = world.time + burrow_plantspread_interval//Setup the next spread tick

	//We loop through every burrow and see what it needs
	for (var/obj/structure/burrow/B in GLOB.all_burrows)

		//Branch 1: No plants yet
		if (!B.plant)
			//This burrow has no plant registered, lets look for nearby plants
			for (var/obj/effect/plant/P in dview(1, B.loc))

				//Make sure this is a spreading plant, no sending potatoes through a burrow
				if (P.seed.get_trait(TRAIT_SPREAD) >= 2)

					//We have found a plant, good to go!
					B.plant = P.seed //Set the seed
					spread_plants_from(B) //And spread the plants from this burrow to others

		else
			//Branch 2: It has plants
			//Lets check the validity of all its plantspread burrows
			for (var/b in B.plantspread_burrows)
				//This is a list of refs, so resolve it
				var/obj/structure/burrow/C = locate(b)
				if (QDELETED(C))
					//If the specified burrow is no longer there, lets remove it from the list
					B.plantspread_burrows.Remove(b)

			//Now that those are validated, do we still have spread burrows left?
			if (!B.plantspread_burrows.len)
				//If not, then we are suddenly no longer a burrow which has plants.
				//Players must have rekt all the nearby burrows
				B.plant = null

				//There may still be a plant in or near our turf, and if so it will be re-registered next tick
				//For now, we've got to wait 10 minutes til we can spread plants again
				continue


			//Alright, we do still have burrows. Lets check the master plant in our turf, is it alright?
			for (var/obj/effect/plant in B.loc)
				//Yea its still there, we're done
				continue

			//The plant in our turf has gone. Since we're still connected to the plant network, we respawn it
			B.spread_plants()
			//If people cut down all the plants near us, but didn't collapse this burrow, they're in for a bad time
			//Plants are back baby!

/*
	Finds burrows near to the specified one, and sends plants from it to them
*/
/datum/controller/subsystem/migration/proc/spread_plants_from(var/obj/structure/burrow/B)
	var/list/sorted = get_sorted_burrow_network(B)
	/*
	This gives us a list of burrows in ascending order of distance. The order is important, we dont want plants to
	travel too far from the source*/



	var/list/viewlist = find_visible_burrows(B, 10) //Capture a list of nearby burrows
	var/i = 0 //Number of burrows we've sent plants to. We're done when this gets high enough
	//Lets go through this list and find places to send plants to
	while (i < plantspread_burrows_num && sorted.len)
		var/obj/structure/burrow/C = sorted[1] //Grab the first element
		sorted.Cut(1,2)//And remove it from the list


		//It already has plants, no good
		if (C.plant)
			continue

		//We don't want to send to other burrows in the same room as us.
		//The point of burrows is to let things move between rooms
		if (C in viewlist)
			continue

		//Chance to reject it anyways to make plant spreading less predictable
		if (prob(60))
			continue

		//If it has no plants yet, it should be okay to send things to it
		i++ //Increment this
		B.plantspread_burrows.Add("\ref[C]") //Add them to each other's plantspread lists
		C.plantspread_burrows.Add("\ref[B]")
		C.plant = B.plant //Make them share the same seed
		C.spread_plants() //And make some plants at the new burrow

/*************************************************
	Burrow Finding and Sorting
*************************************************/

//Things hidden under floors don't show in some view/range calls
//To work around this, use these procs to locate nearby burrows
/proc/find_nearby_burrow(var/atom/target, var/dist = 10)
	var/turf/t = get_turf(target)
	for (var/turf/T in range(dist, t))
		for (var/obj/structure/burrow/B in T.contents)
			return B

/proc/find_nearby_burrows(var/atom/target, var/dist = 10)
	var/turf/t = get_turf(target)
	var/list/NB = list()
	for (var/turf/T in range(dist, t))
		for (var/obj/structure/burrow/B in T.contents)
			NB.Add(B)
	return NB


/proc/find_visible_burrow(var/atom/target, var/dist = 10)
	var/turf/t = get_turf(target)
	for (var/turf/T in dview(dist, t))
		for (var/obj/structure/burrow/B in T.contents)
			return B

/proc/find_visible_burrows(var/atom/target, var/dist = 10)
	var/turf/t = get_turf(target)
	var/list/NB = list()
	for (var/turf/T in dview(dist, t))
		for (var/obj/structure/burrow/B in T.contents)
			NB.Add(B)

	return NB



//Returns a list of all burrows, sorted in ascending order of distance from the source atom
/proc/get_sorted_burrow_network(var/atom/source)
	var/list/sorted = list() //List of the burrows, in order
	var/list/distances  = list() //Associative list of burrows and distances
	for (var/b in GLOB.all_burrows)
		if (b == source)
			continue //Don't have ourselves in the return list

		var/obj/structure/burrow/B = b

		//How far between the burrows?
		var/dist = dist3D(source, B)
		distances[B] = dist

		//Now lets scroll through the list of sorted burrows and find where to insert it
		var/index = 0
		var/inserted = FALSE
		for (var/a in sorted)
			index++
			//When we find one that is farther away than us, we will insert ourselves before it
			if (dist <= distances[a])
				sorted.Insert(index, B)
				inserted = TRUE
				break

		if (inserted)
			continue

		//If we get here then sorted was empty. just add the first element
		sorted.Add(B)

	return sorted
