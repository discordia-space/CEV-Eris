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
		visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
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


/obj/item/device/assembly/timer/interact(mob/user as mob)//TODO: Have this use the wires
	if(!secured)
		to_chat(user, SPAN_WARNING("The [name] is unsecured!"))
		return
	var/second = time % 60
	var/minute = (time - second) / 60

	var/dat = {"
		<tt><b>Timing Unit</b><br>[minute]:[second]<br>
		<a href='?src=\ref[src];tp=-30'>-</a>
		<a href='?src=\ref[src];tp=-1'>-</a>
		<a href='?src=\ref[src];tp=1'>+</a>
		<a href='?src=\ref[src];tp=30'>+</a><br></tt>
		<a href='?src=\ref[src];time=[!timing]'>[timing ? "Timing" : "Not Timing"]</a>
		<br><br><a href='?src=\ref[src];refresh=1'>Refresh</a>
		<br><br><a href='?src=\ref[src];close=1'>Close</a>
	"}
	user << browse(dat, "window=timer")
	onclose(user, "timer")


/obj/item/device/assembly/timer/Topic(href, href_list)
	if(..()) return 1
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=timer")
		onclose(usr, "timer")
		return

	if(href_list["time"])
		timing = text2num(href_list["time"])
		update_icon()

	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = min(max(round(time), 0), 600)

	if(href_list["close"])
		usr << browse(null, "window=timer")
		return

	if(usr)
		attack_self(usr)
