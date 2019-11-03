/datum/design/research/item/mecha_tracking
	name = "Exosuit tracking beacon"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_tracking
	category = CAT_MECHA
	starts_unlocked = TRUE

/datum/design/research/item/mecha
	build_type = MECHFAB
	category = CAT_MECHA

/datum/design/research/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

/datum/design/research/item/mecha/hydraulic_clamp
	name = "Hydraulic clamp"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp

/datum/design/research/item/mecha/drill
	name = "Drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill
	starts_unlocked = TRUE

/datum/design/research/item/mecha/extinguisher
	name = "Extinguisher"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/extinguisher
	starts_unlocked = TRUE

/datum/design/research/item/mecha/cable_layer
	name = "Cable layer"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/cable_layer
	starts_unlocked = TRUE

/datum/design/research/item/mecha/flaregun
	name = "Flare launcher"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	starts_unlocked = TRUE

/datum/design/research/item/mecha/sleeper
	name = "Sleeper"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	starts_unlocked = TRUE

/datum/design/research/item/mecha/syringe_gun
	name = "Syringe gun"
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun


/datum/design/research/item/mecha/passenger
	name = "Passenger compartment"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/passenger
	starts_unlocked = TRUE

/datum/design/research/item/mecha/jetpack
	name = "jetpack module"
	build_path = /obj/item/mecha_parts/mecha_equipment/thruster

/datum/design/research/item/mecha/ai_holder
	name = "AI holder"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/ai_holder

//obj/item/mecha_parts/mecha_equipment/repair_droid,

/datum/design/research/item/mecha/taser
	name = "PBT \"Pacifier\" mounted taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	starts_unlocked = TRUE

/datum/design/research/item/mecha/lmg
	name = "Ultra AC 2"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	starts_unlocked = TRUE

/datum/design/research/item/mecha/weapon

// *** Weapon modules
/datum/design/research/item/mecha/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot

/datum/design/research/item/mecha/weapon/laser
	name = "CH-PS \"Immolator\" laser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser

/datum/design/research/item/mecha/weapon/laser_rigged
	name = "Jury-rigged welder-laser"
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
	starts_unlocked = TRUE

/datum/design/research/item/mecha/weapon/laser_heavy
	name = "CH-LC \"Solaris\" laser cannon"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy

/datum/design/research/item/mecha/weapon/ion
	name = "mkIV ion heavy cannon"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion

/datum/design/research/item/mecha/weapon/grenade_launcher
	name = "SGL-6 grenade launcher"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang

// *** Nonweapon modules
/datum/design/research/item/mecha/wormhole_gen
	name = "Wormhole generator"
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/research/item/mecha/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

/datum/design/research/item/mecha/rcd
	name = "RCD"
	desc = "An exosuit-mounted rapid construction device."
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd

/datum/design/research/item/mecha/gravcatapult
	name = "Gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/research/item/mecha/repair_droid
	name = "Repair droid"
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/research/item/mecha/plasma_generator
	desc = "Plasma reactor"
	build_path = /obj/item/mecha_parts/mecha_equipment/generator

/datum/design/research/item/mecha/energy_relay
	name = "Energy relay"
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/research/item/mecha/ccw_armor
	name = "CCW armor booster"
	desc = "Exosuit close-combat armor booster."
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster

/datum/design/research/item/mecha/proj_armor
	desc = "Exosuit projectile armor booster."
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster

/datum/design/research/item/mecha/diamond_drill
	name = "Diamond drill"
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/research/item/mecha/generator_nuclear
	name = "Nuclear reactor"
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear
