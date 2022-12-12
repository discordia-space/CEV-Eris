#define VERY_LOW_OUTPUT 0.5
#define LOW_OUTPUT 2
#define MID_OUTPUT 5
#define HIGH_OUTPUT 10

#define STANDARD_ABERRANT_COOLDOWN 10 SECONDS
#define DEPENDENT_ABERRANT_COOLDOWN 1 MINUTE

#define NOT_USED 1

#define ALL_STANDARD_ORGAN_EFFICIENCIES list(OP_HEART, OP_LUNGS, OP_LIVER, OP_KIDNEYS, OP_APPENDIX, OP_STOMACH, OP_BONE, OP_MUSCLE, OP_NERVE, OP_BLOOD_VESSEL) // OP_EYES, causes runtimes and not particularly useful

#define ALL_ORGAN_STATS list(\
		OP_HEART		= list(100,   2,   0,   0,   10,  10,  list("he", "ar", "t"), list()),\
		OP_LUNGS		= list(100,   2,   50,	10,  10,  0,   list("l", "un", "gs"), list()),\
		OP_LIVER		= list(100,   1,   25,	5,   5,   7,   list("l", "iv", "er"), list()),\
		OP_KIDNEYS		= list(100,   2,   15,  3,   4,   5,   list("k", "idn", "ey"), list()),\
		OP_APPENDIX		= list(100,   0,   0,	0,   0,   0,   list("app", "end", "ix"), list()),\
		OP_STOMACH		= list(100,   1,   25,	5,   0,   5,   list("st", "om", "ach"), list()),\
		OP_BONE			= list(100,   1,   0,	0,   0,   0,   list("b", "on", "e"), list()),\
		OP_MUSCLE		= list(100,   0.5, 2.5, 0.5, 0.5, 0,   list("m", "us", "cle"), list()),\
		OP_NERVE		= list(100,   0,   2.5, 0.5, 0.5, 0,   list("n", "er", "ve"), list()),\
		OP_BLOOD_VESSEL	= list(100,   0.5, 100, 0,   1,   2,   list("blood v", "ess", "el"), list())\
	)	//organ			= eff, size, max blood, blood req, nutriment req, oxygen req, name chunks, verbs

#define DAMAGE_TYPES_BASIC list(BRUTE, BURN, TOX, OXY)

#define ALL_DAMAGE_TYPES list(BRUTE, BURN, TOX, OXY, CLONE, HALLOSS, "brain", PSY)

#define ALL_USABLE_POWER_SOURCES list(/obj/item/cell/small, /obj/item/cell/medium, /obj/item/cell/large, /obj/item/stack/material/plasma, /obj/item/stack/material/uranium, /obj/item/stack/material/tritium)

#define TYPE_1_HORMONES list(/datum/reagent/hormone/bloodclot, /datum/reagent/hormone/bloodrestore, /datum/reagent/hormone/painkiller,\
						/datum/reagent/hormone/speedboost, /datum/reagent/hormone/antitox, /datum/reagent/hormone/oxygenation)

#define TYPE_2_HORMONES list(/datum/reagent/hormone/bloodclot/alt, /datum/reagent/hormone/bloodrestore/alt, /datum/reagent/hormone/painkiller/alt,\
						/datum/reagent/hormone/speedboost/alt, /datum/reagent/hormone/antitox/alt, /datum/reagent/hormone/oxygenation/alt)

// Blacklist all reagents with no name or ones that cannot be produced
#define REAGENT_BLACKLIST list(/datum/reagent/organic, /datum/reagent/metal, /datum/reagent/drug,\
								/datum/reagent/other, /datum/reagent/nanites, /datum/reagent/medicine,\
								/datum/reagent/stim, /datum/reagent/adminordrazine, /datum/reagent/other/matter_deconstructor,\
								/datum/reagent/other/xenomicrobes)

#define REAGENTS_DISPENSER list(/datum/reagent/acetone, /datum/reagent/metal/aluminum, /datum/reagent/toxin/ammonia, /datum/reagent/carbon, /datum/reagent/metal/copper,\
								/datum/reagent/ethanol, /datum/reagent/toxin/hydrazine, /datum/reagent/metal/iron, /datum/reagent/metal/lithium, /datum/reagent/metal/mercury,\
								/datum/reagent/phosphorus, /datum/reagent/metal/potassium, /datum/reagent/metal/radium, /datum/reagent/acid, /datum/reagent/acid/hydrochloric,\
								/datum/reagent/silicon, /datum/reagent/metal/sodium, /datum/reagent/organic/sugar, /datum/reagent/sulfur, /datum/reagent/metal/tungsten)

#define REAGENTS_MEDICINE_BASIC list(/datum/reagent/medicine/inaprovaline, /datum/reagent/medicine/dexalin, /datum/reagent/medicine/hyronalin,\
										/datum/reagent/medicine/alkysine, /datum/reagent/medicine/imidazoline)

#define REAGENTS_MEDICINE_SIMPLE list(/datum/reagent/medicine/kelotane, /datum/reagent/medicine/tricordrazine, /datum/reagent/medicine/dylovene, /datum/reagent/medicine/polystem,\
									/datum/reagent/medicine/inaprovaline, /datum/reagent/medicine/dexalin, /datum/reagent/medicine/hyronalin, /datum/reagent/medicine/alkysine,\
									/datum/reagent/medicine/imidazoline)

#define REAGENTS_MEDICINE_INTERMEDIATE list(/datum/reagent/medicine/bicaridine, /datum/reagent/medicine/synaptizine, /datum/reagent/drug/hyperzine, /datum/reagent/medicine/tramadol,\
										/datum/reagent/medicine/kelotane, /datum/reagent/medicine/tricordrazine, /datum/reagent/medicine/dylovene, /datum/reagent/medicine/polystem,\
										/datum/reagent/medicine/inaprovaline, /datum/reagent/medicine/dexalin, /datum/reagent/medicine/hyronalin, /datum/reagent/medicine/alkysine,\
										/datum/reagent/medicine/imidazoline)

#define REAGENTS_MEDICINE_ADVANCED list()

#define REAGENTS_DRUGS list(/datum/reagent/drug/space_drugs, /datum/reagent/drug/cryptobiolin, /datum/reagent/drug/mindbreaker,\
							/datum/reagent/drug/psilocybin, /datum/reagent/drug/nicotine)

#define REAGENTS_TOXIN list(/datum/reagent/toxin/amatoxin, /datum/reagent/toxin/plasma, /datum/reagent/toxin/fertilizer,\
							/datum/reagent/toxin/plantbgone, /datum/reagent/acid/polyacid, /datum/reagent/toxin/lexorin,\
							/datum/reagent/medicine/soporific, /datum/reagent/toxin/biomatter)

#define REAGENTS_ROACH list(/datum/reagent/toxin/diplopterum, /datum/reagent/toxin/seligitillin, /datum/reagent/toxin/starkellin,\
							/datum/reagent/toxin/gewaltine, /datum/reagent/toxin/blattedin)

#define REAGENTS_SPIDER list(/datum/reagent/toxin/pararein, /datum/reagent/toxin/aranecolmin)

#define REAGENTS_METAL list(/datum/reagent/metal/aluminum, /datum/reagent/metal/copper, /datum/reagent/metal/iron, /datum/reagent/metal/lithium,\
							/datum/reagent/metal/mercury, /datum/reagent/metal/potassium, /datum/reagent/metal/radium, /datum/reagent/metal/sodium,\
							/datum/reagent/metal/tungsten)

#define REAGENTS_EDIBLE list(/datum/reagent/organic/nutriment, /datum/reagent/organic/frostoil, /datum/reagent/organic/capsaicin, /datum/reagent/drink/milk,\
							/datum/reagent/other/lipozine, /datum/reagent/drink/limejuice, /datum/reagent/drink/orangejuice, /datum/reagent/drink/tomatojuice,\
							/datum/reagent/drink/tea, /datum/reagent/drink/tea/icetea)

#define REAGENTS_ALCOHOL list(/datum/reagent/alcohol/ale, /datum/reagent/alcohol/beer, /datum/reagent/alcohol/mead,\
								/datum/reagent/alcohol/gin, /datum/reagent/alcohol/rum, /datum/reagent/alcohol/tequilla, /datum/reagent/alcohol/vermouth,\
								/datum/reagent/alcohol/vodka, /datum/reagent/alcohol/whiskey, /datum/reagent/alcohol/wine, /datum/reagent/alcohol/cognac)

#define REAGENTS_COCKTAIL_SIMPLE list()

#define REAGENTS_NANITES list(/datum/reagent/nanites/arad, /datum/reagent/nanites/implant_medics, /datum/reagent/nanites/nantidotes, /datum/reagent/nanites/nanosymbiotes,\
							/datum/reagent/nanites/oxyrush, /datum/reagent/nanites/trauma_control_system, /datum/reagent/nanites/purgers,\
							/datum/reagent/nanites/uncapped/control_booster_utility, /datum/reagent/nanites/uncapped/control_booster_combat,\
							/datum/reagent/nanites/uncapped/voice_mimic, /datum/reagent/nanites/uncapped/dynamic_handprints)
