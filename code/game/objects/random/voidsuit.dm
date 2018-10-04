/obj/random/voidsuit
	name = "random voidsuit"
	var/damaged = FALSE
	var/list/suitmap = list(
		/obj/item/clothing/suit/space/void = /obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering,
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining,
		/obj/item/clothing/suit/space/void/medical = /obj/item/clothing/head/helmet/space/void/medical,
		/obj/item/clothing/suit/space/void/security = /obj/item/clothing/head/helmet/space/void/security,
		/obj/item/clothing/suit/space/void/atmos = /obj/item/clothing/head/helmet/space/void/atmos,
		/obj/item/clothing/suit/space/void/merc = /obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/suit/space/void/wizard = /obj/item/clothing/head/helmet/space/void/wizard
	)
	has_postspawn = TRUE
/obj/random/voidsuit/item_to_spawn()
	return pickweight(list(
		/obj/item/clothing/suit/space/void = 2,
		/obj/item/clothing/suit/space/void/engineering = 2,
		/obj/item/clothing/suit/space/void/mining = 2,
		/obj/item/clothing/suit/space/void/medical = 2.3,
		/obj/item/clothing/suit/space/void/security = 1,
		/obj/item/clothing/suit/space/void/atmos = 1.5,
		/obj/item/clothing/suit/space/void/merc = 0.5,
		/obj/item/clothing/suit/space/void/wizard = 0.5
	))



/obj/random/voidsuit/post_spawn(var/list/spawns)
	for (var/obj/item/clothing/suit/space/void/suit in spawns)
		var/helmet = suitmap[suit.type]
		if (helmet)
			new helmet(loc)
		else
			log_debug("random_obj (voidsuit): Type [suit.type] was unable to spawn a matching helmet!")
		new /obj/item/clothing/shoes/magboots(loc)
		if (damaged && prob(60))
			suit.create_breaches(pick(BRUTE, BURN), rand(1, 5))


/obj/random/voidsuit/damaged
	damaged = TRUE