/obj/item/device/scanner/mining
	name = "subsurface ore detector"
	desc = "A complex device used to locate ore deep underground."
	icon_state = "mining-scanner"
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_STEEL = 1, MATERIAL_GLASS = 1)

	charge_per_use = 0.5

/obj/item/device/scanner/mining/is_valid_scan_target(atom/O)
	return istype(O, /turf)

/obj/item/device/scanner/mining/scan(turf/T, mob/user)
	scan_data = mining_scan_action(T, user)
	scan_title = "Subsurface ore scan - ([T.x], [T.y])"
	show_results(user)

/proc/mining_scan_action(turf/source, mob/user)
	if(istype(source, /turf/floor/asteroid))
		var/turf/source_simulated = source
		return "Seismic activity (from 1 up to 6): [source_simulated.seismic_activity]"
	return "Seismic activity: N/A - The deep drill cannot mine this ground."
