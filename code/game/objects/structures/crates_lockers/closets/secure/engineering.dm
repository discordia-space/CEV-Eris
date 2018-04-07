/obj/structure/closet/secure_closet/reinforced/engineering_chief
	name = "technomancer exultant's locker"
	req_access = list(access_ce)
	icon_state = "ce"

/obj/structure/closet/secure_closet/reinforced/engineering_chief/populate_contents()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	new /obj/item/blueprints(src)
	new /obj/item/clothing/under/rank/exultant(src)
	new /obj/item/clothing/head/hardhat/white(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/gloves/insulated(src)
	new /obj/item/clothing/shoes/color/brown(src)
	new /obj/item/weapon/cartridge/ce(src)
	new /obj/item/device/radio/headset/heads/ce(src)
	new /obj/item/weapon/storage/toolbox/mechanical(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tool/multitool(src)
	new /obj/item/device/flash(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/weapon/hatton(src)
	new /obj/item/weapon/hatton_magazine(src)
	new /obj/item/weapon/hatton_magazine(src)
	new /obj/item/weapon/hatton_magazine(src)


/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_elec"

/obj/structure/closet/secure_closet/engineering_electrical/populate_contents()
	..()
	new /obj/item/clothing/gloves/insulated(src)
	new /obj/item/clothing/gloves/insulated(src)
	new /obj/item/weapon/storage/toolbox/electrical(src)
	new /obj/item/weapon/storage/toolbox/electrical(src)
	new /obj/item/weapon/storage/toolbox/electrical(src)
	new /obj/item/weapon/circuitboard/apc(src)
	new /obj/item/weapon/circuitboard/apc(src)
	new /obj/item/weapon/circuitboard/apc(src)
	new /obj/item/weapon/tool/multitool(src)
	new /obj/item/weapon/tool/multitool(src)
	new /obj/item/weapon/tool/multitool(src)


/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "eng"
	icon_door = "eng_weld"

/obj/structure/closet/secure_closet/engineering_welding/populate_contents()
	..()
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/weapon/tool/weldingtool(src)
	new /obj/item/weapon/tool/weldingtool(src)
	new /obj/item/weapon/tool/weldingtool(src)
	new /obj/item/weapon/weldpack(src)
	new /obj/item/weapon/weldpack(src)
	new /obj/item/weapon/weldpack(src)
	new /obj/item/weapon/weldpack/canister(src)
	new /obj/item/weapon/weldpack/canister(src)
	new /obj/item/weapon/weldpack/canister(src)
	new /obj/item/weapon/weldpack/canister(src)
	new /obj/item/weapon/weldpack/canister(src)
	new /obj/item/weapon/weldpack/canister(src)


/obj/structure/closet/secure_closet/personal/engineering_personal
	name = "technomancer's locker"
	req_access = list(access_ce)
	access_occupy = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_secure"

/obj/structure/closet/secure_closet/personal/engineering_personal/populate_contents()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	new /obj/item/weapon/storage/toolbox/mechanical(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/gloves/insulated(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/weapon/cartridge/engineering(src)
	new /obj/item/taperoll/engineering(src)
