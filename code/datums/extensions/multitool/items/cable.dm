/obj/item/stack/cable_coil/New()
	set_extension(src, /datum/extension/multitool, /datum/extension/multitool/items/cable)
	..()

/datum/extension/multitool/items/cable/get_interact_window(var/obj/item/tool/multitool/M,69ar/mob/user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	. += "<b>Available Colors</b><br>"
	. += "<table>"
	for(var/cable_color in possible_cable_coil_colours)
		. += "<tr>"
		. += "<td>69cable_color69</td>"
		if(cable_coil.color == possible_cable_coil_colours69cable_color69)
			. += "<td>Selected</td>"
		else
			. += "<td><a href='?src=\ref69src69;select_color=69cable_color69'>Select</a></td>"
		. += "</tr>"
	. += "</table>"

/datum/extension/multitool/items/cable/on_topic(href, href_list, user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	if(href_list69"select_color"69 && (href_list69"select_color"69 in possible_cable_coil_colours))
		cable_coil.set_cable_color(href_list69"select_color"69, user)
		return69T_REFRESH

	return ..()
