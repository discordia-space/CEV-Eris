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
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 10,
		bio = 0,
		rad = 0
	)
	siemens_coefficient = 0.6
	can_hold_knife = 1

/obj/item/clothing/shoes/reinforced
	name = "reinforced boots"
	desc = "Slightly reinforced boots. Optimal for your journey into a wonderful world of maintenance."
	icon_state = "reinforced"
	item_state = "reinforced"
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	siemens_coefficient = 0.5

/obj/item/clothing/shoes/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots"
	item_state = "workboots"
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 10,
		bomb = 10,
		bio = 0,
		rad = 25
	)
	siemens_coefficient = 0
	can_hold_knife = 1
