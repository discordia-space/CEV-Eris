/obj/item/device/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a69oice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 1)
	var/listening = 0
	var/recorded	//the activation69essage

/obj/item/device/assembly/voice/New()
	..()
	add_hearing()

/obj/item/device/assembly/voice/Destroy()
	remove_hearing()
	. = ..()

/obj/item/device/assembly/voice/hear_talk(mob/M as69ob,69sg,69erb, datum/language/speaking, speech_volume)
	if(listening)
		recorded =69sg
		listening = 0
		var/turf/T = get_turf(src)	//otherwise it won't work in hand
		T.visible_message("\icon69src69 beeps, \"Activation69essage is '69recorded69'.\"")
	else
		if(findtext(msg, recorded))
			pulse(0)

/obj/item/device/assembly/voice/activate()
	if(secured)
		if(!holder)
			listening = !listening
			var/turf/T = get_turf(src)
			T.visible_message("\icon69src69 beeps, \"69listening ? "Now" : "No longer"69 recording input.\"")


/obj/item/device/assembly/voice/attack_self(mob/user)
	if(!user)
		return
	activate()


/obj/item/device/assembly/voice/toggle_secure()
	. = ..()
	listening = 0
