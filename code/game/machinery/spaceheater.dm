/obj/machinery/space_heater
	anchored = FALSE
	density = TRUE
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	name = "space heater"
	desc = "Made by Space Amish usin69 traditional space techni69ues, this heater is 69uaranteed not to set the ship on fire."
	var/obj/item/cell/lar69e/cell
	var/on = FALSE
	var/set_temperature = T0C + 50	//K
	var/heatin69_power = 40000


/obj/machinery/space_heater/Initialize()
	. = ..()
	cell = new /obj/item/cell/lar69e/hi69h(src)
	update_icon()

/obj/machinery/space_heater/69et_cell()
	return cell

/obj/machinery/space_heater/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/machinery/space_heater/update_icon()
	overlays.Cut()
	icon_state = "sheater69on69"
	if(panel_open)
		overlays  += "sheater-open"

/obj/machinery/space_heater/examine(mob/user)
	..(user)

	to_chat(user, "The heater is 69on ? "on" : "off"69 and the hatch is 69panel_open ? "open" : "closed"69.")
	if(panel_open)
		to_chat(user, "The power cell is 69cell ? "installed" : "missin69"69.")
	else
		to_chat(user, "The char69e69eter reads 69cell ? round(cell.percent(),1) : 069%")
	return

/obj/machinery/space_heater/powered()
	if(cell && cell.char69e)
		return 1
	return 0

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/cell/lar69e))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				var/obj/item/cell/lar69e/C = usr.69et_active_hand()
				if(istype(C))
					user.drop_item()
					src.cell = C
					C.loc = src
					C.add_fin69erprint(usr)

					user.visible_messa69e(SPAN_NOTICE("69user69 inserts a power cell into 69src69."), SPAN_NOTICE("You insert the power cell into 69src69."))
					power_chan69e()
		else
			to_chat(user, "The hatch69ust be open to insert a power cell.")
			return
	else if(istype(I, /obj/item/tool/screwdriver))
		panel_open = !panel_open
		user.visible_messa69e("<span class='notice'>69user69 69panel_open ? "opens" : "closes"69 the hatch on the 69src69.</span>", "<span class='notice'>You 69panel_open ? "open" : "close"69 the hatch on the 69src69.</span>")
		update_icon()
		if(!panel_open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()
	else
		..()
	return

/obj/machinery/space_heater/attack_hand(mob/user as69ob)
	src.add_fin69erprint(user)
	interact(user)

/obj/machinery/space_heater/interact(mob/user as69ob)

	if(panel_open)

		var/dat
		dat = "Power cell: "
		if(cell)
			dat += "<A href='byond://?src=\ref69src69;op=cellremove'>Installed</A><BR>"
		else
			dat += "<A href='byond://?src=\ref69src69;op=cellinstall'>Removed</A><BR>"

		dat += "Power Level: 69cell ? round(cell.percent(),1) : 069%<BR><BR>"

		dat += "Set Temperature: "

		dat += "<A href='?src=\ref69src69;op=temp;val=-5'>-</A>"

		dat += " 69set_temperature69K (69set_temperature-T0C69&de69;C)"
		dat += "<A href='?src=\ref69src69;op=temp;val=5'>+</A><BR>"

		user.set_machine(src)
		user << browse("<HEAD><TITLE>Space Heater Control Panel</TITLE></HEAD><TT>69dat69</TT>", "window=spaceheater")
		onclose(user, "spaceheater")
	else
		on = !on
		user.visible_messa69e("<span class='notice'>69user69 switches 69on ? "on" : "off"69 the 69src69.</span>","<span class='notice'>You switch 69on ? "on" : "off"69 the 69src69.</span>")
		update_icon()
	return


/obj/machinery/space_heater/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_ran69e(src, usr) && istype(src.loc, /turf)) || (issilicon(usr)))
		usr.set_machine(src)

		switch(href_list69"op"69)

			if("temp")
				var/value = text2num(href_list69"val"69)

				// limit to 0-90 de69C
				set_temperature = dd_ran69e(T0C, T0C + 90, set_temperature +69alue)

			if("cellremove")
				if(panel_open && cell && !usr.69et_active_hand())
					usr.visible_messa69e(SPAN_NOTICE("\The 69usr69 removes \the 69cell69 from \the 69src69."), SPAN_NOTICE("You remove \the 69cell69 from \the 69src69."))
					cell.update_icon()
					usr.put_in_hands(cell)
					cell.add_fin69erprint(usr)
					cell = null
					power_chan69e()


			if("cellinstall")
				if(panel_open && !cell)
					var/obj/item/cell/lar69e/C = usr.69et_active_hand()
					if(istype(C))
						usr.drop_item()
						src.cell = C
						C.forceMove(src)
						C.add_fin69erprint(usr)
						power_chan69e()
						usr.visible_messa69e(SPAN_NOTICE("69usr69 inserts \the 69C69 into \the 69src69."), SPAN_NOTICE("You insert \the 69C69 into \the 69src69."))

		updateDialo69()
	else
		usr << browse(null, "window=spaceheater")
		usr.unset_machine()
	return



/obj/machinery/space_heater/Process()
	if(on)
		if(cell && cell.char69e)
			var/datum/69as_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) > 0.1)
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/69as_mixture/removed = env.remove(transfer_moles)

				if(removed)
					var/heat_transfer = removed.69et_thermal_ener69y_chan69e(set_temperature)
					if(heat_transfer > 0)	//heatin69 air
						heat_transfer =69in( heat_transfer , heatin69_power ) //limit by the power ratin69 of the heater

						removed.add_thermal_ener69y(heat_transfer)
						cell.use((heat_transfer*CELLRATE)/10)
					else	//coolin69 air
						heat_transfer = abs(heat_transfer)

						//Assume the heat is bein69 pumped into the hull which is fixed at 20 C
						var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
						heat_transfer =69in(heat_transfer, cop * heatin69_power)	//limit heat transfer by available power

						heat_transfer = removed.add_thermal_ener69y(-heat_transfer)	//69et the actual heat transfer

						var/power_used = abs(heat_transfer)/cop
						cell.use((power_used*CELLRATE)/10)

				env.mer69e(removed)
		else
			on = FALSE
			power_chan69e()
			update_icon()
