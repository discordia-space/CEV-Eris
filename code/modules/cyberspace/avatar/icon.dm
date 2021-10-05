/datum/CyberSpaceAvatar
	var/tmp/image/Icon
	var/color = CYBERSPACE_MAIN_COLOR
	var/icon_file
	var/icon_state

/datum/CyberSpaceAvatar/proc/UpdateIcon(forced) //handle underlays, icon and overlays in separated icons 
	if(enabled && Owner)
		if(!istype(Owner))
			CRASH("Somebody set datum/CyberSpaceAvatar(\ref[src]) to follow not atom([Owner.type]>\ref[Owner][Owner]")
		var/IsIconForced = (icon_file || icon_state)
		if(!Icon)
			Icon = image(,Owner,)
			Icon.plane = FULLSCREEN_PLANE + 1
			//Icon.layer = FULLSCREEN_LAYER
			if(!IsIconForced)
				Icon.SyncWithAtom(Owner)
		if(IsIconForced)
			Icon.icon = icon_file
			Icon.icon_state = icon_state
		_updateImage_icon(Icon)
		if(ismovable(Owner))
			GLOB.moved_event.register(Owner, src, /datum/CyberSpaceAvatar/proc/UpdateIcon)
		GLOB.dir_set_event.register(Owner, src, /datum/CyberSpaceAvatar/proc/UpdateIcon)
		if(forced)
			for(var/mob/viewer in GLOB.CyberSpaceViewers)
				viewer.client && ShowToClient(viewer.client)
	else
		for(var/mob/viewer in GLOB.CyberSpaceViewers)
			viewer.client && HideFromClient(viewer.client)

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

/datum/CyberSpaceAvatar/proc/ShowToClient(client/viewerClient, forced = FALSE)
	if((enabled || forced) && viewerClient?.ckey && !viewerClient.AlreadySeeThisCyberAvatar(src))
		viewerClient.images |= Icon

/datum/CyberSpaceAvatar/proc/HideFromClient(client/viewerClient, forced = TRUE)
	if((enabled || forced) && viewerClient?.ckey && viewerClient.AlreadySeeThisCyberAvatar(src))
		viewerClient.images -= Icon
