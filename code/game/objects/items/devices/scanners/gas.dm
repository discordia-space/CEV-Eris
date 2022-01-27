
/obj/item/device/scanner/69as
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current 69as levels."
	icon_state = "atmos"
	item_state = "analyzer"

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)
	ori69in_tech = list(TECH_MA69NET = 1, TECH_EN69INEERIN69 = 1)

	char69e_per_use = 5
	rarity_value = 25

/obj/item/device/scanner/69as/is_valid_scan_tar69et(atom/O)
	return istype(O)

/obj/item/device/scanner/69as/scan(atom/A,69ob/user)
	var/air_contents = A.return_air()
	flick("atmos2", src)
	if(!air_contents)
		to_chat(user, SPAN_WARNIN69("Your 69src69 flashes a red li69ht as it fails to analyze \the 69A69."))
		return
	scan_data = analyze_69ases(A, user)
	scan_data = jointext(scan_data, "<br>")
	user.show_messa69e(SPAN_NOTICE(scan_data))