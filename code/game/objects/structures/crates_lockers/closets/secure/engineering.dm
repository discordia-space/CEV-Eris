/obj/structure/closet/secure_closet/reinforced/engineering_chief
	name = "technomancer exultant's locker"
	req_access = list(access_ce)
	icon_state = "ce"

/obj/structure/closet/secure_closet/reinforced/engineering_chief/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/industrial(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/industrial(NULL))
	spawnedAtoms.Add(new  /obj/item/blueprints(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/exultant(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/hardhat/white(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/ce(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/mechanical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/te_coat(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULL))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULL))
	spawnedAtoms.Add(new  /obj/item/taperoll/engineering(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/engineering_supply(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/engineering_material(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet/technomancer_old(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_elec"

/obj/structure/closet/secure_closet/engineering_electrical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/electrical(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/electrical(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/electrical(NULL))
	spawnedAtoms.Add(new  /obj/item/electronics/circuitboard/apc(NULL))
	spawnedAtoms.Add(new  /obj/item/electronics/circuitboard/apc(NULL))
	spawnedAtoms.Add(new  /obj/item/electronics/circuitboard/apc(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "eng"
	icon_door = "eng_weld"

/obj/structure/closet/secure_closet/engineering_welding/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/weldingtool(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/weldingtool(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/weldingtool(NULL))
	spawnedAtoms.Add(new  /obj/item/weldpack(NULL))
	spawnedAtoms.Add(new  /obj/item/weldpack(NULL))
	spawnedAtoms.Add(new  /obj/item/weldpack(NULL))
	spawnedAtoms.Add(new  /obj/item/tool_upgrade/augment/fuel_tank(NULL))
	spawnedAtoms.Add(new  /obj/item/tool_upgrade/augment/fuel_tank(NULL))
	spawnedAtoms.Add(new  /obj/item/tool_upgrade/augment/fuel_tank(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/personal/engineering_personal
	name = "technomancer's locker"
	req_access = list(access_ce)
	access_occupy = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_secure"

/obj/structure/closet/secure_closet/personal/engineering_personal/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/industrial(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/industrial(NULL))
	spawnedAtoms.Add(new  /obj/item/taperoll/engineering(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/mechanical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/engineer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/hardhat(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_eng(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/hazardvest/orange(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/powered/meson(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet/technomancer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/insulated(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet/technomancer_old(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/technomancer_old(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/engineering_tools (NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)
