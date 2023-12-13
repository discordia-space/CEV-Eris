/obj/structure/closet/secure_closet/personal/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	access_occupy = list(access_hydroponics)
	icon_state = "hydro"

/obj/structure/closet/secure_closet/personal/hydroponics/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/botanist(NULL))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/botanist(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/botanist(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/apron(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/bag/produce(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/hydroponics(NULL))
	spawnedAtoms.Add(new  /obj/item/device/scanner/plant(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_service(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/bandana/botany(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/minihoe(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/hatchet(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/wirecutters(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/spray/plantbgone(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/botanic_leather(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/hydroponics/public
	name = "gardener's locker"
	req_access = list(access_hydroponics)
	access_occupy = list()
