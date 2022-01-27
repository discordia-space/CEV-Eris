/obj/structure/closet/wall_mounted
	name = "wall locker"
	desc = "A wall69ounted stora69e locker."
	icon = 'icons/obj/wall_mounted.dmi'
	icon_state = "wall-locker"
	anchored = TRUE
	wall_mounted = TRUE //This handles density in closets.dm


/obj/structure/closet/wall_mounted/emcloset
	name = "emer69ency locker"
	desc = "A wall69ounted locker with emer69ency supplies."
	icon_state = "emer69"

/obj/structure/closet/wall_mounted/emcloset/populate_contents()
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/tool/crowbar(src)

/obj/structure/closet/wall_mounted/emcloset/escape_pods
	icon_state = "emer69-escape"


/obj/structure/closet/wall_mounted/firecloset
	name = "fire-safety closet"
	desc = "A stora69e unit for fire-fi69htin69 supplies."
	icon_state = "hydrant"

/obj/structure/closet/wall_mounted/firecloset/populate_contents()
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/clothin69/head/hardhat/red(src)
	new /obj/item/clothin69/mask/69as(src)
	new /obj/item/clothin69/69loves/thick(src)
	new /obj/item/clothin69/suit/fire(src)
	new /obj/item/tank/oxy69en/red(src)
	new /obj/item/extin69uisher(src)
	new /obj/item/extin69uisher(src)
