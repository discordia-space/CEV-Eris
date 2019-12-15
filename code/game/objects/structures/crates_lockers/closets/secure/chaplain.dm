/obj/structure/closet/secure_closet/reinforced/chaplain
	name = "preacher's locker"
	req_access = list(access_chapel_office)
	icon_state = "head_preacher"

/obj/structure/closet/secure_closet/reinforced/chaplain/populate_contents()
	new /obj/item/clothing/under/rank/preacher(src)
	new /obj/item/clothing/under/rank/preacher(src)
	new /obj/item/device/radio/headset/church(src)
	new /obj/item/weapon/storage/belt/security/neotheology(src)
	new /obj/item/clothing/shoes/reinforced(src)
	new /obj/item/clothing/shoes/reinforced(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/deck/tarot(src)
	new /obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_boards (src)
	for (var/i in 1 to 10)
		new /obj/item/weapon/implant/core_implant/cruciform(src)
	new /obj/item/weapon/material/knife/neotritual(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/neotheology(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/neotheology(src)
