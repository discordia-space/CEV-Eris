
/obj/item/device/scanner/gas
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon_state = "atmos"
	item_state = "analyzer"

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

	charge_per_use = 5
	rarity_value = 25

/obj/item/device/scanner/gas/is_valid_scan_target(atom/O)
	return istype(O)

/obj/item/device/scanner/gas/scan(atom/A, mob/user)
	var/air_contents = A.return_air()
	flick("atmos2", src)
	if(!air_contents)
		to_chat(user, SPAN_WARNING("Your [src] flashes a red light as it fails to analyze \the [A]."))
		return
	scan_data = analyze_gases(A, user)
	scan_data = jointext(scan_data, "<br>")
	user.show_message(SPAN_NOTICE(scan_data))