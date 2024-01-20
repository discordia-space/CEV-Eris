/obj/item/device/radio/intercom
	name = "ship intercom (General)"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = TRUE
	spawn_tags = null
	slot_flags = null
	volumeClass = ITEM_SIZE_BULKY
	canhear_range = 2
	flags = CONDUCT | NOBLOODY
	var/number = 0
	var/area/linked_area

/obj/item/device/radio/intercom/custom
	name = "ship intercom (Custom)"
	broadcasting = 0
	listening = 0

/obj/item/device/radio/intercom/interrogation
	name = "ship intercom (Interrogation)"
	frequency  = 1449

/obj/item/device/radio/intercom/private
	name = "ship intercom (Private)"
	frequency = AI_FREQ

/obj/item/device/radio/intercom/department
	canhear_range = 5
	broadcasting = 0
	listening = 1

/obj/item/device/radio/intercom/department/medbay
	name = "ship intercom (Medbay)"
	frequency = MED_I_FREQ

/obj/item/device/radio/intercom/department/security
	name = "ship intercom (Security)"
	frequency = SEC_I_FREQ

/obj/item/device/radio/intercom/New()
	..()
	loop_area_check()

/obj/item/device/radio/intercom/department/medbay/New()
	..()
	internal_channels = default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security/New()
	..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(access_security)
	)


/obj/item/device/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly"
	frequency = SYND_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/device/radio/intercom/syndicate/New()
	..()
	internal_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range

/obj/item/device/radio/intercom/proc/change_status()
	SIGNAL_HANDLER
	on = linked_area.powered(STATIC_EQUIP)
	icon_state = on ? "intercom" : "intercom-p"

/obj/item/device/radio/intercom/proc/loop_area_check()
	var/area/target_area = get_area(src)
	if(!target_area?.apc)
		addtimer(CALLBACK(src, PROC_REF(loop_area_check)), 30 SECONDS, TIMER_STOPPABLE) // We don't proces if there is no APC , no point in doing so is there ?
		return FALSE
	linked_area = target_area
	RegisterSignal(target_area, COMSIG_AREA_APC_DELETED, PROC_REF(on_apc_removal))
	RegisterSignal(target_area, COMSIG_AREA_APC_POWER_CHANGE, PROC_REF(change_status))

/obj/item/device/radio/intercom/proc/on_apc_removal()
	SIGNAL_HANDLER
	UnregisterSignal(linked_area , COMSIG_AREA_APC_DELETED)
	UnregisterSignal(linked_area, COMSIG_AREA_APC_POWER_CHANGE)
	linked_area = null
	on = FALSE
	icon_state = "intercom-p"
	addtimer(CALLBACK(src, PROC_REF(loop_area_check)), 30 SECONDS)

/obj/item/device/radio/intercom/broadcasting
	broadcasting = 1

/obj/item/device/radio/intercom/locked
    var/locked_frequency

/obj/item/device/radio/intercom/locked/set_frequency(var/frequency)
	if(frequency == locked_frequency)
		..(locked_frequency)

/obj/item/device/radio/intercom/locked/list_channels()
	return ""

/obj/item/device/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	frequency = AI_FREQ
	broadcasting = 1
	listening = 1

/obj/item/device/radio/intercom/locked/confessional
	name = "confessional intercom"
	frequency = 1480
