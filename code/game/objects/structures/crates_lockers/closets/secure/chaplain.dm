/obj/structure/closet/secure_closet/chaplain
	name = "cyberchristian preacher's locker"
	req_access = list(access_chapel_office)
	icon_state = "preacher"

/obj/structure/closet/secure_closet/chaplain/populate_contents()
	..()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/reinforced(src)
	new /obj/item/clothing/shoes/reinforced(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/deck/tarot(src)
	for (var/i=1, i<=10, i++)
		new /obj/item/weapon/implant/core_implant/cruciform(src)
	new /obj/item/weapon/material/knife/neotritual(src)
