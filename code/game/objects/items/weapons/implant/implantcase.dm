//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_TINY
	var/obj/item/implant/implant = null
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_GLASS = 3)

/obj/item/implantcase/New()
	..()
	if(ispath(implant))
		implant = new implant(src)
		update_icon()

/obj/item/implantcase/update_icon()
	cut_overlays()
	if(implant)
		var/image/content = image('icons/obj/items.dmi', icon_state = implant.implant_overlay, pixel_x = 7, pixel_y = -6)
		add_overlay(content)

/obj/item/implantcase/attackby(obj/item/I as obj,69ob/user as69ob)
	..()
	if (istype(I, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("6969", src.name), null)  as text
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t,69AX_NAME_LEN)
		if(t)
			src.name = "Glass Case - '69t69'"
		else
			src.name = "Glass Case"
	else if(istype(I, /obj/item/reagent_containers/syringe))
		if(!implant)
			return
		if(!implant.allow_reagents)
			return
		if(implant.reagents.total_volume >= implant.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The 69src69 is full."))
		else
			spawn(5)
				I.reagents.trans_to_obj(implant, 5)
				to_chat(user, SPAN_NOTICE("You inject 5 units of the solution. The syringe now contains 69I.reagents.total_volume69 units."))
	else if (istype(I, /obj/item/implanter))
		var/obj/item/implanter/M = I
		if(M.implant)
			if (implant ||69.implant.implanted)
				return
			M.implant.forceMove(src)
			src.implant =69.implant
			M.implant = null
			update_icon()
			M.update_icon()
		else
			if(implant && !implant.is_external() && !M.implant)
				implant.forceMove(M)
				M.implant = implant
				implant = null
				update_icon()
				M.update_icon()
	else if (istype(I, /obj/item/implant) && !implant && user.unE69uip(I, src))
		implant = I
		update_icon()