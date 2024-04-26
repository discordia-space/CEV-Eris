/*
	MATERIAL DATUMS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation. ~Z

	PATHS THAT USE DATUMS
		turf/wall
		obj/item/material
		obj/structure/barricade
		obj/item/stack/material
		obj/structure/table

	VALID ICONS
		WALLS
			stone
			metal
			solid
			cult
		DOORS
			stone
			metal
			resin
			wood
*/

// Assoc list containing all material datums indexed by name.
var/list/name_to_material

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return null

//mostly for convenience
/obj/proc/get_material_name()
	var/material/material = get_material()
	if(material)
		return material.name

// Builds the datum list above.
/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake) return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/material) - /material)
		var/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1

// Safety proc to make sure the material list exists before trying to grab from it.
/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	var/material/M = name_to_material[lowertext(name)]
	if(!M)
		error("Invalid material given: [name]")
	return M

/proc/get_material_name_by_stack_type(stype)
	if(!name_to_material)
		populate_material_list()

	for(var/name in name_to_material)
		var/material/M = name_to_material[name]
		if(M.stack_type == stype)
			return M.name
	return null

/proc/material_display_name(name)
	var/material/material = get_material_by_name(name)
	if(material)
		return material.display_name
	return null

/proc/material_stack_type(name)
	var/material/material = get_material_by_name(name)
	if(material)
		return material.stack_type
	return null

// Material definition and procs follow.
/material
	var/name	                          // Unique name for use in indexing the list.
	var/display_name                      // Prettier name for display.
	var/use_name
	var/flags = 0                         // Various status modifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"

	// Shards/tables/structures
	var/shard_type = SHARD_SHRAPNEL       // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/list/recipes                      // Holder for all recipes usable with a sheet of this material.
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.

	// Icons
	var/icon_colour                                      // Colour applied to products of this material.
	var/icon_base = "solid"                              // Wall and table base icon tag. See header.
	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/icon_reinf = "reinf_over"                       // Overlay used
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1) // Research level for stacks.

	// Attributes
	var/cut_delay = 0            // Delay in ticks when cutting through this wall.
	var/radioactivity            // Radiation var. Used in wall and object processing to irradiate surroundings.
	var/ignition_point           // K, point at which the material catches on fire.
	var/melting_point = 1800     // K, walls will take damage if they're next to a fire hotter than this
	var/heat_resistance = 1 	 // divisor, walls resist thermite and welding based on this
	var/integrity = 150          // General-use HP value for products.
	var/opacity = 1              // Is the material transparent? 0.5< makes transparent walls/doors.
	var/conductive = 1           // Objects with this var add CONDUCTS to flags on spawn.
	var/list/composite_material  // If set, object matter var will be a list containing these values.
	/// Armor values for this material whenever its applied on something.
	var/datum/armor/armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 1,
		bio = 1,
		rad = 1
	)

	// Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	// Damage values.
	var/hardness = 60            // Prob of wall destruction by hulk, used for edge damage in weapons.
	var/weight = 20              // Determines blunt damage/throwforce for weapons.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Noise made when you hit structure made of this material.
	var/hitsound = 'sound/weapons/genhit.ogg'
	// Path to resulting stacktype. Todo remove need for this.
	var/stack_type

// Placeholders for light tiles and rglass.
/material/proc/build_rod_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, SPAN_WARNING("You cannot make anything out of \the [target_stack]"))
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		to_chat(user, SPAN_WARNING("You need one rod and one sheet of [display_name] to make anything useful."))
		return
	used_stack.use(1)
	target_stack.use(1)
	var/obj/item/stack/S = new rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)

/material/proc/build_wired_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, SPAN_WARNING("You cannot make anything out of \the [target_stack]"))
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, SPAN_WARNING("You need five wires and one sheet of [display_name] to make anything useful."))
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, SPAN_NOTICE("You attach wire to the [name]."))
	var/obj/item/product = new wire_product(get_turf(user))
	if(!(user.l_hand && user.r_hand))
		user.put_in_hands(product)

// Make sure we have a display name and shard icon even if they aren't explicitly set.
/material/New()
	..()
	if(!display_name)
		display_name = name
	if(!use_name)
		use_name = display_name
	if(!shard_icon)
		shard_icon = shard_type

// This is a placeholder for proper integration of windows/windoors into the system.
/material/proc/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)
	return 0

// Weapons handle applying a divisor for this value locally.
/material/proc/get_blunt_damage()
	return weight //todo

// Return the matter comprising this material.
/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter[material_string] = composite_material[material_string]
	else
		temp_matter[name] = 1
	return temp_matter

// Currently used for weapons and objects made of uranium to irradiate things.
/material/proc/products_need_process()
	return (radioactivity>0) //todo


// Use this to drop a given amount of material.
/material/proc/place_material(target, amount=1, mob/living/user = null)
	// Drop the integer amount of sheets
	var/obj/sheets = place_sheet(target, round(amount))
	if(sheets)
		amount -= round(amount)
		if(user)
			sheets.add_fingerprint(user)

	// If there is a remainder left, drop it as a shard instead
	if(amount)
		place_shard(target, amount)

// Debris product. Used ALL THE TIME.
/material/proc/place_sheet(target, amount=1)
	if(stack_type)
		return new stack_type(target, amount)

// As above.
/material/proc/place_shard(target, amount=1)
	if(shard_type)
		return new /obj/item/material/shard(target, src.name, amount)

// Used by walls and weapons to determine if they break or not.
/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)

/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

// Datum definitions follow.
/material/uranium
	name = MATERIAL_URANIUM
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22
	hardness = 80
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	// it is a metal and it does conduct , but it does very poorly
	conductive = FALSE
	armor = list(
		melee = 6,
		bullet = 6,
		energy = 10,
		bomb = 25,
		bio = 25,
		rad = 0
	)

/material/diamond
	name = MATERIAL_DIAMOND
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	weight = 50
	stack_origin_tech = list(TECH_MATERIAL = 6)
	armor = list(
		melee = 15,
		bullet = 15,
		energy = 0,
		bomb = 80,
		bio = 0,
		rad = 0
	)

/material/gold
	name = MATERIAL_GOLD
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 25
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductive = TRUE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 1,
		bio = 45,
		rad = 1
	)

/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	icon_colour = "#EDD12F"
	conductive = TRUE
	armor = list(
		melee = 2,
		bullet = 2,
		energy = 3,
		bomb = 10,
		bio = 30,
		rad = 0
	)

/material/silver
	name = MATERIAL_SILVER
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 45
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductive = TRUE
	armor = list(
		melee = 2,
		bullet = 2,
		energy = 2,
		bomb = 10,
		bio = 80,
		rad = 0
	)

/material/plasma
	name = MATERIAL_PLASMA
	stack_type = /obj/item/stack/material/plasma
	ignition_point = PLASMA_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PLASMA = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	conductive = TRUE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 6,
		bomb = 1,
		bio = 80,
		rad = 45
	)

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/material/plasma/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPlasma = 0
	for(var/turf/floor/target_tile in RANGE_TURFS(2, T))
		var/plasmaToDeduce = (temperature/30) * effect_multiplier
		totalPlasma += plasmaToDeduce
		target_tile.assume_gas("plasma", plasmaToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPlasma/100)
*/

/material/stone
	name = MATERIAL_SANDSTONE
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	heat_resistance = 8
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = FALSE
	armor = list(
		melee = 2,
		bullet = 0,
		energy = 1,
		bomb = 25,
		bio = 0,
		rad = 0
	)

/material/stone/marble
	name = MATERIAL_MARBLE
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 100
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/material/steel
	name = MATERIAL_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	weight = 34
	hardness = 60
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = PLASTEEL_COLOUR
	hitsound = 'sound/weapons/genhit.ogg'
	conductive = TRUE
	armor = list(
		melee = 5,
		bullet = 5,
		energy = 5,
		bomb = 35,
		bio = 0,
		rad = 0
	)

/material/steel/holographic
	name = "holo" + MATERIAL_STEEL
	display_name = MATERIAL_STEEL
	stack_type = null
	shard_type = SHARD_NONE
	// wish.com steel
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)

/material/plasteel
	name = MATERIAL_PLASTEEL
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = PLASTEEL_COLOUR//"#777777"
	heat_resistance = 3
	hardness = 80
	weight = 23
	stack_origin_tech = list(TECH_MATERIAL = 2)
	conductive = TRUE
	hitsound = 'sound/weapons/genhit.ogg'
	armor = list(
		melee = 8,
		bullet = 8,
		energy = 4,
		bomb = 75,
		bio = 35,
		rad = 25
	)

/material/plasteel/titanium
	name = "titanium"
	stack_type = null
	icon_base = "metal"
	weight = 20
	heat_resistance = 4
	hardness = 90
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"
	conductive = TRUE
	armor = list(
		melee = 16,
		bullet = 10,
		energy = 6,
		bomb = 125,
		bio = 35,
		rad = 0
	)

/material/glass
	name = MATERIAL_GLASS
	stack_type = /obj/item/stack/material/glass
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 15
	weight = 15
	door_icon_base = "stone"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1)
	created_window = /obj/structure/window/basic
	rod_product = /obj/item/stack/material/glass/reinforced
	conductive = FALSE
	hitsound = 'sound/effects/Glasshit.ogg'
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)

/material/glass/build_windows(mob/living/user, obj/item/stack/used_stack)
	if(!user || !used_stack || !created_window || !window_options.len)
		return 0

	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("This task is too complex for your clumsy hands."))
		return 1

	var/turf/T = user.loc
	if(!istype(T))
		to_chat(user, SPAN_WARNING("You must be standing on open flooring to build a window."))
		return 1

	var/title = "Sheet-[used_stack.name] ([used_stack.get_amount()] sheet\s left)"
	var/choice = input(title, "What would you like to construct?") as null|anything in window_options

	if(!choice || !used_stack || !user || used_stack.loc != user || user.stat || user.loc != T)
		return 1

	// Get the closest available dir to the user's current facing.
	var/build_dir = SOUTHWEST //Default to southwest for fulltile windows.
	// Get data for building windows here.
	var/list/possible_directions = cardinal.Copy()
	var/window_count = 0
	for(var/obj/structure/window/check_window in user.loc)
		window_count++
		possible_directions  -= check_window.dir

	var/failed_to_build
	if(window_count >= 4)
		failed_to_build = 1
	else
		if(possible_directions.len)
			for(var/direction in list(user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
				if(direction in possible_directions)
					build_dir = direction
					break
		else
			failed_to_build = 1
		if(!failed_to_build && choice == "Windoor")
			if(!is_reinforced())
				to_chat(user, SPAN_WARNING("This material is not reinforced enough to use for a door."))
				return
			if((locate(/obj/structure/windoor_assembly) in T.contents) || (locate(/obj/machinery/door/window) in T.contents))
				failed_to_build = 1

	if(failed_to_build)
		to_chat(user, SPAN_WARNING("There is no room in this location."))
		return 1

	var/build_path = /obj/structure/windoor_assembly
	var/sheets_needed = window_options[choice]
	if(choice == "Windoor")
		build_dir = user.dir
	else
		build_path = created_window

	if(used_stack.get_amount() < sheets_needed)
		to_chat(user, SPAN_WARNING("You need at least [sheets_needed] sheets to build this."))
		return 1

	// Build the structure and update sheet count etc.
	used_stack.use(sheets_needed)
	var/obj/O = new build_path(T, build_dir)
	O.Created(user)
	return 1

/material/glass/proc/is_reinforced()
	return (hardness > 35) //todo

/material/glass/reinforced
	name = MATERIAL_RGLASS
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 30
	weight = 30
	stack_origin_tech = "materials=2"
	composite_material = list(MATERIAL_STEEL = 2,MATERIAL_GLASS = 3)
	window_options = list("One Direction" = 1, "Windoor" = 5)
	created_window = /obj/structure/window/reinforced
	conductive = FALSE
	wire_product = null
	rod_product = null
	armor = list(
		melee = 4,
		bullet = 4,
		energy = 0,
		bomb = 35,
		bio = 0,
		rad = 0
	)

/material/glass/plasma
	name = MATERIAL_PLASMAGLASS
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/plasmaglass
	flags = MATERIAL_BRITTLE
	integrity = 100
	icon_colour = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	weight = 40
	hardness = 50
	created_window = /obj/structure/window/plasmabasic
	wire_product = null
	rod_product = /obj/item/stack/material/glass/plasmarglass
	conductive = FALSE
	armor = list(
		melee = 6,
		bullet = 6,
		energy = 0,
		bomb = 45,
		bio = 0,
		rad = 0
	)

/material/glass/plasma/reinforced
	name = MATERIAL_RPLASMAGLASS
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/plasmarglass
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list() //todo
	created_window = /obj/structure/window/reinforced/plasma
	hardness = 60
	weight = 50
	conductive = FALSE
	//composite_material = list() //todo
	rod_product = null
	armor = list(
		melee = 8,
		bullet = 8,
		energy = 0,
		bomb = 50,
		bio = 0,
		rad = 0
	)

/material/plastic
	name = MATERIAL_PLASTIC
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	melting_point = T0C+371 //assuming heat resistant plastic
	conductive = FALSE
	stack_origin_tech = list(TECH_MATERIAL = 3)
	armor = list(
		melee = 3,
		bullet = 3,
		energy = 3,
		bomb = 20,
		bio = 5,
		rad = 0
	)

/material/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE
	conductive = FALSE
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)

/material/osmium
	name = MATERIAL_OSMIUM
	stack_type = /obj/item/stack/material/osmium
	integrity = 480 // might as well.
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	heat_resistance = 10 // osmium is REALLY dense and high melting point.
	melting_point = T0C+3025
	weight = 90
	hardness = 90
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductive = TRUE
	armor = list(
		melee = 20,
		bullet = 14,
		energy = 7,
		bomb = 200,
		bio = 0,
		rad = 25
	)

/material/tritium
	name = MATERIAL_TRITIUM
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductive = FALSE
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 10,
		bomb = 0,
		bio = 100,
		rad = 50
	)

/material/mhydrogen
	name = MATERIAL_MHYDROGEN
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	weight = 10
	hardness = 200
	conductive = TRUE
	display_name = "metallic hydrogen"
	armor = list(
		melee = 35,
		bullet = 18,
		energy = 8,
		bomb = 350,
		bio = 0,
		rad = 35
	)

/material/platinum
	name = MATERIAL_PLATINUM
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	hardness = 50
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	armor = list(
		melee = 3,
		bullet = 3,
		energy = 15,
		bomb = 25,
		bio = 55,
		rad = 25
	)

/material/iron
	name = MATERIAL_IRON
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	hardness = 40
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	conductive = TRUE
	armor = list(
		melee = 3,
		bullet = 3,
		energy = 3,
		bomb = 35,
		bio = 0,
		rad = 0
	)

// Adminspawn only, do not let anyone get this.
/material/voxalloy
	name = "voxalloy"
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	hardness = 500
	weight = 500
	armor = list(
		melee = 50,
		bullet = 35,
		energy = 25,
		bomb = 500,
		bio = 0,
		rad = 85
	)

/material/wood
	name = MATERIAL_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#824B28"
	integrity = 50
	icon_base = "solid"
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	heat_resistance = 0.5 // not good
	weight = 18
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"
	hitsound = 'sound/effects/woodhit.ogg'
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 5,
		bomb = 10,
		bio = 0,
		rad = 0
	)

/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE
	conductive = FALSE
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)

/material/cardboard
	name = MATERIAL_CARDBOARD
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	heat_resistance = 0.25 // very bad
	hardness = 1
	weight = 1
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	conductive = FALSE
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cloth //todo
	name = MATERIAL_CLOTH
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	heat_resistance = 0.25 // very bad
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MATERIAL_PADDING
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)


/material/biomatter
	name = MATERIAL_BIOMATTER
	stack_type = /obj/item/stack/material/biomatter
	icon_colour = "#F48042"
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"
	armor = list(
		melee = 2,
		bullet = 2,
		energy = 2,
		bomb = 15,
		bio = 100,
		rad = 0
	)

/material/compressed
	name = MATERIAL_COMPRESSED
	stack_type = /obj/item/stack/material/compressed
	icon_colour = "#00E1FF"
	sheet_singular_name = "cartrigde"
	sheet_plural_name = "cartridges"
	conductive = TRUE
	armor = list(
		melee = 18,
		bullet = 10,
		energy = 10,
		bomb = 150,
		bio = 0,
		rad = 100
	)

//TODO PLACEHOLDERS:
/material/leather
	name = MATERIAL_LEATHER
	icon_colour = "#5C4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	armor = list(
		melee = 4,
		bullet = 2,
		energy = 2,
		bomb = 10,
		bio = 10,
		rad = 0
	)

/material/carpet
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	conductive = FALSE
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cotton
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)

/material/cloth_teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cloth_black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cloth_green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cloth_puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cloth_blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cloth_beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)

/material/cloth_lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = FALSE
	armor = list(
		melee = 1,
		bullet = 1,
		energy = 1,
		bomb = 5,
		bio = 0,
		rad = 0
	)
