/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack some skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access = list(access_security)
	products = list(/obj/item/handcuffs = 8,
					/obj/item/handcuffs/zipties = 8,
					/obj/item/grenade/flashbang = 8,
					/obj/item/grenade/chem_grenade/teargas = 8,
					/obj/item/grenade/smokebomb = 8,
					/obj/item/device/flash = 8,
					/obj/item/reagent_containers/spray/pepper = 8,
					/obj/item/ammo_magazine/ihclrifle/rubber = 8,
					/obj/item/ammo_magazine/pistol/rubber = 8,
					/obj/item/ammo_magazine/smg/rubber = 4,
					/obj/item/ammo_magazine/slmagnum/rubber = 4,
					/obj/item/ammo_magazine/magnum/rubber = 4,
					/obj/item/ammo_magazine/ammobox/shotgun/beanbags = 2,
					/obj/item/ammo_magazine/ammobox/pistol/rubber = 4,
					/obj/item/ammo_magazine/ammobox/magnum/rubber = 4,
					/obj/item/ammo_magazine/ammobox/clrifle_small/rubber = 4,
					/obj/item/device/hailer = 8,
					/obj/item/taperoll/police = 8,
					/obj/item/device/holowarrant = 8,
					/obj/item/storage/box/evidence = 2,
					/obj/item/computer_hardware/hard_drive/portable/design/security = 2,
					/obj/item/computer_hardware/hard_drive/portable/design/armor/ih = 2,
					/obj/item/computer_hardware/hard_drive/portable/design/armor/ih/bulletproof = 1,
					/obj/item/storage/ration_pack/ihr = 3)
	contraband = list(/obj/item/tool/knife/tacknife = 4,/obj/item/reagent_containers/food/snacks/donut/normal = 12)
	auto_price = FALSE

/obj/machinery/vending/theomat
	name = "NeoTheology Theo-Mat"
	desc = "A NeoTheology dispensary for disciples and new converts."
	product_slogans = "Immortality is the reward of the faithful.; Help humanity ascend, join your brethren today!; Come and seek a new life!"
	product_ads = "Praise!;Pray!;Obey!"
	icon_state = "teomat"
	vendor_department = DEPARTMENT_CHURCH
	products = list(/obj/item/book/ritual/cruciform = 10, /obj/item/storage/fancy/candle_box = 10, /obj/item/reagent_containers/food/drinks/bottle/ntcahors = 20)
	contraband = list(/obj/item/implant/core_implant/cruciform = 3)
	prices = list(/obj/item/book/ritual/cruciform = 500, /obj/item/storage/fancy/candle_box = 200, /obj/item/reagent_containers/food/drinks/bottle/ntcahors = 250,
				/obj/item/implant/core_implant/cruciform = 1000)
