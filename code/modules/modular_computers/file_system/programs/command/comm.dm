#define STATE_DEFAULT	1
#define STATE_MESSAGELIST	2
#define STATE_VIEWMESSAGE	3
#define STATE_STATUSDISPLAY	4
#define STATE_ALERT_LEVEL	5
/datum/computer_file/program/comm
	filename = "comm"
	filedesc = "Command and Communications Program"
	program_icon_state = "comm"
	program_key_state = "med_key"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/comm
	extended_desc = "Used to command and control. Can relay long-range communications. This program can69ot be run on tablet computers."
	required_access = access_heads
	requires_ntnet = 1
	size = 12
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	network_destination = "long-range communication array"
	var/datum/comm_message_listener/message_core =69ew

/datum/computer_file/program/comm/clone()
	var/datum/computer_file/program/comm/temp = ..()
	temp.message_core.messages =69ull
	temp.message_core.messages =69essage_core.messages.Copy()
	return temp

/datum/nano_module/program/comm
	name = "Command and Communications Program"
	available_to_ai = TRUE
	var/current_status = STATE_DEFAULT
	var/msg_line1 = ""
	var/msg_line2 = ""
	var/centcom_message_cooldown = 0
	var/announcment_cooldown = 0
	var/datum/announcement/priority/crew_announcement =69ew
	var/current_viewing_message_id = 0
	var/current_viewing_message =69ull

/datum/nano_module/program/comm/New()
	..()
	crew_announcement.newscast = 1

/datum/nano_module/program/comm/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)

	var/list/data = host.initial_data()

	if(program)
		data69"emagged"69 = program.computer_emagged
		data69"net_comms"69 = !!program.get_signal(NTNET_COMMUNICATION) //Double !! is69eeded to get 1 or 0 answer
		data69"net_syscont"69 = !!program.get_signal(NTNET_SYSTEMCONTROL)
		if(program.computer)
			data69"have_printer"69 = !!program.computer.printer
		else
			data69"have_printer"69 = 0
	else
		data69"emagged"69 = 0
		data69"net_comms"69 = 1
		data69"net_syscont"69 = 1
		data69"have_printer"69 = 0

	data69"message_line1"69 =69sg_line1
	data69"message_line2"69 =69sg_line2
	data69"state"69 = current_status
	data69"isAI"69 = issilicon(usr)
	data69"authenticated"69 = is_autenthicated(user)
	//data69"boss_short"69 = GLOB.maps_data.boss_short

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
	data69"current_security_level_ref"69 = any2ref(security_state.current_security_level)
	data69"current_security_level_title"69 = security_state.current_security_level.name

	data69"cannot_change_security_level"69 = !security_state.can_change_security_level()
	var/list/security_levels = list()
	for(var/decl/security_level/security_level in security_state.comm_console_security_levels)
		var/list/security_setup = list()
		security_setup69"title"69 = security_level.name
		security_setup69"ref"69 = any2ref(security_level)
		security_levels69++security_levels.len69 = security_setup
	data69"security_levels"69 = security_levels
/*
	var/datum/comm_message_listener/l = obtain_message_listener()
	data69"messages"69 = l.messages
	data69"message_deletion_allowed"69 = l != global_message_listener
	data69"message_current_id"69 = current_viewing_message_id
	if(current_viewing_message)
		data69"message_current"69 = current_viewing_message
*/
	var/list/processed_evac_options = list()
	if(!isnull(evacuation_controller))
		for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
			var/list/option = list()
			option69"option_text"69 = EO.option_text
			option69"option_target"69 = EO.option_target
			option69"needs_syscontrol"69 = EO.needs_syscontrol
			option69"silicon_allowed"69 = EO.silicon_allowed
			processed_evac_options69++processed_evac_options.len69 = option
	data69"evac_options"69 = processed_evac_options

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, "communication.tmpl",69ame, 550, 420, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/comm/proc/is_autenthicated(var/mob/user)
	if(program)
		return program.can_run(user)
	return 1

/datum/nano_module/program/comm/proc/obtain_message_listener()
	if(program)
		var/datum/computer_file/program/comm/P = program
		return P.message_core
	return global_message_listener

/datum/nano_module/program/comm/Topic(href, href_list)
	if(..())
		return 1
	var/mob/user = usr
	var/ntn_comm = program ? !!program.get_signal(NTNET_COMMUNICATION) : 1
	var/ntn_cont = program ? !!program.get_signal(NTNET_SYSTEMCONTROL) : 1
	var/datum/comm_message_listener/l = obtain_message_listener()
	switch(href_list69"action"69)
		if("sw_menu")
			. = 1
			current_status = text2num(href_list69"target"69)
		if("announce")
			. = 1
			if(is_autenthicated(user) && !issilicon(usr) &&69tn_comm)
				if(user)
					var/obj/item/card/id/id_card = user.GetIdCard()
					crew_announcement.announcer = GetNameAndAssignmentFromId(id_card)
				else
					crew_announcement.announcer = "Unknown"
				if(announcment_cooldown)
					to_chat(usr, "Please allow at least one69inute to pass between announcements")
					return TRUE
				var/input = input(usr, "Please write a69essage to announce to the 69station_name()69.", "Priority Announcement") as69ull|text
				if(!input || !can_still_topic())
					return 1
				if(GLOB.in_character_filter.len) //I don't want to read announcements about sending people to brazil.
					if(findtext(input, config.ic_filter_regex))
						to_chat(usr, SPAN_WARNING("You think better of announcing something so foolish."))
						return 1

				var/affected_zlevels = GLOB.maps_data.contact_levels
				var/atom/A = host
				if(istype(A))
					affected_zlevels = GetConnectedZlevels(A.z)
				crew_announcement.Announce(input, zlevels = affected_zlevels)
				announcment_cooldown = 1
				spawn(600)//One69inute cooldown
					announcment_cooldown = 0

		/*
		if("message")
			. = 1
			if(href_list69"target"69 == "emagged")
				if(program)
					if(is_autenthicated(user) && program.computer_emagged && !issilicon(usr) &&69tn_comm)
						if(centcom_message_cooldown)
							to_chat(usr, "<span class='warning'>Arrays recycling. Please stand by.</span>")
							SSnano.update_uis(src)
							return
						var/input = sanitize(input(usr, "Please choose a69essage to transmit to \69ABNORMAL ROUTING CORDINATES\6969ia quantum entanglement.  Please be aware that this process is69ery expensive, and abuse will lead to... termination. Transmission does69ot guarantee a response. There is a 30 second delay before you69ay send another69essage, be clear, full and concise.", "To abort, send an empty69essage.", "") as69ull|text)
						if(!input || !can_still_topic())
							return 1
						//Syndicate_announce(input, usr)	TODO : THIS
						to_chat(usr, "<span class='notice'>Message transmitted.</span>")
						log_say("69key_name(usr)69 has69ade an illegal announcement: 69input69")
						centcom_message_cooldown = 1
						spawn(300)//30 second cooldown
							centcom_message_cooldown = 0
			else if(href_list69"target"69 == "regular")
				if(is_autenthicated(user) && !issilicon(usr) &&69tn_comm)
					if(centcom_message_cooldown)
						to_chat(usr, "<span class='warning'>Arrays recycling. Please stand by.</span>")
						SSnano.update_uis(src)
						return
					if(!is_relay_online())//Contact Centcom has a check, Syndie doesn't to allow for Contractor funs.
						to_chat(usr, "<span class='warning'>No Emergency Bluespace Relay detected. Unable to transmit69essage.</span>")
						return 1

					var/input = sanitize(input("Please choose a69essage to transmit to 69GLOB.maps_data.boss_short6969ia quantum entanglement.  Please be aware that this process is69ery expensive, and abuse will lead to... termination.  Transmission does69ot guarantee a response. There is a 30 second delay before you69ay send another69essage, be clear, full and concise.", "To abort, send an empty69essage.", "") as69ull|text)
					if(!input || !can_still_topic())
						return 1
					Centcom_announce(input, usr)
					to_chat(usr, "<span class='notice'>Message transmitted.</span>")
					log_say("69key_name(usr)69 has69ade an IA 69GLOB.maps_data.boss_short69 announcement: 69input69")
					centcom_message_cooldown = 1
					spawn(300) //30 second cooldown
						centcom_message_cooldown = 0

						*/
		if("evac")
			. = 1
			if(is_autenthicated(user))
				var/datum/evacuation_option/selected_evac_option = evacuation_controller.evacuation_options69href_list69"target"6969
				if (isnull(selected_evac_option) || !istype(selected_evac_option))
					return
				if (!selected_evac_option.silicon_allowed && issilicon(user))
					return
				if (selected_evac_option.needs_syscontrol && !ntn_cont)
					return
				var/confirm = alert("Are you sure you want to 69selected_evac_option.option_desc69?",69ame, "No", "Yes")
				if (confirm == "Yes" && can_still_topic())
					evacuation_controller.handle_evac_option(selected_evac_option.option_target, user)
		if("setstatus")
			. = 1
			if(is_autenthicated(user) &&69tn_cont)
				switch(href_list69"target"69)
					if("line1")
						var/linput = reject_bad_text(sanitize(input("Line 1", "Enter69essage Text",69sg_line1) as text|null, 40), 40)
						if(can_still_topic())
							msg_line1 = linput
					if("line2")
						var/linput = reject_bad_text(sanitize(input("Line 2", "Enter69essage Text",69sg_line2) as text|null, 40), 40)
						if(can_still_topic())
							msg_line2 = linput
					if("message")
						post_status("message",69sg_line1,69sg_line2)
					if("image")
						post_status("image", href_list69"image"69)
					else
						post_status(href_list69"target"69)
		if("setalert")
			. = 1
			if(is_autenthicated(user) && !issilicon(usr) &&69tn_cont &&69tn_comm)
				var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
				var/decl/security_level/target_level = locate(href_list69"target"69) in security_state.comm_console_security_levels
				if(target_level && security_state.can_switch_to(target_level))
					var/confirm = alert("Are you sure you want to change the alert level to 69target_level.name69?",69ame, "No", "Yes")
					if(confirm == "Yes" && can_still_topic())
						security_state.set_security_level(target_level)
			else
				to_chat(usr, "You press the button, but a red light flashes and69othing happens.") //This should69ever happen

			current_status = STATE_DEFAULT
		if("viewmessage")
			. = 1
			if(is_autenthicated(user) &&69tn_comm)
				current_viewing_message_id = text2num(href_list69"target"69)
				for(var/list/m in l.messages)
					if(m69"id"69 == current_viewing_message_id)
						current_viewing_message =69
				current_status = STATE_VIEWMESSAGE
		if("delmessage")
			. = 1
			if(is_autenthicated(user) &&69tn_comm && l != global_message_listener)
				l.Remove(current_viewing_message)
			current_status = STATE_MESSAGELIST
		if("printmessage")
			. = 1
			if(is_autenthicated(user) &&69tn_comm)
				if(program && program.computer && program.computer.printer)
					if(!program.computer.printer.print_text(current_viewing_message69"contents"69,current_viewing_message69"title"69))
						to_chat(usr, "<span class='notice'>Hardware Error: Printer was unable to print the selected file.</span>")
					else
						program.computer.visible_message("<span class='notice'>\The 69program.computer69 prints out a paper.</span>")

#undef STATE_DEFAULT
#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_STATUSDISPLAY
#undef STATE_ALERT_LEVEL

/*
General69essage handling stuff
*/
var/list/comm_message_listeners = list() //We first have to initialize list then we can use it.
var/datum/comm_message_listener/global_message_listener =69ew //May be used by admins
var/last_message_id = 0

/proc/get_comm_message_id()
	last_message_id = last_message_id + 1
	return last_message_id

/proc/post_comm_message(var/message_title,69ar/message_text)
	var/list/message = list()
	message69"id"69 = get_comm_message_id()
	message69"title"69 =69essage_title
	message69"contents"69 =69essage_text

	for (var/datum/comm_message_listener/l in comm_message_listeners)
		l.Add(message)

/datum/comm_message_listener
	var/list/messages

/datum/comm_message_listener/New()
	..()
	messages = list()
	comm_message_listeners.Add(src)

/datum/comm_message_listener/proc/Add(var/list/message)
	messages69++messages.len69 =69essage

/datum/comm_message_listener/proc/Remove(var/list/message)
	messages -= list(message)

/proc/post_status(var/command,69ar/data1,69ar/data2)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal =69ew
	status_signal.transmission_method = 1
	status_signal.data69"command"69 = command

	switch(command)
		if("message")
			status_signal.data69"msg1"69 = data1
			status_signal.data69"msg2"69 = data2
			log_admin("STATUS: 69key_name(usr)69 set status screen69essage with : 69data169 69data269")
		if("image")
			status_signal.data69"picture_state"69 = data1

	frequency.post_signal( signal = status_signal )

/proc/cancel_call_proc(var/mob/user)
	if (!SSticker || !evacuation_controller)
		return

	if(evacuation_controller.cancel_evacuation())
		log_game("69key_name(user)69 has cancelled the evacuation.")
		message_admins("69key_name_admin(user)69 has cancelled the evacuation.", 1)

	return


/proc/is_relay_online()
	for(var/obj/machinery/bluespacerelay/M in GLOB.machines)
		if(M.stat == 0)
			return 1
	return 0

/proc/call_shuttle_proc(var/mob/user,69ar/emergency)
	if (!SSticker || !evacuation_controller)
		return

	if(isnull(emergency))
		emergency = 1

	if(universe.OnShuttleCall(usr))
		to_chat(user, "<span class='notice'>Cannot establish a bluespace connection.</span>")
		return
/*
	if(GLOB.deathsquad.deployed)
		to_chat(user, "69GLOB.maps_data.boss_short69 will69ot allow an evacuation to take place. Consider all contracts terminated.")
		return
*/
	if(evacuation_controller.deny)
		to_chat(user, "An evacuation cannot be called at this time. Please try again later.")
		return

	if(evacuation_controller.is_on_cooldown()) // Ten69inute grace period to let the game get going without lolmetagaming. -- TLE
		to_chat(user, evacuation_controller.get_cooldown_message())

	if(evacuation_controller.is_evacuating())
		to_chat(user, "An evacuation is already underway.")
		return

	if(evacuation_controller.call_evacuation(user, _emergency_evac = emergency))
		log_and_message_admins("69user? key_name(user) : "Autotransfer"69 has called the shuttle.")

/proc/init_autotransfer()

	if (!SSticker || !evacuation_controller)
		return

	. = evacuation_controller.call_evacuation(null, _emergency_evac = FALSE, autotransfer = TRUE)
