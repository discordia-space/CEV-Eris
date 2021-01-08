/datum/CyberSpaceAvatar
	var/atom/Owner

/datum/CyberSpaceAvatar/New(atom/nOwner)
	. = ..()
	Owner = nOwner
	UpdateIcon()
