/obj/structure/closet/secure_closet/medicine
	name = "medicine closet"
	desc = "Filled with medical junk."
	icon_state = "med"
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medicine/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/box/autoinjectors(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/syringes(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/dropper(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/dropper(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/beaker(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/beaker(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/inaprovaline(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/inaprovaline(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/antitoxin(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/antitoxin(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/anesthetics
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "med"
	req_access = list(access_moebius)

/obj/structure/closet/secure_closet/anesthetics/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/tank/anesthetic(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tank/anesthetic(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tank/anesthetic(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/breath/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/breath/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/breath/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/wrench(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/doctor
	name = "moebius doctor's locker"
	req_access = list(access_cmo)
	access_occupy = list(access_medical_equip)
	icon_state = "med"

/obj/structure/closet/secure_closet/personal/doctor/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/medical(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical/green(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/surgery/green(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex/nitrile(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_med(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/taperoll/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/emt(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/emt(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/surgical_apron(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/paramedic
	name = "moebius paramedic's locker"
	req_access = list(access_cmo)
	access_occupy = list(access_paramedic)
	icon_state = "med"

/obj/structure/closet/secure_closet/personal/paramedic/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/medical(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical/green(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/surgery/green(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/paramedic(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex/nitrile(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/lighting/toggleable/flashlight(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/crowbar(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/extinguisher/mini(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_med(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/taperoll/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/emt(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/hazardvest/black(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/medical_supply(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/CMO
	name = "moebius biolab officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/reinforced/CMO/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/medical(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/bio_suit(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/bio_hood(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex/nitrile(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical/green(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/surgery/green(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/moebius_biolab_officer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat/cmo(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown	(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/cmo(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/hypospray(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/medical_supply(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_surgery)
	icon_state = "sec"

/obj/structure/closet/secure_closet/animal/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/device/assembly/signaler(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/electropack(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/electropack(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/electropack(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "med"
	icon_door = "chemical"
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/box/pillbottles(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/pillbottles(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/tubular/vial(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
