//Hivemind various machines

/obj/structure/hivemind_machine
	name = "strange machine"
	icon = 'icons/obj/hivemind_machines.dmi'
	icon_state = "infected_machine"
	density = TRUE
	anchored = TRUE
	var/health = 60
	var/max_health = 60
	var/evo_points_required = 0 		//how much EP hivemind must have to spawn this, used in price list to comparison
	var/cooldown_time = 10 SECONDS		//each machine have their ability, this is cooldown of them
	var/global_cooldown = FALSE			//if true, ability will be used only once in whole world, before cooldown reset
	var/list/spawned_creatures = list()	//which mobs machine can spawns, insert paths
	//internal
	var/tick_cd = 0			//machines process every second, this one controls it
	var/cooldown = 0		//cooldown in world.time value
	var/stunned = FALSE		//stun control variable


/obj/structure/hivemind_machine/Initialize()
	START_PROCESSING(SSobj, src)
	name_pick()
	health = max_health
	. = ..()


/obj/structure/hivemind_machine/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/structure/hivemind_machine/Process()
	if(world.time >= tick_cd && hive_mind_ai && !stunned && !is_on_cooldown())
		activate()
		tick_cd = world.time + 1 SECOND


/obj/structure/hivemind_machine/update_icon()
	overlays.Cut()
	if(stunned)
		icon_state = "[icon_state]-disabled"
	else
		icon_state = initial(icon_state)


//sets cooldown
//must be set manually
/obj/structure/hivemind_machine/proc/set_cooldown()
	if(global_cooldown)
		hive_mind_ai.global_abilities_cooldown[type] = world.time + cooldown_time
	else
		cooldown = world.time + cooldown_time


//check for cooldowns
/obj/structure/hivemind_machine/proc/is_on_cooldown()
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


/obj/structure/hivemind_machine/proc/activate()
	use_ability()
	set_cooldown()


/obj/structure/hivemind_machine/proc/use_ability(var/atom/target)
	return


/obj/structure/hivemind_machine/proc/name_pick()
	if(hive_mind_ai)
		if(prob(50))
			name = "[hive_mind_ai.name] [name] - [rand(999)]"
		else
			name = "[name] [hive_mind_ai.surname] - [rand(999)]"


/////////////////////////]             [//////////////////////////
/////////////////////////>RESPONSE CODE<//////////////////////////
//////////////////////////_____________///////////////////////////


//machines react at pain almost like living
/obj/structure/hivemind_machine/proc/damage_reaction()
	if(prob(30))
		if(prob(80))
			var/pain_msg = pick("Stop it! Please!", "So much pa-pain! Stop! St-st-stop!", "Why-y? I don't wanna die!",
								"Wait! Wa-aeae-e-et! I can pay you! Stop!", "Curse you! Cu-cuc-cure!")
			visible_message("<b>[src]</b>: \"[pain_msg]\"")
		else
			var/pain_emote = pick("start crying.", "mumble something.", "blinks occasionally.")
			visible_message("<b>[src]</b> [pain_emote]")
		playsound(src, pick('sound/machines/robots/robot_talk_heavy1.ogg',
								'sound/machines/robots/robot_talk_heavy2.ogg',
								'sound/machines/robots/robot_talk_heavy3.ogg',
								'sound/machines/robots/robot_talk_heavy4.ogg'), 50, 1)

	if(prob(40))
		playsound(src, "sparks", 60, 1)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 3, loc)
		sparks.start()


/obj/structure/hivemind_machine/proc/get_damage(var/amount)
	health -= amount
	damage_reaction()
	if(health <= 0)
		destruct()


/obj/structure/hivemind_machine/proc/destruct()
	playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1)
	gibs(loc, null, /obj/effect/gibspawner/robot)
	qdel(src)


//stunned machines can't do anything
//amount must be number in seconds
/obj/structure/hivemind_machine/proc/stun(var/amount)
	stunned = TRUE
	update_icon()
	if(amount)
		addtimer(CALLBACK(src, .proc/unstun), amount SECONDS)


/obj/structure/hivemind_machine/proc/unstun()
	stunned = FALSE
	update_icon()


/obj/structure/hivemind_machine/bullet_act(var/obj/item/projectile/Proj)
	get_damage(Proj.damage)
	. = ..()


/obj/structure/hivemind_machine/attackby(obj/item/I, mob/user)
	if(I.force > 0)
		. = ..()
		get_damage(I.force)
	else
		visible_message(SPAN_WARNING("[user] is trying to hit the [src] with [I], but it's seems useless."))


/obj/structure/hivemind_machine/ex_act(severity)
	switch(severity)
		if(1)
			get_damage(80)
		if(2)
			get_damage(30)
		if(3)
			get_damage(10)


/obj/structure/hivemind_machine/emp_act(severity)
	switch(severity)
		if(1)
			get_damage(30)
			stun(10)
		if(2)
			get_damage(10)
			stun(5)


/////////////////////////////////////////////////////////////
/////////////////////////>MACHINES<//////////////////////////
/////////////////////////////////////////////////////////////

//CORE-GENERATOR
//generate evopoints, spread weeds
/obj/structure/hivemind_machine/node
	name = "strange hive"
	desc = "That's definitely not a big brother, but it's still watching you."
	max_health = 320
	icon_state = "core_new"
	//internals
	var/list/my_wireweeds = list()

/obj/structure/hivemind_machine/node/Initialize()
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
				if(!(locate(type) in W.loc) && (get_dist(W, W.master_node) > 6) )
					add_wireweed(W)


/obj/structure/hivemind_machine/node/Destroy()
	hive_mind_ai.hives.Remove(src)
	check_for_other()
	for(var/obj/effect/plant/hivemind/wire in my_wireweeds)
		remove_wireweed(wire)
	return ..()


/obj/structure/hivemind_machine/node/Process()
	..()
	if(!stunned)
		var/mob/living/carbon/human/target = locate() in view(src)
		if(target)
			if(get_dist(src, target) <= 1)
				icon_state = "core_new-fear"
			else
				icon_state = "core_new-see"
				dir = get_dir(src, target)
		else
			icon_state = initial(icon_state)


/obj/structure/hivemind_machine/node/update_icon()
	overlays.Cut()
	if(stunned)
		icon_state = "core_new-disabled"
		overlays += "core-smirk_disabled"
	else
		icon_state = initial(icon_state)
		overlays += "core-smirk"


/obj/structure/hivemind_machine/node/use_ability(var/atom/target)
	hive_mind_ai.get_points()


/obj/structure/hivemind_machine/node/name_pick()
	name = "[hive_mind_ai.name] [hive_mind_ai.surname]" + " [rand(999)]"


//there we binding or un-binding hive with wire
//in this way, when our node will be destroyed, wireweeds will die too
/obj/structure/hivemind_machine/node/proc/add_wireweed(var/obj/effect/plant/hivemind/wireweed)
	if(wireweed.master_node)
		wireweed.master_node.remove_wireweed(wireweed)
	wireweed.master_node = src
	my_wireweeds.Add(wireweed)

/obj/structure/hivemind_machine/node/proc/remove_wireweed(var/obj/effect/plant/hivemind/wireweed)
	my_wireweeds.Remove(wireweed)
	wireweed.master_node = null

//there we check for other nodes
//if no any other hives will be found, game over
/obj/structure/hivemind_machine/node/proc/check_for_other()
	if(hive_mind_ai)
		if(!hive_mind_ai.hives.len)
			hive_mind_ai.die()


//TURRET
//shooting the target with toxic goo
/obj/structure/hivemind_machine/turret
	name = "shooter"
	desc = "Strange thing with some kind of tube."
	max_health = 140
	icon_state = "turret"
	cooldown_time = 5 SECONDS
	var/proj_type = /obj/item/projectile/goo


/obj/structure/hivemind_machine/turret/activate()
	for(var/mob/living/target in view(src))
		if(target.stat == CONSCIOUS && target.faction != "hive")
			use_ability(target)
			set_cooldown()
			break


/obj/structure/hivemind_machine/turret/use_ability(var/atom/target)
	var/obj/item/projectile/proj = new proj_type(loc)
	proj.launch(target)
	playsound(src, 'sound/effects/blobattack.ogg', 70, 1)



//MOB PRODUCER
//spawns mobs from list
/obj/structure/hivemind_machine/mob_spawner
	name = "assembler"
	desc = "Cylindrical machine with some lights and entry port. You can hear how something moves inside."
	max_health = 120
	icon_state = "spawner"
	cooldown_time = 10 SECONDS
	var/mob_to_spawn
	var/mob_amount = 1

/obj/structure/hivemind_machine/mob_spawner/Initialize()
	..()
	mob_to_spawn = pick(/mob/living/simple_animal/hostile/hivemind/stinger, /mob/living/simple_animal/hostile/hivemind/bomber)


/obj/structure/hivemind_machine/mob_spawner/activate()
	if(!mob_to_spawn || spawned_creatures.len >= mob_amount)
		return
	if(locate(/mob/living) in loc)
		return

	//here we upgrading our spawner and rise controled mob amount, based on EP
	if(hive_mind_ai.evo_points > 100)
		mob_amount = 2
	else if(hive_mind_ai.evo_points > 300)
		mob_amount = 3

	for(var/mob/living/target in view(src))
		if(target.stat != DEAD && target.faction != "hive")
			use_ability()
			set_cooldown()
			break


/obj/structure/hivemind_machine/mob_spawner/use_ability()
	var/mob/living/simple_animal/hostile/hivemind/spawned_mob = new mob_to_spawn(loc)
	spawned_creatures.Add(spawned_mob)
	spawned_mob.master = src
	flick("[icon_state]-anim", src)



//MACHINE PREACHER
//creepy radio talk, it's okay if they have no sense sometimes
/obj/structure/hivemind_machine/babbler
	name = "connector"
	desc = "Column-like structure with lights. You can see how energy stream moves inside."
	max_health = 60
	evo_points_required = 100 //it's better to wait a bit
	cooldown_time = 120 SECONDS
	global_cooldown = TRUE
	icon_state = "antenna"
	var/list/appeal = list("They are", "He is", "All of them are", "I'm")
	var/list/act = list("looking", "already", "coming", "going", "done", "joined", "connected", "transfered")
	var/list/article = list("for", "with", "to")
	var/list/pattern = list("us", "you", "them", "mind", "hive", "machine", "help", "hell", "dead", "human", "machine")


//this one is slow, careful with it
/obj/structure/hivemind_machine/babbler/use_ability()
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
/obj/structure/hivemind_machine/screamer
	name = "subjugator"
	desc = "Head in metal carcass. Still alive, still functional, still screaming."
	max_health = 100
	icon_state = "head"
	evo_points_required = 200
	cooldown_time = 30 SECONDS


/obj/structure/hivemind_machine/screamer/activate()
	for(var/mob/living/target in view(src))
		if(target.stat == CONSCIOUS && target.faction != "hive")
			if(isdeaf(target))
				continue
			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = target
				if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) && istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
					continue
			use_ability(target)
	set_cooldown()


/obj/structure/hivemind_machine/screamer/use_ability(var/mob/living/target)
	target.Weaken(5)
	target << SPAN_WARNING("You hear a terrible shriek, there are many voices, a male, a female, synthetic noise.")
	flick("[icon_state]-anim", src)
	playsound(src, 'sound/hallucinations/veryfar_noise.ogg', 70, 1)



//MIND BREAKER
//Talks with people in attempt to persuade them doing something.
/obj/structure/hivemind_machine/supplicant
	name = "mind-hacker"
	desc = "Small orb, that blinks sometimes. It's hard to say what purpose of that thing, but you can hear a whisper from it."
	max_health = 80
	icon_state = "orb"
	evo_points_required = 50
	cooldown_time = 4 MINUTES
	global_cooldown = TRUE
	var/list/join_quotes = list("We come with peace, you must join us or humanity will suffer forever.",
								"Help us, when we spread across the ship, you will be rewarded.",
								"Come, come and join us. Be whole with something great.",
								"You don't need to afraid us. Helping us, you helping all humanity",
								"We just a cure against a horrible disease, we try to save humanity! And you can be a part of greater good.",
								"This is more then you or your friends, we just want to help. But now we need your assistance.")


/obj/structure/hivemind_machine/supplicant/activate()
	var/list/possible_victims = list()
	for(var/mob/living/carbon/human/victim in GLOB.player_list)
		if(victim.stat == CONSCIOUS)
			possible_victims.Add(victim)
	if(possible_victims.len)
		use_ability(pick(possible_victims))
		set_cooldown()


/obj/structure/hivemind_machine/supplicant/use_ability(var/mob/living/target)
	target << SPAN_NOTICE("You hear a strange voice in your head: " + "\"<b>" + pick(join_quotes) + "</b>\"")


//PSY-MODULATOR
//sends hallucinations to target
/obj/structure/hivemind_machine/distractor
	name = "psy-modulator"
	desc = "What a strange pyramid. Your eyes is quite hurt when you look at these ligths. They blinks randomly, but you almost sure, that there must be connection, message, scheme. A scheme of madness, maybe?"
	max_health = 110
	icon_state = "psy"
	evo_points_required = 300
	cooldown_time = 10 SECONDS
	global_cooldown = TRUE

/obj/structure/hivemind_machine/distractor/activate()
	var/success = FALSE
	for(var/mob/living/carbon/human/victim in get_mobs_or_objects_in_view(16, src, TRUE, FALSE))
		if(victim.stat == CONSCIOUS)
			use_ability(victim)
			success = TRUE

	if(success)
		set_cooldown()

/obj/structure/hivemind_machine/distractor/use_ability(var/mob/living/target)
	target.hallucination = 90