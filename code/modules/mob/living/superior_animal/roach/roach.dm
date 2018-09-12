/mob/living/superior_animal/roach
	name = "Kampfer Roach"
	desc = "A monstrous, dog-sized cockroach. These huge mutants can be everywhere where humans are, on ships, planets and stations."

	// --------------- ICONS THINGS --------------- //
	icon_state = "roach"

	// ----------------- MOVEMENT ----------------- //
	density = 0 //Swarming roaches! They also more robust that way.
	speed = 4

	// ------------------ EMOTES ------------------ //
	emote_see = list("chirps loudly.", "cleans its whiskers with forelegs.")
	speak_chance = 5
	turns_per_move = 3
	turns_since_move = 0

	response_help = "pets the"
	response_disarm = "pushes aside"
	response_harm = "stamps on"

	// ------------- MEAT AND HEALTH -------------- //
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/roachmeat
	meat_amount = 3

	maxHealth = 10
	health = 10

	var/blattedin_revives_left = 1 // how many times blattedin can get us back to life (as num for adminbus fun).

	// ------------------ DAMAGE ------------------ //
	melee_damage_lower = 1
	melee_damage_upper = 4


/mob/living/superior_animal/roach/Login()
	if(src && src.client)
		src.client.screen = null
	..()


/mob/living/superior_animal/roach/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Health: [round((health / maxHealth) * 100)]%")


/mob/living/superior_animal/roach/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	return tally+config.animal_delay


/mob/living/superior_animal/roach/get_speech_ending(verb, var/ending)
	return verb


/mob/living/superior_animal/roach/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return 1
