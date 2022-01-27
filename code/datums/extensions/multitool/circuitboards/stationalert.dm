/datum/extension/multitool/circuitboards/stationalert/get_interact_window(var/obj/item/tool/multitool/M,69ar/mob/user)
	var/obj/item/electronics/circuitboard/stationalert/SA = holder
	. += "<b>Alarm Sources</b><br>"
	. += "<table>"
	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		. += "<tr>"
		. += "<td>69AH.category69</td>"
		if(AH in SA.alarm_handlers)
			. += "<td><span class='good'>&#9724</span>Active</td><td><a href='?src=\ref69src69;remove=\ref69AH69'>Inactivate</a></td>"
		else
			. += "<td><span class='bad'>&#9724</span>Inactive</td><td><a href='?src=\ref69src69;add=\ref69AH69'>Activate</a></td>"
		. += "</tr>"
	. += "</table>"

/datum/extension/multitool/circuitboards/stationalert/on_topic(href, href_list, user)
	var/obj/item/electronics/circuitboard/stationalert/SA = holder
	if(href_list69"add"69)
		var/datum/alarm_handler/AH = locate(href_list69"add"69) in SSalarm.all_handlers
		if(AH)
			SA.alarm_handlers |= AH
			return69T_REFRESH

	if(href_list69"remove"69)
		var/datum/alarm_handler/AH = locate(href_list69"remove"69) in SSalarm.all_handlers
		if(AH)
			SA.alarm_handlers -= AH
			return69T_REFRESH

	return ..()
