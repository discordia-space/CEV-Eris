
/mob/living/simple_animal/hostile/retaliate/beast
	var/hunger = 0
	var/list/prey = list()

/mob/living/simple_animal/hostile/retaliate/beast/ListTargets(var/dist = 7)
	var/list/see = ..()
	if(see.len)
		return see
	if(prey.len)
		. = list()
		for(var/weakref/W in prey)
			var/mob/M = W.resolve()
			if(M)
				. +=69
		return
	if(hunger > 500) //time to look for some food
		for(var/mob/living/L in69iew(src, dist))
			if(!attack_same && L.faction != faction)
				prey |= weakref(L)

/mob/living/simple_animal/hostile/retaliate/beast/Life()
	. = ..()
	if(!.)
		return FALSE
	hunger++
	if(hunger < 100) //stop hunting when satiated
		prey.Cut()
	else
		for(var/mob/living/simple_animal/S in range(src,1))
			if(S.stat == DEAD)
				visible_message("69src69 consumes \the body of 69S69!")
				var/turf/T = get_turf(S)
				var/obj/item/remains/xeno/X =69ew(T)
				X.desc += "These look like they belong to \a 69S.name69."
				hunger =69ax(0, hunger - 5*S.maxHealth)
				if(prob(5))
					S.gib()
				else
					qdel(S)

/mob/living/simple_animal/proc/name_species()
	set69ame = "Name Alien Species"
	set category = "Exploration"
	set src in69iew()

	if(!config.use_overmap)
		return
	if(!CanInteract(usr, GLOB.conscious_state))
		return

	for(var/obj/effect/overmap/sector/exoplanet/E)
		if(src in E.animals)
			var/newname = input("What do you want to69ame this species?", "Species69aming", E.get_random_species_name()) as text|null
			newname = sanitizeName(newname, allow_numbers = TRUE)
			if(newname && CanInteract(usr, GLOB.conscious_state))
				if(E.rename_species(type,69ewname))
					to_chat(usr,"<span class='notice'>This species will be known from69ow on as '69newname69'.</span>")
				else
					to_chat(usr,"<span class='warning'>This species has already been69amed!</span>")
			return
/*
/mob/living/simple_animal/hostile/retaliate/beast/samak
	name = "samak"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."
	faction = "samak"
	icon_state = "samak"
	icon_living = "samak"
	icon_dead = "samak_dead"
	move_to_delay = 2
	maxHealth = 125
	health = 125
	speed = 2
	melee_damage_lower = 5
	melee_damage_upper = 15
	melee_damage_flags = DAM_SHARP
	attacktext = "mauled"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its69ane","stomps")
	emote_hear = list("snuffles")
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/retaliate/beast/samak/alt
	desc = "A fast, armoured predator accustomed to hiding and ambushing."
	icon_state = "samak-alt"
	icon_living = "samak-alt"
	icon_dead = "samak-alt_dead"

/mob/living/simple_animal/hostile/retaliate/beast/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt69eat on occasion."
	faction = "diyaab"
	icon_state = "diyaab"
	icon_living = "diyaab"
	icon_dead = "diyaab_dead"
	move_to_delay = 1
	maxHealth = 25
	health = 25
	speed = 1
	melee_damage_lower = 1
	melee_damage_upper = 8
	melee_damage_flags = DAM_SHARP
	attacktext = "gouged"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Awrr?","Aowrl!","Worrl")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")
	mob_size =69OB_SMALL

/mob/living/simple_animal/hostile/retaliate/beast/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent69ane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	move_to_delay = 1
	maxHealth = 75
	health = 75
	speed = 1
	melee_damage_lower = 3
	melee_damage_upper = 12
	melee_damage_flags = DAM_SHARP
	attacktext = "gouged"
	cold_damage_per_tick = 0
	speak_chance = 2
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out its69ane","tinkles gently")

/mob/living/simple_animal/hostile/retaliate/beast/shantak/alt
	desc = "A piglike creature with a long and graceful69ane. Don't be fooled by its beauty."
	icon_state = "shantak-alt"
	icon_living = "shantak-alt"
	icon_dead = "shantak-alt_dead"
	emote_see = list("scratches the ground","shakes out it's69ane","rustles softly")

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature69aguely resembling an oversized snail without a shell."
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	mob_size =69OB_TINY

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	mob_size =69OB_TINY

/mob/living/simple_animal/thinbug
	name = "taki"
	desc = "It looks like a bunch of legs."
	icon_state = "thinbug"
	icon_living = "thinbug"
	icon_dead = "thinbug_dead"
	speak_chance = 1
	emote_hear = list("scratches the ground","chitters")
	mob_size =69OB_MINISCULE

/mob/living/simple_animal/hostile/retaliate/royalcrab
	name = "cragenoy"
	desc = "It looks like a crustacean with an exceedingly hard carapace. Watch the pinchers!"
	faction = "crab"
	icon_state = "royalcrab"
	icon_living = "royalcrab"
	icon_dead = "royalcrab_dead"
	move_to_delay = 3
	maxHealth = 150
	health = 150
	speed = 1
	melee_damage_lower = 2
	melee_damage_upper = 5
	attacktext = "pinched"
	speak_chance = 1
	emote_see = list("skitters","oozes liquid from its69outh", "scratches at the ground", "clicks its claws")
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT
		)

/mob/living/simple_animal/hostile/retaliate/beast/charbaby
	name = "charbaby"
	desc = "A huge grubby creature."
	icon_state = "char"
	icon_living = "char"
	icon_dead = "char_dead"
	mob_size =69OB_LARGE
	damtype = BURN
	health = 45
	maxHealth = 45
	melee_damage_lower = 2
	melee_damage_upper = 3
	speed = 2
	response_help =  "pats briefly"
	response_disarm = "gently pushes"
	response_harm = "strikes"
	attacktext = "singed"
	return_damage_min = 2
	return_damage_max = 3
	harm_intent_damage = 1
	blood_color = COLOR_NT_RED
	natural_armor = list(
		laser = ARMOR_LASER_HANDGUNS
		)

/mob/living/simple_animal/hostile/retaliate/beast/charbaby/attack_hand(mob/living/carbon/human/H)
	. = ..()
	reflect_unarmed_damage(H, BURN, "amorphous69ass")

/mob/living/simple_animal/hostile/retaliate/beast/charbaby/AttackingTarget()
	. = ..()
	if(isliving(target_mob) && prob(25))
		var/mob/living/L = target_mob
		if(prob(10))
			L.adjust_fire_stacks(1)
			L.IgniteMob()

/mob/living/simple_animal/hostile/retaliate/beast/shantak/lava
	desc = "A69aguely canine looking beast. It looks as though its fur is69ade of stone wool."
	icon_state = "lavadog"
	icon_living = "lavadog"
	icon_dead = "lavadog_dead"
	attacktext = "bit"
	speak = list("Karuph","Karump")*/