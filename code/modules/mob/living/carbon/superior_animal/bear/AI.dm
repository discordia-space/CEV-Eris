//Gradually build anger until we get enough to attack
/mob/living/carbon/superior_animal/bear/enter_attack_stance()
	if (angry())
		if (stance == HOSTILE_STANCE_IDLE)
			//Roar as we charge
			growl_loud()
		.=..()
	else
		//If we're not angry enough yet, growl and stare at the target for while
		if (target_mob)
			face_atom(target_mob) //Stand still and face them
			stop_automated_movement = TRUE
			anger++
			//Growls a lot when its getting ready to attack someone
			if (prob(35))
				visible_emote("[pick(emote_see)] [target_mob]")


/mob/living/carbon/superior_animal/bear/isValidAttackTarget(var/atom/O)
	if (islying(O) && !angry())
		//Bears won't attack if you play dead
		//Not a good combat tactic, but allows civilians to escape their attention
		//If the bear is already mad this tactic won't work
		return FALSE
	return ..()

/mob/living/carbon/superior_animal/bear/prepareAttackOnTarget()
	.=..()
	if (prob(25))
		speak_audio() //Roar a whole lot while we're in combat. It's confusing and terrifying



//Called when we want to bypass ticks and attack immediately. For example in response to being shot
//This calls several procs and some duplicated code from the parent class to immediately put us in an assault state and lash out
/mob/living/carbon/superior_animal/bear/proc/instant_aggro()
	anger = max(anger, anger_attack_threshold)
	if (stance < HOSTILE_STANCE_ATTACKING)
		growl_loud()
		stance = HOSTILE_STANCE_ATTACKING

		if(!target_mob)
			findTarget()
		if(target_mob)
			growl_loud()
			if(destroy_surroundings)
				destroySurroundings()
			move_to_target()
			prepareAttackOnTarget()//When first aggroed, this causes the bear to instantly lash out and counter any melee attacker nearby




//Called when someone hurts us. User optionally specifies who did it
/mob/living/carbon/superior_animal/bear/proc/damage_taken(var/delta, var/mob/user)
	//If that damage killed us, then we don't do anything
	if (stat == DEAD || health <= 0)
		return

	//If we know who did it, focus that asshole
	if (istype(user))
		target_mob = user
	//Get mad
	anger++
	instant_aggro()


//Various interactions will make bears mad
/mob/living/carbon/superior_animal/bear/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/healthbefore = health
	.=..()
	spawn(1)
		if (health < healthbefore)//Hurting the bear makes it mad
			damage_taken(healthbefore - health, user)


/mob/living/carbon/superior_animal/bear/attack_generic(var/mob/attacker, var/damage, var/attacktext, var/environment_smash)
	var/healthbefore = health
	.=..()
	spawn(1)
		if (health < healthbefore)//Hurting the bear makes it mad
			damage_taken(healthbefore - health, attacker)

/mob/living/carbon/superior_animal/bear/attack_hand(mob/living/carbon/human/M as mob)
	var/healthbefore = health
	.=..()
	spawn(1)
		if (health < healthbefore)//Hurting the bear makes it mad
			damage_taken(healthbefore - health, M)


/mob/living/carbon/superior_animal/bear/bullet_act(obj/item/projectile/P, def_zone)//Teleport around when shot, so its harder to burst it down with a carbine
	var/healthbefore = health
	.=..()
	spawn(1)
		if (health < healthbefore)
			//It doesn't understand guns enough to know who shot it. But bullet hurt make bear mad grr
			damage_taken(healthbefore - health)

/mob/living/carbon/superior_animal/bear/ex_act(var/severity = 2.0)
	var/healthbefore = health
	.=..()
	spawn(1)
		if (health < healthbefore)
			damage_taken(healthbefore - health)


/mob/living/carbon/superior_animal/bear/hitby(atom/movable/AM as mob|obj)
	var/healthbefore = health
	var/mob/attacker = AM.thrower
	.=..()
	spawn(1)
		if (health < healthbefore)
			damage_taken(healthbefore - health, attacker)
