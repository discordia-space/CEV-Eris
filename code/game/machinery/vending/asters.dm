/obj/machinery/vending/powermat
	name = "Asters Guild Power-Mat"
	desc = "Trust is power, and there's no power you can trust like Robustcell."
	product_slogans = "Trust is power, and there's no cell you can trust like Robustcell.;No battery is stronger nor lasts longer.;One that Lasts!;You can't top the copper top!"
	product_ads = "Robust!;Trustworthy!;Durable!"
	icon_state = "powermat"
	products = list(/obj/item/cell/large = 10, /obj/item/cell/large/high = 10, /obj/item/cell/medium = 15, /obj/item/cell/medium/high = 15, /obj/item/cell/small = 20, /obj/item/cell/small/high = 20)
	contraband = list(/obj/item/cell/large/super = 5, /obj/item/cell/medium/super = 5, /obj/item/cell/small/super = 5)
	prices = list(/obj/item/cell/large = 500, /obj/item/cell/large/high = 700, /obj/item/cell/medium = 300, /obj/item/cell/medium/high = 400, /obj/item/cell/small = 100, /obj/item/cell/small/high = 200,
				/obj/item/cell/large/super = 1200, /obj/item/cell/medium/super = 700, /obj/item/cell/small/super = 350)

/obj/machinery/vending/printomat
	name = "Asters Guild Print-o-Mat"
	desc = "Everything you can imagine (not really) on a disc! Print your own gun TODAY."
	product_slogans = "Print your own gun TODAY!;The future is NOW!;Can't stop the industrial revolution!"
	product_ads = "Almost free!;Print it yourself!;Don't copy that floppy!"
	icon_state = "discomat"
	products = list(
					/obj/item/computer_hardware/hard_drive/portable = 20,
					/obj/item/storage/box/data_disk/basic = 5,
					/obj/item/computer_hardware/hard_drive/portable/design/misc = 10,
					/obj/item/computer_hardware/hard_drive/portable/design/devices = 10,
					/obj/item/computer_hardware/hard_drive/portable/design/tools = 10,
					/obj/item/computer_hardware/hard_drive/portable/design/components = 10,
					/obj/item/computer_hardware/hard_drive/portable/design/adv_tools = 5,
					/obj/item/computer_hardware/hard_drive/portable/design/circuits = 5,
					/obj/item/computer_hardware/hard_drive/portable/design/conveyors = 2,
					/obj/item/computer_hardware/hard_drive/portable/design/computer = 10,
					/obj/item/computer_hardware/hard_drive/portable/design/medical = 10,
					/obj/item/computer_hardware/hard_drive/portable/design/security = 5,
					/obj/item/computer_hardware/hard_drive/portable/design/armor/asters = 5,
					/obj/item/computer_hardware/hard_drive/portable/design/guns/fs_cheap_guns = 5,
					/obj/item/computer_hardware/hard_drive/portable/design/guns/fs_slaught_o_matic = 5,
					/obj/item/computer_hardware/hard_drive/portable/design/nonlethal_ammo = 10,
					/obj/item/electronics/circuitboard/autolathe = 3,
					/obj/item/electronics/circuitboard/vending = 10)
	contraband = list(
			/obj/item/computer_hardware/hard_drive/portable/design/lethal_ammo = 3,
			/obj/item/electronics/circuitboard/autolathe_disk_cloner = 3
			)
	prices = list(/obj/item/computer_hardware/hard_drive/portable = 50,
					/obj/item/storage/box/data_disk/basic = 100,
					/obj/item/computer_hardware/hard_drive/portable/design/misc = 300,
					/obj/item/computer_hardware/hard_drive/portable/design/devices = 400,
					/obj/item/computer_hardware/hard_drive/portable/design/tools = 400,
					/obj/item/computer_hardware/hard_drive/portable/design/components = 500,
					/obj/item/computer_hardware/hard_drive/portable/design/adv_tools = 1800,
					/obj/item/computer_hardware/hard_drive/portable/design/circuits = 600,
					/obj/item/computer_hardware/hard_drive/portable/design/conveyors = 400,
					/obj/item/computer_hardware/hard_drive/portable/design/medical = 400,
					/obj/item/computer_hardware/hard_drive/portable/design/computer = 500,
					/obj/item/computer_hardware/hard_drive/portable/design/security = 600,
					/obj/item/computer_hardware/hard_drive/portable/design/armor/asters = 900,
					/obj/item/computer_hardware/hard_drive/portable/design/guns/fs_cheap_guns = 3000,
					/obj/item/computer_hardware/hard_drive/portable/design/guns/fs_slaught_o_matic = 600,
					/obj/item/computer_hardware/hard_drive/portable/design/nonlethal_ammo = 700,
					/obj/item/electronics/circuitboard/autolathe = 700,
					/obj/item/electronics/circuitboard/autolathe_disk_cloner = 1000,
					/obj/item/electronics/circuitboard/vending = 500,
					/obj/item/computer_hardware/hard_drive/portable/design/lethal_ammo = 1200,)

/obj/machinery/vending/style
	name = "Asters Guild Style-o-matic"
	desc = "Asters Guild vendor selling, possibly stolen, most likely overpriced, stylish clothing."
	product_slogans = "Highly stylish clothing for sale!;Latest fashion trends right here!"
	product_ads = "Stylish!;Cheap!;Legal within this sector!"
	icon_state = "style"
	products = list(
		/obj/item/clothing/mask/scarf/style = 8,
		/obj/item/clothing/mask/scarf/style/bluestyle = 8,
		/obj/item/clothing/mask/scarf/style/yellowstyle = 8,
		/obj/item/clothing/mask/scarf/style/redstyle = 8,
		/obj/item/clothing/gloves/knuckles = 3,
		/obj/item/clothing/head/ranger = 4,
		/obj/item/clothing/head/inhaler = 2,
		/obj/item/clothing/head/skull = 3,
		/obj/item/clothing/head/skull/black = 3,
		/obj/item/clothing/shoes/redboot = 4,
		/obj/item/clothing/shoes/jackboots/longboot = 3,
		/obj/item/clothing/under/white = 4,
		/obj/item/clothing/under/red = 4,
		/obj/item/clothing/under/green = 4,
		/obj/item/clothing/under/grey = 4,
		/obj/item/clothing/under/black = 4,
		/obj/item/clothing/under/dress = 4,
		/obj/item/clothing/under/dress/white = 4,
		/obj/item/clothing/under/helltaker = 4,
		/obj/item/clothing/under/johnny = 3,
		/obj/item/clothing/under/raider = 3,
		/obj/item/clothing/suit/storage/triad = 2,
		/obj/item/clothing/suit/storage/akira = 2
					)
	prices = list(
		/obj/item/clothing/mask/scarf/style = 250,
		/obj/item/clothing/mask/scarf/style/bluestyle = 250,
		/obj/item/clothing/mask/scarf/style/yellowstyle = 250,
		/obj/item/clothing/mask/scarf/style/redstyle = 250,
		/obj/item/clothing/gloves/knuckles = 650,
		/obj/item/clothing/head/ranger = 550,
		/obj/item/clothing/head/inhaler = 750,
		/obj/item/clothing/head/skull = 450,
		/obj/item/clothing/head/skull/black = 450,
		/obj/item/clothing/shoes/redboot = 450,
		/obj/item/clothing/shoes/jackboots/longboot = 550,
		/obj/item/clothing/under/white = 600,
		/obj/item/clothing/under/red = 600,
		/obj/item/clothing/under/green = 600,
		/obj/item/clothing/under/grey = 600,
		/obj/item/clothing/under/black = 600,
		/obj/item/clothing/under/dress = 600,
		/obj/item/clothing/under/dress/white = 600,
		/obj/item/clothing/under/helltaker = 600,
		/obj/item/clothing/under/johnny = 750,
		/obj/item/clothing/under/raider = 750,
		/obj/item/clothing/suit/storage/triad = 1200,
		/obj/item/clothing/suit/storage/akira = 750,
		/obj/item/clothing/head/skull/drip = 100000
					)

	contraband = list(
		/obj/item/clothing/head/skull/drip = 1)	//drip
