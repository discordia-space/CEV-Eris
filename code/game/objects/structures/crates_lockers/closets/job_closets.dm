/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 *		Acolyte
 */

/*
 * Bartender
 */
/obj/structure/closet/69mcloset
	name = "Club69ana69er closet"
	desc = "A stora69e unit for formal clothin69."
	icon_door = "black"

/obj/structure/closet/69mcloset/populate_contents()
	new /obj/item/clothin69/head/that(src)
	new /obj/item/clothin69/head/that(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothin69/head/hairflower
	new /obj/item/clothin69/suit/stora69e/to6969le/club(src)
	new /obj/item/clothin69/under/rank/bartender(src)
	new /obj/item/clothin69/under/rank/bartender(src)
	new /obj/item/clothin69/suit/wcoat(src)
	new /obj/item/clothin69/suit/wcoat(src)
	new /obj/item/clothin69/shoes/color/black(src)
	new /obj/item/clothin69/shoes/color/black(src)
	new /obj/item/clothin69/under/rank/bartender/skirt(src)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "Club Worker closet"
	desc = "A stora69e unit for club personnel."
	icon_door = "black"

/obj/structure/closet/chefcloset/populate_contents()
	new /obj/item/clothin69/under/waiter(src)
	new /obj/item/clothin69/under/waiter(src)
	new /obj/item/clothin69/under/waiter/skirt(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/stora69e/box/mousetraps(src)
	new /obj/item/stora69e/box/mousetraps(src)
	new /obj/item/clothin69/under/rank/chef(src)
	new /obj/item/rea69ent_containers/69lass/beaker/bowl(src)
	new /obj/item/rea69ent_containers/69lass/beaker/bowl(src)
	new /obj/item/clothin69/head/chefhat(src)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "janitorial closet"
	desc = "A stora69e unit for janitorial clothes and 69ear."
	icon_door = "mixed"

/obj/structure/closet/jcloset/populate_contents()
	if(prob(50))
		new /obj/item/stora69e/backpack/sport/purple(src)
	else
		new /obj/item/stora69e/backpack/satchel(src)
	new /obj/item/clothin69/under/rank/janitor(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothin69/69loves/thick(src)
	new /obj/item/clothin69/head/soft/purple(src)
	new /obj/item/clothin69/head/beret/purple(src)
	new /obj/item/device/li69htin69/to6969leable/flashli69ht(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/device/li69htreplacer(src)
	new /obj/item/stora69e/ba69/trash(src)
	new /obj/item/clothin69/shoes/69aloshes(src)
	new /obj/item/mop(src)
	new /obj/item/soap/nanotrasen(src)
	new /obj/item/stora69e/pouch/small_69eneric(src) // Because I feel like poor janitor 69ets it bad.
	new /obj/item/tool/knife/da6969er/nt(src)

/obj/structure/closet/custodial
	name = "custodial closet"
	desc = "A stora69e unit for purifyin69 clothes and 69ear."
	icon_state = "custodian"

/obj/structure/closet/custodial/populate_contents()
	if(prob(25))
		new /obj/item/stora69e/backpack/neotheolo69y(src)
	else if(prob(25))
		new /obj/item/stora69e/backpack/sport/neotheolo69y(src)
	else
		new /obj/item/stora69e/backpack/satchel/neotheolo69y(src)
	new /obj/item/clothin69/under/rank/church(src)
	new /obj/item/stora69e/belt/utility/neotheolo69y(src)
	new /obj/item/device/radio/headset/church(src)
	new /obj/item/clothin69/69loves/thick(src)
	new /obj/item/clothin69/suit/armor/custodian(src)
	new /obj/item/clothin69/head/armor/custodian(src)
	new /obj/item/clothin69/head/soft/purple(src)
	new /obj/item/clothin69/head/beret/purple(src)
	new /obj/item/device/li69htin69/to6969leable/flashli69ht(src)
	new /obj/item/69un/matter/launcher/nt_sprayer(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/device/li69htreplacer(src)
	new /obj/item/stora69e/ba69/trash(src)
	new /obj/item/clothin69/shoes/69aloshes(src)
	new /obj/item/mop(src)
	new /obj/item/clothin69/under/rank/church/sport(src)
	new /obj/item/clothin69/suit/stora69e/neotheosports(src)
	new /obj/item/soap/nanotrasen(src)
	new /obj/item/stora69e/pouch/small_69eneric(src) // Because I feel like poor janitor 69ets it bad.
	new /obj/item/69un/ener69y/nt_svalinn(src)
	new /obj/item/cell/small/neotheolo69y(src)
	new /obj/item/cell/small/neotheolo69y(src)
	new /obj/item/tool/knife/da6969er/nt(src)
	new /obj/item/holyvacuum(src)
	new /obj/item/clothin69/shoes/jackboots/neotheolo69y(src)
/obj/structure/closet/acolyte
	name = "acolyte closet"
	desc = "A closet for those that work with the69achines of 69od."
	icon_state = "acolyte"

/obj/structure/closet/acolyte/populate_contents()
	if(prob(25))
		new /obj/item/stora69e/backpack/neotheolo69y(src)
	else if(prob(25))
		new /obj/item/stora69e/backpack/sport/neotheolo69y(src)
	else
		new /obj/item/stora69e/backpack/satchel/neotheolo69y(src)
	new /obj/item/clothin69/under/rank/acolyte(src)
	new /obj/item/clothin69/suit/stora69e/neotheolo69y_jacket(src)
	new /obj/item/stora69e/belt/tactical/neotheolo69y(src)
	new /obj/item/clothin69/mask/69as(src)
	new /obj/item/device/radio/headset/church(src)
	new /obj/item/clothin69/69loves/thick(src)
	new /obj/item/clothin69/under/rank/church/sport(src)
	new /obj/item/clothin69/suit/stora69e/neotheosports(src)
	new /obj/item/clothin69/head/armor/acolyte(src)
	new /obj/item/clothin69/suit/armor/acolyte(src)
	new /obj/item/69un/ener69y/nt_svalinn(src)
	new /obj/item/cell/small/neotheolo69y(src)
	new /obj/item/cell/small/neotheolo69y(src)
	new /obj/item/stora69e/belt/sheath(src)
	new /obj/item/tool/sword/nt/shortsword(src)
	new /obj/item/tool/knife/da6969er/nt(src)
	new /obj/item/clothin69/shoes/reinforced(src)
