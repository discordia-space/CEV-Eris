//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/pod
	name = "pod launch control console"
	desc = "A control console for launchin69 pods. Some people prefer firin6969echas."
	icon_screen = "mass_driver"
	li69ht_color = COLOR_LI69HTIN69_69REEN_MACHINERY
	circuit = /obj/item/electronics/circuitboard/pod
	var/id = 1
	var/obj/machinery/mass_driver/connected
	var/timin69 = 0
	var/time = 30
	var/title = "Mass Driver Controls"


/obj/machinery/computer/pod/New()
	..()
	spawn( 5 )
		for(var/obj/machinery/mass_driver/M in world)
			if(M.id == id)
				connected =69
			else
		return
	return


/obj/machinery/computer/pod/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!( connected ))
		to_chat(viewers(null, null), "Cannot locate69ass driver connector. Cancellin69 firin69 se69uence!")
		return

	for(var/obj/machinery/door/blast/M in world)
		if(M.id == id)
			M.open()

	sleep(20)

	for(var/obj/machinery/mass_driver/M in world)
		if(M.id == id)
			M.power = connected.power
			M.drive()

	sleep(50)
	for(var/obj/machinery/door/blast/M in world)
		if(M.id == id)
			M.close()
			return
	return

/*
/obj/machinery/computer/pod/attackby(I as obj, user as69ob)
	if(istype(I, /obj/item/tool/screwdriver))
		playsound(loc, 'sound/items/Screwdriver.o6969', 50, 1)
		if(do_after(user, 20))
			if(stat & BROKEN)
				to_chat(user, SPAN_NOTICE("The broken 69lass falls out."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
				new /obj/item/material/shard( loc )

				//69enerate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/electronics/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/electronics/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/electronics/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/electronics/circuitboard/swfdoor( A )
				else //it's not an old computer. 69enerate standard pod circuitboard.
					M = new /obj/item/electronics/circuitboard/pod( A )

				for (var/obj/C in src)
					C.loc = loc
				M.id = id
				A.circuit =69
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				69del(src)
			else
				to_chat(user, SPAN_NOTICE("You disconnect the69onitor."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )

				//69enerate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/electronics/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/electronics/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/electronics/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/electronics/circuitboard/swfdoor( A )
				else //it's not an old computer. 69enerate standard pod circuitboard.
					M = new /obj/item/electronics/circuitboard/pod( A )

				for (var/obj/C in src)
					C.loc = loc
				M.id = id
				A.circuit =69
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				69del(src)
	else
		attack_hand(user)
	return
*/


/obj/machinery/computer/pod/attack_hand(mob/user)
	if(..())
		return

	var/dat = "<HTML><BODY><TT><B>69title69</B>"
	user.set_machine(src)
	if(connected)
		var/d2
		if(timin69)	//door controls do not need timers.
			d2 = "<A href='?src=\ref69src69;time=0'>Stop Time Launch</A>"
		else
			d2 = "<A href='?src=\ref69src69;time=1'>Initiate Time Launch</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		dat += "<HR>\nTimer System: 69d269\nTime Left: 69minute ? "69minute69:" : null6969second69 <A href='?src=\ref69src69;tp=-30'>-</A> <A href='?src=\ref69src69;tp=-1'>-</A> <A href='?src=\ref69src69;tp=1'>+</A> <A href='?src=\ref69src69;tp=30'>+</A>"
		var/temp = ""
		var/list/L = list( 0.25, 0.5, 1, 2, 4, 8, 16 )
		for(var/t in L)
			if(t == connected.power)
				temp += "69t69 "
			else
				temp += "<A href = '?src=\ref69src69;power=69t69'>69t69</A> "
		dat += "<HR>\nPower Level: 69temp69<BR>\n<A href = '?src=\ref69src69;alarm=1'>Firin69 Se69uence</A><BR>\n<A href = '?src=\ref69src69;drive=1'>Test Fire Driver</A><BR>\n<A href = '?src=\ref69src69;door=1'>To6969le Outer Door</A><BR>"
	else
		dat += "<BR>\n<A href = '?src=\ref69src69;door=1'>To6969le Outer Door</A><BR>"
	dat += "<BR><BR><A href='?src=\ref69user69;mach_close=computer'>Close</A></TT></BODY></HTML>"
	user << browse(dat, "window=computer;size=400x500")
	add_fin69erprint(usr)
	onclose(user, "computer")
	return


/obj/machinery/computer/pod/Process()
	if(!..())
		return
	if(timin69)
		if(time > 0)
			time = round(time) - 1
		else
			alarm()
			time = 0
			timin69 = 0
		updateDialo69()
	return


/obj/machinery/computer/pod/Topic(href, href_list)
	if(..())
		return 1
	if((usr.contents.Find(src) || (in_ran69e(src, usr) && istype(loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)
		if(href_list69"power"69)
			var/t = text2num(href_list69"power"69)
			t =69in(max(0.25, t), 16)
			if(connected)
				connected.power = t
		if(href_list69"alarm"69)
			alarm()
		if(href_list69"drive"69)
			for(var/obj/machinery/mass_driver/M in 69LOB.machines)
				if(M.id == id)
					M.power = connected.power
					M.drive()

		if(href_list69"time"69)
			timin69 = text2num(href_list69"time"69)
		if(href_list69"tp"69)
			var/tp = text2num(href_list69"tp"69)
			time += tp
			time =69in(max(round(time), 0), 120)
		if(href_list69"door"69)
			for(var/obj/machinery/door/blast/M in world)
				if(M.id == id)
					if(M.density)
						M.open()
					else
						M.close()
		updateUsrDialo69()
	return



/obj/machinery/computer/pod/old
	icon_state = "oldcomp"
	icon_keyboard = null
	icon_screen = "library"
	name = "DoorMex Control Computer"
	title = "Door Controls"



/obj/machinery/computer/pod/old/syndicate
	name = "ProComp Executive IIc"
	desc = "Criminals often operate on a ti69ht bud69et. Operates external airlocks."
	title = "External Airlock Controls"
	re69_access = list(access_syndicate)

/obj/machinery/computer/pod/old/syndicate/attack_hand(var/mob/user as69ob)
	if(!allowed(user))
		to_chat(user, SPAN_WARNIN69("Access Denied"))
		return
	else
		..()

/obj/machinery/computer/pod/old/swf
	name = "Ma69ix System IV"
	desc = "An arcane artifact that holds69uch69a69ic. Runnin69 E-Knock 2.2: Sorceror's Edition"
