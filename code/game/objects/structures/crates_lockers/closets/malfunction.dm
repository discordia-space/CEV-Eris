/obj/structure/closet/malf/suits
	desc = "It's a storage unit for operational gear."
	icon_state = "syndicate"

/obj/structure/closet/malf/suits/populate_contents()
	..()
	new /obj/item/weapon/tank/jetpack/void(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/helmet/space/void(src)
	new /obj/item/clothing/suit/space/void(src)
	new /obj/item/weapon/tool/crowbar(src)
	new /obj/item/weapon/cell/large(src)
	new /obj/item/weapon/tool/multitool(src)
