/obj/item/weapon/cell //Basic type of the cells, should't be used by itself
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = list(TECH_POWER = 1)
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 3
	throw_range = 5
	w_class = 3.0
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 100
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 50)

//BIG CELLS - for APC, borgs and machinery.

/obj/item/weapon/cell/big
	name = "heavy-duty power cell"
	desc = "A rechargable electrochemical power cell."
	maxcharge = 1000

/obj/item/weapon/cell/big/high
	name = "high-capacity power cell"
	origin_tech = list(TECH_POWER = 2)
	icon_state = "hcell"
	maxcharge = 5000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 60)

/obj/item/weapon/cell/big/super
	name = "super-capacity power cell"
	origin_tech = list(TECH_POWER = 5)
	icon_state = "scell"
	maxcharge = 15000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 70)

/obj/item/weapon/cell/big/hyper
	name = "hyper-capacity power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "hpcell"
	maxcharge = 20000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)

/obj/item/weapon/cell/big/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon = 'icons/obj/power.dmi'
	icon_state = "potato_cell"
	charge = 100
	maxcharge = 300
	minor_fault = 1

/obj/item/weapon/cell/big/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	origin_tech = list(TECH_POWER = 2, TECH_BIO = 4)
	icon = 'icons/mob/slimes.dmi'
	icon_state = "yellow slime extract"
	maxcharge = 10000
	matter = null

//MEDIUM CELLS - for energy weapons and large devices

/obj/item/weapon/cell/medium/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "cell"
	w_class = 2
	force = WEAPON_FORCE_HARMLESS
	throw_speed = 5
	throw_range = 7
	maxcharge = 1000
	matter = list("metal" = 350, "glass" = 50)

/obj/item/weapon/cell/medium/device/variable/New(newloc, charge_amount)
	..(newloc)
	maxcharge = charge_amount
	charge = maxcharge

//SMALL CELLS - for small devices, such as flashlights, analyzers and HUDs.

/obj/item/weapon/cell/small
	name = "small power cell"
	desc = "A rechargable electrochemical power cell."
	maxcharge = 100
