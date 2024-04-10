/obj/item/modification/organ
	name = "organoid"
	bad_type = /obj/item/modification/organ
	matter = list(MATERIAL_BIOMATTER = 5)
	origin_tech = list(TECH_BIO = 3)	// One level higher than regular organs
	price_tag = 25		// Biomatter is 5 credits per unit
	var/use_generated_icon = TRUE

/obj/item/modification/organ/internal
	icon = 'icons/obj/organ_mods.dmi'
	icon_state = "organoid"
	desc = "Functional tissue of one or more organs in graftable form."
	spawn_tags = SPAWN_TAG_ORGAN_MOD
	spawn_blacklisted = TRUE	// Organoids should only spawn in teratomas and mods will just add more clutter to junk loot
	bad_type = /obj/item/modification/organ/internal

/obj/item/modification/organ/internal/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 1)
	. = ..()
	update_icon()

	var/datum/component/modification/organ/M = GetComponent(/datum/component/modification/organ)

	if(M)
		if(generate_organ_stats)
			generate_organ_stats_for_mod(M, predefined_modifier, num_eff)
		else
			M.modifications[ORGAN_SPECIFIC_SIZE_BASE] = 0.20

/obj/item/modification/organ/internal/Destroy()
	if(LAZYLEN(datum_components))
		for(var/datum/component/comp in datum_components)
			comp.ClearFromParent()
			qdel(comp)
	return ..()

/obj/item/modification/organ/internal/update_icon()
	if(use_generated_icon)
		icon_state = initial(icon_state) + "-[rand(1,5)]"

/obj/item/modification/organ/internal/proc/generate_organ_stats_for_mod(datum/component/modification/organ/O, predefined_modifier = null, num_eff = 1)
	var/is_parasitic = FALSE
	if(predefined_modifier < 0)
		is_parasitic = TRUE

	var/list/organ_list
	if(is_parasitic)
		organ_list = SYMBIOTIC_ORGAN_EFFICIENCIES
	else
		organ_list = ALL_STANDARD_ORGAN_EFFICIENCIES

	organ_list = shuffle(organ_list)

	// Organ stat generation
	var/list/organ_efficiency_base
	var/specific_organ_size_base
	var/max_blood_storage_base
	var/blood_req_base
	var/nutriment_req_base
	var/oxygen_req_base

	if(!islist(O.modifications[ORGAN_EFFICIENCY_NEW_BASE]))
		O.modifications[ORGAN_EFFICIENCY_NEW_BASE] = list()

	organ_efficiency_base = O.modifications[ORGAN_EFFICIENCY_NEW_BASE]

	var/generation_runs = 0
	for(var/organ in organ_list)
		if(generation_runs < num_eff)
			var/list/organ_stats = ALL_ORGAN_STATS[organ]
			var/modifier = abs(predefined_modifier)
			if(!modifier)
				modifier = 0.10
			organ_efficiency_base[organ] 	+= round(organ_stats[1] * modifier * (1 - (2 * is_parasitic)), 1)
			specific_organ_size_base 		+= round(organ_stats[2] * modifier * (1 + (2 * is_parasitic)), 0.01)
			max_blood_storage_base			+= round(organ_stats[3] * modifier, 1)
			blood_req_base 					+= round(organ_stats[4] * modifier * (1 + (1 * is_parasitic)), 0.01)
			nutriment_req_base 				+= round(organ_stats[5] * modifier * (1 + (1 * is_parasitic)), 0.01)
			oxygen_req_base 				+= round(organ_stats[6] * modifier * (1 + (1 * is_parasitic)), 0.01)

			++generation_runs

	O.modifications[ORGAN_SPECIFIC_SIZE_BASE] = specific_organ_size_base
	O.modifications[ORGAN_MAX_BLOOD_STORAGE_BASE] = max_blood_storage_base
	O.modifications[ORGAN_BLOOD_REQ_BASE] = blood_req_base
	O.modifications[ORGAN_NUTRIMENT_REQ_BASE] = nutriment_req_base
	O.modifications[ORGAN_OXYGEN_REQ_BASE] = oxygen_req_base
