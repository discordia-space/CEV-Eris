/obj/item/device/spy_bug
	name = "bug"
	desc = ""	// Nothing to see here
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0"
	item_state = "nothing"
	layer = TURF_LAYER+0.2

	flags = CONDUCT
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = WEAPON_FORCE_HARMLESS
	throw_range = 15
	throw_speed = 3

	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	var/obj/item/device/radio/spy/radio
	var/obj/machinery/camera/spy/camera

/obj/item/device/spy_bug/New()
	..()
	radio = new(src)
	camera = new(src)
	add_hearing()

/obj/item/device/spy_bug/Destroy()
	remove_hearing()
	. = ..()

/obj/item/device/spy_bug/examine(mob/user)
	. = ..(user, 0)
	if(.)
		to_chat(user, "It's a tiny camera, microphone, and transmission device in a happy union.")
		to_chat(user, "Needs to be both configured and brought in contact with monitor device to be fully functional.")

/obj/item/device/spy_bug/attack_self(mob/user)
	radio.attack_self(user)

/obj/item/device/spy_bug/attackby(obj/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/device/spy_monitor))
		var/obj/item/device/spy_monitor/SM = W
		SM.pair(src, user)
	else
		..()

/obj/item/device/spy_bug/hear_talk(mob/M, var/msg, verb, datum/language/speaking, speech_volume)
	radio.hear_talk(M, msg, speaking, speech_volume = speech_volume)


/obj/item/device/spy_monitor
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"

	w_class = ITEM_SIZE_SMALL

	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_COVERT = 3)

	var/operating = 0
	var/obj/item/device/radio/spy/radio
	var/obj/machinery/camera/spy/selected_camera
	var/list/obj/machinery/camera/spy/cameras = new()

/obj/item/device/spy_monitor/New()
	..()
	radio = new(src)
	add_hearing()

/obj/item/device/spy_monitor/Destroy()
	remove_hearing()
	. = ..()

/obj/item/device/spy_monitor/examine(mob/user)
	. = ..(user, 1)
	if(.)
		to_chat(user, "The time '12:00' is blinking in the corner of the screen and \the [src] looks very cheaply made.")

/obj/item/device/spy_monitor/attack_self(mob/user)
	if(operating)
		return

	radio.attack_self(user)
	view_cameras(user)

/obj/item/device/spy_monitor/attackby(obj/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/device/spy_bug))
		pair(W, user)
	else
		return ..()

/obj/item/device/spy_monitor/proc/pair(var/obj/item/device/spy_bug/SB, var/mob/living/user)
	if(SB.camera in cameras)
		to_chat(user, SPAN_NOTICE("\The [SB] has been unpaired from \the [src]."))
		cameras -= SB.camera
	else
		to_chat(user, SPAN_NOTICE("\The [SB] has been paired with \the [src]."))
		cameras += SB.camera

/obj/item/device/spy_monitor/proc/view_cameras(mob/user)
	if(!can_use_cam(user))
		return

	selected_camera = cameras[1]
	view_camera(user)

	operating = 1
	while(selected_camera && Adjacent(user))
		selected_camera = input("Select camera bug to view.") as null|anything in cameras
	selected_camera = null
	operating = 0

/obj/item/device/spy_monitor/proc/view_camera(mob/user)
	spawn(0)
		while(selected_camera && Adjacent(user))
			var/turf/T = get_turf(selected_camera)
			if(!T || !is_on_same_plane_or_station(T.z, user.z) || !selected_camera.can_use())
				user.unset_machine()
				user.reset_view(null)
				to_chat(user, SPAN_NOTICE("[selected_camera] unavailable."))
				sleep(90)
			else
				user.set_machine(selected_camera)
				user.reset_view(selected_camera)
			sleep(10)
		user.unset_machine()
		user.reset_view(null)

/obj/item/device/spy_monitor/proc/can_use_cam(mob/user)
	if(operating)
		return

	if(!cameras.len)
		to_chat(user, SPAN_WARNING("No paired cameras detected!"))
		to_chat(user, SPAN_WARNING("Bring a bug in contact with this device to pair the camera."))
		return

	return 1

/obj/item/device/spy_monitor/hear_talk(mob/M, var/msg, verb, datum/language/speaking, speech_volume)
	return radio.hear_talk(M, msg, speaking, speech_volume = speech_volume)


/obj/machinery/camera/spy
	// These cheap toys are accessible from the mercenary camera console as well
	network = list(NETWORK_MERCENARY)

/obj/machinery/camera/spy/New()
	..()
	name = "DV-136ZB #[rand(1000,9999)]"
	c_tag = name

/obj/machinery/camera/spy/check_eye(mob/user)
	return 0

/obj/item/device/radio/spy
	name = "spy device"
	icon_state = "syn_cypherkey"
	listening = 0
	frequency = 1473
	broadcasting = 0
	canhear_range = 1
	spawn_blacklisted = 1
