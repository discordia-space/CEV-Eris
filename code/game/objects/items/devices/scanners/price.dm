/obj/item/device/scanner/price
	name = "export scanner"
	desc = "A device used to check objects against Commercial database."
	icon = 'icons/obj/reader.dmi'
	icon_state = "reader0"
	item_state = "radio"
	flags = NOBLUDGEON
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 1
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

	charge_per_use = 3

	var/obj/machinery/computer/supplycomp/cargo_console = null

/obj/item/device/scanner/price/examine(mob/user)
	..()
	if(!cargo_console)
		to_chat(user, "<span class='notice'>The [src] is currently not linked to a cargo console.</span>")

/obj/item/device/scanner/price/is_valid_scan_target(atom/movable/target)
	return istype(target)

/obj/item/device/scanner/price/can_use(mob/user)
	if(!istype(cargo_console))
		to_chat(user, SPAN_WARNING("You must link [src] to a cargo console first!"))
		return
	return ..()

/obj/item/device/scanner/price/scan(atom/movable/target, mob/user)
	scan_title = "Price estimations"
	
	if(!scan_data)
		scan_data = price_scan_results(target, cargo_console.contraband, cargo_console.emagged)
	else
		scan_data += "<br>[price_scan_results(target, cargo_console.contraband, cargo_console.emagged)]"
	flick("reader1", src)
	show_results(user)

/obj/item/device/scanner/price/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(istype(A, /obj/machinery/computer/supplycomp))
		var/obj/machinery/computer/supplycomp/C = A
		if(!C.requestonly)
			cargo_console = C
			to_chat(user, SPAN_NOTICE("Scanner linked to [C]."))
			return
	return ..()

/proc/price_scan_results(var/atom/movable/target, var/contraband = 0, var/emag = 0)
	var/list/data = list()
	// Before you fix it:
	// yes, checking manifests is a part of intended functionality.
	var/price = export_item_and_contents(target, contraband, emag, dry_run=TRUE)

	if(price)
		data += "<span class='notice'>Scanned [target], value: <b>[price]</b> \
			credits[target.contents.len ? " (contents included)" : ""].</span>"
	else
		data += "<span class='warning'>Scanned [target], no export value. \
			</span>"
	
	data = jointext(data, "<br>")
	return data