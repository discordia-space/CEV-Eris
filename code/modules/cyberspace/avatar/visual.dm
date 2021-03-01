/datum/CyberSpaceAvatar/proc/ShowToClient(client/viewerClient, forced = FALSE)
	if((enabled || forced) && viewerClient?.ckey && !viewerClient.AlreadySeeThisCyberAvatar(src))
		viewerClient.images |= Icon

/datum/CyberSpaceAvatar/proc/HideFromClient(client/viewerClient, forced = TRUE)
	if((enabled || forced) && viewerClient?.ckey && viewerClient.AlreadySeeThisCyberAvatar(src))
		viewerClient.images -= Icon
