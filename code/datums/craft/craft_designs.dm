/*
For use in defining designs for crafting stations.
Based on /datum/design of \code\datums\autolathe\autolathe_datums.dm

("firearm grips", "firearm barrels", "pistol mechanisms", "revolver mechanisms", "pump-action mechanisms", "self-reloading mechanisms", ".35 caliber", ".40 caliber", ".20 caliber", ".25 caliber", ".30 caliber", "shotgun shells", "special munitions")

*/

/datum/design/makeshift
	var/subcategory = "miscellaneous" // One level is not enough
	build_type = MAKESHIFT

/datum/design/makeshift/AssembleDesignUIData()
	..()
	nano_ui_data["subcategory"] = subcategory

/datum/design/makeshift/grip
	name = "shotgun shells (slug)"
	build_path = /obj/item/ammo_casing/shotgun/prespawned
