//basic spider mob, these generally guard nests
/mob/living/carbon/superior_animal/giant_spider
	name = "giant spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has deep red eyes."
	icon_state = "guard"
	icon_living = "guard"
	pass_flags = PASSTABLE

	mob_size = MOB_MEDIUM

	maxHealth = 120
	health = 120

	attack_sound = 'sound/weapons/spiderlunge.ogg'
	speak_emote = list("chitters")
	emote_see = list("chitters", "rubs its legs")
	speak_chance = 5

	move_to_delay = 6
	turns_per_move = 5
	see_in_dark = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/spider
	meat_amount = 3
	stop_automated_movement_when_pulled = 0

	melee_damage_lower = 12
	melee_damage_upper = 17

	min_breath_required_type = 3
	min_air_pressure = 15 //below this, brute damage is dealt

	var/poison_per_bite = 5
	var/poison_type = "pararein"
	pass_flags = PASSTABLE
	faction = "spiders"
	var/busy = 0

/mob/living/carbon/superior_animal/giant_spider/New(var/location, var/atom/parent)
	get_light_and_color(parent)
	..()