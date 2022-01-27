/datum/computer_file/program/signaller
	filename = "signalman"
	filedesc = "Signal69anager"
	extended_desc = "A tool that uses a wireless69etwork card to send simple control signals."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "signal-diag"
	size = 4
	requires_ntnet = 0
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL

	var/code = 30
	var/max_saved = 10
	var/list/saved_signals = list()

/datum/computer_file/program/signaller/clone()
	var/datum/computer_file/program/signaller/F = ..()
	F.code = code
	for(var/list/L in saved_signals)
		F.saved_signals.Add(list(L.Copy()))
	return F

/datum/computer_file/program/signaller/is_supported_by_hardware(obj/item/modular_computer/hardware,69ob/user, loud)
	if(!..())
		return FALSE

	if(!hardware?.network_card.check_functionality() || hardware.network_card.ethernet)
		if(loud)
			to_chat(user, SPAN_WARNING("Hardware Error - Wireless69etwork card required"))
		return FALSE

	return TRUE

/datum/computer_file/program/signaller/ui_data()
	var/list/data = computer.get_header_data()

	data69"freq"69 = computer?.network_card.frequency
	data69"code"69 = code
	data69"max_saved"69 =69ax_saved
	data69"saved_signals"69 = saved_signals

	return data


/datum/computer_file/program/signaller/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open =69ANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_signaller.tmpl", filedesc, 450, 600, state = state)
		ui.set_initial_data(data)
		ui.open()


/datum/computer_file/program/signaller/Topic(href, href_list)
	if(..())
		return 1

	if(!computer?.network_card.check_functionality())
		to_chat(usr, SPAN_WARNING("Hardware Error -69etwork card failure"))
		return 1

	if(href_list69"signal"69)
		computer.network_card.signal(text2num(href_list69"freq"69), text2num(href_list69"code"69))
		return 1

	if(href_list69"change_code"69)
		code = clamp(round(code + text2num(href_list69"change_code"69)), 1, 100)
		return 1

	if(href_list69"edit_code"69)
		var/input_code = input("Enter signal code (1-100):", "Signal parameters", code) as69um|null
		if(input_code && CanUseTopic(usr))
			code = clamp(round(input_code), 1, 100)
		return 1

	if(href_list69"change_freq"69)
		computer.network_card.set_frequency(computer.network_card.frequency + text2num(href_list69"change_freq"69))
		return 1

	if(href_list69"edit_freq"69)
		var/input_freq = input("Enter signal frequency (69RADIO_LOW_FREQ69-69RADIO_HIGH_FREQ69):", "Signal parameters", computer.network_card.frequency) as69um|null
		if(input_freq && CanUseTopic(usr) && computer && computer.network_card)
			if(input_freq < RADIO_LOW_FREQ) // A decimal input69aybe?
				input_freq *= 10

			computer.network_card.set_frequency(round(input_freq))
		return 1

	if(href_list69"save_signal"69)
		if(length(saved_signals) >=69ax_saved)
			return 1
		saved_signals.Add(list(list("freq"=computer.network_card.frequency, "code"=code)))
		return 1

	if(href_list69"delete_signal"69)
		var/delete_index = clamp(round(text2num(href_list69"PRG_delete_signal"69)), 1, length(saved_signals))
		saved_signals.Cut(delete_index, delete_index+1)
		return 1

/datum/computer_file/program/signaller/proc/receive_signal(datum/signal/signal)
	if(signal.encryption == code)
		for(var/mob/O in hearers(1, computer.loc))
			O.show_message("\icon69computer69 *beep* *beep*", 3, "*beep* *beep*", 2)
