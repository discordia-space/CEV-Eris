/obj/structure/closet/secure_closet/reinforced/engineering_chief
	name = "technomancer exultant's locker"
	req_access = list(access_ce)
	icon_state = "ce"

/obj/structure/closet/secure_closet/reinforced/engineering_chief/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/industrial(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/industrial(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/blueprints(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/exultant(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/hardhat/white(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/ce(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/mechanical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/te_coat(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/taperoll/engineering(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/engineering_supply(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/engineering_material(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet/technomancer_old(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_elec"

/obj/structure/closet/secure_closet/engineering_electrical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/electrical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/electrical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/electrical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/electronics/circuitboard/apc(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/electronics/circuitboard/apc(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/electronics/circuitboard/apc(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/multitool(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "eng"
	icon_door = "eng_weld"

/obj/structure/closet/secure_closet/engineering_welding/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/weldingtool(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/weldingtool(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/weldingtool(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/weldpack(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/weldpack(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/weldpack(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool_upgrade/augment/fuel_tank(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool_upgrade/augment/fuel_tank(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool_upgrade/augment/fuel_tank(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/engineering_personal
	name = "technomancer's locker"
	req_access = list(access_ce)
	access_occupy = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_secure"

/obj/structure/closet/secure_closet/personal/engineering_personal/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/industrial(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/industrial(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/taperoll/engineering(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/toolbox/mechanical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/engineer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/hardhat(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/welding(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/insulated(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_eng(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/hazardvest/orange(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/powered/meson(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet/technomancer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/insulated(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet/technomancer_old(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/technomancer_old(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/engineering_tools (NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
