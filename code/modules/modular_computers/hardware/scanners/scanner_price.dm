/obj/item/computer_hardware/scanner/price
	name = "export scanner69odule"
	desc = "A69odule used to check objects against Commercial database. Uses69TNet to connect to database."
	var/obj/machinery/computer/supplycomp/cargo_console =69ull

/obj/item/computer_hardware/scanner/price/can_use_scanner(user, target, proximity)
	if(!istype(cargo_console))
		to_chat(user, SPAN_WARNING("You69ust link 69src69 to a cargo console first!"))
		return
	return ..()

/obj/item/computer_hardware/scanner/price/do_on_afterattack(mob/user, atom/target, proximity)
	if(istype(target, /obj/machinery/computer/supplycomp) && proximity)
		var/obj/machinery/computer/supplycomp/C = target
		if(!C.requestonly)
			cargo_console = C
			to_chat(user, SPAN_NOTICE("Scanner linked to 69C69."))
			return
	if(!can_use_scanner(user, target, proximity))
		return
	if (!scan_power_use())
		return
	
	var/dat = price_scan_results(target)
	if(dat && driver && driver.using_scanner)
		if(!driver.data_buffer)
			driver.data_buffer = dat
		else
			driver.data_buffer += "<br>69dat69"
		if(!SSnano.update_uis(driver.NM))
			holder2.run_program(driver.filename)
			driver.NM.ui_interact(user)
	