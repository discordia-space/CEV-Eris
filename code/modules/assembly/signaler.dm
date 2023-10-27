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
	nano_ui_interact(user)

/obj/item/device/assembly/signaler/nano_ui_data()
	var/list/data = list(
		"freq" = frequency,
		"code" = code
		)
	return data

/obj/item/device/assembly/signaler/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/nano_topic_state/state = GLOB.default_state)
	var/list/data = nano_ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "mpc_signaller.tmpl", name, 350, 200, state = state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/assembly/signaler/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["signal"])
		set_freq(text2num(href_list["freq"]))
		set_code(text2num(href_list["code"]))

		spawn(0)
			signal()
		return 1

	if(href_list["change_code"])
		set_code(code + text2num(href_list["change_code"]))
		return 1

	if(href_list["edit_code"])
		var/input_code = input("Enter signal code (1-100):", "Signal parameters", code) as num|null
		if(input_code && CanUseTopic(usr))
			set_code(input_code)
		return 1

	if(href_list["change_freq"])
		set_freq(frequency + text2num(href_list["change_freq"]))
		return 1

	if(href_list["edit_freq"])
		var/input_freq = input("Enter signal frequency ([RADIO_LOW_FREQ]-[RADIO_HIGH_FREQ]):", "Signal parameters", frequency) as num|null
		if(input_freq && CanUseTopic(usr))
			if(input_freq < RADIO_LOW_FREQ) // A decimal input maybe?
				input_freq *= 10

			set_freq(input_freq)
		return 1


/obj/item/device/assembly/signaler/proc/signal()
	if(!radio_connection)
		return

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = "ACTIVATE"
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
			O.show_message("\icon[src] *beep* *beep*", 3, "*beep* *beep*", 2)


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
		M.visible_message("[M]'s finger twitches a bit over [src]'s signal button!")
	return


/obj/item/device/assembly/signaler/verb/deadman_it()
	set src in usr
	set name = "Threaten to push the button!"
	set desc = "BOOOOM!"
	deadman = 1
	START_PROCESSING(SSobj, src)
	log_and_message_admins("is threatening to trigger a signaler deadman's switch")
	usr.visible_message("\red [usr] moves their finger over [src]'s signal button...")

/obj/item/device/assembly/signaler/Destroy()
	SSradio.remove_object(src,frequency)
	frequency = 0
	. = ..()

/obj/item/device/assembly/signaler/door_controller
	name = "remote door signaling device"
	desc = "Used to remotely activate doors. 2 Beeps for opened ,1 for closed ,0 for no answer. Alt-Click to change Mode , Ctrl-Click to change code."
	icon_state = "signaller"
	item_state = "signaler"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 1)
	wires = WIRE_RECEIVE | WIRE_PULSE | WIRE_RADIO_PULSE | WIRE_RADIO_RECEIVE
	spawn_blacklisted = TRUE

	secured = TRUE
	code = 0
	frequency = BLAST_DOOR_FREQ
	delay = 1

	var/last_message = 0
	var/command = "CMD_DOOR_TOGGLE"

/obj/item/device/assembly/signaler/door_controller/set_frequency(new_frequency)
	SSradio.remove_object(src, BLAST_DOOR_FREQ)
	frequency = BLAST_DOOR_FREQ
	radio_connection = SSradio.add_object(src, BLAST_DOOR_FREQ, RADIO_BLASTDOORS)

// No nanoUI for u
/obj/item/device/assembly/signaler/door_controller/nano_ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nano_topic_state/state)
	return FALSE

/obj/item/device/assembly/signaler/door_controller/receive_signal(datum/signal/signal)
	if(!signal)
		return
	if(signal.encryption != code)
		return
	if(!(src.wires & WIRE_RADIO_RECEIVE))
		return
	pulse(1)
	/// prevent spam if theres multiple doors.
	if(last_message > world.timeofday)
		return
	var/local_message = ""
	switch(signal.data["message"])
		if("DATA_DOOR_OPENED")
			local_message = "\icon[src] beeps twice."
		if("DATA_DOOR_CLOSED")
			local_message = "\icon[src] beeps once."
		if("CMD_DOOR_OPEN")
		if("CMD_DOOR_CLOSE")
		if("CMD_DOOR_TOGGLE")
		else
			local_message = "\icon[src] beeps omniously."
	last_message = world.timeofday + 1 SECONDS

	for(var/mob/O in hearers(1, src.loc))
		O.show_message(local_message, 3, "*beep* *beep*", 2)

/obj/item/device/assembly/signaler/door_controller/AltClick(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.stat)
		return
	if(!Adjacent(user,2))
		return
	var/option = input(user, "Choose signalling mode", "[src] configuration", "Toggle") as anything in list("Toggle", "Close", "Open")
	if(!istype(user))
		return
	if(user.stat)
		return
	if(!Adjacent(user,2))
		return
	switch(option)
		if("Toggle")
			command = "CMD_DOOR_TOGGLE"
		if("Close")
			command = "CMD_DOOR_CLOSE"
		if("Open")
			command = "CMD_DOOR_OPEN"
	to_chat(user, SPAN_NOTICE("You change [src]'s signalling mode to [option]"))

/obj/item/device/assembly/signaler/door_controller/CtrlClick(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.stat)
		return
	if(!Adjacent(user,2))
		return
	var/option = input(user, "Choose signaller code", "[src] configuration", 1) as num
	if(!istype(user))
		return
	if(user.stat)
		return
	if(!Adjacent(user,2))
		return
	code = clamp(input, 0, 1000)
	to_chat(user, SPAN_NOTICE("You change [src]'s code to [option]"))


/obj/item/device/assembly/signaler/door_controller/attack_hand(mob/user)
	if(!..())
		return
	signal()


/// data is expected to be a list
/obj/item/device/assembly/signaler/door_controller/signal(list/data)
	if(!radio_connection)
		return

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = command
	radio_connection.post_signal(src, signal, RADIO_BLASTDOORS)
