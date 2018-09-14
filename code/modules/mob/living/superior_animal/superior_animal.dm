/mob/living/superior_animal
	name = "superior animal"
	desc = "You should not see this."

	// ----------------- MOVEMENT ----------------- //
	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	var/speed = 1
	mob_size = MOB_SMALL

	// --------------- ICONS THINGS --------------- //
	icon = 'icons/mob/animal.dmi'
	icon_state = "tomato"
	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	// ------------------ EMOTES ------------------ //
	var/emote_see = list()
	var/speak_chance = 5
	var/turns_per_move = 3
	var/turns_since_move = 0

	var/response_help  = "pets"
	var/response_disarm = "gently pushes aside"
	var/response_harm   = "pokes"

	var/harm_intent_damage = 3

	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/roachmeat
	var/meat_amount = 3

	// ------------------ DAMAGE ------------------ //
	var/melee_damage_lower = 0
	var/melee_damage_upper = 10
	var/attacktext = "bitten"
	var/attack_sound = 'sound/voice/insect_battle_bite.ogg'

	var/friendly = "nuzzles"
	var/environment_smash = 1
	var/resistance		  = 0	// Damage reduction

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

	// -------------- NULL ROD THINGS ------------- //
	var/supernatural = 0
	var/purge = 0

/mob/living/superior_animal/New()
	..()
	if(!icon_living)
		icon_living = icon_state
	if(!icon_dead)
		icon_dead = "[icon_state]_dead"

	verbs -= /mob/verb/observe

/mob/living/superior_animal/proc/visible_emote(message)
	if(islist(message))
		message = safepick(message)
	if(message)
		visible_message("<span class='name'>[src]</span> [message]")


/mob/living/superior_animal/proc/harvest(var/mob/user)
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