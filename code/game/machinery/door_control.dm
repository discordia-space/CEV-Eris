/obj/machinery/button/remote
	name = "remote object control"
	desc = "It controls objects, remotely."
	icon_state = "doorctrl0"
	power_channel = STATIC_ENVIRON
	var/desiredstate = 0
	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/button/remote/attack_ai(mob/user as mob)
	if(wires & 2)
		return attack_hand(user)
	else
		to_chat(user, "Error, no route to host.")

/obj/machinery/button/remote/attackby(obj/item/W, mob/user as mob)
	return attack_hand(user)

/obj/machinery/button/remote/emag_act(var/remaining_charges, var/mob/user)
	if(req_access.len || req_one_access.len)
		req_access = list()
		req_one_access = list()
		playsound(src.loc, "sparks", 100, 1)
		return 1

/obj/machinery/button/remote/attack_hand(mob/user as mob)
	if(..())
		return 1

	if(!allowed(user) && (wires & 1))
		to_chat(user, SPAN_WARNING("Access Denied"))
		flick("doorctrl-denied",src)
		return

	use_power(5)
	icon_state = "doorctrl1"
	desiredstate = !desiredstate
	trigger(user)
	spawn(15)
		update_icon()

/obj/machinery/button/remote/proc/trigger()
	return

/obj/machinery/button/remote/power_change()
	..()
	update_icon()

/obj/machinery/button/remote/update_icon()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/*
	Airlock remote control
*/

// Bitmasks for door switches.
#define OPEN   0x1
#define IDSCAN 0x2
#define BOLTS  0x4
#define SHOCK  0x8
#define SAFE   0x10

/obj/machinery/button/remote/airlock
	name = "remote door-control"
	desc = "It controls doors, remotely."

	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties
	*/

/obj/machinery/button/remote/airlock/trigger()
	for(var/obj/machinery/door/airlock/D in GLOB.all_doors)
		if(D.id_tag == id)
			if(specialfunctions & OPEN)
				if(D.density)
					spawn(0)
						D.open()
						return
				else
					spawn(0)
						D.close()
						return
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.set_idscan(0)
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.electrify(-1)
				if(specialfunctions & SAFE)
					D.set_safeties(0)
			else
				if(specialfunctions & IDSCAN)
					D.set_idscan(1)
				if(specialfunctions & BOLTS)
					D.unlock()
				if(specialfunctions & SHOCK)
					D.electrify(0)
				if(specialfunctions & SAFE)
					D.set_safeties(1)

#undef OPEN
#undef IDSCAN
#undef BOLTS
#undef SHOCK
#undef SAFE

/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."
	var/datum/radio_frequency/radio_conn
	var/door_status = "OPENED"
	var/open = 0
	var/closed = 0
	var/last_message

/obj/machinery/button/remote/blast_door/Initialize()
	. = ..()
	radio_conn = SSradio.add_object(src, BLAST_DOOR_FREQ, RADIO_BLASTDOORS)
	AddComponent(/datum/component/overlay_manager)

/// Update status at initialization!
/obj/machinery/button/remote/blast_door/LateInitialize()
	. = ..()
	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = id
	signal.data["message"] = "CMD_DOOR_STATE"
	radio_conn.post_signal(src, signal, RADIO_BLASTDOORS)



/obj/machinery/button/remote/blast_door/Destroy()
	SSradio.remove_object(src, BLAST_DOOR_FREQ)
	radio_conn = null
	. = ..()

/obj/machinery/button/remote/blast_door/examine(mob/user, distance, infix, suffix)
	. = ..(user, afterDesc = "[distance <= 2 ? "Linked doors status is currently [door_status]" : ""]")

/obj/machinery/button/remote/blast_door/trigger()
	door_status = "UNKNOWN"
	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = id
	signal.data["message"] = "CMD_DOOR_TOGGLE"
	radio_conn.post_signal(src, signal, RADIO_BLASTDOORS)

#define OVERKEY_DOOR_STATUS "door_status"

/obj/machinery/button/remote/blast_door/update_icon()
	. = ..()
	var/datum/component/overlay_manager/overlay_manager = GetComponent(/datum/component/overlay_manager)
	if(!overlay_manager)
		return
	var/mutable_appearance/appear = mutable_appearance(icon = src.icon, icon_state = "")
	appear.dir = src.dir
	if(stat & NOPOWER)
		overlay_manager.removeOverlay(OVERKEY_DOOR_STATUS)
		return
	switch(door_status)
		if("OPENED")
			appear.icon_state = "doorctrl-open"
		if("MIXED")
			appear.icon_state = "doorctrl-mixed"
		if("CLOSED")
			appear.icon_state = "doorctrl-closed"
		if("UNKNOWN")
			appear.icon_state = "doorctrl-unknown"
	overlay_manager.updateOverlay(OVERKEY_DOOR_STATUS, appear)

#undef OVERKEY_DOOR_STATUS


/obj/machinery/button/remote/blast_door/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal)
		return
	if(signal.encryption != id)
		return
	if(stat & NOPOWER)
		return
	if(last_message < world.time)
		closed = 0
		open = 0
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 2 SECONDS)
	switch(signal.data["message"])
		if("DATA_DOOR_OPENED")
			last_message = world.time + 1 SECOND
			open++
		if("DATA_DOOR_CLOSED")
			last_message = world.time + 1 SECOND
			closed++
		if("CMD_DOOR_OPEN")
			return
		if("CMD_DOOR_CLOSE")
			return
		if("CMD_DOOR_TOGGLE")
			return
		if("CMD_DOOR_STATE")
			return

	if(open && closed)
		door_status = "MIXED"
	else if(open)
		door_status = "OPENED"
	else if(closed)
		door_status = "CLOSED"
	else
		door_status = "UNKNOWN"

/obj/machinery/button/remote/blast_door/id_card
	name = "remote blast id card door-control"
	desc = "It controls blast doors, remotely. But need id_card with access to it."
	icon_state = "doorid0"

/obj/machinery/button/remote/blast_door/id_card/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/card/id))
		var/obj/item/card/id/id_card = W
		if(has_access(req_access, list(), id_card.access))
			use_power(5)
			icon_state = "doorid1"
			desiredstate = !desiredstate
			trigger(user)
			spawn(15)
				update_icon()
		else
			to_chat(user, SPAN_WARNING("Access Denied"))
			flick("doorid-denied",src)
	else
		to_chat(user, SPAN_WARNING("You need a id card to operate."))
		flick("doorid-denied",src)

/obj/machinery/button/remote/blast_door/id_card/attack_hand(mob/user as mob)
	to_chat(user, SPAN_WARNING("You need a id card to operate."))
	flick("doorid-denied",src)

/obj/machinery/button/remote/blast_door/id_card/update_icon()
	if(stat & NOPOWER)
		icon_state = "doorid-p"
	else
		icon_state = "doorid0"

/*
	Emitter remote control
*/
/obj/machinery/button/remote/emitter
	name = "remote emitter control"
	desc = "It controls emitters, remotely."

/obj/machinery/button/remote/emitter/trigger(mob/user as mob)
	for(var/obj/machinery/power/emitter/E in GLOB.machines)
		if(E.id == id)
			spawn(0)
				E.activate(user)
				return

/*
	Mass driver remote control
*/
/obj/machinery/button/remote/driver
	name = "mass driver button"
	desc = "A remote control switch for a mass driver."
	icon_state = "launcher0"

/obj/machinery/button/remote/driver/trigger(mob/user as mob)
	active = 1
	update_icon()

	for(var/obj/machinery/door/blast/M in GLOB.all_doors)
		if(M.id == id)
			spawn(0)
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in GLOB.machines)
		if(M.id == id)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/blast/M in GLOB.all_doors)
		if(M.id == id)
			spawn(0)
				M.close()
				return

	active = 0
	icon_state = "launcher0"
	update_icon()

	return

/obj/machinery/button/remote/driver/update_icon()
	if(active)
		icon_state = "launcher1"
	else if(stat & (NOPOWER))
		icon_state = "launcher-p"
	else
		icon_state = "launcher0"
