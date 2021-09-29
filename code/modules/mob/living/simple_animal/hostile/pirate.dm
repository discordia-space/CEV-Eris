/mob/living/simple_animal/hostile/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	icon_state = "piratemelee"
	icon_dead = "pirate_dead" //TODO: That icon doesn't exist
	speak_chance = 0
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	atmospheric_requirements = list(
		BODY_TEMP_MIN_INDEX = 50,
		ATMOS_DAMAGE_INDEX = 15
	)
	var/corpse = /obj/landmark/corpse/pirate
	var/weapon1 = /obj/item/melee/energy/sword/pirate

	faction = "pirate"

/mob/living/simple_animal/hostile/pirate/ranged
	name = "Pirate Gunner"
	icon_state = "pirateranged"
	projectilesound = 'sound/weapons/laser.ogg'
	ranged = 1
	rapid = 1
	projectiletype = /obj/item/projectile/beam
	corpse = /obj/landmark/corpse/pirate/ranged
	weapon1 = /obj/item/gun/energy/laser


/mob/living/simple_animal/hostile/pirate/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	qdel(src)
	return
