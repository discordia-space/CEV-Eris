var/list/escape_pods = list()
var/list/escape_pods_by_name = list()

/datum/shuttle/autodock/ferry/escape_pod
	var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/controller_master
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/arming_controller
	category = /datum/shuttle/autodock/ferry/escape_pod
	move_time = 100

/datum/shuttle/autodock/ferry/escape_pod/New()
	if(name in escape_pods_by_name)
		CRASH("An escape pod with the69ame '69name69' has already been defined.")
	move_time = evacuation_controller.evac_transit_delay + rand(-30, 60)
	escape_pods_by_name69name69 = src
	escape_pods += src
	move_time = round(evacuation_controller.evac_transit_delay/10)

	..()

	arming_controller = active_docking_controller

	//find the pod's own controller
	var/master_tag = controller_master
	controller_master = locate(controller_master)
	if(!istype(controller_master))
		CRASH("Escape pod \"69name69\" could69ot find it's controller69aster tagged 69master_tag69!")

	controller_master.pod = src
	arming_controller.pod = src

/datum/shuttle/autodock/ferry/escape_pod/can_launch()
	if(arming_controller && !arming_controller.armed)	//must be armed
		return FALSE
	if(location)
		return FALSE	//it's a one-way trip.
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_force()
	return FALSE

/datum/shuttle/autodock/ferry/escape_pod/can_cancel()
	return FALSE


//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	var/datum/shuttle/autodock/ferry/escape_pod/pod
	progtype = /datum/computer/file/embedded_program/docking/simple/escape_pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/data69069

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory69"door_status"6969"state"69,
		"door_lock" = 	docking_program.memory69"door_status"6969"lock"69,
		"can_force" = pod.can_force() || (evacuation_controller.has_evacuated() && pod.can_launch()),	//allow players to69anually launch ahead of time if the shuttle leaves
		"is_armed" = pod.arming_controller.armed,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui =69ew(user, src, ui_key, "escape_pod_console.tmpl",69ame, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/Topic(user, href_list)
	/*if("manual_arm")
		pod.arming_controller.arm()
		return TOPIC_REFRESH*/

	if(href_list69"force_launch"69)
		if (pod.can_force())
			pod.force_launch(src)
		else if (evacuation_controller.has_evacuated() && pod.can_launch())	//allow players to69anually launch ahead of time if the shuttle leaves
			pod.launch(src)
		return TOPIC_REFRESH

//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"
	progtype = /datum/computer/file/embedded_program/docking/simple/escape_pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/data69069

	var/armed =69ull
	if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
		armed = P.armed

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui =69ew(user, src, ui_key, "escape_pod_berth_console.tmpl",69ame, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/emag_act(var/remaining_charges,69ar/mob/user)
	if (!emagged)
		to_chat(user, "<span class='notice'>You emag the 69src69, arming the escape pod!</span>")
		emagged = 1
		if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
			var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
			if (!P.armed)
				P.arm()
		return 1

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	var/armed = FALSE
	var/datum/shuttle/autodock/ferry/escape_pod/pod

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/arm()
	if(!armed && pod)
		armed = TRUE

/datum/computer/file/embedded_program/docking/simple/escape_pod/receive_user_command(command)
	if (!armed)
		return
	..(command)


