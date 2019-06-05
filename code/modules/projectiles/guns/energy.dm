/obj/item/weapon/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"

	var/charge_cost = 100 //How much energy is needed to fire.
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/medium
	var/cell_type = /obj/item/weapon/cell/medium/high
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0

/obj/item/weapon/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/weapon/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/weapon/gun/energy/Initialize()
	. = ..()
	if(self_recharge)
		cell = new cell_type(src)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/weapon/gun/energy/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/weapon/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!cell || cell.charge >= cell.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/weapon/cell/large/external = get_external_cell()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		cell.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/weapon/gun/energy/get_cell()
	return cell

/obj/item/weapon/gun/energy/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/weapon/gun/energy/consume_next_projectile()
	if(!cell) return null
	if(!ispath(projectile_type)) return null
	if(!cell.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/weapon/gun/energy/proc/get_external_cell()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/weapon/gun/energy/examine(mob/user)
	..(user)
	if(!cell)
		to_chat(user, SPAN_NOTICE("Has no battery cell inserted."))
		return
	var/shots_remaining = round(cell.charge / charge_cost)
	to_chat(user, "Has [shots_remaining] shot\s remaining.")
	return

/obj/item/weapon/gun/energy/update_icon(var/ignore_inhands)
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
	if(!ignore_inhands)
		update_wear_icon()

/obj/item/weapon/gun/energy/MouseDrop(over_object)
	if(!self_recharge)
		if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
			cell = null
			update_icon()
	else
		to_chat(usr, SPAN_WARNING("[src] is a self-charging gun, its batteries cannot be removed!."))

/obj/item/weapon/gun/energy/attackby(obj/item/C, mob/living/user)
	if(self_recharge)
		to_chat(usr, SPAN_WARNING("[src] is a self-charging gun, it doesn't need more batteries."))
		return

	if(cell)
		to_chat(usr, SPAN_WARNING("[src] is already loaded."))
		return

	if(istype(C, suitable_cell) && insert_item(C, user))
		cell = C
		update_icon()
