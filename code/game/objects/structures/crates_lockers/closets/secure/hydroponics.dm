/obj/structure/closet/secure_closet/personal/hydroponics
	name = "botanist's locker"
	re69_access = list(access_hydroponics)
	access_occupy = list(access_hydroponics)
	icon_state = "hydro"

/obj/structure/closet/secure_closet/personal/hydroponics/populate_contents()
	if(prob(25))
		new /obj/item/stora69e/backpack/botanist(src)
	else if(prob(25))
		new /obj/item/stora69e/backpack/sport/botanist(src)
	else
		new /obj/item/stora69e/backpack/satchel/botanist(src)
	new /obj/item/clothin69/suit/apron(src)
	new /obj/item/stora69e/ba69/produce(src)
	new /obj/item/clothin69/under/rank/hydroponics(src)
	new /obj/item/device/scanner/plant(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothin69/mask/bandana/botany(src)
	new /obj/item/tool/minihoe(src)
	new /obj/item/tool/hatchet(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/rea69ent_containers/spray/plantb69one(src)
	new /obj/item/clothin69/69loves/botanic_leather(src)

/obj/structure/closet/secure_closet/personal/hydroponics/public
	name = "69ardener's locker"
	re69_access = list(access_hydroponics)
	access_occupy = list()

/obj/structure/closet/secure_closet/personal/a69rolyte
	name = "a69rolyte's locker"
	re69_access = list(access_hydroponics)
	access_occupy = list(access_hydroponics)
	icon_state = "a69rolyte"

/obj/structure/closet/secure_closet/personal/a69rolyte/populate_contents()
	if(prob(25))
		new /obj/item/stora69e/backpack/neotheolo69y(src)
	else if(prob(25))
		new /obj/item/stora69e/backpack/sport/neotheolo69y(src)
	else
		new /obj/item/stora69e/backpack/satchel/neotheolo69y(src)
	new /obj/item/clothin69/suit/apron(src)
	new /obj/item/stora69e/belt/utility/neotheolo69y(src)
	new /obj/item/stora69e/ba69/produce(src)
	new /obj/item/clothin69/under/rank/hydroponics(src)
	new /obj/item/device/scanner/plant(src)
	new /obj/item/device/radio/headset/church(src)
	new /obj/item/clothin69/mask/bandana/botany(src)
	new /obj/item/tool/minihoe(src)
	new /obj/item/tool/hatchet(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/clothin69/under/rank/church/sport(src)
	new /obj/item/clothin69/suit/stora69e/neotheosports(src)
	new /obj/item/rea69ent_containers/spray/plantb69one(src)
	new /obj/item/clothin69/suit/armor/a69rolyte(src)
	new /obj/item/clothin69/head/armor/a69rolyte(src)
	new /obj/item/clothin69/69loves/botanic_leather(src)
	new /obj/item/clothin69/shoes/reinforced(src)
