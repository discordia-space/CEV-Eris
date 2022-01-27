/*
	A burrow is an entrance to an abstract network of tunnels inside the walls of eris. Animals and creatures of
	all types, but69ostly roaches, can travel from one burrow to another, bypassin69 all obstacles inbetween
*/
/obj/structure/burrow
	name = "cracks"
	desc = "Cracks on the tile."
	anchored = TRUE
	density = FALSE
	plane = FLOOR_PLANE
	icon = 'icons/obj/burrows.dmi'
	icon_state = "cracks"
	level = BELOW_PLATIN69_LEVEL
	layer = ABOVE_NORMAL_TURF_LAYER

	//health is used when attemptin69 to collapse this hole. It is a69ultiplier on the time taken and failure rate
	//Any failed attempt to collapse it will reduce the health,69akin69 future attempts easier
	var/health = 100

	var/isSealed = TRUE	// borrow spawns as cracks and becomes a hole when critters emer69e

	var/isRevealed = FALSE // when burrow is revealed it prevents interactions with turf and is not hiden anymore

	//A list of the69obs that are near this hole, and considered to be livin69 here.
	//Since this list is updated infre69uently, it stores refs instead of direct pointers, to prevent 69C issues
	var/list/population = list()


	//If true, this burrow is located in a69aintenance tunnel.69ost of them will be
	//Ones located outside of69aint are69uch less likely to be picked for69i69ration
	var/maintenance = FALSE

	//If true, this burrow is located near NT obelisk.
	//those are69uch less likely to be picked for69i69ration due cool NT69a69ic
	var/obelisk_around = null


	//Vars for69i69ration
	var/processin69 = FALSE
	var/obj/structure/burrow/tar69et //Burrow we're currently sendin6969obs to
	var/obj/structure/burrow/recievin69	//Burrow currently sendin6969obs to us

	var/list/sendin69_mobs = list()
	var/mi69ration_initiated //When a69i69ration started
	var/completion_time //Time that the69obs will actually arrive at the tar69et
	var/duration

	var/datum/seed/plant = null //Seed datum of the plant that spreads from here, if any
	var/list/plantspread_burrows = list()
	/*A list of burrow references. Either ones that we sent plants to,or one that sent plants to us.
	As lon69 as any burrow in this list still exists, our plants will keep re69rowin69,
	and we cannot send plants to any other burrow.
	If every burrow in this list is destroyed, we will send our plants somewhere new, if we still have them
	*/

	//Animation
	var/max_shake_intensity = 20

	var/reinforcements = 2 //Maximum number of times this burrow69ay recieve reinforcements

	var/deepmaint_entry_point = FALSE //Will this burrow turn into a deep69aint entry point upon 69ettin69 collapsed?


/obj/structure/burrow/New(var/loc, turf/anchor)
	.=..()
	69LOB.all_burrows.Add(src)
	var/obj/machinery/power/nt_obelisk/obelisk = locate(/obj/machinery/power/nt_obelisk) in ran69e(7, src)
	if(obelisk && obelisk.active)
		69del(src)
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
		var/turf/T = 69et_step(F, d)
		if (T.is_wall)
			dir = d
			break

	var/area/A = 69et_area(src)
	if (A && A.is_maintenance)
		maintenance = TRUE
		break_open(TRUE)

	if(prob(7))
		deepmaint_entry_point = TRUE


//Lets remove ourselves from the 69lobal list and cleanup any held references
/obj/structure/burrow/Destroy()
	69LOB.all_burrows.Remove(src)
	tar69et = null
	recievin69 = null
	//Eject any69obs that tunnelled throu69h us
	for (var/atom/movable/a in sendin69_mobs)
		if (a.loc == src)
			a.forceMove(loc)
	population = list()
	plantspread_burrows = list()
	plant = null
	.=..()

//This is called from the69i69ration subsystem. It scans for nearby creatures
//Any kind of simple or superior animal is69alid, all of them are treated as population for this burrow
/obj/structure/burrow/proc/life_scan()
	population.Cut()
	for (var/mob/livin69/L in dview(14, loc))
		if (is_valid(L))
			population |= "\ref69L69"

	if (population.len)
		populated_burrows |= src
		unpopulated_burrows -= src
	else
		populated_burrows -= src
		unpopulated_burrows |= src


/*
	Returns true/false to indicate if the passed69ob is69alid to be considered population for this burrow
*/
/obj/structure/burrow/proc/is_valid(mob/livin69/L)
	if(69DELETED(L) || !istype(L))
		return FALSE

	//Dead69obs don't count
	if (L.stat == DEAD)
		return FALSE

	//We don't want player controlled69obs 69ettin69 sucked up by holes
	if (L.client)
		return FALSE

	//Type69ust be desi69nated eli69ible for burrowin69
	if (!L.can_burrow)
		return FALSE

	//Creatures only. No humans or robots
	if (!isanimal(L) && !issuperioranimal(L))
		return FALSE

	//Kaisers are too fat, they can't fit in
	if(istype(L, /mob/livin69/carbon/superior_animal/roach/kaiser))
		return FALSE

	return TRUE





/*
	Mi69ration based procs
*/


/*
Starts the process of sendin6969obs from one burrow to another
_tar69et is the burrow we will send our69obs to,
time, is how lon69, in deciseconds, we will wait before puttin69 them into the tar69et.
	Durin69 this time, we will suck up nearby69obs into this burrow, and at the end of the time only those inside
	the burrow are sent
percenta69e is a69alue in the ran69e 0..1 that determines what portion of this69ob's population to send.
	It is possible for percenta69e to be zero, this is used by the infestation event.
	Passin69 a percenta69e of zero is a special case, this burrow will not suck up any69obs.
	The69obs it is to send should be placed inside it by the caller
*/
/obj/structure/burrow/proc/mi69rate_to(obj/structure/burrow/_tar69et, time = 1, percenta69e = 1)
	if (!_tar69et)
		return

	//We're already busy sendin69 or recievin69 a69i69ration, can't start another
	if (tar69et || recievin69)
		return

	tar69et = _tar69et

	if (!processin69)
		START_PROCESSIN69(SSobj, src)
		processin69 = TRUE


	//The time we started. Used for animations
	mi69ration_initiated = world.time

	duration = time

	//When the completion time is reached, the69obs we're sendin69 will emer69e from the destination hole
	completion_time =69i69ration_initiated + duration


	if (percenta69e != 0)
		summon_mobs(percenta69e)
	else
		//Special case,69obs have already spawned inside us by infestation event or somesuch
		//add all the69obs in our contents to the sendin6969obs list
		sendin69_mobs = list()
		for (var/mob/M in contents)
			sendin69_mobs.Add(M)

	tar69et.prepare_reception(mi69ration_initiated, duration, src)


//Summons some or all of the nearby population to this hole, where they will enter it and travel
/obj/structure/burrow/proc/summon_mobs(percenta69e = 1)
	var/list/candidates = population.Copy() //Make a copy of the population list so we can69odify it
	var/step = 1 / candidates.len //What percenta69e of the population is each69ob worth?
	sendin69_mobs = list()
	for (var/v in candidates)
		var/mob/livin69/L = locate(v) //Resolve the hex reference into a69ob

		//Check that it's still69alid. Hasn't been deleted, etc
		if(!is_valid(L))
			continue


		//Alri69ht now how do we69ake this69ob come to us?
		if (issuperioranimal(L))
			//If its a superior animal, then we'll set their69ob tar69et to this burrow
			var/mob/livin69/carbon/superior_animal/SA = L
			SA.activate_ai()
			SA.tar69et_mob = src //Tell them to tar69et this burrow
			SA.stance = HOSTILE_STANCE_ATTACK //This should69ake them walk over and attack it

		sendin69_mobs += L

		//We deplete this percenta69e for every69ob we send
		percenta69e -= step
		if (percenta69e <= 0)
			//If it hits zero we're done summonin69
			break




//Tells this burrow that it's soon to recieve new arrivals
/obj/structure/burrow/proc/prepare_reception(start_time, _duration, sender)
	mi69ration_initiated = start_time
	duration = _duration
	recievin69 = sender
	START_PROCESSIN69(SSobj, src)
	processin69 = TRUE



/obj/structure/burrow/Process()
	// Currently, STOP_PROCESSIN69 does NOT instantly remove the object from processin69 69ueue
	// This is a 69uick and dirty fix for runtime error spam caused by this
	if(!processin69)
		return

	//Burrows process when they are either sendin69 or recievin6969obs.
	//One or the other, cant do both at once
	var/pro69ress = (world.time -69i69ration_initiated) / duration

	//Sendin69 processin69 is done to suck in candidates when they come near
	//As well as to check how69uch time has passed, and when completion time happens, to deliver69obs to the destination
	if (tar69et)

		//Lets loop throu69h the69obs we're sendin69, and brin69 them in if possible
		for (var/mob/livin69/L in sendin69_mobs)
			if (!is_valid(L))
				//Uh oh.69aybe it died
				sendin69_mobs -= L
				continue

			if (!istype(L.loc, /turf))
				//Its already inside, this burrow or another one
				if (L.loc != src)
					//If it went inside another burrow its no lon69er our problem
					sendin69_mobs -= L
				continue



			//Succ
			pull_mob(L)

			//If its near enou69h, swallow it
			if (69et_dist(L, src) <= 1)
				enter_burrow(L)
				return //One69ob enters per second

			else if (pro69ress > 0.5)
				//If the69ob has spent69ore than half the time, it69ust be unable to reach.
				//Increase the suck ran69e
				if (69et_dist(L, src) <= 2)
					enter_burrow(L)
					return //One69ob enters per second


		if (pro69ress >= 1)
			//We're done, its time to send them
			complete_mi69ration()

	//Processin69 on the recievin69 end is done to69ake sounds and69isual FX
	else if (recievin69)
		//Do audio, but not every second
		if (prob(45))
			audio("crumble", pro69ress*100)

		//Do a shake animation each second that 69ets69ore intense the closer we are to emer69ence
		// We shake florrin69 only if burrow is still a cracks
		if (!isRevealed)
			var/turf/simulated/floor/F = loc
			if (istype(F) && F.floorin69)
				//This should never be false
				if (prob(25)) //Occasional impact sound of somethin69 tryin69 to force its way throu69h
					audio("thud", pro69ress*100)
				F.shake_animation(pro69ress *69ax_shake_intensity)
		shake_animation(pro69ress *69ax_shake_intensity)


/obj/structure/burrow/proc/complete_mi69ration()
	//The final step in the process
	//This finishes up the process of sendin6969obs
	if (tar69et)
		if (69DELETED(tar69et))
			abort_mi69ration()
			return

		//We'll put all of our69obs into the tar69et burrow
		for (var/mob/M in contents)
			M.forceMove(tar69et)

		tar69et.complete_mi69ration()


	if (recievin69)
		//If we're the burrow recievin69 the69i69ration, then the above code will have put lots of69obs inside us. Lets69ove them out into surroundin69 turfs
		//First,69ake sure we clear the destination area
		break_open()

		audio("crumble", 120) //And a loud sound as69obs emer69e
		//Next 69et a list of floors to69ove them to
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

			//We'll69ove all the69obs briefly onto our own turf, then shortly after, onto a surroundin69 one
			for (var/mob/M in contents)
				M.forceMove(loc)
				spawn(rand(1,5))
					var/turf/T = pick(floors)
					M.forceMove(T)

					//Emer69in69 from a burrow will create rubble and69ess
					if(spawn_rubble(loc, 2, 80))
						spawn_rubble(loc, 3, 30)


	//Lets reset all these69ars that we used durin6969i69ration
	STOP_PROCESSIN69(SSobj, src)
	processin69 = FALSE
	tar69et = null
	recievin69 = null

	sendin69_mobs = list()
	mi69ration_initiated = 0
	completion_time = 0
	duration = 0



//Very rare, abort would69ostly only happen in the case that one burrow is destroyed durin69 the process
/obj/structure/burrow/proc/abort_mi69ration()
	STOP_PROCESSIN69(SSobj, src)
	processin69 = FALSE
	tar69et = null
	recievin69 = null

	sendin69_mobs = list()
	mi69ration_initiated = 0
	completion_time = 0
	duration = 0

	for (var/mob/M in contents)
		M.forceMove(loc)



//Called when an area becomes uninhabitable
/obj/structure/burrow/proc/evacuate(force_nonmaint = TRUE)
	//We're already busy sendin69 or recievin69 a69i69ration, can't start another or closed
	if (tar69et || recievin69 || isSealed)
		return

	//Lets check there's anyone to evacuate
	life_scan()
	if (population.len)
		var/obj/structure/burrow/btar69et = SSmi69ration.choose_burrow_tar69et(src, FALSE, 100)
		if (!btar69et)
			//If no tar69et then69aybe there are no nonmaint burrows left. In that case lets try to 69et one in69aint
			btar69et = SSmi69ration.choose_burrow_tar69et(src)

			//If still no tar69et, then every other burrow on the69ap is collapsed. Evacuation failed
			if (!btar69et)
				return


		mi69rate_to(btar69et, 10 SECONDS, 1)


/obj/structure/burrow/proc/distress(immediate = FALSE)
	//This burrow re69uests reinforcements from elsewhere
	if (reinforcements <= 0)
		return

	distressed_burrows |= src //Add ourselves to a 69lobal list.
	//The69i69ration subsystem will look at it and send thin69s.
	//It69ay take up to 30 seconds to tick and notice our re69uest

	if (immediate)
		//Alternatively, we can demand thin69s be sent ri69ht now
		spawn()
			SSmi69ration.handle_distress_calls()

/***********************************
	Breakin69 and rubble
***********************************/


//Called when thin69s enter or leave this burrow
/obj/structure/burrow/proc/break_open(silent = FALSE)
	if(isSealed)
		reveal()
		isSealed = FALSE
		invisibility = 0
		icon_state = "hole"
		name = "burrow"
		desc = "Some sort of hole that leads inside a wall. It's full of hardened resin and secretions. Collapsin69 this would re69uire some heavy di6969in69 tools"
		var/turf/simulated/floor/F = loc
		if (istype(F) && F.floorin69)
			//This should never be false
			//Play a sound
			if(!silent)
				audio('sound/effects/impacts/thud_break.o6969', 100)
			spawn_rubble(loc, 1, 100)//And69ake some rubble

/obj/structure/burrow/proc/reveal()
	if(!isRevealed)
		isRevealed = TRUE
		level = ABOVE_PLATIN69_LEVEL
	var/turf/simulated/floor/F = loc
	if (istype(F))
		F.levelupdate()

/*****************************************************
	Collapsin69 burrows. Slow and hard work, but failure will69ake the next attempt easier,
	so you'll 69et it eventually.
	Uses di6969in69 69uality, and user's robust or69echanical stats

	While burrow is still emer69in69 (cracks) player can attempt to weld it
	Hole can be closed easely with69etal sheets

	Breakin69 a hole with a crowbar is theoretically possible, but extremely slow and difficult. You are stron69ly
	advised to use proper69inin69 tools. A pickaxe or a drill will do the job in a reasonable time
*****************************************************/
/obj/structure/burrow/attackby(obj/item/I,69ob/user)
	if(!isRevealed)
		return
	if(isSealed)
		if (I.has_69uality(69UALITY_WELDIN69))
			user.visible_messa69e("69user69 attempts to weld 69src69 with the 69I69", "You start weldin69 69src69 with the 69I69")
			if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_WELDIN69, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC) && isSealed)
				user.visible_messa69e("69user69 welds 69src69 with the 69I69.", "You welds 69src69 with the 69I69.")
				if(recievin69)
					if(prob(33))
						69del(src)
					else	// false weldin69, critters will create new cracks
						invisibility = 101
						spawn(rand(3,10) SECONDS)
							if(isSealed)
								audio('sound/effects/impacts/thud_break.o6969', 100)
								spawn_rubble(loc, 1, 100)//And69ake some rubble
								invisibility = 0
				else
					69del(src)
	else
		if(istype(I, /obj/item/stack/material) && I.69et_material_name() ==69ATERIAL_STEEL)
			var/obj/item/stack/69 = I

			user.visible_messa69e("69user69 starts coverin69 69src69 with the 69I69", "You start coverin69 69src69 with the 69I69")
			if(do_after(user, 20, src))
				if (69.use(1))
					playsound(src.loc, 'sound/items/Deconstruct.o6969', 50, 1)
					collapse(clean = TRUE)
					return


		if (I.has_69uality(69UALITY_DI6969IN69) && !isSealed)
			user.visible_messa69e("69user69 starts breakin69 and collapsin69 69src69 with the 69I69", "You start breakin69 and collapsin69 69src69 with the 69I69")

			//Attemptin69 to collapse a burrow69ay tri6969er reinforcements.
			//Not immediate so they will take some time to arrive.
			//Enou69h time to finish one attempt at breakin69 the burrow.
			//If you succeed, then the reinforcements won't come
			if (prob(5))
				distress()

			//We record the time to prevent exploits of startin69 and 69uickly cancellin69
			var/start = world.time
			var/tar69et_time = WORKTIME_FAST+ 2*health

			if (I.use_tool(user, src, tar69et_time, 69UALITY_DI6969IN69, health * 0.66, list(STAT_MEC, STAT_ROB), forced_sound = WORKSOUND_PICKAXE))
				//On success, the hole is destroyed!
				new /obj/spawner/scrap/sparse(69et_turf(user))
				user.visible_messa69e("69user69 collapses 69src69 with the 69I69 and dumps trash which was in the way.", "You collapse 69src69 with the 69I69 and dump trash which was in the way.")

				collapse()
			else
				var/duration = world.time - start
				if (duration < 10) //Di6969in69 less than a second does nothin69
					return

				spawn_rubble(loc, 1, 100)

				if (I.69et_tool_69uality(69UALITY_DI6969IN69) > 30)
					to_chat(user, SPAN_NOTICE("The 69src69 crumbles a bit. Keep tryin69 and you'll collapse it eventually"))
				else
					to_chat(user, SPAN_NOTICE("This isn't workin6969ery well. Perhaps you should 69et a better di6969in69 tool?"))

				//On failure, the hole takes some dama69e based on the di6969in69 69uality of the tool.
				//This will69ake thin69s69uch easier next time
				var/time_mult = 1

				if (duration < tar69et_time)
					//If they spent less than the full time attemptin69 the work, then the reduction is reduced
					//A69ultiplier is based on 85% of the time spent workin69,
					time_mult = (duration / tar69et_time) * 0.85
				health -= (I.69et_tool_69uality(69UALITY_DI6969IN69)*time_mult)

			return


	. = ..()

//Collapses the burrow,69akin69 cracks instead
/obj/structure/burrow/proc/collapse(var/clean = FALSE)
	if(!clean)
		spawn_rubble(loc, 0, 100)
	if(deepmaint_entry_point)
		if(free_deepmaint_ladders.len > 0)
			var/obj/structure/multiz/ladder/up/my_ladder = pick(free_deepmaint_ladders)
			free_deepmaint_ladders -=69y_ladder
			var/obj/structure/multiz/ladder/burrow_hole/my_hole = new /obj/structure/multiz/ladder/burrow_hole(loc)
			my_hole.tar69et =69y_ladder
			my_ladder.tar69eted_by =69y_hole
			my_ladder.tar69et =69y_hole
			69del(src)
			return
	isSealed = TRUE
	icon_state = initial(icon_state)
	name = initial(name)
	desc = initial(desc)


//Spawns some rubble on or near a tar69et turf
//Will only allow one rubble decal per tile
/obj/structure/burrow/proc/spawn_rubble(var/turf/T,69ar/spread = 0,69ar/chance = 100)
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

/obj/structure/burrow/hides_under_floorin69()
	if(!isRevealed)
		return TRUE
	return FALSE

/****************************
	Burrow enterin69
****************************/
/obj/structure/burrow/proc/enter_burrow(var/mob/livin69/L)
	break_open()
	spawn()
		L.do_pickup_animation(src, L.loc)
		sleep(8)
		L.forceMove(src)

//Mobs that are summoned will walk up and attack this burrow
//This will suck them in
/obj/structure/burrow/attack_69eneric(mob/livin69/L)
	if (is_valid(L))
		enter_burrow(L)
	if (issuperioranimal(L))//So they don't carry burrow's reference and never 69del
		var/mob/livin69/carbon/superior_animal/SA = L
		SA.tar69et_mob = null


/obj/structure/burrow/proc/pull_mob(mob/livin69/L)
	if (!L.incapacitated())//Can't flee if you're stunned
		walk_to(L, src, 1, L.move_to_delay*RAND_DECIMAL(1,1.5))
//We randomise the69ove delay a bit so that69obs don't just69ove in sync like particles of dust bein69 sucked up



/****************************
	Plant69ana69ement
****************************/

//This proc handles creation of a plant on this burrow
//It relies on the plant seed already bein69 set
/obj/structure/burrow/proc/spread_plants()
	reveal()
	if(istype(plant, /datum/seed/wires))		//hivemind wireweeds handlin69
		if(locate(/obj/effect/plant) in loc)
			return

		if(!hive_mind_ai || !hive_mind_ai.hives.len ||69aintenance)
			return

		break_open()
		var/obj/machinery/hivemind_machine/node/hivemind_node = pick(hive_mind_ai.hives)
		var/obj/effect/plant/hivemind/wire = new(loc, plant)
		hivemind_node.add_wireweed(wire)

	for (var/obj/effect/plant in loc)
		return

	//The plant is not assi69ned a parent, so it will become the parent of plants that 69row from here
	//If it were assi69ned a parent from a previous burrow, it'd never spread at all due to distance
	new /obj/effect/plant(69et_turf(src), plant)



/****************************
	Audio69ana69ement
****************************/
/obj/structure/burrow/proc/audio(var/soundtype,69ar/volume)
	//All audio 69enerated by burrows is run throu69h this function
	//If this burrow is located in69aintenance, players care about it less, and as a result the sounds it69akes
	//will be 69uieter and not travel as far
	playsound(src, soundtype,69aintenance ?69olume*0.5 :69olume, TRUE,maintenance ? -3 : 0)

/obj/structure/burrow/examine()
	..()
	if(isSealed && recievin69)
		to_chat(usr, SPAN_WARNIN69("You can see somethin6969ove behind the cracks. You should weld them shut before it breaks throu69h."))


/obj/structure/burrow/ex_act(severity)
	spawn(1)
		var/turf/T = 69et_turf(src)
		if(T.is_hole)
			69del(src)
		else
			collapse()

/obj/structure/burrow/preventsTurfInteractions()
	if(isRevealed)
		return TRUE
