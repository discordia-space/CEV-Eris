/obj/item/weapon/coreimplant_upgrade/cruciform
	name = ""
	desc = "Upgrade module for coreimplant. Must be activated after install."
	icon_state = "cruciform_upgrade"
	implant_type = /obj/item/weapon/implant/core_implant/cruciform

/obj/item/weapon/coreimplant_upgrade/cruciform/priest
	name = "Priest upgrade"
	desc = "Upgrades cruciform to priest"
	implant_type = /obj/item/weapon/implant/core_implant/cruciform

/obj/item/weapon/coreimplant_upgrade/cruciform/priest/set_up()
	module = new CRUCIFORM_PRIEST_CONVERT
	module.set_up()


/obj/item/weapon/coreimplant_upgrade/cruciform/obey
	name = "Obey upgrade"
	desc = "Forces cruciform wearer to obey your orders."
	implant_type = /obj/item/weapon/implant/core_implant/cruciform


/obj/item/weapon/coreimplant_upgrade/cruciform/obey/on_install(var/target,var/mob/living/user_mob)
	if(istype(user_mob))
		user = user_mob
		module.user = user

/obj/item/weapon/coreimplant_upgrade/cruciform/obey/set_up()
	module = new CRUCIFORM_OBEY_ACTIVATOR
	module.set_up()

