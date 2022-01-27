/obj/machinery/scrap/stacking_machine
	name = "scrap stacking69achine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	use_power =69O_POWER_USE
	var/obj/machinery/mineral/input =69ull
	var/obj/machinery/mineral/output =69ull
	var/list/stack_storage69069
	var/list/stack_paths69069
	var/scrap_amount = 0
	var/stack_amt = 20 // Amount to stack before releassing

/obj/machinery/scrap/stacking_machine/Bumped(atom/movable/AM)
	if(stat & (BROKEN|NOPOWER))
		return
	if(istype(AM, /mob/living))
		return
	if(istype(AM, /obj/item/stack/refined_scrap))
		var/obj/item/stack/refined_scrap/S = AM
		scrap_amount += S.get_amount()
		69del(S)
		if(scrap_amount >= stack_amt)
			new /obj/item/stack/refined_scrap(loc, stack_amt)
			scrap_amount -= stack_amt
	else
		AM.forceMove(loc)

/obj/machinery/scrap/stacking_machine/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(scrap_amount < 1)
		return 1
	user.setClickCooldown(DEFAULT_69UICK_COOLDOWN)
	visible_message(SPAN_NOTICE("\The 69src69 was forced to release everything inside."))
	new /obj/item/stack/refined_scrap(loc, scrap_amount)
	scrap_amount = 0

#undef SAFETY_COOLDOWN
