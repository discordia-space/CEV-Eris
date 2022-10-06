/datum/design/organ
	category = "Standard"
	build_type = ORGAN_GROWER
	starts_unlocked = TRUE

/datum/design/organ/heart
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/heart

/datum/design/organ/lungs
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/lungs

/datum/design/organ/kidney_left
	materials = list()
	build_path = /obj/item/organ/internal/kidney/left

/datum/design/organ/kidney_right
	materials = list()
	build_path = /obj/item/organ/internal/kidney/right

/datum/design/organ/liver
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/liver

/datum/design/organ/stomach
	materials = list(MATERIAL_BIOMATTER = 10)
	build_path = /obj/item/organ/internal/stomach

/datum/design/organ/eyes
	materials = list(MATERIAL_BIOMATTER = 10)
	build_path = /obj/item/organ/internal/eyes

/datum/design/organ/nerves
	materials = list(MATERIAL_BIOMATTER = -10)
	build_path = /obj/item/organ/internal/nerve

/datum/design/organ/muscle
	build_path = /obj/item/organ/internal/muscle

/datum/design/organ/blood_vessel
	materials = list(MATERIAL_BIOMATTER = -10)
	build_path = /obj/item/organ/internal/blood_vessel

/datum/design/organ/back_alley
	category = "Back Alley"
	starts_unlocked = FALSE

/datum/design/organ/back_alley/ex_lungs
	name = "Extended Lungs"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/lungs/long

/datum/design/organ/back_alley/huge_heart
	name = "Huge Heart"
	materials = list(MATERIAL_BIOMATTER = 45)
	build_path = /obj/item/organ/internal/heart/huge

/datum/design/organ/back_alley/big_liver
	name = "Big Liver"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/liver/big

/datum/design/organ/back_alley/hyper_nerves
	name = "Hypersensitive Nerves"
	materials = list(MATERIAL_BIOMATTER = 15, MATERIAL_GOLD = 1)
	build_path = /obj/item/organ/internal/nerve/sensitive_nerve

/datum/design/organ/back_alley/super_muscle
	name = "Super Muscle"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/muscle/super_muscle

/datum/design/organ/back_alley/ex_blood_vessel
	name = "Extensive Blood Vessels"
	materials = list(MATERIAL_BIOMATTER = 30, MATERIAL_PLASTIC = 2)
	build_path = /obj/item/organ/internal/blood_vessel/extensive
