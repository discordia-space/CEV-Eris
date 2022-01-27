/mob/observer/eye/angel/Logout()
	..()
	spawn(0)
		if(src && !key)	//we've transferred to another69ob. This ghost should be deleted.
			qdel(src)
