/obj/item/voice_changer
	name = "voice changer"
	desc = "A voice scrambling module. If you can see this, report it as a bug on the tracker."
	var/voice_name //If set and item is present in mask/suit, this name will be used for the wearer's speech.
	var/voice_tts
	var/active

/obj/item/clothing/mask/chameleon/voice
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. It seems to house some odd electronics."
	var/obj/item/voice_changer/changer
	origin_tech = list(TECH_COVERT = 4)

/obj/item/clothing/mask/chameleon/voice/verb/Toggle_Voice_Changer()
	set category = "Object"
	set src in usr

	changer.active = !changer.active
	to_chat(usr, "<span class='notice'>You [changer.active ? "enable" : "disable"] the voice-changing module in \the [src].</span>")

/obj/item/clothing/mask/chameleon/voice/verb/Set_Name(_name as text)
	set category = "Object"
	set src in usr

	var/voice_name = sanitize(_name, MAX_NAME_LEN)
	if(voice_name)
		changer.voice_name = voice_name
		to_chat(usr, SPAN_NOTICE("You are now mimicking <B>[changer.voice_name]</B>."))
		var/mob/living/carbon/human/matching_mob
		for(var/mob/living/carbon/human/H as anything in GLOB.human_mob_list)
			if(H.real_name == voice_name)
				matching_mob = H
				break
		if(!matching_mob)
			for(var/mob/living/carbon/human/H as anything in GLOB.human_mob_list)
				if(H.name == voice_name)
					matching_mob = H
					break
		if(matching_mob && (alert(usr, "Want to impersonate their pronunciation as well?", "There is a person with matching name", "Yes", "No") == "Yes"))
			changer.voice_tts = matching_mob.tts_seed ? matching_mob.tts_seed : (matching_mob.gender == "male" ? TTS_SEED_DEFAULT_MALE : TTS_SEED_DEFAULT_FEMALE)


/obj/item/clothing/mask/chameleon/voice/verb/Set_Voice()
	set category = "Object"
	set src in usr

	var/mob/living/user = usr
	if(istype(user))
		var/choice = input(user, "Pick a voice preset.") as null|anything in tts_seeds
		if(choice)
			changer.voice_tts = choice


/obj/item/clothing/mask/chameleon/voice/New()
	..()
	changer = new(src)
