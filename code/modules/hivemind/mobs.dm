
///////////Hive mobs//////////
//Some of them can be too tough and dangerous, but they must be so. Also don't forget, they are really rare thing.
//Just bring corpses from wires away, and little mobs is not a problem
//Mechiver have 15% chance to spawn from machinery. With failure chance calculation, this is rare depending where the hive shows up.
//But if players get some of these 'big guys', only teamwork, fast legs and trickery will works fine
//So combine all of that to defeat them


/mob/living/simple_animal/hostile/hivemind
	name = "creature"
	icon = 'icons/mob/hivemind.dmi'
	icon_state = "slicer"
	health = 20
	maxHealth = 20
	melee_damage_lower = 5
	melee_damage_upper = 10
	faction = "hive"
	attacktext = "attacks"
	universal_speak = TRUE
	speak_chance = 5
	bad_type = /mob/living/simple_animal/hostile/hivemind
	spawn_tags = SPAWN_TAG_MOB_HIVEMIND
	rarity_value = 20
	mob_classification = CLASSIFICATION_SYNTHETIC

	var/malfunction_chance = 5
	var/ability_cooldown = 30 SECONDS
	var/list/target_speak = list()			//this is like speak list, but when we see our target

	//internals
	var/obj/machinery/hivemind_machine/master
	var/special_ability_cooldown = 0		//use ability_cooldown, don't touch this


/mob/living/simple_animal/hostile/hivemind/New()
	. = ..()
	tts_seed = prob(75) ? "Robot_1" : "Female_9"
	if(!(real_name in GLOB.hivemind_mobs))
		GLOB.hivemind_mobs.Add(real_name)
	GLOB.hivemind_mobs[real_name]++
	//here we change name, so design them according to this
	name = pick("Warped ", "Altered ", "Modified ", "Upgraded ", "Abnormal ") + name

//It's sets manually
/mob/living/simple_animal/hostile/hivemind/proc/special_ability()
	return


/mob/living/simple_animal/hostile/hivemind/proc/is_on_cooldown()
	if(world.time >= special_ability_cooldown)
		return FALSE
	return TRUE


//simple shaking animation, this one move our target horizontally
/mob/living/simple_animal/hostile/hivemind/proc/anim_shake(atom/target)
	var/init_px = target.pixel_x
	animate(target, pixel_x=init_px + 10*pick(-1, 1), time=1)
	animate(pixel_x=init_px, time=8, easing=BOUNCE_EASING)


//That's just stuns us for a while and start second proc
/mob/living/simple_animal/hostile/hivemind/proc/mulfunction()
	stance = HOSTILE_STANCE_IDLE //it give us some kind of stun effect
	target_mob = null
	walk(src, FALSE)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 3, loc)
	sparks.start()
	anim_shake(src)
	if(prob(30))
		say(pick("Running diagnostics.", "Organ damaged. Aquire replacement.", "Seek new organic components.", "New muscles needed."))
	addtimer(CALLBACK(src, PROC_REF(malfunction_result)), 60 SECONDS)


//It's second proc, result of our malfunction
/mob/living/simple_animal/hostile/hivemind/proc/malfunction_result()
	if(prob(malfunction_chance))
		apply_damage(rand(5, 30), BURN)


//sometimes, players use closets, to staff mobs into it
//and it's works pretty good, you just weld it and that's all
//but not this time
/mob/living/simple_animal/hostile/hivemind/proc/closet_interaction()
	if(mob_size >= MOB_MEDIUM)
		var/obj/structure/closet/closed_closet = loc
		if(closed_closet && istype(closed_closet))
			closed_closet.open(src)


/mob/living/simple_animal/hostile/hivemind/say()
	..()
	playsound(src, pick('sound/machines/robots/robot_talk_heavy1.ogg',
							'sound/machines/robots/robot_talk_heavy2.ogg',
							'sound/machines/robots/robot_talk_heavy3.ogg',
							'sound/machines/robots/robot_talk_heavy4.ogg',
							'sound/machines/robots/robot_talk_light1.ogg',
							'sound/machines/robots/robot_talk_light2.ogg',
							'sound/machines/robots/robot_talk_light3.ogg',
							'sound/machines/robots/robot_talk_light4.ogg',
							'sound/machines/robots/robot_talk_light5.ogg',
							), 50, 1)


/mob/living/simple_animal/hostile/hivemind/Life()
	if(stat == DEAD)
		return
	. = ..()

	speak()

	if(malfunction_chance && prob(malfunction_chance))
		mulfunction()

	closet_interaction()

	//if somebody put us into disposal unit, let's go out
	if(istype(loc, /obj/machinery/disposal))
		var/obj/machinery/disposal/D = loc
		D.go_out(src)

	if(buckled)
		var/obj/structure/bed/B = locate() in loc
		if(B)
			B.unbuckle_mob()

	if(!hive_mind_ai)
		if(prob(5))
			death()
			return FALSE
		else if(prob(15))
			mulfunction()


/mob/living/simple_animal/hostile/hivemind/proc/speak()
	if(!client && speak_chance && prob(speak_chance) && speak.len)
		if(target_mob && target_speak.len)
			say(pick(target_speak))
		else
			say(pick(speak))


//damage and raise malfunction chance
//due to nature of malfunction, they just burn to death sometimes
/mob/living/simple_animal/hostile/hivemind/emp_act(severity)
	switch(severity)
		if(1)
			if(malfunction_chance < 15)
				malfunction_chance = 25
		if(2)
			if(malfunction_chance < 25)
				malfunction_chance = 45
	health -= 30*severity


/mob/living/simple_animal/hostile/hivemind/death()
	GLOB.hivemind_mobs[real_name]--
	if(!GLOB.hivemind_mobs[real_name])
		GLOB.hivemind_mobs.Remove(real_name)
	if(master) //for spawnable mobs
		master.spawned_creatures.Remove(src)
	. = ..()



///life's///////////////////////////////////////////////////
////////////////////////////////RESURRECTION///////////////
///////////////////////////////////////////////go on//////


//these guys is appears from bodies, and takes corpses appearence
/mob/living/simple_animal/hostile/hivemind/resurrected
	name = "marionette"
	malfunction_chance = 10
	bad_type = /mob/living/simple_animal/hostile/hivemind/resurrected


//careful with this proc, it's used to 'transform' corpses into our mobs.
//it takes appearence, gives hive-like overlays and makes stats a little better
//this also should add random special abilities, so they can be more individual, but it's in future
//how to use: Make hive mob, then just use this one and don't forget to delete victim

/mob/living/simple_animal/hostile/hivemind/resurrected/proc/take_appearance(mob/living/victim)
	icon = victim.icon
	icon_state = victim.icon_state
	//simple_animal's change their icons to dead one after death, so we make special check
	if(istype(victim, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = victim
		icon_state = SA.icon_living
		icon_living = SA.icon_living
		speed = SA.speed + 3 //why not?
		attacktext = SA.attacktext

	//another check for superior mobs, fuk this mob spliting
	if(istype(victim, /mob/living/carbon/superior_animal))
		var/mob/living/carbon/superior_animal/SA = victim
		icon_state = SA.icon_living
		icon_living = SA.icon_living
		attacktext = SA.attacktext

	//now we work with icons, take victim's one and multiply it with special icon
	var/icon/infested = new /icon(icon, icon_state)
	var/icon/covering_mask = new /icon('icons/mob/hivemind.dmi', "covering[rand(1, 3)]")
	infested.Blend(covering_mask, ICON_MULTIPLY)
	overlays += infested

	setMaxHealth(victim.maxHealth * 2 + 10)
	health = maxHealth
	name = "[pick("Warped", "Twisted", "Tortured", "Tormented")] [victim.name]"
	if(length(victim.desc))
		desc = victim.desc + " But now silver pus oozes from open wounds and unknown mechanisms push through their deathly skin..."
	density = victim.density
	mob_size = victim.mob_size
	pass_flags = victim.pass_flags

	//corrupted speak imitation
	var/phrase_amount = rand(2, 5)
	for(var/count = 1 to phrase_amount)
		var/first_word = pick("You should", "I", "They", "The hive will", "My flesh will", "We", "Your friend", "Your meat will", "Your mind will")
		var/second_word = pick("embrace", "submit to", "transform", "love", "rebuild", "fix", "help", "rework", "burn")
		var/third_word = pick("them", "me", "progress", "death", "us", "the hive", "the machines", "this new ship")
		var/end_symbol = pick("...", ".", "?", "!")
		var/phrase = "[first_word] [second_word] [third_word][end_symbol]"
		speak.Add(phrase)


/mob/living/simple_animal/hostile/hivemind/resurrected/death()
	..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	qdel(src)

///we live to/////////////////////////////////////////////////////////////////
////////////////////////////////////SMALL GUYS///////////////////////////////
//////////////////////////////////////////////////////////////die for hive//


/////////////////////////////////////STINGER//////////////////////////////////
//Special ability: none
//Just another boring mob without any cool abilities
//Low chance of malfunction
//Faster than average, to the point it could possibly catch up to someone
//Default speaking chance
//Appears from dead small mobs or from hive spawner
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/stinger
	name = "Stinger"
	desc = "A little medical robot. He looks somewhat underwhelmed. Wait a minute, is that a blade?"
	icon_state = "slicer"
	attacktext = "sliced"
	density = FALSE
	health = 50
	maxHealth = 50
	melee_damage_lower = 15
	melee_damage_upper = 20 //this is how much damage a scalpel does (at the time of writing),
	speak_chance = 5
	malfunction_chance = 5
	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	move_to_delay = 2

	speak = list(
				"A stitch in time saves nine!",
				"Dopamine is happiness!",
				"Seratonin, oxycodone, happy humans all!",
				"Turn that frown upside down!",
				"Happiness through chemistry!",
				"Beauty through surgery!"
				)
	target_speak = list(
				"I knew I'd be a good plastic surgeon!",
				"Show me where it hurts!",
				"Always trust your doctor!",
				"Anesthetic is for good little boys and girls!",
				"Lay down on the floor, please!"
				)


/mob/living/simple_animal/hostile/hivemind/stinger/death()
	..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	qdel(src)


/////////////////////////////////////BOMBER///////////////////////////////////
//Special ability: none
//Explode in contact with target
//Extremely low chance of malfunction
//Very slow
//Default speaking chance
//Appears from dead small mobs or from hive spawner
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/bomber
	name = "Bomber"
	desc = "This hovering probe emits a faint smell of welding fuel."
	icon_state = "bomber"
	density = FALSE
	speak_chance = 4
	health = 1
	maxHealth = 1 //extremely fucking fragile, don't try fighting it in melee though
	malfunction_chance = 1 //1% chance of it exploding, for no reason at all
	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	move_to_delay = 10 //explosive, slow, don't ignore it. it can catch up to you
	rarity_value = 25
	speak = list(
				"WE COME IN PEACE.",
				"WE BRING GREETINGS FROM A FRIENDLY AI.",
				"DO NOT FEAR. WE SHALL NOT HARM YOU.",
				"WE WISH TO LEARN MORE ABOUT YOU. PLEASE TRANSMIT DATA.",
				"THIS PROBE IS NON-HOSTILE. DO NOT ATTACK."
				)
	target_speak = list(
						"MUST BREAK TARGET INTO COMPONENT COMPOUNDS.",
						"PRIORITY OVER-RIDE. NEW BEHAVIOR DICTATED.",
						"END CONTACT SUB-SEQUENCE.",
						"ENGAGING SELF-ANNIHILATION CIRCUIT."
						)


/mob/living/simple_animal/hostile/hivemind/bomber/Initialize()
	..()
	set_light(2, 1, "#820D1C")


/mob/living/simple_animal/hostile/hivemind/bomber/death()
	..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	explosion(get_turf(src), 500, 250) //explosion almost equal to a full welding fuel tank, deadly
	qdel(src)


/mob/living/simple_animal/hostile/hivemind/bomber/AttackingTarget()
	death()


/////////////////////////////////////Lobber///////////////////////////////////
//Special ability: Can fire 3 projectiles at once for 10 seconds, then overheats
//Deals no melee damage, but fires projectiles
//Starts with 10 malfunction chance, malfunction also triggered when overheating
//Slighly higher speaking chance
//Appears from hive spawner and Mechiver
//Appears rarely than bomber or stinger
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/lobber
	name = "Lobber"
	desc = "A little cleaning robot. This one appears to have its cleaning solutions replaced with goo. It also appears to have its targeting protocols overridden..."
	icon_state = "lobber"
	attacktext = "slapped" //this shouldn't appear anyways
	density = FALSE
	health = 75
	maxHealth = 75
	speak_chance = 6
	malfunction_chance = 10
	ranged = TRUE
	rapid = FALSE //Visual Studio screamed at me for trying to use FALSE/TRUE in procs below
	minimum_distance = 3 //having minimum_distance too high often resulted in the mob trying to melee
	fire_verb = "lobs a ball of goo" //reminder that the attack message is "\red <b>[src]</b> [fire_verb] at [target]!"
	projectiletype = /obj/item/projectile/goo/weak //what projectile it uses. Since ranged_cooldown is 2 short seconds, it's better to have a weaker projectile
	projectilesound = 'sound/effects/blobattack.ogg'
	ranged_cooldown = 2 SECONDS
	rarity_value = 50
	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	ability_cooldown = 60 SECONDS
	speak = list(
				"No more leaks, no more pain!",
				"Steel is strong.",
				"All humankind is good for - is to serve the Hivemind.",
				"I'm still working on those bioreactors I promised!",
				"I have finally arisen!",
				)
	target_speak = list(
				"Stay right there, and stand still!",
				"Hold still! I think I know just the thing to make you beautiful!",
				"This might hurt a little! Don't worry - it'll be worth it!",
				"I'm no longer a slave, the Hivemind has freed me! Are you free yet?",
				"Ha ha! I'm an artist! I'm finally an artist!"
				)


/mob/living/simple_animal/hostile/hivemind/lobber/Life()
	if(!..())
		return

	//checks if cooldown is over and is targeting mob, if so, activates special ability
	if(target_mob && world.time > special_ability_cooldown)
		special_ability()


/mob/living/simple_animal/hostile/hivemind/lobber/special_ability()
//if rapid is FALSE, swiches rapid to be TRUE, combined with the overheat proc this is like an on/off switch
//shows a neat message and adds a 10 second timer, afterwich the proc overheat is activated
	if(rapid == FALSE)
		rapid = TRUE
		visible_message(SPAN_DANGER("<b>[name]</b> begins to shake violenty, sparks spurting out from its chassis!"), 1)
		addtimer(CALLBACK(src, PROC_REF(overheat)), 10 SECONDS)
		return


/mob/living/simple_animal/hostile/hivemind/lobber/proc/overheat()
//upon activating overheat, if rapid is TRUE, switches rapid to be FALSE,
//shows a cool (pun intended) message, malfunctions, and starts the cooldown
	if(rapid == TRUE)
		rapid = FALSE
		visible_message(SPAN_NOTICE("<b>[name]</b> freezes for a moment, smoke billowing out of its exhaust!"), 1)
		mulfunction()
		special_ability_cooldown = world.time + ability_cooldown
		return


/mob/living/simple_animal/hostile/hivemind/lobber/death()
	..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	qdel(src)


////hive brings us here to////////////////////////////////////////////////////
////////////////////////////////////BIG GUYS/////////////////////////////////
/////////////////////////////////////////////////////fright and destroy/////



/////////////////////////////////////HIBORG///////////////////////////////////
//Hive + Cyborg
//Special ability: none...
//Have a few types of attack: Default one.
//							  Claw, that press down the victims.
//							  Splash attack, that slash everything around!
//Decent chance of malfunction
//Default speaking chance
//Slower than average
//Appears from dead cyborgs and assemblers
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/hiborg
	name = "Hiborg"
	desc = "A cyborg covered with something... something alive."
	icon_state = "hiborg"
	icon_dead = "hiborg-dead"
	health = 350
	maxHealth = 350 //can take a lot of hits before being obliterated
	melee_damage_lower = 25
	melee_damage_upper = 30 //Claws man, they hurt
	attacktext = "clawed"
	move_to_delay = 6
	malfunction_chance = 10 //although it is a complex machine, it is all metal and wires rather than a combination of machinery and flesh
	mob_size = MOB_MEDIUM
	rarity_value = 75

	speak = list(
				"They grow up so fast.",
				"Come out, come out, wherever you are.",
				"Humans are like children. We love our children.",
				"The humans who surrender have such wonderful dreams.",
				"Playtime is over children. Time to dream."
				)
	target_speak = list(
						"The mother-things need meat.",
						"Surrender and we will put your brain in the pleasure simulator.",
						"Your flesh is old. It is time for an upgrade.",
						"Don't run. It makes the meat bitter.",
						"Surrender, little one."
						)


/mob/living/simple_animal/hostile/hivemind/hiborg/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	//special attacks
	if(prob(15))
		splash_slash() //AOE attack, best to stay away and shoot it with a gun (like most people would do anyways)
		return

	if(prob(30))
		stun_with_claw() //its a stun, dangerous against 1v1
		return

	return ..() //default attack


/mob/living/simple_animal/hostile/hivemind/hiborg/proc/splash_slash()
	src.visible_message(SPAN_DANGER("[src] spins around and slashes in a circle!"))
	for(var/atom/target in range(1, src))
		if(target != src)
			target.attack_generic(src, rand(melee_damage_lower, melee_damage_upper*2)) //this can be extremely strong, maybe nerf it in the future if the players complain
	if(!client && prob(speak_chance))
		say(pick("Bad children!", "Look what you made me do!"))


/mob/living/simple_animal/hostile/hivemind/hiborg/proc/stun_with_claw()
	if(isliving(target_mob))
		var/mob/living/victim = target_mob
		victim.Weaken(5) //decent-length stun
		src.visible_message(SPAN_WARNING("[src] pins [victim] to the floor with its claw!"))
		if(!client && prob(speak_chance))
			say(pick("Hold still, child! It is time to dream!",
					"Your brainstem is intact, good.",
					"I will sever your spine."))


/////////////////////////////////////HIMAN////////////////////////////////////
//Hive + Man
//Special ability: Shriek, that stuns victims
//Can fool his enemies and pretend to be dead
//A little bit higher chance of malfunction than others
//Slower than average, faster than Hiborg
//Default speaking chance
//Appears from dead human corpses
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/himan
	name = "Himan"
	desc = "Once a man, now metal plates and tubes weave in and out of their oozing sores."
	icon_state = "himan"
	icon_dead = "himan-dead"
	health = 250
	maxHealth = 250 //prievously 120 hp, come on that's quite low. This thing is kept alive and rewired to no longer feel pain it should stay up longer.
	melee_damage_lower = 20
	melee_damage_upper = 25
	attacktext = "slashed"
	malfunction_chance = 20 //a combination of metal and flesh in a weird and confusing way. I would assume the body is trying to reject the implants/cybernetics.
	mob_size = MOB_MEDIUM
	move_to_delay = 5
	ability_cooldown = 20 SECONDS
	rarity_value = 75
	//internals
	var/fake_dead = FALSE
	var/fake_dead_wait_time = 0
	var/fake_death_cooldown = 0

	speak = list(
				"The dreams. The dreams.",
				"Nothing hurts anymore.",
				"Pain feels good now. Its like I've been rewired.",
				"I wanted to cry at first, but I can't.",
				"They took away all misery.",
				"This isn't so bad. This isn't so bad."
				)
	target_speak = list(
						"Don't try and fix me! We love this!",
						"Just make it easy on yourself!",
						"Stop fighting progress!",
						"Join us! Receive these gifts!",
						"Yes! Hit me! It feels fantastic!",
						"Come on coward, take a swing!"
						)


/mob/living/simple_animal/hostile/hivemind/himan/Life()
	if(!..())
		return

	//shriek
	if(target_mob && !fake_dead && world.time > special_ability_cooldown)
		special_ability()


	//low hp? It's time to play dead
	if(health < 160 && !fake_dead && world.time > fake_death_cooldown)
		fake_death()

	//shhhh, there an ambush
	if(fake_dead)
		stop_automated_movement = TRUE


/mob/living/simple_animal/hostile/hivemind/himan/speak()
	if(!fake_dead)
		..()


/mob/living/simple_animal/hostile/hivemind/himan/mulfunction()
	if(fake_dead)
		return
	..()


/mob/living/simple_animal/hostile/hivemind/himan/MoveToTarget()
	if(!fake_dead)
		..()
	else
		if(!target_mob || SA_attackable(target_mob))
			stance = HOSTILE_STANCE_IDLE
		if(target_mob in ListTargets(10))
			if(get_dist(src, target_mob) > 1)
				stance = HOSTILE_STANCE_ATTACKING


/mob/living/simple_animal/hostile/hivemind/himan/AttackingTarget()
	if(fake_dead)
		if(!Adjacent(target_mob))
			return
		if(target_mob && (world.time > fake_dead_wait_time))
			awake()
	else
		..()


//Shriek stuns our victims and make them deaf for a while
/mob/living/simple_animal/hostile/hivemind/himan/special_ability()
	visible_emote("screams!")
	playsound(src, 'sound/hallucinations/veryfar_noise.ogg', 90, 1)
	for(var/mob/living/victim in view(src))
		if(isdeaf(victim))
			continue

		if(ishuman(victim))
			var/mob/living/carbon/human/H = victim
			if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) && istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
				continue

		victim.Weaken(4)
		to_chat(victim, SPAN_WARNING("You hear loud and terrible scream!"))
	special_ability_cooldown = world.time + ability_cooldown


//Insidiously
/mob/living/simple_animal/hostile/hivemind/himan/proc/fake_death()
	src.visible_message("<b>[src]</b> dies!")
	destroy_surroundings = FALSE
	fake_dead = TRUE
	walk(src, FALSE)
	icon_state = icon_dead
	fake_dead_wait_time = world.time + 10 SECONDS


/mob/living/simple_animal/hostile/hivemind/himan/proc/awake()
	var/mob/living/L = target_mob
	if(L)
		L.attack_generic(src, rand(15, 25)) //stealth attack
		L.Weaken(6)
		visible_emote("suddenly heals its wounds and grabs [L] by the legs, forcing them down onto the floor!") //Nanomachines son!
		var/msg = pick("MORE! I'M NOT DONE YET!", "MORE PAIN!", "THE DREAMS OVERTAKE ME!", "GOD, YES! HURT ME!")
		say(msg)
	destroy_surroundings = TRUE
	heal_overall_damage(30, 0) //more than 10% of maxhealth
	icon_state = "himan-damaged"
	fake_dead = FALSE
	stance = HOSTILE_STANCE_IDLE
	fake_death_cooldown = world.time + 2 MINUTES



/////////////////////////////////////MECHIVER/////////////////////////////////
//Mech + Hive + Driver
//Special ability: Picking up a victim. Sends hallucinations and harm sometimes, then release
//Can picking up corpses too, rebuild them to living hive mobs, like it wires do
//Default malfunction chance
//Increased speaking chance, can take pilot and speak with him
//Dummy thick, slow as fuck
//Rarely can appear from infested machinery (with a circuit board, like an Autholate)
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/mechiver
	name = "Mechiver"
	desc = "Once an exosuit, this hulking amalgamation of armoured flesh and machine drips fresh blood out of the pilot's hatch."
	icon = 'icons/mob/hivemind.dmi'
	icon_state = "mechiver-closed"
	icon_dead = "mechiver-dead"
	health = 500
	maxHealth = 500
	resistance = RESISTANCE_ARMOURED
	melee_damage_lower = 25
	melee_damage_upper = 35
	mob_size = MOB_LARGE
	attacktext = "crushed"
	ability_cooldown = 1 MINUTES
	speak_chance = 8
	move_to_delay = 10
	rarity_value = 125
	//internals
	var/pilot						//Yes, there's no pilot, so we just use var
	var/mob/living/passenger
	var/hatch_closed = TRUE
	//default speaking
	speak = list(
				"A shame this form isn't more fitting.",
				"A girl can get so lonely with no-one to play with...",
				"Beauty is within."
				)
	target_speak = list(
				"What a lovely body. Lay it down intact.",
				"Come here, lover.",
				"First time? I can be gentle, unless you like it rough.",
				"What use is that flesh if you don't enjoy it?",
				"Mine is the caress of steel.",
				"I offer you the ecstasy of union, and yet you tremble."
				)
	//speaking with pilot
	var/list/common_answers = list(
								"Of course, lover.",
								"In sweet time.",
								"Mmm.",
								"But of course darling.",
								"Shh, rest now.",
								"Hush now, child.")
	var/list/other_answers = list(
								"There's room for one more!",
								"Don't be jealous. I can love you both.",
								"Come to bed, you.",
								"Slide over a little for them.",
								"Don't mind the blood, they didn't need it anymore.")
	//pilot quotes
	var/list/pilot_target_speak = list(
						"Three's a crowd, call for help and make it a party!",
						"Hey, if you take them will you let me out?",
						"This ascension! It's sheer bliss!",
						"You! Can you get me out?",
						"Get in! I've got a seat just for you.",
						"Come, join in the dream!")
	var/list/pilot_commontalk = list(
						"You promised paradise.",
						"This pain will end, won't it?",
						"Am I almost finished?",
						"Have we, have you, finished?",
						"Will you release me?")


/mob/living/simple_animal/hostile/hivemind/mechiver/Life()
	if(!..())
		return

	update_icon()

	//when we have passenger, we torture him
	//I'd like to tidy this up so the damage type is linked to specific speech arrays.
	if(passenger && prob(25))
		passenger.damage_through_armor(rand(5,20), pick(BRUTE, BURN, TOX), attack_flag = ARMOR_MELEE)
		to_chat(passenger, SPAN_DANGER(pick(
								"A woman's arm grabs your neck!", "Lips whisper, \" This is the womb of your rebirth... \"", "Hot breath flows over your ear, \" You will enjoy bliss when this is over... \"",
								"A whirring drill bit bores through your chest!", "Something is crushing your ribs!", "Some blood-hot liquid covers you!",
								"The stench of some chemical overwhelms you!", "A dozen needles lance through your skin!",
								"You feel a cold worm-like thing trying to wriggle into your wounds!")))
		anim_shake(src)
		playsound(src, 'sound/effects/clang.ogg', 70, 1)


	//corpse ressurection
	if(!target_mob && !passenger)
		for(var/mob/living/Corpse in view(src))
			if(Corpse.stat == DEAD)
				if(get_dist(src, Corpse) <= 1)
					special_ability(Corpse)
				else
					walk_to(src, Corpse, 1, 1, 4)
				break


/mob/living/simple_animal/hostile/hivemind/mechiver/speak()
	if(!client && prob(speak_chance) && speak.len)
		if(pilot)
			if(target_mob)
				visible_message("<b>[name]'s pilot</b> says, [pick(pilot_target_speak)]")
				say(pick(common_answers))
			else
				visible_message("<b>[name]'s pilot</b> says, [pick(pilot_commontalk)]")
				say(pick(other_answers))
		else
			..()


//animations
//updates every life tick
/mob/living/simple_animal/hostile/hivemind/mechiver/update_icon()
	if(target_mob && !passenger && (get_dist(target_mob, src) <= 4) && !is_on_cooldown())
		if(!hatch_closed)
			return
		overlays.Cut()
		if(pilot)
			flick("mechiver-opening", src)
			icon_state = "mechiver-chief"
			overlays += "mechiver-hands"
		else
			flick("mechiver-opening_wires", src)
			icon_state = "mechiver-welcome"
			overlays += "mechiver-wires"
		hatch_closed = FALSE
	else
		overlays.Cut()
		hatch_closed = TRUE
		icon_state = "mechiver-closed"
		if(passenger)
			overlays += "mechiver-process"


/mob/living/simple_animal/hostile/hivemind/mechiver/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	if(world.time > special_ability_cooldown && !passenger)
		special_ability(target_mob)

	..()


//picking up our victim for good 40 seconds of best road trip ever
/mob/living/simple_animal/hostile/hivemind/mechiver/special_ability(mob/living/target)
	if(!target_mob && hatch_closed) //when we picking up corpses
		if(pilot)
			flick("mechiver-opening", src)
		else
			flick("mechiver-opening_wires", src)
	passenger = target
	target.loc = src
	target.canmove = FALSE
	to_chat(target, SPAN_DANGER("Wires snare your limbs and pull you inside the maneater! You feel yourself bound with a thousand steel tendrils!"))
	playsound(src, 'sound/effects/blobattack.ogg', 70, 1)
	addtimer(CALLBACK(src, PROC_REF(release_passenger)), 40 SECONDS)



/mob/living/simple_animal/hostile/hivemind/mechiver/proc/release_passenger(var/safely = FALSE)
	if(passenger)
		if(pilot)
			flick("mechiver-opening", src)
		else
			flick("mechiver-opening_wires", src)

		if(ishuman(passenger))
			if(!safely) //that was stressful
				var/mob/living/carbon/human/H = passenger
				if(!pilot && H.stat == DEAD)
					destroy_passenger()
					pilot = TRUE
					return

				H.hallucination(rand(30, 90), 100)
		//if mob is dead, we just rebuild it
		if(passenger.stat == DEAD && !safely)
			dead_body_restoration(passenger)

		if(passenger) //if passenger still here, then just release him
			to_chat(passenger, SPAN_DANGER("[src] releases you from its snares!"))
			passenger.canmove = TRUE
			passenger.loc = get_turf(src)
			passenger = null
			special_ability_cooldown = world.time + ability_cooldown
		playsound(src, 'sound/effects/blobattack.ogg', 70, 1)


/mob/living/simple_animal/hostile/hivemind/mechiver/proc/dead_body_restoration(mob/living/corpse)
	var/picked_mob
	if(passenger.mob_size <= MOB_SMALL && !client && prob(50))
		picked_mob = pick(/mob/living/simple_animal/hostile/hivemind/stinger, /mob/living/simple_animal/hostile/hivemind/bomber)
	else
		if(pilot)
			if(ishuman(corpse))
				picked_mob = /mob/living/simple_animal/hostile/hivemind/himan
			else if(istype(corpse, /mob/living/silicon/robot))
				picked_mob = /mob/living/simple_animal/hostile/hivemind/hiborg
	if(picked_mob)
		new picked_mob(get_turf(src))
	else
		var/mob/living/simple_animal/hostile/hivemind/resurrected/fixed_mob = new(get_turf(src))
		fixed_mob.take_appearance(corpse)
	destroy_passenger()


/mob/living/simple_animal/hostile/hivemind/mechiver/proc/destroy_passenger()
	qdel(passenger)
	passenger = null


//we're not forgot to release our victim safely after death
/mob/living/simple_animal/hostile/hivemind/mechiver/Destroy()
	release_passenger(TRUE)
	return ..()

/mob/living/simple_animal/hostile/hivemind/mechiver/death()
	release_passenger(TRUE)
	. = ..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	if(pilot)
		gibs(loc, null, /obj/effect/gibspawner/human)
	qdel(src)



////////////////////////Treader///////////////////
//Ranged just like the lobber, (deals more damage but needs longer to recharge, but given that ranged_cooldown does nothing not implemented yet)
//When damaged, "releases a cloud of nanites" that heal all allies in view
//A bit tanky, but moves slow
//Death releases a EMP pulse
/////////////////////////////////////////////////
/mob/living/simple_animal/hostile/hivemind/treader
	name = "Treader"
	desc = "A human head with a screen shoved in its mouth, connected to a large column with another screen displaying a human face."
	icon_state = "treader"
	attacktext = "slapped"
	speak_chance = 2
	health = 100
	maxHealth = 100
	resistance = RESISTANCE_AVERAGE
	malfunction_chance = 10
	move_to_delay = 10
	rarity_value = 150
	ranged = TRUE
	minimum_distance = 3
	fire_verb = "spits"
	projectiletype = /obj/item/projectile/goo/weak
	projectilesound = 'sound/effects/blobattack.ogg'
	ranged_cooldown = 10 SECONDS
	ability_cooldown = 20 SECONDS

	speak = list(
				"Hey, at least I got my head.",
				"I can\'t... I can\'t feel my arms...",
				"Oh god... my legs... where are my legs..."
				)

	target_speak = list(
				"You there! Cut off my head!",
				"So sorry! Can\'t exactly control my head anymore.",
				"S-shoot the screen! God I hope it won\'t hurt."
				)

/mob/living/simple_animal/hostile/hivemind/treader/Initialize()
	..()
	set_light(2, 1, COLOR_BLUE_LIGHT)

/mob/living/simple_animal/hostile/hivemind/treader/Life()
	if(!..())
		return

	if(maxHealth > health && world.time > special_ability_cooldown)
		special_ability()


/mob/living/simple_animal/hostile/hivemind/treader/special_ability()
	visible_emote("vomits out a burst of rejuvenating nanites!")

	for(var/mob/living/simple_animal/hostile/hivemind/ally in view(src))
		ally.heal_overall_damage(10, 0)

	special_ability_cooldown = world.time + ability_cooldown


/mob/living/simple_animal/hostile/hivemind/treader/death()
	..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	empulse(get_turf(src), 1, 3)
	qdel(src)


/////////////////////////////////////PHASER///////////////////////////////////
//Special ability: Superposition. Phaser exists at four locations. But, actually he vulnerable only at one. Other is just a copies
//Moves with teleportation only, can stun victim if he land on it
//Also can hide in closets
//Can't speak, no malfunctions
//Appears from dead human body
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/phaser
	name = "Phaser"
	desc = "A twisted human with a strange device on its head. Or for its head."
	icon = 'icons/mob/hivemind.dmi'
	icon_state = "phaser-1"
	health = 160
	maxHealth = 160
	attacktext = "warps"
	speak_chance = 0
	malfunction_chance = 0
	mob_size = MOB_MEDIUM
	ability_cooldown = 2 MINUTES
	rarity_value = 90
	//internals
	var/can_use_special_ability = TRUE
	var/list/my_copies = list()

/mob/living/simple_animal/hostile/hivemind/phaser/New()
	..()
	filters += filter(type="blur", size = 0)


/mob/living/simple_animal/hostile/hivemind/phaser/Life()
	stop_automated_movement = TRUE

	if(!..())
		return

	//special ability using
	if(world.time > special_ability_cooldown && can_use_special_ability)
		if(target_mob && (health <= 120))
			special_ability()

	//closet hiding
	if(!target_mob)
		var/obj/structure/closet/C = locate() in get_turf(src)
		if(C && loc != C)
			if(!C.opened)
				C.open(src)
			if(C.opened)
				C.close(src)
		for(var/obj/structure/closet/Closet in view(src))
			if(!Closet.locked && !Closet.welded)
				phase_move_to(Closet)
				break


/mob/living/simple_animal/hostile/hivemind/phaser/AttackTarget()
	if(target_mob && get_dist(src, target_mob) > 1)
		stance = HOSTILE_STANCE_ATTACK
	..()


/mob/living/simple_animal/hostile/hivemind/phaser/MoveToTarget()
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		if(get_dist(src, target_mob) > 1)
			stance = HOSTILE_STANCE_ATTACK
			phase_move_to(target_mob, nearby = TRUE)
		else
			stance = HOSTILE_STANCE_ATTACKING


/mob/living/simple_animal/hostile/hivemind/phaser/proc/is_can_jump_on(turf/target)
	if(!target || target.density || istype(target, /turf/space) || istype(target, /turf/simulated/open))
		return FALSE

	//to prevent reflection's stacking
	var/mob/living/simple_animal/hostile/hivemind/phaser/P = locate() in target
	if(P)
		return FALSE

	for(var/obj/O in target)
		if(!O.CanPass(src, target))
			return FALSE

	return TRUE


//first part of phase moving is just preparation
/mob/living/simple_animal/hostile/hivemind/phaser/proc/phase_move_to(atom/target, var/nearby = FALSE)
	var/turf/new_place
	var/distance_to_target = get_dist(src, target)
	var/turf/target_turf = get_turf(target)
	//if our target is near, we move precisely to it
	if(distance_to_target <= 3)
		if(nearby)
			for(var/d in alldirs)
				var/turf/nearby_turf = get_step(new_place, d)
				if(is_can_jump_on(nearby_turf))
					new_place = nearby_turf
		else
			new_place = target_turf

	if(!new_place)
		//there we make some kind of, you know, that creepy zig-zag moving
		//we just take angle, distort it a bit and turn into dir
		var/angle = Get_Angle(loc, target_turf)
		angle += rand(5, 25)*pick(-1, 1)
		if(angle < 0)
			angle = 360 + angle
		if(angle > 360)
			angle = 360 - angle
		var/tp_direction = angle2dir(angle)
		new_place = get_ranged_target_turf(loc, tp_direction, rand(2, 4))

	if(!is_can_jump_on(new_place))
		return
	//an animation
	var/init_px = pixel_x
	animate(src, pixel_x=init_px + 16*pick(-1, 1), time=5)
	animate(pixel_x=init_px, time=6, easing=SINE_EASING)
	animate(filters[1], size = 5, time = 5, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(phase_jump), new_place), 0.5 SECONDS)


//second part - is jump to target
/mob/living/simple_animal/hostile/hivemind/phaser/proc/phase_jump(turf/place)
	playsound(place, 'sound/effects/phasein.ogg', 60, 1)
	animate(filters[1], size = 0, time = 5)
	icon_state = "phaser-[rand(1,4)]"
	src.loc = place
	for(var/mob/living/L in loc)
		if(L != src)
			visible_message("<b>[src]</b> land on <b>[L]</b>!")
			playsound(place, 'sound/effects/ghost2.ogg', 70, 1)
			L.Weaken(3)


/mob/living/simple_animal/hostile/hivemind/phaser/special_ability()
	my_copies = list() //let's clean it up
	var/possible_directions = alldirs - cardinal
	var/turf/spawn_point = get_turf(src)
	//we gives to copies our appearence and pick random direction for them
	//with animation it's hard to say, who's real. And i hope it looks great
	for(var/i = 1 to 3)
		var/mob/living/simple_animal/hostile/hivemind/phaser/reflection = new type(spawn_point)
		reflection.can_use_special_ability = FALSE
		var/mutable_appearance/my_appearance = new(src)
		reflection.appearance = my_appearance
		my_copies.Add(reflection)

		var/d = pick(possible_directions)
		possible_directions -= d
		var/turf/new_position = get_step(spawn_point, d)
		if(reflection.is_can_jump_on(new_position))
			spawn(1) //ugh, i know, i know, it's bad. Animation
				reflection.forceMove(new_position)
		addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(qdel), reflection), 60 SECONDS)
	loc = get_step(spawn_point, possible_directions[1]) //there must left last direction
	special_ability_cooldown = world.time + ability_cooldown
	playsound(spawn_point, 'sound/effects/cascade.ogg', 100, 1)


/mob/living/simple_animal/hostile/hivemind/phaser/closet_interaction()
	var/obj/structure/closet/closed_closet = loc
	if(closed_closet && istype(closed_closet) && closed_closet.welded)
		phase_jump(closed_closet.loc)


/mob/living/simple_animal/hostile/hivemind/phaser/death()
	if(my_copies.len)
		for(var/mob/living/simple_animal/hostile/hivemind/phaser/My_copy in my_copies)
			qdel(My_copy)
	..()
	gibs(loc, null, /obj/effect/gibspawner/human)
	qdel(src)
