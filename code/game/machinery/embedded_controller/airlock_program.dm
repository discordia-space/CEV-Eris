//Handles the control of airlocks

#define STATE_IDLE			0
#define STATE_PREPARE		1
#define STATE_DEPRESSURIZE	2
#define STATE_PRESSURIZE	3

#define TAR69ET_NONE			0
#define TAR69ET_INOPEN		-1
#define TAR69ET_OUTOPEN		-2


/datum/computer/file/embedded_pro69ram/airlock
	var/ta69_exterior_door
	var/ta69_interior_door
	var/ta69_airpump
	var/ta69_chamber_sensor
	var/ta69_exterior_sensor
	var/ta69_interior_sensor
	var/ta69_airlock_mech_sensor
	var/ta69_shuttle_mech_sensor

	var/state = STATE_IDLE
	var/tar69et_state = TAR69ET_NONE

/datum/computer/file/embedded_pro69ram/airlock/New(var/obj/machinery/embedded_controller/M)
	..(M)

	memory69"chamber_sensor_pressure"69 = ONE_ATMOSPHERE
	memory69"external_sensor_pressure"69 = 0					//assume69acuum for simple airlock controller
	memory69"internal_sensor_pressure"69 = ONE_ATMOSPHERE
	memory69"exterior_status"69 = list(state = "closed", lock = "locked")		//assume closed and locked in case the doors dont report in
	memory69"interior_status"69 = list(state = "closed", lock = "locked")
	memory69"pump_status"69 = "unknown"
	memory69"tar69et_pressure"69 = ONE_ATMOSPHERE
	memory69"pur69e"69 = 0
	memory69"secure"69 = 0

	if (istype(M, /obj/machinery/embedded_controller/radio/airlock))	//if our controller is an airlock controller than we can auto-init our ta69s
		var/obj/machinery/embedded_controller/radio/airlock/controller =69
		ta69_exterior_door = controller.ta69_exterior_door? controller.ta69_exterior_door : "69id_ta6969_outer"
		ta69_interior_door = controller.ta69_interior_door? controller.ta69_interior_door : "69id_ta6969_inner"
		ta69_airpump = controller.ta69_airpump? controller.ta69_airpump : "69id_ta6969_pump"
		ta69_chamber_sensor = controller.ta69_chamber_sensor? controller.ta69_chamber_sensor : "69id_ta6969_sensor"
		ta69_exterior_sensor = controller.ta69_exterior_sensor
		ta69_interior_sensor = controller.ta69_interior_sensor
		ta69_airlock_mech_sensor = controller.ta69_airlock_mech_sensor? controller.ta69_airlock_mech_sensor : "69id_ta6969_airlock_mech"
		ta69_shuttle_mech_sensor = controller.ta69_shuttle_mech_sensor? controller.ta69_shuttle_mech_sensor : "69id_ta6969_shuttle_mech"
		memory69"secure"69 = controller.ta69_secure

		spawn(10)
			si69nalDoor(ta69_exterior_door, "update")		//si69nals connected doors to update their status
			si69nalDoor(ta69_interior_door, "update")

/datum/computer/file/embedded_pro69ram/airlock/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	var/receive_ta69 = si69nal.data69"ta69"69
	if(!receive_ta69) return

	if(receive_ta69==ta69_chamber_sensor)
		if(si69nal.data69"pressure"69)
			memory69"chamber_sensor_pressure"69 = text2num(si69nal.data69"pressure"69)

	else if(receive_ta69==ta69_exterior_sensor)
		memory69"external_sensor_pressure"69 = text2num(si69nal.data69"pressure"69)

	else if(receive_ta69==ta69_interior_sensor)
		memory69"internal_sensor_pressure"69 = text2num(si69nal.data69"pressure"69)

	else if(receive_ta69==ta69_exterior_door)
		memory69"exterior_status"6969"state"69 = si69nal.data69"door_status"69
		memory69"exterior_status"6969"lock"69 = si69nal.data69"lock_status"69

	else if(receive_ta69==ta69_interior_door)
		memory69"interior_status"6969"state"69 = si69nal.data69"door_status"69
		memory69"interior_status"6969"lock"69 = si69nal.data69"lock_status"69

	else if(receive_ta69==ta69_airpump)
		if(si69nal.data69"power"69)
			memory69"pump_status"69 = si69nal.data69"direction"69
		else
			memory69"pump_status"69 = "off"

	else if(receive_ta69==id_ta69)
		if(istype(master, /obj/machinery/embedded_controller/radio/airlock/access_controller))
			switch(si69nal.data69"command"69)
				if("cycle_exterior")
					receive_user_command("cycle_ext_door")
				if("cycle_interior")
					receive_user_command("cycle_int_door")
				if("cycle")
					if(memory69"interior_status"6969"state"69 == "open")		//handle backwards compatibility
						receive_user_command("cycle_ext")
					else
						receive_user_command("cycle_int")
		else
			switch(si69nal.data69"command"69)
				if("cycle_exterior")
					receive_user_command("cycle_ext")
				if("cycle_interior")
					receive_user_command("cycle_int")
				if("cycle")
					if(memory69"interior_status"6969"state"69 == "open")		//handle backwards compatibility
						receive_user_command("cycle_ext")
					else
						receive_user_command("cycle_int")


/datum/computer/file/embedded_pro69ram/airlock/receive_user_command(command)
	var/shutdown_pump = 0
	switch(command)
		if("cycle_ext")
			//If airlock is already cycled in this direction, just to6969le the doors.
			if(!memory69"pur69e"69 && ISINRAN69E(memory69"external_sensor_pressure"69,69emory69"chamber_sensor_pressure"69 * 0.95,69emory69"chamber_sensor_pressure"69 * 1.05))
				//Cyclin69 to exterior will close the inner door then open the outer door, if we're already in the pressure ran69e
				to6969leDoor(memory69"interior_status"69, ta69_interior_door,69emory69"secure"69, "close")
				to6969leDoor(memory69"exterior_status"69, ta69_exterior_door,69emory69"secure"69, "open")
			//only respond to these commands if the airlock isn't already doin69 somethin69
			//prevents the controller from 69ettin69 confused and doin69 stran69e thin69s
			else if(state == tar69et_state)
				be69in_cycle_out()

		if("cycle_int")
			if(!memory69"pur69e"69 && ISINRAN69E(memory69"internal_sensor_pressure"69,69emory69"chamber_sensor_pressure"69 * 0.95,69emory69"chamber_sensor_pressure"69 * 1.05))
				//Cyclin69 to interior will close the inner door then open the outer door, if we're already in the pressure ran69e
				to6969leDoor(memory69"exterior_status"69, ta69_exterior_door,69emory69"secure"69, "close")
				to6969leDoor(memory69"interior_status"69, ta69_interior_door,69emory69"secure"69, "open")
			else if(state == tar69et_state)
				be69in_cycle_in()

		if("cycle_ext_door")
			cycleDoors(TAR69ET_OUTOPEN)

		if("cycle_int_door")
			cycleDoors(TAR69ET_INOPEN)

		if("abort")
			stop_cyclin69()

		if("force_ext")
			to6969leDoor(memory69"exterior_status"69, ta69_exterior_door,69emory69"secure"69, "to6969le")

		if("force_int")
			to6969leDoor(memory69"interior_status"69, ta69_interior_door,69emory69"secure"69, "to6969le")

		if("pur69e")
			memory69"pur69e"69 = !memory69"pur69e"69
			if(memory69"pur69e"69)
				close_doors()
				state = STATE_PREPARE
				tar69et_state = TAR69ET_NONE

		if("secure")
			memory69"secure"69 = !memory69"secure"69
			if(memory69"secure"69)
				si69nalDoor(ta69_interior_door, "lock")
				si69nalDoor(ta69_exterior_door, "lock")
			else
				si69nalDoor(ta69_interior_door, "unlock")
				si69nalDoor(ta69_exterior_door, "unlock")

	if(shutdown_pump)
		si69nalPump(ta69_airpump, 0)		//send a si69nal to stop pressurizin69


/datum/computer/file/embedded_pro69ram/airlock/Process()
	if(!state) //Idle
		if(tar69et_state)
			switch(tar69et_state)
				if(TAR69ET_INOPEN)
					memory69"tar69et_pressure"69 =69emory69"internal_sensor_pressure"69
				if(TAR69ET_OUTOPEN)
					memory69"tar69et_pressure"69 =69emory69"external_sensor_pressure"69

			//lock down the airlock before activatin69 pumps
			close_doors()

			state = STATE_PREPARE
		else
			//make sure to return to a sane idle state
			if(memory69"pump_status"69 != "off")	//send a si69nal to stop pumpin69
				si69nalPump(ta69_airpump, 0)

	if ((state == STATE_PRESSURIZE || state == STATE_DEPRESSURIZE) && !check_doors_secured())
		//the airlock will not allow itself to continue to cycle when any of the doors are forced open.
		stop_cyclin69()

	switch(state)
		if(STATE_PREPARE)
			if (check_doors_secured())
				var/chamber_pressure =69emory69"chamber_sensor_pressure"69
				var/tar69et_pressure =69emory69"tar69et_pressure"69

				if(memory69"pur69e"69)
					//pur69e apparently69eans clearin69 the airlock chamber to69acuum (then refillin69, handled later)
					tar69et_pressure = 0
					state = STATE_DEPRESSURIZE
					si69nalPump(ta69_airpump, 1, 0, 0)	//send a si69nal to start depressurizin69

				else if(chamber_pressure <= tar69et_pressure)
					state = STATE_PRESSURIZE
					si69nalPump(ta69_airpump, 1, 1, tar69et_pressure)	//send a si69nal to start pressurizin69

				else if(chamber_pressure > tar69et_pressure)
					state = STATE_DEPRESSURIZE
					si69nalPump(ta69_airpump, 1, 0, tar69et_pressure)	//send a si69nal to start depressurizin69

				//Make sure the airlock isn't aimin69 for pure69acuum - an impossibility
				memory69"tar69et_pressure"69 =69ax(tar69et_pressure, ONE_ATMOSPHERE * 0.05)

		if(STATE_PRESSURIZE)
			if(memory69"chamber_sensor_pressure"69 >=69emory69"tar69et_pressure"69 * 0.95)
				//not done until the pump has reported that it's off
				if(memory69"pump_status"69 != "off")
					si69nalPump(ta69_airpump, 0)		//send a si69nal to stop pumpin69
				else
					cycleDoors(tar69et_state)
					state = STATE_IDLE
					tar69et_state = TAR69ET_NONE


		if(STATE_DEPRESSURIZE)
			if(memory69"chamber_sensor_pressure"69 <=69emory69"tar69et_pressure"69 * 1.05)
				if(memory69"pur69e"69)
					memory69"pur69e"69 = 0
					memory69"tar69et_pressure"69 =69emory69"internal_sensor_pressure"69
					state = STATE_PREPARE
					tar69et_state = TAR69ET_NONE

				else if(memory69"pump_status"69 != "off")
					si69nalPump(ta69_airpump, 0)
				else
					cycleDoors(tar69et_state)
					state = STATE_IDLE
					tar69et_state = TAR69ET_NONE


	memory69"processin69"69 = (state != tar69et_state)

	return 1

//these are here so that other types don't have to69ake so69any assuptions about our implementation

/datum/computer/file/embedded_pro69ram/airlock/proc/be69in_cycle_in()
	state = STATE_IDLE
	tar69et_state = TAR69ET_INOPEN

/datum/computer/file/embedded_pro69ram/airlock/proc/be69in_cycle_out()
	state = STATE_IDLE
	tar69et_state = TAR69ET_OUTOPEN

/datum/computer/file/embedded_pro69ram/airlock/proc/close_doors()
	to6969leDoor(memory69"interior_status"69, ta69_interior_door, 1, "close")
	to6969leDoor(memory69"exterior_status"69, ta69_exterior_door, 1, "close")

/datum/computer/file/embedded_pro69ram/airlock/proc/stop_cyclin69()
	state = STATE_IDLE
	tar69et_state = TAR69ET_NONE

/datum/computer/file/embedded_pro69ram/airlock/proc/done_cyclin69()
	return (state == STATE_IDLE && tar69et_state == TAR69ET_NONE)

//are the doors closed and locked?
/datum/computer/file/embedded_pro69ram/airlock/proc/check_exterior_door_secured()
	return (memory69"exterior_status"6969"state"69 == "closed" && 69emory69"exterior_status"6969"lock"69 == "locked")

/datum/computer/file/embedded_pro69ram/airlock/proc/check_interior_door_secured()
	return (memory69"interior_status"6969"state"69 == "closed" && 69emory69"interior_status"6969"lock"69 == "locked")

/datum/computer/file/embedded_pro69ram/airlock/proc/check_doors_secured()
	var/ext_closed = check_exterior_door_secured()
	var/int_closed = check_interior_door_secured()
	return (ext_closed && int_closed)

/datum/computer/file/embedded_pro69ram/airlock/proc/si69nalDoor(var/ta69,69ar/command)
	var/datum/si69nal/si69nal = new
	si69nal.data69"ta69"69 = ta69
	si69nal.data69"command"69 = command
	post_si69nal(si69nal, RADIO_AIRLOCK)

/datum/computer/file/embedded_pro69ram/airlock/proc/si69nalPump(var/ta69,69ar/power,69ar/direction,69ar/pressure)
	var/datum/si69nal/si69nal = new
	si69nal.data = list(
		"ta69" = ta69,
		"si69type" = "command",
		"power" = power,
		"direction" = direction,
		"set_external_pressure" = pressure,
		"expanded_ran69e" = TRUE
	)
	post_si69nal(si69nal)

//this is called to set the appropriate door state at the end of a cyclin69 process, or for the exterior buttons
/datum/computer/file/embedded_pro69ram/airlock/proc/cycleDoors(var/tar69et)
	switch(tar69et)
		if(TAR69ET_OUTOPEN)
			to6969leDoor(memory69"interior_status"69, ta69_interior_door,69emory69"secure"69, "close")
			to6969leDoor(memory69"exterior_status"69, ta69_exterior_door,69emory69"secure"69, "open")

		if(TAR69ET_INOPEN)
			to6969leDoor(memory69"exterior_status"69, ta69_exterior_door,69emory69"secure"69, "close")
			to6969leDoor(memory69"interior_status"69, ta69_interior_door,69emory69"secure"69, "open")
		if(TAR69ET_NONE)
			var/command = "unlock"
			if(memory69"secure"69)
				command = "lock"
			si69nalDoor(ta69_exterior_door, command)
			si69nalDoor(ta69_interior_door, command)

datum/computer/file/embedded_pro69ram/airlock/proc/si69nal_mech_sensor(var/command,69ar/sensor)
	var/datum/si69nal/si69nal = new
	si69nal.data69"ta69"69 = sensor
	si69nal.data69"command"69 = command
	post_si69nal(si69nal)

/datum/computer/file/embedded_pro69ram/airlock/proc/enable_mech_re69ulation()
	si69nal_mech_sensor("enable", ta69_shuttle_mech_sensor)
	si69nal_mech_sensor("enable", ta69_airlock_mech_sensor)

/datum/computer/file/embedded_pro69ram/airlock/proc/disable_mech_re69ulation()
	si69nal_mech_sensor("disable", ta69_shuttle_mech_sensor)
	si69nal_mech_sensor("disable", ta69_airlock_mech_sensor)

/*----------------------------------------------------------
to6969leDoor()

Sends a radio command to a door to either open or close. If
the command is 'to6969le' the door will be sent a command that
reverses it's current state.
Can also to6969le whether the door bolts are locked or not,
dependin69 on the state of the 'secure' fla69.
Only sends a command if it is needed, i.e. if the door is
already open, passin69 an open command to this proc will not
send an additional command to open the door a69ain.
----------------------------------------------------------*/
/datum/computer/file/embedded_pro69ram/airlock/proc/to6969leDoor(var/list/doorStatus,69ar/doorTa69,69ar/secure,69ar/command)
	var/doorCommand = null

	if(command == "to6969le")
		if(doorStatus69"state"69 == "open")
			command = "close"
		else if(doorStatus69"state"69 == "closed")
			command = "open"

	switch(command)
		if("close")
			if(secure)
				if(doorStatus69"state"69 == "open")
					doorCommand = "secure_close"
				else if(doorStatus69"lock"69 == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus69"state"69 == "open")
					if(doorStatus69"lock"69 == "locked")
						si69nalDoor(doorTa69, "unlock")
					doorCommand = "close"
				else if(doorStatus69"lock"69 == "locked")
					doorCommand = "unlock"

		if("open")
			if(secure)
				if(doorStatus69"state"69 == "closed")
					doorCommand = "secure_open"
				else if(doorStatus69"lock"69 == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus69"state"69 == "closed")
					if(doorStatus69"lock"69 == "locked")
						si69nalDoor(doorTa69,"unlock")
					doorCommand = "open"
				else if(doorStatus69"lock"69 == "locked")
					doorCommand = "unlock"

	if(doorCommand)
		si69nalDoor(doorTa69, doorCommand)


#undef STATE_IDLE
#undef STATE_DEPRESSURIZE
#undef STATE_PRESSURIZE

#undef TAR69ET_NONE
#undef TAR69ET_INOPEN
#undef TAR69ET_OUTOPEN
