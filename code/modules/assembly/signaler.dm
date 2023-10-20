#define SIGNALER_DEFAULT_CODE      30
#define SIGNALER_DEFAULT_FREQUENCY 1457

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


/obj/item/device/assembly/signaler/ui_status(mob/user)
	if(is_secured(user))
		return ..()

	return UI_CLOSE


/obj/item/device/assembly/signaler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Signaler", name)
		ui.open()


/obj/item/device/assembly/signaler/ui_data(mob/user)
	var/list/data = list(
		"maxFrequency" = RADIO_HIGH_FREQ,
		"minFrequency" = RADIO_LOW_FREQ,
		"frequency" = frequency,
		"code" = code
		)
	return data


/obj/item/device/assembly/signaler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("signal")
			signal()
			. = TRUE
		if("adjust")
			if(params["freq"])
				var/value = params["freq"]
				set_freq(frequency + value)
				. = TRUE
			else if(params["code"])
				var/value = params["code"]
				set_code(code + value)
				. = TRUE
		if("reset")
			if(params["freq"])
				frequency = SIGNALER_DEFAULT_FREQUENCY
				. = TRUE
			else if(params["code"])
				code = SIGNALER_DEFAULT_CODE
				. = TRUE


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

#undef SIGNALER_DEFAULT_FREQUENCY
#undef SIGNALER_DEFAULT_CODE
