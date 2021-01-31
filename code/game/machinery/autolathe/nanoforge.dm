/obj/machinery/autolathe/nanoforge
	name = "matter nanoforge"
	desc = "It consumes items and produces compressed matter."
	icon_state = "nanoforge"
	icon = 'icons/obj/machines/autolathe.dmi'
	use_oddities = TRUE

/obj/machinery/autolathe/nanoforge/icon_off()
	. = ..()
	if(. || !inspiration)
		icon_state = initial(icon_state)
		icon_state = "[icon_state]_off"

/obj/machinery/autolathe/nanoforge/check_user(mob/user)
	if(user.stats.getPerk(PERK_TECHNOMANCER) || user.stat_check(STAT_MEC, STAT_LEVEL_EXPERT))
		return TRUE
	to_chat(user, SPAN_NOTICE("you have not how to make it work [src]"))
	return FALSE

	..()
	var/mb_rating = 0
	var/mb_amount = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
		mb_amount++

	storage_capacity = round(initial(storage_capacity)*(mb_rating/mb_amount))

	var/man_rating = 0
	var/man_amount = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating
		man_amount++
	man_rating -= man_amount

	var/las_rating = 0
	var/las_amount = 0
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts)
		las_rating += M.rating
		las_amount++
	las_rating -= las_amount

	speed = initial(speed) + man_rating + las_rating
	mat_efficiency = max(0.2, 1 - (man_rating * 0.1))
