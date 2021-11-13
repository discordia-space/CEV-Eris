/obj/machinery/power/apc
	var/CyberAlarmLevel = 0
	var/DefaultLevelDelta = 0.2
	var/list/AlarmLevelsToProcs = list(
		"1" = .proc/DeployIces,
		"2" = list(.proc/DeployIces, 2),
		"3" = list(.proc/DeployIces, 3),
		"4" = list(\
			.proc/DeployIces, list(1, /mob/observer/cyber_entity/IceHolder/black_ice),\
			.proc/AnnounceAlarm, null\
		),
		"5" = list(\
			.proc/DeployIces,list(2, /mob/observer/cyber_entity/IceHolder/black_ice),\
			.proc/ScanAreaRevealXYZOfRunners, null\
		),
	)
	var/obj/item/device/radio/Announcer = new

	var/list/ICEAssortiment = list(
		/mob/observer/cyber_entity/IceHolder/cyberassassin,
		/mob/observer/cyber_entity/IceHolder/spooklet,
		/mob/observer/cyber_entity/IceHolder/spearman
	)

/obj/machinery/power/apc/Process(wait)
	. = ..()
	RaiseAlarmLevel(-DefaultLevelDelta / 10) //8 minutes 20 seconds is default time of lowing alarm level to zero

/obj/machinery/power/apc/proc/RaiseAlarmLevel(value = DefaultLevelDelta)
	var/old_value = FLOOR(CyberAlarmLevel, 1)
	CyberAlarmLevel += value
	var/current = FLOOR(CyberAlarmLevel, 1)
	if(old_value != current)
		var/l = length(AlarmLevelsToProcs)
		var/toobig = (old_value > l)
		var/delta = current - old_value
		for(var/i in 1 to delta)
			if(toobig)
				TriggerAlarmLevelEffect(AlarmLevelsToProcs[l])
			else
				TriggerAlarmLevelEffect("[old_value + i]")

/obj/machinery/power/apc/proc/TriggerAlarmLevelEffect(textLevel)
	if(textLevel in AlarmLevelsToProcs)
		var/list/procToCall = AlarmLevelsToProcs[textLevel]
		if(istype(procToCall) && length(procToCall) >= 2)
			for(var/i in 2 to length(procToCall) step 2)
				call(src, procToCall[i-1])(procToCall[i])
			return
		call(src, AlarmLevelsToProcs[textLevel])()

/obj/machinery/power/apc/proc/DeployIces(list/arguments = 1) // amount; [amount, forced_type]
	var/area/A = get_area(src)
	var/list/amount = arguments
	if(isnum(amount))
		var/mob/observer/cyber_entity/IceHolder/t = pick(ICEAssortiment)
		CreateICE(t, pick_area_turf(A))
	else if(islist(amount))
		var/forcedIceType
		. = amount
		if(length(amount) >= 2)
			forcedIceType = amount[2]
		amount = amount[1]
		for(var/i in 1 to amount)
			var/mob/observer/cyber_entity/IceHolder/t = forcedIceType
			if(!forcedIceType)
				t = pick(ICEAssortiment)
			CreateICE(t, pick_area_turf(A))

/obj/machinery/power/apc/proc/CreateICE(mob/observer/cyber_entity/IceHolder/prefab, turf/where)
	var/mob/observer/cyber_entity/IceHolder/I = new prefab(where)
	I.MyFirewall = src

/obj/machinery/power/apc/proc/ScanAreaRevealXYZOfRunners(list/arguments)
	. = 0
	radio_message("Intrusion alert, probbing area.")
	for(var/mob/observer/cyber_entity/cyberspace_eye/r in get_area(src))
		spawn(. SECONDS + rand(1, 3) SECONDS)
			if(!QDELETED(r) && r.owner)
				var/turf/host = get_turf(r.owner)
				radio_message("Trasing complete: ZXY:([host.z]:[host.x]:[host.y]).")
		. += 1

/obj/machinery/power/apc/proc/AnnounceAlarm(list/arguments)
	. = radio_message("Cyberspace alarm level has reached [CyberAlarmLevel]. Area ZXY:([z]:[x]:[y]).")

/obj/machinery/power/apc/proc/radio_message(msg, author = "Intrusion Countermeasures Engrams' System", _name = name)
	return Announcer.autosay(
		SPAN_WARNING("[_name]: ") + "[msg]",
		author
	)
