/datum/component/internal_wound/organic
	diagnosis_stat = STAT_BIO
	diagnosis_difficulty = STAT_LEVEL_ADEPT
	wound_nature = MODIFICATION_ORGANIC

// Blunt
/datum/component/internal_wound/organic/blunt	// Abstract
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BLOODCLOT = 0.55)	// Tricordrazine/polystem + bicaridine + meralyne OR quickclot OD + any brute heal
	severity = 0
	severity_max = 5
	hal_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/organic/blunt/rupture
	name = "rupture"

/datum/component/internal_wound/organic/blunt/hemorrhage
	name = "internal hemorrhage"

/datum/component/internal_wound/organic/blunt/contusion
	name = "contusion"

/*
/datum/component/internal_wound/organic/blunt/bruising
	name = "severe bruising"

/datum/component/internal_wound/organic/blunt/trauma
	name = "blunt trauma"
*/

// Sharp
/datum/component/internal_wound/organic/sharp
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BLOODCLOT = 0.85)	// Brute heal chem mix + quickclot OD
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/organic/sharp/perforation
	name = "perforation"

/datum/component/internal_wound/organic/sharp/cavity
	name = "cavitation"

/datum/component/internal_wound/organic/sharp/gore
	name = "gored tissue"

/*
/datum/component/internal_wound/organic/sharp/puncture
	name = "puncture"

/datum/component/internal_wound/organic/sharp/trauma
	name = "penetrating trauma"
*/

// Edge
/datum/component/internal_wound/organic/edge
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 2)
	treatments_tool = list(QUALITY_CAUTERIZING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_BLOODCLOT = 0.85)	// Brute heal chem mix + quickclot OD
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/swelling
	hal_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/organic/edge/laceration
	name = "laceration"

/datum/component/internal_wound/organic/edge/gash
	name = "deep gash"

/datum/component/internal_wound/organic/edge/rip
	name = "ripped tissue"

/*
/datum/component/internal_wound/organic/edge/tear
	name = "torn tissue"

/datum/component/internal_wound/organic/edge/cut
	name = "leaking cut"
*/

// Burn
/datum/component/internal_wound/organic/burn
	treatments_item = list(/obj/item/stack/medical/advanced/ointment = 2)
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_STABLE = 1)	// Inaprov will only keep it from killing you
	scar = /datum/component/internal_wound/organic/necrosis_start
	severity = 0
	severity_max = 5
	next_wound = /datum/component/internal_wound/organic/infection
	hal_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/organic/burn/scorch
	name = "scorched tissue"

/datum/component/internal_wound/organic/burn/char
	name = "charred tissue"

/datum/component/internal_wound/organic/burn/incinerate
	name = "incinerated flesh"

/*
/datum/component/internal_wound/organic/burn/sear
	name = "seared flesh"

/datum/component/internal_wound/organic/burn/burnt
	name = "burnt tissue"
*/

/datum/component/internal_wound/organic/necrosis_start
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	severity = 0
	severity_max = 1
	next_wound = /datum/component/internal_wound/organic/necrosis

/datum/component/internal_wound/organic/necrosis_start/damaged_tissue
	name = "damaged tissue"

/datum/component/internal_wound/organic/necrosis
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_STABLE = 1)	// Inaprov will only keep it from killing you
	scar = /datum/component/internal_wound/organic/necrosis_start
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/organic/infection
	hal_damage = IWOUND_LIGHT_DAMAGE

/datum/component/internal_wound/organic/necrosis/dying
	name = "necrotizing tissue"

// Tox (toxins)
/datum/component/internal_wound/organic/poisoning
	treatments_item = list(/obj/item/stack/medical/advanced/bruise_pack = 1)
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_ANTITOX = 2)
	severity = 0
	severity_max = 4
	hal_damage = IWOUND_LIGHT_DAMAGE

/// Cheap hack, but prevents unbalanced toxins from killing someone immediately
/datum/component/internal_wound/organic/poisoning/InheritComponent()
	if(prob(5))
		progress()

/datum/component/internal_wound/organic/poisoning/pustule
	name = "pustule"
	specific_organ_size_multiplier = 0.20

/datum/component/internal_wound/organic/poisoning/poisoning
	name = "minor poisoning"
	blood_req_multiplier = 0.25
	nutriment_req_multiplier = 0.25
	oxygen_req_multiplier = 0.25

/datum/component/internal_wound/organic/poisoning/accumulation
	name = "foreign accumulation"
	hal_damage = IWOUND_MEDIUM_DAMAGE

/*
/datum/component/internal_wound/organic/poisoning/swelling
	name = "light swelling"
*/

// Tox (OD/atmos)
/datum/component/internal_wound/organic/heavy_poisoning
	treatments_chem = list(CE_PURGER = 3)	// No anti-tox cure, poisoning can occur as a result of too much anti-tox
	severity = 0
	severity_max = IORGAN_MAX_HEALTH / 2
	hal_damage = IWOUND_MEDIUM_DAMAGE
	specific_organ_size_multiplier = 0.50
	blood_req_multiplier = 0.50
	nutriment_req_multiplier = 0.50
	oxygen_req_multiplier = 0.50

/datum/component/internal_wound/organic/heavy_poisoning/toxin
	name = "toxin accumulation"

/datum/component/internal_wound/organic/heavy_poisoning/chem
	name = "chemical poisoning"

// Clone/radiation
// There are a lot of dummy wounds that exist for cosmetic purposes
/datum/component/internal_wound/organic/radiation
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_ONCOCIDAL = 1)
	characteristic_flag = IWOUND_PROGRESS	// Does not apply any damage to the parent organ
	severity = 0
	severity_max = 2
	next_wound = /datum/component/internal_wound/organic/debuff_tumor
	hal_damage = 0

/datum/component/internal_wound/organic/radiation/abnormal
	name = "abnormal growth"

/datum/component/internal_wound/organic/radiation/strange
	name = "strange growth"

/datum/component/internal_wound/organic/radiation/polyp
	name = "polyp"

/datum/component/internal_wound/organic/radiation/polyp_abnormal
	name = "abnormal polyp"

/datum/component/internal_wound/organic/radiation/polyp_strange
	name = "strange polyp"

/datum/component/internal_wound/organic/radiation/neoplasm
	name = "neoplasm"

/datum/component/internal_wound/organic/radiation/neoplasm_abnormal
	name = "abnormal neoplasm"

/datum/component/internal_wound/organic/radiation/malignant
	name = "malignant neoplasm"
	treatments_chem = list(CE_ONCOCIDAL = 2)
	next_wound = /datum/component/internal_wound/organic/tumor

/datum/component/internal_wound/organic/radiation/metaplasm
	name = "metaplasm"
	next_wound = /datum/component/internal_wound/organic/parenchyma

// Secondary wounds
/datum/component/internal_wound/organic/swelling
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_ANTIBIOTIC = 5) // Spaceacillin
	severity = 0
	severity_max = 3
	next_wound = /datum/component/internal_wound/organic/infection
	hal_damage = IWOUND_LIGHT_DAMAGE
	specific_organ_size_multiplier = 0.2

/datum/component/internal_wound/organic/swelling/normal
	name = "swelling"

/datum/component/internal_wound/organic/swelling/abcess
	name = "abcess"

/datum/component/internal_wound/organic/tumor
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_ONCOCIDAL = 2)
	characteristic_flag = IWOUND_CAN_DAMAGE|IWOUND_PROGRESS|IWOUND_SPREAD
	severity = 0
	severity_max = IORGAN_MAX_HEALTH	// Will kill any organ
	spread_threshold = IORGAN_SMALL_HEALTH	// This will spread at the same moment it kills a small organ
	status_flag = ORGAN_WOUNDED|ORGAN_MUTATED

/datum/component/internal_wound/organic/tumor/malignant
	name = "malignant tumor"

/datum/component/internal_wound/organic/debuff_tumor
	treatments_tool = list(QUALITY_CUTTING = FAILCHANCE_NORMAL)
	treatments_chem = list(CE_ONCOCIDAL = 2)
	severity = 0
	severity_max = 1
	organ_efficiency_multiplier = -0.10

/datum/component/internal_wound/organic/debuff_tumor
	name = "tumor"

/datum/component/internal_wound/organic/debuff_tumor_15
	name = "tumor"
	organ_efficiency_multiplier = -0.15

/datum/component/internal_wound/organic/debuff_tumor_5
	name = "tumor"
	organ_efficiency_multiplier = -0.05

/datum/component/internal_wound/organic/parenchyma
	treatments_tool = list(QUALITY_LASER_CUTTING = FAILCHANCE_NORMAL)	// Players may not want to remove this
	characteristic_flag = null
	severity = 0
	severity_max = 0
	status_flag = null

/datum/component/internal_wound/organic/parenchyma/RegisterWithParent()
	. = ..()
	var/obj/item/organ/O = parent

	if(O.owner)
		O.owner.mutation_index++

/datum/component/internal_wound/organic/parenchyma/UnregisterFromParent()
	. = ..()
	var/obj/item/organ/O = parent
	
	if(O.owner)
		O.owner.mutation_index--
	
/datum/component/internal_wound/organic/parenchyma/heart
	name = "heart parenchyma"
	organ_efficiency_mod = list(OP_HEART = 10)

/datum/component/internal_wound/organic/parenchyma/lungs
	name = "lung parenchyma"
	organ_efficiency_mod = list(OP_LUNGS = 10)

/datum/component/internal_wound/organic/parenchyma/liver
	name = "liver parenchyma"
	organ_efficiency_mod = list(OP_LIVER = 10)

/datum/component/internal_wound/organic/parenchyma/kidney
	name = "kidney parenchyma"
	organ_efficiency_mod = list(OP_KIDNEYS = 10)

/datum/component/internal_wound/organic/parenchyma/stomach
	name = "stomach parenchyma"
	organ_efficiency_mod = list(OP_STOMACH = 10)

/datum/component/internal_wound/organic/parenchyma/blood_vessel
	name = "blood vessel parenchyma"
	organ_efficiency_mod = list(OP_BLOOD_VESSEL = 10)

/datum/component/internal_wound/organic/parenchyma/nerve
	name = "nerve parenchyma"
	organ_efficiency_mod = list(OP_NERVE = 10)

/datum/component/internal_wound/organic/parenchyma/muscle
	name = "muscle parenchyma"
	organ_efficiency_mod = list(OP_MUSCLE = 10)

// Other wounds
/datum/component/internal_wound/organic/oxy
	treatments_chem = list(CE_OXYGENATED = 2, CE_BLOODRESTORE = 1)	// Dex+ treats, but it will come back if you don't get blood
	severity = 0
	severity_max = IORGAN_MAX_HEALTH
	progression_threshold = IWOUND_1_MINUTE	// Kills small organs in 7 minutes, normal in 14

/datum/component/internal_wound/organic/oxy/blood_loss
	name = "blood loss"

// Infection 2.0. This will spread to other organs in your body if untreated. Progresses until death.
/datum/component/internal_wound/organic/infection
	treatments_chem = list(CE_ANTIBIOTIC = 5)
	characteristic_flag = IWOUND_CAN_DAMAGE|IWOUND_PROGRESS|IWOUND_PROGRESS_DEATH|IWOUND_SPREAD
	severity = 0
	severity_max = IORGAN_MAX_HEALTH
	hal_damage = IWOUND_LIGHT_DAMAGE
	spread_threshold = IORGAN_SMALL_HEALTH
	status_flag = ORGAN_WOUNDED|ORGAN_INFECTED

/datum/component/internal_wound/organic/infection/standard
	name = "infection"

/datum/component/internal_wound/organic/permanent
	name = "scar tissue"
	treatments_item = list()	// No way to treat without an autodoc
	treatments_tool = list()
	treatments_chem = list()
	characteristic_flag = IWOUND_CAN_DAMAGE
	severity = 2
	severity_max = 2
	hal_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/organic/permanent/nopain
	hal_damage = 0
