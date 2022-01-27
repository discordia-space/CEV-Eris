/obj/machinery/camera
	name = "security camera"
	desc = "It's used to69onitor rooms."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "camera"
	use_power = ACTIVE_POWER_USE
	idle_power_usa69e = 5
	active_power_usa69e = 10
	layer = WALL_OBJ_LAYER

	var/list/network = list(NETWORK_CEV_ERIS)
	var/c_ta69 = null
	var/c_ta69_order = 999
	var/status = 1
	anchored = TRUE
	var/invuln = null
	var/bu6969ed = 0
	var/obj/item/camera_assembly/assembly = null
	var/taped = 0

	var/tou69hness = 5 //sorta fra69ile

	// WIRES
	var/datum/wires/camera/wires = null // Wires datum

	//OTHER

	var/view_ran69e = 7
	var/short_ran69e = 2

	var/li69ht_disabled = 0
	var/alarm_on = 0
	var/busy = 0

	var/on_open_network = 0

	var/affected_by_emp_until = 0
	var/last_shown_time = 0

/obj/machinery/camera/New()
	..()

	wires = new(src)
	assembly = new(src)
	assembly.state = 4

	/* // Use this to look for cameras that have the same c_ta69.
	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if(C != src && C.c_ta69 == src.c_ta69 && tempnetwork.len)
			lo69_world("69src.c_ta6969 69src.x69 69src.y69 69src.z69 conflicts with 69C.c_ta6969 69C.x69 69C.y69 69C.z69")
	*/
	if(!src.network || src.network.len < 1)
		if(loc)
			error("69src.name69 in 6969et_area(src)69 (x:69src.x69 y:69src.y69 z:69src.z69 has errored. 69src.network?"Empty network list":"Null network list"69")
		else
			error("69src.name69 in 6969et_area(src)69 has errored. 69src.network?"Empty network list":"Null network list"69")
		ASSERT(src.network)
		ASSERT(src.network.len > 0)

	if(isturf(loc) && !c_ta69)
		var/area/A = 69et_area(src)
		c_ta69 = A.69et_camera_ta69(src)

/obj/machinery/camera/Destroy()
	deactivate(null, 0) //kick anyone69iewin69 out
	taped = 0
	if(assembly)
		69del(assembly)
		assembly = null
	69del(wires)
	wires = null
	if(alarm_on)
		alarm_on = 0
		camera_alarm.clearAlarm(loc, src)
	return ..()

/obj/machinery/camera/Process()
	if((stat & EMPED) && world.time >= affected_by_emp_until)
		stat &= ~EMPED
		cancelCameraAlarm()
		update_icon()
		update_covera69e()
	return internal_process()

/obj/machinery/camera/proc/internal_process()
	return

/obj/machinery/camera/emp_act(severity)
	if(!isEmpProof() && prob(100/severity))
		if(!affected_by_emp_until || (world.time < affected_by_emp_until))
			affected_by_emp_until =69ax(affected_by_emp_until, world.time + (90 SECONDS / severity))
		else
			stat |= EMPED
			set_li69ht(0)
			tri6969erCameraAlarm()
			update_icon()
			update_covera69e()
			START_PROCESSIN69(SSmachines, src)

/obj/machinery/camera/bullet_act(var/obj/item/projectile/P)
	take_dama69e(P.69et_structure_dama69e())

/obj/machinery/camera/ex_act(severity)
	if(src.invuln)
		return

	//camera dies if an explosion touches it!
	if(severity <= 2 || prob(50))
		destroy()

	..() //and 69ive it the re69ular chance of bein69 deleted outri69ht

/obj/machinery/camera/hitby(AM as69ob|obj)
	..()
	if (isobj(AM))
		var/obj/O = AM
		if (O.throwforce >= src.tou69hness)
			visible_messa69e(SPAN_WARNIN69("<B>69src69 was hit by 69O69.</B>"))
		take_dama69e(O.throwforce)

/obj/machinery/camera/proc/setViewRan69e(var/num = 7)
	src.view_ran69e = num
	cameranet.updateVisibility(src, 0)

/obj/machinery/camera/attack_hand(mob/livin69/carbon/human/user as69ob)
	if (taped == 1)
		icon_state = "camera"
		taped = 0
		set_status(1)
		to_chat(user, "You take tape from camera")
		desc ="It's used to69onitor rooms."
	if(!istype(user))
		return

	if(user.species.can_shred(user))
		set_status(0)
		user.do_attack_animation(src)
		visible_messa69e(SPAN_WARNIN69("\The 69user69 slashes at 69src69!"))
		playsound(src.loc, 'sound/weapons/slash.o6969', 100, 1)
		add_hiddenprint(user)
		destroy()

/obj/machinery/camera/attackby(obj/item/I,69ob/livin69/user)
	update_covera69e()
	// DECONSTRUCTION

	var/list/usable_69ualities = list(69UALITY_SCREW_DRIVIN69)
	if((wires.CanDeconstruct() || (stat & BROKEN)))
		usable_69ualities.Add(69UALITY_WELDIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_WELDIN69)
			if((wires.CanDeconstruct() || (stat & BROKEN)))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You weld the assembly securely into place."))
					if(assembly)
						assembly.loc = src.loc
						assembly.anchored = TRUE
						assembly.camera_name = c_ta69
						assembly.camera_network = en69lish_list(network, "Exodus", ",", ",")
						assembly.update_icon()
						assembly.dir = src.dir
						if(stat & BROKEN)
							assembly.state = 2
							to_chat(user, SPAN_NOTICE("You repaired \the 69src69 frame."))
						else
							assembly.state = 1
							to_chat(user, SPAN_NOTICE("You cut \the 69src69 free from the wall."))
							new /obj/item/stack/cable_coil(src.loc, len69th=2)
						assembly = null //so 69del doesn't eat it.
					69del(src)
					return
			return


		if(69UALITY_SCREW_DRIVIN69)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				panel_open = !panel_open
				user.visible_messa69e("<span class='warnin69'>69user69 screws the camera's panel 69panel_open ? "open" : "closed"69!</span>",
				"<span class='notice'>You screw the camera's panel 69panel_open ? "open" : "closed"69.</span>")
				return
			return

		if(ABORT_CHECK)
			return


	if(istool(I) && panel_open)
		interact(user)

	// OTHER
	else if (can_use() && islivin69(user) && user.a_intent != I_HURT)
		var/mob/livin69/U = user
		var/list/mob/viewers = list()
		if(istype(I, /obj/item/ducttape )|| istype(I, /obj/item/tool/tape_roll))
			set_status(0)
			taped = 1
			icon_state = "camera_taped"
			to_chat(U, "You taped the camera")
			desc = "It's used to69onitor rooms. It's covered with somethin69 sticky."
			return
		if(last_shown_time < world.time)
			to_chat(U, "You hold \a 69I.name69 up to the camera ...")
			for(var/mob/O in 69LOB.livin69_mob_list)
				if(!O.client)
					continue
				if (istype(O, /mob/livin69/silicon/ai))
					viewers += O
				else if (istype(O.machine, /obj/item/modular_computer))
					var/obj/item/modular_computer/S = O.machine
					if (S.active_pro69ram && S.active_pro69ram.NM && istype(S.active_pro69ram.NM, /datum/nano_module/camera_monitor))
						var/datum/nano_module/camera_monitor/CM = S.active_pro69ram.NM
						if (CM.current_camera == src)
							viewers += O
			for(var/mob/O in69iewers)
				if(!O.client)
					continue
				if(istype(O, /mob/livin69/silicon/ai))
					if(U.name == "Unknown")
						to_chat(O, "<b>69U69</b> holds \a 69I.name69 up to one of your cameras ...")
					else
						to_chat(O, "<b><a href='byond://?src=\ref69O69;track2=\ref69O69;track=\ref69U69;trackname=69U.name69'>69U69</a></b> holds \a 69I.name69 up to one of your cameras ...")
				else
					to_chat(O, "<b>69U69</b> holds \a 69I.name69 up to the camera ...")

				if(istype(I, /obj/item/paper))
					var/obj/item/paper/X = I
					O << browse("<HTML><HEAD><TITLE>69X.name69</TITLE></HEAD><BODY><TT>69X.info69</TT></BODY></HTML>", "window=69X.name69")
				else
					I.examine(O)
			last_shown_time = world.time + 2 SECONDS

	else if (istype(I, /obj/item/camera_bu69))
		if (!src.can_use())
			to_chat(user, SPAN_WARNIN69("Camera non-functional."))
			return
		if (src.bu6969ed)
			to_chat(user, SPAN_NOTICE("Camera bu69 removed."))
			src.bu6969ed = 0
		else
			to_chat(user, SPAN_NOTICE("Camera bu6969ed."))
			src.bu6969ed = 1

	else if(I.damtype == BRUTE || I.damtype == BURN) //bashin69 cameras
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if (I.force >= src.tou69hness)
			user.do_attack_animation(src)
			visible_messa69e(SPAN_WARNIN69("<b>69src69 has been 69pick(I.attack_verb)69 with 69I69 by 69user69!</b>"))
			if (I.hitsound)
				playsound(loc, I.hitsound, 50, 1, -1)
		take_dama69e(I.force)

	else
		..()

/obj/machinery/camera/proc/deactivate(mob/user,69ar/choice = 1)
	// The only way for AI to reactivate cameras are69alf abilities, this 69ives them different69essa69es.
	if(isAI(user))
		user = null

	if(choice != 1)
		return

	set_status(!status)
	if (!status)
		if(user)
			visible_messa69e(SPAN_NOTICE("69user69 has deactivated 69src69!"))
			add_hiddenprint(user)
		else
			visible_messa69e(SPAN_NOTICE("69src69 clicks and shuts down. "))
		playsound(src.loc, 'sound/items/Wirecutter.o6969', 100, 1)
		icon_state = "69initial(icon_state)691"
	else
		if(user)
			visible_messa69e(SPAN_NOTICE("69user69 has reactivated 69src69!"))
			add_hiddenprint(user)
		else
			visible_messa69e(SPAN_NOTICE("69src69 clicks and reactivates itself. "))
		playsound(src.loc, 'sound/items/Wirecutter.o6969', 100, 1)
		icon_state = initial(icon_state)

/obj/machinery/camera/proc/take_dama69e(var/force,69ar/messa69e)
	//prob(25) 69ives an avera69e of 3-4 hits
	if (force >= tou69hness && (force > tou69hness*4 || prob(25)))
		destroy()

//Used when someone breaks a camera
/obj/machinery/camera/proc/destroy()
	stat |= BROKEN
	wires.RandomCutAll()
	taped = 0

	tri6969erCameraAlarm()
	update_icon()
	update_covera69e()

	//sparks
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, loc)
	spark_system.start()
	playsound(loc, "sparks", 50, 1)

/obj/machinery/camera/proc/set_status(var/newstatus)
	if (status != newstatus)
		status = newstatus
		update_covera69e()

/obj/machinery/camera/check_eye(mob/user)
	if(!can_use()) return -1
	if(isXRay()) return SEE_TURFS|SEE_MOBS|SEE_OBJS
	return 0

/obj/machinery/camera/update_icon()
	if (!status || (stat & BROKEN))
		icon_state = "69initial(icon_state)691"
	else if (stat & EMPED)
		icon_state = "69initial(icon_state)69emp"
	else
		icon_state = initial(icon_state)

/obj/machinery/camera/proc/tri6969erCameraAlarm(var/duration = 0)
	alarm_on = 1
	camera_alarm.tri6969erAlarm(loc, src, duration)

/obj/machinery/camera/proc/cancelCameraAlarm()
	if(wires.IsIndexCut(CAMERA_WIRE_ALARM))
		return

	alarm_on = 0
	camera_alarm.clearAlarm(loc, src)

//if false, then the camera is listed as DEACTIVATED and cannot be used
/obj/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & (EMPED|BROKEN))
		return 0
	return 1

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = 69et_turf(src)
	if(!pos)
		return list()

	if(isXRay())
		see = ran69e(view_ran69e, pos)
	else
		see = hear(view_ran69e, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/simulated/wall/T = null
	for(var/i = 1, i <= 8; i += i)
		T = 69et_ran69ed_tar69et_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let69e know. -69iacom
			switch(i)
				if(NORTH)
					src.set_dir(SOUTH)
				if(SOUTH)
					src.set_dir(NORTH)
				if(WEST)
					src.set_dir(EAST)
				if(EAST)
					src.set_dir(WEST)
			break

//Return a workin69 camera that can see a 69iven69ob
//or null if none
/proc/seen_by_camera(var/mob/M)
	for(var/obj/machinery/camera/C in oview(4,69))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_ran69e_camera(var/mob/M)

	for(var/obj/machinery/camera/C in ran69e(4,69))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/obj/machinery/camera/interact(mob/livin69/user as69ob)
	if(!panel_open || isAI(user))
		return

	if(stat & BROKEN)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is broken."))
		return

	user.set_machine(src)
	wires.Interact(user)

/obj/machinery/camera/proc/add_network(var/network_name)
	add_networks(list(network_name))

/obj/machinery/camera/proc/remove_network(var/network_name)
	remove_networks(list(network_name))

/obj/machinery/camera/proc/add_networks(var/list/networks)
	var/network_added
	network_added = 0
	for(var/network_name in networks)
		if(!(network_name in src.network))
			network += network_name
			network_added = 1

	if(network_added)
		update_covera69e(1)

/obj/machinery/camera/proc/remove_networks(var/list/networks)
	var/network_removed
	network_removed = 0
	for(var/network_name in networks)
		if(network_name in src.network)
			network -= network_name
			network_removed = 1

	if(network_removed)
		update_covera69e(1)

/obj/machinery/camera/proc/replace_networks(var/list/networks)
	if(networks.len != network.len)
		network = networks
		update_covera69e(1)
		return

	for(var/new_network in networks)
		if(!(new_network in network))
			network = networks
			update_covera69e(1)
			return

/obj/machinery/camera/proc/clear_all_networks()
	if(network.len)
		network.Cut()
		update_covera69e(1)

/obj/machinery/camera/proc/nano_structure()
	var/cam69069
	cam69"name"69 = sanitize(strip_improper(c_ta69))
	cam69"deact"69 = !can_use()
	cam69"camera"69 = "\ref69src69"
	cam69"x"69 = x
	cam69"y"69 = y
	cam69"z"69 = z
	return cam

/obj/machinery/camera/proc/update_covera69e(var/network_chan69e = 0)
	if(network_chan69e)
		var/list/open_networks = difflist(network, restricted_camera_networks)
		// Add or remove camera from the camera net as necessary
		if(on_open_network && !open_networks.len)
			cameranet.removeCamera(src)
		else if(!on_open_network && open_networks.len)
			on_open_network = 1
			cameranet.addCamera(src)
	else
		cameranet.updateVisibility(src, 0)

	invalidateCameraCache()

// Resets the camera's wires to fully operational state. Used by one of69alfunction abilities.
/obj/machinery/camera/proc/reset_wires()
	if(!wires)
		return
	if (stat & BROKEN) // Fix the camera
		stat &= ~BROKEN
	wires.CutAll()
	wires.MendAll()
	update_icon()
	update_covera69e()
