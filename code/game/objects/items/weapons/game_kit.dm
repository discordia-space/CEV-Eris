/*
CONTAINS:
THAT STUPID GAME KIT

*/
/obj/item/game_kit/New()
	src.board_stat = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
	src.selected = "CR"

/obj/item/game_kit/attack_paw(mob/user as69ob)
	return src.attack_hand(user)

/obj/item/game_kit/MouseDrop(mob/user as69ob)
	if (user == usr && !usr.restrained() && !usr.stat && (usr.contents.Find(src) || in_range(src, usr)))
		if (usr.hand)
			if (!usr.l_hand)
				spawn (0)
					src.attack_hand(usr, 1, 1)
		else
			if (!usr.r_hand)
				spawn (0)
					src.attack_hand(usr, 0, 1)

/obj/item/game_kit/proc/update()
	var/dat = text("<CENTER><B>Game Board</B></CENTER><BR><a href='?src=\ref6969;mode=hia'>6969</a> <a href='?src=\ref6969;mode=remove'>remove</a><HR><table width= 256  border= 0  height= 256  cellspacing= 0  cellpadding= 0 >", src, (src.selected ? text("Selected: 6969", src.selected) : "Nothing Selected"), src)
	for (var/y = 1 to 8)
		dat += "<tr>"

		for (var/x = 1 to 8)
			var/color = (y + x) % 2 ? "#ffffff" : "#999999"
			var/piece = copytext(src.board_stat, ((y - 1) * 8 + x) * 2 - 1, ((y - 1) * 8 + x) * 2 + 1)

			dat += "<td>"
			dat += "<td style='background-color:69color69' width=32 height=32>"
			if (piece != "BB")
				dat += "<a href='?src=\ref69src69;s_board=69x69 69y69'><img src='69src.base_url69/board_69piece69.png' width=32 height=32 border=0>"
			else
				dat += "<a href='?src=\ref69src69;s_board=69x69 69y69'><img src='69src.base_url69/board_none.png' width=32 height=32 border=0>"
			dat += "</td>"

		dat += "</tr>"

	dat += "</table><HR><B>Chips:</B><BR>"
	for (var/piece in list("CB", "CR"))
		dat += "<a href='?src=\ref69src69;s_piece=69piece69'><img src='69src.base_url69/board_69piece69.png' width=32 height=32 border=0></a>"

	dat += "<HR><B>Chess pieces:</B><BR>"
	for (var/piece in list("WP", "WK", "W69", "WI", "WN", "WR"))
		dat += "<a href='?src=\ref69src69;s_piece=69piece69'><img src='69src.base_url69/board_69piece69.png' width=32 height=32 border=0></a>"
	dat += "<br>"
	for (var/piece in list("BP", "BK", "B69", "BI", "BN", "BR"))
		dat += "<a href='?src=\ref69src69;s_piece=69piece69'><img src='69src.base_url69/board_69piece69.png' width=32 height=32 border=0></a>"
	src.data = dat

/obj/item/game_kit/attack_ai(mob/user as69ob, unused, flag)
	return src.attack_hand(user, unused, flag)

/obj/item/game_kit/attack_hand(mob/user as69ob, unused, flag)

	if (flag)
		return ..()
	else
		user.machine = src
		if (!( src.data ))
			update()
		user << browse(src.data, "window=game_kit")
		onclose(user, "game_kit")
		return
	return

/obj/item/game_kit/Topic(href, href_list)
	..()
	if ((usr.stat || usr.restrained()))
		return

	if (usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf)))
		if (href_list69"s_piece"69)
			src.selected = href_list69"s_piece"69
		else if (href_list69"mode"69)
			if (href_list69"mode"69 == "remove")
				src.selected = "remove"
			else
				src.selected = null
		else if (href_list69"s_board"69)
			if (!( src.selected ))
				src.selected = href_list69"s_board"69
			else
				var/tx = text2num(copytext(href_list69"s_board"69, 1, 2))
				var/ty = text2num(copytext(href_list69"s_board"69, 3, 4))
				if ((copytext(src.selected, 2, 3) == " " && length(src.selected) == 3))
					var/sx = text2num(copytext(src.selected, 1, 2))
					var/sy = text2num(copytext(src.selected, 3, 4))
					var/place = ((sy - 1) * 8 + sx) * 2 - 1
					src.selected = copytext(src.board_stat, place, place + 2)
					if (place == 1)
						src.board_stat = text("BB6969", copytext(src.board_stat, 3, 129))
					else
						if (place == 127)
							src.board_stat = text("6969BB", copytext(src.board_stat, 1, 127))
						else
							if (place)
								src.board_stat = text("6969BB6969", copytext(src.board_stat, 1, place), copytext(src.board_stat, place + 2, 129))
					place = ((ty - 1) * 8 + tx) * 2 - 1
					if (place == 1)
						src.board_stat = text("69696969", src.selected, copytext(src.board_stat, 3, 129))
					else
						if (place == 127)
							src.board_stat = text("69696969", copytext(src.board_stat, 1, 127), src.selected)
						else
							if (place)
								src.board_stat = text("696969696969", copytext(src.board_stat, 1, place), src.selected, copytext(src.board_stat, place + 2, 129))
					src.selected = null
				else
					if (src.selected == "remove")
						var/place = ((ty - 1) * 8 + tx) * 2 - 1
						if (place == 1)
							src.board_stat = text("BB6969", copytext(src.board_stat, 3, 129))
						else
							if (place == 127)
								src.board_stat = text("6969BB", copytext(src.board_stat, 1, 127))
							else
								if (place)
									src.board_stat = text("6969BB6969", copytext(src.board_stat, 1, place), copytext(src.board_stat, place + 2, 129))
					else
						if (length(src.selected) == 2)
							var/place = ((ty - 1) * 8 + tx) * 2 - 1
							if (place == 1)
								src.board_stat = text("69696969", src.selected, copytext(src.board_stat, 3, 129))
							else
								if (place == 127)
									src.board_stat = text("69696969", copytext(src.board_stat, 1, 127), src.selected)
								else
									if (place)
										src.board_stat = text("696969696969", copytext(src.board_stat, 1, place), src.selected, copytext(src.board_stat, place + 2, 129))
		src.add_fingerprint(usr)
		update()
		for(var/mob/M in69iewers(1, src))
			if ((M.client &&69.machine == src))
				src.attack_hand(M)
