/obj/machinery/recharger
	name = "recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	circuit = /obj/item/weapon/circuitboard/recharger
	var/max_power_usage = 24000	//22 kW. This is the highest power the charger can draw and use,
	//though it may draw less when charging weak cells due to their charging rate limits
	active_power_usage = 24000//The actual power the charger uses right now. This is recalculated based on the cell when it's inserted
	var/efficiency = 0.85
	var/obj/item/charging = null
	var/list/allowed_devices = list(
		/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton, /obj/item/weapon/cell, /obj/item/modular_computer,
	)
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1

/obj/machinery/recharger/attackby(obj/item/G, mob/user)

	if(portable && !charging)
		if(istype(G, /obj/item/weapon/tool/screwdriver) || istype(G, /obj/item/weapon/tool/crowbar) )
			default_deconstruction(G, user)


	if(portable && istype(G, /obj/item/weapon/tool/wrench))
		if(charging)
			to_chat(user, SPAN_WARNING("Remove [charging] first!"))
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)

	else if (istype(G, /obj/item/weapon/gripper))//Code for allowing cyborgs to use rechargers
		var/obj/item/weapon/gripper/Gri = G
		if (charging)//If there's something in the charger
			if (Gri.grip_item(charging, user))//we attempt to grab it
				charging = null
				update_icon()
			else
				to_chat(user, "<span class='danger'>Your gripper cannot hold \the [charging].</span>")

	if(!user.canUnEquip(G))
		return

	if(is_type_in_list(G, allowed_devices))
		if(charging)
			to_chat(user, SPAN_WARNING("\A [charging] is already charging here."))
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, SPAN_WARNING("The [name] blinks red as you try to insert the item!"))
			return

		if(istype(G, /obj/item/weapon/gun/energy/gun/nuclear) || istype(G, /obj/item/weapon/gun/energy/crossbow))
			to_chat(user, SPAN_NOTICE("Your gun's recharge port was removed to make room for a miniaturized reactor."))
			return

		var/obj/item/weapon/cell/cell = G.get_cell()

		if (!cell)
			to_chat(user, "This device does not have a battery installed.")
			return //We don't want to go any farther if we failed to find a cell
		else
			active_power_usage = min(max_power_usage, (cell.maxcharge*cell.max_chargerate)/CELLRATE)
			//If trying to charge a really small cell, we won't waste more power than it can intake


		user.unEquip(G)
		G.forceMove(src)
		charging = G
		update_icon()




/obj/machinery/recharger/attack_hand(mob/user as mob)
	if(issilicon(user))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

/obj/machinery/recharger/Process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(0)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(1)
		icon_state = icon_state_idle
		return

	var/obj/item/weapon/cell/cell = charging.get_cell()

	if(cell)
		if(!cell.fully_charged())
			icon_state = icon_state_charging
			cell.give((active_power_usage*CELLRATE)*efficiency)
			update_use_power(2)
		else
			icon_state = icon_state_charged
			update_use_power(1)
	else
		icon_state = icon_state_idle
		update_use_power(1)

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(charging)
		var/obj/item/weapon/cell/cell = charging.get_cell()
		if(cell)
			cell.emp_act(severity)

	..(severity)

/obj/machinery/recharger/handle_atom_del(atom/A)
	..()
	if(A == charging)
		charging = null
		update_icon()

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 32000	//40 kW , It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
