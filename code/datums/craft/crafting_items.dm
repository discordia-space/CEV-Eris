/*
 * Crafting Items
 * Items used only in crafting other items
*/

/obj/item/rocket_engine
	name = "rocket engine"
	desc = "A singular rocket engine, used in assisted ballistics."
	icon_state = "rocket_engine"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_POWER = 4)
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_GOLD = 1)

/obj/item/gun_parts
	name = "gun parts"
	desc = "spare parts of a gun."
	icon = 'icons/obj/crafts.dmi'
	icon_state = "gun"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	matter = list(MATERIAL_STEEL = 2)