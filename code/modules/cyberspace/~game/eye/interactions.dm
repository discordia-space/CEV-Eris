/mob/observer/cyber_entity
	var/tmp/NextDisarm = 0
	var/DisarmCooldown = 1 SECOND
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
				if(eye.NextDisarm <= world.time)
					. = DisarmInteraction(eye, user_avatar, params)
					eye.NextDisarm = world.time + eye.DisarmCooldown

/datum/CyberSpaceAvatar/proc/HelpInteraction(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)
	var/mob/observer/cyber_entity/O = Owner
	if(istype(O) && get_dist(user, O) <= user.attack_range)
		to_chat(user, "You are trying to fix [O].")
		if(do_after(user, 2 SECONDS, O, needhand = FALSE))
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

/datum/CyberSpaceAvatar/interactable/DisarmInteraction(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..()
	if(istype(Owner))
		var/value = 1 + round(user.MEC/10)
		Owner.RaiseAlarmLevelInArea(1)
		Owner.emp_act(value)

/datum/CyberSpaceAvatar/entity/DisarmInteraction(mob/observer/cyber_entity/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..()
	if(istype(Owner))
		var/mek = user.MEC
		if(prob(mek))
			var/randOffset = 2 + round(mek/10)
			var/newx = Owner.x + rand(-randOffset, randOffset) 
			var/newy = Owner.y + rand(-randOffset, randOffset)
			Owner.Move(locate(newx, newy, Owner.z))
