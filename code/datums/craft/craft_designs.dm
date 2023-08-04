/*
For use in defining designs for crafting stations.
Based on /datum/design of \code\datums\autolathe\autolathe_datums.dm

("firearm grips", "firearm barrels", "pistol mechanisms", "revolver mechanisms", "pump-action mechanisms", "self-loading mechanisms", ".35 caliber", ".40 caliber", ".20 caliber", ".25 caliber", ".30 caliber", "shotgun shells", "special munitions")

*/

/datum/design/makeshift
	category = "miscellaneous"
	build_type = MAKESHIFT
	quality = 2

/datum/design/makeshift/AssembleDesignName(atom/temp_atom)
	if(!name && temp_atom)
		name = temp_atom.name

	item_name = name

	if(name_category)
		name = "[name_category] ([item_name])"

	name = capitalize(name)

// grips

/datum/design/makeshift/grip
	name = "makeshift grip"
	category = "firearm grips"
	build_path = /obj/item/part/gun/modular/grip/makeshift

/datum/design/makeshift/grip/wood
	name = "wood grip"
	build_path = /obj/item/part/gun/modular/grip/wood
	minimum_quality = 0

// barrels

/datum/design/makeshift/barrel
	name = ".35 barrel"
	category = "firearm barrels"
	build_path = /obj/item/part/gun/modular/barrel/pistol

/datum/design/makeshift/barrel/magnum
	name = ".40 barrel"
	build_path = /obj/item/part/gun/modular/barrel/magnum
	minimum_quality = 0

/datum/design/makeshift/barrel/srifle
	name = ".20 barrel"
	build_path = /obj/item/part/gun/modular/barrel/srifle
	minimum_quality = 0

/datum/design/makeshift/barrel/clrifle
	name = ".25 barrel"
	build_path = /obj/item/part/gun/modular/barrel/clrifle
	minimum_quality = 1

/datum/design/makeshift/barrel/lrifle
	name = ".30 barrel"
	build_path = /obj/item/part/gun/modular/barrel/lrifle
	minimum_quality = 0

/datum/design/makeshift/barrel/shotgun
	name = ".50 shotgun barrel"
	build_path = /obj/item/part/gun/modular/barrel/shotgun

/datum/design/makeshift/barrel/antim
	name = ".60 barrel"
	build_path = /obj/item/part/gun/modular/barrel/antim
	minimum_quality = 2

// cheap barrels (guhh)

/datum/design/makeshift/barrel/steel
	name = "cheap .35 barrel"
	build_path = /obj/item/part/gun/modular/barrel/pistol/steel
	quality = -1

/datum/design/makeshift/barrel/magnum/steel
	name = "cheap .40 barrel"
	build_path = /obj/item/part/gun/modular/barrel/magnum/steel
	quality = -1

/datum/design/makeshift/barrel/srifle/steel
	name = "cheap .20 barrel"
	build_path = /obj/item/part/gun/modular/barrel/srifle/steel
	quality = -1

/datum/design/makeshift/barrel/clrifle/steel
	name = "cheap .25 barrel"
	build_path = /obj/item/part/gun/modular/barrel/clrifle/steel
	quality = -1

/datum/design/makeshift/barrel/lrifle/steel
	name = "cheap .30 barrel"
	build_path = /obj/item/part/gun/modular/barrel/lrifle/steel
	quality = -1

/datum/design/makeshift/barrel/shotgun/steel
	name = "cheap .50 shotgun barrel"
	build_path = /obj/item/part/gun/modular/barrel/shotgun/steel
	quality = -1

// generic mechanisms

/datum/design/makeshift/mechanism
	name = "generic pistol mechanism"
	category = "pistol mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/pistol

/datum/design/makeshift/mechanism/revolver
	name = "generic revolver mechanism"
	category = "revolver mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/revolver

/datum/design/makeshift/mechanism/shotgun
	name = "generic shotgun mechanism"
	category = "pump-action mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/shotgun

/datum/design/makeshift/mechanism/smg
	name = "generic SMG mechanism"
	category = "SMG mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/smg

// cheap mechanisms

/datum/design/makeshift/mechanism/pistol/steel
	name = "cheap pistol mechanism"
	build_path = /obj/item/part/gun/modular/mechanism/pistol/steel
	quality = -1

/datum/design/makeshift/mechanism/revolver/steel
	name = "cheap revolver mechanism"
	build_path = /obj/item/part/gun/modular/mechanism/revolver/steel
	quality = -1

/datum/design/makeshift/mechanism/shotgun/steel
	name = "cheap shotgun mechanism"
	build_path = /obj/item/part/gun/modular/mechanism/shotgun/steel
	quality = -1

/datum/design/makeshift/mechanism/smg/steel
	name = "cheap SMG mechanism"
	build_path = /obj/item/part/gun/modular/mechanism/smg/steel
	quality = -1

/datum/design/makeshift/mechanism/autorifle/steel
	name = "cheap self-loading mechanism (debug)"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/steel
	quality = -1

// rifle mechanisms

/datum/design/makeshift/mechanism/autorifle
	name = "generic self-loading mechanism (debug)"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle

/datum/design/makeshift/mechanism/autorifle/simple
	name = "simplified self-loading mechanism"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/simple

/datum/design/makeshift/mechanism/autorifle/basic
	name = "basic self-loading mechanism"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/basic
	minimum_quality = 0

/datum/design/makeshift/mechanism/autorifle/heavy
	name = "heavy self-loading mechanism"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/heavy
	minimum_quality = 1

/datum/design/makeshift/mechanism/autorifle/light
	name = "light self-loading mechanism"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/light
	minimum_quality = 1

/datum/design/makeshift/mechanism/autorifle/determined
	name = "determined self-loading mechanism"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/determined
	minimum_quality = 2

/datum/design/makeshift/mechanism/autorifle/sharpshooter
	name = "sharpshooter self-loading mechanism"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/sharpshooter
	minimum_quality = 2

/datum/design/makeshift/mechanism/autorifle/marksman
	name = "marksman self-loading mechanism"
	category = "self-loading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle/marksman
	minimum_quality = 2

// .35

/datum/design/makeshift/mags_pistol
	name = "empty standard magazine (.35 Auto)"
	category = ".35 caliber"
	build_path = /obj/item/ammo_magazine/pistol/empty

/datum/design/makeshift/mags_pistol/hpistol
	name = "empty highcap magazine (.35 Auto)"
	build_path = /obj/item/ammo_magazine/hpistol/empty
	minimum_quality = 0

/datum/design/makeshift/mags_pistol/smg
	name = "empty SMG magazine (.35 Auto)"
	build_path = /obj/item/ammo_magazine/smg/empty

/datum/design/makeshift/mags_pistol/sl
	name = "empty speed loader (.35 Auto)"
	build_path = /obj/item/ammo_magazine/slpistol/empty

/datum/design/makeshift/mags_pistol/casings
	name = "scrap ammunition pile (.35 Auto)"
	build_path = /obj/item/ammo_casing/pistol/scrap/prespawned

// .40

/datum/design/makeshift/mags_magnum
	name = "empty magazine (.40 Magnum)"
	category = ".40 caliber"
	build_path = /obj/item/ammo_magazine/magnum/empty

/datum/design/makeshift/mags_magnum/msmg
	name = "empty SMG magazine (.40 Magnum)"
	build_path = /obj/item/ammo_magazine/msmg/empty
	minimum_quality = 0

/datum/design/makeshift/mags_magnum/sl
	name = "empty speed loader (.40 Magnum)"
	build_path = /obj/item/ammo_magazine/slmagnum/empty

/datum/design/makeshift/mags_magnum/casings
	name = "scrap ammunition pile (.40 Magnum)"
	build_path = /obj/item/ammo_casing/magnum/scrap/prespawned

// .20

/datum/design/makeshift/mags_srifle
	name = "empty magazine (.20 Rifle)"
	category = ".20 caliber"
	build_path = /obj/item/ammo_magazine/srifle/empty

/datum/design/makeshift/mags_srifle/long
	name = "empty extended magazine (.20 Rifle)"
	build_path = /obj/item/ammo_magazine/srifle/long/empty
	minimum_quality = 1

/datum/design/makeshift/mags_srifle/drum
	name = "empty drum magazine (.20 Rifle)"
	build_path = /obj/item/ammo_magazine/srifle/drum/empty
	minimum_quality = 2

/datum/design/makeshift/mags_srifle/sl
	name = "empty ammo strip (.20 Rifle)"
	build_path = /obj/item/ammo_magazine/slsrifle/empty

/datum/design/makeshift/mags_srifle/casings
	name = "scrap ammunition pile (.20 Rifle)"
	build_path = /obj/item/ammo_casing/srifle/scrap/prespawned

// .30

/datum/design/makeshift/mags_lrifle
	name = "empty magazine (.30 Rifle)"
	category = ".30 caliber"
	build_path = /obj/item/ammo_magazine/lrifle/empty

/datum/design/makeshift/mags_lrifle/drum
	name = "empty drum magazine (.30 Rifle)"
	build_path = /obj/item/ammo_magazine/lrifle/drum/empty
	minimum_quality = 1

/datum/design/makeshift/mags_lrifle/casings
	name = "scrap ammunition pile (.30 Rifle)"
	build_path = /obj/item/ammo_casing/lrifle/scrap/prespawned

// .25

/datum/design/makeshift/mags_clrifle
	name = "empty magazine (.25 Caseless Rifle)"
	category = ".25 caliber"
	build_path = /obj/item/ammo_magazine/ihclrifle/empty

/datum/design/makeshift/mags_clrifle/pistol
	name = "empty pistol magazine (.25 Caseless Rifle)"
	build_path = /obj/item/ammo_magazine/cspistol/empty
	minimum_quality = 0 // Mandella

/datum/design/makeshift/mags_clrifle/sl
	name = "empty ammo strip (.25 Caseless Rifle)"
	build_path = /obj/item/ammo_magazine/slclrifle/empty

/datum/design/makeshift/mags_clrifle/casings
	name = "scrap ammunition pile (.25 Caseless Rifle)"
	build_path = /obj/item/ammo_casing/clrifle/scrap/prespawned
	minimum_quality = 0

// .50

/datum/design/makeshift/mags_shot
	name = "empty magazine (.50)"
	category = "shotgun shells"
	build_path = /obj/item/ammo_magazine/m12/short/empty

/datum/design/makeshift/mags_shot/drum
	name = "empty drum magazine (.50)"
	build_path = /obj/item/ammo_magazine/m12/empty
	minimum_quality = 1

/datum/design/makeshift/mags_shot/casings
	name = "scrap ammunition pile (.50 Slug)"
	build_path = /obj/item/ammo_casing/shotgun/scrap/prespawned

/datum/design/makeshift/mags_shot/casings/shot
	name = "scrap ammunition pile (.50 Buckshot)"
	build_path = /obj/item/ammo_casing/shotgun/pellet/prespawned

/datum/design/makeshift/mags_shot/casings/bean
	name = "scrap ammunition pile (.50 Beanbag)"
	build_path = /obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned

// special

/datum/design/makeshift/antim
	name = "scrap shell pile (.60 Anti-Material)"
	category = "special munitions"
	build_path = /obj/item/ammo_casing/antim/scrap/prespawned
	minimum_quality = 0

/datum/design/makeshift/rocket
	name = "scrap rocket (PG-7 shell)"
	category = "special munitions"
	build_path = /obj/item/ammo_casing/rocket/scrap/prespawned
	minimum_quality = 1

// frames

/datum/design/makeshift/sermak
	category = "firearm frames"
	name = "\"Sermak\" rifle frame"
	build_path = /obj/item/gun/projectile/automatic/modular/ak/makeshift
	minimum_quality = 0
