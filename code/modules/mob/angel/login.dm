/mob/observer/eye/angel/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	visualnet.updateVisibility(owner, 0)
	visualnet.visibility(src)
	update_see_static_mobs()
