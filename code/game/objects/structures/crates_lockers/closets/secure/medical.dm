/obj/structure/closet/secure_closet/medicine
	name = "medicine closet"
	desc = "Filled with medical junk."
	icon_state = "med"
	req_access = list(access_medical_equip)


/obj/structure/closet/secure_closet/medicine/populate_contents()
	..()
	new /obj/item/weapon/storage/box/autoinjectors(src)
	new /obj/item/weapon/storage/box/syringes(src)
	new /obj/item/weapon/reagent_containers/dropper(src)
	new /obj/item/weapon/reagent_containers/dropper(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)


/obj/structure/closet/secure_closet/anesthetics
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "med"
	req_access = list(access_medical)


/obj/structure/closet/secure_closet/anesthetics/populate_contents()
	..()
	new /obj/item/weapon/tank/anesthetic(src)
	new /obj/item/weapon/tank/anesthetic(src)
	new /obj/item/weapon/tank/anesthetic(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)


/obj/structure/closet/secure_closet/personal/doctor
	name = "moebius doctor's locker"
	req_access = list(access_cmo)
	access_occupy = list(access_medical_equip)
	icon_state = "med"

/obj/structure/closet/secure_closet/personal/doctor/populate_contents()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
			new /obj/item/clothing/head/surgery/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
			new /obj/item/clothing/head/surgery/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
			new /obj/item/clothing/head/surgery/purple(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
			new /obj/item/clothing/head/surgery/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
			new /obj/item/clothing/head/surgery/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
			new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/weapon/storage/belt/medical/emt(src)
	new /obj/item/weapon/storage/belt/medical/emt(src)
	new /obj/item/weapon/storage/belt/medical/(src)
	new /obj/item/weapon/storage/belt/medical/(src)
	new /obj/item/clothing/suit/storage/surgical_apron(src)


/obj/structure/closet/secure_closet/reinforced/CMO
	name = "moebius biolab officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/reinforced/CMO/populate_contents()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	new /obj/item/clothing/suit/bio_suit/cmo(src)
	new /obj/item/clothing/head/bio_hood/cmo(src)
	new /obj/item/clothing/shoes/color/white(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
			new /obj/item/clothing/head/surgery/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
			new /obj/item/clothing/head/surgery/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
			new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/under/rank/moebius_biolab_officer(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(src)
	new /obj/item/weapon/cartridge/cmo(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/shoes/color/brown	(src)
	new /obj/item/device/radio/headset/heads/cmo(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/reagent_containers/hypospray(src)


/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_surgery)
	icon_state = "sec"


/obj/structure/closet/secure_closet/animal/populate_contents()
	..()
	new /obj/item/device/assembly/signaler(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)



/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "med"
	icon_door = "chemical_door"
	req_access = list(access_chemistry)


/obj/structure/closet/secure_closet/chemical/populate_contents()
	..()
	new /obj/item/weapon/storage/box/pillbottles(src)
	new /obj/item/weapon/storage/box/pillbottles(src)
