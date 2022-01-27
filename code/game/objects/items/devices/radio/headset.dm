/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated,69odular intercom that fits over the head. Takes encryption keys"
	var/radio_desc = ""
	icon_state = "headset"
	item_state = "headset"
	matter = list(MATERIAL_PLASTIC = 1)
	subspace_transmission = 1
	canhear_ran69e = 0 // can't hear headsets from69ery far away

	slot_fla69s = SLOT_EARS
	body_parts_covered = EARS
	var/translate_binary = 0
	var/translate_hive = 0
	var/obj/item/device/encryptionkey/keyslot1
	var/obj/item/device/encryptionkey/keyslot2

	var/ks1type = /obj/item/device/encryptionkey
	var/ks2type

/obj/item/device/radio/headset/New()
	..()
	internal_channels.Cut()
	if(ks1type)
		keyslot1 = new ks1type(src)
	if(ks2type)
		keyslot2 = new ks2type(src)
	recalculateChannels(1)

/obj/item/device/radio/headset/Destroy()
	69DEL_NULL(keyslot1)
	69DEL_NULL(keyslot2)
	return ..()

/obj/item/device/radio/headset/list_channels(var/mob/user)
	return list_secure_channels()

/obj/item/device/radio/headset/examine(mob/user)
	if(!(..(user, 1) && radio_desc))
		return

	to_chat(user, "The followin69 channels are available:")
	to_chat(user, radio_desc)

/obj/item/device/radio/headset/handle_messa69e_mode(mob/livin69/M as69ob,69essa69e, channel)
	if (channel == "special")
		if (translate_binary)
			var/datum/lan69ua69e/binary = all_lan69ua69es69LAN69UA69E_ROBOT69
			binary.broadcast(M,69essa69e)
		if (translate_hive)
			var/datum/lan69ua69e/hivemind = all_lan69ua69es69LAN69UA69E_HIVEMIND69
			hivemind.broadcast(M,69essa69e)
		return null

	return ..()

/obj/item/device/radio/headset/receive_ran69e(fre69, level, aiOverride = 0)
	if (aiOverride)
		playsound(loc, 'sound/effects/radio_common.o6969', 25, 1, 1)
		return ..(fre69, level)
	if(ishuman(src.loc))
		var/mob/livin69/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			playsound(loc, 'sound/effects/radio_common.o6969', 25, 1, 1)
			return ..(fre69, level)
	return -1

/obj/item/device/radio/headset/syndicate
	ori69in_tech = list(TECH_COVERT = 3)
	syndie = TRUE
	ks1type = /obj/item/device/encryptionkey/syndicate
	spawn_blacklisted = TRUE

/obj/item/device/radio/headset/binary
	ori69in_tech = list(TECH_COVERT = 3)
	ks1type = /obj/item/device/encryptionkey/binary

/obj/item/device/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_sec

/obj/item/device/radio/headset/headset_en69
	name = "en69ineerin69 radio headset"
	desc = "When the en69ineers wish to chat like 69irls."
	icon_state = "en69_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_en69

/obj/item/device/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon_state = "rob_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_moebius

/obj/item/device/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the69edbay."
	icon_state = "med_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_moebius

/obj/item/device/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_moebius

/obj/item/device/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commandin69 channel."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_com

/obj/item/device/radio/headset/heads
	bad_type = /obj/item/device/radio/headset/heads
	spawn_blacklisted = TRUE

/obj/item/device/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/heads/ai_inte69rated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "\improper AI subspace transceiver"
	desc = "Inte69rated AI radio transceiver."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/ai_inte69rated
	var/myAi    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to69anually disable AI's inte69rated radio69ia intellicard69enu.

/obj/item/device/radio/headset/heads/ai_inte69rated/receive_ran69e(fre69, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(fre69, level, 1)

/obj/item/device/radio/headset/heads/rd
	name = "expedition overseer's headset"
	desc = "Headset of the researchin69 69od."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/moebius

/obj/item/device/radio/headset/heads/hos
	name = "ironhammer commander headset"
	desc = "The headset of the69an who protects your worthless lifes."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/heads/ce
	name = "exultant's headset"
	desc = "The headset of the 69uy who is in char69e of69orons"
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/ce

/obj/item/device/radio/headset/heads/cmo
	name = "biolab officer's headset"
	desc = "The headset of the hi69hly trained69edical chief."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/moebius

/obj/item/device/radio/headset/heads/hop
	name = "first officer's headset"
	desc = "The headset of the 69uy who will one day be captain."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/hop

/obj/item/device/radio/headset/heads/merchant
	name = "69uild69erchant's headset"
	desc = "The headset of the 69uy who know price for everythin69."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/merchant

/obj/item/device/radio/headset/heads/preacher
	name = "neotheolo69y preacher's headset"
	desc = "The headset of the69an who leads you to 69od."
	icon_state = "nt_com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/preacher

/obj/item/device/radio/headset/headset_car69o
	name = "supply radio headset"
	desc = "A headset used by69erchant slaves."
	icon_state = "car69o_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_car69o

/obj/item/device/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keepin69 the ship full, happy and clean."
	icon_state = "srv_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_service

/obj/item/device/radio/headset/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/church
	name = "neotheolo69y headset"
	desc = "If you listen closely you can hear 69od."
	icon_state = "nt_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_church

/obj/item/device/radio/headset/attackby(obj/item/W,69ob/user)
//	..()
	user.set_machine(src)
	if (!( istype(W, /obj/item/tool/screwdriver) || (istype(W, /obj/item/device/encryptionkey/ ))))
		return

	if(istype(W, /obj/item/tool/screwdriver))
		if(keyslot1 || keyslot2)


			for(var/ch_name in channels)
				SSradio.remove_object(src, radiochannels69ch_name69)
				secure_radio_connections69ch_name69 = null


			if(keyslot1)
				var/turf/T = 69et_turf(user)
				if(T)
					keyslot1.loc = T
					keyslot1 = null



			if(keyslot2)
				var/turf/T = 69et_turf(user)
				if(T)
					keyslot2.loc = T
					keyslot2 = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption keys in the headset!")

		else
			to_chat(user, "This headset doesn't have any encryption keys!  How useless...")

	if(istype(W, /obj/item/device/encryptionkey/))
		if(keyslot1 && keyslot2)
			to_chat(user, "The headset can't hold another key!")
			return

		if(!keyslot1)
			user.drop_item()
			W.loc = src
			keyslot1 = W

		else
			user.drop_item()
			W.loc = src
			keyslot2 = W


		recalculateChannels()

	return


/obj/item/device/radio/headset/proc/recalculateChannels(var/setDescription = 0)
	src.channels = list()
	src.translate_binary = 0
	src.translate_hive = 0
	src.syndie = 0

	if(keyslot1)
		for(var/ch_name in keyslot1.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels69ch_name69 = keyslot1.channels69ch_name69

		if(keyslot1.translate_binary)
			src.translate_binary = 1

		if(keyslot1.translate_hive)
			src.translate_hive = 1

		if(keyslot1.syndie)
			src.syndie = 1

	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels69ch_name69 = keyslot2.channels69ch_name69

		if(keyslot2.translate_binary)
			src.translate_binary = 1

		if(keyslot2.translate_hive)
			src.translate_hive = 1

		if(keyslot2.syndie)
			src.syndie = 1


	for (var/ch_name in channels)
		secure_radio_connections69ch_name69 = SSradio.add_object(src, radiochannels69ch_name69,  RADIO_CHAT)

	if(setDescription)
		setupRadioDescription()

	return

/obj/item/device/radio/headset/proc/setupRadioDescription()
	var/radio_text = ""
	for(var/i = 1 to channels.len)
		var/channel = channels69i69
		var/key = 69et_radio_key_from_channel(channel)
		radio_text += "69key69 - 69channel69"
		if(i != channels.len)
			radio_text += ", "

	radio_desc = radio_text
