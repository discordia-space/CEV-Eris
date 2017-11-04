/obj/structure/closet/secure_closet/cargotech
	name = "guild technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"

	New()
		..()
		new /obj/item/clothing/under/rank/cargotech(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/clothing/gloves/thick(src)
		new /obj/item/clothing/head/soft(src)
		new /obj/item/device/export_scanner(src)
		return

/obj/structure/closet/secure_closet/quartermaster
	name = "guild merchant's locker"
	req_access = list(access_merchant)
	icon_state = "secureqm1"


	New()
		..()
		new /obj/item/clothing/under/rank/cargotech(src)
		new /obj/item/clothing/shoes/color/brown(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/clothing/gloves/thick(src)
		new /obj/item/clothing/suit/fire/firefighter(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/clothing/head/soft(src)
		new /obj/item/weapon/gun/projectile/shotgun/pump(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/device/export_scanner(src)
		return
