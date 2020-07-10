/obj/item/clothing/glasses/powered/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	action_button_name = "Toggle Optical Matrix"
	origin_tech = list(TECH_MAGNET = 3)
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_REDUCED
	price_tag = 1000

	tick_cost = 0.5


/obj/item/clothing/glasses/powered/thermal/emp_act(severity)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/M = src.loc
		if(M.glasses == src)
			to_chat(M, SPAN_DANGER("[src] overloads and blinds you!"))
			M.eye_blind = 3
			M.eye_blurry = 5
			// Don't cure being nearsighted
			if(!(M.disabilities & NEARSIGHTED))
				M.disabilities |= NEARSIGHTED
				spawn(100)
					M.disabilities &= ~NEARSIGHTED
	..()

/obj/item/clothing/glasses/powered/thermal/Initialize()
	. = ..()
	overlay = global_hud.thermal

/obj/item/clothing/glasses/powered/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	origin_tech = list(TECH_MAGNET = 3, TECH_COVERT = 4)


/obj/item/clothing/glasses/powered/thermal/onestar
	name = "OS Type - 73 \"Zhenchayuan\""
	desc = "Chinese thermals in the shape of goggles."
	icon_state = "onestar_thermal"
	off_state = "onestar_thermal"

/obj/item/clothing/glasses/powered/thermal/plain
	toggleable = FALSE
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/powered/thermal/plain/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

	body_parts_covered = 0

/obj/item/clothing/glasses/powered/thermal/plain/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0

/obj/item/clothing/glasses/powered/thermal/plain/jensen
	name = "Optical Thermal Implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state = "syringe_kit"

/obj/item/clothing/glasses/powered/thermal/lens
	name = "Thermal lenses"
	desc = "Lenses for glasses."
	toggleable = FALSE
	icon_state = "thermal_lens"
	body_parts_covered = 0
	slot_flags = 0


/obj/item/clothing/glasses/attackby(var/obj/item/Z, var/mob/user)

	if (istype(Z,/obj/item/clothing/glasses/powered/thermal/lens))
		overlay = global_hud.thermal
		vision_flags = SEE_MOBS
		see_invisible = SEE_INVISIBLE_NOLIGHTING
		protection = flash_protection
		flash_protection = FLASH_PROTECTION_REDUCED
		origin_tech = list(TECH_COVERT = 3)
		to_chat(usr, "You attached your lenses to your glasses")
		have_lenses = 1
		qdel(Z)

/obj/item/clothing/glasses/powered/thermal/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/clothing/glasses/powered/thermal/lens))
		to_chat(usr, "This glasses already have thermal implant")
	..()

/obj/item/clothing/glasses/verb/detach_lenses()
	set name = "Detach lenses"
	set category = "Object"
	set src in view(1)

	if (have_lenses == 1)
		flash_protection = protection;
		see_invisible = -1;
		vision_flags = 0;
		origin_tech = 0;
		have_lenses = 0;
		overlay = 0;
		to_chat(usr, "You detach lenses from your glasses");
		var/obj/item/clothing/glasses/powered/thermal/lens/THL = new()
		usr.put_in_hands(THL)
	else to_chat(usr, "You haven't got any lenses in your glasses");