/mob/var/_SeeCyberSpace = FALSE

/mob/Login()
	. = ..()
	UpdateCyberVisuals()

/mob/proc/CanSeeCyberSpace()
	return client && _SeeCyberSpace
/atom/proc/CyberRange(radius = world.view) // Returns atoms with cyberavatars in range
	. = list()
	for(var/atom/A in range(radius, src))
		if(istype(A.CyberAvatar))
			. += A
/mob/proc/UpdateCyberVisuals()
	if(CanSeeCyberSpace())
		client.AddCyberspaceBackground()
		for(var/atom/A in CyberRange(client.view + 1))
		//for(var/atom/A in GLOB.CyberSpaceAtoms)
			A.CyberAvatar.ShowToClient(client)
		GLOB.moved_event.register(src, src, /mob/proc/UpdateCyberVisuals)
		AddToViewers(src)
	else
		if(client)
			client.RemoveCyberspaceBackground()
			for(var/atom/A in GLOB.CyberSpaceAtoms)
			//for(var/atom/A in GLOB.CyberSpaceAtoms)
				if(istype(A.CyberAvatar))
					A.CyberAvatar.HideFromClient(client)
		GLOB.moved_event.unregister(src, src, /mob/proc/UpdateCyberVisuals)
		RemoveFromViewers(src)

/client/proc/AlreadySeeThisCyberAvatar(datum/CyberSpaceAvatar/CA)
	. = istype(CA) && images.Find(CA.Icon)

/mob/proc/SetSeeCyberSpace(value)
	_SeeCyberSpace = value
	UpdateCyberVisuals()

/mob/Destroy()
	SetSeeCyberSpace(FALSE)
	. = ..()
