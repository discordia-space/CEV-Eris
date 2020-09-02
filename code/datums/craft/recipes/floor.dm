/datum/craft_recipe/floor
	category = "Tiles"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL),
	)
	flags = CRAFT_BATCH
	time = 1 //Crafting individual tiles is fast
	related_stats = list(STAT_MEC)

/datum/craft_recipe/floor/classic/
	name = "wood floor tile"
	result = /obj/item/stack/tile/wood
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)
	name_craft_menu = "Classic tiles"

/datum/craft_recipe/floor/classic/cafe
	name = "cafe floor tile"
	result = /obj/item/stack/tile/floor/cafe
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_PLASTIC)
	)
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/classic/techmaint
	name = "maint floor tile"
	result = /obj/item/stack/tile/floor/techmaint
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/classic/techmaint_perforated
	name = "perforated maint floor tile"
	result = /obj/item/stack/tile/floor/techmaint/perforated
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/classic/techmaint_panels
	name = "panels maint floor tile"
	result = /obj/item/stack/tile/floor/techmaint/panels
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/classic/techmaint_cargo
	name = "cargo maint floor tile"
	result = /obj/item/stack/tile/floor/techmaint/cargo
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel
	name = "regular steel floor tile"
	result = /obj/item/stack/tile/floor/steel
	name_craft_menu = "Steel tiles"

/datum/craft_recipe/floor/steel/panels
	name = "steel panel tile"
	result = /obj/item/stack/tile/floor/steel/panels
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/techfloor
	name = "steel techfloor tile"
	result = /obj/item/stack/tile/floor/steel/techfloor
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/techfloor_grid
	name = "steel techfloor tile with vents"
	result = /obj/item/stack/tile/floor/steel/techfloor_grid
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/brown_perforated
	name = "steel brown perforated tile"
	result = /obj/item/stack/tile/floor/steel/brown_perforated
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/gray_perforated
	name = "steel gray perforated tile"
	result = /obj/item/stack/tile/floor/steel/gray_perforated
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/cargo
	name = "steel cargo tile"
	result = /obj/item/stack/tile/floor/steel/cargo
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/brown_platform
	name = "steel brown platform tile"
	result = /obj/item/stack/tile/floor/steel/brown_platform
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/gray_platform
	name = "steel gray platform tile"
	result = /obj/item/stack/tile/floor/steel/gray_platform
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/danger
	name = "steel danger tile"
	result = /obj/item/stack/tile/floor/steel/danger
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/golden
	name = "steel golden tile"
	result = /obj/item/stack/tile/floor/steel/golden
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/bluecorner
	name = "steel blue corner tile"
	result = /obj/item/stack/tile/floor/steel/bluecorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/orangecorner
	name = "steel orange corner tile"
	result = /obj/item/stack/tile/floor/steel/orangecorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/cyancorner
	name = "steel cyan corner tile"
	result = /obj/item/stack/tile/floor/steel/cyancorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/violetcorener
	name = "steel violet corener tile"
	result = /obj/item/stack/tile/floor/steel/violetcorener
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/monofloor
	name = "steel monofloor tile"
	result = /obj/item/stack/tile/floor/steel/monofloor
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/bar_flat
	name = "steel bar flat tile"
	result = /obj/item/stack/tile/floor/steel/bar_flat
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/bar_dance
	name = "steel bar dance tile"
	result = /obj/item/stack/tile/floor/steel/bar_dance
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/steel/bar_light
	name = "steel bar light tile"
	result = /obj/item/stack/tile/floor/steel/bar_light
	variation_type = CRAFT_VARIATION



/datum/craft_recipe/floor/white
	name = "regular white floor tile"
	result = /obj/item/stack/tile/floor/white
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_PLASTIC)
	)
	name_craft_menu = "White tiles"

/datum/craft_recipe/floor/white/panels
	name = "white panel tile"
	result = /obj/item/stack/tile/floor/white/panels
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/techfloor
	name = "white techfloor tile"
	result = /obj/item/stack/tile/floor/white/techfloor
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/techfloor_grid
	name = "white techfloor tile with vents"
	result = /obj/item/stack/tile/floor/white/techfloor_grid
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/brown_perforated
	name = "white brown perforated tile"
	result = /obj/item/stack/tile/floor/white/brown_perforated
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/gray_perforated
	name = "white gray perforated tile"
	result = /obj/item/stack/tile/floor/white/gray_perforated
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/cargo
	name = "white cargo tile"
	result = /obj/item/stack/tile/floor/white/cargo
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/brown_platform
	name = "white brown platform tile"
	result = /obj/item/stack/tile/floor/white/brown_platform
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/gray_platform
	name = "white gray platform tile"
	result = /obj/item/stack/tile/floor/white/gray_platform
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/danger
	name = "white danger tile"
	result = /obj/item/stack/tile/floor/white/danger
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/golden
	name = "white golden tile"
	result = /obj/item/stack/tile/floor/white/golden
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/bluecorner
	name = "white blue corner tile"
	result = /obj/item/stack/tile/floor/white/bluecorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/orangecorner
	name = "white orange corner tile"
	result = /obj/item/stack/tile/floor/white/orangecorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/cyancorner
	name = "white cyan corner tile"
	result = /obj/item/stack/tile/floor/white/cyancorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/violetcorener
	name = "white violet corener tile"
	result = /obj/item/stack/tile/floor/white/violetcorener
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/white/monofloor
	name = "white monofloor tile"
	result = /obj/item/stack/tile/floor/white/monofloor
	variation_type = CRAFT_VARIATION





/datum/craft_recipe/floor/dark
	name = "regular dark floor tile"
	result = /obj/item/stack/tile/floor/dark
	name_craft_menu = "Dark tiles"

/datum/craft_recipe/floor/dark/panels
	name = "dark panel tile"
	result = /obj/item/stack/tile/floor/dark/panels
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/techfloor
	name = "dark techfloor tile"
	result = /obj/item/stack/tile/floor/dark/techfloor
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/techfloor_grid
	name = "dark techfloor tile with vents"
	result = /obj/item/stack/tile/floor/dark/techfloor_grid
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/brown_perforated
	name = "dark brown perforated tile"
	result = /obj/item/stack/tile/floor/dark/brown_perforated
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/gray_perforated
	name = "dark gray perforated tile"
	result = /obj/item/stack/tile/floor/dark/gray_perforated
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/cargo
	name = "dark cargo tile"
	result = /obj/item/stack/tile/floor/dark/cargo
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/brown_platform
	name = "dark brown platform tile"
	result = /obj/item/stack/tile/floor/dark/brown_platform
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/gray_platform
	name = "dark gray platform tile"
	result = /obj/item/stack/tile/floor/dark/gray_platform
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/danger
	name = "dark danger tile"
	result = /obj/item/stack/tile/floor/dark/danger
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/golden
	name = "dark golden tile"
	result = /obj/item/stack/tile/floor/dark/golden
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/bluecorner
	name = "dark blue corner tile"
	result = /obj/item/stack/tile/floor/dark/bluecorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/orangecorner
	name = "dark orange corner tile"
	result = /obj/item/stack/tile/floor/dark/orangecorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/cyancorner
	name = "dark cyan corner tile"
	result = /obj/item/stack/tile/floor/dark/cyancorner
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/violetcorener
	name = "dark violet corener tile"
	result = /obj/item/stack/tile/floor/dark/violetcorener
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/dark/monofloor
	name = "dark monofloor tile"
	result = /obj/item/stack/tile/floor/dark/monofloor
	variation_type = CRAFT_VARIATION

/datum/craft_recipe/floor/lighttile
	name = "light tile"
	result = /obj/machinery/floor_light
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_GLASS, "time" = 30),
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL, "time" = 10),
		list(QUALITY_SCREW_DRIVING, 10, 80),
		list(/obj/item/stack/cable_coil, 5, "time" = 20),
		list(QUALITY_PULSING, 30, 80)
	)

/datum/craft_recipe/floor/grille
	name = "regular grille"
	result = /obj/structure/grille
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(/obj/item/stack/rods, 2, "time" = 10)
	)


