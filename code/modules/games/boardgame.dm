/obj/item/board
	name = "board"
	desc = "A standard 12' checkerboard. Well used."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "board"

	var/num = 0
	var/board_icons = list()
	var/board = list()
	var/selected = -1

/obj/item/board/New()
	..()
	var i
	for(i = 0; i < 12; i++)
		new /obj/item/checker(src.loc)
		new /obj/item/checker/red(src.loc)

/obj/item/board/examine(mob/user,69ar/distance = -1)
	if(in_range(user,src))
		user.set_machine(src)
		interact(user)
		return
	..()

/obj/item/board/attack_hand(mob/living/carbon/human/M as69ob)
	if(M.machine == src)
		..()
	else
		src.examine(M)

obj/item/board/attackby(obj/item/I as obj,69ob/user as69ob)
	if(!addPiece(I,user))
		..()

/obj/item/board/proc/addPiece(obj/item/I as obj,69ob/user as69ob,69ar/tile = 0)
	if(I.w_class != ITEM_SIZE_TINY) //only small stuff
		user.show_message(SPAN_WARNING("\The 69I69 is too big to be used as a board piece."))
		return 0
	if(num == 64)
		user.show_message(SPAN_WARNING("\The 69src69 is already full!"))
		return 0
	if(tile > 0 && board69"69tile69"69)
		user.show_message(SPAN_WARNING("That space is already filled!"))
		return 0
	if(!user.Adjacent(src))
		return 0

	user.drop_from_inventory(I)
	I.forceMove(src)
	num++


	if(!board_icons69"69I.icon69 69I.icon_state69"69)
		board_icons69"69I.icon69 69I.icon_state69"69 = new /icon(I.icon,I.icon_state)

	if(tile == 0)
		var i;
		for(i=0;i<64;i++)
			if(!board69"69i69"69)
				board69"69i69"69 = I
				break
	else
		board69"69tile69"69 = I

	src.updateDialog()

	return 1


/obj/item/board/interact(mob/user as69ob)
	if(user.is_physically_disabled() || (!isAI(user) && !user.Adjacent(src))) //can't see if you arent conscious. If you are not an AI you can't see it unless you are next to it, either.
		user << browse(null, "window=boardgame")
		user.unset_machine()
		return

	var/dat = "<HTML>"
	dat += "<table border='0'>"
	var i, stagger
	stagger = 0 //so we can have the checkerboard effect
	for(i=0, i<64, i++)
		if(i%8 == 0)
			dat += "<tr>"
			stagger = !stagger
		dat += "<td align='center' height='50' width='50' bgcolor="
		if(selected == i)
			dat += "'#FF8566'>"
		else if((i + stagger)%2 == 0)
			dat += "'#66CCFF'>"
		else
			dat += "'#252536'>"
		if(!isobserver(user))
			dat += "<A href='?src=\ref69src69;select=69i69;person=\ref69user69' style='display:block;text-decoration:none;'>"
		if(board69"69i69"69)
			var/obj/item/I = board69"69i69"69
			user << browse_rsc(board_icons69"69I.icon69 69I.icon_state69"69,"69I.icon_state69.png")
			dat += "<image src='69I.icon_state69.png' style='border-style: none'>"
		else
			dat += "&nbsp;"

		if(!isobserver(user))
			dat += "</A>"
		dat += "</td>"

	dat += "</table><br>"

	if(selected >= 0 && !isobserver(user))
		dat += "<br><A href='?src=\ref69src69;remove=0'>Remove Selected Piece</A>"
	user << browse(dat,"window=boardgame;size=500x500")
	onclose(usr, "boardgame")

/obj/item/board/Topic(href, href_list)
	if(!usr.Adjacent(src))
		usr.unset_machine()
		usr << browse(null, "window=boardgame")
		return

	if(!usr.incapacitated()) //you can't69ove pieces if you can't69ove
		if(href_list69"select"69)
			var/s = href_list69"select"69
			var/obj/item/I = board69"69s69"69
			if(selected >= 0)
				//check to see if clicked on tile is currently selected one
				if(text2num(s) == selected)
					selected = 0 //deselect it
					return

				if(I) //cant put items on other items.
					return

			//put item in new spot.
				I = board69"69selected69"69
				board69"69selected69"69 = null
				board -= "69selected69"
				board -= null
				board69"69s69"69 = I
				selected = -1
			else
				if(I)
					selected = text2num(s)
				else
					var/mob/living/carbon/human/H = locate(href_list69"person"69)
					if(!istype(H))
						return
					var/obj/item/O = H.get_active_hand()
					if(!O)
						return
					addPiece(O,H,text2num(s))
		if(href_list69"remove"69)
			var/obj/item/I = board69"69selected69"69
			board69"69selected69"69 = null
			board -= "69selected69"
			board -= null
			I.forceMove(src.loc)
			num--
			selected = -1
			var j
			for(j=0;j<64;j++)
				if(board69"69j69"69)
					var/obj/item/K = board69"69j69"69
					if(K.icon == I.icon && cmptext(K.icon_state,I.icon_state))
						src.updateDialog()
						return
			//Didn't find it in use, remove it and allow GC to delete it.
			board_icons69"69I.icon69 69I.icon_state69"69 = null
			board_icons -= "69I.icon69 69I.icon_state69"
			board_icons -= null
	src.updateDialog()

/obj/item/checker/
	name = "black checker"
	desc = "It is plastic and shiny."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "checker_black"
	w_class = ITEM_SIZE_TINY

/obj/item/checker/red
	name = "red checker"
	icon_state = "checker_red"
