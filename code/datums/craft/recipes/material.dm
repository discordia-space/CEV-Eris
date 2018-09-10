/datum/craft_recipe/material
	category = "Material"


/datum/craft_recipe/material/baseballbat
	name = "baseball bat"
	result = /obj/item/weapon/material/twohanded/baseballbat
	steps = list(
		list(/obj/item/stack/material/steel, 6, time = 20)
	)

/datum/craft_recipe/material/grenade_casing
	name = "grenade casing"
	result = /obj/item/weapon/grenade/chem_grenade
	steps = list(
		list(/obj/item/stack/material/steel, 2)
	)

