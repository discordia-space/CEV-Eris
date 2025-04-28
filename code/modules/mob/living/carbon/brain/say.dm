//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(var/message)
	if (silent)
		return

	message = sanitize(message)

	if(!(container && istype(container, /obj/item/device/mmi)))
		return //No MMI, can't speak, bucko./N
	else
		var/datum/language/speaking = parse_language(message)
		if(speaking)
			message = copytext(message, 2+length(speaking.key))
		var/verb = verb_say
		var/ending = copytext(message, length(message))
		if (speaking)
			verb = get_spoken_verb(ending)
		else
			if(ending=="!")
				verb=pick(verb_exclaim,verb_yell)
			else if(ending=="?")
				verb=verb_ask

		if(prob(emp_damage*4))
			if(prob(10))//10% chane to drop the message entirely
				return
			else
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher

		if(speaking && speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return

		if(istype(container, /obj/item/device/mmi/radio_enabled))
			var/obj/item/device/mmi/radio_enabled/R = container
			if(R.radio)
				spawn(0) R.radio.hear_talk(src, sanitize(message), verb, speaking, getSpeechVolume())
		..(trim(message), speaking, verb)
