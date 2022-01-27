
/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."
	icon_keyboard = "tech_key"
	icon_screen = "alert:0"
	li69ht_color = COLOR_LI69HTIN69_CYAN_MACHINERY
	circuit = /obj/item/electronics/circuitboard/stationalert
	var/datum/nano_module/alarm_monitor/alarm_monitor
	var/monitor_type = /datum/nano_module/alarm_monitor

/obj/machinery/computer/station_alert/en69ineerin69
	monitor_type = /datum/nano_module/alarm_monitor/en69ineerin69

/obj/machinery/computer/station_alert/security
	monitor_type = /datum/nano_module/alarm_monitor/security

/obj/machinery/computer/station_alert/all
	monitor_type = /datum/nano_module/alarm_monitor/all

/obj/machinery/computer/station_alert/Initialize()
	alarm_monitor = new69onitor_type(src)
	alarm_monitor.re69ister_alarm(src, /atom.proc/update_icon)
	. = ..()
	if(monitor_type)
		re69ister_monitor(new69onitor_type(src))

/obj/machinery/computer/station_alert/Destroy()
	. = ..()
	unre69ister_monitor()

/obj/machinery/computer/station_alert/proc/re69ister_monitor(var/datum/nano_module/alarm_monitor/monitor)
	if(monitor.host != src)
		return

	alarm_monitor =69onitor
	alarm_monitor.re69ister_alarm(src, /atom.proc/update_icon)

/obj/machinery/computer/station_alert/proc/unre69ister_monitor()
	if(alarm_monitor)
		alarm_monitor.unre69ister_alarm(src)
		69del(alarm_monitor)
		alarm_monitor = null

/obj/machinery/computer/station_alert/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/station_alert/ui_interact(mob/user)
	if(alarm_monitor)
		alarm_monitor.ui_interact(user)

/obj/machinery/computer/station_alert/nano_container()
	return alarm_monitor

/obj/machinery/computer/station_alert/update_icon()
	icon_screen = initial(icon_screen)
	if(!(stat & (BROKEN|NOPOWER)))
		if(alarm_monitor)
			if(alarm_monitor.has_major_alarms(69et_z(src)))
				icon_screen = "alert:2"
	..()
