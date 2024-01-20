/mob/living/carbon/superior_animal/golem/silver
	name = "silver golem"
	desc = "A moving pile of rocks with silver specks in it."
	icon_state = "golem_silver"
	icon_living = "golem_silver"

	// Health related variables
	maxHealth = GOLEM_HEALTH_LOW
	health = GOLEM_HEALTH_LOW

	// Movement related variables
	move_to_delay = GOLEM_SPEED_HIGH
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_MED
	melee_damage_upper = GOLEM_DMG_HIGH
	melee_sharp = TRUE

	// Armor related variables
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = GOLEM_ARMOR_LOW,
		ARMOR_ENERGY = GOLEM_ARMOR_LOW,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

	// Loot related variables
	ore = /obj/item/ore/silver

// Special capacity of silver golem: when attacked in melee, it reflects part of the damage to the attacker.
// Called when the mob is hit with an item in combat.
/mob/living/carbon/superior_animal/golem/silver/hit_with_weapon(obj/item/I, mob/living/user, list/damages, var/hit_zone)
	. = ..()
	visible_message(SPAN_DANGER("\The [src] reflects \the [I.name]!"))
	user.hit_with_weapon(I, user, dhApplyMultiplier(damages.Copy(), 0.2), pick(BP_ALL_LIMBS))
