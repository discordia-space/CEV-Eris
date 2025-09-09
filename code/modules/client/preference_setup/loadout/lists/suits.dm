// Suit slot
/datum/gear/suit
	display_name = "apron, yellow"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"

/datum/gear/suit/jacket
	display_name = "jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 1 //higher price because it has some armor value or style (old)
	//I'm dropping the price because the style is the same either way
	//and a few extra points in armor roundstart is useless 5 minutes into the round anyways

/datum/gear/suit/jacket/New()
	..()
	var/jacket = list(
		"Bomber" 			= 	/obj/item/clothing/suit/storage/toggle/bomber,
		"Bomber, furred" 	= 	/obj/item/clothing/suit/storage/toggle/bomber/furred,
		"Service" 			= 	/obj/item/clothing/suit/storage/toggle/service,
		"Tactful" 			= 	/obj/item/clothing/suit/storage/khaki,
		"Leather" 			= 	/obj/item/clothing/suit/storage/leather_jacket,
		"White" 			= 	/obj/item/clothing/suit/storage/drive_jacket,
		"Violet" 			= 	/obj/item/clothing/suit/storage/violet_jacket,
		"Windbreaker" 		=	/obj/item/clothing/suit/storage/toggle/windbreaker,
		"Boxer" 			= 	/obj/item/clothing/suit/storage/boxer_jacket
	)
	gear_tweaks += new /datum/gear_tweak/path(jacket)

/datum/gear/suit/hazard_vest
	display_name = "hazard vest"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/hazard_vest = list(
		"Orange"		=	/obj/item/clothing/suit/storage/hazardvest,
		"Dark Orange"	=	/obj/item/clothing/suit/storage/hazardvest/orange,
		"Grey" 			=	/obj/item/clothing/suit/storage/hazardvest/black
	)
	gear_tweaks += new /datum/gear_tweak/path(hazard_vest)

/datum/gear/suit/hoodie
	display_name = "hoodie"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/black

/datum/gear/suit/hoodie/New()
	..()
	var/jacket = list(
		"Black"		=	/obj/item/clothing/suit/storage/toggle/hoodie/black,
		"Grey"		=	/obj/item/clothing/suit/storage/toggle/hoodie
	)
	gear_tweaks += new /datum/gear_tweak/path(jacket)

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/poncho
	display_name = "poncho, color selection"
	path = /obj/item/clothing/suit/poncho

/datum/gear/suit/poncho/New()
	..()
	var/poncho = list(
		"Tan"		=	/obj/item/clothing/suit/poncho,
		"Blue"		=	/obj/item/clothing/suit/poncho/tactical
	)
	gear_tweaks += new /datum/gear_tweak/path(poncho)

/datum/gear/suit/coat
	display_name = "Modern overcoat"
	path = /obj/item/clothing/suit/storage/cyberpunksleek

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

/datum/gear/suit/punkvest
	display_name = "punk vest"
	path = /obj/item/clothing/suit/punkvest
	cost = 1

/datum/gear/suit/punkvest/New()
	..()
	var/punkvest = list(
		"Punk" 			=	/obj/item/clothing/suit/punkvest,
		"Cyberpunk" 	=	/obj/item/clothing/suit/punkvest/cyber,
		"Sleek" 		= 	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake,
		"Tunnelsnake" 	= 	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_snake,
		"Jaeger" 		= 	/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_jager
	)
	gear_tweaks += new /datum/gear_tweak/path(punkvest)

/datum/gear/suit/puffy
	display_name = "puffy coat"
	path = /obj/item/clothing/suit/storage/puffyred
	cost = 1

/datum/gear/suit/puffy/New()
	..()
	var/puffy = list(
		"Red Puffy" 		=	 /obj/item/clothing/suit/storage/puffyred,
		"Blue Puffy" 		=	 /obj/item/clothing/suit/storage/puffyblue,
		"Purple Puffy"	 	=	 /obj/item/clothing/suit/storage/puffypurple
	)
	gear_tweaks += new /datum/gear_tweak/path(puffy)

/datum/gear/suit/bomj
	display_name = "bomj coat"
	path = /obj/item/clothing/suit/storage/bomj

/datum/gear/suit/guild/black
	display_name = "black guild coat"
	path = /obj/item/clothing/suit/storage/cargo_jacket/black
	allowed_roles = list(JOBS_GUILD)

/datum/gear/suit/guild/black/old
	display_name = "old black guild coat"
	path = /obj/item/clothing/suit/storage/cargo_jacket/black/old
	allowed_roles = list(JOBS_GUILD)

