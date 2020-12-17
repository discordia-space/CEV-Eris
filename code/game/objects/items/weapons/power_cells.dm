//BIG CELLS - for APC, borgs and machinery.
/obj/item/weapon/cell/large
	name = "Asters \"Robustcell 1000L\""
	desc = "Asters Guild branded rechargeable L-standardized power cell. This one is the cheapest you can find."
	icon_state = "b_st"
	maxcharge = 1000
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 3, MATERIAL_SILVER = 3)
	price_tag = 200
	spawn_tags = SPAWN_TAG_POWERCELL_LARGE

/obj/item/weapon/cell/large/high
	name = "Asters \"Robustcell 5000L\""
	desc = "Asters Guild branded rechargeable L-standardized power cell. Popular and reliable version."
	icon_state = "b_hi"
	origin_tech = list(TECH_POWER = 2)
	maxcharge = 5000
	rarity_value = 5.5

/obj/item/weapon/cell/large/super
	name = "Asters \"Robustcell 15000L\""
	desc = "Asters Guild branded rechargeable L-standardized power cell. This advanced version can store even more energy."
	icon_state = "b_sup"
	origin_tech = list(TECH_POWER = 5)
	maxcharge = 15000
	rarity_value = 10

/obj/item/weapon/cell/large/hyper
	name = "Asters \"Robustcell-X 20000L\""
	desc = "Asters Guild branded rechargeable L-standardized power cell. Looks like this is a rare and powerful prototype."
	icon_state = "b_hy"
	origin_tech = list(TECH_POWER = 6)
	maxcharge = 20000
	rarity_value = 22.5

/obj/item/weapon/cell/large/moebius
	name = "Moebius \"Power-Geyser 2000L\""
	desc = "Moebius Laboratories branded rechargeable L-standardized power cell. This one is cheap, yet better than Aster model for same price."
	icon_state = "meb_b_st"
	maxcharge = 2000
	rarity_value = 5.5

/obj/item/weapon/cell/large/moebius/high
	name = "Moebius \"Power-Geyser 7000L\""
	desc = "Moebius Laboratories branded rechargeable L-standardized power cell. Popular and reliable version."
	icon_state = "meb_b_hi"
	origin_tech = list(TECH_POWER = 2)
	maxcharge = 7000
	rarity_value = 6.5

/obj/item/weapon/cell/large/moebius/super
	name = "Moebius \"Power-Geyser 13000L\""
	desc = "Moebius Laboratories branded rechargeable L-standardized power cell. This advanced version can store even more energy."
	icon_state = "meb_b_sup"
	origin_tech = list(TECH_POWER = 5)
	maxcharge = 13000
	rarity_value = 9

/obj/item/weapon/cell/large/moebius/hyper
	name = "Moebius \"Power-Geyser 18000L\""
	desc = "Moebius Laboratories branded rechargeable L-standardized power cell. Looks like this is rare and powerful prototype."
	icon_state = "meb_b_hy"
	origin_tech = list(TECH_POWER = 6)
	maxcharge = 18000
	rarity_value = 22.5

/obj/item/weapon/cell/large/moebius/nuclear
	name = "Moebius \"Atomcell 13000L\""
	desc = "Moebius Laboratories branded rechargeable L-standardized power cell. This version able to recharge itself over time."
	icon_state = "meb_b_nu"
	autorecharging = TRUE
	origin_tech = list(TECH_POWER = 6)
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 3, MATERIAL_SILVER = 3, MATERIAL_URANIUM = 6)
	maxcharge = 13000
	rarity_value = 45

/obj/item/weapon/cell/large/excelsior
	name = "Excelsior \"Zarya 15000L\""
	desc = "Commie rechargeable L-standardized power cell. Power to the people!"
	icon_state = "exs_l"
	origin_tech = list(TECH_POWER = 4)
	matter = list(MATERIAL_STEEL = 6, MATERIAL_PLASTIC = 3)
	maxcharge = 15000
	rarity_value = 90

//Meme cells - for fun and cancer

/obj/item/weapon/cell/large/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon = 'icons/obj/power.dmi'
	icon_state = "potato_cell"
	charge = 100
	maxcharge = 300
	minor_fault = 1
	spawn_blacklisted = TRUE

/obj/item/weapon/cell/large/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	origin_tech = list(TECH_POWER = 2, TECH_BIO = 4)
	icon = 'icons/mob/slimes.dmi'
	icon_state = "yellow slime extract"
	maxcharge = 10000
	matter = null
	spawn_blacklisted = TRUE

//MEDIUM CELLS - for energy weapons and large devices

/obj/item/weapon/cell/medium
	name = "Asters \"Robustcell 600M\""
	desc = "Asters Guild branded rechargeable M-standardized power cell. This one is the cheapest you can find."
	icon_state = "m_st"
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_HARMLESS
	throw_speed = 5
	throw_range = 7
	maxcharge = 600
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_SILVER = 2)
	price_tag = 100
	spawn_tags = SPAWN_TAG_POWERCELL_MEDIUM

/obj/item/weapon/cell/medium/high
	name = "Asters \"Robustcell 800M\""
	desc = "Asters Guild branded rechargeable M-standardized power cell. Popular and reliable version."
	icon_state = "m_hi"
	origin_tech = list(TECH_POWER = 2)
	maxcharge = 800
	rarity_value = 5.5
	spawn_tags = SPAWN_TAG_POWERCELL_MEDIUM_IH_AMMO

/obj/item/weapon/cell/medium/super
	name = "Asters \"Robustcell 1000M\""
	desc = "Asters Guild branded rechargeable M-standardized power cell. This advanced version can store even more energy."
	icon_state = "m_sup"
	origin_tech = list(TECH_POWER = 5)
	maxcharge = 1000
	rarity_value = 8

/obj/item/weapon/cell/medium/hyper
	name = "Asters \"Robustcell-X 1500M\""
	desc = "Asters Guild branded rechargeable M-standardized power cell. Looks like this is a rare and powerful prototype."
	icon_state = "m_hy"
	origin_tech = list(TECH_POWER = 6)
	maxcharge = 1500
	rarity_value = 30

/obj/item/weapon/cell/medium/moebius
	name = "Moebius \"Power-Geyser 700M\""
	desc = "Moebius Laboratories branded rechargeable M-standardized power cell. This one is cheap, yet better than Aster model for same price."
	icon_state = "meb_m_st"
	maxcharge = 700
	rarity_value = 5.5

/obj/item/weapon/cell/medium/moebius/high
	name = "Moebius \"Power-Geyser 900M\""
	desc = "Moebius Laboratories branded rechargeable M-standardized power cell. Popular and reliable version."
	icon_state = "meb_m_hi"
	origin_tech = list(TECH_POWER = 2)
	maxcharge = 900
	rarity_value = 6.5


/obj/item/weapon/cell/medium/moebius/super
	name = "Moebius \"Power-Geyser 1000M\""
	desc = "Moebius Laboratories branded rechargeable M-standardized power cell. This advanced version can store even more energy."
	icon_state = "meb_m_sup"
	origin_tech = list(TECH_POWER = 5)
	maxcharge = 1000
	rarity_value = 9

/obj/item/weapon/cell/medium/moebius/hyper
	name = "Moebius \"Power-Geyser 1300M\""
	desc = "Moebius Laboratories branded rechargeable M-standardized power cell. Looks like this is rare and powerful prototype."
	icon_state = "meb_m_hy"
	origin_tech = list(TECH_POWER = 6)
	maxcharge = 1300
	rarity_value = 22.5

/obj/item/weapon/cell/medium/moebius/nuclear
	name = "Moebius \"Atomcell 1000M\""
	desc = "Moebius Laboratories branded rechargeable M-standardized power cell. This version able to recharge itself over time."
	icon_state = "meb_m_nu"
	autorecharging = TRUE
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_SILVER = 2, MATERIAL_URANIUM = 4)
	origin_tech = list(TECH_POWER = 6)
	maxcharge = 1000
	rarity_value = 45

/obj/item/weapon/cell/medium/excelsior
	name = "Excelsior \"Zarya 1000M\""
	desc = "Commie rechargeable M-standardized power cell. Power to the people!"
	icon_state = "exs_m"
	origin_tech = list(TECH_POWER = 4)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 2)
	maxcharge = 1000
	rarity_value = 30


//SMALL CELLS - for small devices, such as flashlights, analyzers and HUDs.
/obj/item/weapon/cell/small
	name = "Asters \"Robustcell 100S\""
	desc = "Asters Guild branded rechargeable S-standardized power cell. This one is the cheapest you can find."
	icon_state = "s_st"
	w_class = ITEM_SIZE_TINY
	force = WEAPON_FORCE_HARMLESS
	throw_speed = 5
	throw_range = 7
	maxcharge = 100
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_SILVER = 1)
	price_tag = 50
	spawn_tags = SPAWN_TAG_POWERCELL_SMALL
	rarity_value = 3

/obj/item/weapon/cell/small/high
	name = "Asters \"Robustcell 200S\""
	desc = "Asters Guild branded rechargeable S-standardized power cell. Popular and reliable version."
	icon_state = "s_hi"
	origin_tech = list(TECH_POWER = 2)
	maxcharge = 200
	rarity_value = 4

/obj/item/weapon/cell/small/super
	name = "Asters \"Robustcell 300S\""
	desc = "Asters Guild branded rechargeable S-standardized power cell. This advanced version can store even more energy."
	icon_state = "s_sup"
	origin_tech = list(TECH_POWER = 5)
	maxcharge = 300
	rarity_value = 7

/obj/item/weapon/cell/small/hyper
	name = "Asters \"Robustcell-X 500S\""
	desc = "Asters Guild branded rechargeable S-standardized power cell. Looks like this is a rare and powerful prototype."
	icon_state = "s_hy"
	origin_tech = list(TECH_POWER = 6)
	maxcharge = 500
	rarity_value = 20

/obj/item/weapon/cell/small/moebius
	name = "Moebius \"Power-Geyser 120S\""
	desc = "Moebius Laboratories branded rechargeable S-standardized power cell. This one is cheap, yet better than Aster model for same price."
	icon_state = "meb_s_st"
	maxcharge = 120
	rarity_value = 4

/obj/item/weapon/cell/small/moebius/high
	name = "Moebius \"Power-Geyser 250S\""
	desc = "Moebius Laboratories branded rechargeable S-standardized power cell. Popular and reliable version."
	icon_state = "meb_s_hi"
	origin_tech = list(TECH_POWER = 2)
	maxcharge = 250
	rarity_value = 5

/obj/item/weapon/cell/small/moebius/super
	name = "Moebius \"Power-Geyser 300S\""
	desc = "Moebius Laboratories branded rechargeable S-standardized power cell. This advanced version can store even more energy."
	icon_state = "meb_s_sup"
	origin_tech = list(TECH_POWER = 5)
	maxcharge = 300
	rarity_value = 6

/obj/item/weapon/cell/small/moebius/hyper
	name = "Moebius \"Power-Geyser 400S\""
	desc = "Moebius Laboratories branded rechargeable S-standardized power cell. Looks like this is rare and powerful prototype."
	icon_state = "meb_s_hy"
	origin_tech = list(TECH_POWER = 6)
	maxcharge = 400
	rarity_value = 16

/obj/item/weapon/cell/small/moebius/nuclear
	name = "Moebius \"Atomcell 300S\""
	desc = "Moebius Laboratories branded rechargeable S-standardized microreactor cell. Recharges itself over time."
	icon_state = "meb_s_nu"
	autorecharging = TRUE
	origin_tech = list(TECH_POWER = 6)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_SILVER = 1, MATERIAL_URANIUM = 2)
	maxcharge = 300
	rarity_value = 40

/obj/item/weapon/cell/small/moebius/pda
	name = "Moebius \"Atomcell 50S\""
	desc = "Moebius Laboratories branded S-standardized microreactor cell. Recharges itself over time."
	icon_state = "meb_pda"
	origin_tech = list(TECH_POWER = 4)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1)
	matter_reagents = list("radium" = 5, "uranium" = 1)
	maxcharge = 50
	// Autorecharge rate is calculated for PDA power consumption: enough to offset it, unless PDA light is on.
	autorecharging = TRUE
	autorecharge_rate = 0.0007
	recharge_time = 1
	spawn_blacklisted = TRUE
	rarity_value = 40

/obj/item/weapon/cell/small/excelsior
	name = "Excelsior \"Zarya 300S\""
	desc = "Commie rechargeable S-standardized power cell. Power to the people!"
	icon_state = "exs_s"
	origin_tech = list(TECH_POWER = 4)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 1)
	maxcharge = 300
	rarity_value = 80

/obj/item/weapon/cell/disposable
	name = "a disposable cell"
	desc = "just steel for this one!"
	icon_state = "s_st"
	w_class = ITEM_SIZE_TINY
	force = WEAPON_FORCE_HARMLESS
	throw_speed = 5
	throw_range = 7
	origin_tech = list(TECH_POWER = 1)
	matter = list(MATERIAL_STEEL = 1)  //some cost just in case you manage to get this in a disk or something
	maxcharge = 100  //small cause if someone manage to get this shouldn't be that usefull. and 100 is a nice number to work with.
	spawn_blacklisted = TRUE
	
// Infinite cells - intended for debug use only, plus a bit of BSL lore should a player ever get their hands on them. they never run out of charge
// and have the highest capacity in the game

/obj/item/weapon/cell/large/moebius/nuclear/infinite
	name = "BSL \"Nullcell 99999L\""
	desc = "Bluespace League branded rechargeable L-standardized power cell. This strange piece of technology has the tag 'Made in Space Finland' on the back. It never seems to run out of charge."
	icon_state = "infinite_b"
	autorecharge_rate = 1 // charges 100% of itself every tick
	bad_type = /obj/item/weapon/cell/large/moebius/nuclear/infinite // really shouldn't spawn in maint, or anywhere else
	maxcharge = 99999 // unlimited power! well, not really, but i dont think anything consumed 99999 watts a tick
	matter = list(MATERIAL_PLASMA = 12, MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 3, MATERIAL_SILVER = 3, MATERIAL_URANIUM = 12) // might as well give them material values

/obj/item/weapon/cell/medium/moebius/nuclear/infinite
	name = "BSL \"Nullcell 9999L\""
	desc = "Bluespace League branded rechargeable M-standardized power cell. This strange piece of technology has the tag 'Made in Space Finland' on the back. It never seems to run out of charge."
	icon_state = "infinite_m"
	autorecharge_rate = 1
	bad_type = /obj/item/weapon/cell/medium/moebius/nuclear/infinite
	maxcharge = 9999
	matter = list(MATERIAL_PLASMA = 8, MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_SILVER = 2, MATERIAL_URANIUM = 8)
	
/obj/item/weapon/cell/small/moebius/nuclear/infinite
	name = "BSL \"Nullcell 999L\""
	desc = "Bluespace League branded rechargeable S-standardized power cell. This strange piece of technology has the tag 'Made in Space Finland' on the back. It never seems to run out of charge."
	icon_state = "infinite_s"
	autorecharge_rate = 1
	bad_type = /obj/item/weapon/cell/small/moebius/nuclear/infinite
	maxcharge = 999
	matter = list(MATERIAL_PLASMA = 4, MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_SILVER = 1, MATERIAL_URANIUM = 4)
