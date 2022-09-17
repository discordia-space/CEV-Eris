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
	cost = 2 //higher price because it has some armor value or style

/datum/gear/suit/jacket/New()
	..()
	var/jacket = list(
		"Bomber"				=	/obj/item/clothing/suit/storage/toggle/bomber,
		"Bomber, furred"		=	/obj/item/clothing/suit/storage/toggle/bomber/furred,
		"Service"				=	/obj/item/clothing/suit/storage/toggle/service,
		"Tactful"		=	/obj/item/clothing/suit/storage/khaki,
		"Leather"		=	/obj/item/clothing/suit/storage/leather_jacket,
		"White"			=	/obj/item/clothing/suit/storage/drive_jacket,
		"Violet"		=	/obj/item/clothing/suit/storage/violet_jacket,
		"Tunnelsnake"	=	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_snake,
		"Sleek"			=	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake,
		"Jaeger"		=	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_jager,
		"Boxer"			=	/obj/item/clothing/suit/storage/boxer_jacket
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

/datum/gear/suit/punkvest
	display_name = "punk vest"
	path = /obj/item/clothing/suit/punkvest
	cost = 1

/datum/gear/suit/punkvest/New()
	..()
	var/punkvest = list(
		"Punk"			=	/obj/item/clothing/suit/punkvest,
		"Cyberpunk"			=	/obj/item/clothing/suit/punkvest/cyber,
		"Windbreaker"			=	/obj/item/clothing/suit/storage/toggle/windbreaker,
	)
	gear_tweaks += new /datum/gear_tweak/path(punkvest)

/datum/gear/suit/puffypurple
	display_name = "purple puffy coat"
	path = /obj/item/clothing/suit/storage/puffypurple
	cost = 1
/datum/gear/suit/puffyblue
	display_name = "blue puffy coat"
	path = /obj/item/clothing/suit/storage/puffyblue
	cost = 1
/datum/gear/suit/puffyred
	display_name = "crimson puffy coat"
	path = /obj/item/clothing/suit/storage/puffyred
	cost = 1
