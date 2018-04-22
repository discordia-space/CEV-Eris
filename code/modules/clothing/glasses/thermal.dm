/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	action_button_name = "Toggle Optical Matrix"
	origin_tech = list(TECH_MAGNET = 3)
	toggleable = TRUE
	prescription = TRUE
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_REDUCED
	active = FALSE
	var/tick_cost = 0.5
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small

/obj/item/clothing/glasses/thermal/emp_act(severity)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/M = src.loc
		if(M.glasses == src)
			M << SPAN_DANGER("[src] overloads and blinds you!")
			M.eye_blind = 3
			M.eye_blurry = 5
			// Don't cure being nearsighted
			if(!(M.disabilities & NEARSIGHTED))
				M.disabilities |= NEARSIGHTED
				spawn(100)
					M.disabilities &= ~NEARSIGHTED
	..()

/obj/item/clothing/glasses/thermal/New()
	..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)
	overlay = global_hud.thermal

/obj/item/clothing/glasses/thermal/Process()
	if(active)
		if(!cell || !cell.checked_use(tick_cost))
			if(ismob(src.loc))
				src.loc << SPAN_WARNING("[src] flashes with error - LOW POWER.")
			toggle(ismob(loc) && loc, FALSE)

/obj/item/clothing/glasses/thermal/toggle(mob/user, new_state)
	if(new_state)
		if(!cell || !cell.check_charge(tick_cost) && user)
			user << SPAN_WARNING("[src] battery is dead or missing.")
			return
	..(user, new_state)

/obj/item/clothing/glasses/thermal/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/clothing/glasses/thermal/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

/obj/item/clothing/glasses/thermal/plain
	toggleable = FALSE
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "Optical Thermal Implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state = "syringe_kit"
