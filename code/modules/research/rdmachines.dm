//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

var/list/default_material_composition = list(MATERIAL_STEEL = 0, MATERIAL_GLASS = 0, MATERIAL_GOLD = 0, MATERIAL_SILVER = 0, MATERIAL_PLASMA = 0, MATERIAL_URANIUM = 0, MATERIAL_DIAMOND = 0)
/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console

	var/list/materials = list()

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/proc/getMaterialType(var/name)
	switch(name)
		if(MATERIAL_STEEL)
			return /obj/item/stack/material/steel
		if(MATERIAL_GLASS)
			return /obj/item/stack/material/glass
		if(MATERIAL_GOLD)
			return /obj/item/stack/material/gold
		if(MATERIAL_SILVER)
			return /obj/item/stack/material/silver
		if(MATERIAL_PLASMA)
			return /obj/item/stack/material/plasma
		if(MATERIAL_URANIUM)
			return /obj/item/stack/material/uranium
		if(MATERIAL_DIAMOND)
			return /obj/item/stack/material/diamond
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	switch(type)
		if(/obj/item/stack/material/steel)
			return MATERIAL_STEEL
		if(/obj/item/stack/material/glass)
			return MATERIAL_GLASS
		if(/obj/item/stack/material/gold)
			return MATERIAL_GOLD
		if(/obj/item/stack/material/silver)
			return MATERIAL_SILVER
		if(/obj/item/stack/material/plasma)
			return MATERIAL_PLASMA
		if(/obj/item/stack/material/uranium)
			return MATERIAL_URANIUM
		if(/obj/item/stack/material/diamond)
			return MATERIAL_DIAMOND

/obj/machinery/r_n_d/proc/eject(var/material, var/amount)
	if(!(material in materials))
		return
	var/obj/item/stack/material/sheetType = getMaterialType(material)
	var/perUnit = initial(sheetType.perunit)
	var/eject = round(materials[material] / perUnit)
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return
	var/obj/item/stack/material/S = new sheetType(loc)
	S.amount = eject
	materials[material] -= eject * perUnit