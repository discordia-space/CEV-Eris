/mob/var/_SeeCyberSpace = FALSE

/mob/Login()
	. = ..()
	UpdateCyberVisuals()

/mob/proc/CanSeeCyberSpace()
	return client && _SeeCyberSpace

/mob/proc/UpdateCyberVisuals()
	if(CanSeeCyberSpace())
		client.AddCyberspaceBackground()
		for(var/atom/A in range(client.view + 1, src))
		//for(var/atom/A in GLOB.CyberSpaceAtoms)
			A.CyberAvatar?.ShowToClient(client)
		GLOB.moved_event.register(src, src, /mob/proc/UpdateCyberVisuals)
		SScyberspace.AddToViewers(src)
	else
		if(client)
			client.RemoveCyberspaceBackground()
			for(var/atom/A in range(client.view + 1, src))
			//for(var/atom/A in GLOB.CyberSpaceAtoms)
				A.CyberAvatar?.HideFromClient(client)
		GLOB.moved_event.unregister(src, src, /mob/proc/UpdateCyberVisuals)
		SScyberspace.RemoveFromViewers(src)

/client/proc/AlreadySeeThisCyberAvatar(datum/CyberSpaceAvatar/CA)
	. = istype(CA) && images.Find(CA.Icon)

/mob/proc/SetSeeCyberSpace(value)
	_SeeCyberSpace = value
	if(value)
		SScyberspace.InitCyberspace()
	UpdateCyberVisuals()

/mob/Destroy()
	SetSeeCyberSpace(FALSE)
	. = ..()
