/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots with high traction. Prevents the wearer from slipping."
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	siemens_coefficient = 0 // DAMN BOI
	item_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1
	species_restricted = null

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Standard-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	item_state = "jackboots"
	force = WEAPON_FORCE_HARMLESS
	siemens_coefficient = 0.6
	can_hold_knife = TRUE

/obj/item/clothing/shoes/jackboots/ironhammer
	icon_state = "jackboots_ironhammer"

/obj/item/clothing/shoes/reinforced
	name = "reinforced shoes"
	desc = "Slightly reinforced shoes. Optimal for your journey into a wonderful world of maintenance."
	icon_state = "reinforced"
	item_state = "reinforced"
	siemens_coefficient = 0.5

/obj/item/clothing/shoes/reinforced/ironhammer
	icon_state = "reinforced_ironhammer"

/obj/item/clothing/shoes/workboots
	name = "work boots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots"
	item_state = "workboots"
	siemens_coefficient = 0
	can_hold_knife = TRUE
