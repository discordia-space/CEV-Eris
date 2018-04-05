/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	icon_state = "junk-black"

/obj/random/junk/item_to_spawn()
	return pick(prob(5);/obj/item/weapon/material/shard,\
				prob(5);/obj/item/weapon/material/shard/shrapnel,\
				prob(3);/obj/item/stack/material/cardboard,\
				prob(3);/obj/item/weapon/storage/box/lights/mixed,\
				prob(4);/obj/item/weapon/storage/box/matches,\
				prob(2);/obj/item/weapon/folder,\
				prob(2);/obj/item/weapon/folder/blue,\
				prob(2);/obj/item/weapon/folder/red,\
				prob(2);/obj/item/weapon/folder/yellow,\
				prob(2);/obj/item/weapon/folder/white,\
				prob(5);/obj/item/weapon/circuitboard/broken,\
				prob(1);/obj/item/trash/candle,\
				prob(1);/obj/item/trash/candy,\
				prob(1);/obj/item/trash/cheesie,\
				prob(1);/obj/item/trash/chips,\
				prob(1);/obj/item/trash/liquidfood,\
				prob(1);/obj/item/trash/pistachios,\
				prob(1);/obj/item/trash/plate,\
				prob(1);/obj/item/trash/raisins,\
				prob(1);/obj/item/trash/semki,\
				prob(1);/obj/item/trash/snack_bowl,\
				prob(1);/obj/item/trash/sosjerky,\
				prob(1);/obj/item/trash/syndi_cakes,\
				prob(1);/obj/item/trash/tastybread,\
				prob(1);/obj/item/trash/tray,\
				prob(1);/obj/item/trash/waffles,\
				prob(3);/obj/item/weapon/caution,\
				prob(3);/obj/item/weapon/caution/cone,\
				prob(2);/obj/item/weapon/c_tube,\
				prob(2);/obj/item/weapon/wrapping_paper,\
				prob(3);/obj/item/weapon/implanter,\
				prob(5);/obj/item/weapon/newspaper,\
				prob(3);/obj/item/weapon/ore/glass,\
				prob(3);/obj/item/weapon/pen,\
				prob(1);/obj/item/weapon/reagent_containers/glass/beaker,\
				prob(1);/obj/item/weapon/reagent_containers/glass/bucket,\
				prob(1);/obj/item/weapon/reagent_containers/glass/rag,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/jar,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/flask/barflask,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/drinkingglass,\
				prob(1);/obj/item/weapon/reagent_containers/blood/empty,\
				prob(1);/obj/item/weapon/reagent_containers/dropper,\
				prob(4);/obj/item/stack/rods,\
				prob(4);/obj/item/weapon/paper,\
				prob(5);/obj/item/remains/robot,\
				prob(4);/obj/item/weapon/cigbutt,\
				prob(1);/obj/effect/decal/cleanable/blood/gibs/robot,\
				prob(1);/obj/effect/decal/cleanable/blood/oil,\
				prob(1);/obj/effect/decal/cleanable/blood/oil/streak,\
				prob(1);/obj/effect/decal/cleanable/molten_item,\
				prob(1);/obj/effect/decal/cleanable/spiderling_remains,\
				prob(1);/obj/effect/decal/cleanable/vomit,\
				prob(1);/obj/effect/decal/cleanable/blood/splatter)

/obj/random/junk/low_chance
	name = "low chance random junk"
	icon_state = "junk-black-low"
	spawn_nothing_percentage = 60
