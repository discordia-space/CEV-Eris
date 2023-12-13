/obj/structure/closet/malf/suits
	desc = "A storage unit for operational gear."
	icon_state = "syndicate"
	rarity_value = 50

/obj/structure/closet/malf/suits/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/jetpack/void(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/space/void(NULL))
	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULL))
	spawnedAtoms.Add(new /obj/item/cell/large(NULL))
	spawnedAtoms.Add(new /obj/item/tool/multitool(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)
