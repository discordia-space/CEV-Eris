/*
	MATERIAL DATUMS
	This data is used by69arious parts of the game for basic physical properties and behaviors
	of the69etals/materials used for constructing69any objects. Each69ar is commented and should be pretty
	self-explanatory but the69arious object types69ay have their own documentation. ~Z

	PATHS THAT USE DATUMS
		turf/simulated/wall
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

// Assoc list containing all69aterial datums indexed by69ame.
var/list/name_to_material

//Returns the69aterial the object is69ade of, if applicable.
//Will we ever69eed to return69ore than one69alue here? Or should we just return the "dominant"69aterial.
/obj/proc/get_material()
	return69ull

//mostly for convenience
/obj/proc/get_material_name()
	var/material/material = get_material()
	if(material)
		return69aterial.name

// Builds the datum list above.
/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake) return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/material) - /material)
		var/material/new_mineral =69ew type
		if(!new_mineral.name)
			continue
		name_to_material69lowertext(new_mineral.name)69 =69ew_mineral
	return 1

// Safety proc to69ake sure the69aterial list exists before trying to grab from it.
/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	var/material/M =69ame_to_material69lowertext(name)69
	if(!M)
		error("Invalid69aterial given: 69name69")
	return69

/proc/get_material_name_by_stack_type(stype)
	if(!name_to_material)
		populate_material_list()

	for(var/name in69ame_to_material)
		var/material/M =69ame_to_material69name69
		if(M.stack_type == stype)
			return69.name
	return69ull

/proc/material_display_name(name)
	var/material/material = get_material_by_name(name)
	if(material)
		return69aterial.display_name
	return69ull

/proc/material_stack_type(name)
	var/material/material = get_material_by_name(name)
	if(material)
		return69aterial.stack_type
	return69ull

//69aterial definition and procs follow.
/material
	var/name	                          // Unique69ame for use in indexing the list.
	var/display_name                      // Prettier69ame for display.
	var/use_name
	var/flags = 0                         //69arious status69odifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"

	// Shards/tables/structures
	var/shard_type = SHARD_SHRAPNEL       // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/list/recipes                      // Holder for all recipes usable with a sheet of this69aterial.
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.

	// Icons
	var/icon_colour                                      // Colour applied to products of this69aterial.
	var/icon_base = "solid"                              // Wall and table base icon tag. See header.
	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/icon_reinf = "reinf_over"                       // Overlay used
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1) // Research level for stacks.

	// Attributes
	var/cut_delay = 0            // Delay in ticks when cutting through this wall.
	var/radioactivity            // Radiation69ar. Used in wall and object processing to irradiate surroundings.
	var/ignition_point           // K, point at which the69aterial catches on fire.
	var/melting_point = 1800     // K, walls will take damage if they're69ext to a fire hotter than this
	var/integrity = 150          // General-use HP69alue for products.
	var/opacity = 1              // Is the69aterial transparent? 0.5<69akes transparent walls/doors.
	var/explosion_resistance = 5 // Only used by walls currently.
	var/conductive = 1           // Objects with this69ar add CONDUCTS to flags on spawn.
	var/list/composite_material  // If set, object69atter69ar will be a list containing these69alues.

	// Placeholder69ars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/created_window_full
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	// Damage69alues.
	var/hardness = 60            // Prob of wall destruction by hulk, used for edge damage in weapons.
	var/weight = 20              // Determines blunt damage/throwforce for weapons.

	//69oise when someone is faceplanted onto a table69ade of this69aterial.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	//69oise69ade when a simple door69ade of this69aterial opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	//69oise69ade when you hit structure69ade of this69aterial.
	var/hitsound = 'sound/weapons/genhit.ogg'
	// Path to resulting stacktype. Todo remove69eed for this.
	var/stack_type
	// Wallrot crumble69essage.
	var/rotting_touch_message = "crumbles under your touch"

// Placeholders for light tiles and rglass.
/material/proc/build_rod_product(var/mob/user,69ar/obj/item/stack/used_stack,69ar/obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, SPAN_WARNING("You cannot69ake anything out of \the 69target_stack69"))
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		to_chat(user, SPAN_WARNING("You69eed one rod and one sheet of 69display_name69 to69ake anything useful."))
		return
	used_stack.use(1)
	target_stack.use(1)
	var/obj/item/stack/S =69ew rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)

/material/proc/build_wired_product(var/mob/user,69ar/obj/item/stack/used_stack,69ar/obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, SPAN_WARNING("You cannot69ake anything out of \the 69target_stack69"))
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, SPAN_WARNING("You69eed five wires and one sheet of 69display_name69 to69ake anything useful."))
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, SPAN_NOTICE("You attach wire to the 69name69."))
	var/obj/item/product =69ew wire_product(get_turf(user))
	if(!(user.l_hand && user.r_hand))
		user.put_in_hands(product)

//69ake sure we have a display69ame and shard icon even if they aren't explicitly set.
/material/New()
	..()
	if(!display_name)
		display_name =69ame
	if(!use_name)
		use_name = display_name
	if(!shard_icon)
		shard_icon = shard_type

// This is a placeholder for proper integration of windows/windoors into the system.
/material/proc/build_windows(var/mob/living/user,69ar/obj/item/stack/used_stack)
	return 0

// Weapons handle applying a divisor for this69alue locally.
/material/proc/get_blunt_damage()
	return weight //todo

// Return the69atter comprising this69aterial.
/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter69material_string69 = composite_material69material_string69
	else
		temp_matter69name69 = 1
	return temp_matter

// As above.
/material/proc/get_edge_damage()
	return hardness //todo

// Snowflakey, only checked for alien doors at the69oment.
/material/proc/can_open_material_door(var/mob/living/user)
	return 1

// Currently used for weapons and objects69ade of uranium to irradiate things.
/material/proc/products_need_process()
	return (radioactivity>0) //todo

// Used by walls when qdel()ing to avoid69eighbor69erging.
/material/placeholder
	name = "placeholder"

// Places a girder object when a wall is dismantled, also applies reinforced69aterial.
/material/proc/place_dismantled_girder(target,69aterial/reinf_material)
	var/obj/structure/girder/G =69ew(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()

// Use this to drop a given amount of69aterial.
/material/proc/place_material(target, amount=1,69ob/living/user =69ull)
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
		return69ew stack_type(target, amount)

// As above.
/material/proc/place_shard(target, amount=1)
	if(shard_type)
		return69ew /obj/item/material/shard(target, src.name, amount)

// Used by walls and weapons to determine if they break or69ot.
/material/proc/is_brittle()
	return !!(flags &69ATERIAL_BRITTLE)

/material/proc/combustion_effect(var/turf/T,69ar/temperature)
	return

// Datum definitions follow.
/material/uranium
	name =69ATERIAL_URANIUM
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"

/material/diamond
	name =69ATERIAL_DIAMOND
	stack_type = /obj/item/stack/material/diamond
	flags =69ATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)

/material/gold
	name =69ATERIAL_GOLD
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	icon_colour = "#EDD12F"

/material/silver
	name =69ATERIAL_SILVER
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/plasma
	name =69ATERIAL_PLASMA
	stack_type = /obj/item/stack/material/plasma
	ignition_point = PLASMA_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PLASMA = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/material/plasma/combustion_effect(var/turf/T,69ar/temperature,69ar/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPlasma = 0
	for(var/turf/simulated/floor/target_tile in RANGE_TURFS(2, T))
		var/plasmaToDeduce = (temperature/30) * effect_multiplier
		totalPlasma += plasmaToDeduce
		target_tile.assume_gas("plasma", plasmaToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPlasma/100)
*/

/material/stone
	name =69ATERIAL_SANDSTONE
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/material/stone/marble
	name =69ATERIAL_MARBLE
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 100
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/material/steel
	name =69ATERIAL_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = PLASTEEL_COLOUR
	hitsound = 'sound/weapons/genhit.ogg'

/material/steel/holographic
	name = "holo" +69ATERIAL_STEEL
	display_name =69ATERIAL_STEEL
	stack_type =69ull
	shard_type = SHARD_NONE

/material/plasteel
	name =69ATERIAL_PLASTEEL
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = PLASTEEL_COLOUR//"#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	stack_origin_tech = list(TECH_MATERIAL = 2)
	hitsound = 'sound/weapons/genhit.ogg'

/material/plasteel/titanium
	name = "titanium"
	stack_type =69ull
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"

/material/glass
	name =69ATERIAL_GLASS
	stack_type = /obj/item/stack/material/glass
	flags =69ATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 30
	weight = 15
	door_icon_base = "stone"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 6)
	created_window = /obj/structure/window/basic
	created_window_full = /obj/structure/window/basic/full
	rod_product = /obj/item/stack/material/glass/reinforced
	hitsound = 'sound/effects/Glasshit.ogg'

/material/glass/build_windows(var/mob/living/user,69ar/obj/item/stack/used_stack)

	if(!user || !used_stack || !created_window || !window_options.len)
		return 0

	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("This task is too complex for your clumsy hands."))
		return 1

	var/turf/T = user.loc
	if(!istype(T))
		to_chat(user, SPAN_WARNING("You69ust be standing on open flooring to build a window."))
		return 1

	var/title = "Sheet-69used_stack.name69 (69used_stack.get_amount()69 sheet\s left)"
	var/choice = input(title, "What would you like to construct?") as69ull|anything in window_options

	if(!choice || !used_stack || !user || used_stack.loc != user || user.stat || user.loc != T)
		return 1

	// Get the closest available dir to the user's current facing.
	var/build_dir = SOUTHWEST //Default to southwest for fulltile windows.
	if(choice in list("One Direction","Windoor"))
		// Get data for building windows here.
		var/list/possible_directions = cardinal.Copy()
		var/window_count = 0
		for (var/obj/structure/window/check_window in user.loc)
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
					to_chat(user, SPAN_WARNING("This69aterial is69ot reinforced enough to use for a door."))
					return
				if((locate(/obj/structure/windoor_assembly) in T.contents) || (locate(/obj/machinery/door/window) in T.contents))
					failed_to_build = 1

		if(failed_to_build)
			to_chat(user, SPAN_WARNING("There is69o room in this location."))
			return 1

	else
		build_dir = SOUTHWEST
		//We're attempting to build a full window.
		//We69eed to find a suitable low wall to build ontop of
		var/obj/structure/low_wall/mount =69ull
		//We will check the tile infront of the user
		var/turf/t = get_step(T, user.dir)
		mount = locate(/obj/structure/low_wall) in t


		if (!mount)
			to_chat(user, SPAN_WARNING("Full windows69ust be69ounted on a low wall infront of you."))
			return 1

		if (locate(/obj/structure/window) in t)
			to_chat(user, SPAN_WARNING("The target tile69ust be clear of other windows"))
			return 1

		//building will be successful, lets set the build location
		T = t

	var/build_path = /obj/structure/windoor_assembly
	var/sheets_needed = window_options69choice69
	if(choice == "Windoor")
		build_dir = user.dir
	else if (choice == "Full Window")
		build_path = created_window_full
	else
		build_path = created_window

	if(used_stack.get_amount() < sheets_needed)
		to_chat(user, SPAN_WARNING("You69eed at least 69sheets_needed69 sheets to build this."))
		return 1

	// Build the structure and update sheet count etc.
	used_stack.use(sheets_needed)
	var/obj/O =69ew build_path(T, build_dir)
	O.Created(user)
	return 1

/material/glass/proc/is_reinforced()
	return (hardness > 35) //todo

/material/glass/reinforced
	name =69ATERIAL_RGLASS
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	flags =69ATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 40
	weight = 30
	stack_origin_tech = "materials=2"
	composite_material = list(MATERIAL_STEEL = 2,MATERIAL_GLASS = 3)
	window_options = list("One Direction" = 1, "Full Window" = 6, "Windoor" = 5)
	created_window = /obj/structure/window/reinforced
	created_window_full = /obj/structure/window/reinforced/full
	wire_product =69ull
	rod_product =69ull

/material/glass/plasma
	name =69ATERIAL_PLASMAGLASS
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/plasmaglass
	flags =69ATERIAL_BRITTLE
	integrity = 100
	icon_colour = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	created_window = /obj/structure/window/plasmabasic
	created_window_full = /obj/structure/window/plasmabasic/full
	wire_product =69ull
	rod_product = /obj/item/stack/material/glass/plasmarglass

/material/glass/plasma/reinforced
	name =69ATERIAL_RPLASMAGLASS
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/plasmarglass
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list() //todo
	created_window = /obj/structure/window/reinforced/plasma
	created_window_full = /obj/structure/window/reinforced/plasma/full
	hardness = 40
	weight = 30
	//composite_material = list() //todo
	rod_product =69ull

/material/plastic
	name =69ATERIAL_PLASTIC
	stack_type = /obj/item/stack/material/plastic
	flags =69ATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/material/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type =69ull
	shard_type = SHARD_NONE

/material/osmium
	name =69ATERIAL_OSMIUM
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/tritium
	name =69ATERIAL_TRITIUM
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/mhydrogen
	name =69ATERIAL_MHYDROGEN
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	display_name = "metallic hydrogen"

/material/platinum
	name =69ATERIAL_PLATINUM
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/iron
	name =69ATERIAL_IRON
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'

// Adminspawn only, do69ot let anyone get this.
/material/voxalloy
	name = "voxalloy"
	display_name = "durable alloy"
	stack_type =69ull
	icon_colour = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500

/material/wood
	name =69ATERIAL_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#824B28"
	integrity = 50
	icon_base = "solid"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18
	melting_point = T0C+300 //okay,69ot69elting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"
	hitsound = 'sound/effects/woodhit.ogg'

/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	stack_type =69ull
	shard_type = SHARD_NONE

/material/cardboard
	name =69ATERIAL_CARDBOARD
	stack_type = /obj/item/stack/material/cardboard
	flags =69ATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 1
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"

/material/cloth //todo
	name =69ATERIAL_CLOTH
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags =69ATERIAL_PADDING

/material/biomatter
	name =69ATERIAL_BIOMATTER
	stack_type = /obj/item/stack/material/biomatter
	icon_colour = "#F48042"
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/material/compressed
	name =69ATERIAL_COMPRESSED
	stack_type = /obj/item/stack/material/compressed
	icon_colour = "#00E1FF"
	sheet_singular_name = "cartrigde"
	sheet_plural_name = "cartridges"

//TODO PLACEHOLDERS:
/material/leather
	name =69ATERIAL_LEATHER
	icon_colour = "#5C4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags =69ATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300

/material/carpet
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"

/material/cotton
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth_teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth_black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth_green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth_puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth_blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth_beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth_lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags =69ATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
