/obj/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	var/insert_anim = "bigscanner1"
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = STATIC_EQUIP
	var/obj/item/copyitem =69ull	//what's in the copier!
	var/copies = 1	//how69any copies to print!
	var/toner = 30 //how69uch toner is left! woooooo~
	var/maxcopies = 10	//how69any copies can be copied at once- idea shamelessly stolen from bs12's copier!

/obj/machinery/photocopier/attack_hand(mob/user as69ob)
	user.set_machine(src)

	var/dat = "Photocopier<BR><BR>"
	if(copyitem)
		dat += "<a href='byond://?src=\ref69src69;remove=1'>Remove Item</a><BR>"
		if(toner)
			dat += "<a href='byond://?src=\ref69src69;copy=1'>Copy</a><BR>"
			dat += "Printing: 69copies69 copies."
			dat += "<a href='byond://?src=\ref69src69;min=1'>-</a> "
			dat += "<a href='byond://?src=\ref69src69;add=1'>+</a><BR><BR>"
	else if(toner)
		dat += "Please insert something to copy.<BR><BR>"
	if(issilicon(user))
		dat += "<a href='byond://?src=\ref69src69;aipic=1'>Print photo from database</a><BR><BR>"
	dat += "Current toner level: 69toner69"
	if(!toner)
		dat +="<BR>Please insert a69ew toner cartridge!"
	user << browse(dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/Topic(href, href_list)
	if(href_list69"copy"69)
		if(stat & (BROKEN|NOPOWER))
			return

		for(var/i = 0, i < copies, i++)
			if(toner <= 0)
				break

			if (istype(copyitem, /obj/item/paper))
				copy(copyitem)
				sleep(15)
			else if (istype(copyitem, /obj/item/photo))
				photocopy(copyitem)
				sleep(15)
			else if (istype(copyitem, /obj/item/paper_bundle))
				var/obj/item/paper_bundle/B = bundlecopy(copyitem)
				sleep(15*B.pages.len)
			else
				to_chat(usr, SPAN_WARNING("\The 69copyitem69 can't be copied by \the 69src69."))
				break

			use_power(active_power_usage)
		updateUsrDialog()
	else if(href_list69"remove"69)
		if(copyitem)
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			to_chat(usr, SPAN_NOTICE("You take \the 69copyitem69 out of \the 69src69."))
			copyitem =69ull
			updateUsrDialog()
	else if(href_list69"min"69)
		if(copies > 1)
			copies--
			updateUsrDialog()
	else if(href_list69"add"69)
		if(copies <69axcopies)
			copies++
			updateUsrDialog()
	else if(href_list69"aipic"69)
		if(!issilicon(usr))
			return
		if(stat & (BROKEN|NOPOWER))
			return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = usr
			var/obj/item/device/camera/siliconcam/camera = tempAI.aiCamera

			if(!camera)
				return
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by 69tempAI.name69"
			else
				p.desc += " - Copied by 69tempAI.name69"
			toner -= 5
			sleep(15)
		updateUsrDialog()

/obj/machinery/photocopier/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/paper) || istype(I, /obj/item/photo) || istype(I, /obj/item/paper_bundle))
		if(!copyitem)
			user.drop_item()
			copyitem = I
			I.loc = src
			to_chat(user, SPAN_NOTICE("You insert \the 69I69 into \the 69src69."))
			flick(insert_anim, src)
			updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("There is already something in \the 69src69."))
	else if(istype(I, /obj/item/device/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			user.drop_item()
			to_chat(user, SPAN_NOTICE("You insert the toner cartridge into \the 69src69."))
			var/obj/item/device/toner/T = I
			toner += T.toner_amount
			qdel(I)
			updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("This cartridge is69ot yet ready for replacement! Use up the rest of the toner."))
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
			anchored = !anchored
			to_chat(user, "<span class='notice'>You 69anchored ? "wrench" : "unwrench"69 \the 69src69.</span>")
	return

/obj/machinery/photocopier/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)
			else
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
		else
			if(prob(50))
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
	return

/obj/machinery/photocopier/proc/copy(var/obj/item/paper/copy)
	var/obj/item/paper/c =69ew /obj/item/paper (loc)
	if(toner > 10)	//lots of toner,69ake it dark
		c.info = "<font color = #101010>"
	else			//no toner? shitty copies for you!
		c.info = "<font color = #808080>"
	var/copied = html_decode(copy.info)
	copied = replacetext(copied, "<font face=\"69c.deffont69\" color=", "<font face=\"69c.deffont69\"69ocolor=")	//state of the art techniques in action
	copied = replacetext(copied, "<font face=\"69c.crayonfont69\" color=", "<font face=\"69c.crayonfont69\"69ocolor=")	//This basically just breaks the existing color tag, which we69eed to do because the innermost tag takes priority.
	c.info += copied
	c.info += "</font>"//</font>
	c.name = copy.name // -- Doohl
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.ico = copy.ico
	c.offset_x = copy.offset_x
	c.offset_y = copy.offset_y
	var/list/temp_overlays = copy.overlays       //Iterates through stamps
	var/image/img                                //and puts a69atching
	for (var/j = 1, j <=69in(temp_overlays.len, copy.ico.len), j++) //gray overlay onto the copy
		if (findtext(copy.ico69j69, "cap") || findtext(copy.ico69j69, "cent"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
		else if (findtext(copy.ico69j69, "deny"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
		img.pixel_x = copy.offset_x69j69
		img.pixel_y = copy.offset_y69j69
		c.overlays += img
	c.updateinfolinks()
	toner--
	if(toner == 0)
		visible_message(SPAN_NOTICE("A red light on \the 69src69 flashes, indicating that it is out of toner."))
	return c


/obj/machinery/photocopier/proc/photocopy(var/obj/item/photo/photocopy)
	var/obj/item/photo/p = photocopy.copy()
	p.loc = src.loc

	var/icon/I = icon(photocopy.icon, photocopy.icon_state)
	if(toner > 10)	//plenty of toner, go straight greyscale
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))		//I'm69ot sure how expensive this is, but given the69any limitations of photocopying, it shouldn't be an issue.
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	else			//not69uch toner left, lighten the photo
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
	p.icon = I
	toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		visible_message(SPAN_NOTICE("A red light on \the 69src69 flashes, indicating that it is out of toner."))

	return p

//If69eed_toner is 0, the copies will still be lightened when low on toner, however it will69ot be prevented from printing. TODO: Implement print queues for fax69achines and get rid of69eed_toner
/obj/machinery/photocopier/proc/bundlecopy(var/obj/item/paper_bundle/bundle,69ar/need_toner=1)
	var/obj/item/paper_bundle/p =69ew /obj/item/paper_bundle (src)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 &&69eed_toner)
			toner = 0
			visible_message(SPAN_NOTICE("A red light on \the 69src69 flashes, indicating that it is out of toner."))
			break

		if(istype(W, /obj/item/paper))
			W = copy(W)
		else if(istype(W, /obj/item/photo))
			W = photocopy(W)
		W.loc = p
		p.pages += W

	p.loc = src.loc
	p.update_icon()
	p.icon_state = "paper_words"
	p.name = bundle.name
	p.pixel_y = rand(-8, 8)
	p.pixel_x = rand(-9, 9)
	return p

/obj/item/device/toner
	name = "toner cartridge"
	icon_state = "tonercartridge"
	var/toner_amount = 30
