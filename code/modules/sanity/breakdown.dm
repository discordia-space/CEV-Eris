/datum/breakdown
	var/name
	var/datum/sanity/holder

	var/icon_state
	var/breakdown_sound

	var/start_message_span
	var/list/start_messages
	var/list/end_messages

	var/duration
	var/end_time

	var/finished = FALSE
	var/restore_sanity_pre
	var/restore_sanity_post

/datum/breakdown/New(datum/sanity/S)
	..()
	holder = S

/datum/breakdown/Destroy()
	holder = null
	return ..()

/datum/breakdown/proc/can_occur()
	return !!name

/datum/breakdown/proc/update()
	if(finished || (duration && world.time > end_time))
		conclude()
		return FALSE
	return TRUE

/datum/breakdown/proc/occur()
	var/image/img = image('icons/effects/insanity_statuses.dmi', holder.owner)
	holder.owner << img
	flick(icon_state, img)
	holder.owner.playsound_local(get_turf(holder.owner), breakdown_sound, 100)
	if(start_messages)
		log_and_message_admins("[holder.owner] is affected by breakdown [name] with duration [duration]")
		to_chat(holder.owner, span(start_message_span, pick(start_messages)))
	if(restore_sanity_pre)
		holder.restoreLevel(restore_sanity_pre)
	if(duration == 0)
		conclude()
		return FALSE
	else if(duration > 0)
		end_time = world.time + duration
	return TRUE

/datum/breakdown/proc/conclude()
	if(end_messages)
		log_and_message_admins("[holder.owner] is no longer affected by [name]")
		to_chat(holder.owner,SPAN_NOTICE(pick(end_messages)))
	if(restore_sanity_post)
		holder.restoreLevel(restore_sanity_post)
	qdel(src)
