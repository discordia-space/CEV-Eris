/obj/item/device/scanner/xenobio
	name = "slime scanner"
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	throw_speed = 3
	throw_range = 7

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_BIO = 1)
	var/list/valid_targets = list(
		/mob/living/carbon/slime
	)

/obj/item/device/scanner/xenobio/is_valid_scan_target(atom/O)
	if(is_type_in_list(O, valid_targets))
		return TRUE
	return FALSE

/obj/item/device/scanner/xenobio/scan(mob/O, mob/user)
	scan_title = O.name
	scan_data = xenobio_scan_results(O)
	user.show_message(SPAN_NOTICE(scan_data))

/proc/xenobio_scan_results(mob/target)
	. = list()
	if(istype(target, /mob/living/carbon/slime))
		var/mob/living/carbon/slime/T = target
		. += "Slime scan results:"
		. += text("[T.colour] [] slime", T.is_adult ? "adult" : "baby")
		. += text("Nutrition: [T.nutrition]/[]", T.get_max_nutrition())
		if (T.nutrition < T.get_starve_nutrition())
			. += "<span class='alert'>Warning: slime is starving!</span>"
		else if (T.nutrition < T.get_hunger_nutrition())
			. += SPAN_WARNING("Warning: slime is hungry")
		. += "Electric change strength: [T.powerlevel]"
		. += "Health: [T.health]"
		if (T.slime_mutation[4] == T.colour)
			. += "This slime does not evolve any further"
		else
			if (T.slime_mutation[3] == T.slime_mutation[4])
				if (T.slime_mutation[2] == T.slime_mutation[1])
					. += text("Possible mutation: []", T.slime_mutation[3])
					. += "Genetic destability: [T.mutation_chance/2]% chance of mutation on splitting"
				else
					. += text("Possible mutations: [], [], [] (x2)", T.slime_mutation[1], T.slime_mutation[2], T.slime_mutation[3])
					. += "Genetic destability: [T.mutation_chance]% chance of mutation on splitting"
			else
				. += text("Possible mutations: [], [], [], []", T.slime_mutation[1], T.slime_mutation[2], T.slime_mutation[3], T.slime_mutation[4])
				. += "Genetic destability: [T.mutation_chance]% chance of mutation on splitting"
		if (T.cores > 1)
			. += "Anomalious slime core amount detected"
		. += "Growth progress: [T.amount_grown]/10"
		return jointext(., "<br>")
