/obj/item/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/traps.dmi'
	icon_state = "beartrap"
	desc = "A69echanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = 0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_STEEL = 25)
	edge = TRUE
	sharp = TRUE
	var/deployed = FALSE

	var/base_damage = 20
	var/fail_damage = 5
	var/base_difficulty = 85
	var/time_to_escape = 40
	var/target_zone
	var/min_size = 5 //Mobs smaller than this won't trigger the trap
	var/struggle_prob = 2
	var/list/aware_mobs = list() //List of refs of69obs that examined this trap. Won't trigger it when walking.
	var/prob_catch = 100 //prob catch to69ob


/obj/item/beartrap/Initialize()
	.=..()
	update_icon()


/***********************************
	Releasing69obs
***********************************/

/*
When someone is trapped in a beartrap, anyone (victim or other) can attempt to free them
They can do this either with their bare hands or with a prying tool for better odds.
This is a69ery difficult task and it will fre69uently fail the first few times.
Every failure causes the trap to dig deeper and hurt the69ictim69ore

Freeing yourself is69uch harder than freeing someone else. Calling for help is advised if practical
*/
/obj/item/beartrap/proc/attempt_release(mob/living/user, obj/item/I)
	if (!buckled_mob || 69DELETED(buckled_mob))
		return //Nobody there to rescue?

	if (!user)
		return //No user, or too far away

	if(iscarbon(user)) //check if69ob is carbon as handcuffed only applies to carbon69obs
		var/mob/living/carbon/C = user //set carbon to user
		if(C.handcuffed)
			return//you instantly fail if you are handcuffed and trapped, this way you will loose the handcuffs first instead of repeatedly snapping your torso in half

	//How hard will this be? The chance of failure
	var/difficulty = base_difficulty

	//Does the user have the dexterity to operate the trap?
	if (!can_use(user))
		//If they don't, then they're probably some kind of animal trapped in it
		if (user != buckled_mob || user.client)
			//Such a creature can't free someone else
			return

		//But they can attempt to struggle out on their own. At a69ery low success rate
		difficulty = 96
		/*This will generally not work, and repeated attempts will result in the creature bleeding to
		death as it tries to escape
		Such is nature*/

	else
		if (user != buckled_mob)
			difficulty -= 35 //It's easier to free someone else than to free yourself

		//Is there a tool involved?
		if (istype(I))
			//Using a crowbar helps
			to_chat(user, SPAN_NOTICE("\The 69I69 gives you extra leverage"))
			var/reduction = I.get_tool_69uality(69UALITY_PRYING)*0.5
			if (user == buckled_mob)
				reduction *= 0.66 //But it helps less if you don't have good leverage
			difficulty -= reduction
			I.consume_resources(time_to_escape * 3, user)

		if (issilicon(user))
			difficulty += 5 //Robots are less dextrous

		//How about your stats? Being strong or crafty helps.
		//We'll subtract the highest of either robustness or69echanical, from the difficulty
		var/reduction = user.stats.getMaxStat(list(STAT_ROB, STAT_MEC))
		if (user == buckled_mob)
			reduction *= 0.66 //But it helps less if you don't have good leverage
		difficulty -= reduction

	//Alright we calculated the difficulty, now lets do the attempt

	//Firstly a69isible69essage
	if (buckled_mob == user)
		user.visible_message(
			SPAN_NOTICE("\The 69user69 tries to free themselves from \the 69src69."),
			SPAN_NOTICE("You carefully begin to free yourself from \the 69src69."),
			SPAN_NOTICE("You hear69etal creaking.")
			)
	else
		user.visible_message(
			SPAN_NOTICE("\The 69user69 tries to free \the 69buckled_mob69 from \the 69src69."),
			SPAN_NOTICE("You carefully begin to free \the 69buckled_mob69 from \the 69src69."),
			SPAN_NOTICE("You hear69etal creaking.")
			)

	//Play a69etal creaking sound
	playsound(src, 'sound/machines/airlock_creaking.ogg', 10, 1, -3,-3)



	//Now a do_after
	if(!do_after(user, time_to_escape))
		//If you abort it's an automatic fail
		fail_attempt()
		return

	//You completed the doafter, but did you succeed?
	if (difficulty > 0 && prob(difficulty))
		fail_attempt(user, difficulty)
		return

	//You succeeded yay
	user.visible_message(
			SPAN_NOTICE("69user69 successfully releases 69buckled_mob69 from \the 69src69."),
			SPAN_NOTICE("You successfully release 69buckled_mob69 from \the 69src69."),
			SPAN_DANGER("You hear69etal creaking.")
			)
	release_mob()


//Using a crowbar allows you to lever the trap open, better success rate
/obj/item/beartrap/attackby(obj/item/C,69ob/living/user)
	if (C.has_69uality(69UALITY_PRYING))
		attempt_release(user, C)
		return
	.=..()

/obj/item/beartrap/attack_hand(mob/user as69ob)
	if (buckled_mob)
		attempt_release(user)
		return
	if (deployed)
		user.visible_message(
			SPAN_DANGER("69user69 starts to carefully disarm \the 69src69."),
			SPAN_DANGER("You begin to carefully disarm \the 69src69.")
			)

		if (do_after(user, 25))
			user.visible_message(
				SPAN_DANGER("69user69 has disarmed \the 69src69."),
				SPAN_DANGER("You have disarmed \the 69src69!")
				)
			deployed = FALSE
			anchored = FALSE
			update_icon()
		return
	.=..()

/obj/item/beartrap/attack_generic(mob/user, damage)
	if (buckled_mob)
		attempt_release(user)
		return
	.=..()

/obj/item/beartrap/attack_robot(mob/user)
	if (buckled_mob)
		attempt_release(user)
		return
	.=..()

/obj/item/beartrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !user.stat && user.Adjacent(src))

/obj/item/beartrap/proc/release_mob()
	unbuckle_mob()
	anchored = FALSE
	deployed = FALSE
	can_buckle = initial(can_buckle)
	update_icon()
	STOP_PROCESSING(SSobj, src)

//Attempting to resist out of a beartrap will be counted as using your hand on the trap.
/obj/item/beartrap/resist_buckle(mob/user)
	if (user == buckled_mob && !user.stunned)
		//We check stunned here, and a failure stuns the69ictim. This prevents someone from just spam-resisting and instantly killing themselves
		if (user.client)
			attack_hand(user)
		else
			//Fallback behaviour for possible future use of NPCs
			attempt_release(user, null)
	return FALSE //Returning false prevents the default resist behaviour of instantly releasing the trap

/***********************************
	Deployment
***********************************/

/obj/item/beartrap/attack_self(mob/user as69ob)
	..()
	if(locate(/obj/structure/multiz/ladder) in get_turf(user))
		to_chat(user, SPAN_NOTICE("You cannot place \the 69src69 here, there is a ladder."))
		return
	if(locate(/obj/structure/multiz/stairs) in get_turf(user))
		to_chat(user, SPAN_NOTICE("You cannot place \the 69src69 here, it needs a flat surface."))
		return
	if(!deployed && can_use(user))
		user.visible_message(
			SPAN_DANGER("69user69 starts to deploy \the 69src69."),
			SPAN_DANGER("You begin deploying \the 69src69!"),
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 25))
			user.visible_message(
				SPAN_DANGER("69user69 has deployed \the 69src69."),
				SPAN_DANGER("You have deployed \the 69src69!"),
				"You hear a latch click loudly."
				)

			aware_mobs = list()
			deployed = TRUE
			user.drop_from_inventory(src)
			update_icon()
			anchored = TRUE
			log_admin("69key_name(user)69 has placed \a 69src69 at (69x69,69y69,69z69).")

/***********************************
	Hurting69obs
***********************************/

//If an attempt to release the69ob fails, it digs in and deals69ore damage
/obj/item/beartrap/proc/fail_attempt(user, difficulty)
	if (!buckled_mob)
		return

	var/mob/living/L = buckled_mob
	//armour

	if( L.damage_through_armor(fail_damage, BRUTE, target_zone, ARMOR_MELEE, used_weapon = src) )
	//No damage - no stun
		L.Stun(4) //A short stun prevents spamming failure attempts
		shake_camera(user, 2, 1)

	if (ishuman(L))
		var/mob/living/carbon/human/H = L
		visible_message(SPAN_DANGER("\The 69src69 snaps back, digging deeper into 69buckled_mob.name69's 69H.get_organ(target_zone).name69"))
	else
		visible_message(SPAN_DANGER("\The 69src69 snaps back, digging deeper into 69buckled_mob.name69"))

	playsound(src, 'sound/effects/impacts/beartrap_shut.ogg', 10, 1,-2,-2)//Fairly 69uiet snapping sound

	if (difficulty)
		to_chat(user, SPAN_NOTICE("You failed to release the trap. There was a 69round(100 - difficulty)69% chance of success"))
		if (user == buckled_mob)
			to_chat(user, SPAN_NOTICE("Freeing yourself is69ery difficult. Perhaps you should call for help?"))



/obj/item/beartrap/proc/attack_mob(mob/living/L)
	//Small69obs won't trigger the trap
	//Imagine a69ouse running harmlessly over it
	if (!L || L.mob_size <69in_size)
		return

	if (ismech(L))
		deployed = FALSE
		playsound(src, 'sound/effects/impacts/beartrap_shut.ogg', 100, 1,10,10)
		return

	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick(BP_L_LEG, BP_R_LEG)

	deployed = FALSE
	can_buckle = initial(can_buckle)
	playsound(src, 'sound/effects/impacts/beartrap_shut.ogg', 100, 1,10,10)//Really loud snapping sound

	//armour
	if( L.damage_through_armor(fail_damage, BRUTE, target_zone, ARMOR_MELEE, used_weapon = src) )
	//No damage - no stun
		L.Stun(4) //A short stun prevents spamming failure attempts
		shake_camera(L, 2, 1)

	//trap the69ictim in place
	set_dir(L.dir)
	can_buckle = TRUE
	buckle_mob(L)
	to_chat(L, SPAN_DANGER("The steel jaws of \the 69src69 bite into you, trapping you in place!"))


	//If the69ictim is nonhuman and has no client, start processing.
	if (!ishuman(L) && !L.client)
		START_PROCESSING(SSobj, src)



/*
Beartraps process when a clientless69ob is trapped in them.
Periodically the69ob will attempt to struggle out. It will probably fail, take damage, and eventually die
Very rarely it69ight escape
*/
/obj/item/beartrap/Process()
	var/mob/living/L = buckled_mob

	//If its dead or gone, stop processing
	//Also stop if a player took control of it, they can try to free themselves
	if (69DELETED(L) || L.is_dead() || L.loc != loc || L.client)
		release_mob()		// Reset the trap properly if the roach was gibbed during the processing.
		return PROCESS_KILL

	if (L.incapacitated())
		//If it's not conscious and able, skip this process tick, but keep checking in future
		return

	//Chance each tick that the69ob will attempt to free itself
	if (prob(struggle_prob))
		attempt_release(L)



/obj/item/beartrap/Crossed(AM as69ob|obj)
	if(deployed && isliving(AM))
		if(locate(/obj/structure/multiz/ladder) in get_turf(loc))
			visible_message(SPAN_DANGER("\The 69src69's triggering69echanism is disrupted by the ladder and does not go off."))
			return ..()
		if(locate(/obj/structure/multiz/stairs) in get_turf(loc))
			visible_message(SPAN_DANGER("\The 69src69's triggering69echanism is disrupted by the slope and does not go off."))
			return ..()
		var/mob/living/L = AM
		var/true_prob_catch = prob_catch - L.skill_to_evade_traps()
		if("\ref69L69" in aware_mobs)
			if(MOVING_DELIBERATELY(L))
				return ..()
			else
				true_prob_catch -= 30
		if(!prob(true_prob_catch))
			return ..()
		L.visible_message(
			SPAN_DANGER("69L69 steps on \the 69src69."),
			SPAN_DANGER("You step on \the 69src69!"),
			"<b>You hear a loud69etallic snap!</b>"
			)

		attack_mob(L)
		if(!buckled_mob)
			anchored = FALSE
		deployed = FALSE
		update_icon()
	..()

/obj/item/beartrap/examine(mob/user)
	..()
	if(deployed && isliving(user) && !("\ref69user69" in aware_mobs))
		to_chat(user, SPAN_NOTICE("You're aware of this trap, now. You won't set it off when walking carefully."))
		aware_mobs |= "\ref69user69"


/obj/item/beartrap/update_icon()
	..()

	if(!deployed)
		icon_state = "69initial(icon_state)690"
	else
		icon_state = "69initial(icon_state)691"



/**********************************
	Makeshift Trap
**********************************/
/*
	Can be constructed from stuff you find in69aintenance
	Slightly worse stats all around
	Has integrity that depletes and it will eventually break
*/
/obj/item/beartrap/makeshift
	base_damage = 16
	fail_damage = 4
	base_difficulty = 80
	name = "jury-rigged69echanical trap"
	desc = "A wicked looking construct of spiky bits of69etal and wires. Will snap shut on anyone who steps in it. It'll do some nasty damage."
	icon_state = "sawtrap"
	matter = list(MATERIAL_STEEL = 15)
	var/integrity = 100


//It takes 5 damage whenever it snaps onto a69ob
/obj/item/beartrap/makeshift/attack_mob(mob/living/L)
	.=..()
	integrity -= 4
	spawn(5)
		check_integrity()

//Takes 1 damage every time they fail to open it
/obj/item/beartrap/makeshift/fail_attempt(var/user,69ar/difficulty)
	.=..()
	integrity -= 0.8
	spawn(5)
		check_integrity()

/obj/item/beartrap/makeshift/proc/check_integrity()
	if (prob(integrity))
		return

	break_apart()


/obj/item/beartrap/makeshift/proc/break_apart()
	visible_message(SPAN_DANGER("\the 69src69 shatters into fragments!"))
	new /obj/item/stack/material/steel(loc, 10)
	new /obj/item/material/shard/shrapnel(loc)
	new /obj/item/material/shard/shrapnel(loc)
	69del(src)


/**********************************
	Armed Subtypes
**********************************/
/*
	Used for random trap spawners.
	These start already deployed and will entrap the first creature that steps on it
*/

/obj/item/beartrap/armed
	deployed = TRUE
	anchored = TRUE
	rarity_value = 33.3
	spawn_fre69uency = 10
	spawn_tags = SPAWN_TAG_TRAP_ARMED

/obj/item/beartrap/makeshift/armed
	deployed = TRUE
	anchored = TRUE
	rarity_value = 22.2
	spawn_fre69uency = 10
	spawn_tags = SPAWN_TAG_TRAP_ARMED
