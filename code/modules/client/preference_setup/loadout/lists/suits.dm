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
		"White"			=	/obj/item/clothing/suit/storage/drive_jacket,
		"Violet"		=	/obj/item/clothing/suit/storage/violet_jacket,
		"Tunnelsnake"	=	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_snake,
		"Sleek"			=	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake,
		"Jaeger"		=	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_jager
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

/datum/gear/suit/poncho/tactical
	display_name = "poncho, blue"
	path = /obj/item/clothing/suit/poncho/tactical
	cost = 1

/datum/gear/suit/coat
	display_name = "Modern overcoat"
	path = /obj/item/clothing/suit/storage/cyberpunksleek
	cost = 2

/datum/gear/suit/coat/New()
	..()
	var/coat = list(
		"Green"			=	/obj/item/clothing/suit/storage/cyberpunksleek/green,
		"Black"			=	/obj/item/clothing/suit/storage/cyberpunksleek/black,
		"White"			=	/obj/item/clothing/suit/storage/cyberpunksleek/white,
		"Brown"			=	/obj/item/clothing/suit/storage/cyberpunksleek
	)
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/longcoat
	display_name = "Modern long overcoat"
	path = /obj/item/clothing/suit/storage/cyberpunksleek_long
	cost = 2

/datum/gear/suit/longcoat/New()
	..()
	var/longcoat = list(
		"Green"			=	/obj/item/clothing/suit/storage/cyberpunksleek_long/green,
		"Black"			=	/obj/item/clothing/suit/storage/cyberpunksleek_long/black,
		"White"			=	/obj/item/clothing/suit/storage/cyberpunksleek_long/white,
		"Brown"			=	/obj/item/clothing/suit/storage/cyberpunksleek_long
	)
	gear_tweaks += new /datum/gear_tweak/path(longcoat)

/datum/gear/suit/bladerunner
	display_name = "old leather coat"
	path = /obj/item/clothing/suit/storage/bladerunner
	cost = 2

/datum/gear/suit/bomj
	display_name = "bomj coat"
	path = /obj/item/clothing/suit/storage/bomj
	cost = 2
