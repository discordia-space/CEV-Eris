/datum/CyberSpaceAvatar/ClickedByAvatar(mob/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..()
	var/mob/observer/cyberspace_eye/eye = user
	if(istype(eye))
		switch(eye.a_intent)
			if(I_HELP)
				. = HelpInteraction(eye, user_avatar, params)
			if(I_HURT)
				. = HurtInteraction(eye, user_avatar, params)
			if(I_GRAB)
				. = GrabInteraction(eye, user_avatar, params)
			if(I_DISARM)
				. = DisarmInteraction(eye, user_avatar, params)

/datum/CyberSpaceAvatar/proc/HelpInteraction(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	var/mob/observer/cyberspace_eye/O = Owner
	if(istype(O))
		to_chat(user, "You are trying to fix [O].")
		if(do_after(user, 2 SECONDS, O, needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE))
			return O.ChangeHP(0, user.Might)
		else
			to_chat(user, SPAN_WARNING("Fixing failed."))
			return
	return Owner.attack_ai(user)//Owner.ui_interact(user, state = GLOB.netrunner_state)

/mob/observer/cyberspace_eye/proc/ChangeHP(percents = 0.05, amount = FALSE)
	if(!amount)
		amount = maxHP * percents
	. = HP
	HP = clamp(HP + amount, 0, maxHP)
	. = HP - .
	update_hud()

/datum/CyberSpaceAvatar/proc/HurtInteraction(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	var/mob/observer/cyberspace_eye/O = Owner
	if(istype(O, /mob/observer/cyberspace_eye))
		to_chat(user, "You have attacked \the [O].")
		return O.ChangeHP(0, -user.Might)

/datum/CyberSpaceAvatar/proc/GrabInteraction(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	if(!user_avatar || !user)
		if(!user_avatar)
			user_avatar = user
		else if(!user)
			user = user_avatar

	if(HackingTry(user, user_avatar))
		return Hacked(user, user_avatar)

/datum/CyberSpaceAvatar/proc/HackingTry(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)

/datum/CyberSpaceAvatar/proc/Hacked(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar)

/datum/CyberSpaceAvatar/proc/DisarmInteraction(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)

