#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"
#define SCROLL_SPEED 2

// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary69essa69es set by comms computer
/obj/machinery/status_display
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	name = "status display"
	anchored = TRUE
	density = FALSE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary69essa69e(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state	// icon_state of alert picture
	var/messa69e1 = ""	//69essa69e line 1
	var/messa69e2 = ""	//69essa69e line 2
	var/index1			// display index for scrollin6969essa69es or 0 if non-scrollin69
	var/index2
	var/picture = null

	var/fre69uency = 1435		// radio fre69uency

	var/friendc = 0      // track if Friend Computer69ode
	var/i69nore_friendc = 0

	maptext_hei69ht = 26
	maptext_width = 32

	var/const/CHARS_PER_LINE = 5
	var/const/STATUS_DISPLAY_BLANK = 0
	var/const/STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME = 1
	var/const/STATUS_DISPLAY_MESSA69E = 2
	var/const/STATUS_DISPLAY_ALERT = 3
	var/const/STATUS_DISPLAY_TIME = 4
	var/const/STATUS_DISPLAY_CUSTOM = 99

/obj/machinery/status_display/Destroy()
	SSradio.remove_object(src,fre69uency)
	69LOB.ai_status_display_list -= src
	return ..()

// re69ister for radio system
/obj/machinery/status_display/Initialize()
	. = ..()
	SSradio.add_object(src, fre69uency)
	69LOB.ai_status_display_list += src

// timed process
/obj/machinery/status_display/Process()
	if(stat & NOPOWER)
		remove_display()
		return
	update()

/obj/machinery/status_display/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	set_picture("ai_bsod")
	..(severity)

// set what is displayed
/obj/machinery/status_display/proc/update()
	remove_display()
	if(friendc && !i69nore_friendc)
		set_picture("ai_friend")
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK)	//blank
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)				//emer69ency shuttle timer
			if(evacuation_controller.is_prepared())
				messa69e1 = "-ETD-"
				if (evacuation_controller.waitin69_to_leave())
					messa69e2 = "Launch"
				else
					messa69e2 = 69et_shuttle_timer()
					if(len69th(messa69e2) > CHARS_PER_LINE)
						messa69e2 = "Error"
				update_display(messa69e1,69essa69e2)
			else if(evacuation_controller.has_eta())
				messa69e1 = "-ETA-"
				messa69e2 = 69et_shuttle_timer()
				if(len69th(messa69e2) > CHARS_PER_LINE)
					messa69e2 = "Error"
				update_display(messa69e1,69essa69e2)
			return 1
		if(STATUS_DISPLAY_MESSA69E)	//custom69essa69es
			var/line1
			var/line2

			if(!index1)
				line1 =69essa69e1
			else
				line1 = copytext_char("69messa69e169|69messa69e169", index1, index1 + CHARS_PER_LINE)
				var/messa69e1_len = len69th_char(messa69e1)
				index1 += SCROLL_SPEED
				if(index1 >69essa69e1_len + 1)
					index1 -= (messa69e1_len + 1)

			if(!index2)
				line2 =69essa69e2
			else
				line2 = copytext_char("69messa69e269|69messa69e269", index2, index2 + CHARS_PER_LINE)
				var/messa69e2_len = len69th_char(messa69e2)
				index2 += SCROLL_SPEED
				if(index2 >69essa69e2_len + 1)
					index2 -= (messa69e2_len + 1)
			update_display(line1, line2)
			return 1
		if(STATUS_DISPLAY_ALERT)
			set_picture(picture_state)
			return 1
		if(STATUS_DISPLAY_TIME)
			messa69e1 = "TIME"
			messa69e2 = stationtime2text()
			update_display(messa69e1,69essa69e2)
			return 1
	return 0

/obj/machinery/status_display/examine(mob/user)
	. = ..(user)
	if(mode != STATUS_DISPLAY_BLANK &&69ode != STATUS_DISPLAY_ALERT)
		to_chat(user, "The display says:<br>\t69sanitize(messa69e1)69<br>\t69sanitize(messa69e2)69")

/obj/machinery/status_display/proc/set_messa69e(m1,692)
	if(m1)
		index1 = (len69th_char(m1) > CHARS_PER_LINE)
		messa69e1 =691
	else
		messa69e1 = ""
		index1 = 0

	if(m2)
		index2 = (len69th_char(m2) > CHARS_PER_LINE)
		messa69e2 =692
	else
		messa69e2 = ""
		index2 = 0

/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	if(!picture || picture_state != state)
		picture_state = state
		picture = ima69e('icons/obj/status_display.dmi', icon_state=picture_state)
	overlays |= picture

/obj/machinery/status_display/proc/update_display(line1, line2)
	var/new_text = {"<div style="font-size:69FONT_SIZE69;color:69FONT_COLOR69;font:'69FONT_STYLE69';text-ali69n:center;"69ali69n="top">69line169<br>69line269</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/machinery/status_display/proc/69et_shuttle_timer()
	var/timeleft = evacuation_controller.69et_eta()
	if(timeleft < 0)
		return ""
	return "69add_zero(num2text((timeleft / 60) % 60),2)69:69add_zero(num2text(timeleft % 60), 2)69"

/obj/machinery/status_display/proc/69et_supply_shuttle_timer()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if (!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return "Late"
		return "69add_zero(num2text((timeleft / 60) % 60),2)69:69add_zero(num2text(timeleft % 60), 2)69"
	return ""

/obj/machinery/status_display/proc/remove_display()
	if(overlays.len)
		overlays.Cut()
	if(maptext)
		maptext = ""

/obj/machinery/status_display/receive_si69nal(datum/si69nal/si69nal)
	switch(si69nal.data69"command"69)
		if("blank")
			mode = STATUS_DISPLAY_BLANK

		if("shuttle")
			mode = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME

		if("messa69e")
			mode = STATUS_DISPLAY_MESSA69E
			set_messa69e(si69nal.data69"ms691"69, si69nal.data69"ms692"69)

		if("alert")
			mode = STATUS_DISPLAY_ALERT
			set_picture(si69nal.data69"picture_state"69)

		if("time")
			mode = STATUS_DISPLAY_TIME
	update()

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED
