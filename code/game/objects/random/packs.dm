/*
This file contains random spawners of random spawners, and this is ONLY subtype that should do that.
DO NOT use random spawners in other random spawners.
DO NOT use random spawners of random spawners in other random spawners. Yes, that was done once.
Packs are meant to be send mainly to junkpiles, but can be placed on map as well.
They generally give more random result and can provide more divercity in spawn.
*/

/obj/spawner/pack
	bad_type = /obj/spawner/pack

/obj/spawner/pack/cloth
	name = "Random cloth supply"
	icon_state = "armor-red"
	desc = "This is a random cloth supply."
	tags_to_spawn = list(SPAWN_CLOTHING)
	restricted_tags = list(SPAWN_VOID_SUIT)

/obj/spawner/pack/cloth/low_chance
	name = "low chance random cloth"
	icon_state = "armor-red-low"
	spawn_nothing_percentage = 70


//Those are going to the closets, mostly
/obj/spawner/pack/tech_loot
	name = "Random technical loot"
	icon_state = "tool-red"
	desc = "This is a random technical loot."

/obj/spawner/pack/tech_loot/item_to_spawn()
	return pickweight(list(
					/obj/spawner/lathe_disk = 2,
					/obj/spawner/electronics = 6,
					/obj/spawner/knife = 6,
					/obj/spawner/lowkeyrandom = 8,
					/obj/spawner/material/building = 4,
					/obj/spawner/material/resources/rare = 3,
					/obj/spawner/material/resources = 8,
					/obj/spawner/exosuit_equipment = 3,
					/obj/spawner/powercell = 8,
					/obj/spawner/techpart = 10,
					/obj/spawner/tool = 20,
					/obj/spawner/tool_upgrade = 30,
					/obj/spawner/toolbox = 5,
					/obj/spawner/voidsuit = 2,
					/obj/spawner/armor_parts = 4,
					/obj/spawner/gun_upgrade = 2
				))

/obj/spawner/pack/tech_loot/low_chance
	name = "low chance technical loot"
	icon_state = "tool-red-low"
	spawn_nothing_percentage = 70


/obj/spawner/pack/tech_loot/onestar
	name = "Random technical One Star loot"
	icon_state = "tool-red"
	desc = "This is a random technical loot."
	allow_blacklist = TRUE
	tags_to_spawn = list(SPAWN_ITEM_TECH_OS)

//This will be spawned in rare closets
/obj/spawner/pack/gun_loot
	name = "Random gun loot"
	icon_state = "gun-red"
	desc = "This is a random technical loot."

/obj/spawner/pack/gun_loot/item_to_spawn()
	return pickweight(list(
					/obj/spawner/gun/cheap = 8,
					/obj/spawner/gun/normal = 3,
					/obj/spawner/gun/energy_cheap = 6,
					/obj/spawner/gun/shotgun = 5,
					/obj/spawner/knife = 6,
					/obj/spawner/ammo = 15,
					/obj/spawner/ammo/shotgun = 15,
					/obj/spawner/ammo/ihs = 15,
					/obj/spawner/ammo/lowcost = 18,
					/obj/spawner/gun_upgrade = 10,
					/obj/spawner/cloth/holster = 8,
					/obj/spawner/gun_parts = 20
				))

/obj/spawner/pack/gun_loot/low_chance
	name = "low chance gun loot"
	icon_state = "gun-red-low"
	spawn_nothing_percentage = 70


/obj/spawner/pack/gun_adjacent_loot // this is gun loot with the guns and all the ammo except for ammo kit's pool removed
	name = "Random gun adjacent loot" // also everything remaining except for gun parts's weight is cut in half
	icon_state = "gun-red"
	desc = "This is a random technical loot."

/obj/spawner/pack/gun_adjacent_loot/item_to_spawn()
	return pickweight(list(
					/obj/spawner/gun_parts = 20,
					/obj/spawner/knife = 3,
					/obj/spawner/ammo/lowcost = 9,
					/obj/spawner/gun_upgrade = 5,
					/obj/spawner/cloth/holster = 4
				))

/obj/spawner/pack/gun_adjacent_loot/low_chance
	name = "low chance gun loot"
	icon_state = "gun-red-low"
	spawn_nothing_percentage = 70

//Rare loot, where we need to be sure that reward is worth it
/obj/spawner/pack/rare
	name = "rare loot"
	icon_state = "box-orange"
	rarity_value = 100
	spawn_tags = SPAWN_TAG_RARE_ITEM

/obj/spawner/pack/rare/item_to_spawn()
	return pickweight(RANDOM_RARE_ITEM) // made into a define so that rare objects can be spawned for mobs too

/obj/spawner/pack/rare/low_chance
	name = "low chance rare loot"
	icon_state = "box-orange-low"
	spawn_nothing_percentage = 70
	spawn_frequency = 0


//The pack to surpass them all. This pack is meant to be PLACED ON MAP. Not in JUNK CODE, because it CONTAINS JUNK SPAWNER.
//It meant to spawn any large structure, machine or container.
/obj/spawner/pack/machine
	name = "random machine"
	icon_state = "machine-orange"


/obj/spawner/pack/machine/item_to_spawn()
	return pickweight(list(
					/obj/spawner/structures/common = 28, //That one have MUCH MORE important objects for maints inside, that's why the number is hight
					/obj/spawner/closet/maintloot = 18, //That one is also important part of the maints
					/obj/spawner/closet/tech = 6,
					/obj/spawner/closet = 4,
					/obj/spawner/closet/wardrobe = 2,
					/obj/spawner/scrap = 12, //Our scrap pile. This is basically just a huge spawner.
					/obj/spawner/exosuit/damaged = 1, //Some dangerous shit can be found there
				))

/obj/spawner/pack/machine/low_chance
	name = "low chance random structure"
	icon_state = "machine-orange-low"
	spawn_nothing_percentage = 70


//Same pack as above, but it meant to be PLACED TO JUNK CODE. Numbers are a bit different as well
//Those sctuctures can contain more loot or even mobs. Keep that in mind, because I feel it can break in the future
/obj/spawner/pack/junk_machine
	name = "random junk machine"
	icon_state = "machine-grey"


/obj/spawner/pack/junk_machine/item_to_spawn()
	return pickweight(list(
					/obj/spawner/structures/common = 14, //That one have MUCH MORE important objects for maints inside, that's why the number is hight
					/obj/spawner/closet/maintloot = 18, //That one is also important part of the maints
					/obj/spawner/closet/tech = 6,
					/obj/spawner/closet = 4,
					/obj/spawner/closet/wardrobe = 2,
					/obj/spawner/exosuit/damaged = 1, //Some dangerous shit can be found there
				))

/obj/spawner/pack/junk_machine/low_chance
	name = "low chance random junk structure"
	icon_state = "machine-grey-low"
	spawn_nothing_percentage = 70

/obj/spawner/pack/junk_machine/beacon/item_to_spawn()
	return pickweight(list(
					/obj/spawner/structures/common = 7, //That one have MUCH MORE important objects for maints inside, that's why the number is hight
					/obj/spawner/closet/maintloot/beacon = 28, //That one is also important part of the maints
					/obj/spawner/closet/tech = 3,
					/obj/spawner/closet = 2,
					/obj/spawner/closet/wardrobe = 2,
					/obj/spawner/exosuit/damaged = 1, //Some dangerous shit can be found there
				))

// This pack is meant to be PLACED ON MAP. Not in JUNK CODE, because it CONTAINS JUNK SPAWNER.
// It meant to spawn any large structure, machine, or container. Contains things that should only be spawned in deep maint or dungeons.
/obj/spawner/pack/deep_machine
	name = "random deepmaint machine"
	icon_state = "machine-orange"

/obj/spawner/pack/deep_machine/item_to_spawn()
	return pickweight(list(
					/obj/spawner/structures/common = 28, //That one have MUCH MORE important objects for maints inside, that's why the number is hight
					/obj/spawner/closet/maintloot = 18, //That one is also important part of the maints
					/obj/spawner/closet/tech = 6,
					/obj/spawner/closet = 4,
					/obj/spawner/closet/wardrobe = 2,
					/obj/spawner/scrap = 12, //Our scrap pile. This is basically just a huge spawner.
					/obj/spawner/exosuit/damaged = 1, //Some dangerous shit can be found there
					/obj/spawner/aberrant_machine = 3
				))
