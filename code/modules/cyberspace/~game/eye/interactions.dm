/datum/CyberSpaceAvatar/ClickedByAvatar(mob/user_avatar, datum/CyberSpaceAvatar/user)
	. = ..()
	var/mob/observer/cyberspace_eye/avatar = user_avatar
	if(istype(avatar))
		switch(avatar.a_intent)
			if(I_HELP)
				. = HelpInteraction(avatar, user)
			if(I_HURT)
				. = HurtInteraction(avatar, user)
			if(I_GRAB)
				. = GrabInteraction(avatar, user)
			if(I_DISARM)
				. = DisarmInteraction(avatar, user)

/datum/CyberSpaceAvatar/proc/HelpInteraction(mob/observer/cyberspace_eye/user_avatar, datum/CyberSpaceAvatar/user)
	var/mob/observer/cyberspace_eye/O = Owner
	if(istype(O))
		to_chat(user_avatar, "You are trying to fix [O]")
		if(do_after(user_avatar, 2 SECONDS, O, needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE))
			return O.ChangeHP(0, O.Might)
		else
			to_chat(user_avatar, SPAN_WARNING("Fixing failed."))
			return
	return Owner.ui_interact(user_avatar, state = GLOB.netrunner_state)

/mob/observer/cyberspace_eye/proc/ChangeHP(percents = 0.05, amount = FALSE)
	if(!amount)
		amount = maxHP * percents
	. = HP
	HP = clamp(HP + amount, 0, maxHP)
	. = HP - .
	update_hud()

/datum/CyberSpaceAvatar/proc/HurtInteraction(mob/observer/cyberspace_eye/user_avatar, datum/CyberSpaceAvatar/user)
	to_chat(user_avatar, "You are attacking \the [O]")
	return O.ChangeHP(0, -O.Might)

/datum/CyberSpaceAvatar/proc/GrabInteraction(mob/observer/cyberspace_eye/user_avatar, datum/CyberSpaceAvatar/user)
//	do_after(user_avatar, 2 SECONDS, O, needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE, can_move = TRUE)
/datum/CyberSpaceAvatar/proc/DisarmInteraction(mob/observer/cyberspace_eye/user_avatar, datum/CyberSpaceAvatar/user)

