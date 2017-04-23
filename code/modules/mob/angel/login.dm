/mob/observer/eye/angel/Login()
	..()

	visualnet.updateVisibility(owner, 0)
	visualnet.visibility(src)
	updateSeeStaticMobs()