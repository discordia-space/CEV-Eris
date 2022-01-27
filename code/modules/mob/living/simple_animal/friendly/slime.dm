/mob/living/simple_animal/slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey baby slime"
	icon_dead = "grey baby slime dead"
	speak_emote = list("chirps")
	health = 100
	maxHealth = 100
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	emote_see = list("jiggles", "bounces in place")
	var/colour = "grey"
	can_burrow = TRUE

/mob/living/simple_animal/slime/can_force_feed(var/feeder,69ar/food,69ar/feedback)
	if(feedback)
		to_chat(feeder, "Where do you intend to put \the 69food69? \The 69src69 doesn't have a69outh!")
	return 0

/mob/living/simple_animal/adultslime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/slimes.dmi'
	health = 200
	maxHealth = 200
	icon_state = "grey adult slime"
	icon_dead = "grey baby slime dead"
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	emote_see = list("jiggles", "bounces in place")
	var/colour = "grey"

/mob/living/simple_animal/adultslime/New()
	..()
	overlays += "aslime-:33"


/mob/living/simple_animal/slime/adult/death()
	var/mob/living/simple_animal/slime/S1 =69ew /mob/living/simple_animal/slime (src.loc)
	S1.icon_state = "69src.colour69 baby slime"
	S1.icon_living = "69src.colour69 baby slime"
	S1.icon_dead = "69src.colour69 baby slime dead"
	S1.colour = "69src.colour69"
	var/mob/living/simple_animal/slime/S2 =69ew /mob/living/simple_animal/slime (src.loc)
	S2.icon_state = "69src.colour69 baby slime"
	S2.icon_living = "69src.colour69 baby slime"
	S2.icon_dead = "69src.colour69 baby slime dead"
	S2.colour = "69src.colour69"
	qdel(src)