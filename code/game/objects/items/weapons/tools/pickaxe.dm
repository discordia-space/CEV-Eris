/obj/item/weapon/tool/pickaxe
	name = "pickaxe"
	desc = "The most basic of mining tools, for short excavations and small mineral extractions."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_DANGEROUS
	icon_state = "pickaxe"
	item_state = "pickaxe"
	w_class = ITEM_SIZE_LARGE
	matter = list(MATERIAL_STEEL = 8000)
	tool_qualities = list(QUALITY_DIGGING = 2, QUALITY_PRYING = 2)
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	sharp = 1

/obj/item/weapon/tool/pickaxe/jackhammer
	name = "jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	matter = list(MATERIAL_STEEL = 6000, MATERIAL_PLASTIC = 2000)
	tool_qualities = list(QUALITY_DIGGING = 3)
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with blasts, perfect for killing cave lizards."

	use_power_cost = 5
	suitable_cell = /obj/item/weapon/cell/medium

/obj/item/weapon/tool/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	tool_qualities = list(QUALITY_DIGGING = 4, QUALITY_DRILLING = 1, )
	matter = list(MATERIAL_STEEL = 6000, MATERIAL_PLASTIC = 2000)
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."

	use_fuel_cost = 2
	max_fuel = 100

/obj/item/weapon/tool/pickaxe/diamonddrill
	name = "diamond-point mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	tool_qualities = list(QUALITY_DIGGING = 5, QUALITY_DRILLING = 2)
	matter = list(MATERIAL_STEEL = 6000, MATERIAL_PLASTIC = 2000, MATERIAL_DIAMOND = 2000)
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"

	use_fuel_cost = 3
	max_fuel = 120

/obj/item/weapon/tool/pickaxe/excavation
	name = "hand pickaxe"
	icon_state = "pick_hand"
	item_state = "syringe_0"
	desc = "A smaller, more precise version of the pickaxe, used for archeology excavation."
	tool_qualities = list(QUALITY_DIGGING = 1, QUALITY_EXCAVATION = 3)
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 4000)
