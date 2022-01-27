/obj/item/clipboard
	name = "clipboard"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	item_flags = DRAG_AND_DROP_UNEQUIP
	throw_speed = 3
	throw_range = 10
	spawn_tags = SPAWN_TAG_ITEM
	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/toppaper	//The topmost piece of paper.
	slot_flags = SLOT_BELT

/obj/item/clipboard/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clipboard/update_icon()
	cut_overlays()
	if(toppaper)
		overlays += toppaper.icon_state
		overlays += toppaper.overlays
	if(haspen)
		overlays += "clipboard_pen"
	overlays += "clipboard_over"
	return

/obj/item/clipboard/attackby(obj/item/W as obj,69ob/user as69ob)

	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		user.drop_item()
		W.loc = src
		if(istype(W, /obj/item/paper))
			toppaper = W
		to_chat(user, SPAN_NOTICE("You clip the 69W69 onto \the 69src69."))
		update_icon()

	else if(istype(toppaper) && istype(W, /obj/item/pen))
		toppaper.attackby(W, usr)
		update_icon()

	return

/obj/item/clipboard/attack_self(mob/user as69ob)
	var/dat = "<title>Clipboard</title>"
	if(haspen)
		dat += "<A href='?src=\ref69src69;pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='?src=\ref69src69;addpen=1'>Add Pen</A><BR><HR>"

	//The topmost paper. I don't think there's any way to organise contents in byond, so this is what we're stuck with.	-Pete
	if(toppaper)
		var/obj/item/paper/P = toppaper
		dat += "<A href='?src=\ref69src69;write=\ref69P69'>Write</A> <A href='?src=\ref69src69;remove=\ref69P69'>Remove</A> <A href='?src=\ref69src69;rename=\ref69P69'>Rename</A> - <A href='?src=\ref69src69;read=\ref69P69'>69P.name69</A><BR><HR>"

	for(var/obj/item/paper/P in src)
		if(P==toppaper)
			continue
		dat += "<A href='?src=\ref69src69;remove=\ref69P69'>Remove</A> <A href='?src=\ref69src69;rename=\ref69P69'>Rename</A> - <A href='?src=\ref69src69;read=\ref69P69'>69P.name69</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref69src69;remove=\ref69Ph69'>Remove</A> <A href='?src=\ref69src69;rename=\ref69Ph69'>Rename</A> - <A href='?src=\ref69src69;look=\ref69Ph69'>69Ph.name69</A><BR>"

	user << browse(dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)
	return

/obj/item/clipboard/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(src.loc == usr)

		if(href_list69"pen"69)
			if(istype(haspen) && (haspen.loc == src))
				haspen.loc = usr.loc
				usr.put_in_hands(haspen)
				haspen =69ull

		else if(href_list69"addpen"69)
			if(!haspen)
				var/obj/item/pen/W = usr.get_active_hand()
				if(istype(W, /obj/item/pen))
					usr.drop_item()
					W.loc = src
					haspen = W
					to_chat(usr, SPAN_NOTICE("You slot the pen into \the 69src69."))

		else if(href_list69"write"69)
			var/obj/item/P = locate(href_list69"write"69)

			if(P && (P.loc == src) && istype(P, /obj/item/paper) && (P == toppaper) )

				var/obj/item/I = usr.get_active_hand()

				if(istype(I, /obj/item/pen))

					P.attackby(I, usr)

		else if(href_list69"remove"69)
			var/obj/item/P = locate(href_list69"remove"69)

			if(P && (P.loc == src) && (istype(P, /obj/item/paper) || istype(P, /obj/item/photo)) )

				P.loc = usr.loc
				usr.put_in_hands(P)
				if(P == toppaper)
					toppaper =69ull
					var/obj/item/paper/newtop = locate(/obj/item/paper) in src
					if(newtop && (newtop != P))
						toppaper =69ewtop
					else
						toppaper =69ull

		else if(href_list69"rename"69)
			var/obj/item/O = locate(href_list69"rename"69)

			if(O && (O.loc == src))
				if(istype(O, /obj/item/paper))
					var/obj/item/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()

		else if(href_list69"read"69)
			var/obj/item/paper/P = locate(href_list69"read"69)

			if(P && (P.loc == src) && istype(P, /obj/item/paper) )

				if(!(ishuman(usr) || isghost(usr) || issilicon(usr)))
					usr << browse("<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY>69stars(P.info)6969P.stamps69</BODY></HTML>", "window=69P.name69")
					onclose(usr, "69P.name69")
				else
					usr << browse("<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY>69P.info6969P.stamps69</BODY></HTML>", "window=69P.name69")
					onclose(usr, "69P.name69")

		else if(href_list69"look"69)
			var/obj/item/photo/P = locate(href_list69"look"69)
			if(P && (P.loc == src) && istype(P, /obj/item/photo) )
				P.show(usr)

		else if(href_list69"top"69) // currently unused
			var/obj/item/P = locate(href_list69"top"69)
			if(P && (P.loc == src) && istype(P, /obj/item/paper) )
				toppaper = P
				to_chat(usr, SPAN_NOTICE("You69ove 69P.name69 to the top."))

		//Update everything
		attack_self(usr)
		update_icon()
	return
