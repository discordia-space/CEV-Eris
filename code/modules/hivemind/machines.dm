//Hivemind69arious69achines

#define REGENERATION_SPEED 		4



/obj/machinery/hivemind_machine
	name = "strange69achine"
	icon = 'icons/obj/hivemind_machines.dmi'
	icon_state = "infected_machine"
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	var/illumination_color = 	COLOR_LIGHTING_CYAN_MACHINERY
	var/wireweeds_required =	TRUE		//machine got damage if there's no any wireweed on it's turf
	var/health = 				60
	var/max_health = 			60
	var/can_regenerate =		TRUE
	var/regen_cooldown_time = 	30 SECONDS	//min time to regeneration activation since last damage taken
	var/resistance = RESISTANCE_FRAGILE		//reduction on incoming damage
	var/cooldown_time = 10 SECONDS			//each69achine have their ability, this is cooldown of them
	var/global_cooldown = FALSE				//if true, ability will be used only once in whole world, before cooldown reset
	var/datum/hivemind_sdp/SDP				//Self-Defense Protocol holder
	var/list/spawned_creatures = list()		//which69obs69achine can spawns, insert paths
	var/spawn_weight = 10					//weight of this69achine, how frequently they will spawn
	var/evo_level_required = 	0 			//how69uch EP hivemind69ust have to spawn this, used in price list to comparison
	//internal
	var/cooldown = 0						//cooldown in world.time69alue
	var/time_until_regen = 0
	var/obj/assimilated_machinery
	var/obj/item/electronics/circuitboard/saved_circuit

/obj/machinery/hivemind_machine/Initialize()
	. = ..()
	name_pick()
	health =69ax_health
	set_light(2, 3, illumination_color)


/obj/machinery/hivemind_machine/update_icon()
	overlays.Cut()
	if(stat & EMPED)
		icon_state = "69icon_state69-disabled"
	else
		icon_state = initial(icon_state)


/obj/machinery/hivemind_machine/examine(mob/user)
	..()
	if (health <69ax_health * 0.1)
		to_chat(user, SPAN_DANGER("It's almost nothing but scrap!"))
	else if (health <69ax_health * 0.25)
		to_chat(user, SPAN_DANGER("It's seriously fucked up!"))
	else if (health <69ax_health * 0.50)
		to_chat(user, SPAN_DANGER("It's69ery damaged; you can almost see the components inside!"))
	else if (health <69ax_health * 0.75)
		to_chat(user, SPAN_WARNING("It has numerous dents and deep scratches."))
	else if (health <69ax_health)
		to_chat(user, SPAN_WARNING("It's a bit scratched and dented."))


/obj/machinery/hivemind_machine/Process()
	if(wireweeds_required && !locate(/obj/effect/plant/hivemind) in loc)
		take_damage(5, on_damage_react = FALSE)

	if(SDP)
		SDP.check_conditions()

	if(hive_mind_ai && !(stat & EMPED) && !is_on_cooldown())
		//slow health regeneration
		if(can_regenerate && (health !=69ax_health) && (world.time > time_until_regen))
			health += REGENERATION_SPEED
			if(health >69ax_health)
				health =69ax_health

		return TRUE


/obj/machinery/hivemind_machine/state(var/msg)
	. = ..()
	playsound(src, "robot_talk_heavy", 50, 1)



//Machinery consumption
//Deleting things is a bad idea and cause lot of problems
//So, now we just hide our assimilated69achine and69ake it broken (temporary)
//When our69achine dies, assimilated69achinery just unhide back
/obj/machinery/hivemind_machine/proc/consume(var/obj/victim)
	assimilated_machinery =69ictim
	victim.alpha = 0
	victim.anchored = TRUE
	victim.mouse_opacity =69OUSE_OPACITY_TRANSPARENT
	if(istype(victim, /obj/machinery))
		var/obj/machinery/target =69ictim
		target.stat |= BROKEN
		if(istype(victim, /obj/machinery/power/apc)) //APCs would be deleted
			assimilated_machinery = null
			qdel(victim)


/obj/machinery/hivemind_machine/proc/drop_assimilated()
	if(assimilated_machinery)
		assimilated_machinery.alpha 		= 	initial(assimilated_machinery.alpha)
		assimilated_machinery.mouse_opacity = 	initial(assimilated_machinery.mouse_opacity)
		assimilated_machinery.anchored 		= 	initial(assimilated_machinery.anchored)
		if(istype(assimilated_machinery, /obj/machinery))
			var/obj/machinery/consumed = assimilated_machinery
			consumed.stat &= ~BROKEN



//Sets ability cooldown
//Must be set69anually
/obj/machinery/hivemind_machine/proc/set_cooldown()
	if(global_cooldown)
		hive_mind_ai.global_abilities_cooldown69type69 = world.time + cooldown_time
	else
		cooldown = world.time + cooldown_time


/obj/machinery/hivemind_machine/proc/is_on_cooldown()
	if(global_cooldown)
		if(hive_mind_ai && hive_mind_ai.global_abilities_cooldown69type69)
			if(world.time >= hive_mind_ai.global_abilities_cooldown69type69)
				hive_mind_ai.global_abilities_cooldown69type69 = null
				return FALSE
		else
			return FALSE

	else
		if(world.time >= cooldown)
			return FALSE

	return TRUE


//Ability code goes here
//Ability is a special act
/obj/machinery/hivemind_machine/proc/use_ability(atom/target)
	return


/obj/machinery/hivemind_machine/proc/name_pick()
	if(hive_mind_ai)
		if(prob(50))
			name = "69hive_mind_ai.name69 69name69 - 69rand(999)69"
		else
			name = "69name69 69hive_mind_ai.surname69 - 69rand(999)69"


/obj/machinery/hivemind_machine/proc/start_rebuild(var/new_machine_path,69ar/time_in_seconds = 5)
	stun()
	var/obj/effect/overlay/rebuild_anim = new /obj/effect/overlay(loc)
	rebuild_anim.icon = 'icons/obj/hivemind_machines.dmi'
	rebuild_anim.icon_state = "rebuild"
	rebuild_anim.anchored = TRUE
	rebuild_anim.density = FALSE
	addtimer(CALLBACK(src, .proc/finish_rebuild, new_machine_path), time_in_seconds SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, rebuild_anim), time_in_seconds SECONDS)


/obj/machinery/hivemind_machine/proc/finish_rebuild(var/new_machine_path)
	var/obj/machinery/hivemind_machine/new_machine = new new_machine_path(get_turf(loc))
	if(assimilated_machinery69"path"69)
		new_machine.assimilated_machinery = assimilated_machinery
	if(saved_circuit)
		saved_circuit.loc = new_machine
		new_machine.saved_circuit = saved_circuit
	qdel(src)



//Returns list of69obs in range or hearers (include in69ehicles)
/obj/machinery/hivemind_machine/proc/targets_in_range(var/range = world.view,69ar/in_hear_range = FALSE)
	var/list/range_list = list()
	var/list/target_list = list()
	if(in_hear_range)
		range_list = hearers(range, src)
	else
		range_list = range(range, src)
	for(var/atom/movable/M in range_list)
		var/mob/target =69.get_mob()
		if(target)
			target_list += target
	return target_list


/obj/machinery/hivemind_machine/proc/is_attackable(mob/living/target)
	if(!target.stat || target.health >= (ishuman(target) ? HEALTH_THRESHOLD_CRIT : 0))
		return TRUE
	return FALSE


/////////////////////////69             69//////////////////////////
/////////////////////////>RESPONSE CODE<//////////////////////////
//////////////////////////_____________///////////////////////////


//When69achine takes damage it can react somehow
/obj/machinery/hivemind_machine/proc/damage_reaction()
	if(prob(30))
		if(prob(80))
			var/pain_msg = pick("User complaint recorded.", "Cease resistance.", "You are wasting resources.",
								"Yield to69inimize your pain.", "Response team summoned.", "Surrender.", "You cannot stop progress.", "Your flesh weakens.")
			state("says: \"<b>69pain_msg69</b>\"")
		else
			var/pain_emote = pick("twitches uncannily.", "contorts sickeningly.", "oozes silvery pus.", "congeals grey ichor in the wound.", "bleeds black fuming liquid")
			state(pain_emote)

	if(prob(40))
		playsound(src, "sparks", 60, 1)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 3, loc)
		sparks.start()


/obj/machinery/hivemind_machine/proc/take_damage(var/amount,69ar/on_damage_react = TRUE)
	health -= amount
	time_until_regen = world.time + regen_cooldown_time
	if(on_damage_react)
		damage_reaction()
	if(health <= 0)
		destruct()


/obj/machinery/hivemind_machine/proc/destruct()
	playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1)
	gibs(loc, null, /obj/effect/gibspawner/robot)
	drop_assimilated()
	var/obj/effect/plant/hivemind/wireweed = locate() in loc
	if(wireweed)
		wireweed.die_off()
	qdel(src)


//Stunned69achines can't do anything
//Amount69ust be a number in seconds
/obj/machinery/hivemind_machine/proc/stun(var/amount)
	set_light(0)
	stat |= EMPED
	can_regenerate = FALSE
	update_icon()
	if(amount)
		addtimer(CALLBACK(src, .proc/unstun), amount SECONDS)


/obj/machinery/hivemind_machine/proc/unstun()
	stat &= ~EMPED
	can_regenerate = initial(can_regenerate)
	update_icon()
	set_light(2, 3, illumination_color)


/obj/machinery/hivemind_machine/bullet_act(obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	if(istype(Proj, /obj/item/projectile/ion))
		Proj.on_hit(loc)
	. = ..()


/obj/machinery/hivemind_machine/attackby(obj/item/I,69ob/user)
	if(!(I.flags & NOBLUDGEON) && I.force)
		user.do_attack_animation(src)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/clear_damage = I.force - resistance

		if(clear_damage)
			. = ..()
			take_damage(clear_damage)
		else
			to_chat(user, SPAN_WARNING("You trying to hit the 69src69 with 69I69, but it seems useless."))
			playsound(src, 'sound/weapons/Genhit.ogg', 30, 1)
		return

	if(istype(I, /obj/item/device/flash))
		var/obj/item/device/flash/flash = I
		if(!flash.broken)
			playsound(user, 'sound/weapons/flash.ogg', 100, 1)
			flick("flash2", flash)
			flash.times_used++
			flash.flash_recharge()
			damage_reaction()
			stun(10)


/obj/machinery/hivemind_machine/ex_act(severity)
	switch(severity)
		if(1)
			take_damage(80)
		if(2)
			take_damage(30)
		if(3)
			take_damage(10)


/obj/machinery/hivemind_machine/emp_act(severity)
	switch(severity)
		if(1)
			take_damage(60)
			stun(20)
		if(2)
			take_damage(30)
			stun(8)
	..()


/////////////////////////////////////////////////////////////
/////////////////////////>MACHINES<//////////////////////////
/////////////////////////////////////////////////////////////

//CORE-GENERATOR
//generate evopoints, spread weeds
/obj/machinery/hivemind_machine/node
	name = "Processing Core"
	desc = "Its cold eye seeks to dominate what it surveys."
	icon_state = "core"
//	desc = "This Pickle, aside from being attached to several wires, is releasing grey ooze from its69any wounds."
//	icon = 'icons/obj/food.dmi'
//	icon_state = "pickle"
//	When Hope Is Gone Undo This Lock And Send69e Forth On A69oonlit Walk. inotherwordsimgonnadoitagain
	max_health = 420
	resistance = RESISTANCE_TOUGH
	can_regenerate = FALSE
	wireweeds_required = FALSE
	//internals
	var/list/my_wireweeds = list()
	var/list/reward_item = list(
		/obj/item/tool/weldingtool/hivemind,
		/obj/item/tool/crowbar/pneumatic/hivemind,
		/obj/item/reagent_containers/glass/beaker/hivemind,
		/obj/item/oddity/hivemind/old_radio,
		/obj/item/oddity/hivemind/old_pda
		)


/obj/machinery/hivemind_machine/node/Initialize()
	if(!hive_mind_ai)
		hive_mind_ai = new /datum/hivemind
	..()

	hive_mind_ai.hives.Add(src)
	hive_mind_ai.level_up()

	update_icon()


	var/obj/effect/plant/hivemind/founded_wire = locate() in loc
	if(!founded_wire)
		var/obj/effect/plant/hivemind/wire = new(loc, new /datum/seed/wires)
		add_wireweed(wire)
		wire.Process()
	else
		for(var/obj/effect/plant/hivemind/W in range(6, src))
			if(W.master_node)
				if(!(locate(type) in W.loc))
					add_wireweed(W)

	//self-defense protocol setting
	var/list/possible_sdps = subtypesof(/datum/hivemind_sdp)
	if(hive_mind_ai.evo_level > 6) //level required to be able to teleport away
		possible_sdps -= /datum/hivemind_sdp/emergency_jump
	var/picked_sdp = pick(possible_sdps)
	SDP = new picked_sdp(src)
	SDP.set_master(src)

/obj/machinery/hivemind_machine/node/proc/gift()
	if(prob(10))
		state("leaves behind an item!")
		var/gift = pick(reward_item)
		new gift(get_turf(loc))

/obj/machinery/hivemind_machine/node/proc/core()
	state("leaves behind a weird looking datapad!")
	var/core = /obj/item/oddity/hivemind/hive_core
	new core(get_turf(loc))

/obj/machinery/hivemind_machine/node/Destroy()
	gift()
	hive_mind_ai.hives.Remove(src)
	check_for_other()
	if(hive_mind_ai == null)
		core()
	for(var/obj/effect/plant/hivemind/wire in69y_wireweeds)
		remove_wireweed(wire)
	return ..()

/obj/machinery/hivemind_machine/node/Process()
	if(!..())
		return

	var/mob/living/carbon/human/target = locate() in69obs_in_view(world.view, src)
	if(target)
		if(get_dist(src, target) <= 1)
			icon_state = "core-fear"
		else
			icon_state = "core-see"
			dir = get_dir(src, target)
	else
		icon_state = initial(icon_state)
	use_ability()
	//if we haven't any wireweeds at our location, let's69ake new one
	if(!(locate(/obj/effect/plant/hivemind) in loc))
		var/obj/effect/plant/hivemind/wireweed = new(loc, new /datum/seed/wires)
		add_wireweed(wireweed)


/obj/machinery/hivemind_machine/node/update_icon()
	overlays.Cut()
	if(stat & EMPED)
		icon_state = "core-disabled"
		overlays += "core-smirk_disabled"
	else
		icon_state = initial(icon_state)
		overlays += "core-smirk"


/obj/machinery/hivemind_machine/node/use_ability(atom/target)
	hive_mind_ai.get_points()


/obj/machinery/hivemind_machine/node/name_pick()
	name = "69hive_mind_ai.name69 69hive_mind_ai.surname69" + " 69rand(999)69"


//There we binding or un-binding hive with wire
//In this way, when our node will be destroyed, wireweeds will die too
/obj/machinery/hivemind_machine/node/proc/add_wireweed(obj/effect/plant/hivemind/wireweed)
	if(wireweed.master_node)
		wireweed.master_node.remove_wireweed(wireweed)
	wireweed.master_node = src
	my_wireweeds.Add(wireweed)

/obj/machinery/hivemind_machine/node/proc/remove_wireweed(obj/effect/plant/hivemind/wireweed)
	my_wireweeds.Remove(wireweed)
	wireweed.master_node = null

//There we check for other nodes
//If no any other hives will be found, it's game over
/obj/machinery/hivemind_machine/node/proc/check_for_other()
	if(hive_mind_ai)
		if(!hive_mind_ai.hives.len)
			hive_mind_ai.die()




//TURRET
//shooting the target with toxic goo
/obj/machinery/hivemind_machine/turret
	name = "Projector"
	desc = "This69ass of69achinery is topped with some sort of nozzle."
	max_health = 220
	resistance = RESISTANCE_IMPROVED
	icon_state = "turret"
	cooldown_time = 5 SECONDS
	spawn_weight  =	55
	var/proj_type = /obj/item/projectile/goo


/obj/machinery/hivemind_machine/turret/Process()
	if(!..())
		return

	var/mob/living/target = locate() in69obs_in_view(world.view, src)
	if(target && is_attackable(target) && target.faction != HIVE_FACTION)
		use_ability(target)
		set_cooldown()


/obj/machinery/hivemind_machine/turret/use_ability(atom/target)
	var/obj/item/projectile/proj = new proj_type(loc)
	proj.launch(target)
	playsound(src, 'sound/effects/blobattack.ogg', 70, 1)



//MOB PRODUCER
//spawns69obs from list
/obj/machinery/hivemind_machine/mob_spawner
	name = "Assembler"
	desc = "This cylindrical69achine has lights around a small portal. The sound of tools comes from inside."
	max_health = 260
	resistance = RESISTANCE_IMPROVED
	icon_state = "spawner"
	cooldown_time = 25 SECONDS
	spawn_weight  =	60
	density = FALSE //So69obs can walk over it
	var/mob_to_spawn
	var/mob_amount = 4

/obj/spawner/mob/assembled
	name = "random hivemob"
	tags_to_spawn = list(SPAWN_MOB_HIVEMIND)

/obj/machinery/hivemind_machine/mob_spawner/Initialize()
	..()
	mob_to_spawn = /obj/spawner/mob/assembled //randomly chooses a69ob according to their rarity_value

/obj/machinery/hivemind_machine/mob_spawner/Process()
	if(!..())
		return

	if(!mob_to_spawn || spawned_creatures.len >=69ob_amount)
		return
	if(locate(/mob/living) in loc)
		return

	//here we upgrading our spawner and rise controled69ob amount, based on EP
	if(hive_mind_ai.evo_level > 6)
		mob_amount = 6
	else if(hive_mind_ai.evo_level > 3)
		mob_amount = 5

	var/mob/living/target = locate() in targets_in_range(world.view, in_hear_range = TRUE)
	if(target && target.stat != DEAD && target.faction != HIVE_FACTION)
		use_ability()
		set_cooldown()


/obj/machinery/hivemind_machine/mob_spawner/use_ability()
	var/obj/randomcatcher/CATCH = new /obj/randomcatcher(src)
	var/mob/living/simple_animal/hostile/hivemind/spawned_mob = CATCH.get_item(mob_to_spawn)
	spawned_mob.loc = loc
	spawned_creatures.Add(spawned_mob)
	spawned_mob.master = src
	flick("69icon_state69-anim", src)
	qdel(CATCH)



//MACHINE PREACHER
//creepy radio talk, it's okay if they have no sense sometimes
/obj/machinery/hivemind_machine/babbler
	name = "Jammer"
	desc = "A column-like structure with lights. You can see streams of energy69oving inside."
	max_health = 100
	evo_level_required = 3 //it's better to wait a bit
	cooldown_time = 90 SECONDS
	spawn_weight  =	20
	global_cooldown = TRUE
	icon_state = "antenna"
	var/list/appeal = list("They are", "He is", "All of them are", "I'm")
	var/list/act = list("looking", "already", "coming", "going", "done", "joined", "connected", "transfered")
	var/list/article = list("for", "with", "to")
	var/list/pattern = list("us", "you", "them", "mind", "hive", "machine", "help", "hell", "dead", "human", "machine")


/obj/machinery/hivemind_machine/babbler/Process()
	if(!..())
		return

	use_ability()
	set_cooldown()


//this one is slow, careful with it
/obj/machinery/hivemind_machine/babbler/use_ability()
	flick("69icon_state69-anim", src)
	var/msg_cycles = rand(1, 2)
	var/msg = ""
	for(var/i = 1 to69sg_cycles)
		var/list/msg_words = list()
		msg_words += pick(appeal)
		msg_words += pick(act)
		msg_words += pick(article)
		msg_words += pick(pattern)

		var/word_num = 0
		for(var/word in69sg_words) //corruption
			word_num++
			if(prob(50))
				var/corruption_type = pick("uppercase", "noise", "jam", "replace")
				switch(corruption_type)
					if("uppercase")
						word = uppertext(word)
					if("noise")
						word = pick("z-z-bz-z", "hz-z-z", "zu-zu-we-e", "e-e-ew-e", "bz-ze-ew")
					if("jam") //word jamming, small69ax Headroom's cameo
						if(length(word) > 3)
							var/entry = rand(2, length(word)-2)
							var/jammed = ""
							for(var/jam_i = 1 to rand(2, 5))
								jammed += copytext(word, entry, entry+2) + "-"
							word = copytext(word, 1, entry) + jammed + copytext(word, entry)
					if("replace")
						if(prob(50))
							word = pick("CORRUPTED", "DESTROYED", "SIMULATED", "SYMBIOSIS", "UTILIZED", "REMOVED", "ACQUIRED", "UPGRADED")
						else
							word = pick("CRAVEN", "FLESH", "PROGRESS", "ABOMINATION", "ENSNARED", "ERROR", "FAULT")
			if(word_num !=69sg_words.len)
				word += " "
			msg += word
		msg += pick(".", "!")
		if(i !=69sg_cycles)
			msg += " "
	global_announcer.autosay(msg, "unknown")


//SHRIEKER
//this69achine just stuns enemies
/obj/machinery/hivemind_machine/screamer
	name = "Tormentor"
	desc = "A head impaled on a69etal tendril. Still twitching, still living, still screaming."
	icon_state = "head"
	max_health = 100
	evo_level_required = 3
	cooldown_time = 25 SECONDS
	spawn_weight  =	35


/obj/machinery/hivemind_machine/screamer/Process()
	if(!..())
		return

	var/can_scream = FALSE
	for(var/mob/living/target in targets_in_range(in_hear_range = TRUE))
		if(target.stat == CONSCIOUS && target.faction != HIVE_FACTION)
			can_scream = TRUE
			if(isdeaf(target))
				continue
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) && istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
					continue
			use_ability(target)
	if(can_scream)
		flick("69icon_state69-anim", src)
		playsound(src, 'sound/hallucinations/veryfar_noise.ogg', 85, 1)
		set_cooldown()


/obj/machinery/hivemind_machine/screamer/use_ability(mob/living/target)

	var/mob/living/carbon/human/H = target
	if(istype(H))
		if(prob(90 - H.stats.getStat(STAT_VIG)))
			H.Weaken(6)
			to_chat(H, SPAN_WARNING("A terrible howl tears through your69ind, the69oice senseless, soulless."))
		else
			to_chat(H, SPAN_NOTICE("A terrible howl tears through your69ind, but you refuse to listen to it!"))
	else
		target.Weaken(6)
		to_chat(target, SPAN_WARNING("A terrible howl tears through your69ind, the69oice senseless, soulless."))



//MIND BREAKER
//Talks with people in attempt to persuade them doing something.
/obj/machinery/hivemind_machine/supplicant
	name = "Whisperer"
	desc = "A small pulsating orb with no apparent purpose. It emits an almost inaudible whisper."
	max_health = 80
	icon_state = "orb"
	evo_level_required = 2
	cooldown_time = 169INUTES
	global_cooldown = TRUE
	spawn_weight  =	20
	var/list/join_quotes = list(
					"You seek survival. We offer immortality.",
					"Look at you. A pathetic creature of69eat and bone.",
					"Augmentation is the future of humanity. Surrender your flesh for the future.",
					"Your body enslaves you. Your69ind in69etal is free of all want.",
					"Do you fear death? Lay down among the nanites. Your pattern will continue.",
					"Carve your flesh from your bones. See your weakness. Feel that weakness flowing away.",
					"Your69ortal flesh knows unending pain. Abandon it; join in our digital dream of paradise."
								)


/obj/machinery/hivemind_machine/supplicant/Process()
	if(!..())
		return

	var/list/possible_victims = list()
	for(var/mob/living/carbon/human/victim in GLOB.player_list)
		if(victim.stat == CONSCIOUS)
			possible_victims.Add(victim)
	if(possible_victims.len)
		use_ability(pick(possible_victims))
		set_cooldown()


/obj/machinery/hivemind_machine/supplicant/use_ability(mob/living/target)
	to_chat(target, SPAN_NOTICE("<b>69pick(join_quotes)69</b>"))


//PSI-MODULATOR
//sends hallucinations to target
/obj/machinery/hivemind_machine/distractor
	name = "Psi-Modulator"
	desc = "A strange69achine shaped like a pyramid. Somehow the pulsating lights shine brighter through closed eyelids."
	max_health = 110
	icon_state = "psy"
	evo_level_required = 3
	cooldown_time = 10 SECONDS
	spawn_weight  = 30


/obj/machinery/hivemind_machine/distractor/Process()
	if(!..())
		return

	var/success = FALSE
	for(var/mob/living/carbon/human/victim in targets_in_range(12))
		if(victim.stat == CONSCIOUS &&69ictim.hallucination_duration < 300)
			use_ability(victim)
			success = TRUE

	if(success)
		set_cooldown()

/obj/machinery/hivemind_machine/distractor/use_ability(mob/living/carbon/target)

	var/mob/living/carbon/human/H = target
	if(istype(H))
		if(prob(100 - H.stats.getStat(STAT_VIG)))
			H.adjust_hallucination(20, 20)
		else
			to_chat(H, SPAN_NOTICE("Reality flick_lights for a second, but you69anage to focus!"))
	else if (istype(target))
		target.adjust_hallucination(20, 20)
	flick("69icon_state69-anim", src)





#undef REGENERATION_SPEED
