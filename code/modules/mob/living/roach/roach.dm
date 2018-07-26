/mob/living/roach
	name = "Kampfer Roach"
	desc = "A monstrous, dog-sized cockroach. These huge mutants can be everywhere where humans are, on ships, planets and stations."

	// --------------- ICONS THINGS --------------- //
	icon = 'icons/mob/animal.dmi'
	icon_state = "roach"

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	// ----------------- MOVEMENT ----------------- //
	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	density = 0 //Swarming roaches! They also more robust that way.
	var/speed = 4
	mob_size = MOB_SMALL

	// ------------------ EMOTES ------------------ //
	var/emote_see = list("chirps loudly.", "cleans its whiskers with forelegs.")
	var/speak_chance = 5
	var/turns_per_move = 3
	var/turns_since_move = 0

	var/response_help = "pets the"
	var/response_disarm = "pushes aside"
	var/response_harm = "stamps on"

	// ------------- MEAT AND HEALTH -------------- //
	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/roachmeat
	var/meat_amount = 3

	maxHealth = 10
	health = 10

	var/blattedin_revives_left = 1 // how many times blattedin can get us back to life (as num for adminbus fun).

	// -------------- SURVIVABILITY --------------- //
	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0

	//Atmos effect - Yes, you can make creatures that require plasma or co2 to survive.
	//N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/min_oxy = 5
	var/max_oxy = 0					//Leaving something at 0 means it's off - has no maximum
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above

	// ------------------ DAMAGE ------------------ //
	var/harm_intent_damage = 3
	var/melee_damage_lower = 1
	var/melee_damage_upper = 4
	var/attacktext = "bitten"
	var/attack_sound = 'sound/voice/insect_battle_bite.ogg'

	var/friendly = "nuzzles"
	var/environment_smash = 1
	var/resistance		  = 0	// Damage reduction

	// -------------- NULL ROD THINGS ------------- //
	var/supernatural = 0
	var/purge = 0


/mob/living/roach/New()
	..()
	if(!icon_living)
		icon_living = icon_state
	if(!icon_dead)
		icon_dead = "[icon_state]_dead"

	verbs -= /mob/verb/observe


/mob/living/roach/Login()
	if(src && src.client)
		src.client.screen = null
	..()


/mob/living/roach/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Health: [round((health / maxHealth) * 100)]%")


/mob/living/roach/proc/visible_emote(message)
	if(islist(message))
		message = safepick(message)
	if(message)
		visible_message("<span class='name'>[src]</span> [message]")


/mob/living/roach/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	return tally+config.animal_delay


/mob/living/roach/get_speech_ending(verb, var/ending)
	return verb


/mob/living/roach/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return 1


/mob/living/roach/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message(SPAN_DANGER("[user] chops up \the [src]!"))
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message(SPAN_DANGER("[user] butchers \the [src] messily!"))
			gib()