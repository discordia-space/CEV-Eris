//Look Sir, free crabs!
/mob/living/simple_animal/blob_seed
	name = "bloob seed"
	desc = "A jelly-like orange bean with green tentacles. Looks squishy."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_seed"
	icon_dead = "blob_seed_dead"
	density = 0
	mob_size = MOB_SMALL
	mob_bump_flag = 0
	mob_swap_flags = 0
	mob_push_flags = 0
	speak_chance = 0
	turns_per_move = 0
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	health = 10
	maxHealth = 10
	stop_automated_movement = TRUE
	wander = FALSE

	max_nutrition = 120
	nutrition_step = 1
	digest_factor = 0.1
	var/last_message = 0

/mob/living/simple_animal/blob_seed/New()
	. = ..()
	nutrition = max_nutrition/2

/mob/living/simple_animal/blob_seed/Life()
	..()
	if(nutrition > 0)
		if(nutrition > max_nutrition * 0.95)
			new /obj/effect/blob/core(get_turf(src))
			log_and_message_admins("Blob was spawned form bloob_seed.")
			Destroy()
			return
		if(buckled)
			if(isliving(buckled))
				if(last_message > world.time + 10 SECONDS)
					last_message = world.time
					if(prob(40))
						visible_message(SPAN_WARNING("\The [src] sucks juices from [buckled]!"))
					else if(prob(40))
						visible_message(SPAN_WARNING("\The [src] sweels!"))
					else
						visible_message(SPAN_WARNING("\The [src] digs deeper into [buckled] with it's tentacles!"))
				var/mob/living/M = buckled
				M.apply_damage(rand(5,15),TOX)
				if(M.stat == DEAD)
					nutrition += 2
				else
					nutrition += 1
			return
		else
			if(last_message > world.time + 10 SECONDS)
				last_message = world.time
				if(prob(40))
					visible_message(SPAN_WARNING("\The [src] stretches it's tentacles outwards, searching for prey."))
			var/mob/living/poor_soul
			// searching for living creature we can latch to
			for(var/mob/living/L in get_turf(src))
				if(L != src)
					poor_soul = L
					break
			if(!poor_soul)
				if(!hunger_enabled)
					hunger_enabled = TRUE
				return
			poor_soul.buckle_mob(src)
			// stops hunger, we are feasting
			hunger_enabled = FALSE
			visible_message(SPAN_WARNING("[src] latches onto \the [poor_soul]!"))
			last_message = world.time
			if(poor_soul.client && poor_soul.stat != DEAD)
				to_chat(poor_soul, SPAN_DANGER("You feel something burrowing under your skin."))
	else
		death()
			
/mob/living/simple_animal/blob_seed/attack_hand(mob/living/M as mob)
	if(M.a_intent == I_DISARM)
		if(buckled && isliving(buckled))
			var/mob/living/poor_soul = buckled
			poor_soul.unbuckle_mob(src)
			visible_message(SPAN_NOTICE("\The [M] dumps [src] from \the [poor_soul]!"))
		return
	else
		..()
	
	
