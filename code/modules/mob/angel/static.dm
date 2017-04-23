/proc/getStaticIcon(icon/A, safety=1)
	var/icon/flat_icon = safety ? A : new(A)
	flat_icon.Blend(rgb(255,255,255))
	flat_icon.BecomeAlphaMask()
	var/icon/static_icon = new/icon('icons/effects/cameravis.dmi', "static_base")
	static_icon.AddAlphaMask(flat_icon)
	return static_icon

/mob/observer/eye/angel/proc/updateSeeStaticMobs()
	if(!client)
		return

	for(var/i in staticOverlays)
		client.images.Remove(i)
		staticOverlays.Remove(i)

	for(var/mob/living/L in mob_list)
		staticOverlays |= L.staticOverlay
		client.images |= L.staticOverlay
