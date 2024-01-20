/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "A storage unit for athletic wear."
	icon_door = "mixed"

/obj/structure/closet/athletic_mixed/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/grey(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/purple(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/snorkel(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/snorkel(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/swimmingfins(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/swimmingfins(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "A storage unit for gloves for use in the boxing ring."

/obj/structure/closet/boxinggloves/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing/yellow(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/masks
	name = "mask closet"
	desc = "A STORAGE UNIT FOR FIGHTER MASKS OLE!"

/obj/structure/closet/masks/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/mask/luchador(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/luchador/rudos(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/luchador/tecnicos(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/lasertag
	bad_type = /obj/structure/closet/lasertag
	rarity_value = 20
	spawn_tags = SPAWN_TAG_CLOSET_LASERTAG

/obj/structure/closet/lasertag/red
	name = "red laser tag equipment"
	desc = "A storage unit for laser tag equipment."
	icon_door = "red"

/obj/structure/closet/lasertag/red/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/redtag(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/redtag(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	desc = "A storage unit for laser tag equipment."
	icon_door = "blue"

/obj/structure/closet/lasertag/blue/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/bluetag(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/bluetag(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
