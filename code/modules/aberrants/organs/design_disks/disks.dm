/obj/item/computer_hardware/hard_drive/portable/design/omg
	icon_state = "omg"
	license = -1
	spawn_blacklisted = TRUE	// Deep maint only

/obj/item/computer_hardware/hard_drive/portable/design/omg/basic_organ_mods
	disk_name = "Oh My Guts! Starter Kit"
	desc = "Data disk used to store autolathe designs. Mod your heart out!"
	designs = list(
		/datum/design/organ/organ_mod/capillaries,
		/datum/design/organ/organ_mod/durable_membrane,
		/datum/design/organ/organ_mod/stem_cells,
		/datum/design/organ/organ_mod/overclock,
		/datum/design/organ/organ_mod/underclock,
		/datum/design/organ/organ_mod/expander,
		/datum/design/organ/organ_mod/silencer,
		/datum/design/organ/organ_mod/parenchymal
	)

/obj/item/computer_hardware/hard_drive/portable/design/omg/diy_organs
	disk_name = "Oh My Guts! DIY Organs"
	designs = list(
		/datum/design/organ/scaffold,
		/datum/design/organ/teratoma/input/reagents_roach,
		/datum/design/organ/teratoma/input/reagents_spider,
		/datum/design/organ/teratoma/input/reagents_toxin,
		/datum/design/organ/teratoma/input/reagents_edible,
		/datum/design/organ/teratoma/input/reagents_alcohol,
		/datum/design/organ/teratoma/input/reagents_drugs,
		/datum/design/organ/teratoma/input/reagents_dispenser,
		/datum/design/organ/teratoma/input/damage,
		/datum/design/organ/teratoma/input/power_source,
		/datum/design/organ/teratoma/process/map,
		/datum/design/organ/teratoma/process/condense,
		/datum/design/organ/teratoma/output/reagents_blood_roach,
		/datum/design/organ/teratoma/output/reagents_blood_drugs,
		/datum/design/organ/teratoma/output/reagents_ingest_edible,
		/datum/design/organ/teratoma/output/reagents_ingest_alcohol,
		/datum/design/organ/teratoma/output/chemical_effects_type_1,
		/datum/design/organ/teratoma/output/stat_boost
	)

/obj/item/computer_hardware/hard_drive/portable/design/omg/teratoma
	disk_name = "Oh My Guts! Bespoke Teratomas"
	license = 10
	designs = list(
		/datum/design/organ/organ_mod/parenchymal_large,
		/datum/design/organ/teratoma/special/chemical_effect,
		/datum/design/organ/teratoma/special/stat_boost,
		/datum/design/organ/teratoma/output/reagents_blood_medicine_simple,
		/datum/design/organ/teratoma/output/chemical_effects_type_2,
		/datum/design/organ/teratoma/input/uncommon/reagents_roach,
		/datum/design/organ/teratoma/input/uncommon/reagents_spider,
		/datum/design/organ/teratoma/input/uncommon/reagents_toxin,
		/datum/design/organ/teratoma/input/uncommon/reagents_edible,
		/datum/design/organ/teratoma/input/uncommon/reagents_alcohol,
		/datum/design/organ/teratoma/input/uncommon/reagents_drugs,
		/datum/design/organ/teratoma/input/uncommon/reagents_dispenser,
		/datum/design/organ/teratoma/input/uncommon/damage,
		/datum/design/organ/teratoma/input/uncommon/power_source,
		/datum/design/organ/teratoma/process/boost,
		/datum/design/organ/teratoma/output/uncommon/reagents_blood_roach,
		/datum/design/organ/teratoma/output/uncommon/reagents_blood_drugs,
		/datum/design/organ/teratoma/output/uncommon/reagents_blood_medicine_simple,
		/datum/design/organ/teratoma/output/uncommon/reagents_ingest_edible,
		/datum/design/organ/teratoma/output/uncommon/reagents_ingest_alcohol,
		/datum/design/organ/teratoma/output/uncommon/chemical_effects_type_1,
		/datum/design/organ/teratoma/output/uncommon/chemical_effects_type_2,
		/datum/design/organ/teratoma/output/uncommon/stat_boost
	)

/obj/item/computer_hardware/hard_drive/portable/design/omg/teratoma_rare
	disk_name = "Oh My Guts! Artisanal Teratomas"
	license = 10
	designs = list(
		/datum/design/organ/scaffold/rare,
		/datum/design/organ/teratoma/output/reagents_blood_medicine_intermediate,
		/datum/design/organ/teratoma/output/uncommon/reagents_blood_medicine_intermediate,
		/datum/design/organ/teratoma/input/rare/reagents_roach,
		///datum/design/organ/teratoma/input/rare/reagents_spider,		// Not enough spider chems in the pool
		/datum/design/organ/teratoma/input/rare/reagents_toxin,
		/datum/design/organ/teratoma/input/rare/reagents_edible,
		/datum/design/organ/teratoma/input/rare/reagents_alcohol,
		/datum/design/organ/teratoma/input/rare/reagents_drugs,
		/datum/design/organ/teratoma/input/rare/reagents_dispenser,
		/datum/design/organ/teratoma/input/rare/damage,
		/datum/design/organ/teratoma/input/rare/power_source,
		/datum/design/organ/teratoma/output/rare/reagents_blood_roach,
		/datum/design/organ/teratoma/output/rare/reagents_blood_drugs,
		/datum/design/organ/teratoma/output/rare/reagents_blood_medicine_intermediate,
		/datum/design/organ/teratoma/output/rare/reagents_ingest_edible,
		/datum/design/organ/teratoma/output/rare/reagents_ingest_alcohol,
		/datum/design/organ/teratoma/output/rare/chemical_effects_type_1,
		/datum/design/organ/teratoma/output/rare/chemical_effects_type_2,
		/datum/design/organ/teratoma/output/rare/stat_boost
	)

/obj/item/computer_hardware/hard_drive/portable/design/omg/simple
	disk_name = "Oh My Guts! The Classics"
	license = 10
	designs = list(
		/datum/design/organ/aberrant_organ/scrub_toxin_blood,
		/datum/design/organ/aberrant_organ/scrub_toxin_ingest,
		/datum/design/organ/aberrant_organ/scrub_toxin_touch,
		/datum/design/organ/aberrant_organ/gastric,
		/datum/design/organ/aberrant_organ/damage_response
	)

/obj/item/computer_hardware/hard_drive/portable/design/omg/alcoholic
	disk_name = "Oh My Guts! Discount Organs"
	license = 10
	designs = list(
		/datum/design/organ/aberrant_organ/wifebeater,
		/datum/design/organ/aberrant_organ/wifebeater/liver = 2,
		/datum/design/organ/aberrant_organ/wifebeater/stomach = 2,
		/datum/design/organ/aberrant_organ/wifebeater/kidney = 2,
		/datum/design/organ/aberrant_organ/functional_alcoholic,
		/datum/design/organ/aberrant_organ/functional_alcoholic/liver = 2,
		/datum/design/organ/aberrant_organ/functional_alcoholic/stomach = 2,
		/datum/design/organ/aberrant_organ/functional_alcoholic/kidney = 2,
		/datum/design/organ/aberrant_organ/classy,
		/datum/design/organ/aberrant_organ/classy/liver = 2,
		/datum/design/organ/aberrant_organ/classy/stomach = 2,
		/datum/design/organ/aberrant_organ/classy/kidney = 2
	)

/obj/item/computer_hardware/hard_drive/portable/design/omg/addict
	disk_name = "Oh My Guts! Refurbished Organs"
	license = 10
	designs = list(
		/datum/design/organ/aberrant_organ/mobster,
		/datum/design/organ/aberrant_organ/mobster/blood_vessel = 2,
		/datum/design/organ/aberrant_organ/mobster/liver = 2,
		/datum/design/organ/aberrant_organ/mobster/muscle = 2,
		/datum/design/organ/aberrant_organ/chemist,
		/datum/design/organ/aberrant_organ/chemist/blood_vessel = 2,
		/datum/design/organ/aberrant_organ/chemist/liver = 2,
		/datum/design/organ/aberrant_organ/chemist/kidney = 2,
		/datum/design/organ/aberrant_organ/exmercenary,
		/datum/design/organ/aberrant_organ/exmercenary/blood_vessel = 2,
		/datum/design/organ/aberrant_organ/exmercenary/liver = 2,
		/datum/design/organ/aberrant_organ/exmercenary/muscle = 2
	)
