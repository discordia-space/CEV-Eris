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
		/datum/design/organ/teratoma/input/power_source,
		/datum/design/organ/teratoma/process/map,
		/datum/design/organ/teratoma/output/reagents_blood_roach,
		/datum/design/organ/teratoma/output/reagents_blood_drugs,
		/datum/design/organ/teratoma/output/reagents_ingest_edible,
		/datum/design/organ/teratoma/output/reagents_ingest_alcohol,
		/datum/design/organ/teratoma/output/chemical_effects_type_1,
		/datum/design/organ/teratoma/output/stat_boost
	)

/obj/item/computer_hardware/hard_drive/portable/design/omg/tissue
	disk_name = "Oh My Guts! Artisanal Tissues"
	license = 10
	designs = list(
		/datum/design/organ/organ_mod/parenchymal_large,
		/datum/design/organ/teratoma/special/stat_boost
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
