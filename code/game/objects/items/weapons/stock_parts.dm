/obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	w_class = ITEM_SIZE_SMALL
	rarity_value = 10
	bad_type = /obj/item/stock_parts
	spawn_tags = SPAWN_TAG_STOCK_PARTS
	var/rating = 1

/obj/item/stock_parts/New()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)
	..()

//Rank 1

/obj/item/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "screen"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_GLASS = 3)

/obj/item/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a69ariety of devices."
	icon_state = "capacitor"
	origin_tech = list(TECH_POWER = 1)
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 1)
	rarity_value = 15

/obj/item/stock_parts/scanning_module
	name = "scanning69odule"
	desc = "A compact, high resolution scanning69odule used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 1)

/obj/item/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little69anipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1)

/obj/item/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)

/obj/item/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed69atter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	rarity_value = 9

//Rank 2

/obj/item/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a69ariety of devices."
	icon_state = "adv_capacitor"
	origin_tech = list(TECH_POWER = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 1)
	spawn_tags = SPAWN_TAG_STOCK_PARTS_TIER_2

/obj/item/stock_parts/scanning_module/adv
	name = "advanced scanning69odule"
	desc = "A compact, high resolution scanning69odule used in the construction of certain devices."
	icon_state = "adv_scan_module"
	origin_tech = list(TECH_MAGNET = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 1)
	spawn_tags = SPAWN_TAG_STOCK_PARTS_TIER_2

/obj/item/stock_parts/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little69anipulator used in the construction of certain devices."
	icon_state = "nano_mani"
	origin_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	rating = 2
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1)
	spawn_tags = SPAWN_TAG_STOCK_PARTS_TIER_2

/obj/item/stock_parts/micro_laser/high
	name = "high-power69icro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	origin_tech = list(TECH_MAGNET = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 1)
	spawn_tags = SPAWN_TAG_STOCK_PARTS_TIER_2

/obj/item/stock_parts/matter_bin/adv
	name = "advanced69atter bin"
	desc = "A container for hold compressed69atter awaiting re-construction."
	icon_state = "advanced_matter_bin"
	origin_tech = list(TECH_MATERIAL = 3)
	rating = 2
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_tags = SPAWN_TAG_STOCK_PARTS_TIER_2

//Rating 3

/obj/item/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a69ariety of devices."
	icon_state = "super_capacitor"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 3
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)

/obj/item/stock_parts/scanning_module/phasic
	name = "phasic scanning69odule"
	desc = "A compact, high resolution phasic scanning69odule used in the construction of certain devices."
	icon_state = "super_scan_module"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 3
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)

/obj/item/stock_parts/manipulator/pico
	name = "pico-manipulator"
	desc = "A tiny little69anipulator used in the construction of certain devices."
	icon_state = "pico_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 3
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2)

/obj/item/stock_parts/micro_laser/ultra
	name = "ultra-high-power69icro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 3
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)

/obj/item/stock_parts/matter_bin/super
	name = "super69atter bin"
	desc = "A container for hold compressed69atter awaiting re-construction."
	icon_state = "super_matter_bin"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 3
	matter = list(MATERIAL_PLASTIC = 3,69ATERIAL_GLASS = 1)


//excelsior stock parts (rating 4)
/obj/item/stock_parts/capacitor/excelsior
	name = "excelsior capacitor"
	desc = "A super-high capacity capacitor used in the construction of a69ariety of devices."
	icon_state = "excel_capacitor"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 4
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/scanning_module/excelsior
	name = "excelsior scanning69odule"
	desc = "A compact, high resolution phasic scanning69odule used in the construction of certain devices."
	icon_state = "excel_scan_module"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 4
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/manipulator/excelsior
	name = "excelsior69anipulator"
	desc = "A tiny little69anipulator used in the construction of certain devices."
	icon_state = "excel_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 4
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/micro_laser/excelsior
	name = "excelsior69icro-laser"
	icon_state = "excel_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 4
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/matter_bin/excelsior
	name = "excelsior69atter bin"
	desc = "A container for holding compressed69atter awaiting re-construction."
	icon_state = "excel_matter"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 4
	matter = list(MATERIAL_PLASTIC = 3,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE

//one star stock parts (rating 5)

/obj/item/stock_parts/capacitor/one_star
	name = "one star capacitor"
	desc = "A super-high capacity capacitor used in the construction of a69ariety of devices."
	icon_state = "one_capacitor"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 5
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_STOCK_PARTS_OS

/obj/item/stock_parts/scanning_module/one_star
	name = "one star scanning69odule"
	desc = "A compact, high resolution phasic scanning69odule used in the construction of certain devices."
	icon_state = "one_scan_module"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 5
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_STOCK_PARTS_OS

/obj/item/stock_parts/manipulator/one_star
	name = "one star69anipulator"
	desc = "A tiny little69anipulator used in the construction of certain devices."
	icon_state = "one_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 5
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_STOCK_PARTS_OS

/obj/item/stock_parts/micro_laser/one_star
	name = "one star69icro-laser"
	icon_state = "one_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 5
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_STOCK_PARTS_OS

/obj/item/stock_parts/matter_bin/one_star
	name = "one star69atter bin"
	desc = "A container for hold compressed69atter awaiting re-construction."
	icon_state = "one_matter"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 5
	matter = list(MATERIAL_PLASTIC = 3,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_STOCK_PARTS_OS


//alien stock parts (rating 6)

/obj/item/stock_parts/capacitor/alien_capacitor
	name = "Exothermal Seal"
	desc = "A can-shaped brass component, covered in scratch69arks and weathered by time. A faint humming can be heard coming from its inner workings. Seems like it can be used in construction of certain devices."
	icon_state = "alien_capacitor"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 5)
	rating = 6
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 3)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/scanning_module/alien
	name = "Optical receptor"
	desc = "A device, closely resembling a human eye. The pupil dilates and contracts when exposed to different69aterials. Seems like it can be used in construction of certain devices."
	icon_state = "alien_scan_module"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 6
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/manipulator/alien
	name = "Gripper"
	desc = "This strange chunk of69etal opens and closes its claws, as if it was a freshly cut crab arm. Seems like it can be used in construction of certain devices."
	icon_state = "alien_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 6
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/micro_laser/alien
	name = "Pico-emitter"
	icon_state = "alien_laser"
	desc = "A bright glass orb with a port on its back. It glows faint blue from time to time. Seems like it can be used in construction of certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 6
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE

/obj/item/stock_parts/matter_bin/alien
	name = "Recepticle"
	desc = "A twisted and time-weathered69etal contraption, that's slightly warm to the touch. Seems like it can be used in construction of certain devices."
	icon_state = "alien_matter"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 6
	matter = list(MATERIAL_PLASTIC = 3,69ATERIAL_GLASS = 1)
	spawn_blacklisted = TRUE

// debug stock parts - rating 100, intended for debugging

/obj/item/stock_parts/capacitor/debug
	name = "bluespace capacitor"
	desc = "An ultra-advanced battery able to store immense amounts of energy in a localized bluespace pocket. Used in construction of certain devices."
	icon_state = "debug_capacitor"
	origin_tech = list(TECH_POWER = 6, TECH_MATERIAL = 6)
	rating = 100 // rating doesn't really69atter past a certain point - this69akes autolathes print stuff at 1/5th the normal cost (item that costs 5 steel now costs 1 steel)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 1,69ATERIAL_GLASS = 3,69ATERIAL_PLASMA = 1)
	bad_type = /obj/item/stock_parts/capacitor/debug

/obj/item/stock_parts/scanning_module/debug
	name = "bluespace scanning69odule"
	desc = "An ultra-advanced electronic that can rapidly scan objects, as well as their69irror images in bluespace in order to easily understand every detail. Used in construction of certain devices."
	icon_state = "debug_scan_module"
	origin_tech = list(TECH_MAGNET = 6)
	rating = 100
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1,69ATERIAL_PLASMA = 1)
	bad_type = /obj/item/stock_parts/scanning_module/debug

/obj/item/stock_parts/manipulator/debug
	name = "bluespace yocto-manipulator"
	desc = "An ultra-advanced device that can69anipulate an objects69olecular structure. Used in construction of certain devices."
	icon_state = "debug_mani"
	origin_tech = list(TECH_MATERIAL = 6, TECH_DATA = 3)
	rating = 100
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_PLASMA = 1)
	bad_type = /obj/item/stock_parts/manipulator/debug

/obj/item/stock_parts/micro_laser/debug
	name = "bluespace yocto-laser"
	icon_state = "debug_micro_laser"
	desc = "An ultra-advanced device that emits a laser that can emit any kind of laser on the spectrum, and several lasers off the spectrum. Used in construction of certain devices."
	origin_tech = list(TECH_MAGNET = 6)
	rating = 100
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1,69ATERIAL_PLASMA = 1)
	bad_type = /obj/item/stock_parts/micro_laser/debug

/obj/item/stock_parts/matter_bin/debug
	name = "bluespace69atter bin"
	desc = "An ultra-advanced container that opens into a localized pocket dimension69eant for holding compressed69atter. Used in construction of certain devices."
	icon_state = "debug_matter_bin"
	origin_tech = list(TECH_MATERIAL = 6)
	rating = 100
	matter = list(MATERIAL_PLASTIC = 3,69ATERIAL_GLASS = 1,69ATERIAL_PLASMA = 1)
	bad_type = /obj/item/stock_parts/matter_bin/debug

// Subspace stock parts
/obj/item/stock_parts/subspace
	rarity_value = 8
	bad_type = /obj/item/stock_parts/subspace

/obj/item/stock_parts/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact69odule capable of sensing extradimensional activity."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 5 ,TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_GLASS = 1,69ATERIAL_SILVER = 2)

/obj/item/stock_parts/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	origin_tech = list(TECH_DATA = 4, TECH_MAGNET = 2)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_GLASS = 1,69ATERIAL_SILVER = 1)

/obj/item/stock_parts/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact69icro-machine capable of amplifying weak subspace transmissions."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_GLASS = 1,69ATERIAL_SILVER = 1)

/obj/item/stock_parts/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact69icro-machine capable of stretching out hyper-compressed radio waves."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 5, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_GLASS = 1,69ATERIAL_SILVER = 1)

/obj/item/stock_parts/subspace/analyzer
	name = "subspace wavelength analyzer"
	icon_state = "wavelength_analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_GLASS = 1,69ATERIAL_SILVER = 1)

/obj/item/stock_parts/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal69ade from pure glass used to transmit laser databursts to subspace."
	origin_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_GLASS = 1,69ATERIAL_SILVER = 2)

/obj/item/stock_parts/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of e69uipment used to open a window into the subspace dimension."
	origin_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_GLASS = 1,69ATERIAL_SILVER = 1)
