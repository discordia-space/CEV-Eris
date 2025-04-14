/datum/asset/spritesheet_batched/sheetmaterials
	name = "sheetmaterials"

/datum/asset/spritesheet_batched/sheetmaterials/create_spritesheets()
	insert_all_icons("", 'icons/obj/stack/material.dmi')
	// Special case on RCD objects
	insert_icon("rcd", 'icons/obj/ammo.dmi', "rcd")
