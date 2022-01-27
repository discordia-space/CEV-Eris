/obj/structure/closet/secure_closet/medicine
	name = "medicine closet"
	desc = "Filled with69edical junk."
	icon_state = "med"
	re69_access = list(access_medical_e69uip)

/obj/structure/closet/secure_closet/medicine/populate_contents()
	new /obj/item/stora69e/box/autoinjectors(src)
	new /obj/item/stora69e/box/syrin69es(src)
	new /obj/item/rea69ent_containers/dropper(src)
	new /obj/item/rea69ent_containers/dropper(src)
	new /obj/item/rea69ent_containers/69lass/beaker(src)
	new /obj/item/rea69ent_containers/69lass/beaker(src)
	new /obj/item/rea69ent_containers/69lass/bottle/inaprovaline(src)
	new /obj/item/rea69ent_containers/69lass/bottle/inaprovaline(src)
	new /obj/item/rea69ent_containers/69lass/bottle/antitoxin(src)
	new /obj/item/rea69ent_containers/69lass/bottle/antitoxin(src)

/obj/structure/closet/secure_closet/anesthetics
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "med"
	re69_access = list(access_moebius)

/obj/structure/closet/secure_closet/anesthetics/populate_contents()
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/clothin69/mask/breath/medical(src)
	new /obj/item/clothin69/mask/breath/medical(src)
	new /obj/item/clothin69/mask/breath/medical(src)
	new /obj/item/tool/wrench(src)

/obj/structure/closet/secure_closet/personal/doctor
	name = "moebius doctor's locker"
	re69_access = list(access_cmo)
	access_occupy = list(access_medical_e69uip)
	icon_state = "med"

/obj/structure/closet/secure_closet/personal/doctor/populate_contents()
	if(prob(50))
		new /obj/item/stora69e/backpack/medical(src)
	else
		new /obj/item/stora69e/backpack/satchel/medical(src)
	new /obj/item/clothin69/under/rank/medical/69reen(src)
	new /obj/item/clothin69/head/sur69ery/69reen(src)
	new /obj/item/clothin69/under/rank/medical(src)
	new /obj/item/clothin69/suit/stora69e/to6969le/labcoat(src)
	new /obj/item/clothin69/69loves/latex/nitrile(src)
	new /obj/item/clothin69/shoes/color/white(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/clothin69/shoes/reinforced/medical(src)
	new /obj/item/clothin69/head/soft/medical(src)
	new /obj/item/stora69e/belt/medical/emt(src)
	new /obj/item/stora69e/belt/medical/emt(src)
	new /obj/item/stora69e/belt/medical/(src)
	new /obj/item/stora69e/belt/medical/(src)
	new /obj/item/clothin69/suit/stora69e/sur69ical_apron(src)

/obj/structure/closet/secure_closet/personal/paramedic
	name = "moebius paramedic's locker"
	re69_access = list(access_cmo)
	access_occupy = list(access_paramedic)
	icon_state = "med"

/obj/structure/closet/secure_closet/personal/paramedic/populate_contents()
	if(prob(50))
		new /obj/item/stora69e/backpack/medical(src)
	else
		new /obj/item/stora69e/backpack/satchel/medical(src)
	new /obj/item/clothin69/under/rank/medical/69reen(src)
	new /obj/item/clothin69/head/sur69ery/69reen(src)
	new /obj/item/clothin69/under/rank/paramedic(src)
	new /obj/item/device/flash(src)
	new /obj/item/clothin69/69loves/latex/nitrile(src)
	new /obj/item/device/li69htin69/to6969leable/flashli69ht(src)
	new /obj/item/device/radio(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/clothin69/shoes/reinforced/medical(src)
	new /obj/item/clothin69/head/soft/medical(src)
	new /obj/item/extin69uisher/mini(src)
	new /obj/item/clothin69/shoes/reinforced(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/stora69e/belt/medical/emt(src)
	new /obj/item/clothin69/suit/stora69e/hazardvest/black(src)
	new /obj/item/stora69e/pouch/medical_supply(src)

/obj/structure/closet/secure_closet/reinforced/CMO
	name = "moebius biolab officer's locker"
	re69_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/reinforced/CMO/populate_contents()
	if(prob(50))
		new /obj/item/stora69e/backpack/medical(src)
	else
		new /obj/item/stora69e/backpack/satchel(src)
	new /obj/item/clothin69/suit/bio_suit(src)
	new /obj/item/clothin69/head/bio_hood(src)
	new /obj/item/clothin69/shoes/color/white(src)
	new /obj/item/clothin69/shoes/reinforced/medical(src)
	new /obj/item/clothin69/69loves/latex/nitrile(src)
	new /obj/item/clothin69/under/rank/medical/69reen(src)
	new /obj/item/clothin69/head/sur69ery/69reen(src)
	new /obj/item/clothin69/under/rank/moebius_biolab_officer(src)
	new /obj/item/clothin69/suit/stora69e/to6969le/labcoat/cmo(src)
	new /obj/item/clothin69/69loves/latex(src)
	new /obj/item/clothin69/shoes/color/brown	(src)
	new /obj/item/device/radio/headset/heads/cmo(src)
	new /obj/item/device/flash(src)
	new /obj/item/rea69ent_containers/hypospray(src)
	new /obj/item/stora69e/belt/medical(src)
	new /obj/item/stora69e/pouch/medical_supply(src)

/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	re69_access = list(access_sur69ery)
	icon_state = "sec"

/obj/structure/closet/secure_closet/animal/populate_contents()
	new /obj/item/device/assembly/si69naler(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dan69erous chemicals in here."
	icon_state = "med"
	icon_door = "chemical"
	re69_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical/populate_contents()
	new /obj/item/stora69e/box/pillbottles(src)
	new /obj/item/stora69e/box/pillbottles(src)
	new /obj/item/stora69e/pouch/tubular/vial(src)
