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
	var/organ_size = 0.2

/obj/item/modification/organ/internal/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 1)
	. = ..()
	update_icon()

	var/datum/component/modification/organ/M = GetComponent(/datum/component/modification/organ)

	if(M)
		if(generate_organ_stats)
			generate_organ_stats_for_mod(M, predefined_modifier, num_eff)
		else
			M.modifications[ORGAN_SPECIFIC_SIZE_BASE] = M.modifications[ORGAN_SPECIFIC_SIZE_BASE] ? M.modifications[ORGAN_SPECIFIC_SIZE_BASE] : organ_size

/obj/item/modification/organ/internal/Destroy()
	if(LAZYLEN(datum_components))
		for(var/datum/component/comp in datum_components)
			comp.ClearFromParent()
			qdel(comp)
	return ..()

/obj/item/modification/organ/internal/examine(mob/user, extra_description = "")
	var/datum/component/modification/organ/M = GetComponent(/datum/component/modification/organ)

	var/using_sci_goggles = FALSE
	var/details_unlocked = FALSE

	var/list/organ_efficiency_base = M.modifications[ORGAN_EFFICIENCY_NEW_BASE]
	var/list/organ_efficiency_mod = M.modifications[ORGAN_EFFICIENCY_NEW_MOD]

	var/specific_organ_size_base = M.modifications[ORGAN_SPECIFIC_SIZE_BASE]
	var/blood_req_base = M.modifications[ORGAN_BLOOD_REQ_BASE]
	var/nutriment_req_base = M.modifications[ORGAN_NUTRIMENT_REQ_BASE]
	var/oxygen_req_base = M.modifications[ORGAN_OXYGEN_REQ_BASE]

	var/aberrant_cooldown_time_base = M.modifications[ORGAN_ABERRANT_COOLDOWN]

	if(isghost(user))
		details_unlocked = TRUE
	else if(user.stats)
		// Goggles check
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(istype(H.glasses, /obj/item/clothing/glasses/powered/science))
				var/obj/item/clothing/glasses/powered/G = H.glasses
				using_sci_goggles = G.active	// Meat vision

		// Stat check
		details_unlocked = (user.stats.getStat(M.examine_stat) >= M.examine_difficulty) ? TRUE : FALSE
		if(M.examine_stat_secondary && details_unlocked)
			details_unlocked = (user.stats.getStat(M.examine_stat_secondary) >= M.examine_difficulty_secondary) ? TRUE : FALSE

	if(M.examine_msg)
		extra_description += SPAN_WARNING(M.examine_msg) + "\n"

	if(M.adjustable)
		extra_description += SPAN_WARNING("Can be adjusted with a laser cutting tool.") + "\n"

	if(using_sci_goggles || details_unlocked)
		var/info = "\nOrganoid size: [specific_organ_size_base ? specific_organ_size_base : "0"]"
		info += "\nRequirements: <span style='color:red'>[blood_req_base ? blood_req_base : "0"]\
								</span>/<span style='color:blue'>[oxygen_req_base ? oxygen_req_base : "0"]\
								</span>/<span style='color:orange'>[nutriment_req_base ? nutriment_req_base : "0"]</span>"

		var/organs
		for(var/organ in organ_efficiency_base)
			organs += organ + " ([organ_efficiency_base[organ]]), "
		for(var/organ in organ_efficiency_mod)
			organs += organ + " ([organ_efficiency_mod[organ]]), "
		organs = copytext(organs, 1, length(organs) - 1)
		info += "\nOrgan tissues present: <span style='color:pink'>[organs ? organs : "none"]</span>"
		if(aberrant_cooldown_time_base)
			info += "\nAverage organ process duration: [aberrant_cooldown_time_base / (1 SECOND)] seconds"

		extra_description += SPAN_NOTICE(info)  + "\n"

		var/function_info = M.get_function_info()
		if(function_info)
			extra_description += SPAN_NOTICE(function_info)
	else
		extra_description += SPAN_WARNING("You lack the biological knowledge and/or mental ability required to understand its functions.")

	..(user, extra_description)

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
