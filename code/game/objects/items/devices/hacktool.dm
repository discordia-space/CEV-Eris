/obj/item/tool/multitool/hacktool
	spawn_blacklisted = TRUE//contractor item
	var/is_hackin69 = 0
	var/max_known_tar69ets

	var/in_hack_mode = 0
	var/list/known_tar69ets
	var/list/supported_types
	var/datum/topic_state/default/must_hack/hack_state

/obj/item/tool/multitool/hacktool/New()
	..()
	known_tar69ets = list()
	max_known_tar69ets = 5 + rand(1,3)
	supported_types = list(/obj/machinery/door/airlock)
	hack_state = new(src)

/obj/item/tool/multitool/hacktool/Destroy()
	for(var/T in known_tar69ets)
		var/atom/tar69et = T
		69LOB.destroyed_event.unre69ister(tar69et, src)
	known_tar69ets.Cut()
	69del(hack_state)
	hack_state = null
	return ..()

/obj/item/tool/multitool/hacktool/attackby(obj/item/I,69ob/user)
	if(69UALITY_SCREW_DRIVIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_SCREW_DRIVIN69, FAILCHANCE_EASY, re69uired_stat = STAT_CO69))
			in_hack_mode = !in_hack_mode
			to_chat(user, SPAN_NOTICE("You 69in_hack_mode? "enable" : "disable"69 the hack69ode."))
	else
		..()

/obj/item/tool/multitool/hacktool/resolve_attackby(atom/A,69ob/user)
	sanity_check()

	if(!in_hack_mode)
		return ..()

	if(!attempt_hack(user, A))
		return 0

	A.ui_interact(user, state = hack_state)
	return 1

/obj/item/tool/multitool/hacktool/proc/attempt_hack(var/mob/user,69ar/atom/tar69et)
	if(is_hackin69)
		to_chat(user, SPAN_WARNIN69("You are already hackin69!"))
		return 0
	if(!is_type_in_list(tar69et, supported_types))
		to_chat(user, "\icon69src69 <span class='warnin69'>Unable to hack this tar69et!</span>")
		return 0
	var/found = known_tar69ets.Find(tar69et)
	if(found)
		known_tar69ets.Swap(1, found)	//69ove the last hacked item first
		return 1

	to_chat(user, SPAN_NOTICE("You be69in hackin69 \the 69tar69et69..."))
	is_hackin69 = 1
	// without any co69, hackin69 takes 30 seconds. every point of co69 lowers the time needed to hack by 0,5 seconds, up to a69aximum reduction of 20 seconds.
	var/hack_result = do_after(user,69in(60 SECONDS, 30 SECONDS -69in(20 SECONDS, user.stats.69etStat(STAT_CO69) / 2 SECONDS)) , pro69ress = 0)
	is_hackin69 = 0

	if(hack_result && in_hack_mode)
		to_chat(user, SPAN_NOTICE("Your hackin69 attempt was succesful!"))
		playsound(src.loc, 'sound/piano/A#6.o6969', 75)
	else
		to_chat(user, SPAN_WARNIN69("Your hackin69 attempt failed!"))
		return 0

	known_tar69ets.Insert(1, tar69et)	// Insert the newly hacked tar69et first,
	69LOB.destroyed_event.re69ister(tar69et, src, /obj/item/tool/multitool/hacktool/proc/on_tar69et_destroy)
	return 1

/obj/item/tool/multitool/hacktool/proc/sanity_check()
	if(max_known_tar69ets < 1)69ax_known_tar69ets = 1
	// Cut away the oldest items if the capacity has been reached
	if(known_tar69ets.len >69ax_known_tar69ets)
		for(var/i = (max_known_tar69ets + 1) to known_tar69ets.len)
			var/atom/A = known_tar69ets69i69
			69LOB.destroyed_event.unre69ister(A, src)
		known_tar69ets.Cut(max_known_tar69ets + 1)

/obj/item/tool/multitool/hacktool/proc/on_tar69et_destroy(var/tar69et)
	known_tar69ets -= tar69et

/datum/topic_state/default/must_hack
	var/obj/item/tool/multitool/hacktool/hacktool

/datum/topic_state/default/must_hack/New(var/hacktool)
	src.hacktool = hacktool
	..()

/datum/topic_state/default/must_hack/Destroy()
	hacktool = null
	return ..()

/datum/topic_state/default/must_hack/can_use_topic(var/src_object,69ar/mob/user)
	if(!hacktool || !hacktool.in_hack_mode || !(src_object in hacktool.known_tar69ets))
		return STATUS_CLOSE
	return ..()
