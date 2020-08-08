/mob/living/simple_animal/hostile/stranger
	name = "Stranger"
	desc = "A stranger from an unknown place."
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
	rapid = TRUE
	projectiletype = /obj/item/projectile/plasma/heavy
	projectilesound = 'sound/weapons/laser.ogg'
	faction = "bluespace"
	var/empy_cell = FALSE
	var/prob_tele = 15

/mob/living/simple_animal/hostile/stranger/New()
	..()
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, src.loc)
	sparks.start()

/mob/living/simple_animal/hostile/stranger/death()
	..()
	var/obj/item/weapon/gun/energy/plasma/stranger/S = new /obj/item/weapon/gun/energy/plasma/stranger(src.loc)
	S.cell = new /obj/item/weapon/cell/medium/hyper
	S.cell.charge = S.cell.maxcharge/2
	if(empy_cell)
		S.cell.charge = 0
	new /obj/effect/decal/cleanable/ash (src.loc)
	var/atom/movable/overlay/animation = null
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon =  'icons/mob/mob.dmi'
	animation.master = src
	flick("dust-h", animation)
	addtimer(CALLBACK(src, .proc/check_delete, animation), 15)
	qdel(src)

/mob/living/simple_animal/hostile/stranger/attackby(obj/item/W, mob/user, params)
	if(user.a_intent != I_HELP && prob(prob_tele))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 3, 2)
		do_teleport(src, T)
		return FALSE
	..()


/mob/living/simple_animal/hostile/stranger/attack_hand(mob/living/carbon/M as mob)
	if(M.a_intent != I_HELP && prob(prob_tele))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 3, 2)
		do_teleport(src, T)
		return FALSE
	..()

/mob/living/simple_animal/hostile/stranger/bullet_act(obj/item/projectile/P, def_zone)
	if(prob(prob_tele))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 3, 2)
		do_teleport(src, T)
		return FALSE
	..()

/mob/living/simple_animal/hostile/stranger/Life()
	if(target_mob && prob(prob_tele))
		var/turf/T = get_random_secure_turf_in_range(target_mob, 3, 2)
		do_teleport(src, T)
	. = ..()

/obj/item/weapon/gun/energy/plasma/stranger
	name = "Unkown plasma gun"
	desc = "A plasma gun from unkown origin"
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 7, MATERIAL_URANIUM = 8, MATERIAL_GOLD = 4)
	price_tag = 5000
	charge_cost = 15
	fire_delay=8
	one_hand_penalty = 8
	twohanded = TRUE

	init_firemodes = list(
		list(mode_name="burn", projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/Taser.ogg', fire_delay=8, charge_cost=null, icon="stun", projectile_color = "#0000FF"),
		list(mode_name="melt", projectile_type=/obj/item/projectile/plasma, fire_sound='sound/weapons/Laser.ogg', fire_delay=12, charge_cost=25, icon="kill", projectile_color = "#FF0000"),
		list(mode_name="INCINERATE", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=14, charge_cost=30, icon="destroy", projectile_color = "#FFFFFF"),
		list(mode_name="VAPORIZE", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=5, charge_cost=70, icon="destroy", projectile_color = "#ff00aa", recoil_buildup=3),
	)
