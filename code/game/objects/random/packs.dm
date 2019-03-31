/*
This file contains random spawners of random spawners, and this is ONLY subtype that should do that.
DO NOT use random spawners in other random spawners.
DO NOT use random spawners of random spawners in other random spawners. Yes, that was done once.
Packs are meant to be send mainly to junkpiles, but can be placed on map as well.
They generally give more random result and can provide more divercity in spawn.
*/

/obj/random/pack/cloth
	name = "Random cloth supply"
	icon_state = "armor-red"
	desc = "This is a random cloth supply."

/obj/random/pack/cloth/item_to_spawn()
	return pickweight(list(
					/obj/random/cloth/masks = 5,
					/obj/random/cloth/armor = 3,
					/obj/random/cloth/suit = 3,
					/obj/random/cloth/hazmatsuit = 4,
					/obj/random/cloth/under = 7,
					/obj/random/cloth/helmet = 4,
					/obj/random/cloth/head = 5,
					/obj/random/cloth/gloves = 5,
					/obj/random/cloth/glasses = 4,
					/obj/random/cloth/shoes = 6,
					/obj/random/cloth/backpack = 4,
					/obj/random/cloth/belt = 4,
				))

/obj/random/pack/cloth/low_chance
	name = "low chance random cloth"
	icon_state = "armor-red-low"
	spawn_nothing_percentage = 70




//Those are going to the closets, mostly
/obj/random/pack/tech_loot
	name = "Random technical loot"
	icon_state = "tool-red"
	desc = "This is a random technical loot."

/obj/random/pack/tech_loot/item_to_spawn()
	return pickweight(list(
					/obj/random/lathe_disk = 3,
					/obj/random/circuitboard = 6,
					/obj/random/knife = 6,
					/obj/random/lowkeyrandom = 8,
					/obj/random/material = 4,
					/obj/random/material_rare = 3,
					/obj/random/material_resources = 8,
					/obj/random/mecha_equipment = 3,
					/obj/random/powercell = 8,
					/obj/random/techpart = 10,
					/obj/random/tool = 20,
					/obj/random/tool_upgrade = 30,
					/obj/random/toolbox = 5,
					/obj/random/voidsuit = 3,
				))

/obj/random/pack/tech_loot/low_chance
	name = "low chance technical loot"
	icon_state = "tool-red-low"
	spawn_nothing_percentage = 70




//This will be spawned in rare closets
/obj/random/pack/gun_loot
	name = "Random gun loot"
	icon_state = "gun-red"
	desc = "This is a random technical loot."

/obj/random/pack/gun_loot/item_to_spawn()
	return pickweight(list(
					/obj/random/gun_cheap = 3,
					/obj/random/gun_normal = 1,
					/obj/random/gun_energy_cheap = 3,
					/obj/random/gun_shotgun = 2,
					/obj/random/ammo = 8,
					/obj/random/ammo/shotgun = 8,
					/obj/random/ammo_ihs = 8,
					/obj/random/ammo_lowcost = 10,
				))

/obj/random/pack/gun_loot/low_chance
	name = "low chance gun loot"
	icon_state = "gun-red-low"
	spawn_nothing_percentage = 70



/obj/random/pack/structure/item_to_spawn()
	return pickweight(list(


					/obj/random/cloth/glasses = 4,
					/obj/random/cloth/gloves = 12,

				))

