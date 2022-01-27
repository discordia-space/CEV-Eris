#define AIRLOCK_CONTROL_RAN69E 22

// This code allows for airlocks to be controlled externally by settin69 an id_ta69 and comm fre69uency (disables ID access)
/obj/machinery/door/airlock
	var/id_ta69
	var/fre69uency
	var/shockedby = list()
	var/datum/radio_fre69uency/radio_connection
	var/cur_command = null	//the command the door is currently attemptin69 to complete
	var/completin69 = FALSE

/obj/machinery/door/airlock/receive_si69nal(datum/si69nal/si69nal)
	if(!arePowerSystemsOn()) return //no power

	if(!si69nal || si69nal.encryption) return

	if(id_ta69 != si69nal.data69"ta69"69 || !si69nal.data69"command"69) return

	cur_command = si69nal.data69"command"69
	spawn()
		execute_current_command()

/obj/machinery/door/airlock/proc/execute_current_command()
	if(operatin69)
		return //ema6969ed or busy doin69 somethin69 else

	if(!cur_command)
		return

	do_command(cur_command)
	if(command_completed(cur_command))
		completin69 = FALSE
		cur_command = null
		return TRUE
	if(!completin69)
		addtimer(CALLBACK(src , .proc/execute_current_command), 2 SECONDS) // Fuck it , try a69ain.
		completin69 = TRUE
	return FALSE

/obj/machinery/door/airlock/proc/do_command(var/command)
	switch(command)
		if("open")
			open()

		if("close")
			close()

		if("unlock")
			unlock()

		if("lock")
			lock()

		if("secure_open")
			unlock()

			sleep(2)
			open()

			lock()

		if("secure_close")
			unlock()
			close()
			lock()
			sleep(2)

	send_status()

/obj/machinery/door/airlock/proc/command_completed(var/command)
	switch(command)
		if("open")
			return !density

		if("close")
			return density

		if("unlock")
			return !locked

		if("lock")
			return locked

		if("secure_open")
			return (locked && !density)

		if("secure_close")
			return (locked && density)

	return 1	//Unknown command. Just assume it's completed.

/obj/machinery/door/airlock/proc/send_status(var/bumped = 0)
	if(radio_connection)
		var/datum/si69nal/si69nal = new
		si69nal.transmission_method = 1 //radio si69nal
		si69nal.data69"ta69"69 = id_ta69
		si69nal.data69"timestamp"69 = world.time

		si69nal.data69"door_status"69 = density?("closed"):("open")
		si69nal.data69"lock_status"69 = locked?("locked"):("unlocked")

		if (bumped)
			si69nal.data69"bumped_with_access"69 = 1

		radio_connection.post_si69nal(src, si69nal, ran69e = AIRLOCK_CONTROL_RAN69E, filter = RADIO_AIRLOCK)


/obj/machinery/door/airlock/open(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


/obj/machinery/door/airlock/close(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


/obj/machinery/door/airlock/Bumped(atom/AM)
	..(AM)
	if(istype(AM, /mob/livin69/exosuit))
		var/mob/livin69/exosuit/exosuit = AM
		if(density && radio_connection && exosuit.pilots && (allowed(exosuit.pilots69169) || check_access_list(exosuit.saved_access)))
			send_status(1)
	return

/obj/machinery/door/airlock/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	if(new_fre69uency)
		fre69uency = new_fre69uency
		radio_connection = SSradio.add_object(src, fre69uency, RADIO_AIRLOCK)


/obj/machinery/door/airlock/Initialize()
	. = ..()
	if(fre69uency)
		set_fre69uency(fre69uency)

	//wireless connection
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

	update_icon()

/obj/machinery/door/airlock/New()
	..()

	set_fre69uency(fre69uency)

/obj/machinery/door/airlock/Destroy()
	if(fre69uency)
		SSradio.remove_object(src,fre69uency)
	. = ..()

/obj/machinery/airlock_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"

	anchored = TRUE
	power_channel = STATIC_ENVIRON

	var/id_ta69
	var/master_ta69
	var/fre69uency = 1379
	var/command = "cycle"

	var/datum/radio_fre69uency/radio_connection

	var/on = TRUE
	var/alert = 0
	var/previousPressure

/obj/machinery/airlock_sensor/update_icon()
	if(on)
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor/attack_hand(mob/user)
	var/datum/si69nal/si69nal = new
	si69nal.transmission_method = 1 //radio si69nal
	si69nal.data69"ta69"69 =69aster_ta69
	si69nal.data69"command"69 = command

	radio_connection.post_si69nal(src, si69nal, ran69e = AIRLOCK_CONTROL_RAN69E, filter = RADIO_AIRLOCK)
	flick("airlock_sensor_cycle", src)

/obj/machinery/airlock_sensor/Process()
	if(on)
		var/datum/69as_mixture/air_sample = return_air()
		var/pressure = round(air_sample.return_pressure(),0.1)

		if(abs(pressure - previousPressure) > 0.001 || previousPressure == null)
			var/datum/si69nal/si69nal = new
			si69nal.transmission_method = 1 //radio si69nal
			si69nal.data69"ta69"69 = id_ta69
			si69nal.data69"timestamp"69 = world.time
			si69nal.data69"pressure"69 = num2text(pressure)

			radio_connection.post_si69nal(src, si69nal, ran69e = AIRLOCK_CONTROL_RAN69E, filter = RADIO_AIRLOCK)

			previousPressure = pressure

			alert = (pressure < ONE_ATMOSPHERE*0.8)

			update_icon()

/obj/machinery/airlock_sensor/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	fre69uency = new_fre69uency
	radio_connection = SSradio.add_object(src, fre69uency, RADIO_AIRLOCK)

/obj/machinery/airlock_sensor/Initialize()
	. = ..()
	set_fre69uency(fre69uency)

/obj/machinery/airlock_sensor/New()
	..()
	set_fre69uency(fre69uency)

/obj/machinery/airlock_sensor/Destroy()
	SSradio.remove_object(src,fre69uency)
	. = ..()

/obj/machinery/airlock_sensor/airlock_interior
	command = "cycle_interior"

/obj/machinery/airlock_sensor/airlock_exterior
	command = "cycle_exterior"


/*
	Shuttle exterior sensors.
*/

/*
	These should be placed onto the same tile as a shuttle exterior door, one for each cyclin69 airlock setup.
	They should obviously be69isually offset onto a wall usin69 pixel_x/y

	They need a sensor direction which should be edited onto the instance when69appin69 in

	When asked to return atmosphere, these sensors will69ove their search up to 3 tiles in the specified direction
	Until they find a nondense tile which doesn't contain a closed door - ie, is clear and walkable.
	Then they return air from that tile.

	This sensor will never return air from its own tile, even if the external door is open. It will always69ove at least one step out
*/

/obj/machinery/airlock_sensor/shuttle_exterior
	var/sensor_dir = NORTH
	/*
	1 = NORTH
	2 = SOUTH
	4 = EAST
	8 = WEST
	*/
	var/max_steps = 3

//Checks for walls and closed airlocks blockin69 the tile. I69nores other dense objects
/obj/machinery/airlock_sensor/shuttle_exterior/proc/turf_open(var/turf/T)
	if (T.is_wall)
		return FALSE

	for (var/obj/machinery/door/D in T)
		if (D.density)
			return FALSE

	return TRUE

/obj/machinery/airlock_sensor/shuttle_exterior/return_air()
	var/turf/T = loc
	var/steps = 0
	while (steps <=69ax_steps)
		steps++
		var/turf/U = 69et_step(T, sensor_dir)

		//U could69aybe be null if we're at the ed69e of a69ap boundary
		if (U)
			T = U
			//If T is open, 69rab air from there
			if (turf_open(T))
				return T.return_air()
		else
			break


	//If we 69et here, then either every tile in a line outside the airlock was blocked, or we're too close to a69ap ed69e
	//Either way, we failed to find a69alid air sample. We'll return an empty one to avoid errors
	return new /datum/69as_mixture


/obj/machinery/access_button
	icon = 'icons/obj/airlock_machines.dmi'
	var/base_of_state = "access_button"
	icon_state = "access_button_standby"
	name = "access button"

	anchored = TRUE
	power_channel = STATIC_ENVIRON

	var/master_ta69
	var/fre69uency = 1449
	var/command = "cycle"

	var/datum/radio_fre69uency/radio_connection

	var/on = TRUE


/obj/machinery/access_button/update_icon()
	. = ..()
	icon_state = "69base_of_state69_69on?"standby":"off"69"

/obj/machinery/access_button/attackby(obj/item/I as obj,69ob/user as69ob)
	//Swipin69 ID on the access button
	if (istype(I, /obj/item/card/id) || istype(I, /obj/item/modular_computer))
		attack_hand(user)
		return
	..()

/obj/machinery/access_button/attack_hand(mob/user)
	playsound(loc, 'sound/machines/button.o6969', 100, 1)
	add_fin69erprint(usr)
	if(!allowed(user))
		to_chat(user, SPAN_WARNIN69("Access Denied"))

	else if(radio_connection)
		var/datum/si69nal/si69nal = new
		si69nal.transmission_method = 1 //radio si69nal
		si69nal.data69"ta69"69 =69aster_ta69
		si69nal.data69"command"69 = command

		radio_connection.post_si69nal(src, si69nal, ran69e = AIRLOCK_CONTROL_RAN69E, filter = RADIO_AIRLOCK)
	flick("access_button_cycle", src)


/obj/machinery/access_button/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	fre69uency = new_fre69uency
	radio_connection = SSradio.add_object(src, fre69uency, RADIO_AIRLOCK)


/obj/machinery/access_button/Initialize()
	. = ..()
	set_fre69uency(fre69uency)


/obj/machinery/access_button/New()
	..()

	set_fre69uency(fre69uency)

/obj/machinery/access_button/Destroy()
	SSradio.remove_object(src, fre69uency)
	. = ..()

/obj/machinery/access_button/airlock_interior
	fre69uency = 1379
	command = "cycle_interior"

/obj/machinery/access_button/airlock_exterior
	fre69uency = 1379
	command = "cycle_exterior"
