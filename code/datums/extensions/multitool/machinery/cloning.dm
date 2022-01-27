/datum/extension/multitool/cryo/get_interact_window(var/obj/item/tool/multitool/M,69ar/mob/user)
	. += buffer(M)
	. += "<HR><b>Connected Cloning Pods:</b><br>"
	var/obj/machinery/computer/cloning/C = holder
	for(var/atom/cloning_pod in C.pods)
		. += "69cloning_pod.name69<br>"

/datum/extension/multitool/cryo/receive_buffer(var/obj/item/tool/multitool/M,69ar/atom/buffer,69ar/mob/user)
	var/obj/machinery/clonepod/P = buffer
	var/obj/machinery/computer/cloning/C = holder

	if(!istype(P))
		to_chat(user, SPAN_WARNING("No69alid connection data in \the 69M69 buffer."))
		return69T_NOACTION

	var/is_connected = (P in C.pods)
	if(!is_connected)
		if(C.connect_pod(P))
			to_chat(user, SPAN_NOTICE("You connect \the 69P69 to \the 69C69."))
		else
			to_chat(user, SPAN_WARNING("You failed to connect \the 69P69 to \the 69C69."))
		return69T_REFRESH

	if(C.release_pod(P))
		to_chat(user, SPAN_NOTICE("You disconnect \the 69P69 from \the 69C69."))
	else
		to_chat(user, SPAN_NOTICE("You failed to disconnect \the 69P69 from \the 69C69."))
	return69T_REFRESH
