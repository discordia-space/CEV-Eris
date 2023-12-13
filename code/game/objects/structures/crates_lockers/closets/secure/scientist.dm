/obj/structure/closet/secure_closet/personal/scientist
	name = "moebius scientist's locker"
	req_access = list(access_rd)
	access_occupy = list(access_tox_storage)
	icon_state = "science"

/obj/structure/closet/secure_closet/personal/scientist/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/purple/scientist(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/purple/scientist(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/scientist(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat/science(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/jackboots(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sci(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tank/air(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/regular/goggles/clear(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/psychiartist
	name = "moebius psychiartist's locker"
	req_access = list(access_rd)
	access_occupy = list(access_psychiatrist)
	icon_state = "science"

/obj/structure/closet/secure_closet/personal/psychiartist/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/purple/scientist(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/purple/scientist(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/psych(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sci(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/medical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/regular/hipster(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/RD
	name = "Moebius Expedition Overseer locker"
	req_access = list(access_rd)
	icon_state = "rd"

/obj/structure/closet/secure_closet/reinforced/RD/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/leather/withwallet(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/bio_suit(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/bio_hood(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/expedition_overseer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/leather(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/latex(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/rd(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tank/air(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/regular/goggles/clear(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
