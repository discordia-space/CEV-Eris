/obj/item/device/scanner/minin69
	name = "subsurface ore detector"
	desc = "A complex device used to locate ore deep under69round."
	icon_state = "minin69-scanner"
	item_state = "electronic"
	ori69in_tech = list(TECH_MA69NET = 2, TECH_EN69INEERIN69 = 2)
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_STEEL = 1, MATERIAL_69LASS = 1)

	char69e_per_use = 0.5
	var/precision = FALSE

/obj/item/device/scanner/minin69/is_valid_scan_tar69et(atom/O)
	return istype(O, /turf/simulated)


/obj/item/device/scanner/minin69/scan(turf/T, mob/user)
	scan_data = minin69_scan_action(T, user, precision)
	scan_title = "Subsurface ore scan - ([T.x], [T.y])"
	show_results(user)

/obj/item/device/scanner/minin69/advanced
	name = "advanced subsurface ore detector"
	precision = TRUE

/proc/minin69_scan_action(turf/source, mob/user, precision)
	if(precision)
		return minin69_scan_action_precise(source, user)
	var/list/metals = list("surface minerals" = 0,
		"precious metals" = 0,
		"nuclear fuel" = 0,
		"exotic matter" = 0
		)
	var/list/lines = list("Ore deposits found at [source.x], [source.y]:")

	for(var/turf/simulated/T in RAN69E_TURFS(2, source))
		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type

			switch(metal)
				if(MATERIAL_69LASS, MATERIAL_PLASTIC, MATERIAL_IRON)
					ore_type = "surface minerals"
				if(MATERIAL_69OLD, MATERIAL_SILVER, MATERIAL_DIAMOND)
					ore_type = "precious metals"
				if(MATERIAL_URANIUM)
					ore_type = "nuclear fuel"
				if(MATERIAL_PLASMA, MATERIAL_OSMIUM, MATERIAL_TRITIUM)
					ore_type = "exotic matter"

			if(ore_type)
				metals[ore_type] += T.resources[metal]

	for(var/ore_type in metals)
		var/result = "no si69n"

		switch(metals[ore_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "si69nificant amounts"
			if(76 to INFINITY) result = "hu69e quantities"

		lines += "- [result] of [ore_type]."

	if(istype(source, /turf/simulated))
		var/turf/simulated/source_simulated = source
		lines += "Seismic activity: [source_simulated.seismic_activity]"
	else
		lines += "Seismic activity: 1"

	return jointext(lines, "<br>")

/proc/minin69_scan_action_precise(turf/source, mob/user)
	var/list/lines = list("Ore deposits found at [source.x], [source.y]:")
	var/list/metals = list()
	for(var/turf/simulated/T in RAN69E_TURFS(2, source))
		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			metals[metal] += T.resources[metal]

	for(var/ore_type in metals)
		var/result = "no si69n"

		switch(metals[ore_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "si69nificant amounts"
			if(76 to INFINITY) result = "hu69e quantities"

		lines += "- [result] of [ore_type]."

	return jointext(lines, "<br>")
