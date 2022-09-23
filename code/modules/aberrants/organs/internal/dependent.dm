/obj/item/organ/internal/scaffold/aberrant/dependent
	max_upgrades = 4
	price_tag = 400		// High value due to 4 slots + long cooldown
	spawn_tags = SPAWN_TAG_ABERRANT_ORGAN_RARE		// Rare because 4 upgrade slots
	spawn_blacklisted = TRUE	// More of a novel thing to find in the deep maint vendors
	bad_type = /obj/item/organ/internal/scaffold/aberrant/dependent
	aberrant_cooldown_time = DEPENDENT_ABERRANT_COOLDOWN
	input_mod_path = /obj/item/modification/organ/internal/input/reagents
	process_mod_path = /obj/item/modification/organ/internal/process/condense
	output_mod_path = /obj/item/modification/organ/internal/output/activate_organ_functions
	special_mod_path = /obj/item/modification/organ/internal/special/on_cooldown/stat_boost
	should_process_have_organ_stats = FALSE
	output_pool = ALL_STANDARD_ORGAN_EFFICIENCIES
	output_info = list(1)
	special_info = list(STAT_ROB, 10)


/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater
	desc = "A masterfully engineered organ for when you really need to put someone in their place."
	specific_input_type_pool = list(
		/datum/reagent/alcohol/beer, /datum/reagent/alcohol/ale, /datum/reagent/alcohol/roachbeer
	)
	input_mode = CHEM_INGEST
	special_info = list(STAT_ROB, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/New()
	..()
	var/obj/item/modification/organ/internal/input/I
	for(var/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/input))
			I = mod

	var/datum/component/modification/organ/input/IC = I.GetComponent(/datum/component/modification/organ/input)
	IC.prefix = "wifebeater's"
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/random
	use_generated_name = FALSE

/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/liver
	name = "wifebeater's liver"
	output_pool = list(OP_LIVER)
	special_info = list(STAT_ROB, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/stomach
	name = "wifebeater's stomach"
	output_pool = list(OP_STOMACH)
	special_info = list(STAT_ROB, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/kidney
	name = "wifebeater's kidney"
	output_pool = list(OP_KIDNEYS)
	special_info = list(STAT_ROB, 10)


/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic
	desc = "A masterfully engineered organ for those who want to drink and drive."
	specific_input_type_pool = list(
		/datum/reagent/alcohol/gin, /datum/reagent/alcohol/rum, /datum/reagent/alcohol/sake, /datum/reagent/alcohol/tequilla, /datum/reagent/alcohol/vermouth,
		/datum/reagent/alcohol/vodka, /datum/reagent/alcohol/whiskey, /datum/reagent/alcohol/wine
	)
	input_mode = CHEM_INGEST
	special_info = list(STAT_MEC, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/New()
	..()
	var/obj/item/modification/organ/internal/input/I
	for(var/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/input))
			I = mod

	var/datum/component/modification/organ/input/IC = I.GetComponent(/datum/component/modification/organ/input)
	IC.prefix = "functional alcoholic's"
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/random
	use_generated_name = FALSE

/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/liver
	name = "functional alcoholic's liver"
	output_pool = list(OP_LIVER)
	special_info = list(STAT_MEC, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/stomach
	name = "functional alcoholic's stomach"
	output_pool = list(OP_STOMACH)
	special_info = list(STAT_MEC, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/kidney
	name = "functional alcoholic's kidney"
	output_pool = list(OP_KIDNEYS)
	special_info = list(STAT_MEC, 10)


/obj/item/organ/internal/scaffold/aberrant/dependent/classy
	desc = "A masterfully engineered organ for those fancy dinner parties."
	specific_input_type_pool = list(
		/datum/reagent/alcohol/martini, /datum/reagent/alcohol/coffee/b52, /datum/reagent/alcohol/black_russian, /datum/reagent/alcohol/gintonic
	)
	input_mode = CHEM_INGEST
	special_info = list(STAT_COG, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/classy/New()
	..()
	var/obj/item/modification/organ/internal/input/I
	for(var/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/input))
			I = mod

	var/datum/component/modification/organ/input/IC = I.GetComponent(/datum/component/modification/organ/input)
	IC.prefix = "aristocrat's"
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/dependent/classy/random
	use_generated_name = FALSE

/obj/item/organ/internal/scaffold/aberrant/dependent/classy/liver
	name = "aristocrat's liver"
	output_pool = list(OP_LIVER)
	special_info = list(STAT_COG, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/classy/stomach
	name = "aristocrat's stomach"
	output_pool = list(OP_STOMACH)
	special_info = list(STAT_COG, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/classy/kidney
	name = "aristocrat's kidney"
	output_pool = list(OP_KIDNEYS)
	special_info = list(STAT_COG, 10)

	
/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary
	desc = "A masterfully engineered organ for the really big guns."
	specific_input_type_pool = list(
		/datum/reagent/stim/bouncer, /datum/reagent/stim/steady, /datum/reagent/stim/violence
	)
	input_mode = CHEM_BLOOD
	special_info = list(STAT_VIG, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/New()
	..()
	var/obj/item/modification/organ/internal/input/I
	for(var/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/input))
			I = mod

	var/datum/component/modification/organ/input/IC = I.GetComponent(/datum/component/modification/organ/input)
	IC.prefix = "ex-mercenary's"
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/random
	use_generated_name = FALSE

/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/blood_vessel
	name = "ex-mercenary's blood vessel"
	output_pool = list(OP_BLOOD_VESSEL)
	special_info = list(STAT_VIG, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/liver
	name = "ex-mercenary's liver"
	output_pool = list(OP_LIVER)
	special_info = list(STAT_VIG, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/muscle
	name = "ex-mercenary's muscle"
	output_pool = list(OP_MUSCLE)
	special_info = list(STAT_VIG, 10)


/obj/item/organ/internal/scaffold/aberrant/dependent/mobster
	desc = "A masterfully engineered organ for the tough stuff."
	specific_input_type_pool = list(
		/datum/reagent/drug/space_drugs, /datum/reagent/drug/psilocybin
	)
	input_mode = CHEM_BLOOD
	special_info = list(STAT_TGH, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/New()
	..()
	var/obj/item/modification/organ/internal/input/I
	for(var/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/input))
			I = mod

	var/datum/component/modification/organ/input/IC = I.GetComponent(/datum/component/modification/organ/input)
	IC.prefix = "mobster's"
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/random
	use_generated_name = FALSE

/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/blood_vessel
	name = "mobster's blood vessel"
	output_pool = list(OP_BLOOD_VESSEL)
	special_info = list(STAT_TGH, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/liver
	name = "mobster's liver"
	output_pool = list(OP_LIVER)
	special_info = list(STAT_TGH, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/muscle
	name = "mobster's muscle"
	output_pool = list(OP_MUSCLE)
	special_info = list(STAT_TGH, 10)


/obj/item/organ/internal/scaffold/aberrant/dependent/chemist
	desc = "A masterfully engineered organ for the hard-working pill popper."
	specific_input_type_pool = list(
		/datum/reagent/stim/pro_surgeon, /datum/reagent/medicine/aminazine, /datum/reagent/medicine/citalopram
	)
	input_mode = CHEM_BLOOD
	special_info = list(STAT_BIO, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/New()
	..()
	var/obj/item/modification/organ/internal/input/I
	for(var/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/input))
			I = mod

	var/datum/component/modification/organ/input/IC = I.GetComponent(/datum/component/modification/organ/input)
	IC.prefix = "chemist's"
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/random
	use_generated_name = FALSE

/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/blood_vessel
	name = "chemist's blood vessel"
	output_pool = list(OP_BLOOD_VESSEL)
	special_info = list(STAT_BIO, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/liver
	name = "chemist's liver"
	output_pool = list(OP_LIVER)
	special_info = list(STAT_BIO, 10)

/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/kidney
	name = "chemist's kidney"
	output_pool = list(OP_KIDNEYS)
	special_info = list(STAT_BIO, 10)
