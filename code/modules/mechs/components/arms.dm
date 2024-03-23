/obj/item/mech_component/manipulators
	name = "exosuit arms"
	pixel_y = -12
	icon_state = "loader_arms"
	has_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

	power_use = 10
	matter = list(MATERIAL_STEEL = 10)
	can_gib = TRUE
	gib_hits_needed = 10
	var/melee_damage = WEAPON_FORCE_PAINFUL
	var/action_delay = 15
	/// if they can force open powered doors
	var/can_force_doors = TRUE
	var/obj/item/robot_parts/robot_component/actuator/motivator
	tool_qualities = list(
		QUALITY_HAMMERING = 30,
		QUALITY_PRYING = 20
	)
	var/punch_sound = ('sound/mechs/mech_punch.ogg')

/obj/item/mech_component/manipulators/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/manipulators/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, SPAN_WARNING("It is missing an actuator."))

/obj/item/mech_component/manipulators/ready_to_install()
	return motivator

/obj/item/mech_component/manipulators/prebuild()
	motivator = new(src)

/obj/item/mech_component/manipulators/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The [src] already has an actuator installed."))
			return
		if(insert_item(I, user))
			motivator = I
	else
		return ..()

/obj/item/mech_component/manipulators/update_components()
	motivator = locate() in src

/obj/item/mech_component/manipulators/return_diagnostics(mob/user)
	..()
	if(motivator)
		to_chat(user, SPAN_NOTICE(" Actuator Integrity: <b>[round((((motivator.max_dam - motivator.total_dam) / motivator.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Actuator Missing or Non-functional."))

/obj/item/mech_component/manipulators/cheap
	name = "lifter exosuit arms"
	desc = "Industrial lifter arms that allow you to crudely manipulate things from the safety of your cockpit."
	exosuit_desc_string = "industrial lifter arms"
	icon_state = "loader_arms"
	can_force_doors = FALSE
	max_damage = 90
	power_use = 30
	armor = list(melee = 20, bullet = 10, energy = 5, bomb = 60, bio = 100, rad = 0)
	shielding = 5

	front_mult = 1.2
	rear_mult = 0.8

/obj/item/mech_component/manipulators/light
	name = "light arms"
	exosuit_desc_string = "lightweight, segmented manipulators"
	desc = "As flexible as they are fragile, these manipulators can follow a pilot's movements in close to real time."
	icon_state = "light_arms"
	action_delay = 5
	can_force_doors = FALSE
	max_damage = 45
	power_use = 10
	emp_shielded = TRUE
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 6)
	armor = list(melee = 16, bullet = 8, energy = 4, bomb = 40, bio = 100, rad = 100)

/obj/item/mech_component/manipulators/combat
	name = "combat arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	desc = "These advanced manipulators are designed for combat, and as a result can take and dish out beatings fairly well."
	icon_state = "combat_arms"
	melee_damage = WEAPON_FORCE_LETHAL + 5 // Whack
	action_delay = 10
	max_damage = 125
	power_use = 50
	matter = list(MATERIAL_STEEL = 16, MATERIAL_PLASTEEL = 6, MATERIAL_PLASMA = 4, MATERIAL_DIAMOND = 2)
	armor = list(melee = 26, bullet = 22, energy = 16, bomb = 100, bio = 100, rad = 100)
	shielding = 10

	front_mult = 1.2
	rear_mult = 0.8

/obj/item/mech_component/manipulators/heavy
	name = "heavy arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "heavy_arms"
	desc = "Designed for durability and dishing out beatings, this heavy set of manipulators can both take and dish out beatings."
	melee_damage = WEAPON_FORCE_LETHAL + 20 // You know , these things walk like a snail . Why would you even get close to this.
	action_delay = 20
	max_damage = 175
	power_use = 60
	matter = list(MATERIAL_STEEL = 24, MATERIAL_PLASTEEL = 10, MATERIAL_URANIUM = 6)
	armor = list(melee = 32, bullet = 24, energy = 20, bomb = 160, bio = 100, rad = 100)
	shielding = 15

	front_mult = 1.2
	rear_mult = 0.8
