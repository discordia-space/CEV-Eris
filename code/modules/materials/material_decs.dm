/material/uranium
	name = MATERIAL_URANIUM
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 238
	hardness = 80
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"

/material/diamond
	name = MATERIAL_DIAMOND
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 27
	weight = 18
	stack_origin_tech = list(TECH_MATERIAL = 6)

/material/gold
	name = MATERIAL_GOLD
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 197
	hardness = 25
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	icon_colour = "#EDD12F"

/material/silver
	name = MATERIAL_SILVER
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 108
	hardness = 45
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/plasma
	name = MATERIAL_PLASMA
	stack_type = /obj/item/stack/material/plasma
	ignition_point = PLASMA_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	/// ultra light
	weight = 10
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PLASMA = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"

/material/stone
	name = MATERIAL_SANDSTONE
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 201
	hardness = 55
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/material/stone/marble
	name = MATERIAL_MARBLE
	icon_colour = "#AAAAAA"
	weight = 232
	hardness = 100
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/material/steel
	name = MATERIAL_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	weight = 78
	hardness = 60
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = PLASTEEL_COLOUR
	hitsound = 'sound/weapons/genhit.ogg'

/material/steel/holographic
	name = "holo" + MATERIAL_STEEL
	display_name = MATERIAL_STEEL
	stack_type = null
	shard_type = SHARD_NONE

/material/plasteel
	name = MATERIAL_PLASTEEL
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = PLASTEEL_COLOUR//"#777777"
	hardness = 80
	weight = 90
	stack_origin_tech = list(TECH_MATERIAL = 2)
	hitsound = 'sound/weapons/genhit.ogg'

/material/plasteel/titanium
	name = "titanium"
	stack_type = null
	icon_base = "metal"
	weight = 50
	hardness = 90
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"

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
	weight = 35
	door_icon_base = "stone"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 6)
	created_window = /obj/structure/window/basic
	created_window_full = /obj/structure/window/basic/full
	rod_product = /obj/item/stack/material/glass/reinforced
	hitsound = 'sound/effects/Glasshit.ogg'

/material/glass/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)

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
					to_chat(user, SPAN_WARNING("This material is not reinforced enough to use for a door."))
					return
				if((locate(/obj/structure/windoor_assembly) in T.contents) || (locate(/obj/machinery/door/window) in T.contents))
					failed_to_build = 1

		if(failed_to_build)
			to_chat(user, SPAN_WARNING("There is no room in this location."))
			return 1

	else
		build_dir = SOUTHWEST
		//We're attempting to build a full window.
		//We need to find a suitable low wall to build ontop of
		var/obj/structure/low_wall/mount = null
		//We will check the tile infront of the user
		var/turf/t = get_step(T, user.dir)
		mount = locate(/obj/structure/low_wall) in t


		if (!mount)
			to_chat(user, SPAN_WARNING("Full windows must be mounted on a low wall infront of you."))
			return 1

		if (locate(/obj/structure/window) in t)
			to_chat(user, SPAN_WARNING("The target tile must be clear of other windows"))
			return 1

		//building will be successful, lets set the build location
		T = t

	var/build_path = /obj/structure/windoor_assembly
	var/sheets_needed = window_options[choice]
	if(choice == "Windoor")
		build_dir = user.dir
	else if (choice == "Full Window")
		build_path = created_window_full
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
	integrity = 500
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 30
	weight = 225
	stack_origin_tech = "materials=2"
	composite_material = list(MATERIAL_STEEL = 2,MATERIAL_GLASS = 3)
	window_options = list("One Direction" = 1, "Full Window" = 6, "Windoor" = 5)
	created_window = /obj/structure/window/reinforced
	created_window_full = /obj/structure/window/reinforced/full
	wire_product = null
	rod_product = null

/material/glass/plasma
	name = MATERIAL_PLASMAGLASS
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/plasmaglass
	flags = MATERIAL_BRITTLE
	integrity = 700
	icon_colour = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	weight = 50
	hardness = 50
	composite_material = list(MATERIAL_GLASS = 3, MATERIAL_PLASMA = 3)
	created_window = /obj/structure/window/plasmabasic
	created_window_full = /obj/structure/window/plasmabasic/full
	wire_product = null
	rod_product = /obj/item/stack/material/glass/plasmarglass

/material/glass/plasma/reinforced
	name = MATERIAL_RPLASMAGLASS
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/plasmarglass
	integrity = 1000
	weight = 265
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list(MATERIAL_STEEL = 5, MATERIAL_GLASS = 3, MATERIAL_PLASMA = 3) //todo
	created_window = /obj/structure/window/reinforced/plasma
	created_window_full = /obj/structure/window/reinforced/plasma/full
	hardness = 60
	weight = 50
	rod_product = null

/material/plastic
	name = MATERIAL_PLASTIC
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 36
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/material/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/material/osmium
	name = MATERIAL_OSMIUM
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	weight = 190
	hardness = 90
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/tritium
	name = MATERIAL_TRITIUM
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	weight = 3
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/mhydrogen
	name = MATERIAL_MHYDROGEN
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	weight = 8
	hardness = 200
	display_name = "metallic hydrogen"

/material/platinum
	name = MATERIAL_PLATINUM
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 196
	hardness = 50
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/iron
	name = MATERIAL_IRON
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 56
	hardness = 40
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'

// Adminspawn only, do not let anyone get this.
/material/voxalloy
	name = "voxalloy"
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6C7364"
	weight = 500
	integrity = 1200
	melting_point = 6000       // Hull plating.
	hardness = 500
	weight = 500

/material/wood
	name = MATERIAL_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#824B28"
	integrity = 50
	icon_base = "solid"
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 75
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
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
	stack_type = null
	shard_type = SHARD_NONE

/material/cardboard
	name = MATERIAL_CARDBOARD
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 10
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"

/material/cloth //todo
	name = MATERIAL_CLOTH
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	weight = 30
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MATERIAL_PADDING

/material/biomatter
	name = MATERIAL_BIOMATTER
	stack_type = /obj/item/stack/material/biomatter
	icon_colour = "#F48042"
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	weight = 50
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/material/compressed
	name = MATERIAL_COMPRESSED
	stack_type = /obj/item/stack/material/compressed
	icon_colour = "#00E1FF"
	sheet_singular_name = "cartrigde"
	sheet_plural_name = "cartridges"

//TODO PLACEHOLDERS:
/material/leather
	name = MATERIAL_LEATHER
	icon_colour = "#5C4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	weight = 35
	ignition_point = T0C+300
	melting_point = T0C+300

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

/material/cotton
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300

/material/cloth/kevlar
	name = MATERIAL_KEVLAR
	display_name = "kevlar"
	use_name = "kevlar cloth"
	flags = MATERIAL_PADDING
	ignition_point = T0C + 400
	melting_point = T0C + 544
	composite_material = list(MATERIAL_CLOTH = 6)

/material/cloth/kevlar/upgraded
	name = MATERIAL_KEVLARSTEEL
	display_name = "steelweave kevlar"
	use_name = "steelweave kevlar"
	composite_material = list(MATERIAL_CLOTH = 3, MATERIAL_STEEL = 3)
/material/steel/neosteel
	name = MATERIAL_NEOSTEEL
	display_name = "neosteel"
	use_name = "neosteel"
	composite_material = list(MATERIAL_STEEL = 3, MATERIAL_OSMIUM = 1)

/material/titanium/titanplasteelalloy
	name = MATERIAL_TPALLOY
	display_name = "plastitan"
	use_name = "plastitan"
	composite_material = list(MATERIAL_TITANIUM = 2, MATERIAL_PLASTEEL = 1)

/material/titanium/titangoldalloy
	name = MATERIAL_TGALLOY
	display_name = "golditanium"
	use_name = "golditanium"
	composite_material = list(MATERIAL_GOLD = 3, MATERIAL_TITANIUM = 1)

/material/lowreflective
	name = MATERIAL_LOWREFLECTIVE
	display_name = "silver mirror"
	use_name = "silver mirror"
	composite_material = list(MATERIAL_GLASS = 3, MATERIAL_SILVER = 3)

/material/highreflective
	name = MATERIAL_HIGHREFLECTIVE
	display_name = "dielectric alloy"
	use_name = "dielectric alloy"




