//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

var/list/all_supply_groups = list("Operations","Security","Hospitality","Engineering","Medical / Science","Hydroponics","Mining","Supply","Miscellaneous")

/datum/supply_pack
	var/name = "Crate"
	var/group = "Operations"
	var/true_manifest = ""
	var/hidden = FALSE
	var/contraband = FALSE
	var/cost = 700 // Minimum cost, or infinite points are possible.
	var/access = FALSE
	var/list/contains = null
	var/crate_name = "crate"
	var/containertype = /obj/structure/closet/crate
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE
	var/amount = 0

/datum/supply_pack/New()
	true_manifest += "<ul>"
	for(var/path in contains)
		if(!path)
			continue
		var/atom/movable/AM = path
		true_manifest += "<li>[initial(AM.name)]</li>"
	true_manifest += "</ul>"

/datum/supply_pack/proc/generate(turf/T)
	var/obj/structure/closet/crate/C = new containertype(T)
	C.name = crate_name
	if(access)
		C.req_access = list(access)

	fill(C)

	return C

/datum/supply_pack/proc/fill(obj/structure/closet/crate/C)
	for(var/item in contains)
		var/n_item = new item(C)
		if(src.amount && istype(n_item, /obj/item/stack/material/steel))
			var/obj/item/stack/material/n_sheet = n_item
			n_sheet.amount = src.amount

//----------------------------------------------
//-----------------OPERATIONS-------------------
//----------------------------------------------

/datum/supply_pack/mule
	name = "MULEbot Crate"
	contains = list(/obj/machinery/bot/mulebot)
	cost = 2000
	containertype = /obj/structure/largecrate/mule
	crate_name = "MULEbot Crate"
	group = "Operations"

/datum/supply_pack/lunchboxes
	name = "Lunchboxes"
	contains = list(/obj/item/weapon/storage/lunchbox/cat,
					/obj/item/weapon/storage/lunchbox/cat,
					/obj/item/weapon/storage/lunchbox/cat,
					/obj/item/weapon/storage/lunchbox/cat,
					/obj/item/weapon/storage/lunchbox,
					/obj/item/weapon/storage/lunchbox,
					/obj/item/weapon/storage/lunchbox,
					/obj/item/weapon/storage/lunchbox,
					/obj/item/weapon/storage/lunchbox/rainbow,
					/obj/item/weapon/storage/lunchbox/rainbow,
					/obj/item/weapon/storage/lunchbox/rainbow,
					/obj/item/weapon/storage/lunchbox/rainbow)
	cost = 1500
	containertype = /obj/structure/closet/crate
	crate_name  = "\improper Lunchboxes"
	group = "Operations"

/datum/supply_pack/artscrafts
	name = "Arts and Crafts supplies"
	contains = list(/obj/item/weapon/storage/fancy/crayons,
	/obj/item/device/camera,
	/obj/item/device/camera_film,
	/obj/item/device/camera_film,
	/obj/item/weapon/storage/photo_album,
	/obj/item/weapon/packageWrap,
	/obj/item/weapon/reagent_containers/glass/paint/red,
	/obj/item/weapon/reagent_containers/glass/paint/green,
	/obj/item/weapon/reagent_containers/glass/paint/blue,
	/obj/item/weapon/reagent_containers/glass/paint/yellow,
	/obj/item/weapon/reagent_containers/glass/paint/purple,
	/obj/item/weapon/reagent_containers/glass/paint/black,
	/obj/item/weapon/reagent_containers/glass/paint/white,
	/obj/item/weapon/contraband/poster,
	/obj/item/weapon/wrapping_paper,
	/obj/item/weapon/wrapping_paper,
	/obj/item/weapon/wrapping_paper)
	cost = 1000
	crate_name = "Arts and Crafts crate"
	group = "Operations"

/datum/supply_pack/price_scanner
	name = "Export scanners"
	contains = list(/obj/item/device/export_scanner,
					/obj/item/device/export_scanner)
	cost = 1000
	crate_name = "Export scanners crate"
	group = "Operations"

//----------------------------------------------
//-----------------SECURITY---------------------
//----------------------------------------------

/datum/supply_pack/specialops
	name = "Special Ops supplies"
	contains = list(/obj/item/weapon/storage/box/emps,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/pen/reagent/paralysis,
					/obj/item/weapon/grenade/chem_grenade/incendiary)
	cost = 2000
	crate_name = "Special Ops crate"
	group = "Security"
	hidden = TRUE

/datum/supply_pack/weapons
	name = "Weapons crate"
	contains = list(/obj/item/weapon/melee/baton,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/taser,
					/obj/item/weapon/gun/energy/taser,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/flashbangs)
	cost = 3000
	containertype = /obj/structure/closet/crate/secure/weapon
	crate_name = "Weapons crate"
	access = access_brig
	group = "Security"

/datum/supply_pack/eweapons
	name = "Experimental weapons crate"
	contains = list(/obj/item/weapon/flamethrower/full,
					/obj/item/weapon/tank/plasma,
					/obj/item/weapon/tank/plasma,
					/obj/item/weapon/tank/plasma,
					/obj/item/weapon/grenade/chem_grenade/incendiary,
					/obj/item/weapon/grenade/chem_grenade/incendiary,
					/obj/item/weapon/grenade/chem_grenade/incendiary)
	cost = 2500
	containertype = /obj/structure/closet/crate/secure/weapon
	crate_name = "Experimental weapons crate"
	access = access_heads
	group = "Security"

/datum/supply_pack/armor
	name = "Armor crate"
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest/security,
					/obj/item/clothing/suit/armor/vest/detective,
					/obj/item/clothing/suit/storage/vest)
	cost = 1500
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Armor crate"
	access = access_brig
	group = "Security"

/datum/supply_pack/riot
	name = "Riot gear crate"
	contains = list(/obj/item/weapon/melee/baton,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/handcuffs,
					/obj/item/weapon/handcuffs,
					/obj/item/weapon/handcuffs,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot)
	cost = 6000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Riot gear crate"
	access = access_armory
	group = "Security"
/*
/datum/supply_pack/loyalty
	name = "Loyalty implant crate"
	contains = list (/obj/item/weapon/storage/lockbox/loyalty)
	cost = 6000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Loyalty implant crate"
	access = access_armory
	group = "Security"
*/
/datum/supply_pack/ballistic
	name = "Ballistic gear crate"
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/weapon/storage/box/shotgunammo/buckshot,
					/obj/item/weapon/storage/box/shotgunammo/slug,
					/obj/item/weapon/gun/projectile/shotgun/pump/combat,
					/obj/item/weapon/gun/projectile/shotgun/pump/combat)
	cost = 5000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Ballistic gear crate"
	access = access_armory
	group = "Security"

/datum/supply_pack/erifle
	name = "Energy marksman crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof,
					/obj/item/weapon/gun/energy/sniperrifle,
					/obj/item/weapon/gun/energy/sniperrifle)
	cost = 5000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Energy marksman crate"
	access = access_armory
	group = "Security"

/datum/supply_pack/shotgunammo_beanbag
	name = "Shotgun shells (Beanbag)"
	contains = list(/obj/item/weapon/storage/box/shotgunammo/beanbags,
					/obj/item/weapon/storage/box/shotgunammo/beanbags,
					/obj/item/weapon/storage/box/shotgunammo/beanbags)
	cost = 1000
	crate_name = "Shotgun shells (Beanbag)"
	group = "Security"

/datum/supply_pack/shotgunammo_slug
	name = "Shotgun shells (slug)"
	contains = list(/obj/item/weapon/storage/box/shotgunammo/slug,
					/obj/item/weapon/storage/box/shotgunammo/slug,
					/obj/item/weapon/storage/box/shotgunammo/slug)
	cost = 2000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Shotgun shells (slug)"
	access = access_armory
	group = "Security"

/datum/supply_pack/shotgunammo_buckshot
	name = "Shotgun shells (buckshot)"
	contains = list(/obj/item/weapon/storage/box/shotgunammo/buckshot,
					/obj/item/weapon/storage/box/shotgunammo/buckshot,
					/obj/item/weapon/storage/box/shotgunammo/buckshot)
	cost = 2500
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Shotgun shells (buckshot)"
	access = access_armory
	group = "Security"

/datum/supply_pack/expenergy
	name = "Experimental energy gear crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof,
					/obj/item/weapon/gun/energy/gun,
					/obj/item/weapon/gun/energy/gun)
	cost = 5000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Experimental energy gear crate"
	access = access_armory
	group = "Security"

/datum/supply_pack/exparmor
	name = "Experimental armor crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot)
	cost = 3500
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Experimental armor crate"
	access = access_armory
	group = "Security"

/datum/supply_pack/securitybarriers
	name = "Security barrier crate"
	contains = list(/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier)
	cost = 2000
	containertype = /obj/structure/closet/crate/secure/gear
	crate_name = "Security barrier crate"
	group = "Security"

/datum/supply_pack/securitywallshield
	name = "Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen)
	cost = 2000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "wall shield generators crate"
	access = access_teleporter
	group = "Security"

//----------------------------------------------
//-----------------HOSPITALITY------------------
//----------------------------------------------
/*
/datum/supply_pack/vending_bar
	name = "Bartending supply crate"
	contains = list(/obj/item/weapon/vending_refill/boozeomat)
	cost = 1500
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "bartending supply crate"
	group = "Hospitality"

/datum/supply_pack/vending_coffee
	name = "Hotdrinks supply crate"
	contains = list(/obj/item/weapon/vending_refill/coffee,
					/obj/item/weapon/vending_refill/coffee,
					/obj/item/weapon/vending_refill/coffee)
	cost = 1500
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "hotdrinks supply crate"
	group = "Hospitality"

/datum/supply_pack/vending_snack
	name = "Snack supply crate"
	contains = list(/obj/item/weapon/vending_refill/snack,
					/obj/item/weapon/vending_refill/snack,
					/obj/item/weapon/vending_refill/snack)
	cost = 1500
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "snack supply crate"
	group = "Hospitality"

/datum/supply_pack/vending_cola
	name = "Softdrinks supply crate"
	contains = list(/obj/item/weapon/vending_refill/cola,
					/obj/item/weapon/vending_refill/cola,
					/obj/item/weapon/vending_refill/cola)
	cost = 1500
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "softdrinks supply crate"
	group = "Hospitality"

/datum/supply_pack/vending_cigarette
	name = "Cigarette supply crate"
	contains = list(/obj/item/weapon/vending_refill/cigarette,
					/obj/item/weapon/vending_refill/cigarette,
					/obj/item/weapon/vending_refill/cigarette)
	cost = 1500
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "cigarette supply crate"
	group = "Hospitality"
*/
/datum/supply_pack/party
	name = "Party equipment"
	contains = list(/obj/item/weapon/storage/box/drinkingglasses,
					/obj/item/weapon/reagent_containers/food/drinks/shaker,
					/obj/item/weapon/reagent_containers/food/drinks/flask/barflask,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
					/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
					/obj/item/weapon/lipstick/random,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer)
	cost = 2000
	containertype = /obj/structure/closet/crate
	crate_name = "Party equipment"
	group = "Hospitality"

//----------------------------------------------
//-----------------ENGINEERING------------------
//----------------------------------------------

/datum/supply_pack/internals
	name = "Internals crate"
	/obj/item/clothing/mask/gas/coloured
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/air,
					/obj/item/weapon/tank/air,
					/obj/item/weapon/tank/air)
	cost = 1000
	containertype = /obj/structure/closet/crate/internals
	crate_name = "Internals crate"
	group = "Engineering"

/datum/supply_pack/sleeping_agent
	name = "Canister: \[N2O\]"
	contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)
	cost = 4000
	containertype = /obj/structure/largecrate
	crate_name = "N2O crate"
	group = "Engineering"

/datum/supply_pack/oxygen
	name = "Canister: \[O2\]"
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)
	cost = 3000
	containertype = /obj/structure/largecrate
	crate_name = "O2 crate"
	group = "Engineering"

/datum/supply_pack/nitrogen
	name = "Canister: \[N2\]"
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)
	cost = 2000
	containertype = /obj/structure/largecrate
	crate_name = "N2 crate"
	group = "Engineering"

/datum/supply_pack/air
	name = "Canister \[Air\]"
	contains = list(/obj/machinery/portable_atmospherics/canister/air)
	cost = 2000
	containertype = /obj/structure/largecrate
	crate_name = "Air crate"
	group = "Engineering"

/datum/supply_pack/evacuation
	name = "Emergency equipment"
	contains = list(/obj/item/weapon/storage/toolbox/emergency,
					/obj/item/weapon/storage/toolbox/emergency,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/weapon/tank/emergency_oxygen,
					/obj/item/weapon/tank/emergency_oxygen,
					/obj/item/weapon/tank/emergency_oxygen,
					/obj/item/weapon/tank/emergency_oxygen,
					/obj/item/weapon/tank/emergency_oxygen,
					/obj/item/clothing/mask/gas/coloured,
					/obj/item/clothing/mask/gas/coloured,
					/obj/item/clothing/mask/gas/coloured,
					/obj/item/clothing/mask/gas/coloured,
					/obj/item/clothing/mask/gas/coloured)
	cost = 3500
	containertype = /obj/structure/closet/crate/internals
	crate_name = "Emergency crate"
	group = "Engineering"

/datum/supply_pack/inflatable
	name = "Inflatable barriers"
	contains = list(/obj/item/weapon/storage/briefcase/inflatable,
					/obj/item/weapon/storage/briefcase/inflatable,
					/obj/item/weapon/storage/briefcase/inflatable)
	cost = 2000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Inflatable Barrier Crate"
	group = "Engineering"

/datum/supply_pack/lightbulbs
	name = "Replacement lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixed,
					/obj/item/weapon/storage/box/lights/mixed,
					/obj/item/weapon/storage/box/lights/mixed)
	cost = 1000
	containertype = /obj/structure/closet/crate
	crate_name = "Replacement lights"
	group = "Engineering"

/datum/supply_pack/metal50
	name = "50 metal sheets"
	contains = list(/obj/item/stack/material/steel)
	amount = 50
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Metal sheets crate"
	group = "Engineering"

/datum/supply_pack/glass50
	name = "50 glass sheets"
	contains = list(/obj/item/stack/material/glass)
	amount = 50
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Glass sheets crate"
	group = "Engineering"

/datum/supply_pack/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood)
	amount = 50
	cost = 1000
	containertype = /obj/structure/closet/crate
	crate_name = "Wooden planks crate"
	group = "Engineering"

/datum/supply_pack/electrical
	name = "Electrical maintenance crate"
	contains = list (/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/clothing/gloves/insulated,
					/obj/item/clothing/gloves/insulated,
					/obj/item/weapon/cell/large,
					/obj/item/weapon/cell/large,
					/obj/item/weapon/cell/large/high,
					/obj/item/weapon/cell/large/high)
	cost = 1500
	containertype = /obj/structure/closet/crate
	crate_name = "Electrical maintenance crate"
	group = "Engineering"

/datum/supply_pack/mechanical
	name = "Mechanical maintenance crate"
	contains = list(/obj/item/weapon/storage/belt/utility/full,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat)
	cost = 1000
	containertype = /obj/structure/closet/crate
	crate_name = "Mechanical maintenance crate"
	group = "Engineering"

/datum/supply_pack/fueltank
	name = "Fuel tank crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 800
	containertype = /obj/structure/largecrate
	crate_name = "fuel tank crate"
	group = "Engineering"

/datum/supply_pack/solar
	name = "Solar Pack crate"
	contains  = list(/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly, // 21 Solar Assemblies. 1 Extra for the controller
					/obj/item/weapon/circuitboard/solar_control,
					/obj/item/weapon/tracker_electronics,
					/obj/item/weapon/paper/solar)
	cost = 2000
	containertype = /obj/structure/closet/crate
	crate_name = "Solar pack crate"
	group = "Engineering"

/datum/supply_pack/engine
	name = "Emitter crate"
	contains = list(/obj/machinery/power/emitter,
					/obj/machinery/power/emitter)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Emitter crate"
	access = access_ce
	group = "Engineering"

/datum/supply_pack/engine/field_gen
	name = "Field Generator crate"
	contains = list(/obj/machinery/field_generator,
					/obj/machinery/field_generator)
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Field Generator crate"

/datum/supply_pack/engine/sing_gen
	name = "Singularity Generator crate"
	contains = list(/obj/machinery/the_singularitygen)
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Singularity Generator crate"

/datum/supply_pack/engine/collector
	name = "Collector crate"
	contains = list(/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector)
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Collector crate"

/datum/supply_pack/engine/PA
	name = "Particle Accelerator crate"
	cost = 4000
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Particle Accelerator crate"

/datum/supply_pack/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(/obj/item/weapon/book/manual/ripley_build_and_repair,
					/obj/item/weapon/circuitboard/mecha/ripley/main, //TEMPORARY due to lack of circuitboard printer
					/obj/item/weapon/circuitboard/mecha/ripley/peripherals) //TEMPORARY due to lack of circuitboard printer
	cost = 3000
	containertype = /obj/structure/closet/crate/secure/scisecurecrate
	crate_name = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics
	group = "Engineering"

/datum/supply_pack/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(/obj/item/weapon/circuitboard/mecha/odysseus/peripherals, //TEMPORARY due to lack of circuitboard printer
					/obj/item/weapon/circuitboard/mecha/odysseus/main) //TEMPORARY due to lack of circuitboard printer
	cost = 2500
	containertype = /obj/structure/closet/crate/secure/scisecurecrate
	crate_name = "\"Odysseus\" Circuit Crate"
	access = access_robotics
	group = "Engineering"

/datum/supply_pack/robotics
	name = "Robotics assembly crate"
	contains = list(/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/weapon/cell/large/high,
					/obj/item/weapon/cell/large/high)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure/scisecurecrate
	crate_name = "Robotics assembly"
	access = access_robotics
	group = "Engineering"

/datum/supply_pack/shield_gen
	contains = list(/obj/item/weapon/circuitboard/shield_gen)
	name = "Bubble shield generator circuitry"
	cost = 5000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "bubble shield generator circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_pack/shield_gen_ex
	contains = list(/obj/item/weapon/circuitboard/shield_gen_ex)
	name = "Hull shield generator circuitry"
	cost = 5000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "hull shield generator circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_pack/shield_cap
	contains = list(/obj/item/weapon/circuitboard/shield_cap)
	name = "Bubble shield capacitor circuitry"
	cost = 5000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "shield capacitor circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_pack/smbig
	name = "Supermatter Core"
	contains = list(/obj/machinery/power/supermatter)
	cost = 5000
	containertype = /obj/structure/closet/crate/secure/woodseccrate
	crate_name = "Supermatter crate (CAUTION)"
	group = "Engineering"
	access = access_ce

/datum/supply_pack/teg
	contains = list(/obj/machinery/power/generator)
	name = "Mark I Thermoelectric Generator"
	cost = 7500
	containertype = /obj/structure/closet/crate/secure/large
	crate_name = "Mk1 TEG crate"
	group = "Engineering"
	access = access_engine

/datum/supply_pack/circulator
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	name = "Binary atmospheric circulator"
	cost = 6000
	containertype = /obj/structure/closet/crate/secure/large
	crate_name = "Atmospheric circulator crate"
	group = "Engineering"
	access = access_engine

/datum/supply_pack/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	cost = 3500
	containertype = /obj/structure/closet/crate/secure/large
	crate_name = "Pipe Dispenser Crate"
	group = "Engineering"
	access = access_atmospherics

/datum/supply_pack/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	cost = 3500
	containertype = /obj/structure/closet/crate/secure/large
	crate_name = "Disposal Dispenser Crate"
	group = "Engineering"
	access = access_atmospherics

//----------------------------------------------
//------------MEDICAL / SCIENCE-----------------
//----------------------------------------------

/datum/supply_pack/medical
	name = "Medical crate"
	contains = list(/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/adv,
					/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
					/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
					/obj/item/weapon/storage/box/syringes,
					/obj/item/weapon/storage/box/autoinjectors)
	cost = 1000
	containertype = /obj/structure/closet/crate/medical
	crate_name = "Medical crate"
	group = "Medical / Science"

/datum/supply_pack/virus
	name = "Virus sample crate"
	contains = list(/obj/item/weapon/virusdish/random,
					/obj/item/weapon/virusdish/random,
					/obj/item/weapon/virusdish/random,
					/obj/item/weapon/virusdish/random)
	cost = 2500
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Virus sample crate"
	access = access_cmo
	group = "Medical / Science"

/datum/supply_pack/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 1600
	containertype = /obj/structure/largecrate
	crate_name = "Coolant tank crate"
	group = "Medical / Science"

/datum/supply_pack/phoron
	name = "Phoron assembly crate"
	contains = list(/obj/item/weapon/tank/plasma,
					/obj/item/weapon/tank/plasma,
					/obj/item/weapon/tank/plasma,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure/scisecurecrate
	crate_name = "Phoron assembly crate"
	access = access_tox_storage
	group = "Medical / Science"

/datum/supply_pack/surgery
	name = "Surgery crate"
	contains = list(/obj/item/weapon/tool/cautery,
					/obj/item/weapon/tool/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/weapon/tank/anesthetic,
					/obj/item/weapon/tool/hemostat,
					/obj/item/weapon/tool/scalpel,
					/obj/item/weapon/tool/retractor,
					/obj/item/weapon/tool/bonesetter,
					/obj/item/weapon/tool/saw/circular)
	cost = 2500
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Surgery crate"
	access = access_medical
	group = "Medical / Science"

/datum/supply_pack/sterile
	name = "Sterile equipment crate"
	contains = list(/obj/item/clothing/under/rank/medical/green,
					/obj/item/clothing/under/rank/medical/green,
					/obj/item/clothing/head/surgery/green,
					/obj/item/clothing/head/surgery/green,
					/obj/item/weapon/storage/box/masks,
					/obj/item/weapon/storage/box/gloves)
	cost = 1500
	containertype = /obj/structure/closet/crate
	crate_name = "Sterile equipment crate"
	group = "Medical / Science"

/datum/supply_pack/bloodpacks
	name = "Blood Pack Variety Crate"
	cost = 3500
	contains = list(/obj/item/weapon/reagent_containers/blood/empty,
					/obj/item/weapon/reagent_containers/blood/empty,
					/obj/item/weapon/reagent_containers/blood/APlus,
					/obj/item/weapon/reagent_containers/blood/AMinus,
					/obj/item/weapon/reagent_containers/blood/BPlus,
					/obj/item/weapon/reagent_containers/blood/BMinus,
					/obj/item/weapon/reagent_containers/blood/OPlus,
					/obj/item/weapon/reagent_containers/blood/OMinus)
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "blood freezer"
	group = "Medical / Science"

/datum/supply_pack/iv_drip
	name = "IV Drip Crate"
	cost = 1000
	contains = list(/obj/machinery/iv_drip)
	containertype = /obj/structure/closet/crate/medical
	crate_name = "iv drip crate"
	group = "Medical / Science"

/datum/supply_pack/body_bags
	name = "Body Bags Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/box/bodybags,
					/obj/item/weapon/storage/box/bodybags,
					/obj/item/weapon/storage/box/bodybags)
	crate_name = "body bags crate"
	group = "Medical / Science"

/datum/supply_pack/suspension_gen
	name = "Suspension Field Generetor Crate"
	cost = 3000
	contains = list(/obj/machinery/suspension_gen)
	containertype = /obj/structure/closet/crate/secure/scisecurecrate
	crate_name = "Suspension Field Generetor Crate"
	access = access_research
	group = "Medical / Science"

/datum/supply_pack/floodlight
	name = "Emergency Floodlight Crate"
	cost = 2000
	contains = list(/obj/machinery/floodlight,
					/obj/machinery/floodlight)
	containertype = /obj/structure/closet/crate/scicrate
	crate name = "Emergency Floodlight Crate"
	group = "Medical / Science"

//----------------------------------------------
//-----------------HYDROPONICS------------------
//----------------------------------------------

/datum/supply_pack/monkey
	name = "Monkey crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes)
	cost = 2000
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "Monkey crate"
	group = "Hydroponics"

/datum/supply_pack/hydroponics // -- Skie
	name = "Hydroponics Supply Crate"
	contains = list(/obj/item/weapon/reagent_containers/spray/plantbgone,
					/obj/item/weapon/reagent_containers/spray/plantbgone,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia,
					/obj/item/weapon/material/hatchet,
					/obj/item/weapon/material/minihoe,
					/obj/item/device/scanner/analyzer/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron) // Updated with new things
	cost = 1500
	containertype = /obj/structure/closet/crate/hydroponics
	crate_name = "Hydroponics crate"
	access = access_hydroponics
	group = "Hydroponics"

//farm animals - useless and annoying, but potentially a good source of food
/datum/supply_pack/cow
	name = "Cow crate"
	cost = 3000
	containertype = /obj/structure/largecrate/animal/cow
	crate_name = "Cow crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_pack/goat
	name = "Goat crate"
	cost = 2500
	containertype = /obj/structure/largecrate/animal/goat
	crate_name = "Goat crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_pack/chicken
	name = "Chicken crate"
	cost = 2000
	containertype = /obj/structure/largecrate/animal/chick
	crate_name = "Chicken crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_pack/corgi
	name = "Corgi crate"
	cost = 5000
	containertype = /obj/structure/largecrate/animal/corgi
	crate_name = "Corgi crate"
	group = "Hydroponics"

/datum/supply_pack/cat
	name = "Cat crate"
	cost = 4000
	containertype = /obj/structure/largecrate/animal/cat
	crate_name = "Cat crate"
	group = "Hydroponics"

/datum/supply_pack/seeds
	name = "Seeds crate"
	contains = list(/obj/item/seeds/chiliseed,
					/obj/item/seeds/berryseed,
					/obj/item/seeds/cornseed,
					/obj/item/seeds/eggplantseed,
					/obj/item/seeds/tomatoseed,
					/obj/item/seeds/appleseed,
					/obj/item/seeds/soyaseed,
					/obj/item/seeds/wheatseed,
					/obj/item/seeds/carrotseed,
					/obj/item/seeds/harebell,
					/obj/item/seeds/lemonseed,
					/obj/item/seeds/orangeseed,
					/obj/item/seeds/grassseed,
					/obj/item/seeds/sunflowerseed,
					/obj/item/seeds/chantermycelium,
					/obj/item/seeds/potatoseed,
					/obj/item/seeds/sugarcaneseed)
	cost = 1000
	containertype = /obj/structure/closet/crate/hydroponics
	crate_name = "Seeds crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_pack/weedcontrol
	name = "Weed control crate"
	contains = list(/obj/item/clothing/mask/gas/coloured,
					/obj/item/weapon/grenade/chem_grenade/antiweed,
					/obj/item/weapon/grenade/chem_grenade/antiweed,
					/obj/item/weapon/grenade/chem_grenade/antiweed,
					/obj/item/weapon/grenade/chem_grenade/antiweed)
	cost = 2000
	containertype = /obj/structure/closet/crate/secure/hydrosec
	crate_name = "Weed control crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_pack/exoticseeds
	name = "Exotic seeds crate"
	contains = list(/obj/item/seeds/libertymycelium,
					/obj/item/seeds/reishimycelium,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/kudzuseed)
	cost = 1500
	containertype = /obj/structure/closet/crate/hydroponics
	crate_name = "Exotic Seeds crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_pack/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 800
	containertype = /obj/structure/largecrate
	crate_name = "Water tank crate"
	group = "Hydroponics"
/*
/datum/supply_pack/bee_keeper
	name = "Beekeeping crate"
	contains = list(/obj/item/beezeez,
					/obj/item/weapon/bee_net,
					/obj/item/apiary,
					/obj/item/queen_bee)
	cost = 4000
	contraband = TRUE
	containertype = /obj/structure/closet/crate/hydroponics
	crate_name = "Beekeeping crate"
	access = access_hydroponics
	group = "Hydroponics"
*/
//----------------------------------------------
//--------------------MINING--------------------
//----------------------------------------------
/*
/datum/supply_pack/mining
	name = "Mining Explosives Crate"
	contains = list(/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,
					/obj/item/weapon/mining_charge,)
	cost = 1500
	containertype = /obj/structure/closet/crate/secure/gear
	crate_name = "Mining Explosives Crate"
	access = access_mining
	group = "Mining"
*/
/datum/supply_pack/mining_drill
	name = "Drill Crate"
	contains = list(/obj/machinery/mining/drill)
	cost = 3000
	containertype = /obj/structure/closet/crate/secure/large
	crate_name = "Drill Crate"
	access = access_mining
	group = "Mining"

/datum/supply_pack/mining_brace
	name = "Brace Crate"
	contains = list(/obj/machinery/mining/brace)
	cost = 1500
	containertype = /obj/structure/closet/crate/secure/large
	crate_name = "Brace Crate"
	access = access_mining
	group = "Mining"

/datum/supply_pack/mining_supply
	name = "Mining Supply Crate"
	contains = list(
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/device/lighting/toggleable/flashlight,
					/obj/item/weapon/tool/pickaxe/jackhammer)
	cost = 3000
	containertype = /obj/structure/closet/crate/secure/gear
	crate_name = "Mining Supply Crate"
	access = access_mining
	group = "Mining"

//----------------------------------------------
//--------------------SUPPLY--------------------
//----------------------------------------------

/datum/supply_pack/food
	name = "Kitchen supply crate"
	contains = list(/obj/item/weapon/reagent_containers/food/condiment/flour,
					/obj/item/weapon/reagent_containers/food/condiment/flour,
					/obj/item/weapon/reagent_containers/food/condiment/flour,
					/obj/item/weapon/reagent_containers/food/condiment/flour,
					/obj/item/weapon/reagent_containers/food/drinks/milk,
					/obj/item/weapon/reagent_containers/food/drinks/milk,
					/obj/item/weapon/storage/fancy/egg_box,
					/obj/item/weapon/reagent_containers/food/snacks/tofu,
					/obj/item/weapon/reagent_containers/food/snacks/tofu,
					/obj/item/weapon/reagent_containers/food/snacks/meat,
					/obj/item/weapon/reagent_containers/food/snacks/meat)

	cost = 1000
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "Food crate"
	group = "Supply"

/datum/supply_pack/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner)
	cost = 1000
	crate_name = "Toner cartridges"
	group = "Supply"

/datum/supply_pack/misc/posters
	name = "Corporate Posters Crate"
	contains = list(/obj/item/weapon/contraband/poster,
					/obj/item/weapon/contraband/poster,
					/obj/item/weapon/contraband/poster,
					/obj/item/weapon/contraband/poster,
					/obj/item/weapon/contraband/poster)
	cost = 800
	crate_name = "Corporate Posters Crate"
	group = "Supply"

/datum/supply_pack/janitor
	name = "Janitorial supplies"
	contains = list(/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/item/weapon/caution,
					/obj/item/weapon/caution,
					/obj/item/weapon/caution,
					/obj/item/weapon/caution,
					/obj/item/weapon/storage/bag/trash,
					/obj/item/device/lightreplacer,
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/grenade/chem_grenade/cleaner,
					/obj/item/weapon/grenade/chem_grenade/cleaner,
					/obj/item/weapon/grenade/chem_grenade/cleaner,
					/obj/structure/mopbucket)
	cost = 1000
	crate_name = "Janitorial supplies"
	group = "Supply"

/datum/supply_pack/boxes
	name = "Empty boxes"
	contains = list(/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box,
	/obj/item/weapon/storage/box)
	cost = 1000
	crate_name = "Empty box crate"
	group = "Supply"

//----------------------------------------------
//--------------MISCELLANEOUS-------------------
//----------------------------------------------

/datum/supply_pack/formal_wear
	contains = list(/obj/item/clothing/head/bowler,
					/obj/item/clothing/head/that,
					/obj/item/clothing/under/suit_jacket,
					/obj/item/clothing/under/suit_jacket/red,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/leather,
					/obj/item/clothing/suit/wcoat)
	name = "Formalwear closet"
	cost = 2000
	containertype = /obj/structure/closet
	crate_name = "Formalwear for the best occasions."
	group = "Miscellaneous"

/datum/supply_pack/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "EFTPOS scanner"
	cost = 1000
	crate_name = "EFTPOS crate"
	group = "Miscellaneous"

//----------------------------------------------
//-----------------RANDOMISED-------------------
//----------------------------------------------

/datum/supply_pack/randomised
	name = "Collectable Hats Crate!"
	cost = 20000
	var/num_contained = 4 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	crate_name = "Collectable hats crate! Brought to you by Bass.inc!"
	group = "Miscellaneous"

/datum/supply_pack/randomised/fill(obj/structure/closet/crate/C)
	var/list/L = contains.Copy()
	var/item
	if(num_contained <= L.len)
		for(var/i in 1 to num_contained)
			item = pick_n_take(L)
			new item(C)
	else
		for(var/i in 1 to num_contained)
			item = pick(L)
			new item(C)

/datum/supply_pack/randomised/contraband
	num_contained = 5
	contains = list(/obj/item/seeds/bloodtomatoseed,
					/obj/item/weapon/storage/pill_bottle/zoom,
					/obj/item/seeds/kudzuseed,
					/obj/item/weapon/storage/pill_bottle/happy,
					/obj/item/weapon/contraband/poster,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine)
	name = "Contraband crate"
	cost = 3000
	containertype = /obj/structure/closet/crate
	crate_name = "Unlabeled crate"
	contraband = TRUE
	group = "Operations"

/datum/supply_pack/randomised/pizza
	num_contained = 5
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	name = "Surprise pack of five pizzas"
	cost = 1500
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "Pizza crate"
	group = "Hospitality"

/datum/supply_pack/randomised/costume
	num_contained = 2
	contains = list(/obj/item/clothing/suit/pirate,
					/obj/item/clothing/suit/judgerobe,
					/obj/item/clothing/suit/wcoat,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/under/rank/fo_suit,
					/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
					/obj/item/clothing/under/schoolgirl,
					/obj/item/clothing/under/owl,
					/obj/item/clothing/under/waiter,
					/obj/item/clothing/under/gladiator,
					/obj/item/clothing/under/soviet,
					/obj/item/clothing/under/bride_white,
					/obj/item/clothing/suit/chef,
					/obj/item/clothing/under/kilt)
	name = "Costumes crate"
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "Actor Costumes"
	access = access_theatre
	group = "Miscellaneous"
