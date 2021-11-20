/datum/CyberSpaceAvatar/ClickedByAvatar(mob/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..()
	var/mob/observer/cyber_entity/eye = user
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

/datum/CyberSpaceAvatar/proc/HelpInteraction(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)
	var/mob/observer/cyber_entity/O = Owner
	if(istype(O) && get_dist(user, O) <= user.attack_range)
		to_chat(user, "You are trying to fix [O].")
		if(do_after(user, 2 SECONDS, O, needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE))
			return O.ChangeHP(0, user.Might)
		else
			to_chat(user, SPAN_WARNING("Fixing failed."))
			return
	return Owner.attack_ai(user)//Owner.ui_interact(user, state = GLOB.netrunner_state)

/datum/CyberSpaceAvatar/proc/HurtInteraction(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)
	var/mob/observer/cyber_entity/O = Owner
	if(istype(O, /mob/observer/cyber_entity) && get_dist(user, O) <= user.attack_range)
		to_chat(user, "You have attacked \the [O].")
		return O.ChangeHP(0, -user.Might)

/datum/CyberSpaceAvatar/proc/GrabInteraction(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)
	if(!user_avatar || !user)
		if(!user_avatar)
			user_avatar = user
		else if(!user)
			user = user_avatar

	if(length(user.HackingInProgress) <= user.hacking_limit && !(src in user.HackingInProgress))
		user.HackingInProgress |= src
		if(HackingTry(user, user_avatar))
			. = Hacked(user, user_avatar, params)
		user.HackingInProgress -= src

/datum/CyberSpaceAvatar/proc/HackingTry(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = TRUE

/datum/CyberSpaceAvatar/proc/Hacked(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)

/datum/CyberSpaceAvatar/proc/DisarmInteraction(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)

