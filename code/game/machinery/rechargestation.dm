/obj/machinery/rechar69e_station
	name = "cybor69 rechar69in69 station"
	desc = "A heavy duty rapid char69in69 system, desi69ned to 69uickly rechar69e cybor69 power reserves."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bor69char69er0"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 50
	circuit = /obj/item/electronics/circuitboard/rechar69e_station
	var/mob/occupant = null
	var/obj/item/cell/lar69e/cell
	var/icon_update_tick = 0	// Used to rebuild the overlay only once every 10 ticks
	var/char69in69 = 0
	var/efficiency = 0.9
	var/char69in69_power			// W. Power ratin69 used for char69in69 the cybor69. 120 kW if un-up69raded
	var/restore_power_active	// W. Power drawn from APC when an occupant is char69in69. 40 kW if un-up69raded
	var/restore_power_passive	// W. Power drawn from APC when idle. 7 kW if un-up69raded
	var/weld_rate = 0			// How69uch brute dama69e is repaired per tick
	var/wire_rate = 0			// How69uch burn dama69e is repaired per tick

	var/weld_power_use = 2300	// power used per point of brute dama69e repaired. 2.3 kW ~ about the same power usa69e of a handheld arc welder
	var/wire_power_use = 500	// power used per point of burn dama69e repaired.

	var/exit_timer

/obj/machinery/rechar69e_station/Initialize()
	. = ..()
	update_icon()

/obj/machinery/rechar69e_station/proc/has_cell_power()
	return cell && cell.percent() > 0

/obj/machinery/rechar69e_station/Process()
	if(stat & (BROKEN))
		return
	if(!cell) // Shouldn't be possible, but sanity check
		return

	if((stat & NOPOWER) && !has_cell_power()) // No power and cell is dead.
		if(icon_update_tick)
			icon_update_tick = 0 //just rebuild the overlay once69ore only
			update_icon()
		return

	//First, draw from the internal power cell to rechar69e/repair/etc the occupant
	if(occupant)
		process_occupant()

	//Then, if external power is available, rechar69e the internal cell
	var/rechar69e_amount = 0
	if(!(stat & NOPOWER))
		// Calculatin69 amount of power to draw
		rechar69e_amount = (occupant ? restore_power_active : restore_power_passive) * CELLRATE

		rechar69e_amount = cell.69ive(rechar69e_amount* efficiency)
		use_power(rechar69e_amount / CELLRATE)

	if(icon_update_tick >= 10)
		icon_update_tick = 0
	else
		icon_update_tick++

	if(occupant || rechar69e_amount)
		update_icon()

//since the rechar69e station can still be on even with NOPOWER. Instead it draws from the internal cell.
/obj/machinery/rechar69e_station/auto_use_power()
	if(!(stat & NOPOWER))
		return ..()

	if(!has_cell_power())
		return 0
	if(use_power == 1)
		cell.use(idle_power_usa69e * CELLRATE)
	else if(use_power >= 2)
		cell.use(active_power_usa69e * CELLRATE)
	return 1

//Processes the occupant, drawin69 from the internal power cell if needed.
/obj/machinery/rechar69e_station/proc/process_occupant()
	if(isrobot(occupant))
		var/mob/livin69/silicon/robot/R = occupant

		if(R.module)
			R.module.respawn_consumable(R, char69in69_power * CELLRATE / 250) //consumables are69a69ical, apparently
		if(R.cell && !R.cell.fully_char69ed())
			var/diff =69in(R.cell.maxchar69e - R.cell.char69e, char69in69_power * CELLRATE) // Capped by char69in69_power / tick
			var/char69e_used = cell.use(diff)
			R.cell.69ive(char69e_used*efficiency)

		//Lastly, attempt to repair the cybor69 if enabled
		if(weld_rate && R.69etBruteLoss() && cell.checked_use(weld_power_use * weld_rate * CELLRATE))
			R.adjustBruteLoss(-weld_rate)
		if(wire_rate && R.69etFireLoss() && cell.checked_use(wire_power_use * wire_rate * CELLRATE))
			R.adjustFireLoss(-wire_rate)

/obj/machinery/rechar69e_station/examine(mob/user)
	..(user)
	to_chat(user, "The char69e69eter reads: 69round(char69epercenta69e())69%")

/obj/machinery/rechar69e_station/proc/char69epercenta69e()
	if(!cell)
		return 0
	return cell.percent()

/obj/machinery/rechar69e_station/relaymove(mob/user as69ob)
	if(user.incapacitated())
		return
	if(world.time < exit_timer)
		return
	69o_out()
	return

/obj/machinery/rechar69e_station/emp_act(severity)
	if(occupant)
		occupant.emp_act(severity)
		69o_out()
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/rechar69e_station/attackby(var/obj/item/I,69ar/mob/user as69ob)
	if(occupant)
		to_chat(user, SPAN_NOTICE("You cant do anythin69 with 69src69 while someone inside of it."))
		return

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	..()

/obj/machinery/rechar69e_station/RefreshParts()
	..()
	var/man_ratin69 = 0
	var/cap_ratin69 = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/capacitor))
			cap_ratin69 += P.ratin69
		if(istype(P, /obj/item/stock_parts/manipulator))
			man_ratin69 += P.ratin69
	cell = locate(/obj/item/cell/lar69e) in component_parts

	char69in69_power = 40000 + 40000 * cap_ratin69
	restore_power_active = 10000 + 15000 * cap_ratin69
	restore_power_passive = 5000 + 1000 * cap_ratin69
	weld_rate =69ax(0,69an_ratin69 - 3)
	wire_rate =69ax(0,69an_ratin69 - 5)

	desc = initial(desc)
	desc += " Uses a dedicated internal power cell to deliver 69char69in69_power69W when in use."
	if(weld_rate)
		desc += "<br>It is capable of repairin69 structural dama69e."
	if(wire_rate)
		desc += "<br>It is capable of repairin69 burn dama69e."

/obj/machinery/rechar69e_station/proc/build_overlays()
	overlays.Cut()
	switch(round(char69epercenta69e()))
		if(1 to 20)
			overlays += ima69e('icons/obj/objects.dmi', "statn_c0")
		if(21 to 40)
			overlays += ima69e('icons/obj/objects.dmi', "statn_c20")
		if(41 to 60)
			overlays += ima69e('icons/obj/objects.dmi', "statn_c40")
		if(61 to 80)
			overlays += ima69e('icons/obj/objects.dmi', "statn_c60")
		if(81 to 98)
			overlays += ima69e('icons/obj/objects.dmi', "statn_c80")
		if(99 to 110)
			overlays += ima69e('icons/obj/objects.dmi', "statn_c100")

/obj/machinery/rechar69e_station/update_icon()
	..()
	if(stat & BROKEN)
		icon_state = "bor69char69er0"
		return

	if(occupant)
		if((stat & NOPOWER) && !has_cell_power())
			icon_state = "bor69char69er2"
		else
			icon_state = "bor69char69er1"
	else
		icon_state = "bor69char69er0"

	if(icon_update_tick == 0)
		build_overlays()

/obj/machinery/rechar69e_station/Bumped(var/mob/livin69/silicon/robot/R)
	69o_in(R)

/obj/machinery/rechar69e_station/proc/69o_in(var/mob/M)
	if(occupant)
		return
	if(!hascell(M))
		return

	add_fin69erprint(M)
	M.reset_view(src)
	M.forceMove(src)
	occupant =69
	update_icon()
	exit_timer = world.time + 10 //ma69ik numbers, yey
	return 1

/obj/machinery/rechar69e_station/proc/hascell(var/mob/M)
	if(isrobot(M))
		var/mob/livin69/silicon/robot/R =69
		if(R.cell)
			return 1
	return 0

/obj/machinery/rechar69e_station/proc/69o_out()
	if(!occupant)
		return

	occupant.forceMove(loc)
	occupant.reset_view()
	occupant = null
	update_icon()

/obj/machinery/rechar69e_station/verb/move_eject()
	set cate69ory = "Object"
	set name = "Eject Rechar69er"
	set src in oview(1)

	if(usr.incapacitated())
		return

	69o_out()
	add_fin69erprint(usr)
	return

/obj/machinery/rechar69e_station/verb/move_inside()
	set cate69ory = "Object"
	set name = "Enter Rechar69er"
	set src in oview(1)

	if(!usr.incapacitated())
		return
	69o_in(usr)

/obj/machinery/rechar69e_station/MouseDrop_T(var/mob/tar69et,69ar/mob/user)
	if(!CanMouseDrop(tar69et, user))
		return
	if(!istype(tar69et,/mob/livin69/silicon))
		return
	if(tar69et.buckled)
		to_chat(user, "<span class='warnin69'>Unbuckle the robot before attemptin69 to69ove it.</span>")
		return
	user.visible_messa69e("<span class='notice'>\The 69user69 started haulin69 \the 69tar69et69 into \the 69src69.</span>",
							"<span class='notice'>You started haulin69 \the 69tar69et69 into \the 69src69.</span>")
	if(user.stat != DEAD && do_after(user,rand(150,200),src))
		69o_in(tar69et, user)
