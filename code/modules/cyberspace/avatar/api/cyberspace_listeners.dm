GLOBAL_LIST_EMPTY(CyberListeners)
/datum/CyberSpaceAvatar
	var/ListenToSurrounding = FALSE
	New()
		. = ..()
		SetListenToSurrounding(ListenToSurrounding)
	proc/SetListenToSurrounding(value)
		if(value)
			GLOB.CyberListeners |= src
		else
			GLOB.CyberListeners -= src
		ListenToSurrounding = value
	proc/AnotherAvatarFound(datum/CyberSpaceAvatar/avatar)
