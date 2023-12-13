/obj/structure/closet/secure_closet/personal/scientist
	name = "moebius scientist's locker"
	req_access = list(access_rd)
	access_occupy = list(access_tox_storage)
	icon_state = "science"

/obj/structure/closet/secure_closet/personal/scientist/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/purple/scientist(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/purple/scientist(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/scientist(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat/science(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/jackboots(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sci(NULL))
	spawnedAtoms.Add(new  /obj/item/tank/air(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/regular/goggles/clear(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/psychiartist
	name = "moebius psychiartist's locker"
	req_access = list(access_rd)
	access_occupy = list(access_psychiatrist)
	icon_state = "science"

/obj/structure/closet/secure_closet/personal/psychiartist/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/purple/scientist(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/purple/scientist(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/psych(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sci(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/regular/hipster(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/RD
	name = "Moebius Expedition Overseer locker"
	req_access = list(access_rd)
	icon_state = "rd"

/obj/structure/closet/secure_closet/reinforced/RD/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/leather/withwallet(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/bio_suit(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/bio_hood(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/expedition_overseer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/leather(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/rd(NULL))
	spawnedAtoms.Add(new  /obj/item/tank/air(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/regular/goggles/clear(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
