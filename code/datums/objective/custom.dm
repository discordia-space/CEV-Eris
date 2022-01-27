/datum/objective/custom
	explanation_text = "Only gods know what you should do."

/datum/objective/custom/get_panel_entry()
	return "69explanation_text69</br><a href='?src=\ref69src69;set_explane=1'>Change explanation text</a>"

/datum/objective/custom/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list69"set_explane"69)
		var/new_explane = input(usr, "Set explanation text", "Custom objective", explanation_text, "message")
		if(!new_explane)
			return
		explanation_text = new_explane
		antag.antagonist_panel()
