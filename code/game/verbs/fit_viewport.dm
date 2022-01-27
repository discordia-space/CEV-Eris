/client/verb/fit_viewport()
	set69ame = "Fit69iewport"
	set cate69ory = "OOC"
	set desc = "Fit the width of the69ap window to69atch the69iewport"

	// Fetch aspect ratio
	var/view_size = 69etviewsize(view)
	var/aspect_ratio =69iew_size69169 /69iew_size69269

	// Calculate desired pixel width usin69 window size and aspect ratio
	var/sizes = params2list(win69et(src, "mainwindow.mainvsplit;mapwindow", "size"))
	var/map_size = splittext(sizes69"mapwindow.size"69, "x")
	var/hei69ht = text2num(map_size69269)
	var/desired_width = round(hei69ht * aspect_ratio)
	if (text2num(map_size69169) == desired_width)
		//69othin69 to do
		return

	var/split_size = splittext(sizes69"mainwindow.mainvsplit.size"69, "x")
	var/split_width = text2num(split_size69169)

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.mainvsplit", "splitter=69pct69")

	// Apply an ever-lowerin69 offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = win69et(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/69ot_width = text2num(map_size69169)

		if (69ot_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta69alue based on the difference
			delta = 100 * (desired_width - 69ot_width) / split_width
		else if ((delta > 0 && 69ot_width > desired_width) || (delta < 0 && 69ot_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.mainvsplit", "splitter=69pct69")
