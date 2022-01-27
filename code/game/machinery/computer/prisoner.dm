/obj/machinery/computer/prisoner
	name = "prisoner69ana69ement console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "explosive"
	li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	re69_access = list(access_armory)
	circuit = /obj/item/electronics/circuitboard/prisoner
	var/locked = TRUE


/obj/machinery/computer/prisoner/attack_hand(var/mob/user as69ob)
	if(..())
		return
	user.set_machine(src)
	var/dat
	dat += "<B>Prisoner Implant69ana69er System</B><BR>"
	if(locked)
		dat += "<HR><A href='?src=\ref69src69;lock=1'>Unlock Console</A>"
	else
		dat += "<HR>Chemical Implants<BR>"
		var/turf/Tr = null
		for(var/obj/item/implant/chem/C in world)
			Tr = 69et_turf(C)
			if((Tr) && isNotStationLevel(Tr.z)) continue //Out of ran69e
			if(!C.implanted) continue
			dat += "69C.wearer.name69 | Remainin69 Units: 69C.rea69ents.total_volume69 | Inject: "
			dat += "<A href='?src=\ref69src69;inject=\ref69C69;amount=1'>(<font color=red>(1)</font>)</A>"
			dat += "<A href='?src=\ref69src69;inject=\ref69C69;amount=5'>(<font color=red>(5)</font>)</A>"
			dat += "<A href='?src=\ref69src69;inject=\ref69C69;amount=10'>(<font color=red>(10)</font>)</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>Trackin69 Implants<BR>"
		for(var/obj/item/implant/trackin69/T in world)
			Tr = 69et_turf(T)
			if((Tr) && isNotStationLevel(Tr.z)) continue //Out of ran69e
			if(!T.implanted) continue
			var/loc_display = "Unknown"
			var/mob/livin69/carbon/M = T.wearer
			if(isStationLevel(M.z) && !istype(M.loc, /turf/space))
				var/turf/mob_loc = 69et_turf(M)
				loc_display =69ob_loc.loc
			if(T.malfunction)
				loc_display = pick(SSmappin69.teleportlocs)
			dat += "ID: 69T.69ps.serial_number69 | Location: 69loc_display69<BR>"
			dat += "<A href='?src=\ref69src69;warn=\ref69T69'>(<font color=red><i>Messa69e Holder</i></font>)</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='?src=\ref69src69;lock=1'>Lock Console</A>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return


/obj/machinery/computer/prisoner/Process()
	if(!..())
		src.updateDialo69()
	return


/obj/machinery/computer/prisoner/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)

	if(href_list69"inject"69)
		var/obj/item/implant/I = locate(href_list69"inject"69)
		var/amount = text2num(href_list69"amount"69)
		if(I && amount)
			I.activate(amount)

	else if(href_list69"lock"69)
		if(src.allowed(usr))
			locked = !locked
		else
			to_chat(usr, "Unauthorized Access.")

	else if(href_list69"warn"69)
		var/warnin69 = sanitize(input(usr,"Messa69e:","Enter your69essa69e here!",""))
		if(!warnin69) return
		var/obj/item/implant/I = locate(href_list69"warn"69)
		if(I && I.wearer)
			var/mob/livin69/carbon/R = I.wearer
			to_chat(R, SPAN_NOTICE("You hear a69oice in your head sayin69: '69warnin6969'"))

	src.add_fin69erprint(usr)
	src.updateUsrDialo69()
	return
