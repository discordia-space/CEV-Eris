/obj/structure/salvageable
	name = "broken macninery"
	desc = "Broken beyond repair, but looks like you can still salvage something from this."
	icon = 'icons/obj/salvageable.dmi'
	density = 1
	anchored = 1
	var/salvageable_parts = list()

/obj/structure/salvageable/proc/dismantle()
	new /obj/machinery/constructable_frame/machine_frame (src.loc)
	for(var/path in salvageable_parts)
		if(prob(salvageable_parts[path]))
			new path (loc)
	return

/obj/structure/salvageable/attackby(obj/item/I, mob/user)
	if(I.get_tool_type(usr, list(QUALITY_PRYING)))
		user << SPAN_NOTICE("You start salvage anything useful from \the [src].")
		if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_PRYING, FAILCHANCE_NORMAL, required_stat = STAT_PRD))
			dismantle()
			qdel(src)
			return

//Types themself, use them, but not the parent object


/obj/structure/salvageable/machine
	icon_state = "machine"
	salvageable_parts = list(
		/obj/item/weapon/stock_parts/console_screen = 80,
		/obj/item/stack/cable_coil{amount = 5} = 80,
		/obj/item/weapon/stock_parts/capacitor = 40,
		/obj/item/weapon/stock_parts/capacitor = 40,
		/obj/item/weapon/stock_parts/scanning_module = 40,
		/obj/item/weapon/stock_parts/scanning_module = 40,
		/obj/item/weapon/stock_parts/manipulator = 40,
		/obj/item/weapon/stock_parts/manipulator = 40,
		/obj/item/weapon/stock_parts/micro_laser = 40,
		/obj/item/weapon/stock_parts/micro_laser = 40,
		/obj/item/weapon/stock_parts/matter_bin = 40,
		/obj/item/weapon/stock_parts/matter_bin = 40,
		/obj/item/weapon/stock_parts/capacitor/adv = 20,
		/obj/item/weapon/stock_parts/scanning_module/adv = 20,
		/obj/item/weapon/stock_parts/manipulator/nano = 20,
		/obj/item/weapon/stock_parts/micro_laser/high = 20,
		/obj/item/weapon/stock_parts/matter_bin/adv = 20,
	)

/obj/structure/salvageable/autolathe
	icon_state = "autolathe"
	salvageable_parts = list(
		/obj/item/weapon/stock_parts/console_screen = 80,
		/obj/item/stack/cable_coil{amount = 5} = 80,
		/obj/item/weapon/stock_parts/capacitor = 40,
		/obj/item/weapon/stock_parts/scanning_module = 40,
		/obj/item/weapon/stock_parts/manipulator = 40,
		/obj/item/weapon/stock_parts/micro_laser = 40,
		/obj/item/weapon/stock_parts/micro_laser = 40,
		/obj/item/weapon/stock_parts/micro_laser = 40,
		/obj/item/weapon/stock_parts/matter_bin = 40,
		/obj/item/weapon/stock_parts/matter_bin = 40,
		/obj/item/weapon/stock_parts/matter_bin = 40,
		/obj/item/weapon/stock_parts/matter_bin = 40,
		/obj/item/weapon/stock_parts/capacitor/adv = 20,
		/obj/item/weapon/stock_parts/micro_laser/high = 20,
		/obj/item/weapon/stock_parts/micro_laser/high = 20,
		/obj/item/weapon/stock_parts/matter_bin/adv = 20,
		/obj/item/weapon/stock_parts/matter_bin/adv = 20,
		/obj/item/stack/material/steel{amount = 20} = 40,
		/obj/item/stack/material/glass{amount = 20} = 40,
		/obj/item/stack/material/plastic{amount = 20} = 40,
		/obj/item/stack/material/plasteel{amount = 10} = 40,
		/obj/item/stack/material/silver{amount = 10} = 20,
		/obj/item/stack/material/gold{amount = 10} = 20,
		/obj/item/stack/material/plasma{amount = 10} = 20,
	)
