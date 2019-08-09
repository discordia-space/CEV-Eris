//Prosthesis ====================================

/datum/design/research/item/mechfab/prosthesis
	category = CAT_PROSTHESIS
	starts_unlocked = TRUE

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
	category = CAT_PROSTHESIS

/datum/design/research/item/mechfab/modules/armor
	name = "subdermal body armor"
	build_path = /obj/item/organ_module/armor

/datum/design/research/item/mechfab/modules/armblade
	name = "Embedded armblade"
	build_path = /obj/item/organ_module/active/simple/armblade

/datum/design/research/item/mechfab/modules/runner
	name = "Mechanical muscles"
	build_path = /obj/item/organ_module/muscle


/datum/design/research/item/mechfab/modules/multitool/surgical
	build_path = /obj/item/organ_module/active/multitool/surgical
	name = "Embedded surgical multitool"

/datum/design/research/item/mechfab/modules/multitool/engineer
	build_path = /obj/item/organ_module/active/multitool/engineer
	name = "Embedded Technomancer multitool"

/datum/design/research/item/mechfab/modules/multitool/miner
	build_path = /obj/item/organ_module/active/multitool/miner
	name = "Embedded mining multitool"


//Implants
/datum/design/research/item/implant
	build_type = PROTOLATHE | MECHFAB
	name_category = "implantable biocircuit"
	category = CAT_PROSTHESIS

/datum/design/research/item/implant/chemical
	name = "chemical"
	build_path = /obj/item/weapon/implantcase/chem
	sort_string = "MFAAA"

/datum/design/research/item/implant/freedom
	name = "freedom"
	build_path = /obj/item/weapon/implantcase/freedom
	sort_string = "MFAAB"
