/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags =69ONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags =69ONKEY|SLIME|SIMPLE_ANIMAL
	bad_type = /mob/living/simple_animal
	var/datum/component/spawner/nest

	var/show_stat_health = TRUE	//does the percentage health show in the stat panel for the69ob

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib =69ull	//We only try to show a gibbing animation if this exists.

	//Napping
	var/can_nap = FALSE
	var/icon_rest =69ull

	var/list/speak = list()
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this69ariable only show by themselves with69o spoken text. IE: Ian barks, Ian yaps

	var/turns_per_move = 1
	var/turns_since_move = 0
	universal_speak = 0		//No, just69o.
	var/meat_amount = 0
	var/meat_type
	var/stop_automated_movement = FALSE //Use this to temporarely stop random69ovement or to if you write special69ovement code for animals.
	var/wander = TRUE	// Does the69ob wander around when idle?
	var/stop_automated_movement_when_pulled = TRUE //When set to 1 this stops the animal from69oving when someone is pulling it.
	var/atom/movement_target =69ull//Thing we're69oving towards
	var/turns_since_scan = 0
	var/eat_from_hand = TRUE

	//Interaction
	var/response_help   = "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm   = "tries to hurt"
	var/harm_intent_damage = 3

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than69axbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than69inbodytemp
	var/fire_alert = 0

	//Atmos effect - Yes, you can69ake creatures that require plasma or co2 to survive.692O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and69e don't69ix (Yes, yes69ake all the dick jokes you want with that.) - Errorage
	var/min_oxy = 5
	var/max_oxy = 0					//Leaving something at 069eans it's off - has69o69aximum
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	var/speed = 2 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE69OBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower,69egative speed is faster

	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/attacktext = "attacked"
	var/attack_sound =69ull
	var/friendly = "nuzzles"
	var/environment_smash = 0
	var/resistance		  = 0	// Damage reduction

	//Null rod stuff
	var/supernatural = 0
	var/purge = 0

	//Hunger/feeding69ars
	var/hunger_enabled = 1//If set to 0, a creature ignores hunger
	max_nutrition = 50
	var/metabolic_factor = 1//A69ultiplier on how fast69utrition is lost. used to tweak the rates on a per-animal basis
	var/nutrition_step = 0.2 //nutrition lost per tick and per step, calculated from69ob_size, 0.2 is a fallback
	var/bite_factor = 0.4
	var/digest_factor = 0.2 //A69ultiplier on how quickly reagents are digested
	var/stomach_size_mult = 5

	//Food behaviour69ars
	var/autoseek_food = 1//If 0. this animal will69ot automatically eat
	var/beg_for_food = 1//If 0, this animal will69ot show interest in food held by a person
	var/min_scan_interval = 1//Minimum and69aximum69umber of procs between a foodscan. Animals will slow down if there's69o food around for a while
	var/max_scan_interval = 30
	var/scan_interval = 5//current scan interval, clamped between69in and69ax
	//It gradually increases up to69ax when its left alone, to save performance
	//It will drop back to 1 if it spies any food.
		//This short time69akes animals69ore responsive to interactions and69ore fun to play with

	var/seek_speed = 2//How69any tiles per second the animal will69ove towards food
	var/seek_move_delay
	var/scan_range = 6//How far around the animal will look for food
	var/foodtarget = 0
	//Used to control how often ian scans for69earby food

	sanity_damage = -0.01

	mob_classification = CLASSIFICATION_ORGANIC

/mob/living/simple_animal/proc/beg(var/atom/thing,69ar/atom/holder)
	visible_emote("gazes longingly at 69holder69's 69thing69")

/mob/living/simple_animal/New()
	..()
	if(!icon_living)
		icon_living = icon_state
	if(!icon_dead)
		icon_dead = "69icon_state69_dead"

	seek_move_delay = (1 / seek_speed) / (world.tick_lag / 10)//number of ticks between69oves
	turns_since_scan = rand(min_scan_interval,69ax_scan_interval)//Randomise this at the start so animals don't sync up

	verbs -= /mob/verb/observe

	if(mob_size)
		nutrition_step =69ob_size * 0.03 *69etabolic_factor
		bite_factor =69ob_size * 0.1
		max_nutrition *= 1 + (nutrition_step*4)//Max69utrition scales faster than costs, so bigger creatures eat less often
		create_reagents(stomach_size_mult*mob_size)
	else
		create_reagents(20)

/mob/living/simple_animal/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != DEAD)
			src.adjustNutrition(-nutrition_step)

/mob/living/simple_animal/Released()
	//These will cause69obs to immediately do things when released.
	scan_interval =69in_scan_interval
	turns_since_move = turns_per_move
	..()

/mob/living/simple_animal/Initialize(var/mapload)
	.=..()
	if (mapload && can_burrow)
		find_or_create_burrow(get_turf(src))

/mob/living/simple_animal/Login()
	if(src && src.client)
		src.client.screen =69ull
	..()


/mob/living/simple_animal/updatehealth()
	..()
	if (health <= 0 && stat != DEAD)
		death()

/mob/living/simple_animal/examine(mob/user)
	..()
	if(hunger_enabled)
		if (!nutrition)
			to_chat(user, SPAN_DANGER("It looks starving!"))
		else if (nutrition <69ax_nutrition *0.5)
			to_chat(user, SPAN_NOTICE("It looks hungry."))
		else if ((reagents.total_volume > 0 &&69utrition >69ax_nutrition *0.75) ||69utrition >69ax_nutrition *0.9)
			to_chat(user, "It looks full and contented.")
	if (health <69axHealth * 0.25)
		to_chat(user, SPAN_DANGER("It's grievously wounded!"))
	else if (health <69axHealth * 0.50)
		to_chat(user, SPAN_DANGER("It's badly wounded!"))
	else if (health <69axHealth * 0.75)
		to_chat(user, SPAN_WARNING("It's wounded."))
	else if (health <69axHealth)
		to_chat(user, SPAN_WARNING("It's a bit wounded."))

/mob/living/simple_animal/Life()
	.=..()

	if(!stasis)

		if(!.)
			return FALSE

		if(health <= 0 && stat != DEAD)
			death()
			return FALSE

		if(health >69axHealth)
			health =69axHealth

		handle_stunned()
		handle_weakened()
		handle_paralysed()
		handle_supernatural()

		process_food()
		handle_foodscanning()

		//Atmos
		var/atmos_suitable = 1

		var/atom/A = loc

		if(istype(A,/turf))
			var/turf/T = A

			var/datum/gas_mixture/Environment = T.return_air()

			if(Environment)

				if( abs(Environment.temperature - bodytemperature) > 40 )
					bodytemperature += ((Environment.temperature - bodytemperature) / 5)

				if(min_oxy)
					if(Environment.gas69"oxygen"69 <69in_oxy)
						atmos_suitable = 0
				if(max_oxy)
					if(Environment.gas69"oxygen"69 >69ax_oxy)
						atmos_suitable = 0
				if(min_tox)
					if(Environment.gas69"plasma"69 <69in_tox)
						atmos_suitable = 0
				if(max_tox)
					if(Environment.gas69"plasma"69 >69ax_tox)
						atmos_suitable = 0
				if(min_n2)
					if(Environment.gas69"nitrogen"69 <69in_n2)
						atmos_suitable = 0
				if(max_n2)
					if(Environment.gas69"nitrogen"69 >69ax_n2)
						atmos_suitable = 0
				if(min_co2)
					if(Environment.gas69"carbon_dioxide"69 <69in_co2)
						atmos_suitable = 0
				if(max_co2)
					if(Environment.gas69"carbon_dioxide"69 >69ax_co2)
						atmos_suitable = 0

		//Atmos effect
		if(bodytemperature <69inbodytemp)
			fire_alert = 2
			adjustBruteLoss(cold_damage_per_tick)
		else if(bodytemperature >69axbodytemp)
			fire_alert = 1
			adjustBruteLoss(heat_damage_per_tick)
		else
			fire_alert = 0

		if(!atmos_suitable)
			adjustBruteLoss(unsuitable_atoms_damage)

		if(!AI_inactive)
			//Speaking
			if(!client && speak_chance)
				if(rand(0,200) < speak_chance)
					visible_emote(emote_see)
					speak_audio()

			if(incapacitated())
				return TRUE

			//Movement
			turns_since_move++
			if(!client && !stop_automated_movement && wander && !anchored)
				if(isturf(loc) && !incapacitated() && canmove)		//This is so it only69oves if it's69ot inside a closet, gentics69achine, etc.
					if(turns_since_move >= turns_per_move)
						if(!(stop_automated_movement_when_pulled && pulledby)) //Soma animals don't69ove when pulled
							var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I69ention fuck BYOND
							moving_to = pick(cardinal)
							set_dir(moving_to)			//How about we turn them the direction they are69oving, yay.
							step_glide(src,69oving_to, DELAY2GLIDESIZE(0.5 SECONDS))
							turns_since_move = 0

	return TRUE

/mob/living/simple_animal/proc/visible_emote(message)
	if(islist(message))
		message = safepick(message)
	if(message)
		visible_message("<span class='name'>69src69</span> 69message69")

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

//Simple reagent processing for simple animals
//This allows animals to digest food, and only food
//Most drugs, poisons etc, are designed to work on carbons and affect69any69alues a simple animal doesnt have
/mob/living/simple_animal/proc/process_food()
	if (hunger_enabled)
		if (nutrition)
			adjustNutrition(-nutrition_step)//Bigger animals get hungry faster
			nutrition =69ax(0,min(nutrition,69ax_nutrition))//clamp the69alue
		else
			if (prob(3))
				to_chat(src, "You feel hungry...")

		if (!reagents || !reagents.total_volume)
			return

		for(var/datum/reagent/current in reagents.reagent_list)
			var/removed =69in(current.metabolism*digest_factor, current.volume)
			if (istype(current, /datum/reagent/organic/nutriment))//If its food, it feeds us
				var/datum/reagent/organic/nutriment/N = current
				adjustNutrition(removed*N.nutriment_factor)
				var/heal_amount = removed*N.regen_factor
				if (bruteloss > 0)
					var/n =69in(heal_amount, bruteloss)
					adjustBruteLoss(-n)
					heal_amount -=69
				if (fireloss && heal_amount)
					var/n =69in(heal_amount, fireloss)
					adjustFireLoss(-n)
					heal_amount -=69
				updatehealth()
			current.remove_self(removed)//If its69ot food, it just does69othing.69o fancy effects

/mob/living/simple_animal/can_eat()
	if (!hunger_enabled ||69utrition >69ax_nutrition * 0.9)
		return 0//full

	else if (nutrition >69ax_nutrition * 0.8)
		return 1//content

	else return 2//hungry

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	if(Proj.nodamage)
		if(istype(Proj, /obj/item/projectile/ion))
			Proj.on_hit(loc)
		return

	adjustBruteLoss(Proj.get_total_damage())
	return 0

/mob/living/simple_animal/rejuvenate()
	..()
	health =69axHealth
	density = initial(density)
	update_icons()

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as69ob)
	..()

	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("\blue 69M69 69response_help69 \the 69src69")

		if(I_DISARM)
			M.visible_message("\blue 69M69 69response_disarm69 \the 69src69")
			M.do_attack_animation(src)
			//TODO: Push the69ob away or something

		if(I_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return

			var/obj/item/grab/G =69ew /obj/item/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant =69

			M.visible_message("\red 69M69 has grabbed 69src69 passively!")
			M.do_attack_animation(src)

		if(I_HURT)
			adjustBruteLoss(harm_intent_damage)
			playsound(src, pick(punch_sound),60,1)
			M.visible_message("\red 69M69 69response_harm69 \the 69src69")
			M.do_attack_animation(src)

	return

/mob/living/simple_animal/attackby(var/obj/item/O,69ar/mob/user)
	if(istype(O, /obj/item/gripper))
		return ..(O, user)

	else if(istype(O, /obj/item/reagent_containers) || istype(O, /obj/item/stack/medical))
		..()

	else if(meat_type && (stat == DEAD))	//if the animal has a69eat, and if it is dead.
		if(QUALITY_CUTTING in O.tool_qualities)
			if(O.use_tool(user, src, WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_NORMAL, required_stat = STAT_BIO))
				harvest(user)
	else
		O.attack(src, user, user.targeted_organ)

/mob/living/simple_animal/hit_with_weapon(obj/item/O,69ob/living/user,69ar/effective_force,69ar/hit_zone)

	if(effective_force <= resistance)
		to_chat(user, SPAN_DANGER("This weapon is ineffective, it does69o damage."))
		return 2
	effective_force -= resistance
	.=..(O, user, effective_force, hit_zone)

/mob/living/simple_animal/movement_delay()
	var/tally =69OVE_DELAY_BASE //Incase I69eed to add stuff other than "speed" later

	tally += speed
	if(purge)//Purged creatures will69ove69ore slowly. The69ore time before their purge stops, the slower they'll69ove.
		if(tally <= 0)
			tally = 1
		tally *= purge

	if (!nutrition)
		tally += 4

	return tally

/mob/living/simple_animal/Stat()
	. = ..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: 69round((health /69axHealth) * 100)69%")

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!")
	walk_to(src,0)
	movement_target =69ull
	icon_state = icon_dead
	density = FALSE
	stasis = TRUE
	return ..(gibbed,deathmessage)

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		if (HUDtech.Find("flash"))
			flick("flash", HUDtech69"flash"69)
	switch (severity)
		if (1)
			adjustBruteLoss(500)
			gib()
			return

		if (2)
			adjustBruteLoss(60)


		if(3)
			adjustBruteLoss(30)



/mob/living/simple_animal/proc/SA_attackable(_target_mob)
	. = TRUE

	if(isliving(_target_mob))
		var/mob/living/L = _target_mob
		if(istype(_target_mob, /mob/living/exosuit))
			var/mob/living/exosuit/M = _target_mob
			if(length(M.pilots))
				return FALSE
		else if(!L.stat || L.health >= (ishuman(L) ? HEALTH_THRESHOLD_CRIT : 0))
			return FALSE

	if(istype(_target_mob, /obj/machinery/bot))
		var/obj/machinery/bot/B = _target_mob
		if(B.health > 0)
			return FALSE

/mob/living/simple_animal/get_speech_ending(verb,69ar/ending)
	return69erb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) //69o hands.
	W.loc = get_turf(src)
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user)
	var/actual_meat_amount =69ax(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat =69ew69eat_type(get_turf(src))
			meat.name = "69src.name69 69meat.name69"
		if(issmall(src))
			user.visible_message(SPAN_DANGER("69user69 chops up \the 69src69!"))
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message(SPAN_DANGER("69user69 butchers \the 69src6969essily!"))
			gib()

//Code to handle finding and69omming69earby food items
/mob/living/simple_animal/proc/handle_foodscanning()
	if (client || !hunger_enabled || !autoseek_food)
		return 0

	//Feeding, chasing food, FOOOOODDDD
	if(!incapacitated())

		turns_since_scan++
		if(turns_since_scan >= scan_interval)
			turns_since_scan = 0
			if(movement_target && (!(isturf(movement_target.loc) || ishuman(movement_target.loc)) || (foodtarget && !can_eat()) ))
				movement_target =69ull
				foodtarget = 0
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 7)) )
				walk_to(src,0)
				movement_target =69ull
				foodtarget = 0
				stop_automated_movement = 0
				if (can_eat())
					for(var/obj/item/reagent_containers/food/snacks/S in oview(src,7))
						if(isturf(S.loc) || ishuman(S.loc))
							movement_target = S
							foodtarget = 1
							break

					//Look for food in people's hand
					if (!movement_target && beg_for_food)
						var/obj/item/reagent_containers/food/snacks/F =69ull
						for(var/mob/living/carbon/human/H in oview(src,scan_range))
							if(istype(H.l_hand, /obj/item/reagent_containers/food/snacks))
								F = H.l_hand

							if(istype(H.r_hand, /obj/item/reagent_containers/food/snacks))
								F = H.r_hand

							if (F)
								movement_target = F
								foodtarget = 1
								break

			if(movement_target)
				scan_interval =69in_scan_interval
				stop_automated_movement = 1

				if (istype(movement_target.loc, /turf))
					walk_to(src,movement_target,0, seek_move_delay)//Stand ontop of food
				else
					walk_to(src,movement_target.loc,1, seek_move_delay)//Don't stand ontop of people



				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						set_dir(WEST)
					else if (movement_target.loc.x > src.x)
						set_dir(EAST)
					else if (movement_target.loc.y < src.y)
						set_dir(SOUTH)
					else if (movement_target.loc.y > src.y)
						set_dir(NORTH)
					else
						set_dir(SOUTH)

					if(isturf(movement_target.loc) && Adjacent(get_turf(movement_target), src))
						UnarmedAttack(movement_target)
						if (get_turf(movement_target) == loc)
							set_dir(pick(1,2,4,8,1,1))//Face a random direction when eating, but69ostly upwards
					else if(ishuman(movement_target.loc) && Adjacent(src, get_turf(movement_target)) && prob(15))
						beg(movement_target,69ovement_target.loc)
			else
				scan_interval =69ax(min_scan_interval,69in(scan_interval+1,69ax_scan_interval))//If69othing is happening, ian's scanning frequency slows down to save processing

//For picking up small animals
/mob/living/simple_animal/MouseDrop(atom/over_object)
	if (holder_type)//we69eed a defined holder type in order for picking up to work
		var/mob/living/carbon/H = over_object
		if(!istype(H) || !Adjacent(H))
			return ..()

		get_scooped(H, usr)
		return
	return ..()


/mob/living/simple_animal/handle_fire()
	return

/mob/living/simple_animal/update_fire()
	return
/mob/living/simple_animal/IgniteMob()
	return
/mob/living/simple_animal/ExtinguishMob()
	return


//I wanted to call this proc alert but it already exists.
//Basically69akes the69ob pay attention to the world, resets sleep timers, awakens it from a sleeping state sometimes
/mob/living/simple_animal/proc/poke(var/force_wake = 0)
	if (stat != DEAD)
		if (force_wake || (!client && prob(30)))
			wake_up()

//Puts the69ob to sleep
/mob/living/simple_animal/proc/fall_asleep()
	if (stat != DEAD)
		resting = TRUE
		stat = UNCONSCIOUS
		canmove = FALSE
		wander = FALSE
		walk_to(src,0)
		update_icons()

//Wakes the69ob up from sleeping
/mob/living/simple_animal/proc/wake_up()
	if (stat != DEAD)
		stat = CONSCIOUS
		resting = FALSE
		canmove = TRUE
		wander = TRUE
		update_icons()

/mob/living/simple_animal/update_icons()
	if (stat == DEAD)
		icon_state = icon_dead
	else if ((stat == UNCONSCIOUS || resting) && icon_rest)
		icon_state = icon_rest
	else if (icon_living)
		icon_state = icon_living

/mob/living/simple_animal/lay_down()
	set69ame = "Rest"
	set category = "Abilities"
	if(resting && can_stand_up())
		wake_up()
	else if (!resting)
		fall_asleep()
	to_chat(src, span("notice","You are69ow 69resting ? "resting" : "getting up"69"))
	update_icons()


//This is called when an animal 'speaks'. It does69othing here, but descendants should override it to add audio
/mob/living/simple_animal/proc/speak_audio()
	return

//Animals are generally good at falling, small ones are immune
/mob/living/simple_animal/get_fall_damage()
	return69ob_size - 1
