/obj/structure/bigDelivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycloset"
	density = TRUE
	flags =69OBLUDGEON
	mouse_drag_pointer =69OUSE_ACTIVE_POINTER
	var/obj/wrapped
	var/sortTag
	var/examtext
	var/nameset = 0
	var/label_y
	var/label_x
	var/tag_x

/obj/structure/bigDelivery/attack_hand(mob/user as69ob)
	unwrap()

/obj/structure/bigDelivery/proc/unwrap()
	if(src.wrapped && (src.wrapped in src.contents)) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove(get_turf(src.loc))
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
	69del(src)

/obj/structure/bigDelivery/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, SPAN_NOTICE("You have labeled the destination as 69O.currTag69."))
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			else
				to_chat(user, SPAN_WARNING("The package is already labeled for 69O.currTag69."))
		else
			to_chat(user, SPAN_WARNING("You69eed to set a destination first!"))

	else if(istype(W, /obj/item/pen))
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = sanitizeSafe(input(usr,"Label text?","Set label",""),69AX_NAME_LEN)
				if(!str || !length(str))
					to_chat(usr, SPAN_WARNING(" Invalid text."))
					return
				user.visible_message("\The 69user69 titles \the 69src69 with \a 69W69,69arking down: \"69str69\"",\
				"<span class='notice'>You title \the 69src69: \"69str69\"</span>",\
				"You hear someone scribbling a69ote.")
				playsound(src.loc, 'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg', 50, 1)
				name = "69name69 (69str69)"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1
			if("Description")
				var/str = sanitize(input(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(usr, "\red Invalid text.")
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The 69user69 labels \the 69src69 with \a 69W69, scribbling down: \"69examtext69\"",\
				"<span class='notice'>You label \the 69src69: \"69examtext69\"</span>",\
				"You hear someone scribbling a69ote.")
				playsound(src.loc, 'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg', 50, 1)
	return

/obj/structure/bigDelivery/update_icon()
	overlays =69ew()
	if(nameset || examtext)
		var/image/I =69ew/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycloset")
			I.pixel_x = 2
			if(label_y ==69ull)
				label_y = rand(-6, 11)
			I.pixel_y = label_y
		else if(icon_state == "deliverycrate")
			if(label_x ==69ull)
				label_x = rand(-8, 6)
			I.pixel_x = label_x
			I.pixel_y = -3
		overlays += I
	if(src.sortTag)
		var/image/I =69ew/image('icons/obj/storage.dmi',"delivery_tag")
		if(icon_state == "deliverycloset")
			if(tag_x ==69ull)
				tag_x = rand(-2, 3)
			I.pixel_x = tag_x
			I.pixel_y = 9
		else if(icon_state == "deliverycrate")
			if(tag_x ==69ull)
				tag_x = rand(-8, 6)
			I.pixel_x = tag_x
			I.pixel_y = -3
		overlays += I

/obj/structure/bigDelivery/examine(mob/user)
	if(..(user, 4))
		if(sortTag)
			to_chat(user, "<span class='notice'>It is labeled \"69sortTag69\"</span>")
		if(examtext)
			to_chat(user, "<span class='notice'>It has a69ote attached which reads, \"69examtext69\"</span>")
	return

/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate3"
	var/obj/item/wrapped
	var/sortTag
	var/examtext
	var/nameset = 0
	var/tag_x

/obj/item/smallDelivery/attack_self(mob/user as69ob)
	if (src.wrapped && (src.wrapped in src.contents)) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove(user.loc)
		if(ishuman(user))
			user.put_in_hands(wrapped)
		else
			wrapped.forceMove(get_turf(src))

	69del(src)
	return

/obj/item/smallDelivery/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, SPAN_NOTICE("You have labeled the destination as 69O.currTag69."))
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
				playsound(src,'sound/effects/FOLEY_Gaffer_Tape_Tear_mono.ogg',100,2)
			else
				to_chat(user, SPAN_WARNING("The package is already labeled for 69O.currTag69."))
		else
			to_chat(user, SPAN_WARNING("You69eed to set a destination first!"))

	else if(istype(W, /obj/item/pen))
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = sanitizeSafe(input(usr,"Label text?","Set label",""),69AX_NAME_LEN)
				if(!str || !length(str))
					to_chat(usr, SPAN_WARNING(" Invalid text."))
					return
				user.visible_message("\The 69user69 titles \the 69src69 with \a 69W69,69arking down: \"69str69\"",\
				"<span class='notice'>You title \the 69src69: \"69str69\"</span>",\
				"You hear someone scribbling a69ote.")
				playsound(src.loc, 'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg', 50, 1)
				name = "69name69 (69str69)"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1

			if("Description")
				var/str = sanitize(input(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(usr, "\red Invalid text.")
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The 69user69 labels \the 69src69 with \a 69W69, scribbling down: \"69examtext69\"",\
				"<span class='notice'>You label \the 69src69: \"69examtext69\"</span>",\
				"You hear someone scribbling a69ote.")
				playsound(src.loc, 'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg', 50, 1)
	return

/obj/item/smallDelivery/update_icon()
	overlays =69ew()
	if((nameset || examtext) && icon_state != "deliverycrate1")
		var/image/I =69ew/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycrate5")
			I.pixel_y = -1
		overlays += I
	if(src.sortTag)
		var/image/I =69ew/image('icons/obj/storage.dmi',"delivery_tag")
		switch(icon_state)
			if("deliverycrate1")
				I.pixel_y = -5
			if("deliverycrate2")
				I.pixel_y = -2
			if("deliverycrate3")
				I.pixel_y = 0
			if("deliverycrate4")
				if(tag_x ==69ull)
					tag_x = rand(0,5)
				I.pixel_x = tag_x
				I.pixel_y = 3
			if("deliverycrate5")
				I.pixel_y = -3
		overlays += I

/obj/item/smallDelivery/examine(mob/user)
	if(..(user, 4))
		if(sortTag)
			to_chat(user, "<span class='notice'>It is labeled \"69sortTag69\"</span>")
		if(examtext)
			to_chat(user, "<span class='notice'>It has a69ote attached which reads, \"69examtext69\"</span>")
	return

/obj/item/packageWrap
	name = "package wrapper"
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	w_class = ITEM_SIZE_NORMAL
	spawn_tags = SPAWN_TAG_ITEM_UTILITY
	rarity_value = 50
	var/amount = 25.0


/obj/item/packageWrap/afterattack(var/obj/target as obj,69ob/user as69ob, proximity)
	if(!proximity) return
	if(!istype(target))	//this really shouldn't be69ecessary (but it is).	-Pete
		return
	if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
	|| istype(target, /obj/item/gift) || istype(target, /obj/item/evidencebag))
		return
	if(target.anchored)
		return
	if(target in user)
		return
	if(user in target) //no wrapping closets that you are inside - it's69ot physically possible
		return

	user.attack_log += text("\6969time_stamp()69\69 <font color='blue'>Has used 69src.name69 on \ref69target69</font>")
	playsound(src,'sound/machines/PAPER_Fold_01_mono.ogg',100,1)

	if (istype(target, /obj/item) && !(istype(target, /obj/item/storage) && !istype(target,/obj/item/storage/box)))
		var/obj/item/O = target
		if (src.amount > 1)
			var/obj/item/smallDelivery/P =69ew /obj/item/smallDelivery(get_turf(O.loc))	//Aaannd wrap it up!
			if(!istype(O.loc, /turf))
				if(user.client)
					user.client.screen -= O
			P.wrapped = O
			O.forceMove(P)
			P.w_class = O.w_class
			var/i = round(O.w_class)
			if(i in list(1,2,3,4,5))
				P.icon_state = "deliverycrate69i69"
				switch(i)
					if(1) P.name = "tiny parcel"
					if(3) P.name = "normal-sized parcel"
					if(4) P.name = "large parcel"
					if(5) P.name = "huge parcel"
			if(i < 1)
				P.icon_state = "deliverycrate1"
				P.name = "tiny parcel"
			if(i > 5)
				P.icon_state = "deliverycrate5"
				P.name = "huge parcel"
			P.add_fingerprint(usr)
			O.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.amount -= 1
			user.visible_message("\The 69user69 wraps \a 69target69 with \a 69src69.",\
			SPAN_NOTICE("You wrap \the 69target69, leaving 69amount69 units of paper on \the 69src69."),\
			"You hear someone taping paper around a small object.")
	else if (istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P =69ew /obj/structure/bigDelivery(get_turf(O.loc))
			P.icon_state = "deliverycrate"
			P.wrapped = O
			O.forceMove(P)
			src.amount -= 3
			user.visible_message("\The 69user69 wraps \a 69target69 with \a 69src69.",\
			SPAN_NOTICE("You wrap \the 69target69, leaving 69amount69 units of paper on \the 69src69."),\
			"You hear someone taping paper around a large object.")
		else if(src.amount < 3)
			to_chat(user, SPAN_WARNING("You69eed69ore paper."))
	else if (istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P =69ew /obj/structure/bigDelivery(get_turf(O.loc))
			P.wrapped = O
			O.welded = 1
			O.forceMove(P)
			src.amount -= 3
			user.visible_message("\The 69user69 wraps \a 69target69 with \a 69src69.",\
			SPAN_NOTICE("You wrap \the 69target69, leaving 69amount69 units of paper on \the 69src69."),\
			"You hear someone taping paper around a large object.")
		else if(src.amount < 3)
			to_chat(user, SPAN_WARNING("You69eed69ore paper."))
	else
		to_chat(user, "\blue The object you are trying to wrap is unsuitable for the sorting69achinery!")
	if (src.amount <= 0)
		new /obj/item/c_tube( src.loc )
		69del(src)
		return
	return

/obj/item/packageWrap/examine(mob/user)
	if(..(user, 0))
		to_chat(user, "\blue There are 69amount69 units of package wrap left!")

	return

/obj/structure/bigDelivery/Destroy()
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.loc = (get_turf(loc))
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.loc = T
	. = ..()

/obj/item/device/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon_state = "dest_tagger"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	rarity_value = 50
	var/currTag = 0

	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	flags = CONDUCT
	slot_flags = SLOT_BELT

/obj/item/device/destTagger/proc/openwindow(mob/user as69ob)
	var/dat = "<tt><center><h1><b>TagMaster 2.3</b></h1></center>"

	dat += "<table style='width:100%; padding:4px;'><tr>"
	for(var/i = 1, i <= tagger_locations.len, i++)
		dat += "<td><a href='?src=\ref69src69;nextTag=69tagger_locations69i6969'>69tagger_locations69i6969</a></td>"

		if (i%4==0)
			dat += "</tr><tr>"

	dat += "</tr></table><br>Current Selection: 69currTag ? currTag : "None"69</tt>"
	dat += "<br><a href='?src=\ref69src69;nextTag=CUSTOM'>Enter custom location.</a>"
	user << browse(dat, "window=destTagScreen;size=450x375")
	onclose(user, "destTagScreen")

/obj/item/device/destTagger/attack_self(mob/user as69ob)
	openwindow(user)
	return

/obj/item/device/destTagger/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"nextTag"69 && (href_list69"nextTag"69 in tagger_locations))
		src.currTag = href_list69"nextTag"69
	if(href_list69"nextTag"69 == "CUSTOM")
		var/dest = input("Please enter custom location.", "Location", src.currTag ? src.currTag : "None")
		if(dest != "None")
			src.currTag = dest
		else
			src.currTag = 0
	openwindow(usr)

/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	icon_state = "intake"
	layer = BELOW_OBJ_LAYER //So that things being ejected are69isible
	var/c_mode = 0

/obj/machinery/disposal/deliveryChute/New()
	..()
	spawn(5)
		trunk = locate() in src.loc
		if(trunk)
			trunk.linked = src	// link the pipe trunk to self

/obj/machinery/disposal/deliveryChute/interact()
	return

/obj/machinery/disposal/deliveryChute/update()
	return

/obj/machinery/disposal/deliveryChute/Bumped(var/atom/movable/AM) //Go straight into the chute
	if(istype(AM, /obj/item/projectile) || istype(AM, /obj/effect))	return
	if(AM.loc && src.loc)
		switch(dir)
			if(NORTH)
				if(AM.loc.y != src.loc.y+1) return
			if(EAST)
				if(AM.loc.x != src.loc.x+1) return
			if(SOUTH)
				if(AM.loc.y != src.loc.y-1) return
			if(WEST)
				if(AM.loc.x != src.loc.x-1) return

	if(isobj(AM) || ismob(AM))
		AM.forceMove(src)
	src.flush()

/obj/machinery/disposal/deliveryChute/flush()
	flushing = 1
	flick("intake-closing", src)
	var/obj/structure/disposalholder/H =69ew()	//69irtual holder object which actually
												// travels through the pipes.
	air_contents =69ew()		//69ew empty gas resv.

	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	sleep(5) // wait for animation to finish

	H.init(src)	// copy the contents of disposer to holder

	H.start(src) // start the holder processing69ovement
	flushing = 0
	//69ow reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return

/obj/machinery/disposal/deliveryChute/get_eject_turf()
	return get_ranged_target_turf(src, dir, 10)

/obj/machinery/disposal/deliveryChute/attackby(var/obj/item/I,69ar/mob/user)

	var/list/usable_69ualities = list(69UALITY_SCREW_DRIVING)
	if(c_mode == 1)
		usable_69ualities.Add(69UALITY_WELDING)

	var/tool_type = I.get_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVING)
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			if(mode<=0)
				var/used_sound =69ode ? 'sound/machines/Custom_screwdriverclose.ogg' : 'sound/machines/Custom_screwdriveropen.ogg'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					if(c_mode==0) // It's off but still69ot unscrewed
						c_mode=1 // Set it to doubleoff l0l
						to_chat(user, "You remove the screws around the power connection.")
						return
					else if(c_mode==1)
						c_mode=0
						to_chat(user, "You attach the screws around the power connection.")
						return
			return

		if(69UALITY_WELDING)
			if(mode==-1)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY))
					to_chat(user, "You sliced the floorweld off the disposal unit.")
					var/obj/structure/disposalconstruct/C =69ew (src.loc)
					src.transfer_fingerprints_to(C)
					C.pipe_type = PIPE_TYPE_INTAKE
					C.anchored = TRUE
					C.density = TRUE
					C.update()
					69del(src)
			return

/obj/machinery/disposal/deliveryChute/Destroy()
	if(trunk)
		trunk.linked =69ull
	. = ..()
