/datum/CyberSpaceAvatar
	var/tmp/image/Icon
	var/color = CYBERSPACE_MAIN_COLOR

/datum/CyberSpaceAvatar/proc/UpdateIcon(forced) //handle underlays, icon and overlays in separated icons 
	if(enabled && Owner)
		if(!istype(Owner))
			CRASH("Somebody set datum/CyberSpaceAvatar(\ref[src]) to follow not atom([Owner])")
		if(!Icon)
			Icon = image(,Owner,)
			Icon.SyncWithAtom(Owner)
			Icon.plane = FULLSCREEN_PLANE
			Icon.layer = FULLSCREEN_LAYER + 0.01
		_updateImage_icon(Icon)
		if(ismovable(Owner))
			GLOB.moved_event.register(Owner, src, /datum/CyberSpaceAvatar/proc/UpdateIcon)
		GLOB.dir_set_event.register(Owner, src, /datum/CyberSpaceAvatar/proc/UpdateIcon)
		if(forced)
			for(var/mob/viewer in GLOB.CyberSpaceViewers)
				viewer.client && ShowToClient(viewer.client)

/datum/CyberSpaceAvatar/proc/SetColor(value)
	color = value
	if(enabled && Owner)
		_updateImage_icon(Icon)

/datum/CyberSpaceAvatar/proc/_updateImage_icon(image/iIcon)
	//iIcon.SyncWithAtom(Owner)
	iIcon.color = color

/datum/CyberSpaceAvatar/Destroy()
	istype(Icon) && qdel(Icon)
	for(var/mob/viewer in GLOB.CyberSpaceViewers)
		viewer.client && HideFromClient(viewer.client)
	. = ..()