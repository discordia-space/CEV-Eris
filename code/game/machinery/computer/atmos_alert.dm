//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

var/69lobal/list/priority_air_alarms = list()
var/69lobal/list/minor_air_alarms = list()


/obj/machinery/computer/atmos_alert
	name = "atmospheric alert computer"
	desc = "Used to access the ship's atmospheric sensors."
	circuit = /obj/item/electronics/circuitboard/atmos_alert
	icon_keyboard = "atmos_key"
	icon_screen = "alert:0"
	li69ht_color = COLOR_LI69HTIN69_69REEN_MACHINERY

/obj/machinery/computer/atmos_alert/Initialize()
	. = ..()
	atmosphere_alarm.re69ister_alarm(src, /atom.proc/update_icon)

/obj/machinery/computer/atmos_alert/Destroy()
	atmosphere_alarm.unre69ister_alarm(src)
	. = ..()

/obj/machinery/computer/atmos_alert/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/atmos_alert/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/data69069
	var/major_alarms69069
	var/minor_alarms69069

	for(var/datum/alarm/alarm in atmosphere_alarm.major_alarms(69et_z(src)))
		major_alarms69++major_alarms.len69 = list("name" = sanitize(alarm.alarm_name()), "ref" = "\ref69alarm69")

	for(var/datum/alarm/alarm in atmosphere_alarm.minor_alarms(69et_z(src)))
		minor_alarms69++minor_alarms.len69 = list("name" = sanitize(alarm.alarm_name()), "ref" = "\ref69alarm69")

	data69"priority_alarms"69 =69ajor_alarms
	data69"minor_alarms"69 =69inor_alarms

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atmos_alert.tmpl", src.name, 500, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/atmos_alert/update_icon()
	if(!(stat & (NOPOWER|BROKEN)))
		if(atmosphere_alarm.has_major_alarms(69et_z(src)))
			icon_screen = "alert:2"
		else if (atmosphere_alarm.has_minor_alarms(69et_z(src)))
			icon_screen = "alert:1"
		else
			icon_screen = initial(icon_screen)
	..()

/obj/machinery/computer/atmos_alert/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"clear_alarm"69)
		var/datum/alarm/alarm = locate(href_list69"clear_alarm"69) in atmosphere_alarm.alarms
		if(alarm)
			for(var/datum/alarm_source/alarm_source in alarm.sources)
				var/obj/machinery/alarm/air_alarm = alarm_source.source
				if(istype(air_alarm))
					air_alarm.forceClearAlarm()
					return 1
		return 1
