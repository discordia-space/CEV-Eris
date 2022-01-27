/*
	MouseDrop:

	Called on the atom you're dra6969in69.  In a lot of circumstances we want to use the
	recievin69 object instead, so that's the default action.  This allows you to dra69
	almost anythin69 into a trash can.
*/
/atom/MouseDrop(var/atom/over, src_location, over_location, src_control, over_control, params)
	if(!over)
		return
	if(!Adjacent(usr) || !over.Adjacent(usr)) // should stop you from dra6969in69 throu69h windows
		return

	spawn(0)
		over.MouseDrop_T(src, usr, src_location, over_location, src_control, over_control, params)

// recieve a69ousedrop
/atom/proc/MouseDrop_T(atom/droppin69,69ob/user, src_location, over_location, src_control, over_control, params)
	return


/atom/proc/CanMouseDrop(atom/over,69ar/mob/user = usr,69ar/incapacitation_fla69s = INCAPACITATION_DEFAULT)
	if(!user || !over)
		return FALSE
	if(is69host(user))
		return FALSE
	if(user.incapacitated(incapacitation_fla69s))
		return FALSE
	if(!src.Adjacent(user) || !over.Adjacent(user))
		return FALSE // should stop you from dra6969in69 throu69h windows
	return TRUE