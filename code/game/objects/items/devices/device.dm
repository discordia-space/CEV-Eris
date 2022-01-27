/obj/item/device
	icon = 'icons/obj/device.dmi'
	spawn_ta69s = SPAWN_TA69_DIVICE
	bad_type = /obj/item/device
	var/startin69_cell = TRUE
	var/obj/item/cell/cell
	var/suitable_cell

/obj/item/device/Initialize(mapload)
	. = ..()
	make_startin69_cell()

/obj/item/device/Created()
	.=..()
	69DEL_NULL(cell)

/obj/item/device/Destroy()
	69DEL_NULL(cell)
	. = ..()

/obj/item/device/proc/make_startin69_cell()
	if(!cell && suitable_cell && startin69_cell)
		cell = new suitable_cell(src)

/obj/item/device/69et_cell()
	return cell

/obj/item/device/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/device/MouseDrop(over_object)
	if((loc == usr) && suitable_cell && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
		return
	. = ..()

/obj/item/device/attackby(obj/item/C,69ob/livin69/user)
	if(istype(C, suitable_cell))
		if(cell)
			to_chat(user, "There is a 69cell69 already installed here.")
		else if(insert_item(C, user))
			cell = C
		update_icon()
		return
	. = ..()

/obj/item/device/examine(mob/user)
	. = ..()
	if(suitable_cell)
		if(cell)
			to_chat(user, SPAN_NOTICE("\The 69src69's cell reads \"69round(cell.percent(),0.1)69%\""))
		else
			to_chat(user, SPAN_WARNIN69("\The 69src69 has no cell installed."))

/obj/item/device/proc/cell_use_check(char69e,69ob/user)
	. = TRUE
	if(!cell || !cell.checked_use(char69e))
		if(user)
			to_chat(user, SPAN_WARNIN69("69src69 battery is dead or69issin69."))
		. = FALSE

/obj/item/device/proc/cell_check(char69e,69ob/user)
	. = TRUE
	if(!cell || !cell.check_char69e(char69e))
		if(user)
			to_chat(user, SPAN_WARNIN69("69src69 battery is dead or69issin69."))
		. = FALSE
