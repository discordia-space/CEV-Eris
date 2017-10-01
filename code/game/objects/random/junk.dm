/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	icon_state = "junk-black"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/material/shard,\
					prob(3);/obj/item/weapon/material/shard/shrapnel,\
					prob(3);/obj/item/stack/material/cardboard,\
					prob(3);/obj/item/weapon/storage/box/lights/mixed,\
					prob(3);/obj/item/weapon/storage/box/matches,\
					prob(1);/obj/item/weapon/folder,\
					prob(1);/obj/item/weapon/folder/blue,\
					prob(1);/obj/item/weapon/folder/red,\
					prob(1);/obj/item/weapon/folder/yellow,\
					prob(1);/obj/item/weapon/folder/white)


/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
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
