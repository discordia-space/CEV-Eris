/obj/structure/closet/secure_closet/chaplain
	name = "cyberchristian preacher's locker"
	req_access = list(access_chapel_office)
	icon_state = "preacher1"
	icon_closed = "preacher"
	icon_locked = "preacher1"
	icon_opened = "preacheropen"
	icon_broken = "preacherbroken"
	icon_off = "preacheroff"

	New()
		..()
		new /obj/item/clothing/under/rank/chaplain(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/suit/nun(src)
		new /obj/item/clothing/head/nun_hood(src)
		new /obj/item/clothing/suit/chaplain_hoodie(src)
		new /obj/item/clothing/head/chaplain_hood(src)
		new /obj/item/clothing/under/bride_white(src)
		new /obj/item/weapon/storage/fancy/candle_box(src)
		new /obj/item/weapon/storage/fancy/candle_box(src)
		new /obj/item/weapon/deck/tarot(src)
		new /obj/item/weapon/implant/external/core_implant/cruciform(src)
		new /obj/item/weapon/implant/external/core_implant/cruciform(src)
		new /obj/item/weapon/implant/external/core_implant/cruciform(src)
		return