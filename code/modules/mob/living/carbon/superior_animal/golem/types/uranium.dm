/mob/living/carbon/superior_animal/golem/uranium
	name = "uranium golem"
	desc = "A moving pile of rocks with uranium specks in it."
	icon_state = "golem_uranium_idle"
	icon_living = "golem_uranium_idle"

	// Health related variables
	maxHealth = GOLEM_HEALTH_MED
	health = GOLEM_HEALTH_MED

	// Movement related variables
	move_to_delay = GOLEM_SPEED_LOW
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_FEEBLE

	// Armor related variables
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = GOLEM_ARMOR_MED,
		ARMOR_ENERGY = GOLEM_ARMOR_ULTRA,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

	// Loot related variables
	ore = /obj/item/ore/uranium

	// Uranium golem does not attack
	viewRange = 0  // Cannot attack if it cannot see

/mob/living/carbon/superior_animal/golem/uranium/New(loc, obj/machinery/mining/deep_drill/drill, datum/golem_controller/parent)
	..()
	set_light(3, 3, "#8AD55D")

/mob/living/carbon/superior_animal/golem/uranium/Destroy()
	set_light(0)
	. = ..()

// Special capacity of uranium golem: quickly repair all nearby golems.
/mob/living/carbon/superior_animal/golem/uranium/handle_ai()
	if(controller)
		for(var/mob/living/carbon/superior_animal/golem/GO in controller.golems)
			if(!istype(GO, /mob/living/carbon/superior_animal/golem/uranium))  // Uraniums do not regen
				GO.adjustBruteLoss(-GOLEM_REGENERATION) // Regeneration
	. = ..()
