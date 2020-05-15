/obj/random/exosuit
	name = "random exosuit"
	icon_state = "machine-red"
	var/list/randsuits = list(
		/mob/living/exosuit/premade/powerloader = 5,
		/mob/living/exosuit/premade/powerloader = 4,
		/mob/living/exosuit/premade/light = 6,
		/mob/living/exosuit/premade/combat = 1,//comes unarmed
		)

/obj/random/exosuit/item_to_spawn()
	return pickweight(randsuits)

/obj/random/exosuit/low_chance
	name = "low chance random lathe disk"
	icon_state = "machine-red-low"
	spawn_nothing_percentage = 90



/obj/random/exosuit/damaged
	name = "random damaged exosuit"
	icon_state = "machine-red"
	has_postspawn = TRUE

/obj/random/exosuit/damaged/post_spawn(var/list/things)
	for (var/obj/a in things)
		a.make_old()

/obj/random/exosuit/damaged/low_chance
	name = "low chance random damaged exosuit"
	icon_state = "machine-red-low"
	spawn_nothing_percentage = 90





/obj/random/exosuit_equipment
	name = "random exosuit equipment"
	icon_state = "tech-red"

/obj/random/exosuit_equipment/item_to_spawn()
	return pickweight(list(
//		/obj/item/mech_equipment/tool/ai_holder,
		/obj/item/mech_equipment/sleeper,
//		/obj/item/mech_equipment/cable_layer,
//		/obj/item/mech_equipment/syringe_gun,
//		/obj/item/mech_equipment/thruster = 2,
		/obj/item/mech_equipment/clamp,
		/obj/item/mech_equipment/drill,
//		/obj/item/mech_equipment/drill/diamonddrill,
		/obj/item/mech_equipment/mounted_system/extinguisher,
		/obj/item/mech_equipment/mounted_system/rcd,
		/obj/item/mech_equipment/catapult,
//		/obj/item/mech_equipment/wormhole_generator,
//		/obj/item/mech_equipment/gravcatapult,
		/obj/item/robot_parts/robot_component/armour/exosuit,
		/obj/item/robot_parts/robot_component/armour/exosuit/radproof,
		/obj/item/robot_parts/robot_component/armour/exosuit/em,
		/obj/item/robot_parts/robot_component/armour/exosuit/combat,
//		/obj/item/mech_equipment/repair_droid,
//		/obj/item/mech_equipment/tesla_energy_relay,
//		/obj/item/mech_equipment/generator,
//		/obj/item/mech_equipment/generator/nuclear,
//		/obj/item/mech_equipment/tool/safety_clamp,
//		/obj/item/mech_equipment/tool/passenger,
//		/obj/item/mech_equipment/thruster,
		/obj/item/mech_equipment/mounted_system/taser/laser,
		/obj/item/mech_equipment/mounted_system/taser/ion,
//		/obj/item/mech_equipment/weapon/energy/pulse,
		/obj/item/mech_equipment/mounted_system/taser,
//		/obj/item/mech_equipment/weapon/ballistic/scattershot,
//		/obj/item/mech_equipment/weapon/ballistic/lmg,
//		/obj/item/mech_equipment/weapon/ballistic/missile_rack/flare,
//		/obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive,
//		/obj/item/mech_equipment/weapon/ballistic/missile_rack/flashbang
		)
	)

/obj/random/exosuit/mech_equipment/low_chance
	name = "low chance random exosuit equipment"
	icon_state = "tech-red-low"
	spawn_nothing_percentage = 80
