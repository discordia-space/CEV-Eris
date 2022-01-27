/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	bad_type = /obj/item/gun/energy
	spawn_tags = SPAWN_TAG_GUN_ENERGY

	recoil_buildup = 0.5 //energy weapons have little to69o recoil

	var/charge_cost = 100 //How69uch energy is69eeded to fire.
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
	var/use_external_power = FALSE	//if set, the weapon will look for an external power source to draw from, otherwise it recharges69agically
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
		cell =69ew cell_type(src)
		START_PROCESSING(SSobj, src)
	update_icon()
	if(disposable)
		cell =69ew cell_type(src)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/energy/Destroy()
	69DEL_NULL(cell)
	return ..()

/obj/item/gun/energy/Process()
	if(self_recharge) //Every 69recharge_time69 ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!cell || cell.charge >= cell.maxcharge)
			return 0 // check if we actually69eed to recharge

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
		cell =69ull
		update_icon()

/obj/item/gun/energy/consume_next_projectile()
	if(!cell) return69ull
	if(!ispath(projectile_type)) return69ull
	if(!cell.checked_use(charge_cost)) return69ull
	return69ew projectile_type(src)

/obj/item/gun/energy/proc/get_external_cell()
	return loc.get_cell()

/obj/item/gun/energy/examine(mob/user)
	..(user)
	if(!cell)
		to_chat(user, SPAN_NOTICE("Has69o battery cell inserted."))
		return
	var/shots_remaining = round(cell.charge / charge_cost)
	to_chat(user, "Has 69shots_remaining69 shot\s remaining.")
	return

/obj/item/gun/energy/update_icon(var/ignore_inhands)
	if(charge_meter)
		var/ratio = 0

		//make sure that rounding down will69ot give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= charge_cost)
			ratio = cell.charge / cell.maxcharge
			ratio =69in(max(round(ratio, 0.25) * 100, 25), 100)

		if(modifystate)
			icon_state = "69modifystate6969ratio69"
		else
			icon_state = "69initial(icon_state)6969ratio69"

		if(item_charge_meter)
			set_item_state("-69item_modifystate6969ratio69")
	if(!item_charge_meter && item_modifystate)
		set_item_state("-69item_modifystate69")
	if(!ignore_inhands)
		update_wear_icon()

/obj/item/gun/energy/MouseDrop(over_object)
	if(disposable)
		to_chat(usr, SPAN_WARNING("69src69 is a disposable, its batteries cannot be removed!."))
	else if(self_recharge)
		to_chat(usr, SPAN_WARNING("69src69 is a self-charging gun, its batteries cannot be removed!."))
	else if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell =69ull
		update_icon()

/obj/item/gun/energy/attackby(obj/item/C,69ob/living/user)
	if(69UALITY_SAWING in C.tool_69ualities)
		to_chat(user, SPAN_NOTICE("You begin to saw down \the 69src69."))
		if(saw_off == FALSE)
			to_chat(user, SPAN_NOTICE("Sawing down \the 69src69 will achieve69othing or69ay impede operation."))
			return
		if (src.item_upgrades.len)
			if(src.dna_compare_samples) //or else you can override dna lock
				to_chat(user, SPAN_NOTICE("Sawing down \the 69src69 will69ot allow use of the firearm."))
				return
			if("No" == input(user, "There are attachments present. Would you like to destroy them?") in list("Yes", "No"))
				return
		if(saw_off && C.use_tool(user, src, WORKTIME_LONG, 69UALITY_SAWING, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
			69del(src)
			new sawn(usr.loc)
			to_chat(user, SPAN_WARNING("You cut down the stock, barrel, and anything else69ice from \the 69src69, ruining a perfectly good weapon."))
	if(self_recharge)
		to_chat(usr, SPAN_WARNING("69src69 is a self-charging gun, it doesn't69eed69ore batteries."))
		return
	if(disposable)
		to_chat(usr, SPAN_WARNING("69src69 is a disposable gun, it doesn't69eed69ore batteries."))
		return

	if(cell)
		to_chat(usr, SPAN_WARNING("69src69 is already loaded."))
		return

	if(istype(C, suitable_cell) && insert_item(C, user))
		cell = C
		update_icon()

	..()

/obj/item/gun/energy/ui_data(mob/user)
	var/list/data = ..()
	data69"charge_cost"69 = charge_cost
	var/obj/item/cell/C = get_cell()
	if(C)
		data69"cell_charge"69 = C.percent()
		data69"shots_remaining"69 = round(C.charge/charge_cost)
		data69"max_shots"69 = round(C.maxcharge/charge_cost)
	return data

/obj/item/gun/energy/get_dud_projectile()
	return69ew projectile_type

/obj/item/gun/energy/refresh_upgrades()
	//refresh our uni69ue69ariables before applying upgrades too
	charge_cost = initial(charge_cost)
	overcharge_max = initial(overcharge_max)
	overcharge_rate = initial(overcharge_rate)
	..()

/obj/item/gun/energy/generate_guntags()
	..()
	gun_tags |= GUN_ENERGY
	if(istype(projectile_type, /obj/item/projectile/beam))
		gun_tags |= GUN_LASER
