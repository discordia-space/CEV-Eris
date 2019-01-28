//Space bears!
/mob/living/carbon/superior_animal/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "bear"
	icon_gib = "bear_gib"
	speak_emote = list("growls", "roars")
	emote_see = list("stares ferociously at", "growls at", "sizes up", "glares hungrily at")
	speak_chance = 5
	turns_per_move = 4
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/bearmeat
	meat_amount = 6
	stop_automated_movement_when_pulled = 0
	maxHealth = 250
	melee_damage_lower = 20
	melee_damage_upper = 35
	randpixel = 8
	can_burrow = FALSE
	breath_required_type = 0 //Does not breathe
	attacktext = "mauled"

	var/quiet_sounds = list('sound/effects/creatures/bear_quiet_1.ogg',
	'sound/effects/creatures/bear_quiet_2.ogg',
	'sound/effects/creatures/bear_quiet_3.ogg',
	'sound/effects/creatures/bear_quiet_4.ogg',
	'sound/effects/creatures/bear_quiet_5.ogg',
	'sound/effects/creatures/bear_quiet_6.ogg')
	var/loud_sounds = list('sound/effects/creatures/bear_loud_1.ogg',
	'sound/effects/creatures/bear_loud_2.ogg',
	'sound/effects/creatures/bear_loud_3.ogg',
	'sound/effects/creatures/bear_loud_4.ogg')

	//Space bears aren't affected by atmos.


	min_air_pressure = 0 //Exists happily in a vacuum
	max_air_pressure = 120 //poor tolerance for high pressure
	min_bodytemperature = 0
	max_bodytemperature = 320 //Vulnerable to fire

	faction = "russian"

	//Anger management!
	//Bears are territorial, they gradually become more angry whenever they see a nearby target
	//They will not attack until anger reaches the attack threshold
	var/anger = 0
	var/anger_attack_threshold = 20


//Staring is rude
//Bears are quick to recognise rudeness
/mob/living/carbon/superior_animal/bear/examine(var/mob/user)
	if (isliving(user))
		anger++
	.=..()





/mob/living/carbon/superior_animal/bear/proc/angry()
	if (anger < anger_attack_threshold)
		return FALSE
	return TRUE

/mob/living/carbon/superior_animal/bear/speak_audio()
	if (anger > 10)
		growl_loud()
	else
		growl_soft()


//Plays a random selection of six sounds, at a low volume
//This is triggered randomly periodically by the bear
/mob/living/carbon/superior_animal/bear/proc/growl_soft()
	var/sound = pick(quiet_sounds)
	playsound(src, sound, 70, 1,3, use_pressure = 0)


//Plays a loud sound from a selection of four
//Played when bear is attacking or dies
/mob/living/carbon/superior_animal/bear/proc/growl_loud()
	var/sound = pick(loud_sounds)
	playsound(src, sound, 100, 1, 5, use_pressure = 0)
	for (var/mob/living/L in view(2, src))
		if (L.client)
			shake_camera(L, 3, 0.5)
