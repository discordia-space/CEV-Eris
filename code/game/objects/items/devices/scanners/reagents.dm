/obj/item/device/scanner/reagent
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	spawn_tags = SPAWN_TAG_DEVICE_SCIENCE
	rarity_value = 10
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

	charge_per_use = 7

	var/details = 0
	var/recent_fail = 0

/obj/item/device/scanner/reagent/is_valid_scan_target(obj/O)
	return istype(O)

/obj/item/device/scanner/reagent/scan(obj/O, mob/user)
	scan_data = reagent_scan_results(O, details)
	scan_title = "Reagents scan - [O]"
	user.show_message(SPAN_NOTICE(scan_data))

/proc/reagent_scan_results(obj/O, details = 0)
	if(isnull(O.reagents))
		return "No significant chemical agents found in [O]."
	if(O.reagents.reagent_list.len == 0)
		return "No active chemical agents found in [O]."
	. = list("Chemicals found in [O]:")
	var/one_percent = O.reagents.total_volume / 100
	for (var/datum/reagent/R in O.reagents.reagent_list)
		. += "[R][details ? ": [R.volume / one_percent]%" : ""]"
	. = jointext(., "<br>")

/obj/item/device/scanner/reagent/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)
	spawn_tags = SPAWN_TAG_DEVICE
	rarity_value = 50

