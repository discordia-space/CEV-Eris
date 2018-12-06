/*
	A burrow is an entrance to an abstract network of tunnels inside the walls of eris. Animals and creatures of
	all types, but mostly roaches, can travel from one burrow to another, bypassing all obstacles inbetween
*/
/obj/structure/burrow
	name = "burrow"
	desc = "Some sort of hole that leads inside a wall. It's full of hardened resin and secretions. Collapsing this would require some heavy digging tools"
	anchored = TRUE
	density = FALSE
	plane = FLOOR_PLANE
	icon = 'icons/obj/burrows.dmi'
	icon_state = "hole"
	level = 1 //Apparently this is a magic constant for things to appear under floors. Should really be a define
	layer = LOW_OBJ_LAYER

	//Integrity is used when attempting to collapse this hole. It is a multiplier on the time taken and failure rate
	//Any failed attempt to collapse it will reduce the integrity, making future attempts easier
	var/integrity = 100

	//A list of the mobs that are near this hole, and considered to be living here.
	//Since this list is updated infrequently, it stores refs instead of direct pointers, to prevent GC issues
	var/list/population = list()


	//If true, this burrow is located in a maintenance tunnel. Most of them will be
	//Ones located outside of maint are much less likely to be picked for migration
	var/maintenance = FALSE


	//Vars for migration
	var/processing = FALSE
	var/obj/structure/burrow/target //Burrow we're currently sending mobs to
	var/obj/structure/burrow/recieving	//Burrow currently sending mobs to us

	var/list/sending_mobs = list()
	var/migration_initiated //When a migration started
	var/completion_time //Time that the mobs will actually arrive at the target
	var/duration

	//Animation
	var/max_shake_intensity = 20

/obj/structure/burrow/New(var/loc, var/turf/anchor)
	.=..()
	all_burrows.Add(src)
	world << "Burrow created at [jumplink(loc)] using anchor [jumplink(anchor)]"
	if (anchor)
		offset_to(anchor, 8)

	life_scan()

	//Hide burrows under floors
	var/turf/simulated/floor/F = loc
	if (istype(F))
		F.levelupdate()



//This is called from the migration subsystem. It scans for nearby creatures
//Any kind of simple or superior animal is valid, all of them are treated as population for this burrow
/obj/structure/burrow/proc/life_scan()
	population.Cut()
	for (var/mob/living/L in dview(14, loc))
		//world << "Burrow found [L], checking validity"
		if (is_valid(L))
			population |= "\ref[L]"

	if (population.len)
		populated_burrows |= src
		unpopulated_burrows -= src
	else
		populated_burrows -= src
		unpopulated_burrows |= src


/*
	Returns true/false to indicate if the passed mob is valid to be considered population for this burrow
*/
/obj/structure/burrow/proc/is_valid(var/mob/living/L)
	if (QDELETED(L))
		return FALSE

	//Dead mobs don't count
	if (L.stat == DEAD)
		return FALSE

	//We don't want player controlled mobs getting sucked up by holes
	if (L.client)
		return FALSE


	//Creatures only. No humans or robots
	if (!isanimal(L) && !issuperioranimal(L))
		return FALSE

	return TRUE





/*
	Migration based procs
*/


//Starts the process of sending mobs from one burrow to another
/obj/structure/burrow/proc/migrate_to(var/obj/structure/burrow/_target, var/time = 0, var/percentage = 1)
	if (!_target)
		return

	//We're already busy sending or recieving a migration, can't start another
	if (target || recieving)
		return

	target = _target

	if (!processing)
		START_PROCESSING(SSobj, src)

	world << "About to start migration from [jumplink(src)] to [jumplink(target)]"

	//The time we started. Used for animations
	migration_initiated = world.time

	duration = time

	//When the completion time is reached, the mobs we're sending will emerge from the destination hole
	completion_time = migration_initiated + duration

	summon_mobs(percentage)

	target.prepare_reception(migration_initiated, duration, src)


//Summons some or all of the nearby population to this hole, where they will enter it and travel
/obj/structure/burrow/proc/summon_mobs(var/percentage = 1)
	var/list/candidates = population.Copy() //Make a copy of the population list so we can modify it
	var/step = 1 / candidates.len //What percentage of the population is each mob worth?
	sending_mobs = list()
	for (var/v in candidates)
		var/mob/living/L = locate(v) //Resolve the hex reference into a mob

		//Check that it's still valid. Hasn't been deleted, etc
		if (!is_valid(L))
			continue


		//Alright now how do we make this mob come to us?
		if (issuperioranimal(L))
			//If its a superior animal, then we'll set their mob target to this burrow
			var/mob/living/carbon/superior_animal/SA = L
			SA.target_mob = src //Tell them to target this burrow
			SA.stance = HOSTILE_STANCE_ATTACK //This should make them walk over and attack it

		sending_mobs += L

		//We deplete this percentage for every mob we send
		percentage -= step
		if (percentage <= 0)
			//If it hits zero we're done summoning
			break




//Tells this burrow that it's soon to recieve new arrivals
/obj/structure/burrow/proc/prepare_reception(var/start_time, var/_duration, var/sender)
	migration_initiated = start_time
	duration = _duration
	recieving = sender
	START_PROCESSING(SSobj, src)





/obj/structure/burrow/Process()
	//Burrows process when they are either sending or recieving mobs.
	//One or the other, cant do both at once
	var/progress = (world.time - migration_initiated) / duration

	//Sending processing is done to suck in candidates when they come near
	//As well as to check how much time has passed, and when completion time happens, to deliver mobs to the destination
	if (target)

		//Lets loop through the mobs we're sending, and bring them in if possible
		for (var/mob/living/L in sending_mobs)
			if (!is_valid(L))
				//Uh oh. Maybe it died
				sending_mobs -= L
				continue

			if (!istype(L.loc, /turf))
				//Its already inside, this burrow or another one
				if (L.loc != src)
					//If it went inside another burrow its no longer our problem
					sending_mobs -= L
				continue



			//Succ
			pull_mob(L)

			//If its near enough, swallow it
			if (get_dist(L, src) <= 1)
				enter_burrow(L)

			else if (progress > 0.5)
				//If the mob has spent more than half the time, it must be unable to reach.
				//Increase the suck range
				if (get_dist(L, src) <= 2)
					enter_burrow(L)



		if (progress >= 1)
			//We're done, its time to send them
			complete_migration()

	//Processing on the recieving end is done to make sounds and visual FX
	else if (recieving)
		//Do a shake animation each second that gets more intense the closer we are to emergence

		if (invisibility)
			var/turf/simulated/floor/F = loc
			if (istype(F) && F.flooring)
				//This should never be false

				//If the current flooring is a plating, we shake that
				if (!F.flooring.is_plating)
					F.shake_animation(progress * max_shake_intensity)
					return
		shake_animation(progress * max_shake_intensity)








/obj/structure/burrow/proc/complete_migration()
	//The final step in the process
	//This finishes up the process of sending mobs
	if (target)
		if (QDELETED(target))
			abort_migration()
			return

		//We'll put all of our mobs into the target burrow
		for (var/mob/M in contents)
			M.forceMove(target)

		target.complete_migration()


	if (recieving)
		//If we're the burrow recieving the migration, then the above code will have put lots of mobs inside us. Lets move them out into surrounding turfs
		//First, make sure we clear the destination area
		break_open()
		world << "About to disgorge mobs [jumplink(src)]"

		//Next get a list of floors to move them to
		var/list/floors = list()
		for (var/turf/simulated/floor/F in dview(2, loc))
			floors.Add(F)

		world << "Got [floors.len] floors"
		if (floors.len > 0)

			//We'll move all the mobs briefly onto our own turf, then shortly after, onto a surrounding one
			for (var/mob/M in contents)
				M.forceMove(loc)
				spawn(rand(1,5))
					var/turf/T = pick(floors)
					M.forceMove(T)

					//Emerging from a burrow will sometimes create rubble and mess
					spawn_rubble(loc, 2, 30)


	//Lets reset all these vars that we used during migration
	STOP_PROCESSING(SSobj, src)
	processing = FALSE
	target = null
	recieving = null

	sending_mobs = list()
	migration_initiated = 0
	completion_time = 0
	duration = 0



//Very rare, abort would mostly only happen in the case that one burrow is destroyed during the process
/obj/structure/burrow/proc/abort_migration()
	STOP_PROCESSING(SSobj, src)
	processing = FALSE
	target = null
	recieving = null

	sending_mobs = list()
	migration_initiated = 0
	completion_time = 0
	duration = 0

	for (var/mob/M in contents)
		M.forceMove(loc)



//Called when an area becomes uninhabitable
/obj/structure/burrow/proc/evacuate(var/force_nonmaint = TRUE)
	world << "Burrow [jumplink(src)] calling evacuate"
	//We're already busy sending or recieving a migration, can't start another
	if (target || recieving)
		return

	//Lets check there's anyone to evacuate
	life_scan()
	if (population.len)
		var/obj/structure/burrow/btarget = SSmigration.choose_burrow_target(src, FALSE, 100)
		if (!btarget)
			//If no target then maybe there are no nonmaint burrows left. In that case lets try to get one in maint
			btarget = SSmigration.choose_burrow_target(src)

			//If still no target, then every other burrow on the map is collapsed. Evacuation failed
			if (!btarget)
				return


		migrate_to(btarget, 5 SECONDS, 1)

/***********************************
	Breaking and rubble
***********************************/


//Called when things enter or leave this burrow
//This proc destroys anything that blocks the entrance, ie floors and catwalks
/obj/structure/burrow/proc/break_open()
	var/turf/simulated/floor/F = loc
	if (istype(F) && F.flooring)
		//This should never be false

		//If the current flooring isnt a plating, then it must be an overfloor, tiles, soil, whatever
		if (!F.flooring.is_plating)
			F.ex_act(3)//Destroy the flooring
			spawn_rubble(loc, 1, 100)//And make some rubble

		//Smash any catwalks blocking us
		for (var/obj/structure/catwalk/C in loc)
			C.ex_act(1)
			spawn_rubble(loc, 1, 100)//And make some rubble


//If underfloor, hide the burrow
/obj/structure/burrow/hide(var/i)
	invisibility = i ? 101 : 0

/obj/structure/burrow/hides_under_flooring()
	return TRUE




/*****************************************************
	Collapsing burrows. Slow and hard work, but failure will make the next attempt easier,
	so you'll get it eventually.
	Uses digging quality, and the total of user's robust+mechanical stats

	Breaking a hole with a crowbar is theoretically possible, but extremely slow and difficult. You are strongly
	advised to use proper mining tools. A pickaxe or a drill will do the job in a reasonable time
*****************************************************/
/obj/structure/burrow/attackby(obj/item/I, mob/user)
	if (I.has_quality(QUALITY_DIGGING))
		user.visible_message("[user] starts breaking and collapsing [src] with the [I]", "You start breaking and collapsing [src] with the [I]")

		//We record the time to prevent exploits of starting and quickly cancelling
		var/start = world.time
		var/target_time = WORKTIME_FAST+ 2*integrity

		if (I.use_tool(user, src, target_time, QUALITY_DIGGING, 1.5*integrity, list(STAT_SUM, STAT_MEC, STAT_ROB), forced_sound = WORKSOUND_PICKAXE))
			//On success, the hole is destroyed!
			user.visible_message("[user] collapses [src] with the [I]", "You collapse [src] with the [I]")

			collapse()
		else

			spawn_rubble(loc, 2, 100)
			user << SPAN_WARNING("The [src] crumbles a bit. Keep trying!")
			//On failure, the hole takes some damage based on the digging quality of the tool.
			//This will make things much easier next time
			var/duration = world.time - start
			var/time_mult = 1

			if (duration < target_time)
				//If they spent less than the full time attempting the work, then the reduction is reduced
				//A multiplier is based on 85% of the time spent working,
				time_mult = (duration / target_time) * 0.85
			integrity -= (I.get_tool_quality(QUALITY_DIGGING)*time_mult)

		return


	.=..()

//Collapses the burrow, deleting it
/obj/structure/burrow/proc/collapse()
	spawn_rubble(loc, 0, 100)
	qdel(src)

//Spawns some rubble on or near a target turf
//Will only allow one rubble decal per tile
/obj/structure/burrow/proc/spawn_rubble(var/turf/T, var/spread = 0, var/chance = 100)
	if (!prob(chance))
		return

	var/list/floors = list()
	for (var/turf/simulated/floor/F in trange(spread, T))
		if (F.is_wall)
			continue
		if (locate(/obj/effect/decal/cleanable/rubble) in F)
			continue

		floors |= F

	if (!floors.len)
		return

	new /obj/effect/decal/cleanable/rubble(pick(floors))



/****************************
	Burrow entering
****************************/
/obj/structure/burrow/proc/enter_burrow(var/mob/living/L)
	break_open()
	spawn()
		L.do_pickup_animation(src, L.loc)
		sleep(8)
		L.forceMove(src)

//Mobs that are summoned will walk up and attack this burrow
//This will suck them in
/obj/structure/burrow/attack_generic(var/mob/L)
	if (is_valid(L))
		enter_burrow(L)


/obj/structure/burrow/proc/pull_mob(var/mob/living/L)
	if (!L.incapacitated())//Can't flee if you're stunned
		walk_to(L, src, 1, L.move_to_delay*rand_between(1,1.5))
//We randomise the move delay a bit so that mobs don't just move in sync like particles of dust being sucked up