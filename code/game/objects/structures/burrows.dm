/*
	A burrow is an entrance to an abstract network of tunnels inside the walls of eris. Animals and creatures of
	all types, but mostly roaches, can travel from one burrow to another, bypassing all obstacles inbetween
*/
/obj/structure/burrow
	name = "cracks"
	desc = "Cracks on the tile."
	anchored = TRUE
	density = FALSE
	plane = FLOOR_PLANE
	icon = 'icons/obj/burrows.dmi'
	icon_state = "cracks"
	level = BELOW_PLATING_LEVEL
	layer = ABOVE_NORMAL_TURF_LAYER


	var/isSealed = TRUE	// borrow spawns as cracks and becomes a hole when critters emerge

	var/isRevealed = FALSE // when burrow is revealed it prevents interactions with turf and is not hiden anymore

	//A list of the mobs that are near this hole, and considered to be living here.
	//Since this list is updated infrequently, it stores refs instead of direct pointers, to prevent GC issues
	var/list/population = list()


	//If true, this burrow is located in a maintenance tunnel. Most of them will be
	//Ones located outside of maint are much less likely to be picked for migration
	var/maintenance = FALSE

	//If true, this burrow is located near NT obelisk.
	//those are much less likely to be picked for migration due cool NT magic
	var/obelisk_around = null


	//Vars for migration
	var/processing = FALSE
	var/obj/structure/burrow/target //Burrow we're currently sending mobs to
	var/obj/structure/burrow/recieving	//Burrow currently sending mobs to us

	var/list/sending_mobs = list()
	var/migration_initiated //When a migration started
	var/completion_time //Time that the mobs will actually arrive at the target
	var/duration

	var/datum/seed/plant = null //Seed datum of the plant that spreads from here, if any
	var/list/plantspread_burrows = list()
	/*A list of burrow references. Either ones that we sent plants to,or one that sent plants to us.
	As long as any burrow in this list still exists, our plants will keep regrowing,
	and we cannot send plants to any other burrow.
	If every burrow in this list is destroyed, we will send our plants somewhere new, if we still have them
	*/

	//Animation
	var/max_shake_intensity = 20

	var/reinforcements = 2 //Maximum number of times this burrow may recieve reinforcements

	var/deepmaint_entry_point = FALSE //Will this burrow turn into a deep maint entry point upon getting collapsed?


/obj/structure/burrow/New(var/loc, turf/anchor)
	.=..()
	GLOB.all_burrows.Add(src)
	var/obj/machinery/power/nt_obelisk/obelisk = locate(/obj/machinery/power/nt_obelisk) in range(7, src)
	if(obelisk && obelisk.active)
		qdel(src)
		return
	if (anchor)
		offset_to(anchor, 8)

	//Hide burrows under floors
	var/turf/simulated/floor/F = loc
	if (istype(F))
		F.levelupdate()

	life_scan()

	// apparently burrows should face walls
	for (var/d in cardinal)
		var/turf/T = get_step(F, d)
		if (T.is_wall)
			dir = d
			break

	var/area/A = get_area(src)
	if (A && A.is_maintenance)
		maintenance = TRUE
		break_open(TRUE)

	if(prob(7))
		deepmaint_entry_point = TRUE


//Lets remove ourselves from the global list and cleanup any held references
/obj/structure/burrow/Destroy()
	GLOB.all_burrows.Remove(src)
	populated_burrows -= src
	unpopulated_burrows -= src
	distressed_burrows -= src
	target = null
	recieving = null
	//Eject any mobs that tunnelled through us
	for (var/atom/movable/a in sending_mobs)
		if (a.loc == src)
			a.forceMove(loc)
	population = list()
	plantspread_burrows = list()	// Other burrows may still hold a reference to this burrow after it qdels
	plant = null
	return ..()

//This is called from the migration subsystem. It scans for nearby creatures
//Any kind of simple or superior animal is valid, all of them are treated as population for this burrow
/obj/structure/burrow/proc/life_scan()
	population.Cut()
	for (var/mob/living/L in dview(14, loc))
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
/obj/structure/burrow/proc/is_valid(mob/living/L)
	if(QDELETED(L) || !istype(L))
		return FALSE

	//Dead mobs don't count
	if (L.stat == DEAD)
		return FALSE

	//We don't want player controlled mobs getting sucked up by holes
	if (L.client)
		return FALSE

	//Type must be designated eligible for burrowing
	if (!L.can_burrow)
		return FALSE

	//Creatures only. No humans or robots
	if (!isanimal(L) && !issuperioranimal(L))
		return FALSE

	//Kaisers are too fat, they can't fit in
	if(istype(L, /mob/living/carbon/superior_animal/roach/kaiser))
		return FALSE

	return TRUE





/*
	Migration based procs
*/


/*
Starts the process of sending mobs from one burrow to another
_target is the burrow we will send our mobs to,
time, is how long, in deciseconds, we will wait before putting them into the target.
	During this time, we will suck up nearby mobs into this burrow, and at the end of the time only those inside
	the burrow are sent
percentage is a value in the range 0..1 that determines what portion of this mob's population to send.
	It is possible for percentage to be zero, this is used by the infestation event.
	Passing a percentage of zero is a special case, this burrow will not suck up any mobs.
	The mobs it is to send should be placed inside it by the caller
*/
/obj/structure/burrow/proc/migrate_to(obj/structure/burrow/_target, time = 1, percentage = 1)
	if (!_target)
		return

	//We're already busy sending or recieving a migration, can't start another
	if (target || recieving)
		return

	target = _target

	if (!processing)
		START_PROCESSING(SSobj, src)
		processing = TRUE


	//The time we started. Used for animations
	migration_initiated = world.time

	duration = time

	//When the completion time is reached, the mobs we're sending will emerge from the destination hole
	completion_time = migration_initiated + duration


	if (percentage != 0)
		summon_mobs(percentage)
	else
		//Special case, mobs have already spawned inside us by infestation event or somesuch
		//add all the mobs in our contents to the sending mobs list
		sending_mobs = list()
		for (var/mob/M in contents)
			sending_mobs.Add(M)

	target.prepare_reception(migration_initiated, duration, src)


//Summons some or all of the nearby population to this hole, where they will enter it and travel
/obj/structure/burrow/proc/summon_mobs(percentage = 1)
	var/list/candidates = population.Copy() //Make a copy of the population list so we can modify it
	var/step = 1 / candidates.len //What percentage of the population is each mob worth?
	sending_mobs = list()
	for (var/v in candidates)
		var/mob/living/L = locate(v) //Resolve the hex reference into a mob

		//Check that it's still valid. Hasn't been deleted, etc
		if(!is_valid(L))
			continue


		//Alright now how do we make this mob come to us?
		if (issuperioranimal(L))
			//If its a superior animal, then we'll set their mob target to this burrow
			var/mob/living/carbon/superior_animal/SA = L
			SA.activate_ai()
			SA.target_mob = src //Tell them to target this burrow
			SA.stance = HOSTILE_STANCE_ATTACK //This should make them walk over and attack it

		sending_mobs += L

		//We deplete this percentage for every mob we send
		percentage -= step
		if (percentage <= 0)
			//If it hits zero we're done summoning
			break




//Tells this burrow that it's soon to recieve new arrivals
/obj/structure/burrow/proc/prepare_reception(start_time, _duration, sender)
	migration_initiated = start_time
	duration = _duration
	recieving = sender
	START_PROCESSING(SSobj, src)
	processing = TRUE



/obj/structure/burrow/Process()
	// Currently, STOP_PROCESSING does NOT instantly remove the object from processing queue
	// This is a quick and dirty fix for runtime error spam caused by this
	if(!processing)
		return

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
				return //One mob enters per second

			else if (progress > 0.5)
				//If the mob has spent more than half the time, it must be unable to reach.
				//Increase the suck range
				if (get_dist(L, src) <= 2)
					enter_burrow(L)
					return //One mob enters per second


		if (progress >= 1)
			//We're done, its time to send them
			complete_migration()

	//Processing on the recieving end is done to make sounds and visual FX
	else if (recieving)
		//Do audio, but not every second
		if (prob(45))
			audio("crumble", progress*100)

		//Do a shake animation each second that gets more intense the closer we are to emergence
		// We shake florring only if burrow is still a cracks
		if (!isRevealed)
			var/turf/simulated/floor/F = loc
			if (istype(F) && F.flooring)
				//This should never be false
				if (prob(25)) //Occasional impact sound of something trying to force its way through
					audio("thud", progress*100)
				F.shake_animation(progress * max_shake_intensity)
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

		audio("crumble", 120) //And a loud sound as mobs emerge
		//Next get a list of floors to move them to
		var/list/floors = list()
		for (var/turf/simulated/floor/F in dview(2, loc))
			if (F.is_wall)
				continue

			if (turf_is_external(F))
				continue

			if (!turf_clear(F))
				continue

			floors.Add(F)

		if (floors.len > 0)

			//We'll move all the mobs briefly onto our own turf, then shortly after, onto a surrounding one
			for (var/mob/M in contents)
				M.forceMove(loc)
				spawn(rand(1,5))
					var/turf/T = pick(floors)
					M.forceMove(T)

					//Emerging from a burrow will create rubble and mess
					if(spawn_rubble(loc, 2, 80))
						spawn_rubble(loc, 3, 30)


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
/obj/structure/burrow/proc/evacuate(force_nonmaint = TRUE)
	//We're already busy sending or recieving a migration, can't start another or closed
	if (target || recieving || isSealed)
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


		migrate_to(btarget, 10 SECONDS, 1)


/obj/structure/burrow/proc/distress(immediate = FALSE)
	//This burrow requests reinforcements from elsewhere
	if (reinforcements <= 0)
		return

	distressed_burrows |= src //Add ourselves to a global list.
	//The migration subsystem will look at it and send things.
	//It may take up to 30 seconds to tick and notice our request

	if (immediate)
		//Alternatively, we can demand things be sent right now
		spawn()
			SSmigration.handle_distress_calls()

/***********************************
	Breaking and rubble
***********************************/


//Called when things enter or leave this burrow
/obj/structure/burrow/proc/break_open(silent = FALSE)
	if(isSealed)
		reveal()
		isSealed = FALSE
		invisibility = 0
		icon_state = "hole"
		name = "burrow"
		desc = "Some sort of hole that leads inside a wall. It's full of hardened resin and secretions. Collapsing this would require some heavy digging tools"
		var/turf/simulated/floor/F = loc
		if (istype(F) && F.flooring)
			//This should never be false
			//Play a sound
			if(!silent)
				audio('sound/effects/impacts/thud_break.ogg', 100)
			spawn_rubble(loc, 1, 100)//And make some rubble

/obj/structure/burrow/proc/reveal()
	if(!isRevealed)
		isRevealed = TRUE
		level = ABOVE_PLATING_LEVEL
	var/turf/simulated/floor/F = loc
	if (istype(F))
		F.levelupdate()

/*****************************************************
	Collapsing burrows. Slow and hard work, but failure will make the next attempt easier,
	so you'll get it eventually.
	Uses digging quality, and user's robust or mechanical stats

	While burrow is still emerging (cracks) player can attempt to weld it
	Hole can be closed easely with metal sheets

	Breaking a hole with a crowbar is theoretically possible, but extremely slow and difficult. You are strongly
	advised to use proper mining tools. A pickaxe or a drill will do the job in a reasonable time
*****************************************************/
/obj/structure/burrow/attackby(obj/item/I, mob/user)
	if(!isRevealed)
		return
	if(isSealed)
		if (I.has_quality(QUALITY_WELDING))
			user.visible_message("[user] attempts to weld [src] with the [I]", "You start welding [src] with the [I]")
			if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC) && isSealed)
				user.visible_message("[user] welds [src] with the [I].", "You welds [src] with the [I].")
				if(recieving)
					if(prob(33))
						qdel(src)
					else	// false welding, critters will create new cracks
						invisibility = 101
						spawn(rand(3,10) SECONDS)
							if(isSealed)
								audio('sound/effects/impacts/thud_break.ogg', 100)
								spawn_rubble(loc, 1, 100)//And make some rubble
								invisibility = 0
				else
					qdel(src)
	else
		if(istype(I, /obj/item/stack/material) && I.get_material_name() == MATERIAL_STEEL)
			var/obj/item/stack/G = I

			user.visible_message("[user] starts covering [src] with the [I]", "You start covering [src] with the [I]")
			if(do_after(user, 20, src))
				if (G.use(1))
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					collapse(clean = TRUE)
					return


		if (I.has_quality(QUALITY_DIGGING) && !isSealed)
			user.visible_message("[user] starts breaking and collapsing [src] with the [I]", "You start breaking and collapsing [src] with the [I]")

			//Attempting to collapse a burrow may trigger reinforcements.
			//Not immediate so they will take some time to arrive.
			//Enough time to finish one attempt at breaking the burrow.
			//If you succeed, then the reinforcements won't come
			if (prob(5))
				distress()

			//We record the time to prevent exploits of starting and quickly cancelling
			var/start = world.time
			var/target_time = WORKTIME_FAST+ 2*health

			if (I.use_tool(user, src, target_time, QUALITY_DIGGING, health * 0.66, list(STAT_MEC, STAT_ROB), forced_sound = WORKSOUND_PICKAXE))
				//On success, the hole is destroyed!
				new /obj/spawner/scrap/sparse(get_turf(user))
				user.visible_message("[user] collapses [src] with the [I] and dumps trash which was in the way.", "You collapse [src] with the [I] and dump trash which was in the way.")

				collapse()
			else
				var/duration = world.time - start
				if (duration < 10) //Digging less than a second does nothing
					return

				spawn_rubble(loc, 1, 100)

				if (I.get_tool_quality(QUALITY_DIGGING) > 30)
					to_chat(user, SPAN_NOTICE("The [src] crumbles a bit. Keep trying and you'll collapse it eventually"))
				else
					to_chat(user, SPAN_NOTICE("This isn't working very well. Perhaps you should get a better digging tool?"))

				//On failure, the hole takes some damage based on the digging quality of the tool.
				//This will make things much easier next time
				var/time_mult = 1

				if (duration < target_time)
					//If they spent less than the full time attempting the work, then the reduction is reduced
					//A multiplier is based on 85% of the time spent working,
					time_mult = (duration / target_time) * 0.85
				health -= (I.get_tool_quality(QUALITY_DIGGING)*time_mult)

			return


	. = ..()

//Collapses the burrow, making cracks instead
/obj/structure/burrow/proc/collapse(var/clean = FALSE)
	if(!clean)
		spawn_rubble(loc, 0, 100)
	if(deepmaint_entry_point)
		if(free_deepmaint_ladders.len > 0)
			var/obj/structure/multiz/ladder/up/my_ladder = pick(free_deepmaint_ladders)
			free_deepmaint_ladders -= my_ladder
			var/obj/structure/multiz/ladder/burrow_hole/my_hole = new /obj/structure/multiz/ladder/burrow_hole(loc)
			my_hole.target = my_ladder
			my_ladder.targeted_by = my_hole
			my_ladder.target = my_hole
			qdel(src)
			return
	isSealed = TRUE
	icon_state = initial(icon_state)
	name = initial(name)
	desc = initial(desc)


//Spawns some rubble on or near a target turf
//Will only allow one rubble decal per tile
/obj/structure/burrow/proc/spawn_rubble(var/turf/T, var/spread = 0, var/chance = 100)
	if (!prob(chance))
		return FALSE

	var/list/floors = list()
	for (var/turf/simulated/floor/F in dview(spread, T))
		if (F.is_wall)
			continue
		if (locate(/obj/effect/decal/cleanable/rubble) in F)
			continue

		floors |= F

	if (!floors.len)
		return FALSE

	new /obj/effect/decal/cleanable/rubble(pick(floors))
	return TRUE


//If underfloor, hide the burrow
/obj/structure/burrow/hide(var/i)
	invisibility = i ? INVISIBILITY_MAXIMUM : 0

/obj/structure/burrow/hides_under_flooring()
	if(!isRevealed)
		return TRUE
	return FALSE

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
/obj/structure/burrow/attack_generic(mob/living/L)
	if (is_valid(L))
		enter_burrow(L)
	if (issuperioranimal(L))//So they don't carry burrow's reference and never qdel
		var/mob/living/carbon/superior_animal/SA = L
		SA.target_mob = null


/obj/structure/burrow/proc/pull_mob(mob/living/L)
	if (!L.incapacitated())//Can't flee if you're stunned
		walk_to(L, src, 1, L.move_to_delay*RAND_DECIMAL(1,1.5))
//We randomise the move delay a bit so that mobs don't just move in sync like particles of dust being sucked up



/****************************
	Plant Management
****************************/

//This proc handles creation of a plant on this burrow
//It relies on the plant seed already being set
/obj/structure/burrow/proc/spread_plants()
	reveal()
	if(istype(plant, /datum/seed/wires))		//hivemind wireweeds handling
		if(locate(/obj/effect/plant) in loc)
			return

		if(!hive_mind_ai || !hive_mind_ai.hives.len || maintenance || !GLOB.hive_data_bool["spread_trough_burrows"])
			return

		var/area/A = get_area(src)
		if(!(A.name in GLOB.hivemind_areas))
			if(!GLOB.hive_data_float["maximum_controlled_areas"] || GLOB.hivemind_areas.len < GLOB.hive_data_float["maximum_controlled_areas"])
				GLOB.hivemind_areas.Add(A.name)
			else
				return

		break_open()
		var/obj/machinery/hivemind_machine/node/hivemind_node = pick(hive_mind_ai.hives)
		var/obj/effect/plant/hivemind/wire = new(loc, plant)
		hivemind_node.add_wireweed(wire)

	for (var/obj/effect/plant in loc)
		return

	//The plant is not assigned a parent, so it will become the parent of plants that grow from here
	//If it were assigned a parent from a previous burrow, it'd never spread at all due to distance
	new /obj/effect/plant(get_turf(src), plant)



/****************************
	Audio Management
****************************/
/obj/structure/burrow/proc/audio(var/soundtype, var/volume)
	//All audio generated by burrows is run through this function
	//If this burrow is located in maintenance, players care about it less, and as a result the sounds it makes
	//will be quieter and not travel as far
	playsound(src, soundtype, maintenance ? volume*0.5 : volume, TRUE,maintenance ? -3 : 0)

/obj/structure/burrow/examine()
	..()
	if(isSealed && recieving)
		to_chat(usr, SPAN_WARNING("You can see something move behind the cracks. You should weld them shut before it breaks through."))


/obj/structure/burrow/explosion_act(target_power, explosion_handler/handler)
	. = ..()
	if(QDELETED(src))
		return 0
	collapse()
	return 0

/obj/structure/burrow/preventsTurfInteractions()
	if(isRevealed)
		return TRUE
