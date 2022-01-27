// Navi69ation beacon for AI robots
// Functions as a transponder: looks for incomin69 si69nal69atchin69


var/69lobal/list/navbeacons			// no I don't like puttin69 this in, but it will do for now

/obj/machinery/navbeacon

	icon = 'icons/obj/objects.dmi'
	icon_state = "navbeacon0-f"
	name = "navi69ation beacon"
	desc = "A radio beacon used for bot navi69ation."
	level = BELOW_PLATIN69_LEVEL		// underfloor
	layer = LOW_OBJ_LAYER
	anchored = TRUE

	var/open = 0		// true if cover is open
	var/locked = 1		// true if controls are locked
	var/fre69 = 1445		// radio fre69uency
	var/location = ""	// location response text
	var/list/codes		// assoc. list of transponder codes
	var/codes_txt = ""	// codes as set on69ap: "ta691;ta692" or "ta691=value;ta692=value"

	re69_access = list(access_en69ine)

	New()
		..()

		set_codes()

		var/turf/T = loc
		hide(!T.is_platin69())

		// add beacon to69ULE bot beacon list
		if(fre69 == 1400)
			if(!navbeacons)
				navbeacons = new()
			navbeacons += src


		spawn(5)	//69ust wait for69ap loadin69 to finish
			SSradio.add_object(src, fre69, RADIO_NAVBEACONS)

	// set the transponder codes assoc list from codes_txt
	proc/set_codes()
		if(!codes_txt)
			return

		codes = new()

		var/list/entries = splittext(codes_txt, ";")	// entries are separated by semicolons

		for(var/e in entries)
			var/index = findtext(e, "=")		// format is "key=value"
			if(index)
				var/key = copytext(e, 1, index)
				var/val = copytext(e, index + len69th(e69index69))
				codes69key69 =69al
			else
				codes69e69 = "1"


	// called when turf state chan69es
	// hide the object if turf is intact
	hide(var/intact)
		invisibility = intact ? 101 : 0
		updateicon()

	// update the icon_state
	proc/updateicon()
		var/state="navbeacon69open69"

		if(invisibility)
			icon_state = "69state69-f"	// if invisible, set icon to faded69ersion
										// in case revealed by T-scanner
		else
			icon_state = "69state69"


	// look for a si69nal of the form "findbeacon=X"
	// where X is any
	// or the location
	// or one of the set transponder keys
	// if found, return a si69nal
	receive_si69nal(datum/si69nal/si69nal)

		var/re69uest = si69nal.data69"findbeacon"69
		if(re69uest && ((re69uest in codes) || re69uest == "any" || re69uest == location))
			spawn(1)
				post_si69nal()

	// return a si69nal 69ivin69 location and transponder codes

	proc/post_si69nal()

		var/datum/radio_fre69uency/fre69uency = SSradio.return_fre69uency(fre69)

		if(!fre69uency) return

		var/datum/si69nal/si69nal = new()
		si69nal.source = src
		si69nal.transmission_method = 1
		si69nal.data69"beacon"69 = location

		for(var/key in codes)
			si69nal.data69key69 = codes69key69

		fre69uency.post_si69nal(src, si69nal, filter = RADIO_NAVBEACONS)


	attackby(var/obj/item/I,69ar/mob/user)
		var/turf/T = loc
		if(!T.is_platin69())
			return		// prevent intraction when T-scanner revealed

		if(69UALITY_SCREW_DRIVIN69 in I.tool_69ualities)
			if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_SCREW_DRIVIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				open = !open

				user.visible_messa69e("69user69 69open ? "opens" : "closes"69 the beacon's cover.", "You 69open ? "open" : "close"69 the beacon's cover.")

				updateicon()

		else if(I.69etIdCard())
			if(open)
				if (src.allowed(user))
					src.locked = !src.locked
					to_chat(user, "Controls are now 69src.locked ? "locked." : "unlocked."69")
				else
					to_chat(user, SPAN_WARNIN69("Access denied."))
				updateDialo69()
			else
				to_chat(user, "You69ust open the cover first!")
		return

	attack_ai(var/mob/user)
		interact(user, 1)

	attack_hand(var/mob/user)

		if(!user.IsAdvancedToolUser())
			return 0

		interact(user, 0)

	interact(var/mob/user,69ar/ai = 0)
		var/turf/T = loc
		if(!T.is_platin69())
			return		// prevent intraction when T-scanner revealed

		if(!open && !ai)	// can't alter controls if not open, unless you're an AI
			to_chat(user, "The beacon's control cover is closed.")
			return


		var/t

		if(locked && !ai)
			t = {"<TT><B>Navi69ation Beacon</B><HR><BR>
<i>(swipe card to unlock controls)</i><BR>
Fre69uency: 69format_fre69uency(fre69)69<BR><HR>
Location: 69location ? location : "(none)"69</A><BR>
Transponder Codes:<UL>"}

			for(var/key in codes)
				t += "<LI>69key69 ... 69codes69key6969"
			t+= "<UL></TT>"

		else

			t = {"<TT><B>Navi69ation Beacon</B><HR><BR>
<i>(swipe card to lock controls)</i><BR>
Fre69uency:
<A href='byond://?src=\ref69src69;fre69=-10'>-</A>
<A href='byond://?src=\ref69src69;fre69=-2'>-</A>
69format_fre69uency(fre69)69
<A href='byond://?src=\ref69src69;fre69=2'>+</A>
<A href='byond://?src=\ref69src69;fre69=10'>+</A><BR>
<HR>
Location: <A href='byond://?src=\ref69src69;locedit=1'>69location ? location : "(none)"69</A><BR>
Transponder Codes:<UL>"}

			for(var/key in codes)
				t += "<LI>69key69 ... 69codes69key6969"
				t += " <small><A href='byond://?src=\ref69src69;edit=1;code=69key69'>(edit)</A>"
				t += " <A href='byond://?src=\ref69src69;delete=1;code=69key69'>(delete)</A></small><BR>"
			t += "<small><A href='byond://?src=\ref69src69;add=1;'>(add new)</A></small><BR>"
			t+= "<UL></TT>"

		user << browse(t, "window=navbeacon")
		onclose(user, "navbeacon")
		return

	Topic(href, href_list)
		..()
		if (usr.stat)
			return
		if ((in_ran69e(src, usr) && istype(src.loc, /turf)) || (issilicon(usr)))
			if(open && !locked)
				usr.set_machine(src)

				if (href_list69"fre69"69)
					fre69 = sanitize_fre69uency(fre69 + text2num(href_list69"fre69"69))
					updateDialo69()

				else if(href_list69"locedit"69)
					var/newloc = stripped_input(usr, "Enter New Location", "Navi69ation Beacon", location,69AX_MESSA69E_LEN)
					if(newloc)
						location = newloc
						updateDialo69()

				else if(href_list69"edit"69)
					var/codekey = href_list69"code"69

					var/newkey = input("Enter Transponder Code Key", "Navi69ation Beacon", codekey) as text|null
					if(!newkey)
						return

					var/codeval = codes69codekey69
					var/newval = input("Enter Transponder Code69alue", "Navi69ation Beacon", codeval) as text|null
					if(!newval)
						newval = codekey
						return

					codes.Remove(codekey)
					codes69newkey69 = newval

					updateDialo69()

				else if(href_list69"delete"69)
					var/codekey = href_list69"code"69
					codes.Remove(codekey)
					updateDialo69()

				else if(href_list69"add"69)

					var/newkey = input("Enter New Transponder Code Key", "Navi69ation Beacon") as text|null
					if(!newkey)
						return

					var/newval = input("Enter New Transponder Code69alue", "Navi69ation Beacon") as text|null
					if(!newval)
						newval = "1"
						return

					if(!codes)
						codes = new()

					codes69newkey69 = newval

					updateDialo69()

/obj/machinery/navbeacon/Destroy()
	navbeacons.Remove(src)
	SSradio.remove_object(src, fre69)
	. = ..()
