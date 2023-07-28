/*
For use in defining designs for crafting stations.
Based on /datum/design of \code\datums\autolathe\autolathe_datums.dm

("firearm grips", "firearm barrels", "pistol mechanisms", "revolver mechanisms", "pump-action mechanisms", "self-reloading mechanisms", ".35 caliber", ".40 caliber", ".20 caliber", ".25 caliber", ".30 caliber", "shotgun shells", "special munitions")

*/

/datum/design/makeshift
	category = "miscellaneous"
	build_type = MAKESHIFT

/datum/design/makeshift/part
	name = "shotgun shells (slug)"
	build_path = /obj/item/ammo_casing/shotgun/prespawned

/datum/design/makeshift/grip
	name = "makeshift grip"
	category = "firearm grips"
	build_path = /obj/item/part/gun/modular/grip/makeshift

/datum/design/makeshift/grip/wood
	name = "wood grip"
	build_path = /obj/item/part/gun/modular/grip/wood

/datum/design/makeshift/part/mechanism/pistol
	name = "generic pistol mechanism"
	category = "pistol mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/pistol

/datum/design/makeshift/part/mechanism/revolver
	name = "generic revolver mechanism"
	category = "revolver mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/revolver

/datum/design/makeshift/part/mechanism/shotgun
	name = "generic shotgun mechanism"
	category = "pump-action mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/shotgun

/datum/design/makeshift/part/mechanism/smg
	name = "generic SMG mechanism"
	category = "SMG mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/smg

/datum/design/makeshift/part/mechanism/autorifle
	name = "generic self-loading mechanism"
	category = "self-reloading mechanisms"
	build_path = /obj/item/part/gun/modular/mechanism/autorifle


// .35

/datum/design/makeshift/part/mags/pistol
	name = "empty standard magazine (.35 Auto)"
	category = ".35 caliber"
	build_path = /obj/item/ammo_magazine/pistol/empty

/datum/design/makeshift/part/mags/pistol/hpistol
	name = "empty highcap magazine (.35 Auto)"
	build_path = /obj/item/ammo_magazine/hpistol/empty

/datum/design/makeshift/part/mags/pistol/smg
	name = "empty SMG magazine (.35 Auto)"
	build_path = /obj/item/ammo_magazine/smg/empty

/datum/design/makeshift/part/mags/pistol/sl
	name = "empty speed loader (.40 Magnum)"
	build_path = /obj/item/ammo_magazine/slmagnum/empty


// .40

/datum/design/makeshift/part/mags/magnum
	name = "empty magazine (.40 Magnum)"
	category = ".40 caliber"
	build_path = /obj/item/ammo_magazine/magnum/empty

/datum/design/makeshift/part/mags/magnum/msmg
	name = "empty SMG magazine (.40 Magnum)"
	build_path = /obj/item/ammo_magazine/msmg/empty

/datum/design/makeshift/part/mags/magnum/sl
	name = "empty speed loader (.40 Magnum)"
	build_path = /obj/item/ammo_magazine/slmagnum/empty


// .20

/datum/design/makeshift/part/mags/srifle
	name = "empty magazine (.20 Rifle)"
	category = ".20 caliber"
	build_path = /obj/item/ammo_magazine/srifle/empty

/datum/design/makeshift/part/mags/srifle/long
	name = "empty extended magazine (.20 Rifle)"
	build_path = /obj/item/ammo_magazine/srifle/long/empty

/datum/design/makeshift/part/mags/srifle/drum
	name = "empty drum magazine (.20 Rifle)"
	build_path = /obj/item/ammo_magazine/srifle/drum/empty

/datum/design/makeshift/part/mags/srifle/sl
	name = "empty ammo strip (.20 Rifle)"
	build_path = /obj/item/ammo_magazine/slsrifle/empty


// .25

/datum/design/makeshift/part/mags/clrifle
	name = "empty magazine (.25 Caseless Rifle)"
	category = ".25 caliber"
	build_path = /obj/item/ammo_magazine/ihclrifle/empty

/datum/design/makeshift/part/mags/clrifle/pistol
	name = "empty pistol magazine (.25 Caseless Rifle)"
	build_path = /obj/item/ammo_magazine/cspistol/empty

/datum/design/makeshift/part/mags/srifle/sl
	name = "empty ammo strip (.25 Caseless Rifle)"
	build_path = /obj/item/ammo_magazine/slclrifle/empty


// .50

/datum/design/makeshift/part/mags/shot
	name = "ammo drum (.50)"
	category = "shotgun shells"
	build_path = /obj/item/ammo_magazine/m12
