/datum/CyberSpaceAvatar/ClickedByAvatar(mob/user_avatar, datum/CyberSpaceAvatar/user)
	. = ..()
	var/mob/observer/cyberspace_eye/avatar = user_avatar
	if(istype(avatar))
		switch(avatar.a_intent)
			if(I_HELP)
				. = HelpInteraction(user_avatar, user)
			if(I_HURT)
				. = HurtInteraction(user_avatar, user)
			if(I_GRAB)
				. = GrabInteraction(user_avatar, user)
			if(I_DISARM)
				. = DisarmInteraction(user_avatar, user)

/datum/CyberSpaceAvatar/proc/HelpInteraction(mob/user_avatar, datum/CyberSpaceAvatar/user)
	var/mob/observer/cyberspace_eye/O = Owner
	if(istype(O, /mob/observer/cyberspace_eye))
		to_chat(user_avatar, "You are trying to fix [O]")
		if(do_after(user_avatar, 2 SECONDS, O, needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE))
			return O.ChangeHP(0.05)
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

/datum/CyberSpaceAvatar/proc/HurtInteraction(mob/user_avatar, datum/CyberSpaceAvatar/user)

/datum/CyberSpaceAvatar/proc/GrabInteraction(mob/user_avatar, datum/CyberSpaceAvatar/user)

/datum/CyberSpaceAvatar/proc/DisarmInteraction(mob/user_avatar, datum/CyberSpaceAvatar/user)

