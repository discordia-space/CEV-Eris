/obj/item/modification/organ
	name = "organoid"
	bad_type = /obj/item/modification/organ
	matter = list(MATERIAL_BIOMATTER = 5)
	origin_tech = list(TECH_BIO = 3)	// One level higher than regular organs
	price_tag = 25		// Biomatter is 5 credits per unit

/obj/item/modification/organ/internal
	icon = 'icons/obj/organ_mods.dmi'
	icon_state = "organoid"
	desc = "Functional tissue of one or more organs in graftable form."
	spawn_tags = SPAWN_TAG_ORGAN_MOD
	spawn_blacklisted = TRUE	// These should never spawn without a parent organ/teratoma.
	bad_type = /obj/item/modification/organ/internal

/obj/item/modification/organ/internal/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	..()
	update_icon()
	if(generate_organ_stats)
		var/datum/component/modification/organ/M = GetComponent(/datum/component/modification/organ)
		if(M)
			generate_organ_stats_for_mod(M, predefined_modifier)

/obj/item/modification/organ/internal/update_icon()
	icon_state = initial(icon_state) + "-[rand(1,5)]"

/obj/item/modification/organ/internal/proc/generate_organ_stats_for_mod(datum/component/modification/organ/O, predefined_modifier = null)
	var/is_parasitic = FALSE
	if(predefined_modifier < 0)
		is_parasitic = TRUE

	var/list/organ_list = ALL_ORGAN_STATS

	organ_list = shuffle(organ_list)

	// Organ stat generation
	var/probability = 100

	for(var/organ in organ_list)
		if(prob(probability))
			var/list/organ_stats = organ_list[organ]
			var/modifier = abs(predefined_modifier)
			if(!modifier)
				modifier = pick(0.04, 0.08, 0.16)
			O.organ_efficiency_mod.Add(organ)
			O.organ_efficiency_mod[organ] 	= round(organ_stats[1] * modifier * (1 - (2 * is_parasitic)), 1)
			O.specific_organ_size_mod 		+= round(organ_stats[2] * modifier * (1 + (2 * is_parasitic)), 0.01)
			O.max_blood_storage_mod			+= round(organ_stats[3] * modifier, 1)
			O.blood_req_mod 				+= round(organ_stats[4] * modifier * (1 + (1 * is_parasitic)), 0.01)
			O.nutriment_req_mod 			+= round(organ_stats[5] * modifier * (1 + (1 * is_parasitic)), 0.01)
			O.oxygen_req_mod 				+= round(organ_stats[6] * modifier * (1 + (1 * is_parasitic)), 0.01)

			if(predefined_modifier)
				break

			probability = probability / 8
