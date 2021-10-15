/datum/CyberSpaceAvatar
	var/atom/movable/Owner
	var/enabled = TRUE
	var/density = FALSE

/datum/CyberSpaceAvatar/proc/SetEnabled(value)
	enabled = value
	if(enabled)
		SetOwner(Owner)

/datum/CyberSpaceAvatar/proc/Proccess(wait, times_fired, controller) //TODO for sentry AI

/datum/CyberSpaceAvatar/New(atom/nOwner)
	. = ..()
	SetOwner(nOwner)

/datum/CyberSpaceAvatar/proc/SetOwner(atom/nOwner)
	if(Owner != nOwner)
		AddToAtoms(nOwner)
		RemoveFromAtoms(Owner)
		Owner = nOwner
	UpdateIcon(TRUE)

/atom/proc/CreateCA(_color = CyberAvatar)
	if(istype(CyberAvatar))
		qdel(CyberAvatar)
	if(ispath(CyberAvatar_prefab))
		CyberAvatar = new CyberAvatar_prefab(src)
	else
		CyberAvatar = new(src)
	if(istext(_color))
		CyberAvatar.SetColor(_color)

/datum/CyberSpaceAvatar/proc/GetBody()
	var/mob/observer/cyberspace_eye/eye = Owner
	if(istype(eye))
		var/mob/living/carbon/human/body = eye.owner?.get_user()
		if(istype(body))
			return body

