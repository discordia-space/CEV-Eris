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

/obj/machinery/r_n_d/proc/eject(var/material, var/amount)
	if(!(material in materials))
		return
	var/eject = materials[material]
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return

	var/stack_type = material_stack_type(material)

	var/obj/item/stack/material/S = new stack_type(loc)
	S.amount = eject
	materials[material] -= eject
