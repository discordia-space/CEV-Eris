/obj/item/device/assembly/signaler
	name = "remote signaling device"
	desc = "Used to remotely activate devices."
	icon_state = "signaller"
	item_state = "signaler"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 1)
	wires = WIRE_RECEIVE | WIRE_PULSE | WIRE_RADIO_PULSE | WIRE_RADIO_RECEIVE

	secured = 1

	var/code = 30
	var/frequency = 1457
	var/delay = 0
	var/airlock_wire
	var/datum/wires/connected
	var/datum/radio_frequency/radio_connection
	var/deadman = 0

/obj/item/device/assembly/signaler/New()
	..()
	spawn(40)
		set_frequency(frequency)
	return


/obj/item/device/assembly/signaler/activate()
	if(cooldown > 0)	return 0
	cooldown = 2
	spawn(10)
		process_cooldown()

	signal()
	return 1

/obj/item/device/assembly/signaler/update_icon()
	if(holder)
		holder.update_icon()
	return

/obj/item/device/assembly/signaler/proc/set_code(new_code)
	code = clamp(round(new_code), 1, 100)

/obj/item/device/assembly/signaler/proc/set_freq(new_freq)
	set_frequency(sanitize_frequency(round(new_freq), RADIO_LOW_FREQ, RADIO_HIGH_FREQ))

/obj/item/device/assembly/signaler/interact(mob/user, flag1)
	ui_interact(user)

/obj/item/device/assembly/signaler/ui_data()
	var/list/data = list(
		"freq" = frequency,
		"code" = code
		)
	return data

/obj/item/device/assembly/signaler/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "mpc_signaller.tmpl", name, 350, 200, state = state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/assembly/signaler/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"signal"69)
		set_freq(text2num(href_list69"freq"69))
		set_code(text2num(href_list69"code"69))

		spawn(0)
			signal()
		return 1

	if(href_list69"change_code"69)
		set_code(code + text2num(href_list69"change_code"69))
		return 1

	if(href_list69"edit_code"69)
		var/input_code = input("Enter signal code (1-100):", "Signal parameters", code) as num|null
		if(input_code && CanUseTopic(usr))
			set_code(input_code)
		return 1

	if(href_list69"change_freq"69)
		set_freq(frequency + text2num(href_list69"change_freq"69))
		return 1

	if(href_list69"edit_freq"69)
		var/input_freq = input("Enter signal frequency (69RADIO_LOW_FREQ69-69RADIO_HIGH_FREQ69):", "Signal parameters", frequency) as num|null
		if(input_freq && CanUseTopic(usr))
			if(input_freq < RADIO_LOW_FREQ) // A decimal input69aybe?
				input_freq *= 10

			set_freq(input_freq)
		return 1


/obj/item/device/assembly/signaler/proc/signal()
	if(!radio_connection)
		return

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data69"message"69 = "ACTIVATE"
	radio_connection.post_signal(src, signal)


/obj/item/device/assembly/signaler/pulse(var/radio = 0)
	if(src.connected && src.wires)
		connected.Pulse(src)
	else if(holder)
		holder.process_activation(src, 1, 0)
	else
		..(radio)


/obj/item/device/assembly/signaler/receive_signal(datum/signal/signal)
	if(!signal)
		return
	if(signal.encryption != code)
		return
	if(!(src.wires & WIRE_RADIO_RECEIVE))
		return
	pulse(1)

	if(!holder)
		for(var/mob/O in hearers(1, src.loc))
			O.show_message("\icon69src69 *beep* *beep*", 3, "*beep* *beep*", 2)


/obj/item/device/assembly/signaler/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)
	return


/obj/item/device/assembly/signaler/Process()
	if(!deadman)
		STOP_PROCESSING(SSobj, src)
	var/mob/M = src.loc
	if(!M || !ismob(M))
		if(prob(5))
			signal()
		deadman = 0
		STOP_PROCESSING(SSobj, src)
	else if(prob(5))
		M.visible_message("69M69's finger twitches a bit over 69src69's signal button!")
	return


/obj/item/device/assembly/signaler/verb/deadman_it()
	set src in usr
	set name = "Threaten to push the button!"
	set desc = "BOOOOM!"
	deadman = 1
	START_PROCESSING(SSobj, src)
	log_and_message_admins("is threatening to trigger a signaler deadman's switch")
	usr.visible_message("\red 69usr6969oves their finger over 69src69's signal button...")

/obj/item/device/assembly/signaler/Destroy()
	SSradio.remove_object(src,frequency)
	frequency = 0
	. = ..()
