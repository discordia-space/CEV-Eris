/datum/extension/multitool/store/interact(var/obj/item/tool/multitool/M,69ar/mob/user)
	if(CanUseTopic(user) != STATUS_INTERACTIVE)
		return

	if(M.get_buffer() == holder)
		M.set_buffer(null)
		to_chat(user, SPAN_WARNING("You purge the connection data of \the 69holder69 from \the 69M69."))
	else
		M.set_buffer(holder)
		to_chat(user, SPAN_NOTICE("You load connection data from \the 69holder69 to \the 69M69."))
