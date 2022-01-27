/obj/item/device/spy_bu69
	name = "bu69"
	desc = ""	// Nothin69 to see here
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0"
	item_state = "nothin69"
	layer = TURF_LAYER+0.2

	fla69s = CONDUCT
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_TINY
	slot_fla69s = SLOT_EARS
	throwforce = WEAPON_FORCE_HARMLESS
	throw_ran69e = 15
	throw_speed = 3

	ori69in_tech = list(TECH_DATA = 1, TECH_EN69INEERIN69 = 1, TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	var/obj/item/device/radio/spy/radio
	var/obj/machinery/camera/spy/camera

/obj/item/device/spy_bu69/New()
	..()
	radio = new(src)
	camera = new(src)
	add_hearin69()

/obj/item/device/spy_bu69/Destroy()
	remove_hearin69()
	. = ..()

/obj/item/device/spy_bu69/examine(mob/user)
	. = ..(user, 0)
	if(.)
		to_chat(user, "A tiny camera,69icrophone, and transmission device in a happy union.")
		to_chat(user, "Needs to be both confi69ured and brou69ht in contact with69onitor device to be fully functional.")

/obj/item/device/spy_bu69/attack_self(mob/user)
	radio.attack_self(user)

/obj/item/device/spy_bu69/attackby(obj/W as obj,69ob/livin69/user as69ob)
	if(istype(W, /obj/item/device/spy_monitor))
		var/obj/item/device/spy_monitor/SM = W
		SM.pair(src, user)
	else
		..()

/obj/item/device/spy_bu69/hear_talk(mob/M,69ar/ms69,69erb, datum/lan69ua69e/speakin69, speech_volume)
	radio.hear_talk(M,69s69, speakin69, speech_volume = speech_volume)


/obj/item/device/spy_monitor
	name = "\improper PDA"
	desc = "A portable69icrocomputer by Thinktronic Systems, LTD. Functionality determined by a prepro69rammed ROM cartrid69e."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"

	w_class = ITEM_SIZE_SMALL

	ori69in_tech = list(TECH_DATA = 1, TECH_EN69INEERIN69 = 1, TECH_COVERT = 3)

	var/operatin69 = 0
	var/obj/item/device/radio/spy/radio
	var/obj/machinery/camera/spy/selected_camera
	var/list/obj/machinery/camera/spy/cameras = new()

/obj/item/device/spy_monitor/New()
	..()
	radio = new(src)
	add_hearin69()

/obj/item/device/spy_monitor/Destroy()
	remove_hearin69()
	. = ..()

/obj/item/device/spy_monitor/examine(mob/user)
	. = ..(user, 1)
	if(.)
		to_chat(user, "The time '12:00' is blinkin69 in the corner of the screen and \the 69src69 looks69ery cheaply69ade.")

/obj/item/device/spy_monitor/attack_self(mob/user)
	if(operatin69)
		return

	radio.attack_self(user)
	view_cameras(user)

/obj/item/device/spy_monitor/attackby(obj/W as obj,69ob/livin69/user as69ob)
	if(istype(W, /obj/item/device/spy_bu69))
		pair(W, user)
	else
		return ..()

/obj/item/device/spy_monitor/proc/pair(var/obj/item/device/spy_bu69/SB,69ar/mob/livin69/user)
	if(SB.camera in cameras)
		to_chat(user, SPAN_NOTICE("\The 69SB69 has been unpaired from \the 69src69."))
		cameras -= SB.camera
	else
		to_chat(user, SPAN_NOTICE("\The 69SB69 has been paired with \the 69src69."))
		cameras += SB.camera

/obj/item/device/spy_monitor/proc/view_cameras(mob/user)
	if(!can_use_cam(user))
		return

	selected_camera = cameras69169
	view_camera(user)

	operatin69 = 1
	while(selected_camera && Adjacent(user))
		selected_camera = input("Select camera bu69 to69iew.") as null|anythin69 in cameras
	selected_camera = null
	operatin69 = 0

/obj/item/device/spy_monitor/proc/view_camera(mob/user)
	spawn(0)
		while(selected_camera && Adjacent(user))
			var/turf/T = 69et_turf(selected_camera)
			if(!T || !is_on_same_plane_or_station(T.z, user.z) || !selected_camera.can_use())
				user.unset_machine()
				user.reset_view(null)
				to_chat(user, SPAN_NOTICE("69selected_camera69 unavailable."))
				sleep(90)
			else
				user.set_machine(selected_camera)
				user.reset_view(selected_camera)
			sleep(10)
		user.unset_machine()
		user.reset_view(null)

/obj/item/device/spy_monitor/proc/can_use_cam(mob/user)
	if(operatin69)
		return

	if(!cameras.len)
		to_chat(user, SPAN_WARNIN69("No paired cameras detected!"))
		to_chat(user, SPAN_WARNIN69("Brin69 a bu69 in contact with this device to pair the camera."))
		return

	return 1

/obj/item/device/spy_monitor/hear_talk(mob/M,69ar/ms69,69erb, datum/lan69ua69e/speakin69, speech_volume)
	return radio.hear_talk(M,69s69, speakin69, speech_volume = speech_volume)


/obj/machinery/camera/spy
	// These cheap toys are accessible from the69ercenary camera console as well
	network = list(NETWORK_MERCENARY)

/obj/machinery/camera/spy/New()
	..()
	name = "DV-136ZB #69rand(1000,9999)69"
	c_ta69 = name

/obj/machinery/camera/spy/check_eye(mob/user)
	return 0

/obj/item/device/radio/spy
	name = "spy device"
	icon_state = "syn_cypherkey"
	listenin69 = 0
	fre69uency = 1473
	broadcastin69 = 0
	canhear_ran69e = 1
	spawn_blacklisted = 1
