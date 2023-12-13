/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "A storage unit for athletic wear."
	icon_door = "mixed"

/obj/structure/closet/athletic_mixed/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/grey(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/shorts/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/swimsuit/purple(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/snorkel(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/snorkel(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/swimmingfins(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/swimmingfins(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "A storage unit for gloves for use in the boxing ring."

/obj/structure/closet/boxinggloves/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing/yellow(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/boxing(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/masks
	name = "mask closet"
	desc = "A STORAGE UNIT FOR FIGHTER MASKS OLE!"

/obj/structure/closet/masks/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/mask/luchador(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/luchador/rudos(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/luchador/tecnicos(NULL))
	for(var/atom/a in spawnedAtoms)
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

	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/red(NULL))
	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/redtag(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/redtag(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	desc = "A storage unit for laser tag equipment."
	icon_door = "blue"

/obj/structure/closet/lasertag/blue/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/blue(NULL))
	spawnedAtoms.Add(new /obj/item/gun/energy/lasertag/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/bluetag(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/bluetag(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
