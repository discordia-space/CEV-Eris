/mob/living/carbon/superior_animal/golem/coal
	name = "coal golem"
	desc = "A moving pile of rocks with coal clumps in it."
	icon_state = "golem_coal"
	icon_living = "golem_coal"

	// Health related variables
	maxHealth = GOLEM_HEALTH_MED
	health = GOLEM_HEALTH_MED

	// Movement related variables
	move_to_delay = GOLEM_SPEED_MED
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_LOW
	melee_damage_upper = GOLEM_DMG_MED

	// Armor related variables
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = GOLEM_ARMOR_MED,
		ARMOR_ENERGY = GOLEM_ARMOR_LOW,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

	// Loot related variables
	ore = /obj/item/ore/coal

// Special capacity of coal golem: when set on fire, it turns into a diamond golem
// Especially dangerous since uranium golem can explode into a fireball
/mob/living/carbon/superior_animal/golem/coal/handle_ai()
	if(on_fire)
		visible_message(SPAN_DANGER("\The [src] is engulfed by fire and turns into diamond!"))
		new /mob/living/carbon/superior_animal/golem/diamond(loc, drill=DD, parent=controller)  // Spawn diamond golem at location
		ore = null  // So that the golem does not drop coal ores
		death(FALSE, "no message")
	. = ..()
