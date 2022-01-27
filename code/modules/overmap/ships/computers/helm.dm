#define69AVIGATION_VIEW_RANGE 10

/obj/machinery/computer/helm
	name = "helm control console"
	icon_state = "computer"
	icon_keyboard = "teleport_key"
	icon_screen = "eris_control"
	light_color = COLOR_LIGHTING_CYAN_MACHINERY
	circuit = /obj/item/electronics/circuitboard/helm
	var/obj/effect/overmap/ship/linked			//connected overmap object
	var/autopilot = 0
	var/manual_control = 0
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 2 //top speed for autopilot

/obj/machinery/computer/helm/Initialize()
	. = ..()
	linked =69ap_sectors69"69z69"69
	get_known_sectors()
	new /obj/effect/overmap_event/movable/comet()

	if (isnull(linked))
		error("There are69o69ap_sectors on 69src69's z.")
		return
	linked.check_link()

/obj/machinery/computer/helm/proc/get_known_sectors()
	var/area/overmap/map = locate() in world
	for(var/obj/effect/overmap/sector/S in69ap)
		if (S.known)
			var/datum/data/record/R =69ew()
			R.fields69"name"69 = S.name_stages69169
			R.fields69"x"69 = S.x
			R.fields69"y"69 = S.y
			known_sectors69S.name_stages6916969 = R

/obj/machinery/computer/helm/Process()
	..()
	if (autopilot && dx && dy)
		var/turf/T = locate(dx,dy,GLOB.maps_data.overmap_z)
		if(linked.loc == T)
			if(linked.is_still())
				autopilot = 0
			else
				linked.decelerate()

		var/brake_path = linked.get_brake_path()

		if((!speedlimit || linked.get_speed() < speedlimit) && get_dist(linked.loc, T) > brake_path)
			linked.accelerate(get_dir(linked.loc, T))
		else
			linked.decelerate()

		return

/obj/machinery/computer/helm/relaymove(var/mob/user, direction)
	if(manual_control && linked)
		linked.relaymove(user,direction)
		return 1

/obj/machinery/computer/helm/check_eye(var/mob/user as69ob)
	if (isAI(user))
		user.unset_machine()
		if (!manual_control)
			user.reset_view(user.eyeobj)
		return 0
	if (!manual_control || (!get_dist(user, src) > 1) || user.blinded || !linked )
		return -1
	return 0

/obj/machinery/computer/helm/attack_hand(mob/user)

	if(..())
		user.unset_machine()
		manual_control = 0
		return

	if(!isAI(user))
		user.set_machine(src)

	if(linked &&69anual_control)
		user.reset_view(linked)
		user.client.view = "692*NAVIGATION_VIEW_RANGE+169x692*NAVIGATION_VIEW_RANGE+169"

	else if(!config.use_overmap && user?.client?.holder)
		// Let the69ew developers know why the helm console is unresponsive
		// (it's disabled by default on local server to69ake it start a bit faster)
		to_chat(user, "NOTE: overmap generation is disabled in server configuration.")
		to_chat(user, "To use overmap,69ake sure that \"config.txt\" file is present in the server config folder and \"USE_OVERMAP\" is uncommented.")

	ui_interact(user)

/obj/machinery/computer/helm/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(!linked)
		return

	var/data69069

	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/sector/current_sector = locate() in T

	data69"sector"69 = current_sector ? current_sector.name : "Deep Space"
	data69"sector_info"69 = current_sector ? current_sector.desc : "Not Available"
	data69"s_x"69 = linked.x
	data69"s_y"69 = linked.y
	data69"dest"69 = dy && dx
	data69"d_x"69 = dx
	data69"d_y"69 = dy
	data69"speedlimit"69 = speedlimit ? speedlimit : "None"
	data69"speed"69 = linked.get_speed()
	data69"accel"69 = linked.get_acceleration()
	data69"heading"69 = linked.get_heading() ? dir2angle(linked.get_heading()) : 0
	data69"autopilot"69 = autopilot
	data69"manual_control"69 =69anual_control
	data69"canburn"69 = linked.can_burn()
	data69"canpulse"69 = linked.can_pulse()
	data69"canscanpoi"69 = linked.can_scan_poi()

	if(linked.get_speed())
		data69"ETAnext"69 = "69round(linked.ETA()/10)69 seconds"
	else
		data69"ETAnext"69 = "N/A"

	var/list/locations69069
	for (var/key in known_sectors)
		var/datum/data/record/R = known_sectors69key69
		var/list/rdata69069
		rdata69"name"69 = R.fields69"name"69
		rdata69"x"69 = R.fields69"x"69
		rdata69"y"69 = R.fields69"y"69
		rdata69"reference"69 = "\ref69R69"
		locations.Add(list(rdata))

	data69"locations"69 = locations

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "helm.tmpl", "69linked.name69 Helm Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/helm/Topic(href, href_list, state)
	if(..())
		return 1

	if (!linked)
		return

	if (href_list69"add"69)
		var/datum/data/record/R =69ew()
		var/sec_name = sanitize(input("Input69aviation entry69ame", "New69avigation entry", "Sector #69known_sectors.len69") as text)
		if(!CanInteract(usr,state))
			return
		if(!sec_name)
			sec_name = "Sector #69known_sectors.len69"
		R.fields69"name"69 = sec_name
		if(sec_name in known_sectors)
			to_chat(usr, "<span class='warning'>Sector with that69ame already exists, please input a different69ame.</span>")
			return
		switch(href_list69"add"69)
			if("current")
				R.fields69"x"69 = linked.x
				R.fields69"y"69 = linked.y
			if("new")
				var/newx = input("Input69ew entry x coordinate", "Coordinate input", linked.x) as69um
				if(!CanInteract(usr,state))
					return
				var/newy = input("Input69ew entry y coordinate", "Coordinate input", linked.y) as69um
				if(!CanInteract(usr,state))
					return
				R.fields69"x"69 = CLAMP(newx, 1, world.maxx)
				R.fields69"y"69 = CLAMP(newy, 1, world.maxy)
		known_sectors69sec_name69 = R

	if (href_list69"remove"69)
		var/datum/data/record/R = locate(href_list69"remove"69)
		if(R)
			known_sectors.Remove(R.fields69"name"69)
			qdel(R)

	if (href_list69"setx"69)
		var/newx = input("Input69ew destiniation x coordinate", "Coordinate input", dx) as69um|null
		if(!CanInteract(usr,state))
			return
		if (newx)
			dx = CLAMP(newx, 1, world.maxx)

	if (href_list69"sety"69)
		var/newy = input("Input69ew destiniation y coordinate", "Coordinate input", dy) as69um|null
		if(!CanInteract(usr,state))
			return
		if (newy)
			dy = CLAMP(newy, 1, world.maxy)

	if (href_list69"x"69 && href_list69"y"69)
		dx = text2num(href_list69"x"69)
		dy = text2num(href_list69"y"69)

	if (href_list69"reset"69)
		dx = 0
		dy = 0

	if (href_list69"speedlimit"69)
		var/newlimit = input("Input69ew speed limit for autopilot (0 to disable)", "Autopilot speed limit", speedlimit) as69um|null
		if(newlimit)
			speedlimit = CLAMP(newlimit, 0, 100)

	if (href_list69"move"69)
		var/ndir = text2num(href_list69"move"69)
		linked.relaymove(usr,69dir)

	if (href_list69"brake"69)
		linked.decelerate()

	if (href_list69"apilot"69)
		autopilot = !autopilot

	if (href_list69"manual"69)
		manual_control = !manual_control
		if(manual_control)
			usr.reset_view(linked)
			usr.client.view = "692*NAVIGATION_VIEW_RANGE+169x692*NAVIGATION_VIEW_RANGE+169"
		else
			if (isAI(usr))
				usr.reset_view(usr.eyeobj)

	if (href_list69"pulse"69)
		linked.pulse()

	if (href_list69"scanpoi"69)
		linked.scan_poi()

	updateUsrDialog()


/obj/machinery/computer/navigation
	name = "navigation console"
	circuit = /obj/item/electronics/circuitboard/nav
	var/viewing = 0
	var/obj/effect/overmap/ship/linked
	icon_keyboard = "generic_key"
	icon_screen = "helm"

/obj/machinery/computer/navigation/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(!linked)
		return

	var/data69069


	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/sector/current_sector = locate() in T

	data69"sector"69 = current_sector ? current_sector.name : "Deep Space"
	data69"sector_info"69 = current_sector ? current_sector.desc : "Not Available"
	data69"s_x"69 = linked.x
	data69"s_y"69 = linked.y
	data69"speed"69 = linked.get_speed()
	data69"accel"69 = linked.get_acceleration()
	data69"heading"69 = linked.get_heading() ? dir2angle(linked.get_heading()) : 0
	data69"viewing"69 =69iewing

	if(linked.get_speed())
		data69"ETAnext"69 = "69round(linked.ETA()/10)69 seconds"
	else
		data69"ETAnext"69 = "N/A"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "nav.tmpl", "69linked.name6969avigation Screen", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/navigation/check_eye(var/mob/user as69ob)
	if (isAI(user))
		user.unset_machine()
		if (!viewing)
			user.reset_view(user.eyeobj)
		return 0
	if (!viewing)
		return -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		viewing = 0
		return -1
	return 0

/obj/machinery/computer/navigation/attack_hand(var/mob/user as69ob)
	if(..())
		user.unset_machine()
		viewing = 0
		return

	if(viewing && linked)
		if (!isAI(user))
			user.set_machine(src)
		user.reset_view(linked)
		user.client.view = "692*NAVIGATION_VIEW_RANGE+169x692*NAVIGATION_VIEW_RANGE+169"

	ui_interact(user)

/obj/machinery/computer/navigation/Topic(href, href_list)
	if(..())
		return 1

	if (!linked)
		return

	if (href_list69"viewing"69)
		viewing = !viewing
		if(viewing)
			usr.reset_view(linked)
			usr.client.view = "692*NAVIGATION_VIEW_RANGE+169x692*NAVIGATION_VIEW_RANGE+169"
		else
			if (isAI(usr))
				usr.reset_view(usr.eyeobj)
		return 1
