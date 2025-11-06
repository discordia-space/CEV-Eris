/obj/machinery/computer/HolodeckControl
	name = "holodeck control console"
	desc = "A computer used to control a nearby holodeck."
	icon_keyboard = "tech_key"
	icon_screen = "holocontrol"

	use_power = IDLE_POWER_USE
	active_power_usage = 10000 //10kW for the scenery + 50W per holoitem

	circuit = /obj/item/electronics/circuitboard/holodeckcontrol

	var/item_power_usage = 50

	var/area/holodeck/linkedholodeck = null
	var/linkedholodeck_area
	var/active = FALSE
	var/list/holographic_objs = list()
	var/list/holographic_mobs = list()
	var/list/obj_buffer = list()
	var/damaged = FALSE
	var/safety_disabled = FALSE
	var/mob/last_to_emag = null
	var/last_change = 0
	var/last_gravity_change = 0
	var/list/supported_programs
	var/list/restricted_programs
	var/lastprogram = "turnoff"

/obj/machinery/computer/HolodeckControl/New()
	..()
	linkedholodeck = locate(linkedholodeck_area)
	linkedholodeck.linked_console = linkedholodeck.linked_console ? linkedholodeck.linked_console : src
	supported_programs = list()
	restricted_programs = list()

/obj/machinery/computer/HolodeckControl/attack_hand(mob/user as mob)
	if(..())
		return 1
	user.set_machine(src)
	var/dat

	dat += "<B>Holodeck Control System</B><BR>"
	dat += "<HR>Current Loaded Programs:<BR>"

	if(!linkedholodeck)
		dat += SPAN_DANGER("Warning: Unable to locate holodeck.<br>")
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	if(!supported_programs.len)
		dat += SPAN_DANGER("Warning: No supported holo-programs loaded.<br>")
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	for(var/prog in supported_programs)
		dat += "<A href='?src=\ref[src];program=[supported_programs[prog]]'>([prog])</A><BR>"

	dat += "<BR>"
	var/togglething = !active
	dat += "<A href='?src=\ref[src];toggle=[togglething]'>(Turn [active ? "Off" : "On"])</A><BR>"

	dat += "<BR>"
	dat += "Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.<BR>"

	if(issilicon(user))
		dat += "<BR>"
		if(safety_disabled)
			if (emagged)
				dat += "<font color=red><b>ERROR</b>: Cannot re-enable Safety Protocols.</font><BR>"
			else
				dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=green>Re-Enable Safety Protocols?</font>)</A><BR>"
		else
			dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=red>Override Safety Protocols?</font>)</A><BR>"

	dat += "<BR>"

	if(safety_disabled)
		for(var/prog in restricted_programs)
			dat += "<A href='?src=\ref[src];program=[restricted_programs[prog]]'>(<font color=red>Begin [prog]</font>)</A><BR>"
			dat += "Ensure the holodeck is empty before testing.<BR>"
			dat += "<BR>"
		dat += "Safety Protocols are <font color=red> DISABLED </font><BR>"
	else
		dat += "Safety Protocols are <font color=green> ENABLED </font><BR>"

	if(linkedholodeck.has_gravity)
		dat += "Gravity is <A href='?src=\ref[src];gravity=1'><font color=green>(ON)</font></A><BR>"
	else
		dat += "Gravity is <A href='?src=\ref[src];gravity=1'><font color=blue>(OFF)</font></A><BR>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/HolodeckControl/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)

	if(!isnull(href_list["toggle"]))
		togglePower(text2num(href_list["toggle"]))

	else if(href_list["program"])
		var/prog = href_list["program"]
		if(prog in holodeck_programs)
			loadProgram(prog)

	else if(href_list["AIoverride"])
		if(!issilicon(usr))
			return

		if(safety_disabled && emagged)
			return //if a contractor has gone through the trouble to emag the thing, let them keep it.

		safety_disabled = !safety_disabled
		update_projections()
		if(safety_disabled)
			message_admins("[key_name_admin(usr)] overrode the holodeck's safeties")
			log_game("[key_name(usr)] overrided the holodeck's safeties")
		else
			message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
			log_game("[key_name(usr)] restored the holodeck's safeties")

	else if(href_list["gravity"])
		toggleGravity(linkedholodeck)

	src.updateUsrDialog()
	return

/obj/machinery/computer/HolodeckControl/emag_act(remaining_charges, mob/user as mob)
	playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
	last_to_emag = user //emag again to change the owner
	if (!emagged)
		emagged = TRUE
		safety_disabled = TRUE
		update_projections()
		to_chat(user, SPAN_NOTICE("You vastly increase projector power and override the safety and security protocols."))
		to_chat(user, "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call [company_name] maintenance and do not use the simulator.")
		log_game("[key_name(usr)] emagged the Holodeck Control Computer")
		src.updateUsrDialog()
		return 1
	else
		..()

/obj/machinery/computer/HolodeckControl/proc/update_projections()
	if (safety_disabled)
		item_power_usage = 250
		for(var/obj/item/holo/esword/H in linkedholodeck)
			H.damtype = BRUTE
	else
		item_power_usage = initial(item_power_usage)
		for(var/obj/item/holo/esword/H in linkedholodeck)
			H.damtype = initial(H.damtype)

	for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
		C.set_safety(!safety_disabled)
		if (last_to_emag)
			C.friends = list(last_to_emag)

//This could all be done better, but it works for now.
/obj/machinery/computer/HolodeckControl/Destroy()
	emergencyShutdown()
	clearbuffer()
	. = ..()

/obj/machinery/computer/HolodeckControl/explosion_act(target_power, explosion_handler/handler)
	emergencyShutdown()
	clearbuffer()
	. = ..()

/obj/machinery/computer/HolodeckControl/power_change()
	var/oldstat
	..()
	if (stat != oldstat && active && (stat & NOPOWER))
		emergencyShutdown()

/obj/machinery/computer/HolodeckControl/Process()
	for(var/item in holographic_objs) // do this first, to make sure people don't take items out when power is down.
		if(!(get_turf(item) in linkedholodeck))
			derez(item, FALSE)

	if (!safety_disabled)
		for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
			if (get_area(C.loc) != linkedholodeck)
				holographic_mobs -= C
				C.derez()

	if(!..())
		return
	if(active)
		use_power(item_power_usage * (holographic_objs.len + holographic_mobs.len))
		if(!checkInteg(linkedholodeck))
			damaged = TRUE
			loadProgram("turnoff", 0)
			clearbuffer()
			active = FALSE
			set_power_use(IDLE_POWER_USE)
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")


			for(var/turf/T in linkedholodeck)
				if(prob(30))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
				T.explosion_act(100, null)
				T.hotspot_expose(1000,500,1)


/datum/holoposition
	var/holx
	var/holy
	var/holz
	var/holotype
	var/datum/weakref/trueobj

/datum/holoposition/proc/setup(obj/refobj)
	holx = refobj.x
	holy = refobj.y
	holz = refobj.z
	holotype = refobj.type
	trueobj = WEAKREF(refobj)

// clears the off-state buffer
/obj/machinery/computer/HolodeckControl/proc/clearbuffer()
	for(var/datum/holoposition/toclear in obj_buffer)
		var/obj/resolved = toclear.trueobj.resolve()
		if(resolved)
			qdel(resolved)
	QDEL_LIST(obj_buffer)

/obj/machinery/computer/HolodeckControl/proc/derez(obj/gone , silent = TRUE, buffer = FALSE)
	if(gone == null)
		to_chat(world, "nullobj")
		return

	holographic_objs.Remove(gone)
	to_chat(world, "gone")
	if(isobj(gone))
		if(buffer)
			var/datum/holoposition/holofile = new()
			holofile.setup(gone)
			obj_buffer.Add(holofile)
		var/mob/M = gone.loc
		if(ismob(M))
			M.remove_from_mob(gone)
			M.update_icons()	//so their overlays update

	if(!silent)
		var/obj/oldobj = gone
		visible_message("The [oldobj.name] fades away!")

	if(buffer)
		gone.forceMove(src) // hide in computer
	else
		qdel(gone)

/obj/machinery/computer/HolodeckControl/proc/checkInteg(area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return 0

	return 1

// why wouldn't toggle toggle?
/obj/machinery/computer/HolodeckControl/proc/togglePower(toggleOn)
	if(toggleOn)
		loadProgram(lastprogram, TRUE, TRUE)
	else
		loadProgram("turnoff", FALSE)


		if(!linkedholodeck.has_gravity)
			linkedholodeck.has_gravity = TRUE
			linkedholodeck.update_gravity()

		active = FALSE
		set_power_use(IDLE_POWER_USE)


/obj/machinery/computer/HolodeckControl/proc/loadProgram(programName, check_delay = TRUE, buffered = FALSE)
	var/datum/holodeck_program/HP = holodeck_programs[programName]
	if(!HP)
		return
	var/area/A = locate(HP.target)
	if(!A)
		return

	if(check_delay)
		if(world.time < (last_change + 25))
			if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
				return
			visible_message(SPAN_DANGER("[src] flashes 'ERROR. Recalibrating projection apparatus.'"), SPAN_WARNING("[src] buzzes."), 3)
			last_change = world.time
			return

	last_change = world.time
	active = TRUE
	set_power_use(ACTIVE_POWER_USE)


	for(var/item in holographic_objs)
		derez(item, TRUE, !buffered)
	if(programName != "turnoff" && !buffered)
		clearbuffer()

	for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
		holographic_mobs -= C
		C.derez()

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		qdel(B)

	holographic_objs = A.copy_contents_to(linkedholodeck , FALSE, buffered)		
	for(var/obj/holo_obj in holographic_objs)
		holo_obj.alpha *= 0.9 //give holodeck objs a slight transparency
		holo_obj.update_plane()

	if(buffered)
		for(var/datum/holoposition/toreturn in obj_buffer)
			var/turf/toplace = locate(toreturn.holx, toreturn.holy, toreturn.holz)
			var/obj/replaced = toreturn.trueobj.resolve()
			if(!toplace)
				toplace = get_turf(src)
			if(!replaced)
				replaced = new toreturn.holotype(toplace)
				replaced.alpha *= 0.9 //give holodeck objs a slight transparency
			else
				replaced.forceMove(toplace)
			holographic_objs.Add(replaced) // we do this after the transparency because we assume it already has it
		QDEL_LIST(obj_buffer) // we just used the entire list, it is no longer necessary
	
	if(HP.ambience)
		linkedholodeck.forced_ambience = HP.ambience
	else
		linkedholodeck.forced_ambience = list()

	for(var/mob/living/M in mobs_in_area(linkedholodeck))
		if(M.mind)
			linkedholodeck.play_ambience(M)
	if(programName != "turnoff")
		lastprogram = programName

	spawn(30)
		for(var/obj/landmark/L in linkedholodeck)
			if(L.name=="Atmospheric Test Start")
				spawn(20)
					var/turf/T = get_turf(L)
					var/datum/effect/effect/system/spark_spread/s = new
					s.set_up(2, 1, T)
					s.start()
					if(T)
						T.temperature = 5000
						T.hotspot_expose(50000,50000,1)
			if(istype(L, /obj/landmark/mob/holocarpspawn))
				holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(L.loc)

			if(istype(L, /obj/landmark/mob/holocarprandom))
				if(prob(4)) //With 4 spawn points, carp should only appear 15% of the time.
					holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(L.loc)

		update_projections()


/obj/machinery/computer/HolodeckControl/proc/toggleGravity(area/A)
	if(world.time < (last_gravity_change + 25))
		if(world.time < (last_gravity_change + 15))//To prevent super-spam clicking
			return

		visible_message(SPAN_DANGER("[src] flashes 'ERROR. Recalibrating gravity field.'"), SPAN_WARNING("[src] buzzes."), 3)
		last_change = world.time
		return

	last_gravity_change = world.time
	active = TRUE
	set_power_use(ACTIVE_POWER_USE)


	if(A.has_gravity)
		A.has_gravity = FALSE
	else
		A.has_gravity = TRUE
	linkedholodeck.update_gravity()

/obj/machinery/computer/HolodeckControl/proc/emergencyShutdown()
	//Turn it back to the regular non-holographic room
	loadProgram("turnoff", FALSE)


	linkedholodeck.has_gravity = TRUE

	active = FALSE
	set_power_use(IDLE_POWER_USE)

/obj/machinery/computer/HolodeckControl/Exodus
	linkedholodeck_area = /area/holodeck/alphadeck

/obj/machinery/computer/HolodeckControl/Exodus/New()
	..()
	supported_programs = list(
	"Texas Saloon"		= "texas",
	"Space Bar"			= "spacebar",
	"Wireframe Bar"		= "wireframe",
	"Industrial Pub"			= "industrial"
	)

	restricted_programs = list(
	"Industrial Arenas"		= "industrial_arena"
	)
