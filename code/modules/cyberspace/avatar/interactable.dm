/datum/CyberSpaceAvatar/interactable
	density = TRUE

/datum/CyberSpaceAvatar/proc/AbleToInteract(mob/observer/cyberspace_eye/user)
	. = FALSE

/datum/CyberSpaceAvatar/interactable/AbleToInteract(mob/observer/cyberspace_eye/user)
	. = (1 >= get_dist(Owner, user))

/datum/CyberSpaceAvatar/ClickedByAvatar(mob/user_avatar, datum/CyberSpaceAvatar/user)
	. = ..()
	var/mob/observer/cyberspace_eye/avatar = user?.Owner
	if(istype(avatar) && avatar.a_intent == I_HELP)
		Owner.ui_interact(avatar, state = GLOB.netrunner_state)

/mob/observer/cyberspace_eye/default_can_use_topic(src_object)
	var/atom/target = src_object
	if(istype(target?.CyberAvatar) && target.CyberAvatar.AbleToInteract(src))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE

/datum/CyberSpaceAvatar/interactable/SetOwner(atom/nOwner)
	if(nOwner && Owner != nOwner)
		SyncDensity(nOwner, Owner ? Owner.density : null, nOwner.density)
		if(Owner)
			GLOB.density_set_event.unregister(Owner, src, .proc/SyncDensity)
	. = ..()

/datum/CyberSpaceAvatar/interactable/proc/SyncDensity(atom/Target, _old_density, _density)
	if(istype(Target))
		density = Target.density
	else
		density = _density
	GLOB.density_set_event.register(Target, src, .proc/SyncDensity)
