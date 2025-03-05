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
		new /obj/item/checker/white(src.loc)

/obj/item/board/examine(mob/user, extra_description = "")
	if(get_dist(user, src) < 2)
		user.set_machine(src)
		interact(user)
	..(user, extra_description)

/obj/item/board/attack_hand(mob/living/carbon/human/M as mob)
	if(M.machine == src)
		..()
	else
		src.examine(M)

obj/item/board/attackby(obj/item/I as obj, mob/user as mob)
	if(!addPiece(I,user))
		..()

/obj/item/board/proc/addPiece(obj/item/I as obj, mob/user as mob, var/tile = 0)
	if(I.w_class != ITEM_SIZE_TINY) //only small stuff
		user.show_message(SPAN_WARNING("\The [I] is too big to be used as a board piece."))
		return 0
	if(num == 64)
		user.show_message(SPAN_WARNING("\The [src] is already full!"))
		return 0
	if(tile > 0 && board["[tile]"])
		user.show_message(SPAN_WARNING("That space is already filled!"))
		return 0
	if(!user.Adjacent(src))
		return 0

	user.drop_from_inventory(I)
	I.forceMove(src)
	num++


	if(!board_icons["[I.icon] [I.icon_state]"])
		board_icons["[I.icon] [I.icon_state]"] = new /icon(I.icon,I.icon_state)

	if(tile == 0)
		var i;
		for(i=0;i<64;i++)
			if(!board["[i]"])
				board["[i]"] = I
				break
	else
		board["[tile]"] = I

	src.updateDialog()

	return 1


/obj/item/board/interact(mob/user as mob)
	if(user.is_physically_disabled() || (!isAI(user) && !user.Adjacent(src))) //can't see if you arent conscious. If you are not an AI you can't see it unless you are next to it, either.
		user << browse(null, "window=boardgame")
		user.unset_machine()
		return

	var/list/dat = list({"
	<html><head><style type='text/css'>
	td,td a{height:25px;width:25px}table{border-spacing:0;border:none;border-collapse:collapse}td{text-align:center;padding:0;background-repeat:no-repeat;background-position:center center}td.light{background-color:#E4E7EA}td.dark{background-color:#848891}td.selected{background-color:#FF8566}td a{display:table-cell;text-decoration:none;position:relative;line-height:27px;height:27px;width:27px;vertical-align:middle}
	</style></head><body><table>
	"})
	var i, stagger
	stagger = 0 //so we can have the checkerboard effect
	for(i=0, i<64, i++)
		if(i%8 == 0)
			dat += "<tr>"
			stagger = !stagger
		if(selected == i)
			dat += "<td class='selected'"
		else if((i + stagger)%2 == 0)
			dat += "<td class='dark'"
		else
			dat += "<td class='light'"
		if(board["[i]"])
			var/obj/item/I = board["[i]"]
			user << browse_rsc(board_icons["[I.icon] [I.icon_state]"],"[I.icon_state].png")
			dat += " style='background-image:url([I.icon_state].png)'>"
		else
			dat+= ">"

		if(!isobserver(user))
			dat += "<a href='?src=\ref[src];select=[i];person=\ref[user]'></a>"
		dat += "</td>"

	dat += "</table>"

	if(selected >= 0 && !isobserver(user))
		dat += "<br><A href='?src=\ref[src];remove=0'>Remove Selected Piece</A>"
	user << browse(jointext(dat, null),"window=boardgame;size=250x250")
	onclose(usr, "boardgame")

/obj/item/board/Topic(href, href_list)
	if(!usr.Adjacent(src))
		usr.unset_machine()
		usr << browse(null, "window=boardgame")
		return

	if(!usr.incapacitated()) //you can't move pieces if you can't move
		if(href_list["select"])
			var/s = href_list["select"]
			var/obj/item/I = board["[s]"]
			if(selected >= 0)
				//check to see if clicked on tile is currently selected one
				if(text2num(s) == selected)
					selected = 0 //deselect it
					return

				if(I) //cant put items on other items.
					return

			//put item in new spot.
				I = board["[selected]"]
				board["[selected]"] = null
				board -= "[selected]"
				board -= null
				board["[s]"] = I
				selected = -1
			else
				if(I)
					selected = text2num(s)
				else
					var/mob/living/carbon/human/H = locate(href_list["person"])
					if(!istype(H))
						return
					var/obj/item/O = H.get_active_hand()
					if(!O)
						return
					addPiece(O,H,text2num(s))
		if(href_list["remove"])
			var/obj/item/I = board["[selected]"]
			board["[selected]"] = null
			board -= "[selected]"
			board -= null
			I.forceMove(src.loc)
			num--
			selected = -1
			var j
			for(j=0;j<64;j++)
				if(board["[j]"])
					var/obj/item/K = board["[j]"]
					if(K.icon == I.icon && cmptext(K.icon_state,I.icon_state))
						src.updateDialog()
						return
			//Didn't find it in use, remove it and allow GC to delete it.
			board_icons["[I.icon] [I.icon_state]"] = null
			board_icons -= "[I.icon] [I.icon_state]"
			board_icons -= null
	src.updateDialog()

/obj/item/checker/
	name = "black checker"
	desc = "It is plastic and shiny."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "checker_black"
	w_class = ITEM_SIZE_TINY

/obj/item/checker/queen
	name = "black checker queen"
	desc = "Two black checkers stacked to form a queen. This one seems to have been glued together..."
	icon_state = "checker_black_queen"

/obj/item/checker/white
	name = "white checker"
	icon_state = "checker_white"

/obj/item/checker/white/queen
	name = "white checker queen"
	desc = "Two white checkers stacked to form a queen. This one seems to have been glued together..."
	icon_state = "checker_white_queen"
