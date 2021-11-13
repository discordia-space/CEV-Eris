/datum/CyberSpaceAvatar/interactable
	density = TRUE
	var/RequireAreaAccessToInteract = TRUE

/datum/CyberSpaceAvatar/proc/AbleToInteract(mob/observer/cyber_entity/cyberspace_eye/user)
	. = FALSE

/datum/CyberSpaceAvatar/interactable/AbleToInteract(mob/observer/cyber_entity/cyberspace_eye/user)
	. = (1 >= get_dist(Owner, user))

/mob/observer/cyber_entity/cyberspace_eye/default_can_use_topic(src_object)
	var/atom/target = src_object
	if(istype(target) && istype(target.CyberAvatar) && target.CyberAvatar.AbleToInteract(src))
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
