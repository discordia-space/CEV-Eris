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
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/head/hairflower
	new /obj/item/clothing/suit/storage/toggle/club(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/suit/wcoat(src)
	new /obj/item/clothing/suit/wcoat(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/under/rank/bartender/skirt(src)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "Club Worker closet"
	desc = "A storage unit for club personnel."
	icon_door = "black"

/obj/structure/closet/chefcloset/populate_contents()
	new /obj/item/clothing/under/waiter(src)
	new /obj/item/clothing/under/waiter(src)
	new /obj/item/clothing/under/waiter/skirt(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/storage/box/mousetraps(src)
	new /obj/item/storage/box/mousetraps(src)
	new /obj/item/clothing/under/rank/chef(src)
	new /obj/item/reagent_containers/drywet(src)
	new /obj/item/reagent_containers/drywet(src)
	new /obj/item/clothing/head/chefhat(src)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "janitorial closet" //legacy janitor
	desc = "A storage unit for janitorial clothes and gear."
	icon_door = "mixed"

/obj/structure/closet/jcloset/populate_contents()
	if(prob(50))
		new /obj/item/storage/backpack/sport/purple(src)
	else
		new /obj/item/storage/backpack/satchel(src)
	new /obj/item/clothing/under/rank/janitor(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/head/soft/purple(src)
	new /obj/item/clothing/head/beret/purple(src)
	new /obj/item/device/lighting/toggleable/flashlight(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/mop(src)
	new /obj/item/soap/nanotrasen(src)
	new /obj/item/storage/pouch/small_generic(src) // Because I feel like poor janitor gets it bad.
	new /obj/item/tool/knife/dagger/nt(src)
