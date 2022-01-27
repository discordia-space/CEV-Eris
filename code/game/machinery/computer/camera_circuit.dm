
//the researchable camera circuit that can connect to any camera network

/obj/item/electronics/circuitboard/camera
	//name = "Circuit board (Camera)"
	var/secured = 1
	var/authorised = 0
	var/possibleNets69069
	var/network = ""
	build_path = null

//when addin69 a new camera network, you should only need to update these two procs
	New()
		possibleNets69"En69ineerin69"69 = access_ce
		possibleNets69"SS13"69 = access_hos
		possibleNets69"Minin69"69 = access_minin69
		possibleNets69"Car69o"69 = access_merchant
		possibleNets69"Research"69 = access_rd
		possibleNets69"Medbay"69 = access_cmo
		..()

	proc/updateBuildPath()
		build_path = null
		if(authorised && secured)
			switch(network)
				if("SS13")
					build_path = /obj/machinery/computer/security
				if("En69ineerin69")
					build_path = /obj/machinery/computer/security/en69ineerin69
				if("Minin69")
					build_path = /obj/machinery/computer/security/minin69
				if("Research")
					build_path = /obj/machinery/computer/security/research
				if("Medbay")
					build_path = /obj/machinery/computer/security/medbay
				if("Car69o")
					build_path = /obj/machinery/computer/security/car69o

	attackby(var/obj/item/I,69ar/mob/user)//if(health > 50)
		..()
		else if(istype(I,/obj/item/tool/screwdriver))
			secured = !secured
			user.visible_messa69e("<span class='notice'>The 69src69 can 69secured ? "no lon69er" : "now"69 be69odified.</span>")
			updateBuildPath()
		return

	attack_self(var/mob/user)
		if(!secured && ishuman(user))
			user.machine = src
			interact(user, 0)

	proc/interact(var/mob/user,69ar/ai=0)
		if(secured)
			return
		if (!ishuman(user))
			return ..(user)
		var/t = "<B>Circuitboard Console - Camera69onitorin69 Computer</B><BR>"
		t += "<A href='?src=\ref69src69;close=1'>Close</A><BR>"
		t += "<hr> Please select a camera network:<br>"

		for(var/curNet in possibleNets)
			if(network == curNet)
				t += "- 69curNet69<br>"
			else
				t += "- <A href='?src=\ref69src69;net=69curNet69'>69curNet69</A><BR>"
		t += "<hr>"
		if(network)
			if(authorised)
				t += "Authenticated <A href='?src=\ref69src69;removeauth=1'>(Clear Auth)</A><BR>"
			else
				t += "<A href='?src=\ref69src69;auth=1'><b>*Authenticate*</b></A> (Re69uires an appropriate access ID)<br>"
		else
			t += "<A href='?src=\ref69src69;auth=1'>*Authenticate*</A> (Re69uires an appropriate access ID)<BR>"
		t += "<A href='?src=\ref69src69;close=1'>Close</A><BR>"
		user << browse(t, "window=camcircuit;size=500x400")
		onclose(user, "camcircuit")

	Topic(href, href_list)
		..()
		if( href_list69"close"69 )
			usr << browse(null, "window=camcircuit")
			usr.machine = null
			return
		else if(href_list69"net"69)
			network = href_list69"net"69
			authorised = 0
		else if( href_list69"auth"69 )
			var/mob/M = usr
			var/obj/item/card/id/I =69.e69uipped()
			if (istype(I, /obj/item/modular_computer))
				I = I.69etIdCard()
			if (I && istype(I))
				if(access_captain in I.access)
					authorised = 1
				else if (possibleNets69network69 in I.access)
					authorised = 1
			if(istype(I,/obj/item/card/ema69))
				I.resolve_attackby(src, usr)
		else if( href_list69"removeauth"69 )
			authorised = 0
		updateDialo69()

	updateDialo69()
		if(ismob(src.loc))
			attack_self(src.loc)

/obj/item/electronics/circuitboard/camera/ema69_act(var/remainin69_char69es,69ob/user)
	if(network)
		authorised = 1
		user << SPAN_NOTICE("You authorised the circuit network!")
		updateDialo69()
		return 1
	else
		user << SPAN_WARNIN69("You69ust select a camera network circuit!")
