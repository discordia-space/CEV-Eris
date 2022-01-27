/obj/item/robot_parts/robot_component/exosuit_control
	name = "exosuit control computer"
	desc = "An arrangement of screens, circuitry and software disk ports used to operate an exosuit."
	icon_state = "control"
	icon =69ECH_EQUIPMENT_ICON
	gender =69EUTER
	color =69ull
	matter = list(MATERIAL_STEEL = 10,69ATERIAL_PLASTIC = 5,69ATERIAL_GLASS = 5,69ATERIAL_GOLD = 2)
	var/list/installed_software = list()
	var/max_installed_software = 2

/obj/item/robot_parts/robot_component/exosuit_control/Initialize(newloc)
	. = ..()
	// HACK
	// All robot components add "robot" to the69ame on init - remove that on exosuit computer
	name = initial(name)

/obj/item/robot_parts/robot_component/exosuit_control/examine(mob/user)
	. = ..()
	if(.)
		to_chat(user, SPAN_NOTICE("It has 69max_installed_software - length(installed_software)69 empty slot\s remaining out of 69max_installed_software69."))

/obj/item/robot_parts/robot_component/exosuit_control/attackby(obj/item/I,69ob/living/user)
	if(istype(I, /obj/item/electronics/circuitboard/exosystem))
		install_software(I, user)
		return

	if(I.use_tool(user, src, WORKTIME_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_ZERO))
		var/result = ..()
		update_software()
		return result
	else
		return ..()

/obj/item/robot_parts/robot_component/exosuit_control/proc/install_software(obj/item/electronics/circuitboard/exosystem/software,69ob/living/user)
	if(installed_software.len >=69ax_installed_software)
		if(user)
			to_chat(user, SPAN_WARNING("\The 69src69 can only hold 69max_installed_software69 software69odules."))
		return
	if(user && !user.unEquip(software))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You load \the 69software69 into \the 69src69's69emory."))

	software.forceMove(src)
	update_software()

/obj/item/robot_parts/robot_component/exosuit_control/proc/update_software()
	installed_software = list()
	for(var/obj/item/electronics/circuitboard/exosystem/program in contents)
		installed_software |= program.contains_software



#define T_BOARD_MECH(name)	"exosuit software (" + (name) + ")"

/obj/item/electronics/circuitboard/exosystem
	name = T_BOARD_MECH("template")
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	var/list/contains_software = list()

/obj/item/electronics/circuitboard/exosystem/engineering
	name = T_BOARD_MECH("engineering systems")
	contains_software = list(MECH_SOFTWARE_ENGINEERING)
	origin_tech = list(TECH_DATA = 1)

/obj/item/electronics/circuitboard/exosystem/utility
	name = T_BOARD_MECH("utility systems")
	contains_software = list(MECH_SOFTWARE_UTILITY)
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 1)

/obj/item/electronics/circuitboard/exosystem/medical
	name = T_BOARD_MECH("medical systems")
	contains_software = list(MECH_SOFTWARE_MEDICAL)
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 3,TECH_BIO = 2)

/obj/item/electronics/circuitboard/exosystem/weapons
	name = T_BOARD_MECH("basic weapon systems")
	contains_software = list(MECH_SOFTWARE_WEAPONS)
	icon_state = "mainboard"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 3)

/obj/item/electronics/circuitboard/exosystem/advweapons
	name = T_BOARD_MECH("advanced weapon systems")
	contains_software = list(MECH_SOFTWARE_ADVWEAPONS)
	icon_state = "mainboard"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 5)

#undef T_BOARD_MECH