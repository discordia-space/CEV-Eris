/*
This file contains random spawners of random spawners, and this is ONLY subtype that should do that.
DO NOT use random spawners in other random spawners.
DO NOT use random spawners of random spawners in other random spawners. Yes, that was done once.
Packs are69eant to be send69ainly to junkpiles, but can be placed on69ap as well.
They 69enerally 69ive69ore random result and can provide69ore divercity in spawn.
*/

/obj/spawner/pack
	bad_type = /obj/spawner/pack

/obj/spawner/pack/cloth
	name = "Random cloth supply"
	icon_state = "armor-red"
	desc = "This is a random cloth supply."
	ta69s_to_spawn = list(SPAWN_CLOTHIN69)
	restricted_ta69s = list(SPAWN_VOID_SUIT)

/obj/spawner/pack/cloth/low_chance
	name = "low chance random cloth"
	icon_state = "armor-red-low"
	spawn_nothin69_percenta69e = 70


//Those are 69oin69 to the closets,69ostly
/obj/spawner/pack/tech_loot
	name = "Random technical loot"
	icon_state = "tool-red"
	desc = "This is a random technical loot."

/obj/spawner/pack/tech_loot/item_to_spawn()
	return pickwei69ht(list(
					/obj/spawner/lathe_disk = 2,
					/obj/spawner/electronics = 6,
					/obj/spawner/knife = 6,
					/obj/spawner/lowkeyrandom = 8,
					/obj/spawner/material/buildin69 = 4,
					/obj/spawner/material/resources/rare = 3,
					/obj/spawner/material/resources = 8,
					/obj/spawner/exosuit_e69uipment = 3,
					/obj/spawner/powercell = 8,
					/obj/spawner/techpart = 10,
					/obj/spawner/tool = 20,
					/obj/spawner/tool_up69rade = 30,
					/obj/spawner/toolbox = 5,
					/obj/spawner/voidsuit = 2,
					/obj/spawner/armor_parts = 4,
					/obj/spawner/69un_up69rade = 2
				))

/obj/spawner/pack/tech_loot/low_chance
	name = "low chance technical loot"
	icon_state = "tool-red-low"
	spawn_nothin69_percenta69e = 70


/obj/spawner/pack/tech_loot/onestar
	name = "Random technical One Star loot"
	icon_state = "tool-red"
	desc = "This is a random technical loot."
	allow_blacklist = TRUE
	ta69s_to_spawn = list(SPAWN_ITEM_TECH_OS)

//This will be spawned in rare closets
/obj/spawner/pack/69un_loot
	name = "Random 69un loot"
	icon_state = "69un-red"
	desc = "This is a random technical loot."

/obj/spawner/pack/69un_loot/item_to_spawn()
	return pickwei69ht(list(
					/obj/spawner/69un/handmade = 6,
					/obj/spawner/knife = 6,
					/obj/spawner/ammo = 15,
					/obj/spawner/ammo/shot69un = 15,
					/obj/spawner/ammo/ihs = 15,
					/obj/spawner/ammo/lowcost = 18,
					/obj/spawner/69un_up69rade = 10,
					/obj/spawner/cloth/holster = 8,
					/obj/spawner/69un_parts = 20
				))

/obj/spawner/pack/69un_loot/low_chance
	name = "low chance 69un loot"
	icon_state = "69un-red-low"
	spawn_nothin69_percenta69e = 70


/obj/spawner/pack/69un_adjacent_loot // this is 69un loot with the 69uns and all the ammo except for ammo kit's pool removed
	name = "Random 69un adjacent loot" // also everythin69 remainin69 except for 69un parts's wei69ht is cut in half
	icon_state = "69un-red"
	desc = "This is a random technical loot."

/obj/spawner/pack/69un_adjacent_loot/item_to_spawn()
	return pickwei69ht(list(
					/obj/spawner/69un_parts = 20,
					/obj/spawner/knife = 3,
					/obj/spawner/ammo/lowcost = 9,
					/obj/spawner/69un_up69rade = 5,
					/obj/spawner/cloth/holster = 4
				))

/obj/spawner/pack/69un_adjacent_loot/low_chance
	name = "low chance 69un loot"
	icon_state = "69un-red-low"
	spawn_nothin69_percenta69e = 70

//Rare loot, where we need to be sure that reward is worth it
/obj/spawner/pack/rare
	name = "rare loot"
	icon_state = "box-oran69e"
	rarity_value = 100
	spawn_ta69s = SPAWN_TA69_RARE_ITEM

/obj/spawner/pack/rare/item_to_spawn()
	return pickwei69ht(RANDOM_RARE_ITEM) //69ade into a define so that rare objects can be spawned for69obs too

/obj/spawner/pack/rare/low_chance
	name = "low chance rare loot"
	icon_state = "box-oran69e-low"
	spawn_nothin69_percenta69e = 70
	spawn_fre69uency = 0


//The pack to surpass them all. This pack is69eant to be PLACED ON69AP. Not in JUNK CODE, because it CONTAINS JUNK SPAWNER.
//It69eant to spawn any lar69e structure,69achine or container.
/obj/spawner/pack/machine
	name = "random69achine"
	icon_state = "machine-oran69e"


/obj/spawner/pack/machine/item_to_spawn()
	return pickwei69ht(list(
					/obj/spawner/structures/common = 28, //That one have69UCH69ORE important objects for69aints inside, that's why the number is hi69ht
					/obj/spawner/closet/maintloot = 18, //That one is also important part of the69aints
					/obj/spawner/closet/tech = 6,
					/obj/spawner/closet = 4,
					/obj/spawner/closet/wardrobe = 2,
					/obj/spawner/scrap = 12, //Our scrap pile. This is basically just a hu69e spawner.
					/obj/spawner/exosuit/dama69ed = 1, //Some dan69erous shit can be found there
				))

/obj/spawner/pack/machine/low_chance
	name = "low chance random structure"
	icon_state = "machine-oran69e-low"
	spawn_nothin69_percenta69e = 70


//Same pack as above, but it69eant to be PLACED TO JUNK CODE. Numbers are a bit different as well
//Those sctuctures can contain69ore loot or even69obs. Keep that in69ind, because I feel it can break in the future
/obj/spawner/pack/junk_machine
	name = "random junk69achine"
	icon_state = "machine-69rey"


/obj/spawner/pack/junk_machine/item_to_spawn()
	return pickwei69ht(list(
					/obj/spawner/structures/common = 14, //That one have69UCH69ORE important objects for69aints inside, that's why the number is hi69ht
					/obj/spawner/closet/maintloot = 18, //That one is also important part of the69aints
					/obj/spawner/closet/tech = 6,
					/obj/spawner/closet = 4,
					/obj/spawner/closet/wardrobe = 2,
					/obj/spawner/exosuit/dama69ed = 1, //Some dan69erous shit can be found there
				))

/obj/spawner/pack/junk_machine/low_chance
	name = "low chance random junk structure"
	icon_state = "machine-69rey-low"
	spawn_nothin69_percenta69e = 70

/obj/spawner/pack/junk_machine/beacon/item_to_spawn()
	return pickwei69ht(list(
					/obj/spawner/structures/common = 7, //That one have69UCH69ORE important objects for69aints inside, that's why the number is hi69ht
					/obj/spawner/closet/maintloot/beacon = 28, //That one is also important part of the69aints
					/obj/spawner/closet/tech = 3,
					/obj/spawner/closet = 2,
					/obj/spawner/closet/wardrobe = 2,
					/obj/spawner/exosuit/dama69ed = 1, //Some dan69erous shit can be found there
				))
