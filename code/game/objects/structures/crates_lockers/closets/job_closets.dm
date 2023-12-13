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

	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULL))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULL))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/hairflower(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/club(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/bartender(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/bartender(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/wcoat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/wcoat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/bartender/skirt(NULL))
	for(var/atom/a in spawnedAtoms)
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

	spawnedAtoms.Add(new /obj/item/clothing/under/waiter(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/waiter(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/waiter/skirt(NULL))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULL))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULL))
	spawnedAtoms.Add(new /obj/item/storage/box/mousetraps(NULL))
	spawnedAtoms.Add(new /obj/item/storage/box/mousetraps(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/chef(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/drywet(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/drywet(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/chefhat(NULL))
	for(var/atom/a in spawnedAtoms)
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
		spawnedAtoms.Add(new /obj/item/storage/backpack/sport/purple(NULL))
	else
		spawnedAtoms.Add(new /obj/item/storage/backpack/satchel(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/janitor(NULL))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/purple(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/purple(NULL))
	spawnedAtoms.Add(new /obj/item/device/lighting/toggleable/flashlight(NULL))
	spawnedAtoms.Add(new /obj/item/caution(NULL))
	spawnedAtoms.Add(new /obj/item/caution(NULL))
	spawnedAtoms.Add(new /obj/item/caution(NULL))
	spawnedAtoms.Add(new /obj/item/caution(NULL))
	spawnedAtoms.Add(new /obj/item/device/lightreplacer(NULL))
	spawnedAtoms.Add(new /obj/item/storage/bag/trash(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/galoshes(NULL))
	spawnedAtoms.Add(new /obj/item/mop(NULL))
	spawnedAtoms.Add(new /obj/item/soap/nanotrasen(NULL))
	spawnedAtoms.Add(new /obj/item/storage/pouch/small_generic(NULL)) // Because I feel like poor janitor gets it bad.
	spawnedAtoms.Add(new /obj/item/tool/knife/dagger/nt(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
