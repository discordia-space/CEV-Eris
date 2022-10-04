/datum/craft_recipe/gun
	category = "Guns"
	time = 25
	related_stats = list(STAT_MEC)

/datum/craft_recipe/gun/pistol
	name = "Handmade gun"
	result = /obj/item/part/gun/frame/handmade_pistol
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC),
		list(QUALITY_ADHESIVE, 15, 70),
		list(CRAFT_MATERIAL, 4, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/handmaderevolver
	name = "Handmade Revolver"
	result = /obj/item/part/gun/frame/revolver_handmade
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 15, 70),
		list(CRAFT_MATERIAL, 4, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/handmaderifle
	name = "Handmade bolt action rifle"
	result = /obj/item/part/gun/frame/riose
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 10, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/makeshiftgl
	name = "makeshift grenade launcher"
	result = /obj/item/gun/projectile/shotgun/pump/grenade/makeshift
	steps = list(
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_MATERIAL, 10, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/slidebarrelshotgun
	name = "slide barrel Shotgun"
	result = /obj/item/part/gun/frame/ponyets
	steps = list(
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_MATERIAL, 6, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/motherfucker
	name = "HM Motherfucker .35 \"Punch Hole\""
	result = /obj/item/part/gun/frame/motherfucker
	steps = list(
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_MATERIAL, 10, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/makeshiftlaser
	name = "makeshift laser carbine"
	result = /obj/item/gun/energy/laser/makeshift
	steps = list(
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 15, MATERIAL_PLASTIC),
		list(/obj/item/stock_parts/micro_laser, 4),
		list(QUALITY_SCREW_DRIVING, 10),
		list(/obj/item/stock_parts/capacitor, 1),
		list(QUALITY_SCREW_DRIVING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/lasersmg
	name = "Lasblender"
	result = /obj/item/gun/energy/lasersmg
	steps = list(
		list(/obj/item/gun/projectile/automatic/atreides, 1),
		list(QUALITY_WELDING, 10, "time" = 30),
		list(CRAFT_MATERIAL, 6, MATERIAL_PLASTEEL, "time" = 10),
		list(/obj/item/stock_parts/subspace/crystal, 1),
		list(/obj/item/computer_hardware/led, 1),
		list(/obj/item/stack/cable_coil, 5, "time" = 20),
		list(/obj/item/stock_parts/capacitor, 1, "time" = 5),
		list(CRAFT_MATERIAL, 2, MATERIAL_GLASS, "time" = 10),
		list(QUALITY_ADHESIVE, 15, 70))

/datum/craft_recipe/gun/kalash
	name = "Makeshift AR .30 \"Kalash\""
	result = /obj/item/part/gun/frame/kalash
	steps = list(
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 10),
		list(/obj/item/stack/rods, 2, "time" = 10),
		list(QUALITY_HAMMERING, 10),
		list(CRAFT_MATERIAL, 6, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/luty
	name = "Handmade SMG .35 Auto \"Luty\""
	result = /obj/item/part/gun/frame/luty
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC),
		list(QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_MATERIAL, 6, MATERIAL_WOOD),
		list(QUALITY_HAMMERING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/armgun
	name = "embedded SMG"
	result = /obj/item/organ_module/active/simple/armsmg
	steps = list(
		list(/obj/item/part/gun/frame/luty, 1),
		list(QUALITY_HAMMERING, 10),
		list(CRAFT_MATERIAL, 12, MATERIAL_PLASTEEL, "time" = 10),
		list(QUALITY_WELDING, 10, "time" = 40),
		list(/obj/item/stack/cable_coil, 5, "time" = 20),
		list(CRAFT_MATERIAL, 5, MATERIAL_PLASTIC, "time" = 10),
		list(QUALITY_SCREW_DRIVING, 10),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/poweredcrossbow
	name = "powered crossbow"
	result = /obj/item/gun/energy/poweredcrossbow
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_WOOD), //old frame recipe
		list(/obj/item/stack/rods, 3, "time" = 20),
		list(QUALITY_WELDING, 10, "time" = 30),
		list(/obj/item/stack/cable_coil, 10, "time" = 10),
		list(CRAFT_MATERIAL, 3, MATERIAL_PLASTIC, "time" = 10),
		list(CRAFT_MATERIAL, 2, MATERIAL_GLASS, "time" = 20),
		list(QUALITY_SCREW_DRIVING, 5, 10, "time" = 3))

/datum/craft_recipe/gun/crossbow_bolt
	name = "crossbow bolt"
	result = /obj/item/ammo_casing/crossbow/bolt/prespawned
	steps = list(
		list(/obj/item/stack/rods, 5, "time" = 1),
		list(QUALITY_HAMMERING, 5, 10, "time" = 10)) 

/datum/craft_recipe/gun/rxd
	name = "RXD - Rapid Crossbow Device"
	result = /obj/item/gun/energy/rxd
	steps = list(
		list(/obj/item/rcd, 1, "time" = 15), //Base frame
		list(QUALITY_SCREW_DRIVING, 10, 15), //Undo screws holding it together
		list(QUALITY_SAWING, 10, "time" = 30), //Saw into frame to expose innards
		list(QUALITY_PULSING, 30, "time" = 15), //Hack it so it only makes bolts, other functions ruined
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL), //Add steel to make the bow
		list(QUALITY_WELDING, 10, "time" = 30), //Welds the steel into shape and closes frame
		list(/obj/item/stack/cable_coil, 2, "time" = 10)) //Adds the bowstring


/datum/craft_recipe/gun/flaregun
	name = "Flare gun shotgun"
	result = /obj/item/gun/projectile/flare_gun/shotgun
	steps = list(
		list(/obj/item/gun/projectile/flare_gun, 1),
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20)
	)

/datum/craft_recipe/gun/ammo_kit
	name = "Scrap ammo kit"
	result = /obj/item/ammo_kit
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
		list(QUALITY_WIRE_CUTTING, 10, 20),
		list(CRAFT_MATERIAL, 1, MATERIAL_CARDBOARD),
		list(QUALITY_ADHESIVE, 15, 70)
	)

/datum/craft_recipe/gun/ammo_case	//Added under guns because it's for ammo
	name = "Scrap ammo case"
	result = /obj/item/storage/hcases/ammo/scrap
	steps = list(
		list(CRAFT_MATERIAL, 15, MATERIAL_STEEL),
		list(QUALITY_WELDING, 10, 20)
	)
