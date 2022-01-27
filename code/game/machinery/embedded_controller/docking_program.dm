
#define STATE_UNDOCKED		0
#define STATE_DOCKIN69		1
#define STATE_UNDOCKIN69		2
#define STATE_DOCKED		3

#define69ODE_NONE			0
#define69ODE_SERVER			1
#define69ODE_CLIENT			2	//The one who initiated the dockin69, and who can initiate the undockin69. The server cannot initiate undockin69, and is the one responsible for decidin69 to accept a dockin69 re69uest and si69nals when dockin69 and undockin69 is complete. (Think server == station, client == shuttle)

#define69ESSA69E_RESEND_TIME 5	//how lon69 (in seconds) do we wait before resendin69 a69essa69e

/*
	*** STATE TABLE ***

	MODE_CLIENT|STATE_UNDOCKED		sent a re69uest for dockin69 and now waitin69 for a reply.
	MODE_CLIENT|STATE_DOCKIN69		server told us they are OK to dock, waitin69 for our dockin69 port to be ready.
	MODE_CLIENT|STATE_DOCKED		idle - docked as client.
	MODE_CLIENT|STATE_UNDOCKIN69		we are either waitin69 for our dockin69 port to be ready or for the server to 69ive us the OK to finish undockin69.

	MODE_SERVER|STATE_UNDOCKED		should never happen.
	MODE_SERVER|STATE_DOCKIN69		someone re69uested dockin69, we are waitin69 for our dockin69 port to be ready.
	MODE_SERVER|STATE_DOCKED		idle - docked as server
	MODE_SERVER|STATE_UNDOCKIN69		client re69uested undockin69, we are waitin69 for our dockin69 port to be ready.

	MODE_NONE|STATE_UNDOCKED		idle - not docked.
	MODE_NONE|anythin69 else			should never happen.

	*** Dockin69 Si69nals ***

	Dockin69
	Client sends re69uest_dock
	Server sends confirm_dock to say that yes, we will serve your re69uest
	When client is ready, sends confirm_dock
	Server sends confirm_dock back to indicate that dockin69 is complete

	Undockin69
	Client sends re69uest_undock
	When client is ready, sends confirm_undock
	Server sends confirm_undock back to indicate that dockin69 is complete

	Note that in both cases each side exchan69es confirm_dock before the dockin69 operation is considered done.
	The client first sends a confirm69essa69e to indicate it is ready, and then finally the server will send it's
	confirm69essa69e to indicate that the operation is complete.

	Note also that when dockin69, the server sends an additional confirm69essa69e. This is because before dockin69,
	the server and client do not have a defined relationship. Before undockin69, the server and client are already
	related to each other, thus the extra confirm69essa69e is not needed.

	*** Override, what is it? ***

	The purpose of enablin69 the override is to prevent the dockin69 pro69ram from automatically doin69 thin69s with the dockin69 port when dockin69 or undockin69.
	Maybe the shuttle is full of plamsa/plasma for some reason, and you don't want the door to automatically open, or the airlock to cycle.
	This69eans that the prepare_for_dockin69/undockin69 and finish_dockin69/undockin69 procs don't 69et called.

	The dockin69 controller will still check the state of the dockin69 port, and thus prevent the shuttle from launchin69 unless they force the launch (handlin69 forced
	launches is not the dockin69 controller's responsibility). In this case it is up to the players to69anually 69et the dockin69 port into a 69ood state to undock
	(which usually just69eans closin69 and lockin69 the doors).

	In line with this, dockin69 controllers should prevent players from69anually doin69 thin69s when the override is NOT enabled.
*/


/datum/computer/file/embedded_pro69ram/dockin69
	var/ta69_tar69et				//the ta69 of the dockin69 controller that we are tryin69 to dock with
	var/dock_state = STATE_UNDOCKED
	var/control_mode =69ODE_NONE
	var/response_sent = 0		//so we don't spam confirmation69essa69es
	var/resend_counter = 0		//for periodically resendin69 confirmation69essa69es in case they are69issed

	var/override_enabled = 0	//when enabled, do not open/close doors or cycle airlocks and wait for the player to do it69anually
	var/received_confirm = 0	//for undockin69, whether the server has recieved a confirmation from the client

/datum/computer/file/embedded_pro69ram/dockin69/New()
	..()

	var/datum/existin69 = locate(id_ta69) //in case a datum already exists with our ta69
	if(existin69)
		existin69.ta69 = null //take it from them


	ta69 = id_ta69 //69reatly simplifies shuttle initialization


/datum/computer/file/embedded_pro69ram/dockin69/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	var/receive_ta69 = si69nal.data69"ta69"69		//for dockin69 si69nals, this is the sender id
	var/command = si69nal.data69"command"69
	var/recipient = si69nal.data69"recipient"69	//the intended recipient of the dockin69 si69nal
	if (recipient != id_ta69)
		return	//this si69nal is not for us

	switch (command)
		if ("confirm_dock")
			if (control_mode ==69ODE_CLIENT && dock_state == STATE_UNDOCKED && receive_ta69 == ta69_tar69et)
				dock_state = STATE_DOCKIN69
				broadcast_dockin69_status()
				if (!override_enabled)
					prepare_for_dockin69()

			else if (control_mode ==69ODE_CLIENT && dock_state == STATE_DOCKIN69 && receive_ta69 == ta69_tar69et)
				dock_state = STATE_DOCKED
				broadcast_dockin69_status()
				if (!override_enabled)
					finish_dockin69()	//client done dockin69!
				response_sent = 0
			else if (control_mode ==69ODE_SERVER && dock_state == STATE_DOCKIN69 && receive_ta69 == ta69_tar69et)	//client just sent us the confirmation back, we're done with the dockin69 process
				received_confirm = 1

		if ("re69uest_dock")
			if (control_mode ==69ODE_NONE && dock_state == STATE_UNDOCKED)
				control_mode =69ODE_SERVER

				dock_state = STATE_DOCKIN69
				broadcast_dockin69_status()


				ta69_tar69et = receive_ta69
				if (!override_enabled)
					prepare_for_dockin69()

				send_dockin69_command(ta69_tar69et, "confirm_dock")	//acknowled69e the re69uest

		if ("confirm_undock")
			if (control_mode ==69ODE_CLIENT && dock_state == STATE_UNDOCKIN69 && receive_ta69 == ta69_tar69et)
				if (!override_enabled)
					finish_undockin69()
				reset()		//client is done undockin69!
			else if (control_mode ==69ODE_SERVER && dock_state == STATE_UNDOCKIN69 && receive_ta69 == ta69_tar69et)
				received_confirm = 1

		if ("re69uest_undock")
			if (control_mode ==69ODE_SERVER && dock_state == STATE_DOCKED && receive_ta69 == ta69_tar69et)
				dock_state = STATE_UNDOCKIN69
				broadcast_dockin69_status()

				if (!override_enabled)
					prepare_for_undockin69()

		if ("dock_error")
			if (receive_ta69 == ta69_tar69et)
				reset()

/datum/computer/file/embedded_pro69ram/dockin69/Process()
	switch(dock_state)
		if (STATE_DOCKIN69)	//waitin69 for our dockin69 port to be ready for dockin69
			if (ready_for_dockin69())
				if (control_mode ==69ODE_CLIENT)
					if (!response_sent)
						send_dockin69_command(ta69_tar69et, "confirm_dock")	//tell the server we're ready
						response_sent = 1

				else if (control_mode ==69ODE_SERVER && received_confirm)
					send_dockin69_command(ta69_tar69et, "confirm_dock")	//tell the client we are done dockin69.

					dock_state = STATE_DOCKED
					broadcast_dockin69_status()

					if (!override_enabled)
						finish_dockin69()	//server done dockin69!
					response_sent = 0
					received_confirm = 0

		if (STATE_UNDOCKIN69)
			if (ready_for_undockin69())
				if (control_mode ==69ODE_CLIENT)
					if (!response_sent)
						send_dockin69_command(ta69_tar69et, "confirm_undock")	//tell the server we are OK to undock.
						response_sent = 1

				else if (control_mode ==69ODE_SERVER && received_confirm)
					send_dockin69_command(ta69_tar69et, "confirm_undock")	//tell the client we are done undockin69.
					if (!override_enabled)
						finish_undockin69()
					reset()		//server is done undockin69!

	if (response_sent || resend_counter > 0)
		resend_counter++

	if (resend_counter >=69ESSA69E_RESEND_TIME || (dock_state != STATE_DOCKIN69 && dock_state != STATE_UNDOCKIN69))
		response_sent = 0
		resend_counter = 0

	//handle invalid states
	if (control_mode ==69ODE_NONE && dock_state != STATE_UNDOCKED)
		if (ta69_tar69et)
			send_dockin69_command(ta69_tar69et, "dock_error")
		reset()
	if (control_mode ==69ODE_SERVER && dock_state == STATE_UNDOCKED)
		control_mode =69ODE_NONE


/datum/computer/file/embedded_pro69ram/dockin69/proc/initiate_dockin69(var/tar69et)
	if (dock_state != STATE_UNDOCKED || control_mode ==69ODE_SERVER)	//must be undocked and not servin69 another re69uest to be69in a new dockin69 handshake
		return

	ta69_tar69et = tar69et
	control_mode =69ODE_CLIENT

	send_dockin69_command(ta69_tar69et, "re69uest_dock")

/datum/computer/file/embedded_pro69ram/dockin69/proc/initiate_undockin69()
	if (dock_state != STATE_DOCKED || control_mode !=69ODE_CLIENT)		//must be docked and69ust be client to start undockin69
		return

	dock_state = STATE_UNDOCKIN69
	broadcast_dockin69_status()

	if (!override_enabled)
		prepare_for_undockin69()

	send_dockin69_command(ta69_tar69et, "re69uest_undock")

//tell the dockin69 port to start 69ettin69 ready for dockin69 - e.69. pressurize
/datum/computer/file/embedded_pro69ram/dockin69/proc/prepare_for_dockin69()
	response_sent = 0
	return

//are we ready for dockin69?
/datum/computer/file/embedded_pro69ram/dockin69/proc/ready_for_dockin69()
	return 1

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_pro69ram/dockin69/proc/finish_dockin69()
	return

//tell the dockin69 port to start 69ettin69 ready for undockin69 - e.69. close those doors.
/datum/computer/file/embedded_pro69ram/dockin69/proc/prepare_for_undockin69()
	return

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_pro69ram/dockin69/proc/finish_undockin69()
	return

//are we ready for undockin69?
/datum/computer/file/embedded_pro69ram/dockin69/proc/ready_for_undockin69()
	return 1

/datum/computer/file/embedded_pro69ram/dockin69/proc/enable_override()
	override_enabled = 1

/datum/computer/file/embedded_pro69ram/dockin69/proc/disable_override()
	override_enabled = 0

/datum/computer/file/embedded_pro69ram/dockin69/proc/reset()
	dock_state = STATE_UNDOCKED
	broadcast_dockin69_status()

	control_mode =69ODE_NONE
	ta69_tar69et = null
	response_sent = 0
	received_confirm = 0

/datum/computer/file/embedded_pro69ram/dockin69/proc/force_undock()
	if (ta69_tar69et)
		send_dockin69_command(ta69_tar69et, "dock_error")
	reset()

/datum/computer/file/embedded_pro69ram/dockin69/proc/docked()
	return (dock_state == STATE_DOCKED)

/datum/computer/file/embedded_pro69ram/dockin69/proc/undocked()
	return (dock_state == STATE_UNDOCKED)

//returns 1 if we are saftely undocked (and the shuttle can leave)
/datum/computer/file/embedded_pro69ram/dockin69/proc/can_launch()
	return undocked()

/datum/computer/file/embedded_pro69ram/dockin69/proc/send_dockin69_command(var/recipient,69ar/command)
	var/datum/si69nal/si69nal = new
	si69nal.data69"ta69"69 = id_ta69
	si69nal.data69"command"69 = command
	si69nal.data69"recipient"69 = recipient
	post_si69nal(si69nal)

/datum/computer/file/embedded_pro69ram/dockin69/proc/broadcast_dockin69_status()
	var/datum/si69nal/si69nal = new
	si69nal.data69"ta69"69 = id_ta69
	si69nal.data69"dock_status"69 = 69et_dockin69_status()
	post_si69nal(si69nal)

//this is69ostly for NanoUI
/datum/computer/file/embedded_pro69ram/dockin69/proc/69et_dockin69_status()
	switch (dock_state)
		if (STATE_UNDOCKED) return "undocked"
		if (STATE_DOCKIN69) return "dockin69"
		if (STATE_UNDOCKIN69) return "undockin69"
		if (STATE_DOCKED) return "docked"



