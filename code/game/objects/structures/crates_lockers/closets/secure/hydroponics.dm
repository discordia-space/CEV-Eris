/obj/structure/closet/secure_closet/personal/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	access_occupy = list(access_hydroponics)
	icon_state = "hydro"

/obj/structure/closet/secure_closet/personal/hydroponics/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/botanist(NULLSPACE))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/botanist(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/botanist(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/apron(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/bag/produce(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/hydroponics(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/scanner/plant(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_service(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/bandana/botany(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/minihoe(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/hatchet(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/wirecutters(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/spray/plantbgone(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/botanic_leather(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/hydroponics/public
	name = "gardener's locker"
	req_access = list(access_hydroponics)
	access_occupy = list()
