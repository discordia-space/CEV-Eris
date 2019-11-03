// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/weapon/cell //Basic type of the cells, should't be used by itself
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "b_st"
	item_state = "cell"
	origin_tech = list(TECH_POWER = 1)
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 100
	var/max_chargerate = 0.08 //Power cells are limited in how much power they can intake per charge tick, to prevent small cells from charging almost instantly
	//Default 8% of maximum
	//A tick is roughly 2 seconds, so this means a cell will take a minimum of 25 seconds to charge
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	var/autorecharging = FALSE //For nucclear cells
	var/autorecharge_rate = 0.03
	var/recharge_time = 4 //How often nuclear cells will recharge
	var/charge_tick = 0
	var/last_charge_status = -1 //used in update_icon optimization

/obj/item/weapon/cell/Initialize()
	. = ..()
	charge = maxcharge
	update_icon()
	if(autorecharging)
		START_PROCESSING(SSobj, src)

/obj/item/weapon/cell/Process()
	charge_tick++
	if(charge_tick < recharge_time) return 0
	charge_tick = 0
	give(maxcharge * autorecharge_rate)

	// If installed in a gun, update gun icon to reflect new charge level.
	if(istype(loc, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/I = loc
		I.update_icon()

	return 1

//Newly manufactured cells start off empty. You can't create energy
/obj/item/weapon/cell/Created()
	charge = 0
	update_icon()

/obj/item/weapon/cell/drain_power(var/drain_check, var/surge, var/power = 0)

	if(drain_check)
		return 1

	if(charge <= 0)
		return 0

	var/cell_amt = power * CELLRATE

	return use(cell_amt) / CELLRATE

/obj/item/weapon/cell/update_icon()
	var/charge_status
	var/c = charge/maxcharge
	if (c >=0.95)
		charge_status = 100
	else if (c >=0.75)
		charge_status = 75
	else if (c >=0.50)
		charge_status = 50
	else if (c >=0.25)
		charge_status = 25
	else if (c >=0.01)
		charge_status = 0

	if (charge_status == last_charge_status)
		return

	overlays.Cut()
	if (charge_status != null)
		overlays += image('icons/obj/power_cells.dmi', "[icon_state]_[charge_status]")

	last_charge_status = charge_status


/obj/item/weapon/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

/obj/item/weapon/cell/proc/fully_charged()
	return (charge == maxcharge)

// checks if the power cell is able to provide the specified amount of charge
/obj/item/weapon/cell/proc/check_charge(var/amount)
	return (charge >= amount)

// use power from a cell, returns the amount actually used
/obj/item/weapon/cell/proc/use(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0
	var/used = min(charge, amount)
	charge -= used
	update_icon()
	return used

// Checks if the specified amount can be provided. If it can, it removes the amount
// from the cell and returns 1. Otherwise does nothing and returns 0.
/obj/item/weapon/cell/proc/checked_use(var/amount)
	if(!check_charge(amount))
		return 0
	use(amount)
	return 1

// recharge the cell
/obj/item/weapon/cell/proc/give(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(maxcharge < amount)	return 0
	var/amount_used = min(maxcharge-charge,amount)
	charge += amount_used
	update_icon()
	return amount_used


/obj/item/weapon/cell/examine(mob/user)
	if(!..(user,2))
		return

	to_chat(user, "The manufacturer's label states this cell has a power rating of [maxcharge], and that you should not swallow it.")
	to_chat(user, "The charge meter reads [round(src.percent() )]%.")

/obj/item/weapon/cell/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W

		to_chat(user, "You inject the solution into the power cell.")

		if(S.reagents.has_reagent("plasma", 5))

			rigged = 1

			log_admin("LOG: [user.name] ([user.ckey]) injected a power cell with plasma, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a power cell with plasma, rigging it to explode.")

		S.reagents.clear_reagents()


/obj/item/weapon/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if (charge==0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge)/60)
	var/light_impact_range = round(sqrt(charge)/30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = 0
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)

	log_admin("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")
	message_admins("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")

	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)

	qdel(src)

/obj/item/weapon/cell/proc/corrupt()
	charge /= 2
	maxcharge /= 2
	if (prob(10))
		rigged = 1 //broken batterys are dangerous

/obj/item/weapon/cell/emp_act(severity)
	//remove this once emp changes on dev are merged in
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		severity *= R.cell_emp_mult

	// Lose 1/2, 1/4, 1/6 of the current charge per hit or 1/4, 1/8, 1/12 of the max charge per hit, whichever is highest
	charge -= max(charge / (2 * severity), maxcharge/(4 * severity))
	if (charge < 0)
		charge = 0
	..()

/obj/item/weapon/cell/ex_act(severity)

	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
			if (prob(50))
				corrupt()
		if(3.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(25))
				corrupt()
	return

/obj/item/weapon/cell/proc/get_electrocute_damage()
	switch (charge)
/*		if (9000 to INFINITY)
			return min(rand(90,150),rand(90,150))
		if (2500 to 9000-1)
			return min(rand(70,145),rand(70,145))
		if (1750 to 2500-1)
			return min(rand(35,110),rand(35,110))
		if (1500 to 1750-1)
			return min(rand(30,100),rand(30,100))
		if (750 to 1500-1)
			return min(rand(25,90),rand(25,90))
		if (250 to 750-1)
			return min(rand(20,80),rand(20,80))
		if (100 to 250-1)
			return min(rand(20,65),rand(20,65))*/
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000-1)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000-1)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000-1)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000-1)
			return min(rand(10,20),rand(10,20))
		else
			return 0

/obj/item/weapon/cell/get_cell()
	return src
