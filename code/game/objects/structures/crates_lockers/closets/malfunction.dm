/obj/structure/closet/malf/suits
	desc = "A storage unit for operational gear."
	icon_state = "syndicate"
	rarity_value = 50

/obj/structure/closet/malf/suits/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/jetpack/void(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/space/void(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/cell/large(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/multitool(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
