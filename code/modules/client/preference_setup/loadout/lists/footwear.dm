// Shoelocker
/datum/gear/shoes
	display_name = "workboots"
	path = /obj/item/clothing/shoes/workboots
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/jackboots
	display_name = "jackboots, selection"
	path = /obj/item/clothing/shoes/jackboots

/datum/gear/shoes/jackboots/New()
	..()
	var/jackboots = list(
		"Standard"			=	/obj/item/clothing/shoes/jackboots,
		"Duty"				=	/obj/item/clothing/shoes/jackboots/duty,
		"Duty, long"		=	/obj/item/clothing/shoes/jackboots/duty/long,
		"Service"			= 	/obj/item/clothing/shoes/jackboots/ironhammer,
		"Oberth"			= 	/obj/item/clothing/shoes/jackboots/german
	)
	gear_tweaks += new /datum/gear_tweak/path(jackboots)


/datum/gear/shoes/workboots
	display_name = "workboots"
	path = /obj/item/clothing/shoes/workboots

/datum/gear/shoes/sandals
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal

/datum/gear/shoes/lacey
	display_name = "shoes, classy"
	path = /obj/item/clothing/shoes/reinforced

/datum/gear/shoes/lacey
	display_name = "classy shoes, selection"
	path = /obj/item/clothing/shoes/reinforced

/datum/gear/shoes/lacey/New()
	..()
	var/lacey = list(
		"Standard"			=	/obj/item/clothing/shoes/reinforced,
		"Leather"			=	/obj/item/clothing/shoes/leather,
		"Service"			=	/obj/item/clothing/shoes/reinforced/ironhammer
	)
	gear_tweaks += new /datum/gear_tweak/path(lacey)



/*//Same with /datum/gear/shoes/lacey

/datum/gear/shoes/dress
	display_name = "shoes, dress"
	path = /obj/item/clothing/shoes/reinforced*/

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
		"Black"			=	/obj/item/clothing/shoes/color/black,
		"White"			=	/obj/item/clothing/shoes/color/white,
		"Grey"			= 	/obj/item/clothing/shoes/color/grey,
		"Brown"			=	/obj/item/clothing/shoes/color/brown,
		"Red"			=	/obj/item/clothing/shoes/color/red,
		"Orange"		=	/obj/item/clothing/shoes/color/orange,
		"Yellow"		=	/obj/item/clothing/shoes/color/yellow,
		"Green"			=	/obj/item/clothing/shoes/color/green,
		"Blue"			=	/obj/item/clothing/shoes/color/blue,
		"Purple"		=	/obj/item/clothing/shoes/color/purple
	)
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/sneaker_colors
	display_name = "sneakers, color presets"
	path = /obj/item/clothing/shoes/sneakersred

/datum/gear/shoes/sneaker_colors/New()
	..()
	var/sneaker_colors = list(
		"Red" 		=	 /obj/item/clothing/shoes/sneakersred,
		"Blue" 		=	 /obj/item/clothing/shoes/sneakersblue,
		"Purple"	=	 /obj/item/clothing/shoes/sneakerspurple
	)
	gear_tweaks += new /datum/gear_tweak/path(sneaker_colors)

/datum/gear/shoes/spurs
	display_name = "spurs"
	path = /obj/item/clothing/shoes/spurs
