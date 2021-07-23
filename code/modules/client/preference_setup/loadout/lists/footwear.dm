// Shoelocker
/datum/gear/shoes
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/jackboots
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/workboots
	display_name = "workboots"
	path = /obj/item/clothing/shoes/workboots

/datum/gear/shoes/sandals
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal


/datum/gear/shoes/lacey
	display_name = "shoes, classy"
	path = /obj/item/clothing/shoes/reinforced

/*//Same with /datum/gear/shoes/lacey

/datum/gear/shoes/dress
	display_name = "shoes, dress"
	path = /obj/item/clothing/shoes/reinforced*/

/datum/gear/shoes/leather
	display_name = "shoes, leather"
	path = /obj/item/clothing/shoes/leather

/datum/gear/shoes/rainbow
	display_name = "shoes, rainbow"
	path = /obj/item/clothing/shoes/color/rainbow

/datum/gear/shoes/colorable
	display_name = "shoes, colorable"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/shoes/color

/datum/gear/shoes/color_presets
	display_name = "shoes, color presets"
	path = /obj/item/clothing/shoes/color/black

/datum/gear/shoes/color_presets/New()
	..()
	var/shoes = list(
		"White"			=	/obj/item/clothing/shoes/color/white,
		"Black"			=	/obj/item/clothing/shoes/color/black,
		"Brown"			=	/obj/item/clothing/shoes/color/brown,
		"Red"			=	/obj/item/clothing/shoes/color/red,
		"Orange"		=	/obj/item/clothing/shoes/color/orange,
		"Yellow"		=	/obj/item/clothing/shoes/color/yellow,
		"Green"			=	/obj/item/clothing/shoes/color/green,
		"Blue"			=	/obj/item/clothing/shoes/color/blue,
		"Purple"		=	/obj/item/clothing/shoes/color/purple,
	)
	gear_tweaks += new /datum/gear_tweak/path(shoes)
