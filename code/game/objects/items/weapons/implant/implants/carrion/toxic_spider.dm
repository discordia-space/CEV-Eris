/obj/item/weapon/implant/carrion_spider/toxicbomb
	name = "toxic bomb spider"
	desc = "A spider bloated with noxious gasses, it looks ready to burst!"
	icon_state = "spiderling_toxicbomb"
	spider_price = 35
	var/datum/reagents/gas_storage

/obj/item/weapon/implant/carrion_spider/toxicbomb/activate()
	var/location = get_turf(src)
	gas_storage = new /datum/reagents(100, src)
	gas_storage.add_reagent("lexorin", 100)
	var/datum/effect/effect/system/smoke_spread/chem/S = new
	S.attach(location)
	S.set_up(gas_storage, 10, 100, location)
	spawn(0)
		S.start()
	die()
	..()
