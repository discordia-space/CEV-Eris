/mob/living/simple_animal/hostile/maintdweller
	name = "maint dweller"
	desc = "Something odd you found in maint."
	icon_state = "russianmelee"
	icon_dead = "russian_dead" //TODO: that icon doesn't exist
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "punched"
	a_intent = I_HURT
	var/corpse 
	var/weapon1 = /obj/item/weapon/tool/knife
	var/weapon2 
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	status_flags = CANPUSH



/mob/living/simple_animal/hostile/maintdweller/ranged
	icon_state = "russianranged"
	weapon1 = /obj/item/weapon/gun/projectile/revolver/mateba
	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/Gunshot.ogg'
	casingtype = /obj/item/ammo_casing/magnum


/mob/living/simple_animal/hostile/maintdweller/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	if(weapon2)
		new weapon2 (src.loc)
	qdel(src)
	return

// Haywire androids

/mob/living/simple_animal/hostile/maintdweller/vagabot
	name = "haywire android"
	desc = "An outdated android from a long gone manufacturer. Is that a knife?"
	icon_state = "vagabot_melee"
	icon_gib = "robot"
	faction = "vagabot"
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	corpse = /obj/effect/decal/cleanable/blood/gibs/robot
	weapon2 = /obj/item/weapon/storage/deferred/vagabot
	spawn_tags = SPAWN_TAG_MOB_HOSTILE

/mob/living/simple_animal/hostile/maintdweller/ranged/vagabot
	name = "haywire android"
	desc = "An outdated android from a long gone manufacturer. Why does he have a gun?"
	icon_state = "vagabot_ranged"
	icon_gib = "robot"
	faction = "vagabot"
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	corpse = /obj/effect/decal/cleanable/blood/gibs/robot
	weapon1 = /obj/item/weapon/gun/projectile/colt
	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/Gunshot.ogg'
	casingtype = /obj/item/ammo_casing/pistol
	weapon2 = /obj/item/weapon/storage/deferred/vagabot
	spawn_tags = SPAWN_TAG_MOB_HUMANOID
