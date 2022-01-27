/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten plasma tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	w_class = ITEM_SIZE_HUGE
	layer = BELOW_OBJ_LAYER
	spawn_tags = SPAWN_TAG_STRUCTURE_COMMON
	rarity_value = 50
	var/oxygentanks = 10
	var/plasmatanks = 10
	var/list/oxytanks = list()	//sorry for the similar69ar names
	var/list/platanks = list()


/obj/structure/dispenser/oxygen
	plasmatanks = 0
	rarity_value = 10

/obj/structure/dispenser/plasma
	oxygentanks = 0
	rarity_value = 25


/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()


/obj/structure/dispenser/update_icon()
	overlays.Cut()
	switch(oxygentanks)
		if(1 to 3)	overlays += "oxygen-69oxygentanks69"
		if(4 to INFINITY) overlays += "oxygen-4"
	switch(plasmatanks)
		if(1 to 4)	overlays += "plasma-69plasmatanks69"
		if(5 to INFINITY) overlays += "plasma-5"

/obj/structure/dispenser/attack_ai(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "69src69<br><br>"
	dat += "Oxygen tanks: 69oxygentanks69 - 69oxygentanks ? "<A href='?src=\ref69src69;oxygen=1'>Dispense</A>" : "empty"69<br>"
	dat += "Plasma tanks: 69plasmatanks69 - 69plasmatanks ? "<A href='?src=\ref69src69;plasma=1'>Dispense</A>" : "empty"69"
	user << browse(dat, "window=dispenser")
	onclose(user, "dispenser")


/obj/structure/dispenser/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/tank/oxygen) || istype(I, /obj/item/tank/air) || istype(I, /obj/item/tank/anesthetic))
		if(oxygentanks < 10)
			user.drop_item()
			I.forceMove(src)
			oxytanks.Add(I)
			oxygentanks++
			to_chat(user, SPAN_NOTICE("You put 69I69 in 69src69."))
			if(oxygentanks < 5)
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("69src69 is full."))
		updateUsrDialog()
		return
	if(istype(I, /obj/item/tank/plasma))
		if(plasmatanks < 10)
			user.drop_item()
			I.forceMove(src)
			platanks.Add(I)
			plasmatanks++
			to_chat(user, SPAN_NOTICE("You put 69I69 in 69src69."))
			if(plasmatanks < 6)
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("69src69 is full."))
		updateUsrDialog()
		return
	if(69UALITY_BOLT_TURNING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_BOLT_TURNING, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
			if(anchored)
				to_chat(user, SPAN_NOTICE("You lean down and unwrench 69src69."))
				anchored = FALSE
			else
				to_chat(user, SPAN_NOTICE("You wrench 69src69 into place."))
				anchored = TRUE
			return

/obj/structure/dispenser/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)

	var/obj/item/tank/tank
	if(href_list69"oxygen"69 && oxygentanks > 0)
		if(oxytanks.len)
			tank = oxytanks69oxytanks.len69	// Last stored tank is always the first one to be dispensed
			oxytanks.Remove(tank)
		else
			tank = new /obj/item/tank/oxygen(loc)
		oxygentanks--
	if(href_list69"plasma"69 && plasmatanks > 0)
		if(platanks.len)
			tank = platanks69platanks.len69
			platanks.Remove(tank)
		else
			tank = new /obj/item/tank/plasma(loc)
		plasmatanks--

	if(tank)
		tank.forceMove(drop_location())
		to_chat(usr, SPAN_NOTICE("You take 69tank69 out of 69src69."))
		update_icon()

	playsound(usr.loc, 'sound/machines/Custom_extout.ogg', 100, 1)
	updateUsrDialog()
