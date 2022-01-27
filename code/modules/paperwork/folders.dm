/obj/item/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_BIOMATTER = 2)
	rarity_value = 5
	spawn_tags = SPAWN_TAG_JUNK

/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/cyan
	desc = "A cyan folder."
	icon_state = "folder_cyan"

/obj/item/folder/update_icon()
	cut_overlays()
	if(contents.len)
		overlays += "folder_paper"
	return

/obj/item/folder/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/paper_bundle))
		user.drop_item()
		W.loc = src
		playsound(src,'sound/effects/Paper_Shake.ogg',40,1)
		to_chat(user, SPAN_NOTICE("You put the 69W69 into \the 69src69."))
		update_icon()
	else if(istype(W, /obj/item/pen))
		var/n_name = sanitizeSafe(input(usr, "What would you like to label the folder?", "Folder Labelling",69ull)  as text,69AX_NAME_LEN)
		if((loc == usr && usr.stat == 0))
			name = "folder69(n_name ? text("- '69n_name69'") :69ull)69"
	return

/obj/item/folder/attack_self(mob/user as69ob)
	var/dat = "<title>69name69</title>"

	for(var/obj/item/paper/P in src)
		dat += "<A href='?src=\ref69src69;remove=\ref69P69'>Remove</A> <A href='?src=\ref69src69;rename=\ref69P69'>Rename</A> - <A href='?src=\ref69src69;read=\ref69P69'>69P.name69</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref69src69;remove=\ref69Ph69'>Remove</A> <A href='?src=\ref69src69;rename=\ref69Ph69'>Rename</A> - <A href='?src=\ref69src69;look=\ref69Ph69'>69Ph.name69</A><BR>"
	for(var/obj/item/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref69src69;remove=\ref69Pb69'>Remove</A> <A href='?src=\ref69src69;rename=\ref69Pb69'>Rename</A> - <A href='?src=\ref69src69;browse=\ref69Pb69'>69Pb.name69</A><BR>"
	user << browse(dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(src.loc == usr)

		if(href_list69"remove"69)
			var/obj/item/P = locate(href_list69"remove"69)
			if(P && (P.loc == src) && istype(P))
				P.loc = usr.loc
				playsound(src,'sound/effects/Paper_Remove.ogg',40,1)
				usr.put_in_hands(P)

		else if(href_list69"read"69)
			var/obj/item/paper/P = locate(href_list69"read"69)
			playsound(src,'sound/effects/Paper_Shake.ogg',40,1)
			if(P && (P.loc == src) && istype(P))
				if(!(ishuman(usr) || isghost(usr) || issilicon(usr)))
					usr << browse("<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY>69stars(P.info)6969P.stamps69</BODY></HTML>", "window=69P.name69")
					onclose(usr, "69P.name69")
				else
					usr << browse("<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY>69P.info6969P.stamps69</BODY></HTML>", "window=69P.name69")
					onclose(usr, "69P.name69")
		else if(href_list69"look"69)
			var/obj/item/photo/P = locate(href_list69"look"69)
			if(P && (P.loc == src) && istype(P))
				P.show(usr)
		else if(href_list69"browse"69)
			var/obj/item/paper_bundle/P = locate(href_list69"browse"69)
			if(P && (P.loc == src) && istype(P))
				P.attack_self(usr)
				onclose(usr, "69P.name69")
		else if(href_list69"rename"69)
			var/obj/item/O = locate(href_list69"rename"69)

			if(O && (O.loc == src))
				if(istype(O, /obj/item/paper))
					var/obj/item/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/paper_bundle))
					var/obj/item/paper_bundle/to_rename = O
					to_rename.rename()

		//Update everything
		attack_self(usr)
		update_icon()
	return
