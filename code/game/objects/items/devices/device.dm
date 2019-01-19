/obj/item/device/Created()
	.=..()
	//Quick and precise method to get rid of cells
	for (var/obj/item/weapon/cell/C in contents)
		for (var/a in vars)
			if (vars[a] == C)
				vars[a] = null
				qdel(C)