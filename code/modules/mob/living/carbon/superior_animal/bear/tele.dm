//An extremely mobile hunter, these creatures teleport around the vessel in search of prey.
/mob/living/carbon/superior_animal/bear/tele
	name = "bluespace bear"
	maxHealth = 350
	melee_damage_lower = 22
	melee_damage_upper = 38


	//Teleporting comes in two modes

	/*
		Strategic teleporting moves to a random area anywhere on the ship. Its usually only done outside
		of combat, while looking for prey
	*/
	var/teleport_delay_strategic = 60 SECONDS
	var/next_strategic_teleport = 0

	/*
		Tactical teleporting is done during combat with a target. It moves to a random tile in the same
		area as the target. This will often make it appear behind someone and attack from another angle
		Very disorienting
	*/
	var/teleport_delay_tactical = 5 SECONDS
	var/next_tactical_teleport = 0

	//Bear will flee if it takes too much damage
	var/escape_threshold = 200



//Teleports somewhere random, looking for prey
/mob/living/carbon/superior_animal/bear/tele/proc/teleport_strategic()
	var/attempts = 10 //Safety, just in case
	var/turf/T = null
	while (attempts > 0)
		var/area/A = random_ship_area(TRUE, FALSE)
		T = A.random_space()
		if(!T)
			//We somehow failed to find a turf, decrement i so we get another go
			attempts--
			continue
		break

	if (T)

		//If the bear is buckled into a trap, it can teleport out, but it hurts
		if (buckled)
			if (istype(buckled, /obj/item/weapon/beartrap))
				apply_damage(40, BRUTE, ran_zone(), 0, buckled)
				visible_message(SPAN_DANGER("[src] painfully tears its way free of the [buckled], leaving behind chunks of flesh and fur"))
			buckled.unbuckle_mob()



		if(do_teleport(src, T, 0))

			next_strategic_teleport = world.time + teleport_delay_strategic
			growl_soft() //Signal our arrival
			anger = max(anger-5, 0) //Escaping calms them down a bit
			escape_threshold = health - (maxHealth*rand_between(0.25, 0.4)) //Set the new escape threshold




/*Teleports somewhere in the vicinity of the target
Will usually only be called with a target, but sometimes we wont have one. In that case we just teleport
somewhere random near ourselves
*/
/mob/living/carbon/superior_animal/bear/tele/proc/teleport_tactical()
	//Being caught in a trap prevents shortrange teleporting
	if (buckled)
		return

	var/area/A
	var/turf/T = null
	if (target_mob)
		A = get_area(target_mob)
	else
		A = get_area(src)

	var/attempts = 10 //Safety, just in case
	while (attempts > 0)
		T = A.random_space()
		if(!T)
			//We somehow failed to find a turf, decrement i so we get another go
			attempts--
			continue
		break

	if (T)
		do_teleport(src, T, 0)
		next_tactical_teleport = world.time + teleport_delay_tactical


/*
	We handle automatic teleports in the life tick
*/
/mob/living/carbon/superior_animal/bear/tele/Life()
	. = ..()
	if(.)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				//If we're out of combat, teleport around the ship looking for targets
				if (world.time > next_strategic_teleport && !angry())
					teleport_strategic()

			else
				if (world.time > next_tactical_teleport)
					teleport_tactical()

/mob/living/carbon/superior_animal/bear/tele/enter_attack_stance()
	.=..()
	//Whenever it sees a target, delay the next strategic teleport.
	//This is so that it doesn't just vanish if it loses sight for a moment
	next_strategic_teleport = world.time + teleport_delay_strategic



/*
	Upon taking damage, the bear will often do a reactive tactical teleport to evade farther hits
	This bypasses the cooldown, but also sets it for the next passive one
	If its taken a lot of total damage, it will flee from the battle entirely
*/
/mob/living/carbon/superior_animal/bear/tele/damage_taken(var/delta, var/mob/user)
	.=..()

	if (delta && prob(delta*1.5))
		if (health < escape_threshold)
			teleport_strategic()
		else
			teleport_tactical()