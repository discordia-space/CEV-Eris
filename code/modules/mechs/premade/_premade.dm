//GLOBAL_LIST_INIT(mech_decals, (icon_states(MECH_DECALS_ICON)-list("template", "mask")))
/mob/living/exosuit/premade
	name = "impossible exosuit"
	desc = "It seems to be saying 'please let me die'."

	material = MATERIAL_STEEL
	var/exosuit_color
	var/decal
	var/installed_armor = /obj/item/robot_parts/robot_component/armour/exosuit
	var/list/installed_software_boards = list()
	var/list/installed_systems = list(
		HARDPOINT_HEAD = /obj/item/mech_equipment/light
	)


/mob/living/exosuit/premade/Initialize()
	// Paint and equip all body parts
	for(var/obj/item/mech_component/C in list(arms, legs, head, body))
		if(decal)
			C.decal = decal
		if(exosuit_color)
			C.color = exosuit_color
		C.prebuild()

	if(body && body.computer && length(installed_software_boards))
		for(var/board_path in installed_software_boards)
			new board_path(body.computer)
		body.computer.update_software()

	if(body && body.armor?.type != installed_armor)
		QDEL_NULL(body.armor) // Delete old armor, if any
		body.armor = new installed_armor(src)

	. = ..()

	for(var/hardpoint in installed_systems)
		var/system_type = installed_systems[hardpoint]
		install_system(new system_type(src), hardpoint)


/mob/living/exosuit/premade/random
	name = "mismatched exosuit"
	desc = "It seems to have been roughly thrown together and then spraypainted in a single color."

/mob/living/exosuit/premade/random/Initialize(mapload, obj/structure/heavy_vehicle_frame/source_frame, super_random = FALSE, using_boring_colours = FALSE)
	//if(!prob(100/(LAZYLEN(GLOB.mech_decals)+1)))
	//	decal = pick(GLOB.mech_decals)

	var/list/use_colours
	if(using_boring_colours)
		use_colours = list(
			COLOR_DARK_GRAY,
			"#666666",
			COLOR_DARK_BROWN,
			COLOR_GRAY,
			COLOR_RED_GRAY,
			COLOR_BROWN,
			COLOR_GREEN_GRAY,
			COLOR_BLUE_GRAY,
			COLOR_PURPLE_GRAY,
			COLOR_BEIGE,
			COLOR_PALE_GREEN_GRAY,
			COLOR_PALE_RED_GRAY,
			COLOR_PALE_PURPLE_GRAY,
			COLOR_PALE_BLUE_GRAY,
			COLOR_SILVER,
			"#cccccc",
			COLOR_OFF_WHITE,
			COLOR_GUNMETAL,
			COLOR_HULL,
			COLOR_TITANIUM,
			COLOR_DARK_GUNMETAL,
			"#8c7853",
			"#b99d71"
		)
	else
		use_colours = list(
			COLOR_NAVY_BLUE,
			COLOR_GREEN,
			COLOR_DARK_GRAY,
			COLOR_MAROON,
			COLOR_PURPLE,
			COLOR_VIOLET,
			COLOR_OLIVE,
			COLOR_BROWN_ORANGE,
			COLOR_DARK_ORANGE,
			COLOR_GRAY40,
			COLOR_SEDONA,
			COLOR_DARK_BROWN,
			COLOR_BLUE,
			COLOR_DEEP_SKY_BLUE,
			COLOR_LIME,
			COLOR_CYAN,
			COLOR_TEAL,
			COLOR_RED,
			COLOR_PINK,
			COLOR_ORANGE,
			COLOR_YELLOW,
			COLOR_GRAY,
			COLOR_RED_GRAY,
			COLOR_BROWN,
			COLOR_GREEN_GRAY,
			COLOR_BLUE_GRAY,
			COLOR_SUN,
			COLOR_PURPLE_GRAY,
			COLOR_BLUE_LIGHT,
			COLOR_RED_LIGHT,
			COLOR_BEIGE,
			COLOR_PALE_GREEN_GRAY,
			COLOR_PALE_RED_GRAY,
			COLOR_PALE_PURPLE_GRAY,
			COLOR_PALE_BLUE_GRAY,
			COLOR_LUMINOL,
			COLOR_SILVER,
			COLOR_GRAY80,
			COLOR_OFF_WHITE,
			COLOR_NT_RED,
			COLOR_BOTTLE_GREEN,
			COLOR_PALE_BTL_GREEN,
			COLOR_GUNMETAL,
			COLOR_MUZZLE_FLASH,
			COLOR_CHESTNUT,
			COLOR_BEASTY_BROWN,
			COLOR_WHEAT,
			COLOR_CYAN_BLUE,
			COLOR_LIGHT_CYAN,
			COLOR_PAKISTAN_GREEN,
			COLOR_HULL,
			COLOR_AMBER,
			COLOR_COMMAND_BLUE,
			COLOR_SKY_BLUE,
			COLOR_PALE_ORANGE,
			COLOR_CIVIE_GREEN,
			COLOR_TITANIUM,
			COLOR_DARK_GUNMETAL,
			"#8c7853",
			"#b99d71",
			"#4b0082"
		)

	if(!arms)
		var/armstype = pick(subtypesof(/obj/item/mech_component/manipulators))
		arms = new armstype(src)
	if(!legs)
		var/legstype = pick(subtypesof(/obj/item/mech_component/propulsion))
		legs = new legstype(src)
	if(!head)
		var/headtype = pick(subtypesof(/obj/item/mech_component/sensors))
		head = new headtype(src)
	if(!body)
		var/bodytype = pick(subtypesof(/obj/item/mech_component/chassis))
		body = new bodytype(src)

	if(super_random)
		for(var/obj/item/mech_component/C in list(arms, legs, head, body))
			C.color = pick(use_colours)
	else
		exosuit_color = pick(use_colours)

	material = pickweight(list(
		MATERIAL_STEEL = 50,
		MATERIAL_PLASTEEL = 20,
		MATERIAL_PLASTIC = 20,
		MATERIAL_URANIUM = 7,
		MATERIAL_GOLD = 2,
		MATERIAL_DIAMOND = 1
	))

	installed_armor = pickweight(list(
		/obj/item/robot_parts/robot_component/armour/exosuit = 50,
		/obj/item/robot_parts/robot_component/armour/exosuit/combat = 30,
		/obj/item/robot_parts/robot_component/armour/exosuit/radproof = 10,
		/obj/item/robot_parts/robot_component/armour/exosuit/em = 10
	))

	. = ..()

// Used for spawning/debugging.
/mob/living/exosuit/premade/random/normal

/mob/living/exosuit/premade/random/boring/New(newloc, obj/structure/heavy_vehicle_frame/source_frame)
	..(newloc, source_frame, FALSE, TRUE)

/mob/living/exosuit/premade/random/extra/New(newloc, obj/structure/heavy_vehicle_frame/source_frame)
	..(newloc, source_frame, TRUE)
