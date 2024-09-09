// ORGAN GENERATION
#define ALL_STANDARD_ORGAN_EFFICIENCIES list(OP_HEART, OP_LUNGS, OP_LIVER, OP_KIDNEYS, OP_STOMACH, OP_BONE, OP_MUSCLE, OP_NERVE, OP_BLOOD_VESSEL)
#define SYMBIOTIC_ORGAN_EFFICIENCIES list(OP_LIVER, OP_STOMACH, OP_KIDNEYS, OP_BONE, OP_MUSCLE, OP_NERVE, OP_BLOOD_VESSEL)

#define ALL_ORGAN_STATS list(\
		OP_HEART		= list(100,   2,   0,   0,   10,  10,  list("he", "ar", "t"), list()),\
		OP_LUNGS		= list(100,   2,   50,	10,  10,  0,   list("l", "un", "gs"), list()),\
		OP_LIVER		= list(100,   1,   25,	5,   5,   7,   list("l", "iv", "er"), list()),\
		OP_KIDNEYS		= list(100,   2,   15,  3,   4,   5,   list("k", "idn", "ey"), list()),\
		OP_STOMACH		= list(100,   1,   25,	5,   0,   5,   list("st", "om", "ach"), list()),\
		OP_BONE			= list(100,   1,   0,	0,   0,   0,   list("b", "on", "e"), list()),\
		OP_MUSCLE		= list(100,   0.5, 2.5, 0.5, 0.5, 0,   list("m", "us", "cle"), list()),\
		OP_NERVE		= list(100,   0,   2.5, 0.5, 0.5, 0,   list("n", "er", "ve"), list()),\
		OP_BLOOD_VESSEL	= list(100,   0.5, 100, 0,   1,   2,   list("blood v", "ess", "el"), list())\
	)	//organ			= eff, size, max blood, blood req, nutriment req, oxygen req, name chunks, verbs


// INPUTS/OUTPUTS
#define VERY_LOW_OUTPUT 0.5
#define LOW_OUTPUT 2
#define MID_OUTPUT 5
#define HIGH_OUTPUT 10

#define DAMAGE_TYPES_BASIC list(BRUTE, BURN, OXY)

#define ALL_DAMAGE_TYPES list(BRUTE, BURN, OXY, HALLOSS, "brain", PSY)

#define ALL_USABLE_POWER_SOURCES list(/obj/item/cell/small, /obj/item/cell/medium, /obj/item/cell/large, /obj/item/stack/material/plasma, /obj/item/stack/material/uranium, /obj/item/stack/material/tritium)

#define STANDARD_ORGANIC_CONSUMABLES list(/obj/item/organ/internal, /obj/item/roach_egg, /obj/item/reagent_containers/food/snacks/roachcube, /obj/item/reagent_containers/food/snacks/grown,\
										/obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/monkeycube)

#define STANDARD_ORGANIC_PRODUCEABLES list(/obj/item/reagent_containers/food/snacks/egg, /obj/item/reagent_containers/food/snacks/meat, /obj/item/fleshcube)

#define ROACH_PRODUCEABLES list(/obj/item/roach_egg, /obj/item/reagent_containers/food/snacks/roachcube/kampfer, /obj/item/reagent_containers/food/snacks/roachcube/jager)

#define LIGHT_ANTAG_ORGANIC_PRODUCEABLES list(/obj/effect/decal/cleanable/carrion_puddle, /mob/living/carbon/superior_animal/roach/roachling, /obj/effect/decal/cleanable/solid_biomass,\
											/obj/item/reagent_containers/food/snacks/monkeycube)

#define TYPE_1_HORMONES list(/datum/reagent/hormone/bloodclot, /datum/reagent/hormone/bloodrestore, /datum/reagent/hormone/painkiller,\
						/datum/reagent/hormone/speedboost, /datum/reagent/hormone/antitox, /datum/reagent/hormone/oxygenation)

#define TYPE_2_HORMONES list(/datum/reagent/hormone/bloodclot/type_2, /datum/reagent/hormone/bloodrestore/type_2, /datum/reagent/hormone/painkiller/type_2,\
						/datum/reagent/hormone/speedboost/type_2, /datum/reagent/hormone/antitox/type_2, /datum/reagent/hormone/oxygenation/type_2)

#define TYPE_3_HORMONES list(/datum/reagent/hormone/bloodclot/type_3, /datum/reagent/hormone/bloodrestore/type_3, /datum/reagent/hormone/painkiller/type_3,\
						/datum/reagent/hormone/speedboost/type_3, /datum/reagent/hormone/antitox/type_3, /datum/reagent/hormone/oxygenation/type_3)

// Blacklist all reagents with no name or ones that cannot be produced
#define REAGENT_BLACKLIST list(/datum/reagent/organic, /datum/reagent/metal, /datum/reagent/drug,\
								/datum/reagent/other, /datum/reagent/nanites, /datum/reagent/medicine,\
								/datum/reagent/stim, /datum/reagent/adminordrazine, /datum/reagent/other/matter_deconstructor,\
								/datum/reagent/other/xenomicrobes)

#define REAGENTS_INDUSTRIAL list(/datum/reagent/acetone, /datum/reagent/metal/aluminum, /datum/reagent/toxin/ammonia,\
								/datum/reagent/metal/copper, /datum/reagent/ethanol, /datum/reagent/toxin/hydrazine,\
								/datum/reagent/metal/iron, /datum/reagent/acid, /datum/reagent/acid/hydrochloric,\
								/datum/reagent/silicon, /datum/reagent/metal/tungsten)

#define REAGENTS_DISPENSER_BASE list(/datum/reagent/acetone, /datum/reagent/metal/aluminum, /datum/reagent/toxin/ammonia, /datum/reagent/carbon, /datum/reagent/metal/copper,\
								/datum/reagent/ethanol, /datum/reagent/toxin/hydrazine, /datum/reagent/metal/iron, /datum/reagent/metal/lithium, /datum/reagent/metal/mercury,\
								/datum/reagent/phosphorus, /datum/reagent/metal/potassium, /datum/reagent/metal/radium, /datum/reagent/acid, /datum/reagent/acid/hydrochloric,\
								/datum/reagent/silicon, /datum/reagent/metal/sodium, /datum/reagent/organic/sugar, /datum/reagent/sulfur, /datum/reagent/metal/tungsten)

#define REAGENTS_DISPENSER_1 list(/datum/reagent/medicine/inaprovaline, /datum/reagent/medicine/dylovene, /datum/reagent/medicine/kelotane)

#define REAGENTS_DISPENSER_2 list(/datum/reagent/medicine/tricordrazine, /datum/reagent/medicine/spaceacillin, /datum/reagent/medicine/dermaline)

#define REAGENTS_DRUGS list(/datum/reagent/drug/space_drugs, /datum/reagent/drug/cryptobiolin, /datum/reagent/drug/mindbreaker, /datum/reagent/drug/nicotine)

#define REAGENTS_TOXIN list(/datum/reagent/toxin/amatoxin, /datum/reagent/toxin/plasma, /datum/reagent/toxin/fertilizer,\
							/datum/reagent/toxin/plantbgone, /datum/reagent/toxin/biomatter, /datum/reagent/toxin/lexorin,\
							/datum/reagent/medicine/soporific)

#define REAGENTS_ROACH list(/datum/reagent/toxin/diplopterum, /datum/reagent/toxin/seligitillin, /datum/reagent/toxin/starkellin,\
							/datum/reagent/toxin/gewaltine, /datum/reagent/toxin/blattedin)

#define REAGENTS_FUHRER list(/datum/reagent/toxin/diplopterum, /datum/reagent/toxin/seligitillin, /datum/reagent/toxin/starkellin,\
							/datum/reagent/toxin/gewaltine, /datum/reagent/toxin/blattedin, /datum/reagent/toxin/fuhrerole)

#define REAGENTS_KAISER list(/datum/reagent/toxin/diplopterum, /datum/reagent/toxin/seligitillin, /datum/reagent/toxin/starkellin,\
							/datum/reagent/toxin/gewaltine, /datum/reagent/toxin/blattedin, /datum/reagent/toxin/fuhrerole, /datum/reagent/toxin/kaiseraurum)

#define REAGENTS_SPIDER list(/datum/reagent/toxin/pararein, /datum/reagent/toxin/aranecolmin)

#define REAGENTS_FUNGAL list(/datum/reagent/toxin/amatoxin, /datum/reagent/toxin/mold, /datum/reagent/drug/psilocybin)

#define REAGENTS_METAL list(/datum/reagent/metal/aluminum, /datum/reagent/metal/copper, /datum/reagent/metal/iron, /datum/reagent/metal/lithium,\
							/datum/reagent/metal/mercury, /datum/reagent/metal/potassium, /datum/reagent/metal/radium, /datum/reagent/metal/sodium,\
							/datum/reagent/metal/tungsten, /datum/reagent/metal/gold, /datum/reagent/metal/silver, /datum/reagent/metal/uranium)

#define REAGENTS_EDIBLE list(/datum/reagent/organic/nutriment, /datum/reagent/organic/frostoil, /datum/reagent/organic/capsaicin, /datum/reagent/drink/milk,\
							/datum/reagent/other/lipozine, /datum/reagent/drink/limejuice, /datum/reagent/drink/orangejuice, /datum/reagent/drink/tomatojuice,\
							/datum/reagent/drink/tea, /datum/reagent/drink/tea/icetea)

#define REAGENTS_ALCOHOL list(/datum/reagent/alcohol/ale, /datum/reagent/alcohol/beer, /datum/reagent/alcohol/mead,\
							/datum/reagent/alcohol/gin, /datum/reagent/alcohol/rum, /datum/reagent/alcohol/tequilla, /datum/reagent/alcohol/vermouth,\
							/datum/reagent/alcohol/vodka, /datum/reagent/alcohol/whiskey, /datum/reagent/alcohol/wine, /datum/reagent/alcohol/cognac)

#define REAGENTS_SANTANA_COCKTAIL list(\
		/datum/reagent/alcohol/martini, /datum/reagent/alcohol/coffee/b52, /datum/reagent/alcohol/black_russian, /datum/reagent/alcohol/gintonic\
	)

#define REAGENTS_NANITES list(/datum/reagent/nanites/arad, /datum/reagent/nanites/implant_medics, /datum/reagent/nanites/nantidotes, /datum/reagent/nanites/nanosymbiotes,\
							/datum/reagent/nanites/oxyrush, /datum/reagent/nanites/trauma_control_system, /datum/reagent/nanites/purgers,\
							/datum/reagent/nanites/uncapped/control_booster_utility, /datum/reagent/nanites/uncapped/control_booster_combat,\
							/datum/reagent/nanites/uncapped/voice_mimic, /datum/reagent/nanites/uncapped/dynamic_handprints)

#define STANDARD_CHEM_SMOKE_MODES list("internal gas sac" = null)

#define ROACH_CHEM_SMOKE_MODES list("stomach" = CHEM_INGEST, "bloodstream" = CHEM_BLOOD, "internal gas sac" = null)


// MISCELLANEOUS
#define STANDARD_ABERRANT_COOLDOWN 10 SECONDS
#define MAINT_ABERRANT_COOLDOWN 30 SECONDS
#define EXTENDED_ABERRANT_COOLDOWN 1 MINUTE

#define NOT_USED 1

#define DISGORGER_RESEARCH_LIST list(\
	/datum/design/organ/teratoma/input/damage_basic,\
	/datum/design/organ/teratoma/special/stat_boost,\
	/datum/design/organ/teratoma/special/symbiotic_parasite,\
	/datum/design/organ/teratoma/process/cooldown/long,\
	/datum/design/organ/teratoma/process/multiplier/low,\
	/datum/design/organ/teratoma/output/chemical_effects_type_2,\
	/datum/design/organ/teratoma/output/reagents_blood_dispenser_base,\
	/datum/design/organ/teratoma/output/produce,\
	/datum/design/organ/teratoma/input/damage_all,\
	/datum/design/organ/teratoma/special/chemical_effects,\
	/datum/design/organ/teratoma/special/symbiotic_commensal,\
	/datum/design/organ/teratoma/process/cooldown,\
	/datum/design/organ/teratoma/process/multiplier,\
	/datum/design/organ/teratoma/output/reagents_blood_dispenser_one,\
	/datum/design/organ/teratoma/output/stat_boost,\
	/datum/design/organ/teratoma/special/symbiotic_mutual,\
	/datum/design/organ/scaffold/large,\
	/datum/design/organ/teratoma/process/cooldown/negative,\
	/datum/design/organ/teratoma/process/multiplier/negative_low,\
	/datum/design/organ/teratoma/process/multiplier/negative,\
	/datum/design/organ/teratoma/process/multiplier/high,\
	/datum/design/organ/teratoma/output/reagents_blood_dispenser_two,\
	/datum/design/organ/teratoma/input/power_source\
	)

// Move to DEFINES -> items.dm when merged with item_upgrades

#define ATOM_NAME "atom_name"
#define ATOM_PREFIX "atom_prefix"
#define ATOM_DESC "atom_desc"
#define ATOM_COLOR "atom_color"

// Items

#define ITEM_VERB_NAME "item_verb_name"
#define ITEM_VERB_PROC "item_verb_proc"
#define ITEM_VERB_HANDS_FREE "item_verb_hands_free"
#define ITEM_VERB_ARGS "item_verb_args"

// Organs

#define ORGAN_NATURE "organ_nature"
#define ORGAN_SCANNER_HIDDEN "organ_scanner_hidden"
#define ORGAN_OWNER_VERB "organ_owner_verb"
#define ORGAN_BLOOD_TYPE "organ_blood_type"

// Additive adjustments, affected by multiplicative adjustments
#define ORGAN_EFFICIENCY_NEW_BASE "organ_efficiency_new_base"
#define ORGAN_SPECIFIC_SIZE_BASE "organ_specific_size_base"
#define ORGAN_MAX_BLOOD_STORAGE_BASE "organ_max_blood_storage_base"
#define ORGAN_BLOOD_REQ_BASE "organ_blood_req_base"
#define ORGAN_NUTRIMENT_REQ_BASE "organ_nutriment_req_base"
#define ORGAN_OXYGEN_REQ_BASE "organ_oxygen_req_base"
#define ORGAN_MIN_BRUISED_DAMAGE_BASE "organ_min_bruised_damage_base"
#define ORGAN_MIN_BROKEN_DAMAGE_BASE "organ_min_broken_damage_base"
#define ORGAN_MAX_DAMAGE_BASE "organ_max_damage_base"

// Multiplicative adjustments
#define ORGAN_EFFICIENCY_MULT "organ_efficiency_mult"
#define ORGAN_SPECIFIC_SIZE_MULT "organ_specific_size_mult"
#define ORGAN_MAX_BLOOD_STORAGE_MULT "organ_max_blood_storage_mult"
#define ORGAN_BLOOD_REQ_MULT "organ_blood_req_mult"
#define ORGAN_NUTRIMENT_REQ_MULT "organ_nutriment_req_mult"
#define ORGAN_OXYGEN_REQ_MULT "organ_oxygen_req_mult"
#define ORGAN_MIN_BRUISED_DAMAGE_MULT "organ_min_bruised_damage_mult"
#define ORGAN_MIN_BROKEN_DAMAGE_MULT "organ_min_broken_damage_mult"
#define ORGAN_MAX_DAMAGE_MULT "organ_max_damage_mult"

// Additive adjustments, NOT affected by multiplicative adjustments
#define ORGAN_EFFICIENCY_NEW_MOD "organ_efficiency_new_mod"
#define ORGAN_SPECIFIC_SIZE_MOD "organ_specific_size_mod"
#define ORGAN_MAX_BLOOD_STORAGE_MOD "organ_max_blood_storage_mod"
#define ORGAN_BLOOD_REQ_MOD "organ_blood_req_mod"
#define ORGAN_NUTRIMENT_REQ_MOD "organ_nutriment_req_mod"
#define ORGAN_OXYGEN_REQ_MOD "organ_oxygen_req_mod"
#define ORGAN_MIN_BRUISED_DAMAGE_MOD "organ_min_bruised_damage_mod"
#define ORGAN_MIN_BROKEN_DAMAGE_MOD "organ_min_broken_damage_mod"
#define ORGAN_MAX_DAMAGE_MOD "organ_max_damage_mod"

// Aberrant organs

#define ORGAN_ABERRANT_COOLDOWN "organ_aberrant_cooldown"

#define ORGAN_ABERRANT_PROCESS_MULT "organ_aberrant_process_mult"
