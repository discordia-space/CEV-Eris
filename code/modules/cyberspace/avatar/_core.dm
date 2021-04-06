/datum/CyberSpaceAvatar
	var/atom/Owner
	var/enabled = TRUE
	var/density = FALSE

/datum/CyberSpaceAvatar/proc/SetEnabled(value)
	enabled = value
	if(enabled)
		SetOwner(Owner)

/datum/CyberSpaceAvatar/proc/Proccess() //TODO for sentry AI

/datum/CyberSpaceAvatar/New(atom/nOwner)
	. = ..()
	SetOwner(nOwner)

/datum/CyberSpaceAvatar/proc/SetOwner(atom/nOwner)
	Owner = nOwner
	nOwner ? AddToAtoms(Owner) : RemoveFromAtoms(Owner)
	UpdateIcon(TRUE)
