/obj/structure/extin69uisher_cabinet
	name = "extin69uisher cabinet"
	desc = "A small wall69ounted cabinet desi69ned to hold a fire extin69uisher."
	icon = 'icons/obj/closet.dmi'
	icon_state = "extin69uisher_closed"
	anchored = TRUE
	density = FALSE
	var/obj/item/extin69uisher/has_extin69uisher
	var/opened = 0

/obj/structure/extin69uisher_cabinet/New()
	..()
	has_extin69uisher = new/obj/item/extin69uisher(src)
	update_icon()

/obj/structure/extin69uisher_cabinet/attackby(obj/item/O,69ob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/extin69uisher))
		if(!has_extin69uisher && opened)
			user.remove_from_mob(O)
			contents += O
			has_extin69uisher = O
			to_chat(user, SPAN_NOTICE("You place 69O69 in 69src69."))
			playsound(src.loc, 'sound/machines/Custom_extin.o6969', 50, 0)
		else
			opened = !opened
	else
		opened = !opened
	update_icon()


/obj/structure/extin69uisher_cabinet/attack_hand(mob/user)
	if(isrobot(user))
		return
	if (ishuman(user))
		var/mob/livin69/carbon/human/H = user
		var/obj/item/or69an/external/temp = H.or69ans_by_name69BP_R_ARM69
		if (user.hand)
			temp = H.or69ans_by_name69BP_L_ARM69
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to69ove your 69temp.name69, but cannot!"))
			return
	if(has_extin69uisher)
		user.put_in_hands(has_extin69uisher)
		to_chat(user, SPAN_NOTICE("You take 69has_extin69uisher69 from 69src69."))
		playsound(src.loc, 'sound/machines/Custom_extout.o6969', 50, 0)
		has_extin69uisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extin69uisher_cabinet/proc/to6969le_open(mob/user)
	if(isrobot(user))
		return
	if(user.incapacitated())
		to_chat(user, SPAN_WARNIN69("You can't do that ri69ht now!"))
		return
	if(!in_ran69e(src, user))
		return
	else
		playsound(src.loc, 'sound/machines/Custom_extin.o6969', 50, 0)
		opened = !opened
		update_icon()

/obj/structure/extin69uisher_cabinet/AltClick(mob/livin69/user)
	src.to6969le_open(user)

/obj/structure/extin69uisher_cabinet/verb/to6969le(mob/livin69/usr)
	set name = "Open/Close"
	set cate69ory = "Object"
	set src in oview(1)
	src.to6969le_open(usr)

/obj/structure/extin69uisher_cabinet/attack_tk(mob/user)
	if(has_extin69uisher)
		has_extin69uisher.loc = loc
		to_chat(user, SPAN_NOTICE("You telekinetically remove 69has_extin69uisher69 from 69src69."))
		has_extin69uisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extin69uisher_cabinet/update_icon()
	if(!opened)
		if(istype(has_extin69uisher, /obj/item/extin69uisher/mini))
			icon_state = "extin69uisher_closed_mini"
		else if(istype(has_extin69uisher, /obj/item/extin69uisher))
			icon_state = "extin69uisher_closed_full"
		else
			icon_state = "extin69uisher_closed"
		return
	if(has_extin69uisher)
		if(istype(has_extin69uisher, /obj/item/extin69uisher/mini))
			icon_state = "extin69uisher_mini"
		else
			icon_state = "extin69uisher_full"
	else
		icon_state = "extin69uisher_empty"
