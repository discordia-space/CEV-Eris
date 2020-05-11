/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet"

/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "It's a storage unit for things that have no right being here."
	icon_state = "syndicate"
	anchored = 0

/obj/structure/closet/gimmick/russian
	name = "russian surplus closet"
	desc = "It's a storage unit for Russian standard-issue surplus."
	icon_state = "syndicate"

/obj/structure/closet/gimmick/russian/populate_contents()
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)


/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	icon_state = "syndicate"
	anchored = 1

/obj/structure/closet/thunderdome/New()
	..()

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"

/obj/structure/closet/thunderdome/tdred/populate_contents()
	new /obj/item/clothing/suit/armor/heavy/red(src)
	new /obj/item/clothing/suit/armor/heavy/red(src)
	new /obj/item/clothing/suit/armor/heavy/red(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/clothing/head/armor/helmet/thunderdome(src)
	new /obj/item/clothing/head/armor/helmet/thunderdome(src)
	new /obj/item/clothing/head/armor/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	icon_state = "syndicate"

/obj/structure/closet/thunderdome/tdgreen/populate_contents()
	new /obj/item/clothing/suit/armor/heavy/green(src)
	new /obj/item/clothing/suit/armor/heavy/green(src)
	new /obj/item/clothing/suit/armor/heavy/green(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/clothing/head/armor/helmet/thunderdome(src)
	new /obj/item/clothing/head/armor/helmet/thunderdome(src)
	new /obj/item/clothing/head/armor/helmet/thunderdome(src)

/obj/structure/closet/oldstyle
	name = "old closet"
	desc = "Old and rusty closet, probably older than you."
	icon_state = "oldstyle"
