/*
 * Toy crossbow
 */

/obj/item/gun/projectile/foamcrossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	item_icons = list(
		icon_l_hand = 'icons/mob/items/lefthand_guns.dmi',
		icon_r_hand = 'icons/mob/items/righthand_guns.dmi',
		)
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 2)
	spawn_tags = SPAWN_TAG_TOY_WEAPON
	load_method = SINGLE_CASING
	caliber = CAL_DART
	price_tag = 5 // toy
	fire_sound = 'sound/weapons/empty.ogg'
	max_shells = 5
	safety = FALSE
	restrict_safety = TRUE
	icon_contained = FALSE
