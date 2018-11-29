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
	init_order = INIT_ORDER_MAPPING

	wait = 300 //Ticks once per 30 seconds

	var/burrow_scan_interval = 5 MINUTES //Every 5 minutes, they'll scan and catalogue the lifeforms around them
	var/burrow_migrate_interval = 10 MINUTES //Every 10 minutes, some mobs will move from a populated burrow to a different place

	var/next_scan = 0 //We'll do a scan as soon as round starts
	var/next_migrate = 10 MINUTES

	var/migrate_chance = 15 //The chance, during each migration, for each populated burrow, that mobs will move from there to somewhere else

/datum/controller/subsystem/migration/fire()

	//Life scanning
	if (world.time > next_scan)
		do_scan()

	if (world.time > next_migrate)
		do_migrate()


//Tells all the burrows to refresh their population lists
/datum/controller/subsystem/migration/proc/do_scan()
	set waitfor = false
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
		var/obj/structure/burrow/target = choose_burrow_target()

		if (!target)
			//Something must have gone horribly wrong
			//This could only happen if all the burrows on the map were collapsed
			return


		//Alright now we know where to go, next up, how many are we sending?
		var/percentage = migration_percentage()

/*
	Picks a destination for migrating mobs.
	High chance to reroll burrows that are outside of maintenance areas, to minimise incursions into crew space
*/
/datum/controller/subsystem/migration/proc/choose_burrow_target(var/obj/structure/burrow/source, var/reroll_nonmaint_prob = 95)
	var/num_attempts = 100 //A sanity to prevent infinite loops
	var/obj/structure/burrow/candidate

	//Lets copy the list of our choice into a candidates buffer
	var/list/candidates
	if (populated_burrows.len)
			if (prob(50) || !(unpopulated_burrows.len)) //Make sure that we have burrows in both lists
				candidates = populated_burrows.Copy()

	else if (unpopulated_burrows.len)
		candidates = unpopulated_burrows.Copy()

	//No picking the source burrow
	candidates -= source

	for (var/i = 0; i < num_attempts; i++)

		//50% each to pick a populated or unpopulated target
		candidate = pick_n_take(candidates)

		if (!candidate)
			//If we get here both lists must have been empty
			return null

		//And a high chance to reroll it if its not in maint
		//But if this is the last option in the list we take that anyway
		if (!candidate.maintenance && prob(reroll_nonmaint_prob) && candidates.len)
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
	//First of all lets get a list of everything in dview.
	//Dview is just a view call that ignores darkness. We're probably creating it in a dark maintenance tunnel
	var/list/viewlist = dview(10, target)

	var/list/possible_turfs = list()
	//Now lets look at all the floors
	for (var/turf/simulated/floor/F in viewlist)
		//To be valid, the floor needs to have a wall in a cardinal direction
		for (var/d in cardinal)
			var/turf/T = get_step(F, d)
			if (T.is_wall)
				//Its got a wall!
				possible_turfs[F] = T //We put this floor and its wall into the possible turfs list


	//Alrighty, now we have a list of viable floors in view, lets pick one
	var/turf/floor = pick(possible_turfs)

	//And we create a burrow there, passing in the associated wall as its anchor
	var/obj/structure/burrow/B = new /obj/structure/burrow(floor, possible_turfs[floor])