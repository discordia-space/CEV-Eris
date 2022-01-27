/datum/reagents/proc/get_color()
	return69ix_color_from_reagents(reagent_list)

/proc/mix_color_from_reagents(list/reagent_list)
	if(!istype(reagent_list) || !reagent_list.len)
		return "#ffffffff"

	var/mixcolor
	var/vol_counter = 0
	var/vol_temp

	for(var/datum/reagent/R in reagent_list)
		vol_temp = R.volume
		vol_counter +=69ol_temp

		if(!mixcolor)
			mixcolor = R.color

		else if (length(mixcolor) >= length(R.color))
			mixcolor = BlendRGB(mixcolor, R.color,69ol_temp/vol_counter)
		else
			mixcolor = BlendRGB(R.color,69ixcolor,69ol_temp/vol_counter)

	return69ixcolor
