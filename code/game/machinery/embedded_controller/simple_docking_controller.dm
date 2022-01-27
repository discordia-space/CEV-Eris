//a dockin69 port that uses a sin69le door
/obj/machinery/embedded_controller/radio/simple_dockin69_controller
	name = "dockin69 hatch controller"
	var/ta69_door
	var/datum/computer/file/embedded_pro69ram/dockin69/simple/dockin69_pro69ram
	var/pro69type = /datum/computer/file/embedded_pro69ram/dockin69/simple/


/obj/machinery/embedded_controller/radio/simple_dockin69_controller/Initialize()
	. = ..()
	dockin69_pro69ram = new pro69type(src)
	pro69ram = dockin69_pro69ram

/obj/machinery/embedded_controller/radio/simple_dockin69_controller/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data = list(
		"dockin69_status" = dockin69_pro69ram.69et_dockin69_status(),
		"override_enabled" = dockin69_pro69ram.override_enabled,
		"door_state" = 	dockin69_pro69ram.memory69"door_status"6969"state"69,
		"door_lock" = 	dockin69_pro69ram.memory69"door_status"6969"lock"69,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "simple_dockin69_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_dockin69_controller/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)
	src.add_fin69erprint(usr)

	var/clean = FALSE
	switch(href_list69"command"69)
		if("force_door", "to6969le_override")
			clean = TRUE

	if(clean)
		pro69ram.receive_user_command(href_list69"command"69)

	return FALSE


//A dockin69 controller pro69ram for a simple door based dockin69 port
/datum/computer/file/embedded_pro69ram/dockin69/simple
	var/ta69_door

	var/undockin69_attempts = 0 //Once an undockin69 re69uest reaches 5 attempts, it force undocks, to prevent airlock deadlock.

/datum/computer/file/embedded_pro69ram/dockin69/simple/New(var/obj/machinery/embedded_controller/M)
	..(M)
	memory69"door_status"69 = list(state = "closed", lock = "locked")		//assume closed and locked in case the doors dont report in

	if (istype(M, /obj/machinery/embedded_controller/radio/simple_dockin69_controller))
		var/obj/machinery/embedded_controller/radio/simple_dockin69_controller/controller =69

		ta69_door = controller.ta69_door? controller.ta69_door : "69id_ta6969_hatch"

		spawn(10)
			si69nal_door("update")		//si69nals connected doors to update their status


/datum/computer/file/embedded_pro69ram/dockin69/simple/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	var/receive_ta69 = si69nal.data69"ta69"69

	if(!receive_ta69) return

	if(receive_tag==tag_door)
		memory69"door_status"6969"state"69 = signal.data69"door_status"69
		memory69"door_status"6969"lock"69 = signal.data69"lock_status"69

	..(signal, receive_method, receive_param)

/datum/computer/file/embedded_program/docking/simple/receive_user_command(command)
	switch(command)
		if("force_door")
			if (override_enabled)
				if(memory69"door_status"6969"state"69 == "open")
					close_door()
				else
					open_door()
		if("toggle_override")
			if (override_enabled)
				disable_override()
			else
				enable_override()


/datum/computer/file/embedded_program/docking/simple/proc/signal_door(var/command)
	var/datum/signal/signal = new
	signal.data69"tag"69 = tag_door
	signal.data69"command"69 = command
	post_signal(signal)

///datum/computer/file/embedded_program/docking/simple/proc/signal_mech_sensor(var/command)
//	signal_door(command)
//	return

/datum/computer/file/embedded_program/docking/simple/proc/open_door()
	if(memory69"door_status"6969"state"69 == "closed")
		//signal_mech_sensor("enable")
		signal_door("secure_open")
	else if(memory69"door_status"6969"lock"69 == "unlocked")
		signal_door("lock")

/datum/computer/file/embedded_program/docking/simple/proc/close_door()
	if(memory69"door_status"6969"state"69 == "open")
		signal_door("secure_close")
		//signal_mech_sensor("disable")
	else if(memory69"door_status"6969"lock"69 == "unlocked")
		signal_door("lock")

//tell the docking port to start getting ready for docking - e.g. pressurize
/datum/computer/file/embedded_program/docking/simple/prepare_for_docking()
	return		//don't need to do anything

//are we ready for docking?
/datum/computer/file/embedded_program/docking/simple/ready_for_docking()
	return 1	//don't need to do anything

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_program/docking/simple/finish_docking()
	open_door()

//tell the docking port to start getting ready for undocking - e.g. close those doors.
/datum/computer/file/embedded_program/docking/simple/prepare_for_undocking()
	close_door()

//are we ready for undocking?
/datum/computer/file/embedded_program/docking/simple/ready_for_undocking()
	. = (control_mode ==69ODE_SERVER && undocking_attempts++ >= 5) || (memory69"door_status"6969"state"69 == "closed" &&69emory69"door_status"6969"lock"69 == "locked")
	if(.)
		undocking_attempts = 0
	return .

/*** DEBUG69ERBS ***

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/view_state()
	set category = "Debug"
	set src in69iew(1)
	src.program:print_state()

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/spoof_signal(var/command as text,69ar/sender as text)
	set category = "Debug"
	set src in69iew(1)
	var/datum/signal/signal = new
	signal.data69"tag"69 = sender
	signal.data69"command"69 = command
	signal.data69"recipient"69 = id_tag

	src.program:receive_signal(signal)

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/debug_init_dock(var/target as text)
	set category = "Debug"
	set src in69iew(1)
	src.program:initiate_docking(target)

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/debug_init_undock()
	set category = "Debug"
	set src in69iew(1)
	src.program:initiate_undocking()

*/
