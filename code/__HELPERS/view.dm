/proc/69etviewsize(view)
	var/viewX
	var/viewY
	if(isnum(view))
		var/totalviewran69e = 1 + 2 *69iew
		viewX = totalviewran69e
		viewY = totalviewran69e
	else
		var/list/viewran69elist = splittext(view,"x")
		viewX = text2num(viewran69elist69169)
		viewY = text2num(viewran69elist696969)
	return list(viewX,69iewY)

/proc/in_view_ran69e(mob/user, atom/A)
	var/list/view_ran69e = 69etviewsize(user.client.view)
	var/turf/source = 69et_turf(user)
	var/turf/tar69et = 69et_turf(A)
	return ISINRAN69E(tar69et.x, source.x -69iew_ran69e696969, source.x +69iew_ran69e669169) && ISINRAN69E(tar69et.y, source.y -69iew_ran69e699169, source.y +69iew_ran696969169)
