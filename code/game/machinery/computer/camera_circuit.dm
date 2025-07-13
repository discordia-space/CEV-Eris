
//the researchable camera circuit that can connect to any camera network

/obj/item/electronics/circuitboard/camera
	//name = "Circuit board (Camera)"
	var/secured = 1
	var/authorised = 0
	var/possibleNets[0]
	var/network = ""
	build_path = null

//when adding a new camera network, you should only need to update these two procs
/obj/item/electronics/circuitboard/camera/New()
	possibleNets["Engineering"] = access_ce
	possibleNets["SS13"] = access_hos
	possibleNets["Mining"] = access_mining
	possibleNets["Cargo"] = access_merchant
	possibleNets["Research"] = access_rd
	possibleNets["Medbay"] = access_cmo
	..()

/obj/item/electronics/circuitboard/camera/proc/updateBuildPath()
	build_path = null
	if(authorised && secured)
		switch(network)
			if("SS13")
				build_path = /obj/machinery/computer/security
			if("Engineering")
				build_path = /obj/machinery/computer/security/engineering
			if("Mining")
				build_path = /obj/machinery/computer/security/mining
			if("Research")
				build_path = /obj/machinery/computer/security/research
			if("Medbay")
				build_path = /obj/machinery/computer/security/medbay
			if("Cargo")
				build_path = /obj/machinery/computer/security/cargo

/obj/item/electronics/circuitboard/camera/attackby(obj/item/I, mob/user)//if(health > 50)
	..()
	else if(istype(I,/obj/item/tool/screwdriver))
		secured = !secured
		user.visible_message(span_notice("The [src] can [secured ? "no longer" : "now"] be modified."))
		updateBuildPath()
	return

/obj/item/electronics/circuitboard/camera/attack_self(mob/user)
	if(!secured && ishuman(user))
		user.machine = src
		interact(user, 0)

/obj/item/electronics/circuitboard/camera/proc/interact(mob/user, ai=0)
	if(secured)
		return
	if (!ishuman(user))
		return ..(user)
	var/t = "<B>Circuitboard Console - Camera Monitoring Computer</B><BR>"
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"
	t += "<hr> Please select a camera network:<br>"

	for(var/curNet in possibleNets)
		if(network == curNet)
			t += "- [curNet]<br>"
		else
			t += "- <A href='byond://?src=\ref[src];net=[curNet]'>[curNet]</A><BR>"
	t += "<hr>"
	if(network)
		if(authorised)
			t += "Authenticated <A href='byond://?src=\ref[src];removeauth=1'>(Clear Auth)</A><BR>"
		else
			t += "<A href='byond://?src=\ref[src];auth=1'><b>*Authenticate*</b></A> (Requires an appropriate access ID)<br>"
	else
		t += "<A href='byond://?src=\ref[src];auth=1'>*Authenticate*</A> (Requires an appropriate access ID)<BR>"
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"
	user << browse(HTML_SKELETON(dat), "window=camcircuit;size=500x400")
	onclose(user, "camcircuit")

/obj/item/electronics/circuitboard/camera/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=camcircuit")
		usr.machine = null
		return
	else if(href_list["net"])
		network = href_list["net"]
		authorised = 0
	else if( href_list["auth"] )
		var/mob/M = usr
		var/obj/item/card/id/I = M.equipped()
		if (istype(I, /obj/item/modular_computer))
			I = I.GetIdCard()
		if (I && istype(I))
			if(access_captain in I.access)
				authorised = 1
			else if (possibleNets[network] in I.access)
				authorised = 1
		if(istype(I,/obj/item/card/emag))
			I.resolve_attackby(src, usr)
	else if( href_list["removeauth"] )
		authorised = 0
	updateDialog()

/obj/item/electronics/circuitboard/camera/updateDialog()
	if(ismob(src.loc))
		attack_self(src.loc)

/obj/item/electronics/circuitboard/camera/emag_act(remaining_charges, mob/user)
	if(network)
		authorised = 1
		user << span_notice("You authorised the circuit network!")
		updateDialog()
		return 1
	else
		user << span_warning("You must select a camera network circuit!")
