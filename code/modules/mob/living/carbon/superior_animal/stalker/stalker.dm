// OneStar patrol borg that defends OneStar facilities
/mob/living/carbon/superior_animal/stalker
	name = "OneStar Stalker Mk1"
	desc = "A ruthless patrol borg that defends OneStar facilities. This one has a single minigun, still enough to kill pesky intruders."
	icon_state = "stalker_mk1"
	icon_living = "stalker_mk1"
	pass_flags = PASSTABLE

	mob_size = MOB_MEDIUM

	maxHealth = 100
	health = 100

	//spawn_values
	rarity_value = 37.5
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_MOB_STALKER
	faction = "onestar"

	deathmessage = "suddenly shuts down, its eye light switching to a dim red."
	attacktext = list("bonked")
	attack_sound = 'sound/weapons/smash.ogg'
	speak_emote = list("beeps")
	emote_see = list("beeps repeatedly", "whirrs violently", "flashes its indicator lights", "emits a ping sound")
	speak_chance = 5

	move_to_delay = 6
	turns_per_move = 5
	see_in_dark = 10
	meat_type = null
	meat_amount = 0
	stop_automated_movement_when_pulled = 0

	melee_damage_lower = 12
	melee_damage_upper = 17
	destroy_surroundings = FALSE

	contaminant_immunity = TRUE
	cold_protection = 1
	heat_protection = 1
	breath_required_type = 0
	breath_poison_type = 0
	min_breath_required_type = 0
	min_breath_poison_type = 0
	min_air_pressure = 0 //below this, brute damage is dealt
	max_air_pressure = 10000 //above this, brute damage is dealt
	min_bodytemperature = 0 //below this, burn damage is dealt
	max_bodytemperature = 10000 //above this, burn damage is dealt

	light_range = 3
	light_color = COLOR_LIGHTING_BLUE_BRIGHT
	mob_classification = CLASSIFICATION_SYNTHETIC
	bloodcolor = "#030303"

	ranged = 1 //will it shoot?
	rapid = 0 //will it shoot fast?
	projectiletype = /obj/item/projectile/bullet/srifle/nomuzzle
	projectilesound = 'sound/weapons/Gunshot.ogg'
	casingtype = null
	ranged_cooldown = 1 SECOND
	fire_verb = "fires"
	acceptableTargetDistance = 6
	kept_distance = 3

/mob/living/carbon/superior_animal/stalker/death()
	. = ..()
	visible_message("Critical components of \the [src] blow apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(loc)
	do_sparks(3, TRUE, src)

/mob/living/carbon/superior_animal/stalker/dual
	name = "OneStar Stalker Mk2"
	desc = "A ruthless patrol borg that defends OneStar facilities. This one is an upgraded version with a dual minigun, don\'t stand in front of it for too long."
	icon_state = "stalker_mk2"
	icon_living = "stalker_mk2"

	maxHealth = 200
	health = 200
	rapid = 1

/mob/living/carbon/superior_animal/stalker/New()
	..()
	pixel_x = 0
	pixel_y = 0

/mob/living/carbon/superior_animal/stalker/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/gripper))
		return ..(O, user)

	else if(istype(O, /obj/item/reagent_containers) || istype(O, /obj/item/stack/medical))
		..()

	else if(stat == DEAD)
		if(QUALITY_PRYING in O.tool_qualities)
			if(O.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PRYING, FAILCHANCE_HARD, required_stat = STAT_MEC))
				new /obj/item/stack/material/steel/random(src.loc)
				new /obj/item/stack/material/plasteel/random(src.loc)
				new /obj/item/stack/cable_coil(src.loc)
				for(var/i = 1, i <= 2 + rand(0,2), i++)
					var/os_components_reward = pick(list(
						/obj/item/stock_parts/capacitor/one_star,
						/obj/item/stock_parts/scanning_module/one_star,
						/obj/item/stock_parts/manipulator/one_star,
						/obj/item/stock_parts/micro_laser/one_star,
						/obj/item/stock_parts/matter_bin/one_star
					))
					new os_components_reward(get_turf(src))
				qdel(src)
	else
		O.attack(src, user, user.targeted_organ)
