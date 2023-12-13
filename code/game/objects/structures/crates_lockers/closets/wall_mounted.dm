/obj/structure/closet/wall_mounted
	name = "wall locker"
	desc = "A wall mounted storage locker."
	icon = 'icons/obj/wall_mounted.dmi'
	icon_state = "wall-locker"
	anchored = TRUE
	wall_mounted = TRUE //This handles density in closets.dm


/obj/structure/closet/wall_mounted/emcloset
	name = "emergency locker"
	desc = "A wall mounted locker with emergency supplies."
	icon_state = "emerg"

/obj/structure/closet/wall_mounted/emcloset/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wall_mounted/emcloset/escape_pods
	icon_state = "emerg-escape"


/obj/structure/closet/wall_mounted/firecloset
	name = "fire-safety closet"
	desc = "A storage unit for fire-fighting supplies."
	icon_state = "hydrant"

/obj/structure/closet/wall_mounted/firecloset/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/inflatable/door(NULL))
	spawnedAtoms.Add(new /obj/item/inflatable/door(NULL))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/ointment(NULL))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/ointment(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/fire(NULL))
	spawnedAtoms.Add(new /obj/item/tank/oxygen/red(NULL))
	spawnedAtoms.Add(new /obj/item/extinguisher(NULL))
	spawnedAtoms.Add(new /obj/item/extinguisher(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
