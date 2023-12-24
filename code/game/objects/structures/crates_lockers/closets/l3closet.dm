/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "A storage unit for level-3 biohazard gear."
	icon_state = "bio"

/obj/structure/closet/l3closet/general

/obj/structure/closet/l3closet/general/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/bio_suit(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/bio_hood(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/l3closet/virology
	icon_door = "bio_viro"

/obj/structure/closet/l3closet/virology/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/bio_suit(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/bio_hood(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tank/oxygen(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/l3closet/security
	icon_door = "bio_sec"

/obj/structure/closet/l3closet/security/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/bio_suit(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/bio_hood(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/l3closet/janitor
	icon_door = "bio_jan"

/obj/structure/closet/l3closet/janitor/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/bio_suit(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/bio_hood(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/l3closet/scientist

/obj/structure/closet/l3closet/scientist/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/bio_suit(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/bio_hood(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
