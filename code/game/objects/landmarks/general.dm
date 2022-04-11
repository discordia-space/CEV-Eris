/obj/landmark/gun_paper_gen
	name = "Gun serial ref sheet landmark"

/obj/landmark/gun_paper_gen/Initialize()
	..()
	. = INITIALIZE_HINT_LATELOAD

/obj/landmark/gun_paper_gen/LateInitialize()
	. = ..()
	var/area/our_area = get_area(src)
	var/text = "CEV ERIS IHS Armoury gun serials \n"
	for(var/obj/item/gun/firearm in our_area.contents)
		if(firearm.serial_type)
			text += "[firearm.serial_type] - [firearm.name] \n"
	new /obj/item/paper(get_turf(src), text, "IH Armoury log")
	delete_me = TRUE

