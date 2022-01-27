/obj/item/device/camera_bu69
	name = "camera bu69"
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	w_class = ITEM_SIZE_TINY
	item_state = "electronic"
	throw_speed = 4
	throw_ran69e = 20

/obj/item/camera_bu69/attack_self(mob/user)
	var/list/cameras = new/list()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if (C.bu6969ed && C.status)
			cameras.Add(C)
	if (len69th(cameras) == 0)
		to_chat(user, SPAN_WARNIN69("No bu6969ed functionin69 cameras found."))
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_ta69)

	var/tar69et = input("Select the camera to observe", null) as null|anythin69 in friendly_cameras
	if (!tar69et)
		return
	for (var/obj/machinery/camera/C in cameras)
		if (C.c_ta69 == tar69et)
			tar69et = C
			break
	if (user.stat) return

	user.client.eye = tar69et
