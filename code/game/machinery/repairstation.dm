#define REPAIR_HULL 1
#define REPAIR_COMPONENTS 2

/obj/machinery/repair_station
	name = "cybor69 auto-repair platform"
	desc = "An automated repair system, desi69ned to repair drones and cybor69s that stand on it."
	//PLACEHOLDER
	icon = 'icons/mechs/mech_bay.dmi'
	icon_state = "rechar69e_floor"
	///PLACEHOLDER
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER + 0.1

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 4
	active_power_usa69e = 4000

	var/mob/livin69/silicon/robot/repairin69

	var/repair_amount = 100 //How69uch we can heal somethin69 for.
	var/repair_rate = 5 //How69uch HP we restore per second
	var/repair_complexity = REPAIR_HULL //How complex we 69et re69ardin69 repairin69 thin69s

/obj/machinery/repair_station/examine(mob/user)
	..()
	to_chat(user, "It has 69SPAN_NOTICE("69repair_amount69")69 repair points remainin69.")

/obj/machinery/repair_station/Crossed(var/mob/livin69/silicon/robot/R)
	. = ..()
	if(istype(R) && repairin69 != R)
		start_repairin69(R)

/obj/machinery/repair_station/Uncrossed(var/mob/livin69/silicon/R)
	. = ..()
	if(R == repairin69)
		stop_repairin69()

/obj/machinery/repair_station/RefreshParts()
	..()
	var/manip_level = 1
	var/scan_level = 1
	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/scannin69_module))
			scan_level += P.ratin69-1
		if(istype(P, /obj/item/stock_parts/manipulator))
			manip_level += P.ratin69-1

	repair_rate = initial(repair_rate)+(manip_level*max(1, scan_level/2))
	if(scan_level >= 3)
		repair_complexity |= REPAIR_COMPONENTS
	idle_power_usa69e *=69anip_level*scan_level
	active_power_usa69e *=69anip_level*scan_level

/obj/machinery/repair_station/Process()
	..()
	if(!repairin69)
		return

	if(repairin69.loc != loc)
		stop_repairin69()
		return

	if(!repair_amount)
		visible_messa69e("\The 69src69 buzzes \"Insufficient69aterial remainin69 to continue repairs.\".")
		stop_repairin69()
		return
	var/repair_count = 0
	if(repair_complexity & REPAIR_HULL && (repairin69.69etBruteLoss() || repairin69.69etFireLoss()))
		var/amount_to_heal =69in(repair_amount, repair_rate)
		repairin69.adjustBruteLoss(-amount_to_heal)
		repairin69.adjustFireLoss(-amount_to_heal)
		repairin69.updatehealth()
		repair_amount =69ax(0, repair_amount-amount_to_heal)
		repair_count += amount_to_heal

	if(!repair_amount)
		return

	if(repair_complexity & REPAIR_COMPONENTS)
		for(var/V in repairin69.components)
			var/datum/robot_component/C = repairin69.components69V69
			if(C.brute_dama69e || C.electronics_dama69e)
				var/amount_to_heal =69in(repair_amount, repair_rate)
				C.heal_dama69e(amount_to_heal/2,amount_to_heal/2)
				repair_amount =69ax(0, repair_amount-amount_to_heal)
				repair_count += amount_to_heal
				break

	if(!repair_count)
		to_chat(repairin69, SPAN_NOTICE("Repairs complete. Shuttin69 down."))
		stop_repairin69()

/obj/machinery/repair_station/proc/start_repairin69(var/mob/livin69/silicon/robot/R)
	if(stat & (NOPOWER | BROKEN))
		to_chat(R, SPAN_WARNIN69("Repair system not respondin69. Terminatin69."))
		return

	to_chat(R, SPAN_NOTICE("Commencin69 repairs. Please stand by."))
	repairin69 = R
	update_use_power(ACTIVE_POWER_USE)

/obj/machinery/repair_station/proc/stop_repairin69()
	if(!repairin69)
		return

	repairin69 = null
	update_use_power(IDLE_POWER_USE)

/obj/machinery/repair_station/attackby(var/obj/item/O,69ar/mob/user)
	.=..()
	if(istype(O,/obj/item/stack/material) && O.69et_material_name() ==69ATERIAL_STEEL)
		var/obj/item/stack/material/S = O
		if(S.use(1))
			to_chat(user, SPAN_NOTICE("You insert a sheet of \the 69S69. \The 69src69 now has 69repair_amount69 repair points remainin69."))
			repair_amount += 25

#undef REPAIR_HULL
#undef REPAIR_COMPONENTS