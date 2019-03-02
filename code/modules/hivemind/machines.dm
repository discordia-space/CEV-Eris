//Hivemind various machines

#define HIVE_FACTION 			"hive"
#define REGENERATION_SPEED 		4



/obj/machinery/hivemind_machine
	name = "strange machine"
	icon = 'icons/obj/hivemind_machines.dmi'
	icon_state = "infected_machine"
	density = TRUE
	anchored = TRUE
	use_power = FALSE
	var/illumination_color = 	COLOR_LIGHTING_CYAN_MACHINERY
	var/wireweeds_required =	TRUE		//machine got damage if there's no any wireweed on it's turf
	var/health = 				60
	var/max_health = 			60
	var/can_regenerate =		TRUE
	var/regen_cooldown_time = 	30 SECONDS	//min time to regeneration activation since last damage taken
	var/resistance = RESISTANCE_FRAGILE		//reduction on incoming damage
	var/evo_points_required = 	0 			//how much EP hivemind must have to spawn this, used in price list to comparison
	var/cooldown_time = 10 SECONDS			//each machine have their ability, this is cooldown of them
	var/global_cooldown = FALSE				//if true, ability will be used only once in whole world, before cooldown reset
	var/list/spawned_creatures = list()		//which mobs machine can spawns, insert paths
	//internal
	var/cooldown = 0						//cooldown in world.time value
	var/time_until_regen = 0
	var/list/assimilated_machinery = list("path", "dir", "appearance")

/obj/machinery/hivemind_machine/Initialize()
	. = ..()
	name_pick()
	health = max_health
	set_light(2, 3, illumination_color)


/obj/machinery/hivemind_machine/update_icon()
	overlays.Cut()
	if(stat & EMPED)
		icon_state = "[icon_state]-disabled"
	else
		icon_state = initial(icon_state)


/obj/machinery/hivemind_machine/Process()
	if(wireweeds_required && !locate(/obj/effect/plant/hivemind) in loc)
		take_damage(5, on_damage_react = FALSE)

	if(hive_mind_ai && !(stat & EMPED) && !is_on_cooldown())
		//slow health regeneration
		if(can_regenerate && (health != max_health) && (world.time > time_until_regen))
			health += REGENERATION_SPEED
			if(health > max_health)
				health = max_health

		return TRUE


//Machinery consumption
//We don't want to ruin things by destroying important machines without circuits
//So we store path, dir and appearance to use it later
/obj/machinery/hivemind_machine/proc/consume(var/obj/victim)
	if(istype(victim, /obj/machinery))
		var/obj/machinery/target = victim
		if(target.circuit)
			new target.circuit.type(src)
			qdel(victim)
			return

	assimilated_machinery["path"] 		= victim.type
	assimilated_machinery["dir"]		= victim.dir
	assimilated_machinery["appearance"] = victim.appearance
	if(istype(victim, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/apc = victim
		if(apc.cell)
			qdel(apc.cell)
			apc.cell = null
	qdel(victim)


/obj/machinery/hivemind_machine/proc/drop_assimilated()
	var/obj/item/weapon/circuitboard/saved_circuit = locate() in src
	if(saved_circuit)
		saved_circuit.loc = loc

	else
		var/victim_path = assimilated_machinery["path"]
		if(victim_path)
			var/obj/victim = new victim_path(loc)
			victim.dir = assimilated_machinery["dir"]
			victim.appearance = assimilated_machinery["appearance"]
			assimilated_machinery = initial(assimilated_machinery)



//Sets ability cooldown
//Must be set manually
/obj/machinery/hivemind_machine/proc/set_cooldown()
	if(global_cooldown)
		hive_mind_ai.global_abilities_cooldown[type] = world.time + cooldown_time
	else
		cooldown = world.time + cooldown_time


/obj/machinery/hivemind_machine/proc/is_on_cooldown()
	if(global_cooldown)
		if(hive_mind_ai && hive_mind_ai.global_abilities_cooldown[type])
			if(world.time >= hive_mind_ai.global_abilities_cooldown[type])
				hive_mind_ai.global_abilities_cooldown[type] = null
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
			name = "[hive_mind_ai.name] [name] - [rand(999)]"
		else
			name = "[name] [hive_mind_ai.surname] - [rand(999)]"


//Returns list of mobs in range or hearers (include in vehicles)
/obj/machinery/hivemind_machine/proc/targets_in_range(var/range = world.view, var/in_hear_range = FALSE)
	var/list/range_list = list()
	var/list/target_list = list()
	if(in_hear_range)
		range_list = hearers(range, src)
	else
		range_list = range(range, src)
	for(var/atom/movable/M in range_list)
		var/mob/target = M.get_mob()
		if(target)
			target_list += target
	return target_list


/////////////////////////]             [//////////////////////////
/////////////////////////>RESPONSE CODE<//////////////////////////
//////////////////////////_____________///////////////////////////


//When machine takes damage it can react somehow
/obj/machinery/hivemind_machine/proc/damage_reaction()
	if(prob(30))
		if(prob(80))
			var/pain_msg = pick("Stop it! Please!", "So much pa-pain! Stop! St-st-stop!", "Why-y? I don't wanna die!",
								"Wait! Wa-aeae-e-et! I can pay you! Stop!", "Curse you! Cu-cuc-cure!")
			state("says: \"<b>[pain_msg]</b>\"")
		else
			var/pain_emote = pick("starts crying.", "mumbles something.", "blinks occasionally.")
			state(pain_emote)
		playsound(src, pick('sound/machines/robots/robot_talk_heavy1.ogg',
								'sound/machines/robots/robot_talk_heavy2.ogg',
								'sound/machines/robots/robot_talk_heavy3.ogg',
								'sound/machines/robots/robot_talk_heavy4.ogg'), 50, 1)

	if(prob(40))
		playsound(src, "sparks", 60, 1)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 3, loc)
		sparks.start()


/obj/machinery/hivemind_machine/proc/take_damage(var/amount, var/on_damage_react = TRUE)
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
	qdel(src)


//Stunned machines can't do anything
//Amount must be a number in seconds
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
	take_damage(Proj.damage)
	. = ..()


/obj/machinery/hivemind_machine/attackby(obj/item/I, mob/user)
	if(!(I.flags & NOBLUDGEON) && I.force)
		user.do_attack_animation(src)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/clear_damage = I.force - resistance

		if(clear_damage)
			. = ..()
			take_damage(clear_damage)
		else
			to_chat(user, SPAN_WARNING("You trying to hit the [src] with [I], but it seems useless."))
			playsound(src, 'sound/weapons/Genhit.ogg', 30, 1)


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
			take_damage(30)
			stun(10)
		if(2)
			take_damage(10)
			stun(5)
	..()


/////////////////////////////////////////////////////////////
/////////////////////////>MACHINES<//////////////////////////
/////////////////////////////////////////////////////////////

//CORE-GENERATOR
//generate evopoints, spread weeds
/obj/machinery/hivemind_machine/node
	name = "strange hive"
	desc = "Definitely not a big brother, but it's still watching you."
	icon_state = "core"
	max_health = 360
	resistance = RESISTANCE_AVERAGE
	can_regenerate = FALSE
	wireweeds_required = FALSE
	//internals
	var/list/my_wireweeds = list()

/obj/machinery/hivemind_machine/node/Initialize()
	if(!hive_mind_ai)
		hive_mind_ai = new /datum/hivemind
	..()

	hive_mind_ai.hives.Add(src)

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


/obj/machinery/hivemind_machine/node/Destroy()
	hive_mind_ai.hives.Remove(src)
	check_for_other()
	for(var/obj/effect/plant/hivemind/wire in my_wireweeds)
		remove_wireweed(wire)
	return ..()


/obj/machinery/hivemind_machine/node/Process()
	if(!..())
		return

	var/mob/living/carbon/human/target = locate() in mobs_in_view(world.view, src)
	if(target)
		if(get_dist(src, target) <= 1)
			icon_state = "core-fear"
		else
			icon_state = "core-see"
			dir = get_dir(src, target)
	else
		icon_state = initial(icon_state)
	use_ability()
	//if we haven't any wireweeds at our location, let's make new one
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
	name = "[hive_mind_ai.name] [hive_mind_ai.surname]" + " [rand(999)]"


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
	name = "shooter"
	desc = "Strange thing with some kind of tube."
	max_health = 140
	icon_state = "turret"
	cooldown_time = 5 SECONDS
	var/proj_type = /obj/item/projectile/goo


/obj/machinery/hivemind_machine/turret/Process()
	if(!..())
		return

	var/mob/living/target = locate() in mobs_in_view(world.view, src)
	if(target && target.stat == CONSCIOUS && target.faction != HIVE_FACTION)
		use_ability(target)
		set_cooldown()


/obj/machinery/hivemind_machine/turret/use_ability(atom/target)
	var/obj/item/projectile/proj = new proj_type(loc)
	proj.launch(target)
	playsound(src, 'sound/effects/blobattack.ogg', 70, 1)



//MOB PRODUCER
//spawns mobs from list
/obj/machinery/hivemind_machine/mob_spawner
	name = "assembler"
	desc = "Cylindrical machine with some lights and an entry port. You can hear something moving inside."
	max_health = 120
	icon_state = "spawner"
	cooldown_time = 10 SECONDS
	var/mob_to_spawn
	var/mob_amount = 1

/obj/machinery/hivemind_machine/mob_spawner/Initialize()
	..()
	mob_to_spawn = pick(/mob/living/simple_animal/hostile/hivemind/stinger, /mob/living/simple_animal/hostile/hivemind/bomber)


/obj/machinery/hivemind_machine/mob_spawner/Process()
	if(!..())
		return

	if(!mob_to_spawn || spawned_creatures.len >= mob_amount)
		return
	if(locate(/mob/living) in loc)
		return

	//here we upgrading our spawner and rise controled mob amount, based on EP
	if(hive_mind_ai.evo_points > 100)
		mob_amount = 2
	else if(hive_mind_ai.evo_points > 300)
		mob_amount = 3

	var/mob/living/target = locate() in targets_in_range(world.view, in_hear_range = TRUE)
	if(target && target.stat != DEAD && target.faction != HIVE_FACTION)
		use_ability()
		set_cooldown()


/obj/machinery/hivemind_machine/mob_spawner/use_ability()
	var/mob/living/simple_animal/hostile/hivemind/spawned_mob = new mob_to_spawn(loc)
	spawned_creatures.Add(spawned_mob)
	spawned_mob.master = src
	flick("[icon_state]-anim", src)



//MACHINE PREACHER
//creepy radio talk, it's okay if they have no sense sometimes
/obj/machinery/hivemind_machine/babbler
	name = "connector"
	desc = "A column-like structure with lights. You can see streams of energy moving inside."
	max_health = 60
	evo_points_required = 100 //it's better to wait a bit
	cooldown_time = 120 SECONDS
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
	flick("[icon_state]-anim", src)
	var/msg_cycles = rand(1, 2)
	var/msg = ""
	for(var/i = 1 to msg_cycles)
		var/list/msg_words = list()
		msg_words += pick(appeal)
		msg_words += pick(act)
		msg_words += pick(article)
		msg_words += pick(pattern)

		var/word_num = 0
		for(var/word in msg_words) //corruption
			word_num++
			if(prob(50))
				var/corruption_type = pick("uppercase", "noise", "jam", "replace")
				switch(corruption_type)
					if("uppercase")
						word = uppertext(word)
					if("noise")
						word = pick("z-z-bz-z", "hz-z-z", "zu-zu-we-e", "e-e-ew-e", "bz-ze-ew")
					if("jam") //word jamming, small Max Headroom's cameo
						if(lentext(word) > 3)
							var/entry = rand(2, lentext(word)-2)
							var/jammed = ""
							for(var/jam_i = 1 to rand(2, 5))
								jammed += copytext(word, entry, entry+2) + "-"
							word = copytext(word, 1, entry) + jammed + copytext(word, entry)
					if("replace")
						if(prob(50))
							word = pick("CORRUPTED", "DESTRUCTED", "SIMULATATED", "SYMBIOSIS", "UTILIZATATED", "REMOVED", "ACQUIRED")
						else
							word = pick("REALLY WANT TO", "TAKE ALL OF THAT", "ARE YOU ENJOY IT", "NOT SUPPOSED TO BE", "THERE ARE NO ESCAPE", "HELP US")
			if(word_num != msg_words.len)
				word += " "
			msg += word
		msg += pick(".", "!")
		if(i != msg_cycles)
			msg += " "
	global_announcer.autosay(msg, "unknown")


//SHRIEKER
//this machine just stuns enemies
/obj/machinery/hivemind_machine/screamer
	name = "subjugator"
	desc = "A head in a metal carcass. Still alive, still functional, still screaming."
	max_health = 100
	icon_state = "head"
	evo_points_required = 200
	cooldown_time = 30 SECONDS


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
		flick("[icon_state]-anim", src)
		playsound(src, 'sound/hallucinations/veryfar_noise.ogg', 85, 1)
		set_cooldown()


/obj/machinery/hivemind_machine/screamer/use_ability(mob/living/target)
	target.Weaken(5)
	to_chat(target, SPAN_WARNING("You hear a terrible shriek, there are many voices, a male, a female and synthetic noise."))



//MIND BREAKER
//Talks with people in attempt to persuade them doing something.
/obj/machinery/hivemind_machine/supplicant
	name = "mind-hacker"
	desc = "A small orb that pulses occasionally. It's hard to discern its purpose, but you can hear whispers from it."
	max_health = 80
	icon_state = "orb"
	evo_points_required = 50
	cooldown_time = 4 MINUTES
	global_cooldown = TRUE
	var/list/join_quotes = list(
					"We bring peace, you must join us or humanity will suffer forever.",
					"Help us, when we spread across this ship, you will be rewarded.",
					"Come, join us. Combine with something magnificent.",
					"You don't need to fear us. By assisting us, you are benefiting all of humanity.",
					"We are but a cure against a horrible disease, here to save humanity! You too can contribute to the greater good.",
					"This is bigger than you and your friends, we only want to lift the burden. However, we will require your assistance."
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
	to_chat(target, SPAN_NOTICE("<b>[pick(join_quotes)]</b>"))


//PSY-MODULATOR
//sends hallucinations to target
/obj/machinery/hivemind_machine/distractor
	name = "psy-modulator"
	desc = "An unknown object shaped like a pyramid, your eyes feel sore just from looking at the lights that blink randomly. You are almost certain that there must be some sort of connection, a message, a scheme; Perhaps A scheme of madness?"
	max_health = 110
	icon_state = "psy"
	evo_points_required = 300
	cooldown_time = 10 SECONDS


/obj/machinery/hivemind_machine/distractor/Process()
	if(!..())
		return

	var/success = FALSE
	for(var/mob/living/carbon/human/victim in targets_in_range(12))
		if(victim.stat == CONSCIOUS && victim.hallucination < 300)
			use_ability(victim)
			success = TRUE

	if(success)
		set_cooldown()

/obj/machinery/hivemind_machine/distractor/use_ability(mob/living/target)
	target.hallucination += 20
	flick("[icon_state]-anim", src)





#undef HIVE_FACTION
#undef REGENERATION_SPEED