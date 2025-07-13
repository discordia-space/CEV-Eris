/datum/extension/multitool/store/interact(obj/item/tool/multitool/M, mob/user)
	if(CanUseTopic(user) != STATUS_INTERACTIVE)
		return

	if(M.get_buffer() == holder)
		M.set_buffer(null)
		to_chat(user, span_warning("You purge the connection data of \the [holder] from \the [M]."))
	else
		M.set_buffer(holder)
		to_chat(user, span_notice("You load connection data from \the [holder] to \the [M]."))
