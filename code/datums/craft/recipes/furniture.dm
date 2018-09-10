/datum/craft_recipe/furniture
	category = "Furniture"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF



/datum/craft_recipe/furniture/railing
	name = "railing"
	result = /obj/structure/railing
	steps = (
		list(/obj/item/stack/material/steel, 4),
	)

/datum/craft_recipe/furniture/table
	name = "table frame"
	result = /obj/structure/table
	steps = (
		list(/obj/item/stack/material/steel, 2),
	)

/datum/craft_recipe/furniture/rack
	name = "rack"
	result = /obj/structure/table/rack
	steps = (
		list(/obj/item/stack/material/steel, 2),
	)

/datum/craft_recipe/furniture/shelf
	name = "shelf"
	result = /obj/structure/table/rack/shelf
	steps = (
		list(/obj/item/stack/material/steel, 3),
	)

/datum/craft_recipe/furniture/closet
	name = "closet"
	result = /obj/structure/closet
	steps = (
		list(/obj/item/stack/material/steel, 3),
	)


// Office chairs
/datum/craft_recipe/furniture/office_chair
	name = "dark office chair"
	result = /obj/structure/bed/chair/office/dark
	steps = list(
		list(/obj/item/stack/material/steel, 5),
	)

/datum/craft_recipe/furniture/office_chair/light
	name = "light office chair"
	result = /obj/structure/bed/chair/office/light

// Comfy chairs
/datum/craft_recipe/furniture/comfy_chair
	name = "beige comfy chair"
	result = /obj/structure/bed/chair/comfy/beige
	steps = (
		list(/obj/item/stack/material/steel, 5),
	)

/datum/craft_recipe/furniture/comfy_chair/black
	name = "black comfy chair"
	result = /obj/structure/bed/chair/comfy/black

/datum/craft_recipe/furniture/comfy_chair/brown
	name = "brown comfy chair"
	result = /obj/structure/bed/chair/comfy/brown

/datum/craft_recipe/furniture/comfy_chair/lime
	name = "lime comfy chair"
	result = /obj/structure/bed/chair/comfy/lime

/datum/craft_recipe/furniture/comfy_chair/teal
	name = "teal comfy chair"
	result = /obj/structure/bed/chair/comfy/teal

/datum/craft_recipe/furniture/comfy_chair/red
	name = "red comfy chair"
	result = /obj/structure/bed/chair/comfy/red

/datum/craft_recipe/furniture/comfy_chair/blue
	name = "blue comfy chair"
	result = /obj/structure/bed/chair/comfy/blue

/datum/craft_recipe/furniture/comfy_chair/purple
	name = "purple comfy chair"
	result = /obj/structure/bed/chair/comfy/purp

/datum/craft_recipe/furniture/comfy_chair/green
	name = "green comfy chair"
	result = /obj/structure/bed/chair/comfy/green


