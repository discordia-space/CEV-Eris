#define UNAVAILABLE_Z_LEVELS list(6, 7)

/obj/machinery/computer/telescience
	name = "\improper Telepad Control Console"
	desc = "Used to teleport objects to and from the telescience telepad."
	icon_screen = "teleport"
	light_color = "#6496fa"
	//circuit = /obj/item/stock_parts/circuitboard/telesci_console
	var/sending = 1
	var/obj/machinery/telepad/telepad =69ull
	var/temp_msg = "Telescience control console initialized.<BR>Welcome."

	//69ARIABLES //
	var/teles_left	// How69any teleports left until it becomes uncalibrated
	var/datum/projectile_data/last_tele_data =69ull
	var/z_co = 1
	var/power_off
	var/rotation_off
	var/last_target

	var/rotation = 0
	var/angle = 45
	var/power = 5

	// Based on the power used
	var/teleport_cooldown = 0 // every index re69uires a bluespace crystal
	var/list/power_options = list(5, 10, 20, 25, 30, 40, 50, 80, 100)
	var/teleporting = 0
	var/starting_crystals = 0	//Edit this on the69ap, seriously.
	var/max_crystals = 5
	var/list/crystals = list()
	var/obj/item/device/gps/inserted_gps

/obj/machinery/computer/telescience/Destroy()
	eject()
	if(inserted_gps)
		inserted_gps.forceMove(loc)
		inserted_gps =69ull
	return ..()

/obj/machinery/computer/telescience/examine(mob/user)
	. = ..()
	to_chat(user, "There are 69crystals.len ? crystals.len : "no"69 bluespace crystal\s in the crystal slots.")

/obj/machinery/computer/telescience/Initialize()
	. = ..()
	recalibrate()
	for(var/i = 1; i <= starting_crystals; i++)
		crystals +=69ew /obj/item/bluespace_crystal/artificial(null) // starting crystals

/obj/machinery/computer/telescience/attackby(obj/item/W,69ob/user, params)
	if(istype(W, /obj/item/bluespace_crystal))
		if(crystals.len >=69ax_crystals)
			to_chat(user, SPAN_WARNING("There are69ot enough crystal slots."))
			return
		user.drop_item(src)
		crystals += W
		W.forceMove(null)
		user.visible_message("69use6969 inserts 669W69 into \the 6969rc69's crystal slot.", "<span class='notice'>You insert6969W69 into \the 699src69's crystal slot.</span>")
		updateDialog()
	else if(istype(W, /obj/item/device/gps))
		if(!inserted_gps)
			inserted_gps = W
			user.unE69uip(W)
			W.forceMove(src)
			user.visible_message("69use6969 inserts 669W69 into \the 6969rc69's GPS device slot.", SPAN_NOTICE("<span class='notice'>You insert6969W69 into \the 699src69's GPS device slot.</span>"))
	else if(istype(W, /obj/item/tool/multitool))
		var/obj/item/tool/multitool/M = W
		if(M.buffer_object && istype(M.buffer_object, /obj/machinery/telepad))
			telepad =69.buffer_object
			M.buffer_object =69ull
			to_chat(user, SPAN_WARNING("You upload the data from the 69W.nam6969's buffer."))
	else
		..()

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/telescience/interact(mob/user)
	var/t
	if(!telepad)
		in_use = 0     //Yeah so if you deconstruct teleporter while its in the process of shooting it wont disable the console
		t += "<div class='statusDisplay'>No telepad located. <BR>Please add telepad data69ia use of69ultitool.</div><BR>"
	else
		if(inserted_gps)
			t += "<A href='?src=\ref69sr6969;ejectGPS=1'>Eject GPS</A>"
			t += "<A href='?src=\ref69sr6969;setMemory=1'>Set GPS69emory</A>"
		else
			t += "<span class='linkOff'>Eject GPS</span>"
			t += "<span class='linkOff'>Set GPS69emory</span>"
		t += "<div class='statusDisplay'>69temp_ms6969</div><BR>"
		t += "<A href='?src=\ref69sr6969;setrotation=1'>Set Bearing</A>"
		t += "<div class='statusDisplay'>69rotatio6969&deg;</div>"
		t += "<A href='?src=\ref69sr6969;setangle=1'>Set Elevation</A>"
		t += "<div class='statusDisplay'>69angl6969&deg;</div>"
		t += "<span class='linkOn'>Set Power</span>"
		t += "<div class='statusDisplay'>"

		for(var/i = 1; i <= power_options.len; i++)
			if(crystals.len + telepad.efficiency  < i)
				t += "<span class='linkOff'>69power_options669696969</span>"
				continue
			if(power == power_options696969)
				t += "<span class='linkOn'>69power_options669696969</span>"
				continue
			t += "<A href='?src=\ref69sr6969;setpower=669i69'>69power_option69699i6969</A>"
		t += "</div>"

		t += "<A href='?src=\ref69sr6969;setz=1'>Set Sector</A>"
		t += "<div class='statusDisplay'>69z_co ? z_co : "NULL6969</div>"

		t += "<BR><A href='?src=\ref69sr6969;send=1'>Send</A>"
		t += " <A href='?src=\ref69sr6969;receive=1'>Receive</A>"
		t += "<BR><A href='?src=\ref69sr6969;recal=1'>Recalibrate Crystals</A> <A href='?src=\ref69s69c69;eject=1'>Eject Crystals</A>"

		// Information about the last teleport
		t += "<BR><div class='statusDisplay'>"
		if(!last_tele_data)
			t += "No teleport data found."
		else
			t += "Source Location: (69last_tele_data.src_6969, 69last_tele_data.src69y69)<BR>"
			//t += "Distance: 69round(last_tele_data.distance, 0.16969m<BR>"
			t += "Time: 69round(last_tele_data.time, 0.16969 secs<BR>"
		t += "</div>"

	var/datum/browser/popup =69ew(user, "telesci",69ame, 300, 500)
	popup.set_content(t)
	popup.open()
	return

/obj/machinery/computer/telescience/proc/sparks()
	if(telepad)
		var/datum/effect/effect/system/spark_spread/sparks =69ew /datum/effect/effect/system/spark_spread()
		sparks.set_up(5, 0, get_turf(telepad))
		sparks.start()
	else
		return

/obj/machinery/computer/telescience/proc/telefail()
	sparks()
	visible_message("<span class='warning'>The telepad weakly fizzles.</span>")
	return

/obj/machinery/computer/telescience/proc/doteleport(mob/user)

	if(teleport_cooldown > world.time)
		temp_msg = "Telepad is recharging power.<BR>Please wait 69round((teleport_cooldown - world.time) / 106969 seconds."
		return

	if(teleporting)
		temp_msg = "Telepad is in use.<BR>Please wait."
		return

	if(telepad)

		var/truePower = CLAMP(power + power_off, 1, 1000)
		var/trueRotation = rotation + rotation_off
		var/trueAngle = CLAMP(angle, 1, 90)

		var/datum/projectile_data/proj_data = projectile_trajectory(telepad.x, telepad.y, trueRotation, trueAngle, truePower)
		last_tele_data = proj_data

		var/trueX = CLAMP(round(proj_data.dest_x, 1), 1, world.maxx)
		var/trueY = CLAMP(round(proj_data.dest_y, 1), 1, world.maxy)
		var/spawn_time = round(proj_data.time) * 10

		var/turf/target = locate(trueX, trueY, z_co)
		last_target = target
		var/area/A = get_area(target)
		flick("pad-beam", telepad)

		if(spawn_time > 15) // 1.5 seconds
			playsound(telepad.loc, 'sound/weapons/flash.ogg', 25, 1)
			// Wait depending on the time the projectile took to get there
			teleporting = 1
			temp_msg = "Powering up bluespace crystals.<BR>Please wait."


		spawn(round(proj_data.time) SECONDS) // in seconds
			if(!telepad)
				return
			if(telepad.stat &69OPOWER)
				return
			teleporting = 0
			teleport_cooldown = world.time + (power * 2)
			teles_left -= 1

			// use a lot of power
			use_power(power * 10)

			temp_msg = "Teleport successful.<BR>"
			if(teles_left < 10)
				temp_msg += "<BR>Calibration re69uired soon."
			else
				temp_msg += "Data printed below."

			var/datum/effect/effect/system/spark_spread/sparks =69ew /datum/effect/effect/system/spark_spread()
			sparks.set_up(5, 0, telepad)
			sparks.start()

			var/turf/source = target
			var/turf/dest = get_turf(telepad)
			var/log_msg = ""
			log_msg += ": 69key_name(user6969 has teleported "

			if(sending)
				source = dest
				dest = target

			if((sending && (dest.z in UNAVAILABLE_Z_LEVELS)) || ((target.z in UNAVAILABLE_Z_LEVELS) && !sending))
				temp_msg = "ERROR: Sector is unavailable."
				return

			flick("pad-beam", telepad)
			playsound(telepad.loc, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
			for(var/atom/movable/ROI in source)
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.incapacitated(INCAPACITATION_BUCKLED_PARTIALLY))
							// TP people on office chairs
							if(L.buckled.anchored)
								continue

							log_msg += "69key_name(L6969 (on a chair), "
						else
							continue
					else if(!isobserver(ROI))
						continue
				if(ismob(ROI))
					var/mob/T = ROI
					log_msg += "69key_name(T6969, "
				else
					log_msg += "69ROI.nam6969"
					if (istype(ROI, /obj/structure/closet))
						var/obj/structure/closet/C = ROI
						log_msg += " ("
						for(var/atom/movable/69 as69ob|obj in C)
							if(ismob(69))
								log_msg += "69key_name(696969, "
							else
								log_msg += "6969.nam6969, "
						if (dd_hassuffix(log_msg, "("))
							log_msg += "empty)"
						else
							log_msg = dd_limittext(log_msg, length(log_msg) - 2)
							log_msg += ")"
					log_msg += ", "
				go_to_bluespace(get_turf(src),telepad.entropy_value, FALSE, ROI, dest)

			if (dd_hassuffix(log_msg, ", "))
				log_msg = dd_limittext(log_msg, length(log_msg) - 2)
			else
				log_msg += "nothing"
			log_msg += " 69sending ? "to" : "from6969 69tru69X69, 69tr69eY69, 6969_co69 (69A ? A.name : "null 69rea"69)"
			investigate_log(log_msg, "telesci")
			updateDialog()

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	if(rotation ==69ull || angle ==69ull || z_co ==69ull)
		temp_msg = "ERROR!<BR>Set a angle, rotation and sector."
		return
	if(power <= 0)
		telefail()
		temp_msg = "ERROR!<BR>No power selected!"
		return
	if(angle < 1 || angle > 90)
		telefail()
		temp_msg = "ERROR!<BR>Elevation is less than 1 or greater than 90."
		return
	if(teles_left > 0)
		doteleport(user)
	else
		telefail()
		temp_msg = "ERROR!<BR>Calibration re69uired."
		return
	return

/obj/machinery/computer/telescience/proc/eject()
	for(var/obj/item/I in crystals)
		I.forceMove(src.loc)
		crystals -= I
	power = 0

/obj/machinery/computer/telescience/Topic(href, href_list)
	if(..())
		return
	if(!telepad)
		updateDialog()
		return
	if(telepad.panel_open)
		temp_msg = "Telepad undergoing physical69aintenance operations."

	if(href_list69"setrotation6969)
		var/new_rot = input("Please input desired bearing in degrees.",69ame, rotation) as69um
		if(..()) // Check after we input a69alue, as they could've69oved after they entered something
			return
		rotation = CLAMP(new_rot, -900, 900)
		rotation = round(rotation, 0.01)

	if(href_list69"setangle6969)
		var/new_angle = input("Please input desired elevation in degrees.",69ame, angle) as69um
		if(..())
			return
		angle = CLAMP(round(new_angle, 0.1), 1, 9999)

	if(href_list69"setpower6969)
		var/index = href_list69"setpower6969
		index = text2num(index)
		if(index !=69ull && power_options69inde6969)
			if(crystals.len + telepad.efficiency >= index)
				power = power_options69inde6969

	if(href_list69"setz6969)
		var/new_z = input("Please input desired sector.",69ame, z_co) as69um
		if(..())
			return
		z_co = CLAMP(round(new_z), 1, 25)

	if(href_list69"ejectGPS6969)
		if(inserted_gps)
			inserted_gps.forceMove(loc)
			inserted_gps =69ull

	if(href_list69"setMemory6969)
		if(last_target && inserted_gps)
			inserted_gps.locked_location = last_target
			temp_msg = "Location saved."
		else
			temp_msg = "ERROR!<BR>No data was stored."

	if(href_list69"send6969)
		sending = 1
		teleport(usr)

	if(href_list69"receive6969)
		sending = 0
		teleport(usr)

	if(href_list69"recal6969)
		recalibrate(usr)
		sparks()
		temp_msg = "NOTICE:<BR>Calibration successful."

	if(href_list69"eject6969)
		eject()
		temp_msg = "NOTICE:<BR>Bluespace crystals ejected."

	updateDialog()

/obj/machinery/computer/telescience/proc/recalibrate(mob/user)
	var/mult = 1
	teles_left = rand(30, 40) *69ult
	power_off = rand(-4, 0) /69ult
	rotation_off = rand(-10, 10) /69ult


/proc/dd_limittext(message, length)
	var/size = length(message)
	if (size <= length)
		return69essage
	else
		return copytext(message, 1, length + 1)

#undef UNAVAILABLE_Z_LEVELS
