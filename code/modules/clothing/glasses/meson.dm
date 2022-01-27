/obj/item/clothing/glasses/powered/meson
	name = "Optical69eson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_MAJOR
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 1)
	price_tag = 500

	tick_cost = 0.3

/obj/item/clothing/glasses/powered/meson/Initialize()
	. = ..()
	overlay = global_hud.meson
