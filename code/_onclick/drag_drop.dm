/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	recieving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(!over)
		return
	if(!Adjacent(usr) || !over.Adjacent(usr)) // should stop you from dragging through windows
		return

	over.MouseDrop_T(src, usr, src_location, over_location, src_control, over_control, params)
	SEND_SIGNAL(over, COMSIG_DRAGDROP, src, usr, src_location, over_location, src_control, over_control, params)

// recieve a mousedrop
/atom/proc/MouseDrop_T(atom/dropping, mob/user, src_location, over_location, src_control, over_control, params)
	return


/atom/proc/CanMouseDrop(atom/over, var/mob/user = usr, var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if(!user || !over)
		return FALSE
	if(isghost(user))
		return FALSE
	if(user.incapacitated(incapacitation_flags))
		return FALSE
	if(!src.Adjacent(user) || !over.Adjacent(user))
		return FALSE // should stop you from dragging through windows
	return TRUE
