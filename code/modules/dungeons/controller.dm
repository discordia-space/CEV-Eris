//////////////////////////////
// Tracks mining zone progress and decay
// Makes mining zones more difficult as you enter new ones
// THIS IS THE FIRST UNIT INITIALIZED THAT STARTS EVERYTHING
//////////////////////////////
var/datum/controller/rogue/rm_controller = new()

/datum/controller/rogue
	var/list/datum/rogue/zonemaster/all_zones = list()
	var/list/datum/rogue/zonemaster/clean_zones = list()
	var/list/datum/rogue/zonemaster/ready_zones = list()

	//So I don't have to do absurd list[list[thing]] over and over.
	var/list/diffstep_nums = list(
		100,
		200,
		300,
		450,
		600,
		800)

	var/list/diffstep_strs = list(
		"Low",
		"Moderate",
		"High",
		"Very High",
		"Extreme",
		"ERROR!!@MEM:CH@05R31GN5")

	//The ever-changing difficulty
	var/difficulty = 100

	//Info about our current step
	var/diffstep = 1

	//The current mining zone that the shuttle goes to and whatnot
	var/datum/rogue/zonemaster/current_zone = null
	var/datum/rogue/zonemaster/previous_zone = null

	// The world.time at which the scanner was last run (for cooldown)
	var/last_scan = 0
	var/scan_wait = 10 //In minutes

	var/debugging = 0

	///// Prefab Asteroids /////
	var/prefabs = list(
		"tier1" = list(/datum/rogue/asteroid/predef/cargo),
		"tier2" = list(/datum/rogue/asteroid/predef/cargo,/datum/rogue/asteroid/predef/cargo/angry),
		"tier3" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large),
		"tier4" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large),
		"tier5" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large),
		"tier6" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large)
	)

	///// Monster Lists /////
	var/mobs = list(
		"tier1" = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/goose),

		"tier2" = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/goose),

		"tier3" = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/goose,
						/mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/carp/strong),

		"tier4" = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/goose, /mob/living/simple_animal/hostile/bear,
						/mob/living/simple_animal/hostile/carp/strong, /mob/living/simple_animal/hostile/carp/pike/weak),

		"tier5" = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/carp/pike/weak,
						/mob/living/simple_animal/hostile/carp/strong, /mob/living/simple_animal/hostile/carp/pike),

		"tier6" = list(/mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/carp/strong,
						/mob/living/simple_animal/hostile/carp/pike, /mob/living/simple_animal/hostile/carp/pike/weak)
	)

/datum/controller/rogue/New()
	//How many zones are we working with here
	for(var/area/asteroid/rogue/A in world)
		all_zones += new /datum/rogue/zonemaster(A)
	//decay() //Decay removed for now, since people aren't getting high scores as it is.

/datum/controller/rogue/proc/decay(var/manual = 0)
	world.log << "RM(stats): DECAY on controller from [difficulty] to [difficulty+(RM_DIFF_DECAY_AMT)] min 100." //DEBUG code for playtest stats gathering.
	adjust_difficulty(RM_DIFF_DECAY_AMT)

	if(!manual) //If it was called manually somehow, then don't start the timer, just decay now.
		spawn(RM_DIFF_DECAY_TIME)
			decay()
	return difficulty

/datum/controller/rogue/proc/dbg(var/message)
	ASSERT(message) //I want a stack trace if there's no message
	if(debugging)
		world.log << "[message]"

/datum/controller/rogue/proc/adjust_difficulty(var/amt)
	ASSERT(amt)

	difficulty = max(difficulty+amt, diffstep_nums[1]) //Can't drop below the lowest level.

	if(difficulty < diffstep_nums[diffstep])
		diffstep--
	else if(difficulty >= diffstep_nums[diffstep+1])
		diffstep++

/datum/controller/rogue/proc/get_oldest_zone()
	var/oldest_time = world.time
	var/oldest_zone

	for(var/datum/rogue/zonemaster/ZM in ready_zones)
		if(ZM.prepared_at < oldest_time) //Check ready so we don't return zones that ARE cleaning
			oldest_zone = ZM
			oldest_time = ZM.prepared_at

	return oldest_zone

/datum/controller/rogue/proc/mark_clean(var/datum/rogue/zonemaster/ZM)
	if(!ZM in all_zones) //What? Who?
		rm_controller.dbg("RMC(mc): Some unknown zone asked to be listed.")

	if(ZM in ready_zones)
		rm_controller.dbg("RMC(mc): Finite state machine broken.")

	clean_zones += ZM

/datum/controller/rogue/proc/mark_ready(var/datum/rogue/zonemaster/ZM)
	if(!ZM in all_zones) //What? Who?
		rm_controller.dbg("RMC(mr): Some unknown zone asked to be listed.")

	if(ZM in clean_zones)
		rm_controller.dbg("RMC(mr): Finite state machine broken.")

	ready_zones += ZM

/datum/controller/rogue/proc/unmark_clean(var/datum/rogue/zonemaster/ZM)
	if(!ZM in all_zones) //What? Who?
		rm_controller.dbg("RMC(umc): Some unknown zone asked to be listed.")

	if(!ZM in clean_zones)
		rm_controller.dbg("RMC(umc): Finite state machine broken.")

	clean_zones -= ZM

/datum/controller/rogue/proc/unmark_ready(var/datum/rogue/zonemaster/ZM)
	if(!ZM in all_zones) //What? Who?
		rm_controller.dbg("RMC(umr): Some unknown zone asked to be listed.")

	if(!ZM in ready_zones)
		rm_controller.dbg("RMC(umr): Finite state machine broken.")

	ready_zones -= ZM

/datum/controller/rogue/proc/prepare_new_zone()
	var/datum/rogue/zonemaster/ZM_target

	if(clean_zones.len)
		ZM_target = pick(clean_zones)

	if(ZM_target)
		world.log << "RM(stats): SCORING [ready_zones.len] zones (if unscored)." //DEBUG code for playtest stats gathering.
		for(var/datum/rogue/zonemaster/ZM_toscore in ready_zones) //Score all the zones first.
			if(ZM_toscore.scored) continue
			ZM_toscore.score_zone()
		ZM_target.prepare_zone()
	else
		rm_controller.dbg("RMC(pnz): I was asked for a new zone but there's no space.")

	if(clean_zones.len <= 1) //Need to clean the oldest one, too.
		rm_controller.dbg("RMC(pnz): Cleaning up oldest zone.")
		spawn(0) //Detatch it so we can return the new zone for now.
			var/datum/rogue/zonemaster/ZM_oldest = get_oldest_zone()
			ZM_oldest.clean_zone()

	return ZM_target