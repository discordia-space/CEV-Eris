/obj/item/weapon/stock_parts
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	w_class = ITEM_SIZE_SMALL
	var/rating = 1

/obj/item/weapon/stock_parts/New()
	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)
	..()

//Rank 1

/obj/item/weapon/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "screen"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_GLASS = 3)

/obj/item/weapon/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = list(TECH_POWER = 1)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1)

/obj/item/weapon/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

//Rank 2

/obj/item/weapon/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "adv_capacitor"
	origin_tech = list(TECH_POWER = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "adv_scan_module"
	origin_tech = list(TECH_MAGNET = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "nano_mani"
	origin_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	rating = 2
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1)

/obj/item/weapon/stock_parts/micro_laser/high
	name = "high-power micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	origin_tech = list(TECH_MAGNET = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "advanced_matter_bin"
	origin_tech = list(TECH_MATERIAL = 3)
	rating = 2
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

//Rating 3

/obj/item/weapon/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "super_capacitor"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 3
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "super_scan_module"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 3
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/manipulator/pico
	name = "pico-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "pico_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 3
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/weapon/stock_parts/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 3
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/matter_bin/super
	name = "super matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "super_matter_bin"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 3
	matter = list(MATERIAL_PLASTIC = 3, MATERIAL_GLASS = 1)


//one star stock parts (rating 4)

/obj/item/weapon/stock_parts/capacitor/one_star
	name = "one star capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "one_capacitor"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 4
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/scanning_module/one_star
	name = "one star scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "one_scan_module"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 4
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/manipulator/one_star
	name = "one star manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "one_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 4
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/weapon/stock_parts/micro_laser/one_star
	name = "one star micro-laser"
	icon_state = "one_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 4
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/matter_bin/one_star
	name = "one star matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "one_matter"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 4
	matter = list(MATERIAL_PLASTIC = 3, MATERIAL_GLASS = 1)


//alien stock parts (rating 6)

/obj/item/weapon/stock_parts/capacitor/alien_capacitor
	name = "Exothermal Seal"
	desc = "A can-shaped brass component, covered in scratch marks and weathered by time. A faint humming can be heard coming from its inner workings. Seems like it can be used in construction of certain devices."
	icon_state = "alien_capacitor"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 5)
	rating = 6
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 3)

/obj/item/weapon/stock_parts/scanning_module/alien
	name = "Optical receptor"
	desc = "A device, closely resembling a human eye. The pupil dilates and contracts when exposed to different materials. Seems like it can be used in construction of certain devices."
	icon_state = "alien_scan_module"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 6
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/manipulator/alien
	name = "Gripper"
	desc = "This strange chunk of metal opens and closes its claws, as if it was a freshly cut crab arm. Seems like it can be used in construction of certain devices."
	icon_state = "alien_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 6
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)

/obj/item/weapon/stock_parts/micro_laser/alien
	name = "Pico-emitter"
	icon_state = "alien_laser"
	desc = "A bright glass orb with a port on its back. It glows faint blue from time to time. Seems like it can be used in construction of certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 6
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

/obj/item/weapon/stock_parts/matter_bin/alien
	name = "Recepticle"
	desc = "A twisted and time-weathered metal contraption, that's slightly warm to the touch. Seems like it can be used in construction of certain devices."
	icon_state = "alien_matter"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 6
	matter = list(MATERIAL_PLASTIC = 3, MATERIAL_GLASS = 1)


// Subspace stock parts

/obj/item/weapon/stock_parts/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 5 ,TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 1, MATERIAL_SILVER = 2)

/obj/item/weapon/stock_parts/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	origin_tech = list(TECH_DATA = 4, TECH_MAGNET = 2)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 1, MATERIAL_SILVER = 1)

/obj/item/weapon/stock_parts/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 1, MATERIAL_SILVER = 1)

/obj/item/weapon/stock_parts/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 5, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 1, MATERIAL_SILVER = 1)

/obj/item/weapon/stock_parts/subspace/analyzer
	name = "subspace wavelength analyzer"
	icon_state = "wavelength_analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 1, MATERIAL_SILVER = 1)

/obj/item/weapon/stock_parts/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	origin_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 1, MATERIAL_SILVER = 2)

/obj/item/weapon/stock_parts/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	origin_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_GLASS = 1, MATERIAL_SILVER = 1)