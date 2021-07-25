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

/atom/proc/CreateCA(_color = CyberAvatar)
	if(istype(CyberAvatar))
		qdel(CyberAvatar)
	if(ispath(CyberAvatar_inittype))
		CyberAvatar = new CyberAvatar_inittype(src)
	else
		CyberAvatar = new(src)
	if(istext(_color))
		CyberAvatar.SetColor(_color)
