/mob/living/carbon/superior_animal
	name = "superior animal"
	desc = "You should not see this."

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_size = MOB_SMALL
	a_intent = I_HURT

	icon = 'icons/mob/animal.dmi'
	icon_state = "tomato"

	var/icon_living
	var/icon_dead
	var/icon_rest //resting/unconscious animation
	var/icon_gib //gibbing animation
	var/icon_dust //dusting animation
	var/dust_remains = /obj/effect/decal/cleanable/ash

	var/emote_see = list() //chat emotes
	var/speak_chance = 2 //percentage chance of speaking a line from 'emote_see'

	var/turns_per_move = 3 //number of life ticks per random movement
	var/turns_since_move = 0 //number of life ticks since last random movement
	var/wander = 1 //perform automated random movement when idle
	var/stop_automated_movement = 0 //use this to temporarely stop random movement
	var/stop_automated_movement_when_pulled = 0

	var/deathmessage = "dies."
	var/attacktext = "bitten"
	var/attack_sound = 'sound/weapons/spiderlunge.ogg'
	var/attack_sound_chance = 25
	var/attack_sound_volume = 30
	var/friendly = "nuzzles"

	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/roachmeat
	var/meat_amount = 3

	var/melee_damage_lower = 0
	var/melee_damage_upper = 10

	var/environment_smash = 1

	var/list/objectsInView //memoization for getObjectsInView()
	var/viewRange = 7
	var/acceptableTargetDistance = 1 //consider all targets within this range equally

	var/stance = HOSTILE_STANCE_IDLE //Used to determine behavior
	var/atom/target_mob
	var/attack_same = 0 //whether AI should target own faction members for attacks
	var/list/friends = list()
	var/move_to_delay = 4 //delay for walk() movement

	var/destroy_surroundings = 1
	var/break_stuff_probability = 10

/mob/living/carbon/superior_animal/New()
	..()
	if(!icon_living)
		icon_living = icon_state
	if(!icon_dead)
		icon_dead = "[icon_state]_dead"

	objectsInView = new

	verbs -= /mob/verb/observe

/mob/living/carbon/superior_animal/Destroy()
	. = ..()

/mob/living/carbon/superior_animal/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/superior_animal/proc/visible_emote(message)
	if(islist(message))
		message = safepick(message)
	if(message)
		visible_message("<span class='name'>[src]</span> [message]")