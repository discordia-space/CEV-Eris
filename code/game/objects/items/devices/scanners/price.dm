/obj/item/device/scanner/price
	name = "export scanner"
	desc = "A device used to check objects against Commercial database."
	icon = 'icons/obj/reader.dmi'
	icon_state = "reader0"
	item_state = "radio"
	flags = NOBLUDGEON
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 1
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	charge_per_use = 3
	rarity_value = 25

/obj/item/device/scanner/price/is_valid_scan_target(atom/movable/target)
	return istype(target)

/obj/item/device/scanner/price/scan(atom/movable/target,69ob/user)
	scan_title = "Price estimations"

	if(!scan_data)
		scan_data = price_scan_results(target)
	else
		scan_data += "<br>69price_scan_results(target)69"
	flick("reader1", src)
	show_results(user)

/obj/item/device/scanner/price/afterattack(atom/A,69ob/user, proximity)
	if(!proximity)
		return
	return ..()

/proc/price_scan_results(atom/movable/target)
	var/list/data = list()
	var/price = SStrade.get_export_cost(target)

	if(price)
		data += "<span class='notice'>Scanned 69target69,69alue: <b>69price69</b> \
			credits69target.contents.len ? " (contents included)" : ""69. 69target.surplus_tag?"(surplus)":""69</span>"
	else
		data += "<span class='warning'>Scanned 69target69, no export69alue. \
			</span>"
	data = jointext(data, "<br>")
	return data