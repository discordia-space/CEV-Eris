/obj/item/weapon/coreimplant_upgrade/cruciform
	name = ""
	desc = "Upgrade module for coreimplant. Must be activated after install."
	icon_state = "cruciform_upgrade"
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform

/obj/item/weapon/coreimplant_upgrade/cruciform/priest
	name = "Priest upgrade"
	desc = "Upgrades cruciform to priest"
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform

/obj/item/weapon/coreimplant_upgrade/cruciform/priest/set_up()
	module = new CRUCIFORM_PRIEST_CONVERT
	module.set_up()
