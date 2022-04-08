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
		melee = 0,
		bullet = GOLEM_ARMOR_MED,
		energy = GOLEM_ARMOR_ULTRA,
		bomb = 0,
		bio = 0,
		rad = 0
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
