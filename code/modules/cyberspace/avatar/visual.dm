/datum/CyberSpaceAvatar/proc/ShowToClient(client/viewerClient)
	if(enabled && viewerClient?.ckey && !viewerClient.AlreadySeeThisCyberAvatar(src))
		viewerClient.images |= Icon

/datum/CyberSpaceAvatar/proc/HideFromClient(client/viewerClient)
	if(enabled && viewerClient?.ckey && viewerClient.AlreadySeeThisCyberAvatar(src))
		viewerClient.images -= Icon
