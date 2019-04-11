/datum/design/research/item/mechfab
	build_type = MECHFAB
	category = "Misc"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/research/item/mechfab/robot
	category = "Robot"

/datum/design/research/item/mechfab/robot/exoskeleton
	name = "Robot exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50

/datum/design/research/item/mechfab/robot/torso
	name = "Robot torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	time = 35

/datum/design/research/item/mechfab/robot/head
	name = "Robot head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	time = 35

/datum/design/research/item/mechfab/robot/l_arm
	name = "Robot left arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20

/datum/design/research/item/mechfab/robot/r_arm
	name = "Robot right arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20

/datum/design/research/item/mechfab/robot/l_leg
	name = "Robot left leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20

/datum/design/research/item/mechfab/robot/r_leg
	name = "Robot right leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20

/datum/design/research/item/mechfab/robot/component
	time = 20

/datum/design/research/item/mechfab/robot/component/binary_communication_device
	name = "Binary communication device"
	id = "binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/research/item/mechfab/robot/component/radio
	name = "Radio"
	id = "radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/research/item/mechfab/robot/component/actuator
	name = "Actuator"
	id = "actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/research/item/mechfab/robot/component/diagnosis_unit
	name = "Diagnosis unit"
	id = "diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/research/item/mechfab/robot/component/camera
	name = "Camera"
	id = "camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/research/item/mechfab/robot/component/armour
	name = "Armour plating"
	id = "armour"
	build_path = /obj/item/robot_parts/robot_component/armour


/datum/design/research/item/mechfab/robot/component/jetpack
	name = "Jetpack module"
	desc = "Self refilling jetpack that makes the unit suitable for EVA work."
	id = "borg_jetpack_module"
	build_path = /obj/item/robot_parts/robot_component/jetpack

//Modules ====================================

/datum/design/research/item/mechfab/modules
	category = "Prosthesis"
	req_tech = list(TECH_BIO = 3)

/datum/design/research/item/mechfab/modules/armor
	name = "subdermal body armor"
	build_path = /obj/item/organ_module/armor
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3)

/datum/design/research/item/mechfab/modules/armblade
	name = "Embedded armblade"
	build_path = /obj/item/organ_module/active/simple/armblade
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3)

/datum/design/research/item/mechfab/modules/runner
	name = "Mechanical muscles"
	build_path = /obj/item/organ_module/muscle
	req_tech = list(TECH_BIO = 4)


/datum/design/research/item/mechfab/modules/multitool/surgical
	build_path = /obj/item/organ_module/active/multitool/surgical
	name = "Embedded surgical multitool"
	req_tech = list(TECH_BIO = 4)

/datum/design/research/item/mechfab/modules/multitool/engineer
	build_path = /obj/item/organ_module/active/multitool/engineer
	name = "Embedded Technomancer multitool"
	req_tech = list(TECH_BIO = 3, TECH_ENGINEERING = 3)

/datum/design/research/item/mechfab/modules/multitool/miner
	build_path = /obj/item/organ_module/active/multitool/miner
	name = "Embedded mining multitool"
	req_tech = list(TECH_BIO = 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 4)

//Prosthesis ====================================

/datum/design/research/item/mechfab/prosthesis
	category = "Prosthesis"

/datum/design/research/item/mechfab/prosthesis/r_arm
	name = "right arm"
	id = "prosthesis_simple_r_arm"
	build_path = /obj/item/prosthesis/r_arm

/datum/design/research/item/mechfab/prosthesis/l_arm
	name = "left arm"
	id = "prosthesis_simple_l_arm"
	build_path = /obj/item/prosthesis/l_arm

/datum/design/research/item/mechfab/prosthesis/r_leg
	name = "right leg"
	id = "prosthesis_simple_r_leg"
	build_path = /obj/item/prosthesis/r_leg

/datum/design/research/item/mechfab/prosthesis/l_leg
	name = "left leg"
	id = "prosthesis_simple_l_leg"
	build_path = /obj/item/prosthesis/l_leg


//Ripley ====================================

/datum/design/research/item/mechfab/ripley
	category = "Ripley"

/datum/design/research/item/mechfab/ripley/chassis
	name = "Ripley chassis"
	id = "ripley_chassis"
	build_path = /obj/item/mecha_parts/chassis/ripley
	time = 10

/datum/design/research/item/mechfab/ripley/chassis/firefighter
	name = "Firefigher chassis"
	id = "firefighter_chassis"
	build_path = /obj/item/mecha_parts/chassis/ripley/firefighter

/datum/design/research/item/mechfab/ripley/torso
	name = "Ripley torso"
	id = "ripley_torso"
	build_path = /obj/item/mecha_parts/part/ripley_torso
	time = 20

/datum/design/research/item/mechfab/ripley/left_arm
	name = "Ripley left arm"
	id = "ripley_left_arm"
	build_path = /obj/item/mecha_parts/part/ripley_left_arm
	time = 15

/datum/design/research/item/mechfab/ripley/right_arm
	name = "Ripley right arm"
	id = "ripley_right_arm"
	build_path = /obj/item/mecha_parts/part/ripley_right_arm
	time = 15

/datum/design/research/item/mechfab/ripley/left_leg
	name = "Ripley left leg"
	id = "ripley_left_leg"
	build_path = /obj/item/mecha_parts/part/ripley_left_leg
	time = 15

/datum/design/research/item/mechfab/ripley/right_leg
	name = "Ripley right leg"
	id = "ripley_right_leg"
	build_path = /obj/item/mecha_parts/part/ripley_right_leg
	time = 15


//Odysseus =====================================================

/datum/design/research/item/mechfab/odysseus
	category = "Odysseus"

/datum/design/research/item/mechfab/odysseus/chassis
	name = "Odysseus chassis"
	id = "odysseus_chassis"
	build_path = /obj/item/mecha_parts/chassis/odysseus
	time = 10

/datum/design/research/item/mechfab/odysseus/torso
	name = "Odysseus torso"
	id = "odysseus_torso"
	build_path = /obj/item/mecha_parts/part/odysseus_torso
	time = 18

/datum/design/research/item/mechfab/odysseus/head
	name = "Odysseus head"
	id = "odysseus_head"
	build_path = /obj/item/mecha_parts/part/odysseus_head
	time = 10

/datum/design/research/item/mechfab/odysseus/left_arm
	name = "Odysseus left arm"
	id = "odysseus_left_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm
	time = 12

/datum/design/research/item/mechfab/odysseus/right_arm
	name = "Odysseus right arm"
	id = "odysseus_right_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm
	time = 12

/datum/design/research/item/mechfab/odysseus/left_leg
	name = "Odysseus left leg"
	id = "odysseus_left_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg
	time = 13

/datum/design/research/item/mechfab/odysseus/right_leg
	name = "Odysseus right leg"
	id = "odysseus_right_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg
	time = 13

//Gygax =========================================

/datum/design/research/item/mechfab/gygax
	category = "Gygax"

/datum/design/research/item/mechfab/gygax/chassis
	name = "Gygax chassis"
	id = "gygax_chassis"
	build_path = /obj/item/mecha_parts/chassis/gygax
	time = 10

/datum/design/research/item/mechfab/gygax/torso
	name = "Gygax torso"
	id = "gygax_torso"
	build_path = /obj/item/mecha_parts/part/gygax_torso
	time = 30

/datum/design/research/item/mechfab/gygax/head
	name = "Gygax head"
	id = "gygax_head"
	build_path = /obj/item/mecha_parts/part/gygax_head
	time = 20

/datum/design/research/item/mechfab/gygax/left_arm
	name = "Gygax left arm"
	id = "gygax_left_arm"
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	time = 20

/datum/design/research/item/mechfab/gygax/right_arm
	name = "Gygax right arm"
	id = "gygax_right_arm"
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	time = 20

/datum/design/research/item/mechfab/gygax/left_leg
	name = "Gygax left leg"
	id = "gygax_left_leg"
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	time = 20

/datum/design/research/item/mechfab/gygax/right_leg
	name = "Gygax right leg"
	id = "gygax_right_leg"
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	time = 20

/datum/design/research/item/mechfab/gygax/armour
	name = "Gygax armour plates"
	id = "gygax_armour"
	build_path = /obj/item/mecha_parts/part/gygax_armour
	time = 60

//Phazon ======================================================================

/datum/design/research/item/mechfab/phazon
	category = "Phazon"

/datum/design/research/item/mechfab/phazon/chassis
	name = "Phazon chassis"
	id = "phazon_chassis"
	build_path = /obj/item/mecha_parts/chassis/phazon
	time = 60

/datum/design/research/item/mechfab/phazon/torso
	name = "Phazon torso"
	id = "phazon_torso"
	build_path = /obj/item/mecha_parts/part/phazon_torso
	time = 120

/datum/design/research/item/mechfab/phazon/head
	name = "Phazon head"
	id = "phazon_head"
	build_path = /obj/item/mecha_parts/part/phazon_head
	time = 10

/datum/design/research/item/mechfab/phazon/left_arm
	name = "Phazon left arm"
	id = "phazon_left_arm"
	build_path = /obj/item/mecha_parts/part/phazon_left_arm
	time = 10

/datum/design/research/item/mechfab/phazon/right_arm
	name = "Phazon right arm"
	id = "phazon_right_arm"
	build_path = /obj/item/mecha_parts/part/phazon_right_arm
	time = 10

/datum/design/research/item/mechfab/phazon/left_leg
	name = "Phazon left leg"
	id = "phazon_left_leg"
	build_path = /obj/item/mecha_parts/part/phazon_left_leg
	time = 10

/datum/design/research/item/mechfab/phazon/right_leg
	name = "Phazon right leg"
	id = "phazon_right_leg"
	build_path = /obj/item/mecha_parts/part/phazon_right_leg
	time = 10

/datum/design/research/item/mechfab/phazon/armour
	name = "Phazon armour plates"
	id = "phazon_armour"
	build_path = /obj/item/mecha_parts/part/phazon_armor
	time = 120

//Durand ======================================================================

/datum/design/research/item/mechfab/durand
	category = "Durand"

/datum/design/research/item/mechfab/durand/chassis
	name = "Durand chassis"
	id = "durand_chassis"
	build_path = /obj/item/mecha_parts/chassis/durand
	time = 10

/datum/design/research/item/mechfab/durand/torso
	name = "Durand torso"
	id = "durand_torso"
	build_path = /obj/item/mecha_parts/part/durand_torso
	time = 30

/datum/design/research/item/mechfab/durand/head
	name = "Durand head"
	id = "durand_head"
	build_path = /obj/item/mecha_parts/part/durand_head
	time = 20

/datum/design/research/item/mechfab/durand/left_arm
	name = "Durand left arm"
	id = "durand_left_arm"
	build_path = /obj/item/mecha_parts/part/durand_left_arm
	time = 20

/datum/design/research/item/mechfab/durand/right_arm
	name = "Durand right arm"
	id = "durand_right_arm"
	build_path = /obj/item/mecha_parts/part/durand_right_arm
	time = 20

/datum/design/research/item/mechfab/durand/left_leg
	name = "Durand left leg"
	id = "durand_left_leg"
	build_path = /obj/item/mecha_parts/part/durand_left_leg
	time = 20

/datum/design/research/item/mechfab/durand/right_leg
	name = "Durand right leg"
	id = "durand_right_leg"
	build_path = /obj/item/mecha_parts/part/durand_right_leg
	time = 20

/datum/design/research/item/mechfab/durand/armour
	name = "Durand armour plates"
	id = "durand_armour"
	build_path = /obj/item/mecha_parts/part/durand_armour
	time = 60



/datum/design/research/item/robot_upgrade
	build_type = MECHFAB
	time = 12
	category = "Cyborg Upgrade Modules"

/datum/design/research/item/robot_upgrade/rename
	name = "Rename module"
	desc = "Used to rename a cyborg."
	id = "borg_rename_module"
	build_path = /obj/item/borg/upgrade/rename

/datum/design/research/item/robot_upgrade/reset
	name = "Reset module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	id = "borg_reset_module"
	build_path = /obj/item/borg/upgrade/reset

/datum/design/research/item/robot_upgrade/floodlight
	name = "Floodlight module"
	desc = "Used to boost cyborg's integrated light intensity."
	id = "borg_floodlight_module"
	build_path = /obj/item/borg/upgrade/floodlight

/datum/design/research/item/robot_upgrade/restart
	name = "Emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	id = "borg_restart_module"
	build_path = /obj/item/borg/upgrade/restart

/datum/design/research/item/robot_upgrade/vtec
	name = "VTEC module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	id = "borg_vtec_module"
	build_path = /obj/item/borg/upgrade/vtec

/datum/design/research/item/robot_upgrade/tasercooler
	name = "Rapid taser cooling module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	id = "borg_taser_module"
	build_path = /obj/item/borg/upgrade/tasercooler

/datum/design/research/item/robot_upgrade/rcd
	name = "RCD module"
	desc = "A rapid construction device module for use during construction operations."
	id = "borg_rcd_module"
	build_path = /obj/item/borg/upgrade/rcd

/datum/design/research/item/robot_upgrade/syndicate
	name = "Illegal upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	build_path = /obj/item/borg/upgrade/syndicate


/datum/design/research/item/mecha_tracking
	name = "Exosuit tracking beacon"
	build_type = MECHFAB
	time = 5
	build_path = /obj/item/mecha_parts/mecha_tracking
	category = "Misc"

/datum/design/research/item/mecha
	build_type = MECHFAB
	category = "Exosuit Equipment"
	time = 10

/datum/design/research/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

/datum/design/research/item/mecha/hydraulic_clamp
	name = "Hydraulic clamp"
	id = "hydraulic_clamp"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp

/datum/design/research/item/mecha/drill
	name = "Drill"
	id = "mech_drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill

/datum/design/research/item/mecha/extinguisher
	name = "Extinguisher"
	id = "extinguisher"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/extinguisher

/datum/design/research/item/mecha/cable_layer
	name = "Cable layer"
	id = "mech_cable_layer"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/cable_layer

/datum/design/research/item/mecha/flaregun
	name = "Flare launcher"
	id = "mecha_flare_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare

/datum/design/research/item/mecha/sleeper
	name = "Sleeper"
	id = "mech_sleeper"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/sleeper

/datum/design/research/item/mecha/syringe_gun
	name = "Syringe gun"
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	id = "mech_syringe_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	time = 20


/datum/design/research/item/mecha/passenger
	name = "Passenger compartment"
	id = "mech_passenger"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/passenger

/datum/design/research/item/mecha/jetpack
	name = "jetpack module"
	id = "mech_jetpack"
	build_path = /obj/item/mecha_parts/mecha_equipment/thruster

/datum/design/research/item/mecha/ai_holder
	name = "AI holder"
	id = "mech_aiholder"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/ai_holder

//obj/item/mecha_parts/mecha_equipment/repair_droid,

/datum/design/research/item/mecha/taser
	name = "PBT \"Pacifier\" mounted taser"
	id = "mech_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser

/datum/design/research/item/mecha/lmg
	name = "Ultra AC 2"
	id = "mech_lmg"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg

/datum/design/research/item/mecha/weapon
	req_tech = list(TECH_COMBAT = 3)

// *** Weapon modules
/datum/design/research/item/mecha/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	id = "mech_scattershot"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot

/datum/design/research/item/mecha/weapon/laser
	name = "CH-PS \"Immolator\" laser"
	id = "mech_laser"
	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser

/datum/design/research/item/mecha/weapon/laser_rigged
	name = "Jury-rigged welder-laser"
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/design/research/item/mecha/weapon/laser_heavy
	name = "CH-LC \"Solaris\" laser cannon"
	id = "mech_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy

/datum/design/research/item/mecha/weapon/ion
	name = "mkIV ion heavy cannon"
	id = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion

/datum/design/research/item/mecha/weapon/grenade_launcher
	name = "SGL-6 grenade launcher"
	id = "mech_grenade_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang

// *** Nonweapon modules
/datum/design/research/item/mecha/wormhole_gen
	name = "Wormhole generator"
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/research/item/mecha/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

/datum/design/research/item/mecha/rcd
	name = "RCD"
	desc = "An exosuit-mounted rapid construction device."
	id = "mech_rcd"
	time = 120
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd

/datum/design/research/item/mecha/gravcatapult
	name = "Gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/research/item/mecha/repair_droid
	name = "Repair droid"
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/research/item/mecha/plasma_generator
	desc = "Plasma reactor"
	id = "mech_plasma_generator"
	req_tech = list(TECH_PLASMA = 2, TECH_POWER= 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator

/datum/design/research/item/mecha/energy_relay
	name = "Energy relay"
	id = "mech_energy_relay"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/research/item/mecha/ccw_armor
	name = "CCW armor booster"
	desc = "Exosuit close-combat armor booster."
	id = "mech_ccw_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster

/datum/design/research/item/mecha/proj_armor
	desc = "Exosuit projectile armor booster."
	id = "mech_proj_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster

/datum/design/research/item/mecha/diamond_drill
	name = "Diamond drill"
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/research/item/mecha/generator_nuclear
	name = "Nuclear reactor"
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	id = "mech_generator_nuclear"
	req_tech = list(TECH_POWER= 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear

/datum/design/research/item/flash
	name = "flash"
	id = "flash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	build_path = /obj/item/device/flash
	category = "Misc"
