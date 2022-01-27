//a controller for a docking port with69ultiple independent airlocks
//this is the69aster controller, that things will try to dock with.
/obj/machinery/embedded_controller/radio/docking_port_multi
	name = "docking port controller"

	var/child_tags_txt
	var/child_names_txt
	var/list/child_names = list()

	var/datum/computer/file/embedded_program/docking/multi/docking_program

/obj/machinery/embedded_controller/radio/docking_port_multi/New()
	. = ..()
	docking_program = new/datum/computer/file/embedded_program/docking/multi(src)
	program = docking_program

/obj/machinery/embedded_controller/radio/docking_port_multi/Initialize()
	.=..()
	var/list/names = splittext(child_names_txt, ";")
	var/list/tags = splittext(child_tags_txt, ";")

	if (names.len == tags.len)
		for (var/i = 1; i <= tags.len; i++)
			child_names69tags69i6969 = names69i69


/obj/machinery/embedded_controller/radio/docking_port_multi/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	var/list/airlocks69child_names.len69
	var/i = 1
	for (var/child_tag in child_names)
		airlocks69i++69 = list("name"=child_names69child_tag69, "override_enabled"=(docking_program.children_override69child_tag69 == "enabled"))

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"airlocks" = airlocks,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "multi_docking_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/docking_port_multi/Topic(href, href_list)
	return



//a docking port based on an airlock
/obj/machinery/embedded_controller/radio/airlock/docking_port_multi
	name = "docking port controller"
	var/master_tag	//for69apping
	var/datum/computer/file/embedded_program/airlock/multi_docking/airlock_program
	tag_secure = 1

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/Initialize()
	. = ..()
	airlock_program = new/datum/computer/file/embedded_program/airlock/multi_docking(src)
	program = airlock_program

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data = list(
		"chamber_pressure" = round(airlock_program.memory69"chamber_sensor_pressure"69),
		"exterior_status" = airlock_program.memory69"exterior_status"69,
		"interior_status" = airlock_program.memory69"interior_status"69,
		"processing" = airlock_program.memory69"processing"69,
		"docking_status" = airlock_program.master_status,
		"airlock_disabled" = (airlock_program.docking_enabled && !airlock_program.override_enabled),
		"override_enabled" = airlock_program.override_enabled,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "docking_airlock_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/clean = FALSE
	switch(href_list69"command"69)
		if("cycle_ext", "cycle_int", "force_ext", "force_int", "abort", "toggle_override")
			clean = TRUE

	if(clean)
		program.receive_user_command(href_list69"command"69)

	return 1



/*** DEBUG69ERBS ***

/datum/computer/file/embedded_program/docking/multi/proc/print_state()
	to_chat(world, "id_tag: 69id_tag69")
	to_chat(world, "dock_state: 69dock_state69")
	to_chat(world, "control_mode: 69control_mode69")
	to_chat(world, "tag_target: 69tag_target69")
	to_chat(world, "response_sent: 69response_sent69")

/datum/computer/file/embedded_program/docking/multi/post_signal(datum/signal/signal, comm_line)
	to_chat(world, "Program 69id_tag69 sent a69essage!")
	print_state()
	to_chat(world, "69id_tag69 sent command \"69signal.data69"command"6969\" to \"69signal.data69"recipient"6969\"")
	..(signal)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/view_state()
	set category = "Debug"
	set src in69iew(1)
	src.program:print_state()

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/spoof_signal(var/command as text,69ar/sender as text)
	set category = "Debug"
	set src in69iew(1)
	var/datum/signal/signal = new
	signal.data69"tag"69 = sender
	signal.data69"command"69 = command
	signal.data69"recipient"69 = id_tag

	src.program:receive_signal(signal)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/debug_init_dock(var/target as text)
	set category = "Debug"
	set src in69iew(1)
	src.program:initiate_docking(target)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/debug_init_undock()
	set category = "Debug"
	set src in69iew(1)
	src.program:initiate_undocking()

*/
