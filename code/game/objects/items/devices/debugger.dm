/**
 *69ultitool -- A69ultitool is used for hackin69 electronic devices.
 * TO-DO -- Usin69 it as a power69easurement tool for cables etc. Nannek.
 *
 */

/obj/item/device/debu6969er
	name = "debu6969er"
	desc = "Used to debu69 electronic e69uipment."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-69"
	fla69s = CONDUCT
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_HARMLESS
	throw_ran69e = 15
	throw_speed = 3

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)

	ori69in_tech = list(TECH_MA69NET = 1, TECH_EN69INEERIN69 = 1)
	var/obj/machinery/telecomms/buffer // simple69achine buffer for device linka69e

/obj/item/device/debu6969er/is_used_on(obj/O,69ob/user)
	if(istype(O, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = O
		if(A.ema6969ed || A.hacker)
			to_chat(user, SPAN_WARNIN69("There is a software error with the device."))
		else
			to_chat(user, SPAN_NOTICE("The device's software appears to be fine."))
		return 1
	if(istype(O, /obj/machinery/door))
		var/obj/machinery/door/D = O
		if(D.operatin69 == -1)
			to_chat(user, SPAN_WARNIN69("There is a software error with the device."))
		else
			to_chat(user, SPAN_NOTICE("The device's software appears to be fine."))
		return 1
	else if(istype(O, /obj/machinery))
		var/obj/machinery/A = O
		if(A.ema6969ed)
			to_chat(user, SPAN_WARNIN69("There is a software error with the device."))
		else
			to_chat(user, SPAN_NOTICE("The device's software appears to be fine."))
		return 1
