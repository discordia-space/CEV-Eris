//Rare loot. The rare spawner appears as a subset in other lists
//Mostly it includes the cream of the crop from other lists, and some unique things
/obj/random/rare
	name = "rare spawn"

/obj/random/rare/item_to_spawn()
	return pickweight(list(
	/obj/item/weapon/cell/small/moebius/nuclear = 3,\
	/obj/item/weapon/cell/medium/moebius/hyper = 4,\
	/obj/random/rig = 2,\
	))