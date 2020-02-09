/obj/random/junk //Broken items, or stuff that could be picked up
	has_postspawn = TRUE
	name = "random junk"
	icon_state = "junk-black"
	var/list/exclusions = list()
	var/list/items = list(
		/obj/item/weapon/material/shard = 5,
		/obj/item/weapon/material/shard/shrapnel = 8,
		/obj/item/weapon/reagent_containers/pill/floorpill = 8,
		/obj/item/stack/material/cardboard = 3,
		/obj/item/weapon/storage/box/lights/mixed = 3,
		/obj/item/weapon/storage/box/matches = 4,
		/obj/item/weapon/folder = 2,
		/obj/item/weapon/folder/blue = 2,
		/obj/item/weapon/folder/red = 2,
		/obj/item/weapon/folder/yellow = 2,
		/obj/item/weapon/folder/cyan = 2,
		/obj/item/weapon/circuitboard/broken = 3,
		/obj/item/trash/material/metal = 9,
		/obj/item/trash/material/circuit = 6,
		/obj/item/trash/material/device = 5,
		/obj/item/weapon/tool/tape_roll = 3,
		/obj/item/trash/candle = 1,
		/obj/item/trash/candy = 1,
		/obj/item/trash/cheesie = 1,
		/obj/item/trash/chips = 1,
		/obj/item/trash/liquidfood = 1,
		/obj/item/trash/pistachios = 1,
		/obj/item/trash/plate = 1,
		/obj/item/trash/raisins = 1,
		/obj/item/trash/semki = 1,
		/obj/item/trash/snack_bowl = 1,
		/obj/item/trash/sosjerky = 1,
		/obj/item/trash/syndi_cakes = 1,
		/obj/item/trash/tastybread = 1,
		/obj/item/trash/tray = 1,
		/obj/item/trash/waffles = 1,
		/obj/item/weapon/caution = 3,
		/obj/item/weapon/caution/cone = 3,
		/obj/item/weapon/c_tube = 2,
		/obj/item/weapon/wrapping_paper = 2,
		/obj/item/weapon/implanter = 3,
		/obj/item/weapon/newspaper = 5,
		/obj/item/weapon/ore/glass = 3,
		/obj/item/weapon/pen = 3,
		/obj/item/weapon/reagent_containers/glass/beaker = 1,
		/obj/item/weapon/reagent_containers/glass/bucket = 1,
		/obj/item/weapon/reagent_containers/glass/rag = 1,
		/obj/item/weapon/reagent_containers/food/drinks/jar = 1,
		/obj/item/weapon/reagent_containers/food/drinks/flask/barflask = 1,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 1,
		/obj/item/weapon/reagent_containers/blood/empty = 1,
		/obj/item/weapon/reagent_containers/dropper = 1,
		/obj/item/stack/rods = 4,
		/obj/item/weapon/paper = 3,
		/obj/item/remains/robot = 1,
		/obj/item/trash/cigbutt = 3,
		/obj/effect/decal/cleanable/blood/gibs/robot = 1,
		/obj/effect/decal/cleanable/blood/oil = 1,
		/obj/effect/decal/cleanable/blood/oil/streak = 1,
		/obj/effect/decal/cleanable/molten_item = 1,
		/obj/effect/decal/cleanable/spiderling_remains = 1,
		/obj/effect/decal/cleanable/vomit = 1,
		/obj/effect/decal/cleanable/blood/splatter = 1,
		/obj/effect/spider/stickyweb = 2, //These are useful for tape crafting
	)

/obj/random/junk/post_spawn(var/list/stuff)
	for (var/atom/thing in stuff)
		if (prob(30))
			thing.make_old()

/obj/random/junk/item_to_spawn()
	return pickweight(items - exclusions)

/obj/random/junk/nondense
	exclusions = list(/obj/random/scrap/moderate_weighted, /obj/item/remains/robot)

/obj/random/junk/low_chance
	name = "low chance random junk"
	icon_state = "junk-black-low"
	spawn_nothing_percentage = 60
