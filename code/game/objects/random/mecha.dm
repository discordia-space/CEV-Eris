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


/obj/random/mecha_equipment
	name = "random mecha equipment"
	icon_state = "machine-black"

/obj/random/mecha_equipment/item_to_spawn()
	return pickweight(list(/obj/item/mecha_parts/mecha_equipment/tool/ai_holder,
		/obj/item/mecha_parts/mecha_equipment/tool/sleeper,
		/obj/item/mecha_parts/mecha_equipment/tool/cable_layer,
		/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun,
		/obj/item/mecha_parts/mecha_equipment/thruster = 2,
		/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp,
	 	/obj/item/mecha_parts/mecha_equipment/tool/drill,
	 	/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill,
	 	/obj/item/mecha_parts/mecha_equipment/tool/extinguisher,
	 	/obj/item/mecha_parts/mecha_equipment/tool/rcd,
	 	/obj/item/mecha_parts/mecha_equipment/teleporter,
		/obj/item/mecha_parts/mecha_equipment/wormhole_generator,
		/obj/item/mecha_parts/mecha_equipment/gravcatapult,
		/obj/item/mecha_parts/mecha_equipment/armor_booster,
		/obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster,
		/obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster,
		/obj/item/mecha_parts/mecha_equipment/repair_droid,
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_parts/mecha_equipment/generator,
		/obj/item/mecha_parts/mecha_equipment/generator/nuclear,
		/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp,
		/obj/item/mecha_parts/mecha_equipment/tool/passenger,
		/obj/item/mecha_parts/mecha_equipment/thruster,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang))
