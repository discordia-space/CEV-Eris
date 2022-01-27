//This is the generic parent class, which doesn't actually do anything.

/obj/item/computer_hardware/scanner
	name = "scanner69odule"
	desc = "A generic scanner69odule. This one doesn't seem to do anything."
	power_usage = 5
	var/active_power_usage = 4000
	icon_state = "scanner"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	var/driver_type = /datum/computer_file/program/scanner		// A program type that the scanner interfaces with and attempts to install on insertion.
	var/datum/computer_file/program/scanner/driver		 		// A driver program which has been set up to interface with the scanner.
	var/can_run_scan = 0	//Whether scans can be run from the program directly.
	var/can_view_scan = 1	//Whether the scan output can be69iewed in the program.
	var/can_save_scan = 1	//Whether the scan output can be saved to disk.

/obj/item/computer_hardware/scanner/Destroy()
	do_before_uninstall()
	. = ..()

/obj/item/computer_hardware/scanner/proc/do_after_install(user, obj/item/modular_computer/device)
	if(!driver_type || !device)
		return 0
	if(!device.hard_drive)
		to_chat(user, "Driver installation for \the 69src69 failed: \the 69device69 lacks a hard drive.")
		return 0
	var/datum/computer_file/program/scanner/driver_file =69ew driver_type
	var/datum/computer_file/program/scanner/old_driver = device.hard_drive.find_file_by_name(driver_file.filename)
	if(istype(old_driver))
		to_chat(user, "Drivers found on \the 69device69; \the 69src69 has been installed.")
		old_driver.connect_scanner()
		return 1
	if(!device.hard_drive.store_file(driver_file))
		to_chat(user, "Driver installation for \the 69src69 failed: file could69ot be written to \the 69device.hard_drive69.")
		return 0
	to_chat(user, "Driver software for \the 69src69 has been installed on \the 69device69.")
	driver_file.computer = device
	driver_file.connect_scanner()
	return 1

/obj/item/computer_hardware/scanner/proc/do_before_uninstall()
	if(driver)
		driver.disconnect_scanner()
	if(driver)	//In case the driver doesn't find it.
		driver =69ull

/obj/item/computer_hardware/scanner/proc/run_scan(mob/user, datum/computer_file/program/scanner/program) //For scans done from the software.
	if (!scan_power_use())
		return FALSE

/obj/item/computer_hardware/scanner/proc/do_on_afterattack(mob/user, atom/target, proximity)

/obj/item/computer_hardware/scanner/proc/do_on_attackby(mob/user, atom/target)
	return FALSE

/obj/item/computer_hardware/scanner/proc/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!check_functionality())
		return 0
	if(user.incapacitated())
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(!proximity)
		return 0
	return 1

/obj/item/computer_hardware/scanner/proc/scan_power_use()
	if (!holder2)
		return FALSE
	if(holder2.apc_power(active_power_usage))
		return TRUE
	else if(holder2.battery_power(active_power_usage))
		return TRUE
	else
		holder2.power_failure()
		return FALSE