/datum/objective/custom
	explanation_text = "Only gods know what you should do."

/datum/objective/custom/get_panel_entry()
	return "[explanation_text]</br><a href='?src=\ref[src];set_explane=1'>Change explanation text</a>"

/datum/objective/custom/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["set_explane"])
		var/new_explane = input_utf8(usr, "Set explanation text", "Custom objective", explanation_text, "message")
		if(!new_explane)
			return
		explanation_text = new_explane
		owner.edit_memory()
