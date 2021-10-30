/datum/CyberSpaceAvatar/interactable/firewall/HackingTry(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	return do_after(user, 10 SECONDS, Owner,\
		needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE,\
		target_allowed_to_move = TRUE, move_range = 4) && !QDELETED(user)

/datum/CyberSpaceAvatar/interactable/firewall/Hacked(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar)
	var/obj/machinery/power/apc/A = Owner
	user.AccessCodes += A.CyberAccessCode
