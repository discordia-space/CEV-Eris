#define DET_STABLE 0
#define DET_BLOWING 1

/mob/living/carbon/superior_animal/golem/plasma // plasma golems detonate instead of hitting targets, or prematurely when they're killed.
	name = "plasma golem"
	desc = "A moving pile of rocks with spikes of highly volatile plasma jutting out."
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
		melee = 0,
		bullet = GOLEM_ARMOR_LOW,
		energy = GOLEM_ARMOR_HIGH,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	mineral_name = ORE_PLASMA

	// How much time before detonation
	var/det_time = 2.5 SECONDS
	var/det_status = DET_STABLE

/mob/living/carbon/superior_animal/golem/plasma/death(gibbed, message = deathmessage)
	if(det_status == DET_STABLE)
		walk(src,0)
		anchored = TRUE // Prevents movement.
		det_status = DET_BLOWING
		visible_message(SPAN_DANGER("\The [src] starts glowing!"))
		icon_state = "golem_plasma_explosion"
		spawn(det_time)
			// Plasma ball on location
			visible_message(SPAN_DANGER("\The [src] explodes into a ball of burning plasma!"))
			for(var/turf/floor/target_tile as anything in RANGE_TURFS(2, loc))
				new /obj/effect/decal/cleanable/liquid_fuel(target_tile, 2, 1)
				target_tile.hotspot_expose((T20C * 2) + 380, 500)  // From flamethrower code
			. = ..()

/mob/living/carbon/superior_animal/golem/plasma/UnarmedAttack(atom/A, proximity)
	if(det_status == DET_STABLE)
		death(FALSE)


#undef DET_STABLE
#undef DET_BLOWING
