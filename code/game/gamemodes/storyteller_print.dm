/datum/storyteller/proc/announce_antagonists()
	return "Not implemented yet"

/datum/storyteller/proc/antagonist_report()
	return "Not implemented yet"

/datum/storyteller/proc/storyteller_panel()
	var/data = "<i>If you see it, it means I still haven't made this panel.</i>"

	usr << browse(data,"window=story")

/datum/storyteller/Topic(href,href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["panel"])
		storyteller_panel()

/datum/storyteller/proc/print_required_roles()
	var/text = "[name]'s required roles:"
	for(var/reqrole in required_jobs)
		text += "<br> - [reqrole]"
	return text

