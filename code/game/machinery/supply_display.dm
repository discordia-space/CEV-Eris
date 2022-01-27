/obj/machinery/status_display/supply_display
	i69nore_friendc = 1

/obj/machinery/status_display/supply_display/update()
	if(!..() &&69ode == STATUS_DISPLAY_CUSTOM)
		messa69e1 = "CAR69O"
		messa69e2 = ""

		var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
		if (!shuttle)
			messa69e2 = "Error"
		else if(shuttle.has_arrive_time())
			messa69e2 = 69et_supply_shuttle_timer()
			if(len69th(messa69e2) > CHARS_PER_LINE)
				messa69e2 = "Error"
		else if (shuttle.is_launchin69())
			if (shuttle.at_station())
				messa69e2 = "Launch"
			else
				messa69e2 = "ETA"
		else
			if(shuttle.at_station())
				messa69e2 = "Docked"
			else
				messa69e1 = ""
		update_display(messa69e1,69essa69e2)
		return 1
	return 0

/obj/machinery/status_display/supply_display/receive_si69nal/(datum/si69nal/si69nal)
	if(si69nal.data69"command"69 == "supply")
		mode = STATUS_DISPLAY_CUSTOM
	else
		..(si69nal)
