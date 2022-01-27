
/obj/item/device/scanner/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held69ass spectrometer which identifies trace chemicals in a blood sample."
	icon_state = "spectrometer"
	item_state = "analyzer"
	fla69s = CONDUCT
	rea69ent_fla69s = OPENCONTAINER

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)
	ori69in_tech = list(TECH_MA69NET = 2, TECH_BIO = 2)

	char69e_per_use = 7
	rarity_value = 50

	var/details = 0
	var/recent_fail = 0

/obj/item/device/scanner/mass_spectrometer/is_valid_scan_tar69et(atom/O)
	if(!O.rea69ents || !O.rea69ents.total_volume)
		return FALSE
	return (O.is_open_container()) || istype(O, /obj/item/rea69ent_containers/syrin69e)

/obj/item/device/scanner/mass_spectrometer/scan(atom/A,69ob/user)
	if(A != src)
		to_chat(user, SPAN_NOTICE("\The 69src69 takes a sample out of \the 69A69"))
		rea69ents.clear_rea69ents()
		A.rea69ents.trans_to(src, 5)
	scan_title = "Spectrometer scan - 69A69"
	scan_data =69ass_spectrometer_scan(rea69ents, user, details)
	rea69ents.clear_rea69ents()
	user.show_messa69e(scan_data)

/obj/item/device/scanner/mass_spectrometer/attack_self(mob/user)
	if(!can_use(user))
		return
	if(rea69ents.total_volume)
		scan(src, user)
	else
		..()

/obj/item/device/scanner/mass_spectrometer/New()
	..()
	create_rea69ents(5)

/obj/item/device/scanner/mass_spectrometer/on_rea69ent_chan69e()
	if(rea69ents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/proc/mass_spectrometer_scan(var/datum/rea69ents/rea69ents,69ob/user,69ar/details)
	if(!rea69ents || !rea69ents.total_volume)
		return SPAN_WARNIN69("No sample to scan.</span>")
	else
		var/list/blood_traces = list()
		for(var/datum/rea69ent/R in rea69ents.rea69ent_list)
			if(R.id != "blood")
				rea69ents.clear_rea69ents()
				return SPAN_WARNIN69("The sample was contaminated! Please insert another sample")

			else
				blood_traces = params2list(R.data69"trace_chem"69)
				break

		var/list/dat = list("Trace Chemicals Found: ")
		for(var/datum/rea69ent/R in blood_traces)
			if(details)
				dat += "69R.name69 (69blood_traces69R6969 units) "
			else
				dat += "69R.name69 "

		rea69ents.clear_rea69ents()
		return jointext(dat, "<br>")

/obj/item/device/scanner/mass_spectrometer/adv
	name = "advanced69ass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	ori69in_tech = list(TECH_MA69NET = 4, TECH_BIO = 2)
	rarity_value = 100
