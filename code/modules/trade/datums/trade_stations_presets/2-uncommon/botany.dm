/datum/trade_station/botany
	name_pool = list(
		"MTV \'Arbor\'" = "Moebius Trade Vessel \'Arbor\': Connection with the Moebius botanical research network established."
	)
	icon_states = list("moe_capital", "ship")
	uid = "botany"
	tree_x = 0.34
	tree_y = 0.6
	start_discovered = FALSE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 10
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 3000
	recommendation_threshold = 0
	stations_recommended = list()
	recommendations_needed = 2
	inventory = list(
		"Biochemistry/Special" = list(
			/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency = custom_good_name("plant gene disk: potency (50)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/special/immutable = custom_good_name("plant gene disk: immutable"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/special/mutable = custom_good_name("plant gene disk: mutable"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/special/highly_mutable = custom_good_name("plant gene disk: highly mutable"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/special/chem_sprayer = custom_good_name("plant gene disk: chemical sprayer"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/special/no_chem_sprayer = custom_good_name("plant gene disk: non-spraying"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/cleaner = custom_good_name("plant gene disk: cleaner-producing"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/eznutrient = custom_good_name("plant gene disk: E-Z-nutrient-producing"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/left4zed = custom_good_name("plant gene disk: Left 4 Zed-producing"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/robustharvest = custom_good_name("plant gene disk: Robust Harvest-producing"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/mutagen = custom_good_name("plant gene disk: mutagen-producing")
		),
		"Atmosphere/Environment" = list(
			/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/low_kpa_tolerance = custom_good_name("plant gene disk: low pressure tolerance (40 kPa)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/high_kpa_tolerance = custom_good_name("plant gene disk: high pressure tolerance (160 kPa)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/heat_tolerance  = custom_good_name("plant gene disk: heat tolerance (70 K)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/ideal_heat = custom_good_name("plant gene disk: ideal heat (273 K)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/light_tolerance = custom_good_name("plant gene disk: light tolerance (10)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/ideal_light = custom_good_name("plant gene disk: ideal light (10)")
		),
		"Hardiness" = list(
			/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/toxins_tolerance = custom_good_name("plant gene disk: toxin tolerance (7)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/pest_tolerance = custom_good_name("plant gene disk: pest tolerance (7)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/weed_tolerance = custom_good_name("plant gene disk: weed tolerance (7)")
		),
		"Vigour/Structure" = list(
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield = custom_good_name("plant gene disk: yield (5)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production = custom_good_name("plant gene disk: production (5)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation = custom_good_name("plant gene disk: maturation (5)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/not_spreading = custom_good_name("plant gene disk: non-spreading"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/spreading = custom_good_name("plant gene disk: spreading (1)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/vine_spreading = custom_good_name("plant gene disk: spreading (2)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/wall_hugger = custom_good_name("plant gene disk: wall growth"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/non_wall_hugger = custom_good_name("plant gene disk: no wall growth"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/structure/repeat_harvest = custom_good_name("plant gene disk: repeatable harvest"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/structure/single_harvest = custom_good_name("plant gene disk: single harvest")
		),
		"Output" = list(
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/power_producer = custom_good_name("plant gene disk: battery"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/not_power_producer = custom_good_name("plant gene disk: non-battery"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_off = custom_good_name("plant gene disk: bioluminescence (off)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_dimmer = custom_good_name("plant gene disk: bioluminescence (1)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_dim = custom_good_name("plant gene disk: bioluminescence (2)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_normal = custom_good_name("plant gene disk: bioluminescence (3)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_bright = custom_good_name("plant gene disk: bioluminescence (4)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_brighter = custom_good_name("plant gene disk: bioluminescence (5)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/red = custom_good_name("plant gene disk: light color (red, bright)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/orange = custom_good_name("plant gene disk: light color (orange, bright)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/green = custom_good_name("plant gene disk: light color (green, bright)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/cyan = custom_good_name("plant gene disk: light color (cyan, bright)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/blue = custom_good_name("plant gene disk: light color (blue, bright)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/purple = custom_good_name("plant gene disk: light color (purple, bright)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/red_dark = custom_good_name("plant gene disk: light color (red, dark)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/orange_dark = custom_good_name("plant gene disk: light color (orange, dark)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/green_dark = custom_good_name("plant gene disk: light color (green, dark)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/cyan_dark = custom_good_name("plant gene disk: light color (cyan, dark)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/blue_dark = custom_good_name("plant gene disk: light color (blue, dark)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/purple_dark = custom_good_name("plant gene disk: light color (purple, dark)")
		)
	)
	hidden_inventory = list(
		"Rare Genes" = list(
			/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency_high = custom_good_name("plant gene disk: potency (100)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/no_nutrients_water = custom_good_name("plant gene disk: no nutrients/water"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/requires_nutrients = custom_good_name("plant gene disk: requires nutrients"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/requires_water = custom_good_name("plant gene disk: requires water"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield_high = custom_good_name("plant gene disk: yield (10)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production_high = custom_good_name("plant gene disk: production (3)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation_fast = custom_good_name("plant gene disk: maturation (3)"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/carnivorous = custom_good_name("plant gene disk: carnivorous"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/noncarnivorous = custom_good_name("plant gene disk: non-carnivorous"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/parasitic = custom_good_name("plant gene disk: parasitic"),
			/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/nonparasitic = custom_good_name("plant gene disk: non-parasitic")
		)
	)
	offer_types = list(
		/obj/item/tool/minihoe = offer_data_mods("modified minihoe (3 upgrades)", 1400, 2, OFFER_MODDED_TOOL, 3),
		/obj/item/tool/hatchet = offer_data_mods("modified hatchet (3 upgrades)", 1400, 2, OFFER_MODDED_TOOL, 3)
	)
