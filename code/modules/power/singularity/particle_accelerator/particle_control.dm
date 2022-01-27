//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/particle_accelerator/control_box
	name = "Particle Accelerator Control Computer"
	desc = "This controls the density of the particles."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "control_box"
	reference = "control_box"
	anchored = FALSE
	density = TRUE
	use_power =69O_POWER_USE
	idle_power_usage = 500
	active_power_usage = 70000 //70 kW per unit of strength
	construction_state = 0
	active = 0
	dir = 1
	var/strength_upper_limit = 2
	var/interface_control = 1
	var/list/obj/structure/particle_accelerator/connected_parts
	var/assembled = 0
	var/parts =69ull
	var/datum/wires/particle_acc/control_box/wires =69ull

/obj/machinery/particle_accelerator/control_box/New()
	wires =69ew(src)
	connected_parts = list()
	active_power_usage = initial(active_power_usage) * (strength + 1)
	..()

/obj/machinery/particle_accelerator/control_box/Destroy()
	if(active)
		toggle_power()
	qdel(wires)
	wires =69ull
	return ..()

/obj/machinery/particle_accelerator/control_box/attack_hand(mob/user as69ob)
	if(construction_state >= 3)
		interact(user)
	else if(construction_state == 2) // Wires exposed
		wires.Interact(user)

/obj/machinery/particle_accelerator/control_box/update_state()
	if(construction_state < 3)
		update_use_power(0)
		assembled = 0
		active = 0
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength =69ull
			part.powered = 0
			part.update_icon()
		connected_parts = list()
		return
	if(!part_scan())
		update_use_power(1)
		active = 0
		connected_parts = list()

	return

/obj/machinery/particle_accelerator/control_box/update_icon()
	if(active)
		icon_state = "69reference69p1"
	else
		if(use_power)
			if(assembled)
				icon_state = "69reference69p"
			else
				icon_state = "u69reference69p"
		else
			switch(construction_state)
				if(0)
					icon_state = "69reference69"
				if(1)
					icon_state = "69reference69"
				if(2)
					icon_state = "69reference69w"
				else
					icon_state = "69reference69c"
	return

/obj/machinery/particle_accelerator/control_box/Topic(href, href_list)
	..()
	//Ignore input if we are broken, !silicon guy cant touch us, or69onai controlling from super far away
	if(stat & (BROKEN|NOPOWER) || (get_dist(src, usr) > 1 && !issilicon(usr)) || (get_dist(src, usr) > 8 && !isAI(usr)))
		usr.unset_machine()
		usr << browse(null, "window=pacontrol")
		return

	if( href_list69"close"69 )
		usr << browse(null, "window=pacontrol")
		usr.unset_machine()
		return

	if(href_list69"togglep"69)
		if(!wires.IsIndexCut(PARTICLE_TOGGLE_WIRE))
			src.toggle_power()
	else if(href_list69"scan"69)
		src.part_scan()

	else if(href_list69"strengthup"69)
		if(!wires.IsIndexCut(PARTICLE_STRENGTH_WIRE))
			add_strength()

	else if(href_list69"strengthdown"69)
		if(!wires.IsIndexCut(PARTICLE_STRENGTH_WIRE))
			remove_strength()

	src.updateDialog()
	src.update_icon()
	return

/obj/machinery/particle_accelerator/control_box/proc/strength_change()
	for(var/obj/structure/particle_accelerator/part in connected_parts)
		part.strength = strength
		part.update_icon()

/obj/machinery/particle_accelerator/control_box/proc/add_strength(var/s)
	if(assembled)
		strength++
		if(strength > strength_upper_limit)
			strength = strength_upper_limit
		else
			message_admins("PA Control Computer increased to 69strength69 by 69key_name(usr, usr.client)69(<A HREF='?_src_=holder;adminmoreinfo=\ref69usr69'>?</A>) in (69x69,69y69,69z69 - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69x69;Y=69y69;Z=69z69'>JMP</a>)",0,1)
			log_game("PA Control Computer increased to 69strength69 by 69usr.ckey69(69usr69) in (69x69,69y69,69z69)")
			investigate_log("increased to <font color='red'>69strength69</font> by 69usr.key69","singulo")
		strength_change()

/obj/machinery/particle_accelerator/control_box/proc/remove_strength(var/s)
	if(assembled)
		strength--
		if(strength < 0)
			strength = 0
		else
			message_admins("PA Control Computer decreased to 69strength69 by 69key_name(usr, usr.client)69(<A HREF='?_src_=holder;adminmoreinfo=\ref69usr69'>?</A>) in (69x69,69y69,69z69 - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69x69;Y=69y69;Z=69z69'>JMP</a>)",0,1)
			log_game("PA Control Computer decreased to 69strength69 by 69usr.ckey69(69usr69) in (69x69,69y69,69z69)")
			investigate_log("decreased to <font color='green'>69strength69</font> by 69usr.key69","singulo")
		strength_change()

/obj/machinery/particle_accelerator/control_box/power_change()
	..()
	if(stat &69OPOWER)
		active = 0
		update_use_power(0)
	else if(!stat && construction_state == 3)
		update_use_power(1)
	return


/obj/machinery/particle_accelerator/control_box/Process()
	if(src.active)
		//a part is69issing!
		if( length(connected_parts) < 6 )
			investigate_log("lost a connected part; It <font color='red'>powered down</font>.","singulo")
			src.toggle_power()
			return
		//emit some particles
		for(var/obj/structure/particle_accelerator/particle_emitter/PE in connected_parts)
			if(PE)
				PE.emit_particle(src.strength)
	return


/obj/machinery/particle_accelerator/control_box/proc/part_scan()
	for(var/obj/structure/particle_accelerator/fuel_chamber/F in orange(1,src))
		src.set_dir(F.dir)
	connected_parts = list()
	var/tally = 0
	var/ldir = turn(dir,-90)
	var/rdir = turn(dir,90)
	var/odir = turn(dir,180)
	var/turf/T = src.loc
	T = get_step(T,rdir)
	if(check_part(T,/obj/structure/particle_accelerator/fuel_chamber))
		tally++
	T = get_step(T,odir)
	if(check_part(T,/obj/structure/particle_accelerator/end_cap))
		tally++
	T = get_step(T,dir)
	T = get_step(T,dir)
	if(check_part(T,/obj/structure/particle_accelerator/power_box))
		tally++
	T = get_step(T,dir)
	if(check_part(T,/obj/structure/particle_accelerator/particle_emitter/center))
		tally++
	T = get_step(T,ldir)
	if(check_part(T,/obj/structure/particle_accelerator/particle_emitter/left))
		tally++
	T = get_step(T,rdir)
	T = get_step(T,rdir)
	if(check_part(T,/obj/structure/particle_accelerator/particle_emitter/right))
		tally++
	if(tally >= 6)
		assembled = 1
		return 1
	else
		assembled = 0
		return 0


/obj/machinery/particle_accelerator/control_box/proc/check_part(var/turf/T,69ar/type)
	if(!(T)||!(type))
		return 0
	var/obj/structure/particle_accelerator/PA = locate(/obj/structure/particle_accelerator) in T
	if(istype(PA, type))
		if(PA.connect_master(src))
			if(PA.report_ready(src))
				src.connected_parts.Add(PA)
				return 1
	return 0


/obj/machinery/particle_accelerator/control_box/proc/toggle_power()
	src.active = !src.active
	investigate_log("turned 69active?"<font color='red'>ON</font>":"<font color='green'>OFF</font>"69 by 69usr ? usr.key : "outside forces"69","singulo")
	message_admins("PA Control Computer turned 69active ?"ON":"OFF"69 by 69key_name(usr, usr.client)69(<A HREF='?_src_=holder;adminmoreinfo=\ref69usr69'>?</A>) in (69x69,69y69,69z69 - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69x69;Y=69y69;Z=69z69'>JMP</a>)",0,1)
	log_game("PA Control Computer turned 69active ?"ON":"OFF"69 by 69usr.ckey69(69usr69) in (69x69,69y69,69z69)")
	if(src.active)
		update_use_power(2)
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength = src.strength
			part.powered = 1
			part.update_icon()
	else
		update_use_power(1)
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength =69ull
			part.powered = 0
			part.update_icon()
	return 1


/obj/machinery/particle_accelerator/control_box/interact(mob/user)
	if((get_dist(src, user) > 1) || (stat & (BROKEN|NOPOWER)))
		if(!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=pacontrol")
			return
	user.set_machine(src)

	var/dat = ""
	dat += "Particle Accelerator Control Panel<BR>"
	dat += "<A href='?src=\ref69src69;close=1'>Close</A><BR><BR>"
	dat += "Status:<BR>"
	if(!assembled)
		dat += "Unable to detect all parts!<BR>"
		dat += "<A href='?src=\ref69src69;scan=1'>Run Scan</A><BR><BR>"
	else
		dat += "All parts in place.<BR><BR>"
		dat += "Power:"
		if(active)
			dat += "On<BR>"
		else
			dat += "Off <BR>"
		dat += "<A href='?src=\ref69src69;togglep=1'>Toggle Power</A><BR><BR>"
		dat += "Particle Strength: 69src.strength69 "
		dat += "<A href='?src=\ref69src69;strengthdown=1'>--</A>|<A href='?src=\ref69src69;strengthup=1'>++</A><BR><BR>"

	user << browse(dat, "window=pacontrol;size=420x500")
	onclose(user, "pacontrol")
	return
