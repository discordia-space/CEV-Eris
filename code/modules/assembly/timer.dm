/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 1)

	wires = WIRE_PULSE

	secured = 0

	var/timing = 0
	var/time = 10


/obj/item/device/assembly/timer/activate()
	if(!..()) //Cooldown check
		return

	timing = !timing
	update_icon()


/obj/item/device/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/timer/proc/timer_end()
	if(!secured)
		return
	pulse(0)
	if(!holder)
		visible_message("\icon69src69 *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()


/obj/item/device/assembly/timer/Process()
	if(timing && (time > 0))
		time--
	if(timing && time <= 0)
		timing = 0
		timer_end()
		time = 10


/obj/item/device/assembly/timer/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "timer_timing"
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()


/obj/item/device/assembly/timer/interact(mob/user as69ob)//TODO: Have this use the wires
	if(!secured)
		to_chat(user, SPAN_WARNING("The 69name69 is unsecured!"))
		return
	var/second = time % 60
	var/minute = (time - second) / 60

	var/dat = {"
		<tt><b>Timing Unit</b><br>69minute69:69second69<br>
		<a href='?src=\ref69src69;tp=-30'>-</a>
		<a href='?src=\ref69src69;tp=-1'>-</a>
		<a href='?src=\ref69src69;tp=1'>+</a>
		<a href='?src=\ref69src69;tp=30'>+</a><br></tt>
		<a href='?src=\ref69src69;time=69!timing69'>69timing ? "Timing" : "Not Timing"69</a>
		<br><br><a href='?src=\ref69src69;refresh=1'>Refresh</a>
		<br><br><a href='?src=\ref69src69;close=1'>Close</a>
	"}
	user << browse(dat, "window=timer")
	onclose(user, "timer")


/obj/item/device/assembly/timer/Topic(href, href_list)
	if(..()) return 1
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=timer")
		onclose(usr, "timer")
		return

	if(href_list69"time"69)
		timing = text2num(href_list69"time"69)
		update_icon()

	if(href_list69"tp"69)
		var/tp = text2num(href_list69"tp"69)
		time += tp
		time =69in(max(round(time), 0), 600)

	if(href_list69"close"69)
		usr << browse(null, "window=timer")
		return

	if(usr)
		attack_self(usr)
