/mob/living/simple_animal/iriska
	name = "Iriska"
	desc = "A very fat cat."
	icon = 'icons/mob/iriska.dmi'
	icon_state = "iriska"
    health = 60
    wander = FALSE
    canmove = FALSE
    speak_emote = list("purrs", "meows")
	emote_see = list("shakes their head", "shivers")
	speak_chance = 0.75
    meat_amount = 3
    meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
    response_help  = "pets"
	response_disarm = "gently rubs"
	response_harm   = "makes terrible mistake when kicking"
	mob_size = MOB_HUGE
    harm_intent_damage = 20
	melee_damage_lower = 10
	melee_damage_upper = 40
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	density = TRUE // No stepping on Iriska
    stop_automated_movement = 1
    bite_factor = 1
    stomach_size_mult = 10
    scan_range = 1 //Ignore food that is too far







