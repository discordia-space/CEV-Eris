/obj/item/weapon/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/traps.dmi'
	icon_state = "beartrap"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = 0
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 25)
	edge = TRUE
	sharp = TRUE
	var/deployed = 0

	var/base_damage = 20
	var/fail_damage = 5
	var/base_difficulty = 80
	var/time_to_escape = 40
	var/target_zone
	var/min_size = 5 //Mobs smaller than this won't trigger the trap
	var/struggle_prob = 2


/obj/item/weapon/beartrap/Initialize()
	.=..()
	update_icon()


/***********************************
	Releasing Mobs
***********************************/

/*
When someone is trapped in a beartrap, anyone (victim or other) can attempt to free them
They can do this either with their bare hands or with a prying tool for better odds.
This is a very difficult task and it will frequently fail the first few times.
Every failure causes the trap to dig deeper and hurt the victim more

Freeing yourself is much harder than freeing someone else. Calling for help is advised if practical
*/
/obj/item/weapon/beartrap/proc/attempt_release(var/mob/living/user, var/obj/item/I)
	if (!buckled_mob || QDELETED(buckled_mob))
		return //Nobody there to rescue?

	if (!user)
		return //No user, or too far away

	//How hard will this be? The chance of failure
	var/difficulty = base_difficulty

	//Does the user have the dexterity to operate the trap?
	if (!can_use(user))
		//If they don't, then they're probably some kind of animal trapped in it
		if (user != buckled_mob)
			//Such a creature can't free someone else
			return

		//But they can attempt to struggle out on their own. At a very low success rate
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
			user << SPAN_NOTICE("The [I] gives you extra leverage")
			var/reduction = I.get_tool_quality(QUALITY_PRYING)
			if (user == buckled_mob)
				reduction *= 0.66 //But it helps less if you don't have good leverage
			difficulty -= reduction
			I.consume_resources(time_to_escape*3, user)


		//How about your stats? Being strong or crafty helps.
		//We'll subtract the highest of either robustness or mechanical, from the difficulty
		var/reduction = user.stats.getStat(list(STAT_MAX, STAT_ROB, STAT_MEC))
		if (user == buckled_mob)
			reduction *= 0.66 //But it helps less if you don't have good leverage
		difficulty -= reduction

	//Alright we calculated the difficulty, now lets do the attempt

	//Firstly a visible message
	if (buckled_mob == user)
		user.visible_message(
			"<span class='notice'>\The [user] tries to free themselves from \the [src].</span>",
			"<span class='notice'>You carefully begin to free yourself from \the [src].</span>",
			"<span class='notice'>You hear metal creaking.</span>"
			)
	else
		user.visible_message(
			"<span class='notice'>\The [user] tries to free \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You carefully begin to free \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You hear metal creaking.</span>"
			)

	//Play a metal creaking sound
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
			"<span class='notice'>[user] successfully releases [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You successfully release [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You hear metal creaking.</span>"
			)
	release_mob()


//Using a crowbar allows you to lever the trap open, better success rate
/obj/item/weapon/beartrap/attackby(obj/item/C, mob/living/user)
	if (C.has_quality(QUALITY_PRYING))
		attempt_release(user, C)
		return
	.=..()

/obj/item/weapon/beartrap/attack_hand(mob/user as mob)
	if (buckled_mob)
		attempt_release(user)
		return
	.=..()

/obj/item/weapon/beartrap/attack_generic(var/mob/user, var/damage)
	if (buckled_mob)
		attempt_release(user)
		return
	.=..()


/obj/item/weapon/beartrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/weapon/beartrap/proc/release_mob()
	//user.visible_message("<span class='notice'>\The [buckled_mob] has been freed from \the [src] by \the [user].</span>")
	unbuckle_mob()
	anchored = 0
	can_buckle = initial(can_buckle)
	update_icon()
	STOP_PROCESSING(SSobj, src)




/***********************************
	Deployment
***********************************/

/obj/item/weapon/beartrap/attack_self(mob/user as mob)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 25))
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)

			deployed = 1
			user.drop_from_inventory(src)
			update_icon()
			anchored = 1





/***********************************
	Hurting Mobs
***********************************/

//If an attempt to release the mob fails, it digs in and deals more damage
/obj/item/weapon/beartrap/proc/fail_attempt(var/user, var/difficulty)
	if (!buckled_mob)
		return

	var/mob/living/L = buckled_mob
	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	if(blocked >= 100)
		return

	if (ishuman(L))
		var/mob/living/carbon/human/H = L
		visible_message(SPAN_DANGER("\The [src] snaps back, digging deeper into [buckled_mob.name]'s [H.get_organ(target_zone).name]"))
	else
		visible_message(SPAN_DANGER("\The [src] snaps back, digging deeper into [buckled_mob.name]"))
	L.apply_damage(fail_damage, BRUTE, target_zone, blocked, src)
	playsound(src, 'sound/effects/impacts/beartrap_shut.ogg', 10, 1,-2,-2)//Fairly quiet snapping sound

	if (difficulty)
		user << SPAN_NOTICE("You failed to release the trap. There was a [round(100 - difficulty)]% chance of success")
		if (user == buckled_mob)
			user << SPAN_NOTICE("Freeing yourself is very difficult. Perhaps you should call for help?")

/obj/item/weapon/beartrap/proc/attack_mob(mob/living/L)
	//Small mobs won't trigger the trap
	//Imagine a mouse running harmlessly over it
	if (!L || L.mob_size < min_size)
		return

	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick("l_leg", "r_leg")

	deployed = 0
	can_buckle = initial(can_buckle)
	playsound(src, 'sound/effects/impacts/beartrap_shut.ogg', 100, 1,10,10)//Really loud snapping sound


	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	if(blocked >= 100)
		return

	var/success = L.apply_damage(base_damage, BRUTE, target_zone, blocked, src)
	if(!success)
		return 0

	//trap the victim in place
	set_dir(L.dir)
	can_buckle = 1
	buckle_mob(L)
	L << "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>"


	//If the victim is nonhuman and has no client, start processing.
	if (!ishuman(L) && !L.client)
		START_PROCESSING(SSobj, src)



/*
Beartraps process when a clientless mob is trapped in them.
Periodically the mob will attempt to struggle out. It will probably fail, take damage, and eventually die
Very rarely it might escape
*/
/obj/item/weapon/beartrap/Process()
	var/mob/living/L = buckled_mob

	//If its dead or gone, stop processing
	//Also stop if a player took control of it, they can try to free themselves
	if (QDELETED(L) || L.stat == DEAD || L.loc != loc || L.client)
		return PROCESS_KILL

	if (L.incapacitated())
		//If it's not conscious and able, skip this process tick, but keep checking in future
		return

	//Chance each tick that the mob will attempt to free itself
	if (prob(struggle_prob))
		attempt_release(L)



/obj/item/weapon/beartrap/Crossed(AM as mob|obj)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		L.visible_message(
			"<span class='danger'>[L] steps on \the [src].</span>",
			"<span class='danger'>You step on \the [src]!</span>",
			"<b>You hear a loud metallic snap!</b>"
			)
		attack_mob(L)
		if(!buckled_mob)
			anchored = 0
		deployed = 0
		update_icon()
	..()




/obj/item/weapon/beartrap/update_icon()
	..()

	if(!deployed)
		icon_state = "[initial(icon_state)]0"
	else
		icon_state = "[initial(icon_state)]1"



/**********************************
	Makeshift Trap
**********************************/
/*
	Can be constructed from stuff you find in maintenance
	Slightly worse stats all around
	Has integrity that depletes and it will eventually break
*/
/obj/item/weapon/beartrap/makeshift
	base_damage = 16
	fail_damage = 4
	base_difficulty = 75
	name = "jury-rigged mechanical trap"
	desc = "A wicked looking construct of spiky bits of metal and wires. Will snap shut on anyone who steps in it. It'll do some nasty damage."
	icon_state = "sawtrap"
	matter = list(DEFAULT_WALL_MATERIAL = 15)
	var/integrity = 100


//It takes 5 damage whenever it snaps onto a mob
/obj/item/weapon/beartrap/makeshift/attack_mob(mob/living/L)
	.=..()
	integrity -= 5
	check_integrity()

//Takes 1 damage every time they fail to open it
/obj/item/weapon/beartrap/makeshift/fail_attempt(var/user, var/difficulty)
	.=..()
	integrity -= 1
	check_integrity()

/obj/item/weapon/beartrap/makeshift/proc/check_integrity()
	if (prob(integrity))
		return

	break_apart()


/obj/item/weapon/beartrap/makeshift/proc/break_apart()
	visible_message(SPAN_DANGER("\the [src] shatters into fragments!"))
	new /obj/item/stack/material/steel(loc, 10)
	new /obj/item/weapon/material/shard/shrapnel(loc)
	new /obj/item/weapon/material/shard/shrapnel(loc)
	qdel(src)


/**********************************
	Armed Subtypes
**********************************/
/*
	Used for random trap spawners.
	These start already deployed and will entrap the first creature that steps on it
*/

/obj/item/weapon/beartrap/armed
	deployed = TRUE



/obj/item/weapon/beartrap/makeshift/armed
	deployed = TRUE
