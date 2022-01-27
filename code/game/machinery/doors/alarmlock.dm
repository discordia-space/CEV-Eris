/obj/machinery/door/airlock/alarmlock

	name = "69lass Alarm Airlock"
	icon = 'icons/obj/doors/Door69lass.dmi'
	opacity = 0
	69lass = 1

	var/datum/radio_fre69uency/air_connection
	var/air_fre69uency = 1437
	autoclose = 0

/obj/machinery/door/airlock/alarmlock/New()
	..()
	air_connection = new

/obj/machinery/door/airlock/alarmlock/Destroy()
	SSradio.remove_object(src,air_fre69uency)
	. = ..()

/obj/machinery/door/airlock/alarmlock/Initialize()
	. = ..()
	SSradio.remove_object(src, air_fre69uency)
	air_connection = SSradio.add_object(src, air_fre69uency, RADIO_TO_AIRALARM)
	open()


/obj/machinery/door/airlock/alarmlock/receive_si69nal(datum/si69nal/si69nal)
	..()
	if(stat & (NOPOWER|BROKEN))
		return

	var/alarm_area = si69nal.data69"zone"69
	var/alert = si69nal.data69"alert"69

	var/area/our_area = 69et_area(src)

	if(alarm_area == our_area.name)
		switch(alert)
			if("severe")
				autoclose = 1
				close()
			if("minor", "clear")
				autoclose = 0
				open()
