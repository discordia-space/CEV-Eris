/obj/machinery/power/apc
	var/CyberAlarmLevel = 0
	var/list/AlarmLevelsToProcs = list(
		"5" = .proc/AnnounceAlarm
	)
	var/obj/item/device/radio/Announcer = new

/obj/machinery/power/apc/proc/RaiseAlarmLevel(value = 0.2)
	var/old_value = CyberAlarmLevel
	CyberAlarmLevel += value
	if(round(old_value) != round(CyberAlarmLevel))
		TriggerAlarmLevelEffect("[round(CyberAlarmLevel)]")

/obj/machinery/power/apc/proc/TriggerAlarmLevelEffect(textLevel)
	if(textLevel in AlarmLevelsToProcs)
		call(src, AlarmLevelsToProcs[textLevel])()

/obj/machinery/power/apc/proc/AnnounceAlarm()
	. = Announcer.autosay(
		SPAN_WARNING("[name]:") + " Cyberspace alarm level has reached [CyberAlarmLevel]. Area X:[x]:Y:[y]:Z:[z].",
		"Intrusion Countermeasures Engrams' System"
	)
