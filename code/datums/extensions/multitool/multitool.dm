/datum/extension/multitool
	var/window_x = 370
	var/window_y = 470

/datum/extension/multitool/proc/interact(var/obj/item/tool/multitool/M,69ar/mob/user)
	if(extension_status(user) != STATUS_INTERACTIVE)
		return

	var/html = get_interact_window(M, user)
	if(html)
		var/datum/browser/popup = new(usr, "multitool", "Multitool69enu", window_x, window_y)
		popup.set_content(html)
		popup.set_title_image(user.browse_rsc_icon(M.icon,69.icon_state))
		popup.open()
	else
		close_window(usr)

/datum/extension/multitool/proc/get_interact_window(var/obj/item/tool/multitool/M,69ar/mob/user)
	return

/datum/extension/multitool/proc/close_window(var/mob/user)
	user << browse(null, "window=multitool")

/datum/extension/multitool/proc/buffer(var/obj/item/tool/multitool/multitool)
	. += "<b>Buffer69emory:</b><br>"
	var/buffer_name =69ultitool.get_buffer_name()
	if(buffer_name)
		. += "69buffer_name69 <a href='?src=\ref69src69;send=\ref69multitool.buffer_object69'>Send</a> <a href='?src=\ref69src69;purge=1'>Purge</a><br>"
	else
		. += "No connection stored in the buffer."

/datum/extension/multitool/extension_status(var/mob/user)
	if(!user.get_multitool())
		return STATUS_CLOSE
	. = ..()

/datum/extension/multitool/extension_act(href, href_list,69ar/mob/user)
	if(..())
		close_window(usr)
		return TRUE

	var/obj/item/tool/multitool/M = user.get_multitool()
	if(href_list69"send"69)
		var/atom/buffer = locate(href_list69"send"69)
		. = send_buffer(M, buffer, user)
	else if(href_list69"purge"69)
		M.set_buffer(null)
		. =69T_REFRESH
	else
		. = on_topic(href, href_list, user)

	switch(.)
		if(MT_REFRESH)
			interact(M, user)
		if(MT_CLOSE)
			close_window(user)
	return69T_NOACTION ? FALSE : TRUE

/datum/extension/multitool/proc/on_topic(href, href_list, user)
	return69T_NOACTION

/datum/extension/multitool/proc/send_buffer(var/obj/item/tool/multitool/M,69ar/atom/buffer,69ar/mob/user)
	if(M.get_buffer() == buffer && buffer)
		receive_buffer(M, buffer, user)
	else if(!buffer)
		to_chat(user, SPAN_WARNING("Unable to acquire data from the buffered object. Purging from69emory."))
	return69T_REFRESH

/datum/extension/multitool/proc/receive_buffer(var/obj/item/tool/multitool/M,69ar/atom/buffer,69ar/mob/user)
	return
