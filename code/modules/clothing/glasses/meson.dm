/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"
	action_button_name = "Toggle Optical Matrix"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = TRUE
	prescription = TRUE
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	active = FALSE
	var/tick_cost = 0.5
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small

/obj/item/clothing/glasses/meson/New()
	..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)
	overlay = global_hud.meson

/obj/item/clothing/glasses/meson/Process()
	if(active)
		if(!cell || !cell.checked_use(tick_cost))
			if(ismob(src.loc))
				src.loc << SPAN_WARNING("[src] flashes with error - LOW POWER.")
			toggle(ismob(loc) && loc, FALSE)

/obj/item/clothing/glasses/meson/toggle(mob/user, new_state)
	if(new_state)
		if(!cell || !cell.check_charge(tick_cost) && user)
			user << SPAN_WARNING("[src] battery is dead or missing.")
			return
	..(user, new_state)

/obj/item/clothing/glasses/meson/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/clothing/glasses/meson/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C
