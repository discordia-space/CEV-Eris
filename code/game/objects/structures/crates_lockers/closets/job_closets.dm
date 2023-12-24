/* Closets for specific jobs
 * Contains:
 *		Club Manager
 *      Club Worker
 *		Janitor
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "Club Manager closet"
	desc = "A storage unit for formal clothing."
	icon_door = "black"

/obj/structure/closet/gmcloset/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/hairflower(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/club(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/bartender(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/bartender(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/wcoat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/wcoat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/bartender/skirt(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "Club Worker closet"
	desc = "A storage unit for club personnel."
	icon_door = "black"

/obj/structure/closet/chefcloset/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/waiter(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/waiter(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/waiter/skirt(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/mousetraps(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/mousetraps(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/chef(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/drywet(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/drywet(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/chefhat(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "janitorial closet" //legacy janitor
	desc = "A storage unit for janitorial clothes and gear."
	icon_door = "mixed"

/obj/structure/closet/jcloset/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new /obj/item/storage/backpack/sport/purple(NULLSPACE))
	else
		spawnedAtoms.Add(new /obj/item/storage/backpack/satchel(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/janitor(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/purple(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/purple(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/lighting/toggleable/flashlight(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/lightreplacer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/bag/trash(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/galoshes(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/mop(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/soap/nanotrasen(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pouch/small_generic(NULLSPACE)) // Because I feel like poor janitor gets it bad.
	spawnedAtoms.Add(new /obj/item/tool/knife/dagger/nt(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
