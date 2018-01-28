/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	icon_state = "hydro"

/obj/structure/closet/secure_closet/hydroponics/populate_contents()
	..()
	new /obj/item/clothing/suit/apron(src)
	new /obj/item/weapon/storage/bag/plants(src)
	new /obj/item/clothing/under/rank/hydroponics(src)
	new /obj/item/device/scanner/analyzer/plant_analyzer(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/head/greenbandana(src)
	new /obj/item/weapon/material/minihoe(src)
	new /obj/item/weapon/material/hatchet(src)
	new /obj/item/weapon/tool/wirecutters(src)
	new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
