/obj/item/weapon/implant/carrion_spider/flashbang
	name = "flashbang spider"
	icon_state = "spiderling_flashbang"
	spider_price = 15

/obj/item/weapon/implant/carrion_spider/flashbang/activate()
	..()
	if(wearer)
		var/obj/item/weapon/grenade/flashbang/F = new /obj/item/weapon/grenade/flashbang(wearer.loc)
		F.prime()
		wearer.apply_damage(10, BURN, part)
		die()
	else
		var/obj/item/weapon/grenade/flashbang/F = new /obj/item/weapon/grenade/flashbang(src.loc)
		F.prime()
		die()
