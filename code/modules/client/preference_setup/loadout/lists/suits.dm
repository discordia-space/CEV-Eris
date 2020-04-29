// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 1

/datum/gear/suit/jacket
	display_name = "jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 2 //higher price because it has some armor value

/datum/gear/suit/jacket/New()
	..()
	var/jacket = list(
		"Bomber"		=	/obj/item/clothing/suit/storage/toggle/bomber,
		"Leather"		=	/obj/item/clothing/suit/storage/leather_jacket,
	)
	gear_tweaks += new /datum/gear_tweak/path(jacket)

/datum/gear/suit/hazard_vest
	display_name = "hazard vest"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hoodie
	display_name = "hoodie"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/black

/datum/gear/suit/hoodie/New()
	..()
	var/jacket = list(
		"Black"		=	/obj/item/clothing/suit/storage/toggle/hoodie/black,
		"Grey"		=	/obj/item/clothing/suit/storage/toggle/hoodie,
	)
	gear_tweaks += new /datum/gear_tweak/path(jacket)

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/poncho
	display_name = "poncho, tan"
	path = /obj/item/clothing/suit/poncho
	cost = 1

/datum/gear/suit/cyberpunksleek
	display_name = "sleek modern overcoat"
	path = /obj/item/clothing/suit/storage/cyberpunksleek
	cost = 2

/datum/gear/suit/cyberpunksleek_long
	display_name = "sleek modern longcoat"
	path = /obj/item/clothing/suit/storage/cyberpunksleek_long
	cost = 2