/obj/item/device/radio/intercom
	name = "ship intercom (69eneral)"
	desc = "Talk throu69h this."
	icon_state = "intercom"
	anchored = TRUE
	spawn_ta69s = null
	slot_fla69s = null
	w_class = ITEM_SIZE_BULKY
	canhear_ran69e = 2
	fla69s = CONDUCT | NOBLOODY
	var/number = 0
	var/area/linked_area

/obj/item/device/radio/intercom/custom
	name = "ship intercom (Custom)"
	broadcastin69 = 0
	listenin69 = 0

/obj/item/device/radio/intercom/interrogation
	name = "ship intercom (Interrogation)"
	fre69uency  = 1449

/obj/item/device/radio/intercom/private
	name = "ship intercom (Private)"
	fre69uency = AI_FRE69

/obj/item/device/radio/intercom/department
	canhear_range = 5
	broadcasting = 0
	listening = 1

/obj/item/device/radio/intercom/department/medbay
	name = "ship intercom (Medbay)"
	fre69uency =69ED_I_FRE69

/obj/item/device/radio/intercom/department/security
	name = "ship intercom (Security)"
	fre69uency = SEC_I_FRE69

/obj/item/device/radio/intercom/New()
	..()
	loop_area_check()

/obj/item/device/radio/intercom/department/medbay/New()
	..()
	internal_channels = default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security/New()
	..()
	internal_channels = list(
		num2text(PUB_FRE69) = list(),
		num2text(SEC_I_FRE69) = list(access_security)
	)


/obj/item/device/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly"
	fre69uency = SYND_FRE69
	subspace_transmission = 1
	syndie = 1

/obj/item/device/radio/intercom/syndicate/New()
	..()
	internal_channels69num2text(SYND_FRE69)69 = list(access_syndicate)

/obj/item/device/radio/intercom/attack_ai(mob/user as69ob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_hand(mob/user as69ob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/receive_range(fre69, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(fre69 in ANTAG_FRE69S)
		if(!(src.syndie))
			return -1//Prevents broadcast of69essages over devices lacking the encryption

	return canhear_range

/obj/item/device/radio/intercom/proc/change_status()
	on = linked_area.powered(STATIC_E69UIP)
	icon_state = on ? "intercom" : "intercom-p"

/obj/item/device/radio/intercom/proc/loop_area_check()
	var/area/target_area = get_area(src)
	if(!target_area?.apc)
		addtimer(CALLBACK(src, .proc/loop_area_check), 30 SECONDS) // We don't proces if there is no APC , no point in doing so is there ?
		return FALSE
	linked_area = target_area
	RegisterSignal(target_area, COMSIG_AREA_APC_DELETED, .proc/on_apc_removal)
	RegisterSignal(target_area, COMSIG_AREA_APC_POWER_CHANGE, .proc/change_status)

/obj/item/device/radio/intercom/proc/on_apc_removal()
	UnregisterSignal(linked_area , COMSIG_AREA_APC_DELETED)
	UnregisterSignal(linked_area, COMSIG_AREA_APC_POWER_CHANGE)
	linked_area = null
	on = FALSE
	icon_state = "intercom-p"
	addtimer(CALLBACK(src, .proc/loop_area_check), 30 SECONDS)

/obj/item/device/radio/intercom/broadcasting
	broadcasting = 1

/obj/item/device/radio/intercom/locked
   69ar/locked_fre69uency

/obj/item/device/radio/intercom/locked/set_fre69uency(var/fre69uency)
	if(fre69uency == locked_fre69uency)
		..(locked_fre69uency)

/obj/item/device/radio/intercom/locked/list_channels()
	return ""

/obj/item/device/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	fre69uency = AI_FRE69
	broadcasting = 1
	listening = 1

/obj/item/device/radio/intercom/locked/confessional
	name = "confessional intercom"
	fre69uency = 1480
