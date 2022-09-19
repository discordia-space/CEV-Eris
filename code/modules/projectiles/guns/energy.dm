/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	bad_type = /obj/item/gun/energy
	spawn_tags = SPAWN_TAG_GUN_ENERGY

	var/charge_cost = 100 //How much energy is needed to fire.
	var/obj/item/cell/cell
	var/suitable_cell = /obj/item/cell/medium
	var/cell_type = /obj/item/cell/medium/high
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = TRUE //if set, the icon state will be chosen based on the current charge
	var/item_modifystate
	var/item_charge_meter = FALSE //same as above for item state
	//for sawable guns
	var/saw_off = FALSE
	var/sawn //what it will becone after sawing

	//self-recharging
	var/self_recharge = FALSE		//if set, the weapon will recharge itself
	var/disposable = FALSE
	var/use_external_power = FALSE	//if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0
	var/overcharge_timer //Holds ref to the timer used for overcharging
	var/overcharge_rate = 1 //Base overcharge additive rate for the gun
	var/overcharge_level = 0 //What our current overcharge level is. Peaks at overcharge_max
	var/overcharge_max = 5

	wield_delay = 0 SECOND
	wield_delay_factor = 0

/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/energy/Initialize()
	. = ..()
	if(self_recharge)
		cell = new cell_type(src)
		START_PROCESSING(SSobj, src)
	update_icon()
	if(disposable)
		cell = new cell_type(src)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/energy/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!cell || cell.charge >= cell.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/cell/large/external = get_external_cell()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		cell.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/gun/energy/get_cell()
	return cell

/obj/item/gun/energy/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/gun/energy/consume_next_projectile()
	if(!cell) return null
	if(!ispath(projectile_type)) return null
	if(!cell.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/gun/energy/proc/get_external_cell()
	return loc.get_cell()

/obj/item/gun/energy/examine(mob/user)
	..(user)
	if(!cell)
		to_chat(user, SPAN_NOTICE("Has no battery cell inserted."))
		return
	var/shots_remaining = round(cell.charge / charge_cost)
	to_chat(user, "Has [shots_remaining] shot\s remaining.")
	return

/obj/item/gun/energy/update_icon(var/ignore_inhands)
	if(charge_meter)
		var/ratio = 0

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= charge_cost)
			ratio = cell.charge / cell.maxcharge
			ratio = min(max(round(ratio, 0.25) * 100, 25), 100)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"

		if(item_charge_meter)
			set_item_state("-[item_modifystate][ratio]")
	if(!item_charge_meter && item_modifystate)
		set_item_state("-[item_modifystate]")
	if(!ignore_inhands)
		update_wear_icon()

/obj/item/gun/energy/MouseDrop(over_object)
	if(disposable)
		to_chat(usr, SPAN_WARNING("[src] is a disposable, its batteries cannot be removed!."))
	else if(self_recharge)
		to_chat(usr, SPAN_WARNING("[src] is a self-charging gun, its batteries cannot be removed!."))
	else if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
		update_icon()

/obj/item/gun/energy/attackby(obj/item/C, mob/living/user)
	if(QUALITY_SAWING in C.tool_qualities)
		to_chat(user, SPAN_NOTICE("You begin to saw down \the [src]."))
		if(saw_off == FALSE)
			to_chat(user, SPAN_NOTICE("Sawing down \the [src] will achieve nothing or may impede operation."))
			return
		if (src.item_upgrades.len)
			if(src.dna_compare_samples) //or else you can override dna lock
				to_chat(user, SPAN_NOTICE("Sawing down \the [src] will not allow use of the firearm."))
				return
			if("No" == input(user, "There are attachments present. Would you like to destroy them?") in list("Yes", "No"))
				return
		if(saw_off && C.use_tool(user, src, WORKTIME_LONG, QUALITY_SAWING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			qdel(src)
			new sawn(usr.loc)
			to_chat(user, SPAN_WARNING("You cut down the stock, barrel, and anything else nice from \the [src], ruining a perfectly good weapon."))
	if(self_recharge)
		to_chat(usr, SPAN_WARNING("[src] is a self-charging gun, it doesn't need more batteries."))
		return
	if(disposable)
		to_chat(usr, SPAN_WARNING("[src] is a disposable gun, it doesn't need more batteries."))
		return

	if(istype(C, suitable_cell))
		if(cell)
			if(replace_item(cell, C, user))
				cell = C
				update_icon()
		else if(insert_item(C, user))
			cell = C
			update_icon()
	..()

/obj/item/gun/energy/attack_self(mob/user)
	if(!self_recharge && cell && cell.charge < charge_cost && eject_item(cell, user))
		cell = null
		update_icon()
		return
	..()

/obj/item/gun/energy/nano_ui_data(mob/user)
	var/list/data = ..()
	data["charge_cost"] = charge_cost
	var/obj/item/cell/C = get_cell()
	if(C)
		data["cell_charge"] = C.percent()
		data["shots_remaining"] = round(C.charge/charge_cost)
		data["max_shots"] = round(C.maxcharge/charge_cost)
	return data

/obj/item/gun/energy/get_dud_projectile()
	return new projectile_type

/obj/item/gun/energy/refresh_upgrades()
	//refresh our unique variables before applying upgrades too
	charge_cost = initial(charge_cost)
	overcharge_max = initial(overcharge_max)
	overcharge_rate = initial(overcharge_rate)
	..()

/obj/item/gun/energy/generate_guntags()
	..()
	gun_tags |= GUN_ENERGY
	if(istype(projectile_type, /obj/item/projectile/beam))
		gun_tags |= GUN_LASER
