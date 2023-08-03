/*
For use in defining designs for crafting stations.
Based on /datum/design of \code\datums\autolathe\autolathe_datums.dm

("firearm grips", "firearm barrels", "pistol mechanisms", "revolver mechanisms", "pump-action mechanisms", "self-reloading mechanisms", ".35 caliber", ".40 caliber", ".20 caliber", ".25 caliber", ".30 caliber", "shotgun shells", "special munitions")

*/

/datum/design/makeshift
	category = "miscellaneous"
	build_type = MAKESHIFT

/datum/design/makeshift/grip
	name = "makeshift grip"
	category = "firearm grips"
	build_path = /obj/item/part/gun/modular/grip/makeshift

/datum/design/makeshift/grip/wood
	name = "wood grip"
	build_path = /obj/item/part/gun/modular/grip/wood

/datum/design/makeshift/mechanism/pistol
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

/datum/design/makeshift/mechanism/autorifle
	name = "generic self-loading mechanism"
	category = "self-reloading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle


// .35

/datum/design/makeshift/mags_pistol
	name = "empty standard magazine (.35 Auto)"
	category = ".35 caliber"
	build_path = /obj/item/ammo_magazine/pistol/empty

/datum/design/makeshift/mags_pistol/hpistol
	name = "empty highcap magazine (.35 Auto)"
	build_path = /obj/item/ammo_magazine/hpistol/empty

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

/datum/design/makeshift/mags_srifle/drum
	name = "empty drum magazine (.20 Rifle)"
	build_path = /obj/item/ammo_magazine/srifle/drum/empty

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

/datum/design/makeshift/mags_clrifle/sl
	name = "empty ammo strip (.25 Caseless Rifle)"
	build_path = /obj/item/ammo_magazine/slclrifle/empty

/datum/design/makeshift/mags_clrifle/casings
	name = "scrap ammunition pile (.25 Caseless Rifle)"
	build_path = /obj/item/ammo_casing/clrifle/scrap/prespawned

// .50

/datum/design/makeshift/mags_shot
	name = "ammo drum (.50)"
	category = "shotgun shells"
	build_path = /obj/item/ammo_magazine/m12

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

/datum/design/makeshift/rocket
	name = "scrap rocket (PG-7 shell)"
	category = "special munitions"
	build_path = /obj/item/ammo_casing/rocket/scrap/prespawned

// frames

/datum/design/makeshift/sermak
	category = "firearm frames"
	name = "\"Sermak\" rifle frame"
	build_path = /obj/item/gun/projectile/automatic/modular/ak/makeshift
