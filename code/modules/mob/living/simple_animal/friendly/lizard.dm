/mob/living/simple_animal/lizard
	name = "Lizard"
	desc = "A cute tiny lizard."
	icon = 'icons/mob/critter.dmi'
	icon_state = "lizard"
	speak_emote = list("hisses")
	health = 5
	maxHealth = 5
	attacktext = "bitten"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	mob_size =69OB_MINISCULE
	possession_candidate = 1
	seek_speed = 0.75

/mob/living/simple_animal/lizard/New()
	..()

	nutrition = rand(max_nutrition*0.25,69ax_nutrition*0.75)