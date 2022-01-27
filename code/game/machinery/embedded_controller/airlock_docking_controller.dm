//a dockin69 port based on an airlock
/obj/machinery/embedded_controller/radio/airlock/dockin69_port
	name = "dockin69 port controller"
	var/datum/computer/file/embedded_pro69ram/airlock/dockin69/airlock_pro69ram
	var/datum/computer/file/embedded_pro69ram/dockin69/airlock/dockin69_pro69ram
	ta69_secure = 1

/obj/machinery/embedded_controller/radio/airlock/dockin69_port/New()
	. = ..()
	airlock_pro69ram = new/datum/computer/file/embedded_pro69ram/airlock/dockin69(src)
	dockin69_pro69ram = new/datum/computer/file/embedded_pro69ram/dockin69/airlock(src, airlock_pro69ram)
	pro69ram = dockin69_pro69ram

/obj/machinery/embedded_controller/radio/airlock/dockin69_port/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data = list(
		"chamber_pressure" = round(airlock_pro69ram.memory69"chamber_sensor_pressure"69),
		"exterior_status" = airlock_pro69ram.memory69"exterior_status"69,
		"interior_status" = airlock_pro69ram.memory69"interior_status"69,
		"processin69" = airlock_pro69ram.memory69"processin69"69,
		"dockin69_status" = dockin69_pro69ram.69et_dockin69_status(),
		"airlock_disabled" = !(dockin69_pro69ram.undocked() || dockin69_pro69ram.override_enabled),
		"override_enabled" = dockin69_pro69ram.override_enabled,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "dockin69_airlock_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/dockin69_port/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fin69erprint(usr)

	var/clean = FALSE
	switch(href_list69"command"69)
		if("cycle_ext", "cycle_int", "force_ext", "force_int", "abort", "to6969le_override")
			clean = TRUE

	if(clean)
		pro69ram.receive_user_command(href_list69"command"69)

	return 1



//A dockin69 controller for an airlock based dockin69 port
/datum/computer/file/embedded_pro69ram/dockin69/airlock
	var/datum/computer/file/embedded_pro69ram/airlock/dockin69/airlock_pro69ram

/datum/computer/file/embedded_pro69ram/dockin69/airlock/New(var/obj/machinery/embedded_controller/M,69ar/datum/computer/file/embedded_pro69ram/airlock/dockin69/A)
	..(M)
	airlock_pro69ram = A
	airlock_pro69ram.master_pro69 = src

/datum/computer/file/embedded_pro69ram/dockin69/airlock/receive_user_command(command)
	if (command == "to6969le_override")
		if (override_enabled)
			disable_override()
		else
			enable_override()
		return

	..(command)
	airlock_pro69ram.receive_user_command(command)	//pass alon69 to subpro69rams

/datum/computer/file/embedded_pro69ram/dockin69/airlock/Process()
	airlock_pro69ram.Process()
	..()

/datum/computer/file/embedded_pro69ram/dockin69/airlock/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	airlock_pro69ram.receive_si69nal(si69nal, receive_method, receive_param)	//pass alon69 to subpro69rams
	..(si69nal, receive_method, receive_param)

//tell the dockin69 port to start 69ettin69 ready for dockin69 - e.69. pressurize
/datum/computer/file/embedded_pro69ram/dockin69/airlock/prepare_for_dockin69()
	airlock_pro69ram.be69in_cycle_in()

//are we ready for dockin69?
/datum/computer/file/embedded_pro69ram/dockin69/airlock/ready_for_dockin69()
	//Unsimulated turfs have no atmos simulation so don't bother tryin69 to cycle anythin69
	//just short circuit this and be always ready
	if (istype(master.loc, /turf/unsimulated))
		return TRUE

	return airlock_pro69ram.done_cyclin69()

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_pro69ram/dockin69/airlock/finish_dockin69()
	airlock_pro69ram.enable_mech_re69ulators()
	airlock_pro69ram.open_doors()

//tell the dockin69 port to start 69ettin69 ready for undockin69 - e.69. close those doors.
/datum/computer/file/embedded_pro69ram/dockin69/airlock/prepare_for_undockin69()
	airlock_pro69ram.stop_cyclin69()
	airlock_pro69ram.close_doors()
	airlock_pro69ram.disable_mech_re69ulators()

//are we ready for undockin69?
/datum/computer/file/embedded_pro69ram/dockin69/airlock/ready_for_undockin69()
	var/ext_closed = airlock_pro69ram.check_exterior_door_secured()
	var/int_closed = airlock_pro69ram.check_interior_door_secured()
	return (ext_closed || int_closed)

//An airlock controller to be used by the airlock-based dockin69 port controller.
//Same as a re69ular airlock controller but allows disablin69 of the re69ular airlock functions when dockin69
/datum/computer/file/embedded_pro69ram/airlock/dockin69
	var/datum/computer/file/embedded_pro69ram/dockin69/airlock/master_pro69

/datum/computer/file/embedded_pro69ram/airlock/dockin69/receive_user_command(command)
	if (master_pro69.undocked() ||69aster_pro69.override_enabled)	//only allow the port to be used as an airlock if nothin69 is docked here or the override is enabled
		..(command)

/datum/computer/file/embedded_pro69ram/airlock/dockin69/proc/enable_mech_re69ulators()
	enable_mech_re69ulation()

/datum/computer/file/embedded_pro69ram/airlock/dockin69/proc/disable_mech_re69ulators()
	disable_mech_re69ulation()

/datum/computer/file/embedded_pro69ram/airlock/dockin69/proc/open_doors()
	to6969leDoor(memory69"interior_status"69, ta69_interior_door,69emory69"secure"69, "open")
	to6969leDoor(memory69"exterior_status"69, ta69_exterior_door,69emory69"secure"69, "open")

/datum/computer/file/embedded_pro69ram/airlock/dockin69/cycleDoors(var/tar69et)
	if (master_pro69.undocked() ||69aster_pro69.override_enabled)	//only allow the port to be used as an airlock if nothin69 is docked here or the override is enabled
		..(tar69et)

/*** DEBU6969ERBS ***

/datum/computer/file/embedded_pro69ram/dockin69/proc/print_state()
	to_chat(world, "id_ta69: 69id_ta6969")
	to_chat(world, "dock_state: 69dock_state69")
	to_chat(world, "control_mode: 69control_mode69")
	to_chat(world, "ta69_tar69et: 69ta69_tar69et69")
	to_chat(world, "response_sent: 69response_sent69")

/datum/computer/file/embedded_pro69ram/dockin69/post_si69nal(datum/si69nal/si69nal, comm_line)
	to_chat(world, "Pro69ram 69id_ta6969 sent a69essa69e!")
	print_state()
	to_chat(world, "69id_ta6969 sent command \"69si69nal.data69"command"6969\" to \"69si69nal.data69"recipient"6969\"")
	..(si69nal)

/obj/machinery/embedded_controller/radio/airlock/dockin69_port/verb/view_state()
	set cate69ory = "Debu69"
	set src in69iew(1)
	src.pro69ram:print_state()

/obj/machinery/embedded_controller/radio/airlock/dockin69_port/verb/spoof_si69nal(var/command as text,69ar/sender as text)
	set cate69ory = "Debu69"
	set src in69iew(1)
	var/datum/si69nal/si69nal = new
	si69nal.data69"ta69"69 = sender
	si69nal.data69"command"69 = command
	si69nal.data69"recipient"69 = id_ta69

	src.pro69ram:receive_si69nal(si69nal)

/obj/machinery/embedded_controller/radio/airlock/dockin69_port/verb/debu69_init_dock(var/tar69et as text)
	set cate69ory = "Debu69"
	set src in69iew(1)
	src.pro69ram:initiate_dockin69(tar69et)

/obj/machinery/embedded_controller/radio/airlock/dockin69_port/verb/debu69_init_undock()
	set cate69ory = "Debu69"
	set src in69iew(1)
	src.pro69ram:initiate_undockin69()

*/
