/obj/item/weapon/computer_hardware/scanner/price
	name = "export scanner module"
	desc = "A module used to check objects against Commercial database. Uses NTNet to connect to database."

/obj/item/weapon/computer_hardware/scanner/medical/do_on_afterattack(mob/user, atom/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return
	if (!scan_power_use())
		return
	if(!holder2.get_ntnet_status()) // The program requires NTNet connection, but we are not connected to NTNet.
		to_chat(user, SPAN_DANGER("\The [src]'s screen shows \"NETWORK ERROR - Unable to connect to NTNet. Please retry. If problem persists contact your system administrator.\" warning."))
		return
	var/dat = price_scan_results(target)
	if(dat && driver && driver.using_scanner)
		driver.data_buffer = dat
		if(!SSnano.update_uis(driver.NM))
			holder2.run_program(driver.filename)
			driver.NM.ui_interact(user)
	