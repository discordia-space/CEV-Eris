/mob/observer/eye/angel/Login()
	..()

	visualnet.updateVisibility(owner, 0)
	visualnet.visibility(src)
	update_see_static_mobs()
