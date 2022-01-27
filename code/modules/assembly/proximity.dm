/obj/item/device/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 1)
	flags = PROXMOVE
	wires = WIRE_PULSE

	secured = FALSE

	var/scanning = 0
	var/timing = 0
	var/time = 10

	var/range = 2

/obj/item/device/assembly/prox_sensor/proc/toggle_scan()
	sense()


/obj/item/device/assembly/prox_sensor/activate()
	if(!..()) //Cooldown check
		return
	timing = !timing
	update_icon()


/obj/item/device/assembly/prox_sensor/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		scanning = 0
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/prox_sensor/HasProximity(atom/movable/AM as69ob|obj)
	if(!istype(AM))
		log_debug("DEBUG: HasProximity called with 69AM69 on 69src69 (69usr69).")
		return
	if(istype(AM, /obj/effect/beam))
		return
	if(AM.move_speed < 12)
		sense()


/obj/item/device/assembly/prox_sensor/proc/sense()
	var/turf/mainloc = get_turf(src)

	if((!holder && !secured) || !scanning || cooldown > 0)
		return
	pulse(0)
	if(!holder)
		mainloc.visible_message("\icon69src69 *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()


/obj/item/device/assembly/prox_sensor/Process()
	if(scanning)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(range,mainloc))
			if (A.move_speed < 12)
				sense()

	if(timing && (time >= 0))
		time--
	if(timing && time <= 0)
		timing = 0
		toggle_scan()
		time = 10


/obj/item/device/assembly/prox_sensor/dropped()
	spawn(0)
		sense()


/obj/item/device/assembly/prox_sensor/toggle_scan()
	if(!secured)	return 0
	scanning = !scanning
	update_icon()


/obj/item/device/assembly/prox_sensor/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "prox_timing"
		attached_overlays += "prox_timing"
	if(scanning)
		overlays += "prox_scanning"
		attached_overlays += "prox_scanning"
	if(holder)
		holder.update_icon()
	if(holder && istype(holder.loc,/obj/item/grenade/chem_grenade))
		var/obj/item/grenade/chem_grenade/grenade = holder.loc
		grenade.primed(scanning)


/obj/item/device/assembly/prox_sensor/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	. = ..()
	sense()


/obj/item/device/assembly/prox_sensor/interact(mob/user as69ob)//TODO: Change this to the wires thingy
	if(!secured)
		to_chat(user, SPAN_WARNING("The 69name69 is unsecured!"))
		return
	var/second = time % 60
	var/minute = (time - second) / 60
	var/dat = {"
	<tt><b>Proximity Sensor</b><br>69minute69:69second69<br>
	<a href='?src=\ref69src69;tp=-30'>-</a>
	<a href='?src=\ref69src69;tp=-1'>-</a>
	<a href='?src=\ref69src69;tp=1'>+</a>
	<a href='?src=\ref69src69;tp=30'>+</a><br>
	</tt><a href='?src=\ref69src69;time=69!timing69'>69timing ? "Arming" : "Not Arming"69</a>
	<br>Range: <a href='?src=\ref69src69;range=-1'>-</a> 69range69 <a href='?src=\ref69src69;range=1'>+</a>
	<br><a href='?src=\ref69src69;scanning=1'>69scanning ? "Armed" : "Unarmed"69</a> (Movement sensor active when armed!)
	<br><br><a href='?src=\ref69src69;refresh=1'>Refresh</a>
	<br><br><a href='?src=\ref69src69;close=1'>Close</a>
	"}
	user << browse(dat, "window=prox")
	onclose(user, "prox")


/obj/item/device/assembly/prox_sensor/Topic(href, href_list)
	if(..())
		return TRUE
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=prox")
		onclose(usr, "prox")
		return

	if(href_list69"scanning"69)
		toggle_scan()

	if(href_list69"time"69)
		timing = text2num(href_list69"time"69)
		update_icon()

	if(href_list69"tp"69)
		var/tp = text2num(href_list69"tp"69)
		time += tp
		time =69in(max(round(time), 0), 600)

	if(href_list69"range"69)
		var/r = text2num(href_list69"range"69)
		range += r
		range =69in(max(range, 1), 5)

	if(href_list69"close"69)
		usr << browse(null, "window=prox")
		return

	if(usr)
		attack_self(usr)
