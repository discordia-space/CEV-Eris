/image
	var/list/SynchronizedAtoms = list()

/image/proc/SyncWithAtom(atom/D, withIcon = TRUE, withState = TRUE, withFlicks = TRUE)
	if(istype(D))
		SynchronizedAtoms[D] = args.Copy(2)
//		var/list/types_of_sync = SynchronizedAtoms[D]
		if(withIcon)
			icon_synchronization(D, D.icon)
//			types_of_sync[1] = .proc/icon_synchronization
		if(withState)
			icon_state_synchronization(D, D.icon_state)
//			types_of_sync[2] = .proc/icon_state_synchronization
		if(withFlicks)
			GLOB.flicker_event.register(D, src, .proc/flick_synchronization)
//			types_of_sync[3] = .proc/flick_synchronization
	else
		CRASH("[D](\ref[D]) is not atom, aborting /image/proc/SyncWithAtom. Additional info: {[json_encode(args)]}")

/image/proc/BreakSync(atom/D, breakIcon = TRUE, breakState = TRUE, breakFlicks = TRUE)
	if(istype(D) && SynchronizedAtoms.Find(D))
		var/list/data_of_sync = SynchronizedAtoms[D]
		var/list/types_to_break = args.Copy(2)
		if(length(data_of_sync) >= length(types_to_break))
			
			// for(var/whatNeedToBreak in types_to_break)
			// 	if(whatNeedToBreak)
			// 		data_of_sync.Remove(whatNeedToBreak)
			// 		GLOG.	.unregister(D, src, whatNeedToBreak)
			if(breakIcon && data_of_sync[1])
				data_of_sync[1] = null
				GLOB.set_icon_event.unregister(D, src, .proc/icon_synchronization)
			if(breakState && data_of_sync[2])
				data_of_sync[2] = null
				GLOB.set_icon_state_event.unregister(D, src, .proc/icon_synchronization)
			if(breakFlicks && data_of_sync[3])
				data_of_sync[3] = null
				GLOB.flicker_event.unregister(D, src, .proc/flick_synchronization)

	
			var/is_still_synced = FALSE
			for(var/syncronization_type in data_of_sync)
				is_still_synced = is_still_synced || syncronization_type
				if(is_still_synced)
					break
			if(!is_still_synced)
				SynchronizedAtoms.Remove(D)

/image/proc/icon_synchronization(atom/D, _icon, isByEvent = TRUE)
	if(isByEvent)
		GLOB.set_icon_event.register(D, src, .proc/icon_synchronization)
	icon = _icon

/image/proc/icon_state_synchronization(atom/D, _icon_state, isByEvent = TRUE)
	if(isByEvent)
		GLOB.set_icon_state_event.register(D, src, .proc/icon_state_synchronization)
	icon_state = _icon_state

/image/proc/flick_synchronization(atom/D, iconOrState, isByEvent = TRUE)
	if(QDELETED(D))
		return BreakSync(D)
	if(isByEvent)
		GLOB.flicker_event.register(D, src, .proc/flick_synchronization)
	return flicker(iconOrState)

/image/Destroy()
	for(var/atom/A in SynchronizedAtoms)
		BreakSync(A)
	. = ..()
