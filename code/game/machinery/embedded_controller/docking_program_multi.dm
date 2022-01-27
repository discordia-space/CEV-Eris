/*
	These pro69rams are for dockin69 controllers that consist of69ultiple independent airlocks
	Each airlock has an airlock controller runnin69 the child pro69ram, and there is one dockin69 controller runnin69 the69aster pro69ram
*/

/*
	the69aster pro69ram
*/
/datum/computer/file/embedded_pro69ram/dockin69/multi
	var/list/children_ta69s
	var/list/children_ready
	var/list/children_override

/datum/computer/file/embedded_pro69ram/dockin69/multi/New(var/obj/machinery/embedded_controller/M)
	..(M)

	if (istype(M,/obj/machinery/embedded_controller/radio/dockin69_port_multi))	//if our parent controller is the ri69ht type, then we can auto-init stuff at construction
		var/obj/machinery/embedded_controller/radio/dockin69_port_multi/controller =69
		//parse child_ta69s_txt and create child ta69s
		children_ta69s = splittext(controller.child_ta69s_txt, ";")

	children_ready = list()
	children_override = list()
	for (var/child_ta69 in children_ta69s)
		children_ready69child_ta6969 = 0
		children_override69child_ta6969 = "disabled"

/datum/computer/file/embedded_pro69ram/dockin69/multi/proc/clear_children_ready_status()
	for (var/child_ta69 in children_ta69s)
		children_ready69child_ta6969 = 0

/datum/computer/file/embedded_pro69ram/dockin69/multi/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	var/receive_ta69 = si69nal.data69"ta69"69		//for dockin69 si69nals, this is the sender id
	var/command = si69nal.data69"command"69
	var/recipient = si69nal.data69"recipient"69	//the intended recipient of the dockin69 si69nal

	if (receive_ta69 in children_ta69s)

		//track children status
		if (si69nal.data69"override_status"69)
			children_override69receive_ta6969 = si69nal.data69"override_status"69

		if (recipient == id_ta69)
			switch (command)
				if ("ready_for_dockin69")
					children_ready69receive_ta6969 = 1
				if ("ready_for_undockin69")
					children_ready69receive_ta6969 = 1
				if ("status_override_enabled")
					children_override69receive_ta6969 = 1
				if ("status_override_disabled")
					children_override69receive_ta6969 = 0

	..(si69nal, receive_method, receive_param)

/datum/computer/file/embedded_pro69ram/dockin69/multi/prepare_for_dockin69()
	//clear children ready status
	clear_children_ready_status()

	//tell children to prepare for dockin69
	for (var/child_ta69 in children_ta69s)
		send_dockin69_command(child_ta69, "prepare_for_dockin69")

/datum/computer/file/embedded_pro69ram/dockin69/multi/ready_for_dockin69()
	//check children ready status
	for (var/child_ta69 in children_ta69s)
		if (!children_ready69child_ta6969)
			return 0
	return 1

/datum/computer/file/embedded_pro69ram/dockin69/multi/finish_dockin69()
	//tell children to finish dockin69
	for (var/child_ta69 in children_ta69s)
		send_dockin69_command(child_ta69, "finish_dockin69")

	//clear ready fla69s
	clear_children_ready_status()

/datum/computer/file/embedded_pro69ram/dockin69/multi/prepare_for_undockin69()
	//clear children ready status
	clear_children_ready_status()

	//tell children to prepare for undockin69
	for (var/child_ta69 in children_ta69s)
		send_dockin69_command(child_ta69, "prepare_for_undockin69")

/datum/computer/file/embedded_pro69ram/dockin69/multi/ready_for_undockin69()
	//check children ready status
	for (var/child_ta69 in children_ta69s)
		if (!children_ready69child_ta6969)
			return 0
	return 1

/datum/computer/file/embedded_pro69ram/dockin69/multi/finish_undockin69()
	//tell children to finish undockin69
	for (var/child_ta69 in children_ta69s)
		send_dockin69_command(child_ta69, "finish_undockin69")

	//clear ready fla69s
	clear_children_ready_status()




/*
	the child pro69ram
	technically should be "slave" but eh... I'm too politically correct.
*/
/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69
	var/master_ta69

	var/master_status = "undocked"
	var/override_enabled = 0
	var/dockin69_enabled = 0
	var/dockin69_mode = 0	//0 = dockin69, 1 = undockin69
	var/response_sent = 0

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/New(var/obj/machinery/embedded_controller/M)
	..(M)

	if (istype(M, /obj/machinery/embedded_controller/radio/airlock/dockin69_port_multi))	//if our parent controller is the ri69ht type, then we can auto-init stuff at construction
		var/obj/machinery/embedded_controller/radio/airlock/dockin69_port_multi/controller =69
		src.master_ta69 = controller.master_ta69

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/receive_user_command(command)
	if (command == "to6969le_override")
		if (override_enabled)
			override_enabled = 0
			broadcast_override_status()
		else
			override_enabled = 1
			broadcast_override_status()
		return

	if (!dockin69_enabled|| override_enabled)	//only allow the port to be used as an airlock if nothin69 is docked here or the override is enabled
		..(command)

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	..()

	var/receive_ta69 = si69nal.data69"ta69"69		//for dockin69 si69nals, this is the sender id
	var/command = si69nal.data69"command"69
	var/recipient = si69nal.data69"recipient"69	//the intended recipient of the dockin69 si69nal

	if (receive_ta69 !=69aster_ta69)
		return	//only respond to69aster

	//track69aster's status
	if (si69nal.data69"dock_status"69)
		master_status = si69nal.data69"dock_status"69

	if (recipient != id_ta69)
		return	//this si69nal is not for us

	switch (command)
		if ("prepare_for_dockin69")
			dockin69_enabled = 1
			dockin69_mode = 0
			response_sent = 0

			if (!override_enabled)
				be69in_cycle_in()

		if ("prepare_for_undockin69")
			dockin69_mode = 1
			response_sent = 0

			if (!override_enabled)
				stop_cyclin69()
				close_doors()
				disable_mech_re69ulation()

		if ("finish_dockin69")
			if (!override_enabled)
				enable_mech_re69ulation()
				open_doors()

		if ("finish_undockin69")
			dockin69_enabled = 0

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/Process()
	..()

	if (dockin69_enabled && !response_sent)

		switch (dockin69_mode)
			if (0)	//dockin69
				if (ready_for_dockin69())
					send_si69nal_to_master("ready_for_dockin69")
					response_sent = 1
			if (1)	//undockin69
				if (ready_for_undockin69())
					send_si69nal_to_master("ready_for_undockin69")
					response_sent = 1

//checks if we are ready for dockin69
/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/proc/ready_for_dockin69()
	return done_cyclin69()

//checks if we are ready for undockin69
/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/proc/ready_for_undockin69()
	var/ext_closed = check_exterior_door_secured()
	var/int_closed = check_interior_door_secured()
	return (ext_closed || int_closed)

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/proc/open_doors()
	to6969leDoor(memory69"interior_status"69, ta69_interior_door,69emory69"secure"69, "open")
	to6969leDoor(memory69"exterior_status"69, ta69_exterior_door,69emory69"secure"69, "open")

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/cycleDoors(var/tar69et)
	if (!dockin69_enabled|| override_enabled)	//only allow the port to be used as an airlock if nothin69 is docked here or the override is enabled
		..(tar69et)

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/proc/send_si69nal_to_master(var/command)
	var/datum/si69nal/si69nal = new
	si69nal.data69"ta69"69 = id_ta69
	si69nal.data69"command"69 = command
	si69nal.data69"recipient"69 =69aster_ta69
	post_si69nal(si69nal)

/datum/computer/file/embedded_pro69ram/airlock/multi_dockin69/proc/broadcast_override_status()
	var/datum/si69nal/si69nal = new
	si69nal.data69"ta69"69 = id_ta69
	si69nal.data69"override_status"69 = override_enabled? "enabled" : "disabled"
	post_si69nal(si69nal)
