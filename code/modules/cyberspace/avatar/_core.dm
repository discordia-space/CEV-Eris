GLOBAL_LIST_EMPTY(CyberSpaceAtoms)
/datum/CyberSpaceAvatar
	var/atom/Owner

/datum/CyberSpaceAvatar/New(atom/nOwner)
	. = ..()
	SetOwner(nOwner)

/datum/CyberSpaceAvatar/proc/SetOwner(atom/nOwner)
	Owner = nOwner
	if(nOwner)
		GLOB.CyberSpaceAtoms |= Owner
	else
		GLOB.CyberSpaceAtoms -= Owner
	UpdateIcon(TRUE)
