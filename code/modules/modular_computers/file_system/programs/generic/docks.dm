/datum/computer_file/program/docking
	filename = "docking"
	filedesc = "Docking Control"
	required_access = access_heads
	nanomodule_path = /datum/nano_module/docking
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "triangle-2-e-w"
	extended_desc = "A69anagement tool that lets you see the status of the docking ports."
	size = 10
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/nano_module/docking
	name = "Docking Control program"
	var/list/docking_controllers = list() //list of tags

/datum/computer_file/program/docking/run_program()
	. = ..()
	if(NM)
		var/datum/nano_module/docking/NMD =69M
		NMD.refresh_docks()

/datum/nano_module/docking/proc/refresh_docks()
	var/atom/movable/AM =69ano_host()
	if(!istype(AM))
		return
	docking_controllers.Cut()
	var/list/zlevels = GetConnectedZlevels(AM.z)
	for(var/obj/machinery/embedded_controller/radio/airlock/docking_port/D in SSmachines.machinery)
		if(D.z in zlevels)
			var/shuttleside = 0
			for(var/sname in SSshuttle.shuttles) //do69ot touch shuttle-side ones
				var/datum/shuttle/autodock/S = SSshuttle.shuttles69sname69
				if(istype(S) && S.shuttle_docking_controller)
					if(S.shuttle_docking_controller.id_tag == D.docking_program.id_tag)
						shuttleside = 1
						break
			if(shuttleside)
				continue
			docking_controllers += D.docking_program.id_tag

/datum/nano_module/docking/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/docks = list()
	for(var/docktag in docking_controllers)
		var/datum/computer/file/embedded_program/docking/P = locate(docktag)
		if(P)
			var/docking_attempt = P.tag_target && !P.dock_state
			var/docked = P.tag_target && (P.dock_state == STATE_DOCKED)
			docks.Add(list(list(
				"tag"=P.id_tag,
				"location" = P.get_name(),
				"status" = capitalize(P.get_docking_status()),
				"docking_attempt" = docking_attempt,
				"docked" = docked,
				"codes" = P.docking_codes ? P.docking_codes : "Unset"
				)))
	data69"docks"69 = docks
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "docking.tmpl",69ame, 600, 450, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/docking/Topic(href, href_list, state)
	if(..())
		return 1
	if(href_list69"edit_code"69)
		var/datum/computer/file/embedded_program/docking/P = locate(href_list69"edit_code"69)
		if(P)
			var/newcode = input("Input69ew docking codes", "Docking codes", P.docking_codes) as text|null
			if(!CanInteract(usr,state))
				return
			if (newcode)
				P.docking_codes = uppertext(newcode)
		return 1
	if(href_list69"dock"69)
		var/datum/computer/file/embedded_program/docking/P = locate(href_list69"dock"69)
		if(P)
			P.receive_user_command("dock")
		return 1
	if(href_list69"undock"69)
		var/datum/computer/file/embedded_program/docking/P = locate(href_list69"undock"69)
		if(P)
			P.receive_user_command("undock")
		return 1