//Prosthesis ====================================

/datum/design/research/item/mechfab/prosthesis
	category = "Prosthesis"

/datum/design/research/item/mechfab/prosthesis/r_arm
	name = "right arm"
	build_path = /obj/item/prosthesis/r_arm

/datum/design/research/item/mechfab/prosthesis/l_arm
	name = "left arm"
	build_path = /obj/item/prosthesis/l_arm

/datum/design/research/item/mechfab/prosthesis/r_leg
	name = "right leg"
	build_path = /obj/item/prosthesis/r_leg

/datum/design/research/item/mechfab/prosthesis/l_leg
	name = "left leg"
	build_path = /obj/item/prosthesis/l_leg


//Modules ====================================

/datum/design/research/item/mechfab/modules
	category = "Prosthesis"
	req_tech = list(TECH_BIO = 3)

/datum/design/research/item/mechfab/modules/armor
	name = "subdermal body armor"
	build_path = /obj/item/organ_module/armor
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3)

/datum/design/research/item/mechfab/modules/armblade
	name = "Embedded armblade"
	build_path = /obj/item/organ_module/active/simple/armblade
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3)

/datum/design/research/item/mechfab/modules/runner
	name = "Mechanical muscles"
	build_path = /obj/item/organ_module/muscle
	req_tech = list(TECH_BIO = 4)


/datum/design/research/item/mechfab/modules/multitool/surgical
	build_path = /obj/item/organ_module/active/multitool/surgical
	name = "Embedded surgical multitool"
	req_tech = list(TECH_BIO = 4)

/datum/design/research/item/mechfab/modules/multitool/engineer
	build_path = /obj/item/organ_module/active/multitool/engineer
	name = "Embedded Technomancer multitool"
	req_tech = list(TECH_BIO = 3, TECH_ENGINEERING = 3)

/datum/design/research/item/mechfab/modules/multitool/miner
	build_path = /obj/item/organ_module/active/multitool/miner
	name = "Embedded mining multitool"
	req_tech = list(TECH_BIO = 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 4)


//Implants
/datum/design/research/item/implant
	build_type = PROTOLATHE | MECHFAB
	name_category = "implantable biocircuit"
	category = "Prosthesis"

/datum/design/research/item/implant/chemical
	name = "chemical"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/chem
	sort_string = "MFAAA"

/datum/design/research/item/implant/freedom
	name = "freedom"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/freedom
	sort_string = "MFAAB"
