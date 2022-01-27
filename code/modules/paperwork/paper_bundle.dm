/obj/item/paper_bundle
	name = "paper bundle"
	gender =69EUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	throw_range = 2
	throw_speed = 1
	layer = 4
	attack_verb = list("bapped")
	var/page = 1    // current page
	var/list/pages = list()  // Ordered list of pages as they are to be displayed. Can be different order than src.contents.


/obj/item/paper_bundle/attackby(obj/item/W as obj,69ob/user as69ob)
	..()

	if (istype(W, /obj/item/paper/carbon))
		var/obj/item/paper/carbon/C = W
		if (!C.iscopy && !C.copied)
			to_chat(user, SPAN_NOTICE("Take off the carbon copy first."))
			add_fingerprint(user)
			return
	// adding sheets
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		insert_sheet_at(user, pages.len+1, W)

	// burning
	else if(istype(W, /obj/item/flame))
		burnpaper(W, user)

	//69erging bundles
	else if(istype(W, /obj/item/paper_bundle))
		user.drop_from_inventory(W)
		for(var/obj/O in W)
			O.loc = src
			O.add_fingerprint(usr)
			pages.Add(O)

		to_chat(user, "<span class='notice'>You add \the 69W.name69 to 69(src.name == "paper bundle") ? "the paper bundle" : src.name69.</span>")
		qdel(W)
	else
		if(W.has_quality(QUALITY_ADHESIVE))
			return 0
		if(istype(W, /obj/item/pen))
			usr << browse("", "window=69name69") //Closes the dialog
		var/obj/P = pages69page69
		P.attackby(W, user)

	update_icon()
	attack_self(usr) //Update the browsed page.
	add_fingerprint(usr)
	return

/obj/item/paper_bundle/proc/insert_sheet_at(mob/user,69ar/index, obj/item/sheet)
	if(istype(sheet, /obj/item/paper))
		to_chat(user, "<span class='notice'>You add 69(sheet.name == "paper") ? "the paper" : sheet.name69 to 69(src.name == "paper bundle") ? "the paper bundle" : src.name69.</span>")
	else if(istype(sheet, /obj/item/photo))
		to_chat(user, "<span class='notice'>You add 69(sheet.name == "photo") ? "the photo" : sheet.name69 to 69(src.name == "paper bundle") ? "the paper bundle" : src.name69.</span>")

	user.drop_from_inventory(sheet)
	sheet.loc = src

	pages.Insert(index, sheet)

	if(index <= page)
		page++

/obj/item/paper_bundle/proc/burnpaper(obj/item/flame/P,69ob/user)
	var/class = "warning"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose>"

		user.visible_message("<span class='69class69'>69user69 holds \the 69P69 up to \the 69src69, it looks like \he's trying to burn it!</span>", \
		"<span class='69class69'>You hold \the 69P69 up to \the 69src69, burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message("<span class='69class69'>69user69 burns right through \the 69src69, turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"<span class='69class69'>You burn right through \the 69src69, turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")

				if(user.get_inactive_hand() == src)
					user.drop_from_inventory(src)

				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, "\red You69ust hold \the 69P69 steady to burn \the 69src69.")

/obj/item/paper_bundle/examine(mob/user)
	if(..(user, 1))
		src.show_content(user)
	else
		to_chat(user, SPAN_NOTICE("It is too far away."))
	return

/obj/item/paper_bundle/proc/show_content(mob/user as69ob)
	var/dat
	var/obj/item/W = pages69page69

	// first
	if(page == 1)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref69src69;prev_page=1'>Front</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref69src69;remove=1'>Remove 69(istype(W, /obj/item/paper)) ? "paper" : "photo"69</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref69src69;next_page=1'>Next Page</A></DIV><BR><HR>"
	// last
	else if(page == pages.len)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref69src69;prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref69src69;remove=1'>Remove 69(istype(W, /obj/item/paper)) ? "paper" : "photo"69</A></DIV>"
		dat+= "<DIV STYLE='float;left; text-align:right; with:33.33333%'><A href='?src=\ref69src69;next_page=1'>Back</A></DIV><BR><HR>"
	//69iddle pages
	else
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref69src69;prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref69src69;remove=1'>Remove 69(istype(W, /obj/item/paper)) ? "paper" : "photo"69</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref69src69;next_page=1'>Next Page</A></DIV><BR><HR>"

	if(istype(pages69page69, /obj/item/paper))
		var/obj/item/paper/P = W
		if(!(ishuman(usr) || isghost(usr) || issilicon(usr)))
			dat+= "<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY>69stars(P.info)6969P.stamps69</BODY></HTML>"
		else
			dat+= "<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY>69P.info6969P.stamps69</BODY></HTML>"
		user << browse(dat, "window=69name69")
	else if(istype(pages69page69, /obj/item/photo))
		var/obj/item/photo/P = W
		user << browse_rsc(P.img, "tmp_photo.png")
		user << browse(dat + "<html><head><title>69P.name69</title></head>" \
		+ "<body style='overflow:hidden'>" \
		+ "<div> <img src='tmp_photo.png' width = '6932*P.photo_size69'" \
		+ "69P.scribble ? "<div> Written on the back:<br><i>69P.scribble69</i>" :69ull69"\
		+ "</body></html>", "window=69name69; size=6932*P.photo_size69x6932*P.photo_size69")

/obj/item/paper_bundle/attack_self(mob/user as69ob)
	src.show_content(user)
	add_fingerprint(usr)
	update_icon()
	return

/obj/item/paper_bundle/Topic(href, href_list)
	..()
	if((src in usr.contents) || (istype(src.loc, /obj/item/folder) && (src.loc in usr.contents)))
		usr.set_machine(src)
		var/obj/item/in_hand = usr.get_active_hand()
		if(href_list69"next_page"69)
			if(in_hand && (istype(in_hand, /obj/item/paper) || istype(in_hand, /obj/item/photo)))
				insert_sheet_at(usr, page+1, in_hand)
			else if(page != pages.len)
				page++
				playsound(src.loc, "pageturn", 50, 1)
		if(href_list69"prev_page"69)
			if(in_hand && (istype(in_hand, /obj/item/paper) || istype(in_hand, /obj/item/photo)))
				insert_sheet_at(usr, page, in_hand)
			else if(page > 1)
				page--
				playsound(src.loc, "pageturn", 50, 1)
		if(href_list69"remove"69)
			var/obj/item/W = pages69page69
			usr.put_in_hands(W)
			pages.Remove(pages69page69)

			to_chat(usr, SPAN_NOTICE("You remove the 69W.name69 from the bundle."))

			if(pages.len <= 1)
				var/obj/item/paper/P = src69169
				usr.drop_from_inventory(src)
				usr.put_in_hands(P)
				qdel(src)

				return

			if(page > pages.len)
				page = pages.len

			update_icon()
	else
		to_chat(usr, SPAN_NOTICE("You69eed to hold it in hands!"))
	if (ismob(src.loc) ||ismob(src.loc.loc))
		src.attack_self(usr)
		updateUsrDialog()

/obj/item/paper_bundle/verb/rename()
	set69ame = "Rename bundle"
	set category = "Object"
	set src in usr

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the bundle?", "Bundle Labelling",69ull)  as text,69AX_NAME_LEN)
	if((loc == usr || loc.loc && loc.loc == usr) && usr.stat == 0)
		name = "69(n_name ? text("69n_name69") : "paper")69"
	add_fingerprint(usr)
	return


/obj/item/paper_bundle/verb/remove_all()
	set69ame = "Loose bundle"
	set category = "Object"
	set src in usr

	to_chat(usr, SPAN_NOTICE("You loosen the bundle."))
	for(var/obj/O in src)
		O.loc = usr.loc
		O.layer = initial(O.layer)
		O.add_fingerprint(usr)
	usr.drop_from_inventory(src)
	qdel(src)
	return


/obj/item/paper_bundle/update_icon()
	var/obj/item/paper/P = pages69169
	icon_state = P.icon_state
	overlays = P.overlays
	underlays = 0
	var/i = 0
	var/photo
	for(var/obj/O in src)
		var/image/img = image('icons/obj/bureaucracy.dmi')
		if(istype(O, /obj/item/paper))
			img.icon_state = O.icon_state
			img.pixel_x -=69in(1*i, 2)
			img.pixel_y -=69in(1*i, 2)
			pixel_x =69in(0.5*i, 1)
			pixel_y =69in(  1*i, 2)
			underlays += img
			i++
		else if(istype(O, /obj/item/photo))
			var/obj/item/photo/Ph = O
			img = Ph.tiny
			photo = 1
			overlays += img
	if(i>1)
		desc =  "69i69 papers clipped to each other."
	else
		desc = "A single sheet of paper."
	if(photo)
		desc += "\nThere is a photo attached to it."
	overlays += image('icons/obj/bureaucracy.dmi', "clip")
	return
