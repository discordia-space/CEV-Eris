/datum/CyberSpaceAvatar/ice/HackingTry(mob/observer/cyber_entity/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..()
	if(istype(Owner, /mob/observer/cyber_entity))
		var/mob/observer/cyber_entity/C = Owner
		if(C.Hacked)
			return FALSE
		if(do_after(user, 10 SECONDS, Owner,\
			needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE,\
			target_allowed_to_move = TRUE, move_range = 4)\
		)
			return TRUE
		else
			return FALSE

/datum/CyberSpaceAvatar/ice/Hacked(mob/observer/cyber_entity/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	if(istype(Owner, /mob/observer/cyber_entity))
		var/mob/observer/cyber_entity/C = Owner
		C.Hacked = TRUE
