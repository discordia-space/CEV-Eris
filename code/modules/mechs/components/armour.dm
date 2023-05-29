/*
/datum/extension/armor/exosuit/apply_damage_modifications(damage, damage_type, damage_flags, mob/living/victim, armor_pen, silent = TRUE)
	if(prob(get_blocked(damage_type, damage_flags, armor_pen) * 100)) //extra removal of sharp and edge on account of us being big robots
		damage_flags &= ~(DAM_SHARP | DAM_EDGE)
	. = ..()
*/

/obj/item/robot_parts/robot_component/armour/exosuit
	name = "exosuit armor plating"
	armor = list(melee = 20, bullet = 8, energy = 2, bomb = 100, bio = 100, rad = 0)
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_STEEL = 7)
	spawn_tags = SPAWN_TAG_MECH_QUIPMENT
	rarity_value = 10
	spawn_blacklisted = TRUE

/obj/item/robot_parts/robot_component/armour/exosuit/Initialize(newloc)
	. = ..()
	// HACK
	// All robot components add "robot" to the name on init - remove that on exosuit armor
	name = initial(name)

/obj/item/robot_parts/robot_component/armour/exosuit/plain
	name = "standard exosuit plating"
	desc = "A sturdy hunk of steel and plasteel plating, offers decent protection from physical harm and environmental hazards whilst being cheap to produce."
	armor = list(melee = 20, bullet = 10, energy = 9, bomb = 125, bio = 100, rad = 100)
	origin_tech = list(TECH_MATERIAL = 3)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 10) //Plasteel for the shielding
	spawn_blacklisted = FALSE
	price_tag = 400

/obj/item/robot_parts/robot_component/armour/exosuit/ablative
	name = "ablative exosuit armor plating"
	desc = "This plating is built to shrug off laser impacts and block electromagnetic pulses, but is rather vulnerable to brute trauma."
	armor = list(melee = 15, bullet = 6, energy = 38, bomb = 50, bio = 100, rad = 50)
	origin_tech = list(TECH_MATERIAL = 3)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASMA = 5)
	spawn_blacklisted = FALSE
	price_tag = 550

/obj/item/robot_parts/robot_component/armour/exosuit/combat
	name = "heavy combat exosuit plating"
	desc = "Plating designed to deflect incoming attacks and explosions."
	armor = list(melee = 24, bullet = 24, energy = 16, bomb = 300, bio = 100, rad = 50)
	origin_tech = list(TECH_MATERIAL = 5)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_DIAMOND = 5, MATERIAL_URANIUM = 5)
	spawn_blacklisted = FALSE
	price_tag = 1000
