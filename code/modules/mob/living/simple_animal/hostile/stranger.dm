/mob/living/simple_animal/hostile/stranger
	name = "Stranger"
	desc = "Unknown"
	icon_state = "stranger"
	icon_dead = "stranger_dead" //TODO: that icon doesn't exist
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
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	status_flags = CANPUSH
	ranged = TRUE
	projectiletype = /obj/item/projectile/plasma/heavy
	projectilesound = 'sound/weapons/laser.ogg'
	faction = "bluespace"

/mob/living/simple_animal/hostile/stranger/death()
	..()
	var/obj/item/weapon/gun/energy/plasma/stranger/S = new /obj/item/weapon/gun/energy/plasma/stranger(src.loc)
	S.cell = new /obj/item/weapon/cell/medium/hyper
	new /obj/effect/decal/cleanable/ash (src.loc)
	var/atom/movable/overlay/animation = null
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon =  'icons/mob/mob.dmi'
	animation.master = src
	flick("dust-m", animation)
	addtimer(CALLBACK(src, .proc/check_delete, animation), 15)
	qdel(src)
