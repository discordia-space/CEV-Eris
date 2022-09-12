// Gloves
/datum/gear/gloves
	slot = slot_gloves
	sort_category = "Gloves and Handwear"
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/latex

/datum/gear/gloves/work
	display_name = "gloves, work"
	path = /obj/item/clothing/gloves/thick
	cost = 3

/datum/gear/gloves/rainbow
	display_name = "gloves, rainbow"
	path = /obj/item/clothing/gloves/color/rainbow
	cost = 2

/datum/gear/gloves/colored
	display_name = "gloves, colored"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/gloves/color

/datum/gear/gloves/color_presets
	display_name = "gloves, color presets"
	path = /obj/item/clothing/gloves/color/blue

/datum/gear/gloves/color_presets/New()
	..()
	var/gloves = list(
		"Blue"			= 	/obj/item/clothing/gloves/color/blue,
		"Yellow"		= 	/obj/item/clothing/gloves/color/yellow,
		"White"			= 	/obj/item/clothing/gloves/color/white,
		"Red"			= 	/obj/item/clothing/gloves/color/red,
		"Purple"		= 	/obj/item/clothing/gloves/color/purple,
		"Orange"		= 	/obj/item/clothing/gloves/color/orange,
		"Grey"			= 	/obj/item/clothing/gloves/color/grey,
		"Green"			=	/obj/item/clothing/gloves/color/green,
		"Light-Brown"	=	/obj/item/clothing/gloves/color/light_brown,
		"Brown"			=	/obj/item/clothing/gloves/color/brown
	)
	gear_tweaks += new /datum/gear_tweak/path(gloves)

/datum/gear/gloves/german
	display_name = "gloves, oberth"
	path = /obj/item/clothing/gloves/german
	cost = 3

/datum/gear/gloves/fingerless
	display_name = "gloves, fingerless"
	path = /obj/item/clothing/gloves/fingerless

/datum/gear/gloves/aerostatic
	display_name = "gloves, aerostatic"
	path = /obj/item/clothing/gloves/aerostatic
