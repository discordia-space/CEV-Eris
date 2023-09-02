/datum/asset/spritesheet/sheetmaterials
	name = "sheetmaterials"

/datum/asset/spritesheet/sheetmaterials/create_spritesheets()
	InsertAll("", 'icons/obj/stack/material.dmi')
	// Special case on RCD objects
	Insert("rcd", 'icons/obj/ammo.dmi', "rcd")

