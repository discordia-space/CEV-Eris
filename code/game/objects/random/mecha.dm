/obj/random/mecha
	name = "random mecha"
	icon_state = "machine-black"
	var/list/randsuits = list(
		/obj/mecha/working/hoverpod = 5,
		/obj/mecha/working/hoverpod/combatpod = 0.5,//Comes with weapons
		/obj/mecha/working/hoverpod/shuttlepod = 6,
		/obj/mecha/working/ripley = 5,
		/obj/mecha/working/ripley/firefighter = 6,
		/obj/mecha/working/ripley/deathripley = 0.5,//has a dangerous melee weapon
		/obj/mecha/working/ripley/mining = 4,
		/obj/mecha/medical/odysseus = 6,
		/obj/mecha/medical/odysseus/loaded = 5,
		/obj/mecha/combat/durand = 1,//comes unarmed
		/obj/mecha/combat/gygax = 1.5,//comes unarmed
		/obj/mecha/combat/gygax/dark = 0.5,//has weapons
		/obj/mecha/combat/marauder = 0.6,
		/obj/mecha/combat/marauder/seraph = 0.3,
		/obj/mecha/combat/marauder/mauler = 0.4,
		/obj/mecha/combat/phazon = 0.1)

/obj/random/mecha/item_to_spawn()
	return pickweight(randsuits)

/obj/random/mecha/damaged
	has_postspawn = TRUE

/obj/random/mecha/damaged/post_spawn(var/list/things)
	for (var/obj/a in things)
		a.make_old()