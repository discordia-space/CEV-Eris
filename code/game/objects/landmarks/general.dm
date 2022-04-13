/obj/landmark/IH_Armoury_Gun_Serial_Printer
	name = "Gun serial ref sheet landmark"
	desc = "Grabs all the guns in the area , prints a paper with all their serials"

/obj/landmark/IH_Armoury_Gun_Serial_Printer/Initialize()
	..()
	. = INITIALIZE_HINT_LATELOAD

/obj/landmark/IH_Armoury_Gun_Serial_Printer/LateInitialize()
	. = ..()
	var/area/our_area = get_area(src)
	var/text = "CEV ERIS IHS Armoury gun serials \n"
	for(var/obj/item/gun/firearm in our_area.contents)
		if(firearm.serial_type)
			text += "[firearm.serial_type] - [firearm.name] \n"
	new /obj/item/paper(get_turf(src), text, "IH Armoury log")
	delete_me = TRUE

