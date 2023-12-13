/obj/structure/closet/secure_closet/medicine
	name = "medicine closet"
	desc = "Filled with medical junk."
	icon_state = "med"
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medicine/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/box/autoinjectors(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/syringes(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/dropper(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/dropper(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/beaker(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/beaker(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/inaprovaline(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/inaprovaline(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/antitoxin(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/glass/bottle/antitoxin(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/anesthetics
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "med"
	req_access = list(access_moebius)

/obj/structure/closet/secure_closet/anesthetics/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/tank/anesthetic(NULL))
	spawnedAtoms.Add(new  /obj/item/tank/anesthetic(NULL))
	spawnedAtoms.Add(new  /obj/item/tank/anesthetic(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/breath/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/breath/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/breath/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/wrench(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/doctor
	name = "moebius doctor's locker"
	req_access = list(access_cmo)
	access_occupy = list(access_medical_equip)
	icon_state = "med"

/obj/structure/closet/secure_closet/personal/doctor/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/medical(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical/green(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/surgery/green(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex/nitrile(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_med(NULL))
	spawnedAtoms.Add(new  /obj/item/taperoll/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/emt(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/emt(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/surgical_apron(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/paramedic
	name = "moebius paramedic's locker"
	req_access = list(access_cmo)
	access_occupy = list(access_paramedic)
	icon_state = "med"

/obj/structure/closet/secure_closet/personal/paramedic/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/medical(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical/green(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/surgery/green(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/paramedic(NULL))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex/nitrile(NULL))
	spawnedAtoms.Add(new  /obj/item/device/lighting/toggleable/flashlight(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/crowbar(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/extinguisher/mini(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_med(NULL))
	spawnedAtoms.Add(new  /obj/item/taperoll/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical/emt(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/hazardvest/black(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/medical_supply(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/CMO
	name = "moebius biolab officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/reinforced/CMO/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/medical(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/bio_suit(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/bio_hood(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex/nitrile(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medical/green(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/surgery/green(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/moebius_biolab_officer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat/cmo(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown	(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/cmo(NULL))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/hypospray(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/medical_supply(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_surgery)
	icon_state = "sec"

/obj/structure/closet/secure_closet/animal/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/device/assembly/signaler(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/electropack(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/electropack(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/electropack(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "med"
	icon_door = "chemical"
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/box/pillbottles(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/pillbottles(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/tubular/vial(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
