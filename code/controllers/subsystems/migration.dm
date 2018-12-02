/*
	The migration subsystem handles burrows and the movement of various NPC mobs aboard Eris.

	It allows mobs to move between burrows, dispatches reinforcements to distress calls from mobs under attack,
	and keeps track of all the burrows, negating any need for them to process individually

*/
var/list/global/all_burrows = list()
var/list/global/populated_burrows = list()
var/list/global/unpopulated_burrows = list()

SUBSYSTEM_DEF(migration)
	name = "Migration"
	init_order = INIT_ORDER_LATELOAD

	wait = 300 //Ticks once per 30 seconds

	var/burrow_scan_interval = 5 MINUTES //Every 5 minutes, they'll scan and catalogue the lifeforms around them
	var/burrow_migrate_interval = 10 MINUTES //Every 10 minutes, some mobs will move from a populated burrow to a different place

	var/next_scan = 0 //We'll do a scan as soon as round starts
	var/next_migrate = 1 MINUTES

	var/migrate_chance = 15 //The chance, during each migration, for each populated burrow, that mobs will move from there to somewhere else


	var/roundstart_burrows = 140

/*
	On initialize, the migration system generates a large number of burrows spread across the ship[
*/
/datum/controller/subsystem/migration/Initialize()
	. = ..()
	for (var/i = 0; i < roundstart_burrows; i++)
		var/area/A = random_ship_area(FALSE, FALSE, FALSE)
		var/turf/T = A.random_space() //Lets make sure the selected area is valid
		create_burrow(T)

	spawn(100)
		world << "MIGRATION INITIALIZED, Burrows: [all_burrows.len], Populated: [populated_burrows.len]"

/datum/controller/subsystem/migration/fire()
	world << "Migration subsystem ticking"
	//Life scanning
	if (world.time > next_scan)
		do_scan()

	if (world.time > next_migrate)
		do_migrate()




//Tells all the burrows to refresh their population lists
/datum/controller/subsystem/migration/proc/do_scan()
	set waitfor = FALSE
	for (var/obj/structure/burrow/B in all_burrows)
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


		//Alright now we know where to go, next up, how many are we sending?
		var/percentage = migration_percentage()


		//We have all the data we need, lets go!
		B.migrate_to(target, rand(2000,4000), percentage) //TODO: Lower this time down to 20-40 secs

	next_migrate = world.time + burrow_migrate_interval


/*
	Picks a destination for migrating mobs.
	High chance to reroll burrows that are outside of maintenance areas, to minimise incursions into crew space
*/
/datum/controller/subsystem/migration/proc/choose_burrow_target(var/obj/structure/burrow/source, var/reroll_nonmaint_prob = 95)
	var/num_attempts = 100 //A sanity to prevent infinite loops
	var/obj/structure/burrow/candidate

	//Lets copy the list of our choice into a candidates buffer
	//50% each to pick a populated or unpopulated target
	var/list/candidates = list()
	if (!unpopulated_burrows.len)
		//world << "Candidates taking populated burrows [populated_burrows.len]"
		candidates = populated_burrows.Copy(1,0)

	else if (!populated_burrows.len)
		//world << "Candidates taking unpopulated burrows [unpopulated_burrows.len]"
		candidates = unpopulated_burrows.Copy(1,0)

	else if (prob(50))
		candidates = populated_burrows.Copy(1,0)
	else
		candidates = unpopulated_burrows.Copy(1,0)

	world << "choosetarget Candidates length: [candidates.len]"
	//No picking the source burrow
	candidates -= source

	for (var/i = 0; i < num_attempts; i++)


		candidate = pick_n_take(candidates)

		if (!candidate)
			//If we get here both lists must have been empty
			return null

		//If that was the last candidate, we're taking it
		if (candidates.len <= 0)
			break

		//And a high chance to reroll it if its not in maint
		if (!candidate.maintenance && prob(reroll_nonmaint_prob))
			continue

	return candidate




/datum/controller/subsystem/migration/proc/migration_percentage()
	if (prob(25))
		return 1 //Significant chance to move the entire population of the burrow

	//Otherwise, generate a random number
	return rand()



/*
Called by roaches when they spawn.
This proc will attempt to create a burrow against a wall, within view of the target location
*/
/proc/create_burrow(var/turf/target)
	if (!isOnShipLevel(target))
		return

	world << "Attempting to create burrow at [jumplink(target)]"
	//First of all lets get a list of everything in dview.
	//Dview is just a view call that ignores darkness. We're probably creating it in a dark maintenance tunnel
	var/list/viewlist = dview(10, target)

	var/list/possible_turfs = list()
	//Now lets look at all the floors
	for (var/turf/simulated/floor/F in viewlist)
		//To be valid, the floor needs to have a wall in a cardinal direction

		//No turfs in space
		if (turf_is_external(F))
			continue

		//No being under a low wall
		if (F.is_wall)
			continue

		//No airlocks
		if (locate(/obj/machinery/door) in F)
			continue

		//No ladders or stairs
		if (locate(/obj/structure/multiz) in F)
			continue


		for (var/d in cardinal)
			var/turf/T = get_step(F, d)
			if (T.is_wall)
				//Its got a wall!
				possible_turfs[F] = T //We put this floor and its wall into the possible turfs list


	//Alrighty, now we have a list of viable floors in view, lets pick one
	var/turf/floor = pick(possible_turfs)
	world << "Successfully created at [jumplink(floor)]"
	//And we create a burrow there, passing in the associated wall as its anchor
	var/obj/structure/burrow/B = new /obj/structure/burrow(floor, possible_turfs[floor])
	return B

//Looks for a burrow, and creates one if an existing burrow isnt found
/proc/find_or_create_burrow(var/turf/target)
	for (var/obj/structure/burrow/B in dview(10, target))
		return TRUE

	create_burrow(target)
	return FALSE