/*
	The blob is a horrible acidic slime creature that eats through airlocks and expands infinitely.
	The rate of expansion slows down as it grows, so it is ultimately soft-capped

	Its attacks deal light burn damage, but spam69any hits. They deal a lot of damage by splashing acid
	onto69ictims, allowing acidproof gear to provide some good protection

	Blobs are69ery69ulnerable to fire and lasers. Flamethrower is the recommended weapon, and
	In an emergency, a plasma canister and a lighter will bring a 69uick end to a blob
*/

/datum/storyevent/blob
	id = "blob"
	name = "Blob"


	event_type = /datum/event/blob
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR*1.35)
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE, TAG_NEGATIVE)
//============================================

/datum/event/blob
	announceWhen	= 12

	var/obj/effect/blob/core/Blob

/datum/event/blob/announce()
	level_seven_announcement()

/datum/event/blob/start()
	var/area/A = random_ship_area(filter_players = TRUE, filter_critical = TRUE)
	var/turf/T = A.random_space()
	if(!T)
		log_and_message_admins("Blob failed to find a69iable turf.")
		kill()
		return

	log_and_message_admins("Blob spawned at \the 69get_area(T)69", location = T)
	Blob = new /obj/effect/blob/core(T)
	for(var/i = 1; i < rand(3, 4), i++)
		Blob.Process()

/datum/event/blob/tick()
	if(!Blob || !Blob.loc)
		Blob = null
		kill()
		return
	if(ISMULTIPLE(activeFor, 3))
		Blob.Process()


//===============================================

/*
	Code for how the blob functions
	Nanako fixed this69ess in October 2018
*/
/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	var/icon_scale = 1
	light_range = 3
	desc = "Some blob creature thingy"
	density = FALSE //Normal blobs can be walked over, but it's not a good idea

	opacity = 0
	anchored = TRUE
	mouse_opacity = 2

	var/maxHealth = 20
	var/health = 1
	var/health_regen = 1.7
	var/brute_resist = 1.25
	var/fire_resist = 0.6
	var/expandType = /obj/effect/blob

	//We will periodically update and track neighbors in two lists:
	//One which contains all blobs in cardinal directions, and one which contains all cardinal turfs that dont have blobs
	var/list/blob_neighbors = list()
	var/list/non_blob_neighbors = list()
	var/obj/effect/blob/core/core

	var/obj/effect/blob/parent
	var/active = FALSE

	//World time when we're allowed to expand next.
	//Expansion gets slower as the blob gets farther away from the origin core
	var/next_expansion = 0
	var/coredist = 1
	var/dist_time_scaling = 1.5

/obj/effect/blob/New(loc,69ar/obj/effect/blob/_parent)
	if (_parent)
		parent = _parent
		core = parent.core
		coredist =69ax(1,get_dist(src, core))

		//Accounting for zlevel distance
		if (src.z != core.z)
			coredist += (abs(z - core.z)*3)

		health += (maxHealth*0.5) - coredist
	update_icon()
	set_awake()


	//Random rotation for blobs, as well as larger sizing for some
	var/rot = pick(list(0, 90, 180, -90))
	var/matrix/M =69atrix()
	M.Turn(rot)
	M.Scale(icon_scale)
	transform =69
	name += "69rand(0,999)69"
	return ..(loc)

/obj/effect/blob/Destroy()
	STOP_PROCESSING(SSobj, src)
	wake_neighbors()
	return ..()

/obj/effect/blob/CanPass(var/atom/mover)
	//No letting projectiles through
	if (istype(mover, /obj/item/projectile))
		return FALSE

	//But69obs can walk over the nondense ones.
	return ..()

/obj/effect/blob/proc/update_neighbors()
	blob_neighbors = list()
	non_blob_neighbors = list()
	var/list/turfs = cardinal_turfs(src)
	for (var/t in turfs)

		var/turf/T = t
		var/turf/U = get_connecting_turf(T, loc)//This handles Zlevel stuff
		//If the target turf connects to another across Zlevels, U will hold the destination
		var/obj/effect/blob/B = (locate(/obj/effect/blob/) in U)
		//We check for existing blobs in the destination
		if (B)
			blob_neighbors.Add(B)
		else
			//But we add the origin to our neighbors if there isnt a blob
			//Blob spawning code will handle69aking a new blob transition the zlevel
			non_blob_neighbors.Add(T)



/*************************************************
	Basic blob processing. Every tick we will update our neighbors, try to expand, etc
**************************************************/
/obj/effect/blob/Process()

	//Shouldn't happen, but69aybe a process tick was still 69ueued up when we stopped
	if (!active)
		return PROCESS_KILL

	//Heal ourselves
	regen()


	if (world.time >= next_expansion)
		//Update our neighbors. This69ay cause us to stop processing
		update_neighbors()



		//Okay if we're still active then we69aybe have some expanding to do
		if (health >=69axHealth && non_blob_neighbors.len)
			//We will attempt to expand into only one of the possible nearby tiles
			expand(pick(non_blob_neighbors))


		//Maybe there are69obs in our tile we still need to69elt
		if (!attack_mobs())
			//If not, try to go to sleep
			set_idle()

		//Another active check here
		if (!active)
			return PROCESS_KILL

		set_expand_time()

/obj/effect/blob/proc/regen()
	if (!(69DELETED(core)))
		health =69in(health + health_regen,69axHealth)
	else
		core = null
		//When the core is gone, the blob starts dying
		//The closer it was to the core, the faster it dies. So death spreads out radially
		take_damage((1 / coredist))
	update_icon()

/*
	The blob is allowed to grow forever, there is no upper limit to its size
	However, the farther away each segment is from the core, the longer it69ust rest between expansions
*/
/obj/effect/blob/proc/set_expand_time()
	if (!(69DELETED(core)))
		next_expansion = world.time + ((1 SECONDS) * (dist_time_scaling ** coredist))
	else
		//If the core is gone, no69ore expansion
		next_expansion = INFINITY




/*
	TO69inimise performance costs at69assive sizes, blobs will go to sleep once they're no longer at the
	edge or relevant.
	If a blob finds itself surrounded on all sides by other blobs, and it is at full health, it has nothing to do
*/
/obj/effect/blob/proc/set_idle()
	if (!active)
		return

	if (blob_neighbors.len == 4) //We69ust have a full list of blobneighbors
		if (health >=69axHealth) //We69ust be at full health
			if (!(69DELETED(core)))//We69ust have a living core
				if (!attackable_mobs_in_turf())
					STOP_PROCESSING(SSobj, src)
					active = FALSE


/obj/effect/blob/proc/attackable_mobs_in_turf()
	for (var/mob/living/L in loc)
		if (L.stat != DEAD)
			return TRUE

	for (var/mob/living/exosuit/M in loc)
		return TRUE

	return FALSE

/*
	Wake up the blob and69ake it start processing again.
	This will happen when any neighboring blob is killed
*/
/obj/effect/blob/proc/set_awake()
	if (active)
		return

	START_PROCESSING(SSobj, src)
	active = TRUE
	set_expand_time()


/obj/effect/blob/proc/wake_neighbors()
	update_neighbors()

	//Spawn it off so this part will trigger after we're 69deleted
	spawn()
		for (var/obj/effect/blob/B in blob_neighbors)
			B.set_awake()


/obj/effect/blob/ex_act(var/severity)
	switch(severity)
		if(1)
			take_damage(rand(100, 120) / brute_resist)
		if(2)
			take_damage(rand(60, 100) / brute_resist)
		if(3)
			take_damage(rand(20, 60) / brute_resist)


/obj/effect/blob/fire_act()
	take_damage(rand(20, 60) / fire_resist)

/obj/effect/blob/update_icon()
	var/healthpercent = health /69axHealth
	if(healthpercent > 0.5)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

	//Blob gradually fades out as it's damaged.
	alpha = 255 * healthpercent

/obj/effect/blob/proc/take_damage(var/damage)
	if (damage > 0)
		health -= damage

		if (damage >= 5)
			//Threshold reduces sound spam
			playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		if(health < 0)
			playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			69del(src)
		else
			update_icon()
			wake_neighbors()







/*********************************
	EXPANDING!
**********************************/
//Changes by Nanako, 14th october 2018
//Blob now deals69astly reduced damage to walls and windows, but69astly increased damage to doors
/obj/effect/blob/proc/expand(var/turf/T)
	if(istype(T, /turf/unsimulated/) || istype(T, /turf/space) || (istype(T, /turf/simulated/mineral) && T.density))
		return
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.take_damage(rand(0,3))
		return
	var/obj/structure/girder/G = locate() in T
	if(G)
		G.take_damage(100)

		//No return here because a girder is porous, we can expand past it
	var/obj/structure/window/W = locate() in T
	if(W)
		W.take_damage(rand(0,7)) //Reinforced windows have 6 resistance so this will rarely damage them
		return
	var/obj/structure/grille/GR = locate() in T
	if(GR)
		69del(GR)
		return
	for(var/obj/machinery/door/D in T)
		if(D.density)
			D.take_damage(100)
			//Blob eats through doors69ERY 69uickly
			return
	var/obj/structure/foamedmetal/F = locate() in T
	if(F)
		69del(F)
		return
	var/obj/structure/inflatable/I = locate() in T
	if(I)
		I.deflate(1)
		return

	var/obj/vehicle/V = locate() in T
	if(V)
		V.ex_act(2)
		return
	var/obj/machinery/bot/B = locate() in T
	if(B)
		B.ex_act(2)
		return

	T.Enter(src) //This should69ake them travel down stairs

	// Above things, we destroy completely and thus can use locate.69obs are different.
	for(var/mob/living/L in T)
		attack_mobs(T)//We don't destroy69obs, we'll just grow under their feet and attack them in the process
		break

	//We'll occasionally spawn shield tiles instead of normal blobs
	var/obj/effect/blob/child
	if (prob(6))
		child = new /obj/effect/blob/shield(loc, src)
	else
		child = new expandType(loc, src)

	//Spawn the child blob and69ove it into the new tile
	spawn(1)
		child.handle_move(loc, T)


//This silly special case override is needed to69ake blobs work with portals.
//Code is copied from /atoms_movable.dm, but a spawn call is removed,69aking it completely synchronous
/obj/effect/blob/Bump(var/atom/A, yes)
	if (A && yes)
		A.last_bumped = world.time
		A.Bumped(src)


//Once created, the new blob69oves to its destination turf
/obj/effect/blob/proc/handle_move(var/turf/origin,69ar/turf/destination)
	//First of all lets ensure we still exist.
	//We69ay have been deleted by another blob doing postmove cleanup
	if (69DELETED(src))
		return

	//And lets69ake sure we haven't already69oved
	if (loc != origin)
		return

	//We un-anchor ourselves, so that we're exposed to effects like gravity and teleporting
	anchored = FALSE

	//Now we will attempt a normal69ovement, obeying all the normal rules
	//This allows us to bump into portals and get teleported
	Move(destination)

	/*Now we check if we went anywhere. We don't care about the return69alue of69ove, we do our own check
	In the case of a portal, or falling through an openspace, or69oving along stairs,69ove69ay return false
	but we've still gone somewhere. We will only consider it a failure if we're still where we started
	*/
	if (loc == origin)
		//That failed, okay this time we're not asking
		forceMove(destination)
		//forceMove won't work properly with portals, so we only do it as a backup option


	//Ok now we should definitely be somewhere
	if (loc == origin)
		//Welp, we give up.
		//This shouldn't be possible, but if it somehow happens then this blob is toast
		69del(src)
		return

	//Ok we got somewhere, hooray
	//Now we settle down
	anchored = TRUE

	//And do this
	handle_postmove()

//Now we clean up our arrival tile
/obj/effect/blob/proc/handle_postmove()
	for (var/obj/effect/blob/Bl in loc)
		if (Bl != src)
			69del(Bl) //Lets69ake sure we don't get doubleblobs

/*******************
	BLOB ATTACKING
********************/
//Blobs will do horrible things to any69obs they share a tile with
//Returns true if any69ob was damaged, false if not
/obj/effect/blob/proc/attack_mobs(var/turf/T)
	if (!T)
		T = loc
	for (var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		L.visible_message(SPAN_DANGER("The blob attacks \the 69L69!"), SPAN_DANGER("The blob attacks you!"))
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		L.take_organ_damage(burn = RAND_DECIMAL(0.4, 2.3))

		//In addition to the flat damage above, we will also splash a small amount of acid on the target
		//This allows them to wear acidproof gear to resist it
		if (iscarbon(L))
			var/datum/reagents/R = new /datum/reagents(4, null)
			R.add_reagent("sacid", RAND_DECIMAL(0.8,4))
			R.trans_to(L, R.total_volume)
			69del(R)

		return TRUE

	//If we get here, nobody was harmed
	return FALSE


//Stepping on a blob is bad for your health.
//When walked over, the blob will wake up and attack whoever stepped on it
//Since it's awake, it will keep attacking them every process call until they leave or die
/obj/effect/blob/Crossed()
	set_awake()
	attack_mobs()

/*******************
	BLOB DEFENSE
********************/

//Bullets which hit a blob will keep going on through if they kill it
/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	var/absorbed_damage //The amount of damage that will be subtracted from the projectile
	var/taken_damage //The amount of damage the blob will recieve
	for(var/i in Proj.damage_types)
		if(i == BRUTE)
			absorbed_damage =69in(health * brute_resist, Proj.damage_types69i69)
			taken_damage = (Proj.damage_types69i69 / brute_resist)
			Proj.damage_types69i69 -= absorbed_damage
		if(i == BURN)
			absorbed_damage =69in(health * fire_resist, Proj.damage_types69i69)
			taken_damage= (Proj.damage_types69i69  / fire_resist)
			Proj.damage_types69i69 -= absorbed_damage
	take_damage(taken_damage)
	if (Proj.get_total_damage() <= 0)
		return 0
	else
		return PROJECTILE_CONTINUE

/obj/effect/blob/attackby(var/obj/item/W,69ar/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(W.force && !(W.flags & NOBLUDGEON))
		user.do_attack_animation(src, TRUE)
		var/damage = 0
		switch(W.damtype)
			if("fire")
				damage = (W.force / fire_resist)
				if(istype(W, /obj/item/tool/weldingtool))
					playsound(loc, 'sound/items/Welder.ogg', 100, 1)
			if("brute")
				damage = (W.force / brute_resist)

		take_damage(damage)
		return 1
	return ..()

/obj/effect/blob/core
	name = "blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_core"
	maxHealth = 200
	health = 200
	brute_resist = 4
	fire_resist = 2
	density = TRUE
	icon_scale = 1.2
	health_regen = 0 //The core does not heal

	expandType = /obj/effect/blob/shield


/obj/effect/blob/core/New()
	core = src //It is its own core
	..()

/obj/effect/blob/core/update_icon()
	return

//When the core dies, wake up all our sub-blobs so they can slowly die too
/obj/effect/blob/core/Destroy()
	for (var/obj/effect/blob/B in world)
		if (B == src)
			continue
		if (B.core == src)
			B.core = null
			B.set_awake()
	return ..()



/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "Some blob creature thingy"
	maxHealth = 160
	health = 160
	health_regen = 2
	brute_resist = 2
	fire_resist = 1
	density = TRUE
	icon_scale = 1.2

/obj/effect/blob/shield/update_icon()
	var/healthpercent = health /69axHealth
	if(healthpercent > 0.6)
		icon_state = "blob_idle"
	else if(healthpercent > 0.3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"



	//Blob gradually fades out as it's damaged.
	alpha = 255 * healthpercent


