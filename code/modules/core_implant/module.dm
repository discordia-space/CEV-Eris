/datum/core_module
	var/obj/item/weapon/implant/core_implant/implant
	var/implant_type = /obj/item/weapon/implant/core_implant
	var/install_time = 0
	var/time = 0
	var/mob/living/user

/datum/core_module/proc/install()

/datum/core_module/proc/uninstall()

/datum/core_module/proc/preinstall()

/datum/core_module/proc/set_up()

/datum/core_module/group_ritual


//ACTIVATABLE

/datum/core_module/activatable
	var/active = FALSE
	var/datum/core_module/module

/datum/core_module/activatable/New(var/datum/core_module/M)
	if(istype(M))
		module = M

/datum/core_module/activatable/proc/activate()
	if(implant && istype(module) && !(module in implant.modules))
		implant.add_module(module)
		active = TRUE

/datum/core_module/activatable/proc/deactivate()
	if(implant && istype(module))
		implant.remove_module(module)
		active = FALSE

/datum/core_module/activatable/uninstall()
	deactivate()
