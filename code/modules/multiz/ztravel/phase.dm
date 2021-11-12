/*
	Instantly skip to the destination without any waiting or animation.
	This is basically an OOC movement used by ghosts, AI eye, and bluespace technicians.
*/
/datum/vertical_travel_method/phase
	slip_chance = 0

/datum/vertical_travel_method/phase/can_perform()
	.=..()
	if (.)
		if (istype(M, /mob/observer))
			return TRUE
		if (ismob(M) && mob.incorporeal_move)
			return TRUE

		return FALSE


/datum/vertical_travel_method/phase/start(var/dir)
	//There is no middle, jump straight to the end
	finish()
	delete_self()
