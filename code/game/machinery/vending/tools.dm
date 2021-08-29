/*
/obj/machinery/vending/atmospherics //Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	product_paths = "/obj/item/tank/oxygen;/obj/item/tank/plasma;/obj/item/tank/emergency_oxygen;/obj/item/tank/emergency_oxygen/engi;/obj/item/clothing/mask/breath"
	productamounts = "10;10;10;5;25"
	vend_delay = 0
*/


/obj/machinery/vending/assist
	products = list(
		/obj/item/device/assembly/prox_sensor = 5,/obj/item/device/assembly/igniter = 3,
		/obj/item/device/assembly/signaler = 6,/obj/item/tool/wirecutters = 1, /obj/item/tool/wirecutters/pliers = 1
	)
	contraband = list(/obj/item/device/lighting/toggleable/flashlight = 5,/obj/item/device/assembly/timer = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"
	auto_price = FALSE

//yes, guns are tools
/obj/machinery/vending/weapon_machine
	name = "Frozen Star Guns&Ammo"
	desc = "A self-defense equipment vending machine. When you need to take care of that clown."
	product_slogans = "The best defense is good offense!;Buy for your whole family today!;Nobody can outsmart bullet!;God created man - Frozen Star made them EQUAL!;Stupidity can be cured! By LEAD.;Dead kids can't bully your children!"
	product_ads = "Stunning!;Take justice in your own hands!;LEADearship!"
	icon_state = "weapon"
	no_criminals = TRUE
	products = list(/obj/item/device/flash = 6,
					/obj/item/reagent_containers/spray/pepper = 6,
					/obj/item/gun/projectile/olivaw = 5,
					/obj/item/gun/projectile/giskard = 5,
					/obj/item/gun/energy/gun/martin = 5,
					/obj/item/gun/energy/gun = 5,
					/obj/item/gun/projectile/revolver/havelock = 5,
					/obj/item/gun/projectile/automatic/atreides = 3,
					/obj/item/gun/projectile/shotgun/pump = 3,
					/obj/item/gun/projectile/automatic/slaught_o_matic = 30,
					/obj/item/ammo_magazine/pistol/rubber = 20,
					/obj/item/ammo_magazine/hpistol/rubber = 5,
					/obj/item/ammo_magazine/slpistol/rubber = 20,
					/obj/item/ammo_magazine/smg/rubber = 15,
					/obj/item/ammo_magazine/ammobox/pistol/rubber = 20,
					/obj/item/ammo_magazine/sllrifle = 10,
					/obj/item/ammo_magazine/ammobox/shotgun/beanbags = 10,
					/obj/item/ammo_magazine/ammobox/shotgun/flashshells = 10,
					/obj/item/ammo_magazine/ammobox/shotgun/blanks = 10,
					/obj/item/clothing/accessory/holster = 5,
					/obj/item/clothing/accessory/holster/armpit = 5,
					/obj/item/clothing/accessory/holster/waist = 5,
					/obj/item/clothing/accessory/holster/hip = 5,
					/obj/item/ammo_magazine/slpistol = 5,
					/obj/item/ammo_magazine/pistol = 5,
					/obj/item/ammo_magazine/hpistol = 5,
					/obj/item/ammo_magazine/smg = 3,
					/obj/item/ammo_magazine/ammobox/pistol = 5,
					/obj/item/ammo_magazine/ammobox/shotgun = 3,
					/obj/item/ammo_magazine/ammobox/shotgun/buckshot = 3,
					/obj/item/tool/knife/tacknife = 5,
					/obj/item/storage/box/smokes = 3)

	prices = list(
					/obj/item/ammo_magazine/ammobox/pistol/rubber = 200,
					/obj/item/ammo_magazine/slpistol/rubber = 100,
					/obj/item/ammo_magazine/pistol/rubber = 150,
					/obj/item/ammo_magazine/hpistol = 300,
					/obj/item/ammo_magazine/hpistol/rubber = 200,
					/obj/item/ammo_magazine/ammobox/shotgun/beanbags = 300,
					/obj/item/ammo_magazine/ammobox/shotgun/flashshells = 300,
					/obj/item/ammo_magazine/ammobox/shotgun/blanks = 50,
					/obj/item/ammo_magazine/sllrifle = 300,
					/obj/item/ammo_magazine/slpistol = 100,
					/obj/item/ammo_magazine/smg/rubber = 200,
					/obj/item/ammo_magazine/smg = 400,
					/obj/item/ammo_magazine/ammobox/pistol = 500,
					/obj/item/ammo_magazine/ammobox/shotgun = 600,
					/obj/item/ammo_magazine/ammobox/shotgun/buckshot = 600,
					/obj/item/tool/knife/tacknife = 300,
					/obj/item/storage/box/smokes = 200,
					/obj/item/ammo_magazine/pistol = 300,)

//This one's from bay12
/obj/machinery/vending/cart
	name = "PTech"
	desc = "PDAs and hardware."
	product_slogans = "PDAs for everyone!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	products = list(/obj/item/modular_computer/pda = 10,/obj/item/computer_hardware/scanner/medical = 6,
					/obj/item/computer_hardware/scanner/reagent = 6,/obj/item/computer_hardware/scanner/atmos = 6,
					/obj/item/computer_hardware/scanner/paper = 10,/obj/item/computer_hardware/printer = 10,
					/obj/item/computer_hardware/card_slot = 3,/obj/item/computer_hardware/ai_slot = 4)
	auto_price = FALSE


/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/tool/crowbar = 5,/obj/item/tool/weldingtool = 5,/obj/item/tool/wirecutters = 3, /obj/item/tool/wirecutters/pliers = 3,
					/obj/item/tool/wrench = 5,/obj/item/tool/hammer = 5,/obj/item/device/scanner/gas = 5,/obj/item/device/t_scanner = 5, /obj/item/tool/screwdriver = 5, /obj/item/clothing/gloves/insulated/cheap  = 2, /obj/item/clothing/gloves/insulated = 1,
					/obj/item/storage/pouch/engineering_tools = 2, /obj/item/storage/pouch/engineering_supply = 2)
	prices = list(/obj/item/tool/hammer = 30,/obj/item/stack/cable_coil/random = 100,/obj/item/tool/crowbar = 30,/obj/item/tool/weldingtool = 50,/obj/item/tool/wirecutters = 30, /obj/item/tool/wirecutters/pliers = 30,
					/obj/item/tool/wrench = 30,/obj/item/device/scanner/gas = 50,/obj/item/device/t_scanner = 50, /obj/item/tool/screwdriver = 30, /obj/item/clothing/gloves/insulated/cheap  = 80, /obj/item/clothing/gloves/insulated = 600,
					/obj/item/storage/pouch/engineering_tools = 300, /obj/item/storage/pouch/engineering_supply = 600)

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	products = list(/obj/item/clothing/glasses/powered/meson = 2,/obj/item/tool/multitool = 4,/obj/item/electronics/airlock = 10,/obj/item/electronics/circuitboard/apc = 10,/obj/item/electronics/airalarm = 10,/obj/item/cell/large/high = 10,/obj/item/rpd = 3)
	contraband = list(/obj/item/cell/large/potato = 3)
	premium = list(/obj/item/storage/belt/utility = 3)
	auto_price = FALSE

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself ship repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	products = list(/obj/item/clothing/head/hardhat = 4,
					/obj/item/storage/belt/utility = 4,/obj/item/clothing/glasses/powered/meson = 4,/obj/item/clothing/gloves/insulated = 4, /obj/item/tool/screwdriver = 12,
					/obj/item/tool/crowbar = 12,/obj/item/tool/wirecutters = 6, /obj/item/tool/wirecutters/pliers = 6, /obj/item/tool/multitool = 12,/obj/item/tool/wrench = 12,/obj/item/tool/hammer = 10,/obj/item/device/t_scanner = 12,
					/obj/item/cell/large = 8, /obj/item/tool/weldingtool = 8,/obj/item/clothing/head/welding = 8,
					/obj/item/light/tube = 10,/obj/item/clothing/suit/fire = 4, /obj/item/stock_parts/scanning_module = 5,/obj/item/stock_parts/micro_laser = 5,
					/obj/item/stock_parts/matter_bin = 5,/obj/item/stock_parts/manipulator = 5,/obj/item/stock_parts/console_screen = 5)
	prices = list(/obj/item/clothing/head/hardhat = 4,/obj/item/tool/hammer = 30,
					/obj/item/storage/belt/utility = 150,/obj/item/clothing/glasses/powered/meson = 300,/obj/item/clothing/gloves/insulated = 600, /obj/item/tool/screwdriver = 30,
					/obj/item/tool/crowbar = 30,/obj/item/tool/wirecutters = 30,/obj/item/tool/wirecutters/pliers = 30,/obj/item/tool/multitool = 40,/obj/item/tool/wrench = 40,/obj/item/device/t_scanner = 50,
					/obj/item/cell/large = 500, /obj/item/tool/weldingtool = 40,/obj/item/clothing/head/welding = 80,
					/obj/item/light/tube = 10,/obj/item/clothing/suit/fire = 150, /obj/item/stock_parts/scanning_module = 40,/obj/item/stock_parts/micro_laser = 40,
					/obj/item/stock_parts/matter_bin = 40,/obj/item/stock_parts/manipulator = 40,/obj/item/stock_parts/console_screen = 40)

//FOR ACTORS GUILD - mainly props that cannot be spawned otherwise
/obj/machinery/vending/props
	name = "prop dispenser"
	desc = "All the props an actor could need. Probably."
	icon_state = "Theater"
	products = list(/obj/structure/flora/pottedplant = 2, /obj/item/device/lighting/toggleable/lamp = 2, /obj/item/device/lighting/toggleable/lamp/green = 2, /obj/item/reagent_containers/food/drinks/jar = 1,
					/obj/item/toy/cultsword = 4, /obj/item/toy/katana = 2, /obj/item/phone = 3, /obj/item/clothing/head/centhat = 3, /obj/item/clothing/head/richard = 1)
	auto_price = FALSE

//FOR ACTORS GUILD - Containers
/obj/machinery/vending/containers
	name = "container dispenser"
	desc = "A container that dispenses containers."
	icon_state = "robotics"
	products = list(/obj/structure/closet/crate/freezer = 2, /obj/structure/closet = 3, /obj/structure/closet/crate = 3)
	auto_price = FALSE
