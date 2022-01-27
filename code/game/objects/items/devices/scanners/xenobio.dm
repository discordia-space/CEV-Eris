/obj/item/device/scanner/xenobio
	name = "slime scanner"
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	throw_speed = 3
	throw_range = 7

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	origin_tech = list(TECH_BIO = 1)
	var/list/valid_targets = list(
		/mob/living/carbon/slime
	)

/obj/item/device/scanner/xenobio/is_valid_scan_target(atom/O)
	if(is_type_in_list(O,69alid_targets))
		return TRUE
	return FALSE

/obj/item/device/scanner/xenobio/scan(mob/O,69ob/user)
	scan_title = O.name
	scan_data = xenobio_scan_results(O)
	user.show_message(SPAN_NOTICE(scan_data))

/proc/xenobio_scan_results(mob/target)
	. = list()
	if(istype(target, /mob/living/carbon/slime))
		var/mob/living/carbon/slime/T = target
		. += "Slime scan results:"
		. += text("69T.colour69 6969 slime", T.is_adult ? "adult" : "baby")
		. += text("Nutrition: 69T.nutrition69/6969", T.get_max_nutrition())
		if (T.nutrition < T.get_starve_nutrition())
			. += "<span class='alert'>Warning: slime is starving!</span>"
		else if (T.nutrition < T.get_hunger_nutrition())
			. += SPAN_WARNING("Warning: slime is hungry")
		. += "Electric change strength: 69T.powerlevel69"
		. += "Health: 69T.health69"
		if (T.slime_mutation69469 == T.colour)
			. += "This slime does not evolve any further"
		else
			if (T.slime_mutation69369 == T.slime_mutation69469)
				if (T.slime_mutation69269 == T.slime_mutation69169)
					. += text("Possible69utation: 6969", T.slime_mutation69369)
					. += "Genetic destability: 69T.mutation_chance/269% chance of69utation on splitting"
				else
					. += text("Possible69utations: 6969, 6969, 6969 (x2)", T.slime_mutation69169, T.slime_mutation69269, T.slime_mutation69369)
					. += "Genetic destability: 69T.mutation_chance69% chance of69utation on splitting"
			else
				. += text("Possible69utations: 6969, 6969, 6969, 6969", T.slime_mutation69169, T.slime_mutation69269, T.slime_mutation69369, T.slime_mutation69469)
				. += "Genetic destability: 69T.mutation_chance69% chance of69utation on splitting"
		if (T.cores > 1)
			. += "Anomalious slime core amount detected"
		. += "Growth progress: 69T.amount_grown69/10"
		return jointext(., "<br>")
