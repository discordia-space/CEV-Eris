/obj/item/device/Created()
	world << "Device created"
	.=..()
	//Quick and precise method to get rid of cells
	for (var/obj/item/weapon/cell/C in contents)
		world << "Checking cell C"
		for (var/a in vars)
			world << "Checking var [a]"
			if (vars[a] == C)
				vars[a] = null
				qdel(C)