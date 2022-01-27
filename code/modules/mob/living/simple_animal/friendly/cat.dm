//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon_state = "cat2"
	item_state = "cat2"
	speak_emote = list("purrs", "meows")
	emote_see = list("shakes their head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/mob/flee_target
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	holder_type = /obj/item/holder/cat
	mob_size =69OB_SMALL
	possession_candidate = 1

	scan_range = 3//less aggressive about stealing food
	metabolic_factor = 0.75
	var/mob/living/simple_animal/mouse/mousetarget =69ull
	seek_speed = 5
	pass_flags = PASSTABLE

/mob/living/simple_animal/cat/Life()
	..()

	if(!stasis)
		if (turns_since_move > 5 || (flee_target ||69ousetarget))
			walk_to(src,0)
			turns_since_move = 0

			if (flee_target) //fleeing takes precendence
				handle_flee_target()
			else
				handle_movement_target()

		if (!movement_target)
			walk_to(src,0)

		spawn(2)
			attack_mice()

		if(prob(2)) //spooky
			var/mob/observer/ghost/spook = locate() in range(src,5)
			if(spook)
				var/turf/T = spook.loc
				var/list/visible = list()
				for(var/obj/O in T.contents)
					if(!O.invisibility && O.name)
						visible += O
				if(visible.len)
					var/atom/A = pick(visible)
					visible_emote("suddenly stops and stares at something unseen69istype(A) ? "69ear 69A69":""69.")

/mob/living/simple_animal/cat/proc/handle_movement_target()
	//if our target is69either inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target =69ull
		stop_automated_movement = 0
	//if we have69o target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target =69ull
		stop_automated_movement = 0

	if(movement_target)
		stop_automated_movement = 1
		walk_to(src,movement_target,0,seek_move_delay)

/mob/living/simple_animal/cat/proc/attack_mice()
	if((loc) && isturf(loc))
		if(!incapacitated())
			for(var/mob/living/simple_animal/mouse/M in oview(src,1))
				if(M.stat != DEAD)
					M.splat()
					visible_emote(pick("bites \the 69M69!","toys with \the 69M69.","chomps on \the 69M69!"))
					movement_target =69ull
					stop_automated_movement = 0
					if (prob(75))
						break//usually only kill one69ouse per proc

/mob/living/simple_animal/cat/beg(var/atom/thing,69ar/atom/holder)
	visible_emote("licks its lips and hungrily glares at 69holder69's 69thing.name69")

/mob/living/simple_animal/cat/Released()
	//A thrown cat will immediately attack69ice69ear where it lands
	handle_movement_target()
	spawn(3)
		attack_mice()
	..()

/mob/living/simple_animal/cat/proc/handle_flee_target()
	//see if we should stop fleeing
	if (flee_target && !(flee_target.loc in69iew(src)))
		flee_target =69ull
		stop_automated_movement = 0

	if (flee_target)
		if(prob(25)) say("HSSSSS")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)

/mob/living/simple_animal/cat/proc/set_flee_target(atom/A)
	if(A)
		flee_target = A
		turns_since_move = 5

/mob/living/simple_animal/cat/attackby(var/obj/item/O,69ar/mob/user)
	. = ..()
	if(O.force)
		set_flee_target(user? user : src.loc)

/mob/living/simple_animal/cat/attack_hand(mob/living/carbon/human/M as69ob)
	. = ..()
	if(M.a_intent == I_HURT)
		set_flee_target(M)

/mob/living/simple_animal/cat/ex_act()
	. = ..()
	set_flee_target(src.loc)

/mob/living/simple_animal/cat/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	set_flee_target(proj.firer? proj.firer : src.loc)

/mob/living/simple_animal/cat/hitby(atom/movable/AM)
	. = ..()
	set_flee_target(AM.thrower? AM.thrower : src.loc)

/mob/living/simple_animal/cat/MouseDrop(atom/over_object)

	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

	if(H.a_intent == I_HELP)
		get_scooped(H)
		return
	else
		return ..()

//Cats always land on their feet
/mob/living/simple_animal/cat/get_fall_damage()
	return 0

//Basic friend AI
/mob/living/simple_animal/cat/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job =69ull

/mob/living/simple_animal/cat/fluff/handle_movement_target()
	if (friend)
		var/follow_dist = 5
		if (friend.stat >= DEAD || friend.health <= HEALTH_THRESHOLD_SOFTCRIT) //danger
			follow_dist = 1
		else if (friend.stat || friend.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist =69ax(follow_dist - 2, 1)
		var/current_dist = get_dist(src, friend)

		if (movement_target != friend)
			if (current_dist > follow_dist && !ismouse(movement_target) && (friend in oview(src)))
				//stop existing69ovement
				walk_to(src,0)
				turns_since_scan = 0

				//walk to friend
				stop_automated_movement = 1
				movement_target = friend
				walk_to(src,69ovement_target,69ear_dist, seek_move_delay)

		//already following and close enough, stop
		else if (current_dist <=69ear_dist)
			walk_to(src,0)
			movement_target =69ull
			stop_automated_movement = 0
			if (prob(10))
				say("Meow!")

	if (!friend ||69ovement_target != friend)
		..()

/mob/living/simple_animal/cat/fluff/Life()
	..()
	if (stat || !friend)
		return
	if (get_dist(src, friend) <= 1)
		if (friend.stat >= DEAD || friend.health <= HEALTH_THRESHOLD_SOFTCRIT)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("meows", "mews", "mrowls")
				visible_emote(pick("69verb69 in distress.", "69verb69 anxiously."))

		else
			if (prob(5))
				var/msg5 = (pick("nuzzles 69friend69.",
								   "brushes against 69friend69.",
								   "rubs against 69friend69.",
								   "purrs."))
				src.visible_message("<span class='name'>69src69</span> 69msg569.")
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			visible_emote("69verb69 anxiously.")

/mob/living/simple_animal/cat/fluff/verb/friend()
	set69ame = "Become Friends"
	set category = "IC"
	set src in69iew(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Meow!")
		return

	if (ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(H.job == befriend_job)
			friend = usr
			set_dir(get_dir(src, friend))
			say("Meow!")
			return

	to_chat(usr, SPAN_NOTICE("69src69 ignores you."))
	return


//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of69elvet, and her tail quivers occasionally."
	gender = FEMALE
	icon_state = "cat"
	item_state =  "cat"
	befriend_job = "Moebius Biolab Officer"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	item_state = "kitten"
	gender =69EUTER

// Leaving this here for69ow.
/obj/item/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones!69eow."
	gender =69ALE
	icon_state = "cat3"
	item_state = "cat3"

/mob/living/simple_animal/cat/fluff/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, research cat.69eow."
	gender =69ALE
	icon_state = "cat3"
	item_state = "cat3"
	holder_type = /obj/item/holder/cat/fluff/bones
	befriend_job = "Moebius Biolab Officer"
	var/friend_name = "Erstatz69ryroxes"

/mob/living/simple_animal/cat/kitten/New()
	gender = pick(MALE, FEMALE)
	..()

// Runtime cat

var/cat_cooldown = 20 SECONDS
var/cat_max_number = 10
var/cat_teleport = 0.0
var/cat_number = 0

/mob/living/simple_animal/cat/runtime
	name = "Dusty"
	desc = "A bluespace denizen that purrs its way into our dimension when the69ery fabric of reality is teared apart."
	icon_state = "runtimecat"
	item_state = "runtimecat"
	density = 0
	anchored = TRUE  // So that people cannot pull Dusty
	mob_size =69OB_HUGE // So that people cannot put Dusty in lockers to69ove it

	status_flags = GODMODE // Bluespace cat
	min_oxy = 0
	minbodytemp = 0
	maxbodytemp = INFINITY
	autoseek_food = 0
	metabolic_factor = 0.0

	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	var/cat_life_duration = 169INUTES

/mob/living/simple_animal/cat/runtime/New(loc)
	..(loc)
	stats.addPerk(PERK_TERRIBLE_FATE)
	cat_number += 1
	playsound(loc, 'sound/effects/teleport.ogg', 50, 1)
	spawn(cat_life_duration)
		qdel(src)

/mob/living/simple_animal/cat/runtime/Destroy()
	// We teleport Dusty in the corner of one of the ship zlevel for stylish disparition
	do_teleport(src, get_turf(locate(1, 1, pick(GLOB.maps_data.station_levels))), 2, 0,69ull,69ull, 'sound/effects/teleport.ogg', 'sound/effects/teleport.ogg')
	cat_number -= 1
	return ..()

/mob/living/simple_animal/cat/runtime/attackby(var/obj/item/O,69ar/mob/user)
	visible_message(SPAN_DANGER("69user69's 69O.name69 harmlessly passes through \the 69src69."))
	strike_back(user)

/mob/living/simple_animal/cat/runtime/attack_hand(mob/living/carbon/human/M as69ob)

	switch(M.a_intent)

		if(I_HELP)  // Pet the cat
			M.visible_message(SPAN_NOTICE("69M69 pets \the 69src69."))

		if(I_DISARM)
			M.visible_message(SPAN_NOTICE("69M69's hand passes through \the 69src69."))
			M.do_attack_animation(src)

		if(I_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return

			M.visible_message(SPAN_NOTICE("69M69's hand passes through \the 69src69."))
			M.do_attack_animation(src)

		if(I_HURT)
			var/datum/gender/G = gender_datums69M.gender69
			M.visible_message(SPAN_WARNING("69M69 tries to kick \the 69src69 but 69G.his69 foot passes through."))
			M.do_attack_animation(src)
			visible_message(SPAN_WARNING("\The 69src69 hisses."))
			strike_back(M)

	return

/mob/living/simple_animal/cat/runtime/proc/strike_back(var/mob/target_mob)
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob,/mob/living/exosuit))
		var/mob/living/exosuit/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return69
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/cat/runtime/set_flee_target(atom/A)
	return

/mob/living/simple_animal/cat/runtime/bullet_act(var/obj/item/projectile/proj)
	return PROJECTILE_FORCE_MISS

/mob/living/simple_animal/cat/runtime/ex_act(severity)
	return

/mob/living/simple_animal/cat/runtime/singularity_act()
	return

/mob/living/simple_animal/cat/runtime/MouseDrop(atom/over_object)
	return
