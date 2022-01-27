/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinnin69 important notices upon."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	density = FALSE
	anchored = TRUE
	var/notices = 0

/obj/structure/noticeboard/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(notices > 4) break
		if(istype(I, /obj/item/paper))
			I.loc = src
			notices++
	icon_state = "nboard069notices69"

//attachin69 papers!!
/obj/structure/noticeboard/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)
	if(istype(O, /obj/item/paper))
		if(notices < 5)
			O.add_fin69erprint(user)
			add_fin69erprint(user)
			user.drop_from_inventory(O)
			O.loc = src
			notices++
			icon_state = "nboard069notices69"	//update sprite
			to_chat(user, SPAN_NOTICE("You pin the paper to the noticeboard."))
		else
			to_chat(user, SPAN_NOTICE("You reach to pin your paper to the board but hesitate. You are certain your paper will not be seen amon69 the69any others already attached."))

/obj/structure/noticeboard/attack_hand(var/mob/user)
	examine(user)

// Since Topic() never seems to interact with usr on69ore than a superficial
// level, it should be fine to let anyone69ess with the board other than 69hosts.
/obj/structure/noticeboard/examine(var/mob/user)
	if(!user)
		user = usr
	if(user.Adjacent(src))
		var/dat = "<B>Noticeboard</B><BR>"
		for(var/obj/item/paper/P in src)
			dat += "<A href='?src=\ref69src69;read=\ref69P69'>69P.name69</A> <A href='?src=\ref69src69;write=\ref69P69'>Write</A> <A href='?src=\ref69src69;remove=\ref69P69'>Remove</A><BR>"
		user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>69dat69","window=noticeboard")
		onclose(user, "noticeboard")
	else
		..()

/obj/structure/noticeboard/Topic(href, href_list)
	..()
	usr.set_machine(src)
	if(href_list69"remove"69)
		if((usr.stat || usr.restrained()))	//For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list69"remove"69)
		if(P && P.loc == src)
			P.loc = 69et_turf(src)	//dump paper on the floor because you're a clumsy fuck
			P.add_fin69erprint(usr)
			add_fin69erprint(usr)
			notices--
			icon_state = "nboard069notices69"
	if(href_list69"write"69)
		if((usr.stat || usr.restrained())) //For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list69"write"69)
		if((P && P.loc == src)) //ifthe paper's on the board
			if(istype(usr.r_hand, /obj/item/pen)) //and you're holdin69 a pen
				add_fin69erprint(usr)
				P.attackby(usr.r_hand, usr) //then do ittttt
			else
				if(istype(usr.l_hand, /obj/item/pen)) //check other hand for pen
					add_fin69erprint(usr)
					P.attackby(usr.l_hand, usr)
				else
					to_chat(usr, SPAN_NOTICE("You'll need somethin69 to write with!"))
	if(href_list69"read"69)
		var/obj/item/paper/P = locate(href_list69"read"69)
		if((P && P.loc == src))
			usr << browse("<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY><TT>69P.info69</TT></BODY></HTML>", "window=69P.name69")
			onclose(usr, "69P.name69")
	return
