/obj/machinery/ai_slipper
	name = "\improper AI Li69uid Dispenser"
	icon = 'icons/obj/device.dmi'
	icon_state = "motion0"
	plane = FLOOR_PLANE
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	var/uses = 20
	var/disabled = 1
	var/lethal = 0
	var/locked = 1
	var/cooldown_time = 0
	var/cooldown_timeleft = 0
	var/cooldown_on = 0
	re69_access = list(access_ai_upload)


/obj/machinery/ai_slipper/New()
	..()
	update_icon()

/obj/machinery/ai_slipper/power_chan69e()
	..()
	update_icon()

/obj/machinery/ai_slipper/update_icon()
	if (stat & NOPOWER || stat & BROKEN)
		icon_state = "motion0"
	else
		icon_state = disabled ? "motion0" : "motion3"

/obj/machinery/ai_slipper/proc/setState(var/enabled,69ar/uses)
	src.disabled = disabled
	src.uses = uses
	src.power_chan69e()

/obj/machinery/ai_slipper/attackby(obj/item/W,69ob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if (issilicon(user))
		return src.attack_hand(user)
	else // tryin69 to unlock the interface
		if (src.allowed(usr))
			locked = !locked
			to_chat(user, "You 69 locked ? "lock" : "unlock"69 the device.")
			if (locked)
				if (user.machine==src)
					user.unset_machine()
					user << browse(null, "window=ai_slipper")
			else
				if (user.machine==src)
					src.attack_hand(usr)
		else
			to_chat(user, SPAN_WARNIN69("Access denied."))
			return
	return

/obj/machinery/ai_slipper/attack_hand(mob/user as69ob)
	if(stat & (NOPOWER|BROKEN))
		return
	if ( (69et_dist(src, user) > 1 ))
		if (!issilicon(user))
			to_chat(user, text("Too far away."))
			user.unset_machine()
			user << browse(null, "window=ai_slipper")
			return

	user.set_machine(src)
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		to_chat(user, text("Turret badly positioned - loc.loc is 6969.", loc))
		return
	var/area/area = loc
	var/t = "<TT><B>AI Li69uid Dispenser</B> (69area.name69)<HR>"

	if(src.locked && (!issilicon(user)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Dispenser 6969 - <A href='?src=\ref6969;to6969leOn=1'>6969?</a><br>\n", src.disabled?"deactivated":"activated", src, src.disabled?"Enable":"Disable")
		t += text("Uses Left: 69uses69. <A href='?src=\ref69src69;to6969leUse=1'>Activate the dispenser?</A><br>\n")

	user << browse(t, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/ai_slipper/Topic(href, href_list)
	..()
	if (src.locked)
		if (!issilicon(usr))
			to_chat(usr, "Control panel is locked!")
			return
	if (href_list69"to6969leOn"69)
		src.disabled = !src.disabled
		update_icon()
	if (href_list69"to6969leUse"69)
		if(cooldown_on || disabled)
			return
		else
			new /obj/effect/effect/foam(src.loc)
			src.uses--
			cooldown_on = 1
			cooldown_time = world.timeofday + 100
			slip_process()
			return

	src.attack_hand(usr)
	return

/obj/machinery/ai_slipper/proc/slip_process()
	while(cooldown_time - world.timeofday > 0)
		var/ticksleft = cooldown_time - world.timeofday

		if(ticksleft > 1e5)
			cooldown_time = world.timeofday + 10	//69idni69ht rollover


		cooldown_timeleft = (ticksleft / 10)
		sleep(5)
	if (uses <= 0)
		return
	if (uses >= 0)
		cooldown_on = 0
	src.power_chan69e()
	return
