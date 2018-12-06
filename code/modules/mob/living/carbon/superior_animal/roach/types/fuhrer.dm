//Fuhrer roach is a colossal, slow moving leader
/mob/living/carbon/superior_animal/roach/fuhrer
	name = "Fuhrer Roach"
	desc = "A glorious leader of cockroaches. Literally Hitler."
	icon_state = "fuhrer"

	meat_amount = 20
	turns_per_move = 4
	maxHealth = 200
	health = 200

	melee_damage_lower = 15
	melee_damage_upper = 30
	move_to_delay = 8
	var/distress_level = 0
	extra_burrow_chance = 100


/mob/living/carbon/superior_animal/roach/fuhrer/update_icons()
	.=..()
	var/matrix/M = transform
	M.Scale(1.3)
	transform = M


/*When its subordinates die, the leader may call for aid.
Every nearby roach death triggers this proc, and increases the chance of a call
All the burrows in a wide area will request rapid reinforcements, causing a significant number of roaches to
flood into this room and surrounding ones*/

/mob/living/carbon/superior_animal/roach/fuhrer/proc/distress_call()

	distress_level += 1

	/*
	In order to make it more likely that players will be around to witness it, lets add more distress if we can
	see a human player

	*/
	for (var/mob/living/carbon/human/H in view())
		if (H.stat != DEAD && H.client)
			distress_level += 2
			break

	if (distress_level > 0 && prob(distress_level))

		distress_level = -20 //Once a call is successfully triggered, set the chance negative
		//So it will be a while before this guy can send another call

		playsound(src.loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
		spawn(2)
			playsound(src.loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
			//Playing the sound twice will make it sound really horrible

		visible_message(SPAN_DANGER("[src] emits a horrifying wail as nearby burrows stir to life!"))

		//Add all nearby burrows to the distressed burrows list
		//for (var/obj/structure/burrow/B in range(20, loc))
		for (var/B in find_nearby_burrows())
			distressed_burrows |= B

		spawn()
			SSmigration.handle_distress_calls()
