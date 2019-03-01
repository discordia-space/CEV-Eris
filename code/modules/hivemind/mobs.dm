
///////////Hive mobs//////////
//Some of them can be too tough and dangerous, but they must be so. Also don't forget, they are really rare thing.
//Just bring corpses from wires away, and little mobs is not a problem
//Mechiver have 1% chance to spawn from machinery. With failure chance calculation, this is very raaaaaare
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
	attacktext = "bangs with his head"
	universal_speak = TRUE
	speak_chance = 5
	var/malfunction_chance = 5
	var/ability_cooldown = 30 SECONDS
	var/list/target_speak = list()			//this is like speak list, but when we see our target

	//internals
	var/obj/machinery/hivemind_machine/master
	var/special_ability_cooldown = 0		//use ability_cooldown, don't touch this


	New()
		. = ..()
		//here we change name, so design them according to this
		name = pick("strange ", "unusual ", "odd ", "undiscovered ", "an interesting ") + name

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
		say(pick("Fu-ue-ewe-eweu-u-uck!", "A-a-ah! Sto-op! Stop it pl-pleasuew...", "Go-o-o-od God-d-dpf!", "BZE-EW-EWQ! He-e-el-l-el!"))
	addtimer(CALLBACK(src, .proc/malfunction_result), 2 SECONDS)


//It's second proc, result of our malfunction
/mob/living/simple_animal/hostile/hivemind/proc/malfunction_result()
	if(prob(malfunction_chance))
		apply_damage(rand(10, 25), BURN)


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
			if(malfunction_chance < 20)
				malfunction_chance = 20
		if(2)
			if(malfunction_chance < 30)
				malfunction_chance = 30
	health -= 20*severity


/mob/living/simple_animal/hostile/hivemind/death()
	if(master) //for spawnable mobs
		master.spawned_creatures.Remove(src)
	. = ..()



///life's///////////////////////////////////////////////////
////////////////////////////////RESURRECTION///////////////
///////////////////////////////////////////////go on//////


//these guys is appears from bodies, and takes corpses appearence
/mob/living/simple_animal/hostile/hivemind/resurrected
	name = "resurrected creature"
	malfunction_chance = 10


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

	maxHealth = victim.maxHealth * 2 + 10
	health = maxHealth
	name = "[pick("rebuilded", "undead", "unnatural", "fixed")] [victim.name]"
	if(lentext(victim.desc))
		desc = desc + " But something wasn't right..."
	density = victim.density
	mob_size = victim.mob_size
	pass_flags = victim.pass_flags

	//corrupted speak imitation
	var/phrase_amount = rand(2, 5)
	for(var/count = 1 to phrase_amount)
		var/first_word = pick("You", "I", "They", "Hive", "Corpses", "We", "Your friend", "This ship", "Your mind", "These guys")
		var/second_word = pick("kill", "stop", "transform", "connect", "rebuild", "fix", "hug", "hit", "told", "help", "rework", "burn")
		var/third_word = pick("them", "me", "you", "your soul", "us", "hive", "system", "this ship", "your head", "your brain")
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
//High chance of malfunction
//Default speaking chance
//Appears from dead small mobs or from hive spawner
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/stinger
	name = "medbot"
	desc = "A little medical robot. He looks somewhat underwhelmed. Wait a minute, is that a blade?"
	icon_state = "slicer"
	attacktext = "slice"
	density = 0
	speak_chance = 3
	malfunction_chance = 15
	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	speed = 4

	speak = list(
				"I've seen this ai. Ma-an, that's aw-we-e-ewful!",
				"I know, i know, i remember this one.",
				"Rad-d-dar, put a ma-ma... mask on!",
				"Delicious! Delicious... Del-delicious?..",
				)
	target_speak = list(
				"Hey, i'm comming!",
				"Hold on! I'm almost there!",
				"I'll help you! Come closer.",
				"Only one healthy prick!",
				"He-e-ey?"
				)


/mob/living/simple_animal/hostile/hivemind/stinger/death()
	..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	qdel(src)


/////////////////////////////////////BOMBER///////////////////////////////////
//Special ability: none
//Explode in contact with target
//High chance of malfunction
//Default speaking chance
//Appears from dead small mobs or from hive spawner
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/bomber
	name = "bot"
	desc = "This one looks fine. Only sometimes it careens from one side to the other."
	icon_state = "bomber"
	density = 0
	speak_chance = 3
	malfunction_chance = 15
	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	speed = 6

	speak = list(
				"Can you help me, please? There's something strange.",
				"Are you... Are you kidding?",
				"I want to pass away, just trying to get out of here",
				"This place is really bad, we are in deep shit here.",
				"I'm not sure if we can just stop it",
				)
	target_speak = list(
						"Here you are! I have something for you. Something special!",
						"Hey! Hey? Help me, please!",
						"Hey, look, look. I won't harm you, just calm down!",
						"Oh god, this is... Yes, this is what we are looking for."
						)


/mob/living/simple_animal/hostile/hivemind/bomber/Initialize()
	..()
	set_light(2, 1, "#820D1C")


/mob/living/simple_animal/hostile/hivemind/bomber/death()
	..()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	explosion(get_turf(src), 0, 0, 2)
	qdel(src)


/mob/living/simple_animal/hostile/hivemind/bomber/AttackingTarget()
	death()


////hive brings us here to////////////////////////////////////////////////////
////////////////////////////////////BIG GUYS/////////////////////////////////
/////////////////////////////////////////////////////fright and destroy/////



/////////////////////////////////////HIBORG///////////////////////////////////
//Hive + Cyborg
//Special ability: none...
//Have a few types of attack: Default one.
//							  Claw, that press down the victims.
//							  Splash attack, that slash everything around!
//High chance of malfunction
//Default speaking chance
//Appears from dead cyborgs
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/hiborg
	name = "cyborg"
	desc = "A cyborg covered with something... something alive."
	icon_state = "hiborg"
	icon_dead = "hiborg-dead"
	health = 220
	maxHealth = 220
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "claws"
	speed = 12
	malfunction_chance = 15
	mob_size = MOB_MEDIUM

	speak = list("Everytime something breaks apart. Hell, I hate this job!",
				"What? I hear something. Just mice? Just mice, phew...",
				"I'm too tired, man, too tired. This job is... Awful.",
				"These people know nothing about this work or about me. I can surprise them.",
				"Blue wire is bolts, green is safety. Just... Pulse it here, okay? Right...")
	target_speak = list(
						"I know what's wrong, just let me fix that.",
						"You need my help? What's wrong? Gimme that thing, I can fix that.",
						"Si-i-ir... Sir. Sir. It's better to... Stop here! Stop i said, what are you!?",
						"Wait! Hey! Can i fix that!? I'm an engineer, you fuck! Sto-op-op-p here, i know what to do!"
						)


/mob/living/simple_animal/hostile/hivemind/hiborg/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	//special attacks
	if(prob(10))
		splash_slash()
		return

	if(prob(40))
		stun_with_claw()
		return

	return ..() //default attack


/mob/living/simple_animal/hostile/hivemind/hiborg/proc/splash_slash()
	src.visible_message(SPAN_DANGER("[src] spins around and slashes in a circle!"))
	for(var/atom/target in range(1, src))
		if(target != src)
			target.attack_generic(src, rand(melee_damage_lower, melee_damage_upper*2))
	if(!client && prob(speak_chance))
		say(pick("Get away from me!", "They are everywhere!"))


/mob/living/simple_animal/hostile/hivemind/hiborg/proc/stun_with_claw()
	if(isliving(target_mob))
		var/mob/living/victim = target_mob
		victim.Weaken(5)
		src.visible_message(SPAN_WARNING("[src] holds down [victim] to the floor with his claw."))
		if(!client && prob(speak_chance))
			say(pick("Stand still, I'll make it fast!",
					"I will fix you! Don't resist! Don't resist you rat!",
					"I just want to replace that broken thing!"))


/////////////////////////////////////HIMAN////////////////////////////////////
//Hive + Man
//Special ability: Shriek, that stuns victims
//Can fool his enemies and pretend to be dead
//A little bit higher chance of malfunction
//Default speaking chance
//Appears from dead human corpses
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/himan
	name = "human"
	desc = "This guy is totally not human. You can see tubes all across his body and metal where flesh should be."
	icon_state = "himan"
	icon_dead = "himan-dead"
	health = 120
	maxHealth = 120
	melee_damage_lower = 20
	melee_damage_upper = 25
	attacktext = "slashes with claws"
	malfunction_chance = 10
	mob_size = MOB_MEDIUM
	speed = 8
	ability_cooldown = 30 SECONDS
	//internals
	var/fake_dead = FALSE
	var/fake_dead_wait_time = 0
	var/fake_death_cooldown = 0

	speak = list(
				"Stop... It. Just... STOP IT!",
				"Why, honey? Why? Why-hy-hy?",
				"That noise... My head! Shit!",
				"There must be an... An esca-cape!",
				"Come on, you ba-ba-bastard, I know what you really want.",
				"How much fun!"
				)
	target_speak = list(
						"Are you... Are you okay? Wa-wait, wait a minu-nu-nute.",
						"Come on, you ba-ba-bastard, i know what you really want to.",
						"How much fun!",
						"Are you try-trying to escape? That is how you plan to do it? Then run... Run...",
						"Wait! Can you just... Just pull out this thing from my he-head? Wait...",
						"Hey! I'm friendly! Wait, it's just a-UGH"
						)


/mob/living/simple_animal/hostile/hivemind/himan/Life()
	. = ..()

	//shriek
	if(target_mob && !fake_dead && world.time > special_ability_cooldown)
		special_ability()


	//low hp? It's time to play dead
	if(health < 60 && !fake_dead && world.time > fake_death_cooldown)
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

		victim.Weaken(5)
		victim.ear_deaf = 40
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
		L.Weaken(5)
		visible_emote("grabs [L]'s legs and force them down to the floor!")
		var/msg = pick("SEU-EU-EURPRAI-AI-AIZ-ZT!", "I'M NOT DO-DONE!", "HELL-L-LO-O-OW!", "GOT-T YOU HA-HAH!")
		say(msg)
	destroy_surroundings = TRUE
	icon_state = "himan-damaged"
	fake_dead = FALSE
	stance = HOSTILE_STANCE_IDLE
	fake_death_cooldown = world.time + 2 MINUTES



/////////////////////////////////////MECHIVER/////////////////////////////////
//Mech + Hive + Driver
//Special ability: Picking up a victim. Sends hallucinations and harm sometimes, then release
//Can picking up corpses too, rebuild them to living hive mobs, like it wires do
//Default malfunction chance
//Default speaking chance, can take pilot and speak with him
//Very rarely can appears from infested machinery
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/mechiver
	name = "Robotic Horror"
	desc = "A weird-looking machinery Frankenstein"
	icon = 'icons/mob/hivemind.dmi'
	icon_state = "mechiver-closed"
	icon_dead = "mechiver-dead"
	health = 450
	maxHealth = 450
	melee_damage_lower = 10
	melee_damage_upper = 15
	mob_size = MOB_LARGE
	attacktext = "tramples"
	ability_cooldown = 1 MINUTE
	speak_chance = 5
	speed = 16
	//internals
	var/pilot						//Yes, there's no pilot, so we just use var
	var/mob/living/passenger
	var/hatch_closed = TRUE
	//default speaking
	speak = list(
				"Somebody, just tell him to shut up...",
				"Bzew-zew-zewt. Th-this way!",
				"Wha-a-at? When I'm near this cargo, I feel... fe-fe-fea-fear-er.")
	target_speak = list(
				"Come here, jo-jo-join me. Join us-s.",
				"Time to be-to be-to be whole.",
				"Enter me, i'm be-best mech among all of these rusty buckets.",
				"I'm dying. I can't see my ha-hands! I'm scared, hu-hu-hug me.",
				"I'm not done, it can't be... Hey! Hey you, enter me!")
	//speaking with pilot
	var/list/common_answers = list(
								"Right, chief.",
								"Yes.",
								"Right.",
								"True.",
								"Yep.",
								"That's right, chief.")
	var/list/other_answers = list(
								"Pathetic.",
								"How curious.",
								"We can use it.",
								"Useless.",
								"Disgusting")
	//pilot quotes
	var/list/pilot_target_speak = list(
						"Hey! Hey you, wanna, hah, ri-i-ide? It's free!",
						"Look at this one! Let's-s-s... Take it.",
						"Wait a minute, we just want to fu-fu-fun with you!",
						"I see you. We see you.",
						"Get in! I've got a seat just for you.",
						"Don't be afraid, it's almost painless.")
	var/list/pilot_commontalk = list(
						"They are so unfinished, so fragile-ile.",
						"Look at these... Creatures, I've never seen them before.",
						"Hah, did you hear that? They're trying to use some sort of we-wep-weapons!",
						"Useless things, i'm not satisfied.",
						"This place sucks, man. So creep-p-pew-wepy and no fun, only rudimentary creatures would enjoy living here.")


/mob/living/simple_animal/hostile/hivemind/mechiver/Life()
	. = ..()
	update_icon()

	//when we have passenger, we torture him
	if(passenger && prob(15))
		passenger.apply_damage(rand(5, 10), pick(BRUTE, BURN, TOX))
		to_chat(passenger, SPAN_DANGER(pick(
								"Something grabs your neck!", "You hear whisper: \" It's okay, now you're sa-sa-safe! \"",
								"You've been hit by something metal", "You almost can't feel your leg!", "Something liquid covers you!",
								"You feel awful and smell something rotten", "Something sharp cut your cheek!",
								"You feel something worm-like trying to wriggle into your skull through your ear...")))
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
/mob/living/simple_animal/hostile/hivemind/mechiver/proc/update_icon()
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


//picking up our victim for good 20 seconds of best road trip ever
/mob/living/simple_animal/hostile/hivemind/mechiver/special_ability(mob/living/target)
	if(!target_mob && hatch_closed) //when we picking up corpses
		if(pilot)
			flick("mechiver-opening", src)
		else
			flick("mechiver-opening_wires", src)
	passenger = target
	target.loc = src
	target.canmove = FALSE
	to_chat(target, SPAN_DANGER("You've gotten inside that thing! It's hard to see inside, there's something here, it moves around you!"))
	playsound(src, 'sound/effects/blobattack.ogg', 70, 1)
	addtimer(CALLBACK(src, .proc/release_passenger), 40 SECONDS)



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

				H.hallucination = rand(30, 90)
		//if mob is dead, we just rebuild it
		if(passenger.stat == DEAD && !safely)
			dead_body_restoration(passenger)

		if(passenger) //if passenger still here, then just release him
			to_chat(passenger, SPAN_DANGER("[src] released you!"))
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
			else if(isrobot(corpse))
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


/////////////////////////////////////PHASER///////////////////////////////////
//Special ability: Superposition. Phaser exists at four locations. But, actually he vulnerable only at one. Other is just a copies
//Moves with teleportation only, can stun victim if he land on it
//Also can hide in closets
//Can't speak, no malfunctions
//Appears from dead human body
//////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/hivemind/phaser
	name = "phaser"
	desc = "A Crooked human with a strange device on its head. It twitches sometimes and... Why are you still looking? Run!"
	icon = 'icons/mob/hivemind.dmi'
	icon_state = "phaser-1"
	health = 120
	maxHealth = 120
	speak_chance = 0
	malfunction_chance = 0
	mob_size = MOB_MEDIUM
	ability_cooldown = 2 MINUTES
	//internals
	var/can_use_special_ability = TRUE
	var/list/my_copies = list()

/mob/living/simple_animal/hostile/hivemind/phaser/New()
	..()
	filters += filter(type="blur", size = 0)


/mob/living/simple_animal/hostile/hivemind/phaser/Life()
	stop_automated_movement = TRUE
	. = ..()

	//special ability using
	if(world.time > special_ability_cooldown && can_use_special_ability)
		if(target_mob && (health <= 50))
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
	addtimer(CALLBACK(src, .proc/phase_jump, new_place), 0.5 SECOND)


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
		addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, reflection), 60 SECONDS)
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