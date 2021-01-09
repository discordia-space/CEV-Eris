/datum/CyberSpaceAvatar/proc/ShowToClient(client/viewerClient)
	if(viewerClient?.ckey && !viewerClient.images.Find(Icon))
		viewerClient.images |= Icon

/datum/CyberSpaceAvatar/proc/HideFromClient(client/viewerClient)
	if(viewerClient?.ckey && viewerClient.images.Find(Icon))
		viewerClient.images -= Icon
