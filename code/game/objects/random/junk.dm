/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	desc = "This is some random junk."
	icon_state = "junk-black"
	item_to_spawn()
		return pick(/obj/item/weapon/material/shard,\
					/obj/item/weapon/material/shard/shrapnel,\
					/obj/item/stack/material/cardboard,\
					/obj/item/weapon/storage/box/lights/mixed,\
					/obj/item/weapon/storage/box/matches)


/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
	desc = "This is some random trash."
	icon_state = "junk-grey"
	item_to_spawn()
		return pick(/obj/item/weapon/cigbutt,\
					/obj/effect/decal/cleanable/blood/gibs/robot/,\
					/obj/effect/decal/cleanable/blood/oil,\
					/obj/effect/decal/cleanable/blood/oil/streak,\
					/obj/effect/decal/cleanable/molten_item,\
					/obj/effect/decal/cleanable/spiderling_remains,\
					/obj/effect/decal/cleanable/vomit,\
					/obj/effect/decal/cleanable/blood/splatter,\
					/obj/item/remains/robot)
