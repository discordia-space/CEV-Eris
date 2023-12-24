#define DET_STABLE 0
#define DET_BLOWING 1
#define DET_DEFUSED 2

/mob/living/carbon/superior_animal/golem/plasma
	name = "plasma golem"
	desc = "A moving pile of rocks with plasma specks in it."
	icon_state = "golem_plasma"
	icon_living = "golem_plasma"

	// Health related variables
	maxHealth = GOLEM_HEALTH_LOW
	health = GOLEM_HEALTH_LOW

	// Movement related variables
	move_to_delay = GOLEM_SPEED_MED
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_LOW

	// Armor related variables
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = GOLEM_ARMOR_LOW,
		ARMOR_ENERGY = GOLEM_ARMOR_HIGH,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

	// Loot related variables
	ore = /obj/item/ore/plasma

	// Ranged attack related variables
	ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/plasma
	projectilesound = 'sound/weapons/energy/burn.ogg'
	casingtype = null
	ranged_cooldown = 1 SECOND
	fire_verb = "fires"
	acceptableTargetDistance = 6
	kept_distance = 3

	// How much time before detonation
	var/det_time = 5 SECONDS
	var/det_status = DET_STABLE

// Special capacity of plasma golem: blow up upon death except if hit with melee weapon
/mob/living/carbon/superior_animal/golem/plasma/death(gibbed, message = deathmessage)
	if(det_status == DET_STABLE)
		det_status = DET_BLOWING
		icon_state = "golem_plasma_idle"
		visible_message(SPAN_DANGER("\The [src] starts glowing!"))
		spawn(det_time)
			if(det_status == DET_BLOWING)  // Blowing up since no one defused it
				icon_state = "golem_plasma_explosion"
				spawn(1.5 SECONDS)
					// Plasma ball on location
					visible_message(SPAN_DANGER("\The [src] explodes into a ball of burning palsma!"))
					for(var/turf/simulated/floor/target_tile in range(2, loc))
						new /obj/effect/decal/cleanable/liquid_fuel(target_tile, 2, 1)
						spawn (0) target_tile.hotspot_expose((T20C * 2) + 380, 500)  // From flamethrower code
					. = ..()
	else if(det_status == DET_DEFUSED)  // Will triger when hit by melee while blowing
		. = ..()

// Called when the mob is hit with an item in combat.
/mob/living/carbon/superior_animal/golem/plasma/hit_with_weapon(obj/item/I, mob/living/user, list/damages ,var/hit_zone)
	if(det_status == DET_BLOWING)
		det_status = DET_DEFUSED
		icon_state = "golem_plasma"
	. = ..()

#undef DET_STABLE
#undef DET_BLOWING
#undef DET_DEFUSED
