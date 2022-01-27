// How69any fields a sheet of paper69ay hold.
#define69AX_FIELDS 50

/*
 * Paper
 * also scraps of paper
 */

/obj/item/paper
	name = "sheet of paper"
	gender =69EUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_range = 1
	throw_speed = 1
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	attack_verb = list("bapped")
	matter = list(MATERIAL_BIOMATTER = 1)
	contained_sprite = TRUE
	spawn_tags = SPAWN_JUNK
	rarity_value = 3.5


	var/info		//What's actually written on the paper.
	var/info_links	//A different69ersion of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields		//Amount of user created fields
	var/free_space =69AX_PAPER_MESSAGE_LEN
	var/list/stamped
	var/list/ico69069      //Icons and
	var/list/offset_x69069 //offsets stored for later
	var/list/offset_y69069 //usage by the photocopier
	var/rigged = 0
	var/spam_flag = 0
	var/crumpled = FALSE

	var/const/deffont = "Verdana"
	var/const/signfont = "Times69ew Roman"
	var/const/crayonfont = "Comic Sans69S"

/obj/item/paper/New(loc, text,title)
	..(loc)
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	set_content(text ? text : info, title)

/obj/item/paper/proc/set_content(text,title)
	if(title)
		name = title
	info = html_encode(text)
	info = parsepencode(text)
	update_icon()
	update_space(info)
	updateinfolinks()

/obj/item/paper/update_icon()
	if (icon_state == "paper_talisman")
		return
	else if (info)
		icon_state = "paper_words"
	else
		icon_state = "paper"

/obj/item/paper/proc/update_space(var/new_text)
	if(!new_text)
		free_space -= length(strip_html_properly(new_text))

/obj/item/paper/examine(mob/user)
	. = ..()
	if(name != "sheet of paper")
		to_chat(user, "It's titled '69name69'.")
	if(in_range(user, src) || isghost(user))
		show_content(usr)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")

/obj/item/paper/proc/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	user << browse("<HTML><meta charset=\"utf-8\"><HEAD><TITLE>69name69</TITLE></HEAD><BODY bgcolor='69color69'>69can_read ? info : stars(info)6969stamps69</BODY></HTML>", "window=69name69")
	onclose(user, "69name69")

/obj/item/paper/verb/rename()
	set69ame = "Rename paper"
	set category = "Object"
	set src in usr
	playsound(src,'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg',40,1)

	if((CLUMSY in usr.mutations) && prob(50))
		to_chat(usr, SPAN_WARNING("You cut yourself on the paper."))
		return
	var/n_name = sanitizeSafe(input(usr, "What would you like to label the paper?", "Paper Labelling",69ull)  as text,69AX_NAME_LEN)

	// We check loc one level up, so we can rename in clipboards and such. See also: /obj/item/photo/rename()
	if((loc == usr || loc.loc && loc.loc == usr) && usr.stat == 0 &&69_name)
		name =69_name
		add_fingerprint(usr)

/obj/item/paper/attack_self(mob/living/user as69ob)
	if (user.a_intent == I_HURT)
		if (crumpled)
			user.show_message(SPAN_WARNING("\The 69src69 is already crumpled."))
			return
		//crumple dat paper
		info = stars(info,85)
		user.visible_message("\The 69user69 crumples \the 69src69 into a ball!")
		icon_state = "69icon_state69_crumpled"
		playsound(loc, 'sound/effects/paper_crumpling.ogg', 40, 1)
		crumpled = TRUE
		return
	user.examinate(src)
	if(rigged && (Holiday == "April Fool's Day"))
		if (spam_flag == 0)
			spam_flag = 1
			playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
			spawn(20)
				spam_flag = 0

/obj/item/paper/attack_ai(var/mob/living/silicon/ai/user)
	show_content(user)

/obj/item/paper/attack(mob/living/carbon/M as69ob,69ob/living/carbon/user as69ob)
	if(user.targeted_organ == BP_EYES)
		user.visible_message(SPAN_NOTICE("You show the paper to 69M69. "), \
			SPAN_NOTICE(" 69user69 holds up a paper and shows it to 69M69. "))
		M.examinate(src)

	else if(user.targeted_organ == BP_MOUTH) // lipstick wiping
		if(ishuman(M))
			var/mob/living/carbon/human/H =69
			if(H == user)
				to_chat(user, SPAN_NOTICE("You wipe off the lipstick with 69src69."))
				H.lip_style =69ull
				H.update_body()
			else
				user.visible_message(SPAN_WARNING("69user69 begins to wipe 69H69's lipstick off with \the 69src69."), \
								 	 SPAN_NOTICE("You begin to wipe off 69H69's lipstick."))
				if(do_after(user, 10, H) && do_after(H, 10,69eedhand = 0))	//user69eeds to keep their active hand, H does69ot.
					user.visible_message(SPAN_NOTICE("69user69 wipes 69H69's lipstick off with \the 69src69."), \
										 SPAN_NOTICE("You wipe off 69H69's lipstick."))
					H.lip_style =69ull
					H.update_body()

/obj/item/paper/proc/addtofield(var/id,69ar/text,69ar/links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(locid <69AX_FIELDS)
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart == 0)
			return //69o field found with69atching id

		laststart = istart + 1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			textindex = iend
			break

	if (links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()

/obj/item/paper/proc/updateinfolinks()
	info_links = info
	var/i = 0
	for(i = 1, i<=fields, i++)
		addtofield(i, "<font face=\"69deffont69\"><A href='?src=\ref69src69;write=69i69'>write</A></font>", 1)
	info_links = info_links + "<font face=\"69deffont69\"><A href='?src=\ref69src69;write=end'>write</A></font>"


/obj/item/paper/proc/clearpaper()
	info =69ull
	stamps =69ull
	free_space =69AX_PAPER_MESSAGE_LEN
	stamped = list()
	cut_overlays()
	updateinfolinks()
	update_icon()

/obj/item/paper/proc/get_signature(var/obj/item/pen/P,69ob/user as69ob)
	if (P && istype(P, /obj/item/pen))
		return P.get_signature(user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/paper/proc/parsepencode(t, obj/item/pen/P,69ob/user, iscrayon)
	if (length(t) == 0)
		return ""

	if (findtext(t, "\69sign\69"))
		t = replacetext(t, "\69sign\69", "<font face=\"69signfont69\"><i>69get_signature(P, user)69</i></font>")

	if (iscrayon) // If it is a crayon, and he still tries to use these,69ake them empty!
		t = replacetext(t, "\69*\69", "")
		t = replacetext(t, "\69hr\69", "")
		t = replacetext(t, "\69small\69", "")
		t = replacetext(t, "\69/small\69", "")
		t = replacetext(t, "\69list\69", "")
		t = replacetext(t, "\69/list\69", "")
		t = replacetext(t, "\69table\69", "")
		t = replacetext(t, "\69/table\69", "")
		t = replacetext(t, "\69grid\69", "")
		t = replacetext(t, "\69/grid\69", "")
		t = replacetext(t, "\69row\69", "")
		t = replacetext(t, "\69cell\69", "")
		t = replacetext(t, "\69logo\69", "")

	if (iscrayon)
		t = "<font face=\"69crayonfont69\" color=69P ? P.colour : "black"69><b>69t69</b></font>"
	else
		t = "<font face=\"69deffont69\" color=69P ? P.colour : "black"69>69t69</font>"

	t = pencode2html(t)

	//Count the fields
	var/laststart = 1
	while(fields <69AX_FIELDS)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)	//</span>
		if(i == 0)
			break
		laststart = i + 1
		fields++

	return t

/obj/item/paper/proc/burnpaper(obj/item/flame/P,69ob/user)
	var/class = "warning"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose"

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


/obj/item/paper/Topic(href, href_list)
	..()
	if(!usr || (usr.stat || usr.restrained()))
		return

	if(href_list69"write"69)
		if(!config.paper_input)
			to_chat(usr, SPAN_WARNING("No69atter how hard you try to write on \the 69src69,69othing shows up! (Paper input disabled in config.)"))
			return

		var/id = href_list69"write"69
		//var/t = strip_html_simple(input(usr, "What text do you wish to add to " + (id=="end" ? "the end of the paper" : "field "+id) + "?", "69name69",69ull),8192) as69essage

		if(free_space <= 0)
			to_chat(usr, "<span class='info'>There isn't enough space left on \the 69src69 to write anything.</span>")
			return

		var/t =  sanitize(input("Enter what you want to write:", "Write",69ull,69ull) as69essage, free_space, extra = 0)

		if(!t)
			return

		var/obj/item/i = usr.get_active_hand() // Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		var/iscrayon = 0
		if(!istype(i, /obj/item/pen))
			return

		if(istype(i, /obj/item/pen/crayon))
			iscrayon = 1


		// if paper is69ot in usr, then it69ust be69ear them, or in a clipboard or folder, which69ust be in or69ear usr
		if(src.loc != usr && !src.Adjacent(usr) && !((istype(src.loc, /obj/item/clipboard) || istype(src.loc, /obj/item/folder)) && (src.loc.loc == usr || src.loc.Adjacent(usr)) ) )
			return

		var/last_fields_value = fields

		//t = html_encode(t)
		t = replacetext(t, "\n", "<BR>")
		t = parsepencode(t, i, usr, iscrayon) // Encode everything from pencode to html


		if(fields >69AX_FIELDS)//large amount of fields creates a heavy load on the server, see updateinfolinks() and addtofield()
			to_chat(usr, SPAN_WARNING("Too69any fields. Sorry, you can't do this."))
			fields = last_fields_value
			return

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info += t // Oh, he wants to edit to the end of the file, let him.
			updateinfolinks()
		playsound(src,'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg',40,1)
		update_space(t)

		usr << browse("<HTML><meta charset=\"utf-8\"><HEAD><TITLE>69name69</TITLE></HEAD><BODY bgcolor='69color69'>69info_links6969stamps69</BODY></HTML>", "window=69name69") // Update the window

		update_icon()




/obj/item/paper/attackby(obj/item/P as obj,69ob/user as69ob)
	..()

	if(P.has_quality(QUALITY_ADHESIVE))
		return //The tool's afterattack will handle this

	if(istype(P, /obj/item/paper) || istype(P, /obj/item/photo))
		if (istype(P, /obj/item/paper/carbon))
			var/obj/item/paper/carbon/C = P
			if (!C.iscopy && !C.copied)
				to_chat(user, SPAN_NOTICE("Take off the carbon copy first."))
				add_fingerprint(user)
				return
		var/obj/item/paper_bundle/B =69ew(src.loc)
		if (name != "paper")
			B.name =69ame
		else if (P.name != "paper" && P.name != "photo")
			B.name = P.name
		if (user)
			user.drop_from_inventory(P)
			if (ishuman(user))
				var/mob/living/carbon/human/h_user = user
				if (h_user.r_hand == src)
					h_user.drop_from_inventory(src)
					h_user.put_in_r_hand(B)
				else if (h_user.l_hand == src)
					h_user.drop_from_inventory(src)
					h_user.put_in_l_hand(B)
				else if (h_user.l_store == src)
					h_user.drop_from_inventory(src)
					B.loc = h_user
					B.layer = 20
					h_user.l_store = B
					h_user.update_inv_pockets()
				else if (h_user.r_store == src)
					h_user.drop_from_inventory(src)
					B.loc = h_user
					B.layer = 20
					h_user.r_store = B
					h_user.update_inv_pockets()
				else if (h_user.head == src)
					h_user.u_equip(src)
					h_user.put_in_hands(B)
				else if (!istype(src.loc, /turf))
					src.loc = get_turf(h_user)
					if(h_user.client)	h_user.client.screen -= src
					h_user.put_in_hands(B)
			to_chat(user, SPAN_NOTICE("You clip the 69P.name69 to 69(src.name == "paper") ? "the paper" : src.name69."))
		src.loc = B
		P.loc = B

		B.pages.Add(src)
		B.pages.Add(P)
		B.update_icon()
		return B

	else if(istype(P, /obj/item/pen))
		if(crumpled)
			to_chat(usr, SPAN_WARNING("\The 69src69 is too crumpled to write on."))
			return

		var/obj/item/pen/robopen/RP = P
		if ( istype(RP) && RP.mode == 2 )
			RP.RenamePaper(user,src)
		else
			user << browse("<HTML><meta charset=\"utf-8\"><HEAD><TITLE>69name69</TITLE></HEAD><BODY bgcolor='69color69'>69info_links6969stamps69</BODY></HTML>", "window=69name69")
		return

	else if(istype(P, /obj/item/stamp))
		if((!in_range(src, usr) && loc != user && !( istype(loc, /obj/item/clipboard) ) && loc.loc != user && user.get_active_hand() != P))
			return
		playsound(src,'sound/effects/Stamp.ogg',40,1)
		stamps += (stamps=="" ? "<HR>" : "<BR>") + "<i>This paper has been stamped with the 69P.name69.</i>"

		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		var/x
		var/y
		if(istype(P, /obj/item/stamp/captain))
			x = rand(-2, 0)
			y = rand(-1, 2)
		else
			x = rand(-2, 2)
			y = rand(-3, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y

		if(!ico)
			ico =69ew
		ico += "paper_69P.icon_state69"
		stampoverlay.icon_state = "paper_69P.icon_state69"

		if(!stamped)
			stamped =69ew
		stamped += P.type
		overlays += stampoverlay

		to_chat(user, SPAN_NOTICE("You stamp the paper with your rubber stamp."))

	else if(istype(P, /obj/item/flame))
		burnpaper(P, user)

	add_fingerprint(user)
	return


/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "paper_crumpled"
	crumpled = TRUE

/obj/item/paper/crumpled/update_icon()
	if (icon_state == "paper_crumpled_bloodied")
		return
	else if (info)
		icon_state = "paper_words_crumpled"
	else
		icon_state = "paper_crumpled"
	return

/obj/item/paper/crumpled/bloody
	icon_state = "paper_crumpled_bloodied"

/obj/item/paper/neopaper
	name = "sheet of odd paper"
	icon_state = "paper_neo"

/obj/item/paper/neopaper/update_icon()
	if(info)
		icon_state = "paper_neo_words"
	else
		icon_state = "paper_neo"
	return

/obj/item/paper/crumpled/neo
	name = "odd paper scrap"
	icon_state = "paper_neo_crumpled"

/obj/item/paper/crumpled/neo/update_icon()
	if (icon_state == "paper_neo_crumpled_bloodied")
		return
	else if (info)
		icon_state = "paper_neo_words_crumpled"
	else
		icon_state = "paper_neo_crumpled"
	return

/obj/item/paper/crumpled/neo/bloody
	icon_state = "paper_neo_crumpled_bloodied" //todo fix sprite
	spawn_blacklisted = TRUE

#undef69AX_FIELDS
