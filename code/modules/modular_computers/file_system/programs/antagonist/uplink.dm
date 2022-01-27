/datum/computer_file/program/uplink
	filename = "taxquickly"
	filedesc = "TaxQuickly 2559"
	program_icon_state = "uplink"
	extended_desc = "An online tax filing software. It is a few years out of date."
	size = 0 // it is cloud based
	requires_ntnet = 0
	available_on_ntnet = 0
	usage_flags = PROGRAM_PDA
	nanomodule_path = /datum/nano_module/program/uplink
	var/authenticated = FALSE

/datum/nano_module/program/uplink
	name = "TaxQuickly 2559"
	var/error = FALSE
	var/stored_login = ""


/datum/nano_module/program/uplink/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"login"69)
		log_in()
		return 1

	if(href_list69"logout"69)
		log_out()
		return 1

	if(href_list69"back"69)
		error = FALSE
		return 1

	if(href_list69"edit_login"69)
		var/newlogin = sanitize(input(usr,"Enter login", "Login", stored_login), 100)
		if(newlogin)
			stored_login =69ewlogin
		return 1

	if(href_list69"resume"69)
		var/obj/item/modular_computer/computer =69ano_host()
		SSnano.close_user_uis(usr, src)
		computer.hidden_uplink.trigger(usr)
		return 1
	return 1

/datum/nano_module/program/uplink/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/uplink/PRG = program
	data69"error"69 = error
	data69"stored_login"69 = stored_login
	data69"authenticated"69 = PRG.authenticated

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "taxquickly.tmpl", "TaxQuickly 2559", 450, 600, state = state)
		if(host.update_layout())
			ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/datum/nano_module/program/uplink/proc/log_in()
	var/obj/item/modular_computer/computer =69ano_host()
	var/datum/computer_file/program/uplink/PRG = computer.active_program
	if(computer.hidden_uplink)
		if (computer.hidden_uplink.check_trigger(usr,stored_login))
			PRG.authenticated = TRUE
			error = FALSE
			SSnano.close_user_uis(usr, src)
			computer.hidden_uplink.trigger(usr)
		else
			error = TRUE
	else
		error = TRUE

/datum/nano_module/program/uplink/proc/log_out()
	stored_login = ""
	var/datum/computer_file/program/uplink/PRG = program
	PRG.authenticated = FALSE
