/datum/technology/basic_robotics
	name = "Basic Robotics"
	desc = "Basic Robotics"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.45
	icon = "cyborganalyzer"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(	/datum/design/research/circuit/mech_recharger,
							/datum/design/research/circuit/recharge_station,
							/datum/design/research/item/medical/robot_scanner,
							/datum/design/research/item/mmi)

//MECHA BRANCH

/datum/technology/exosuit_robotics
	name = "Basic Exosuits"
	desc = "Exosuit production and control systems. Exosuit-miner basics."
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.6
	icon = "ripley"

	required_technologies = list(/datum/technology/basic_robotics)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(
		/datum/design/research/circuit/mechacontrol,
		/datum/design/research/circuit/mechfab,
		/datum/design/research/circuit/dronecontrol,
		/datum/design/research/circuit/mecha/main,
		/datum/design/research/circuit/mecha/peripherals,
		/datum/design/research/circuit/mecha/targeting
		)

/datum/technology/mech_odysseus
	name = "Odysseus"
	desc = "Odysseus - the medical exosuit."
	tech_type = RESEARCH_ROBOTICS

	x = 0.8
	y = 0.5
	icon = "odyssey"

	required_technologies = list(/datum/technology/exosuit_robotics)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(
		/datum/design/research/item/mechfab/odysseus/chassis,
		/datum/design/research/item/mechfab/odysseus/torso,
		/datum/design/research/item/mechfab/odysseus/head,
		/datum/design/research/item/mechfab/odysseus/left_arm,
		/datum/design/research/item/mechfab/odysseus/right_arm,
		/datum/design/research/item/mechfab/odysseus/left_leg,
		/datum/design/research/item/mechfab/odysseus/right_leg
		)


/datum/technology/mech_gygax
	name = "Gygax"
	desc = "Gygax - the killer exosuit."
	tech_type = RESEARCH_ROBOTICS

	x = 0.8
	y = 0.7
	icon = "gygax"

	required_technologies = list(/datum/technology/exosuit_robotics)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/gygax/chassis,
		/datum/design/research/item/mechfab/gygax/torso,
		/datum/design/research/item/mechfab/gygax/head,
		/datum/design/research/item/mechfab/gygax/left_arm,
		/datum/design/research/item/mechfab/gygax/right_arm,
		/datum/design/research/item/mechfab/gygax/left_leg,
		/datum/design/research/item/mechfab/gygax/right_leg,
		/datum/design/research/item/mechfab/gygax/armour
		)
/*
/datum/technology/mech_gyrax_ultra
	name = "Gygax Ultra"
	desc = "Gygax Ultra"
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.9
	icon = "gygaxultra"

	required_technologies = list(/datum/technology/mech_gygax)
	required_tech_levels = list()
	cost = 4000

	unlocks_designs = list("ultra_main", "ultra_peri", "ultra_targ")
*/
/datum/technology/mech_durand
	name = "Durand"
	desc = "Durand - the knight exosuit."
	tech_type = RESEARCH_ROBOTICS

	x = 0.7
	y = 0.8
	icon = "durand"

	required_technologies = list(/datum/technology/exosuit_robotics)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/durand/chassis,
		/datum/design/research/item/mechfab/durand/torso,
		/datum/design/research/item/mechfab/durand/head,
		/datum/design/research/item/mechfab/durand/left_arm,
		/datum/design/research/item/mechfab/durand/right_arm,
		/datum/design/research/item/mechfab/durand/left_leg,
		/datum/design/research/item/mechfab/durand/right_leg,
		/datum/design/research/item/mechfab/durand/armour
	)


/datum/technology/mech_phazon
	name = "Phazon"
	desc = "Phazon - the battle scout exosuit"
	tech_type = RESEARCH_ROBOTICS

	x = 0.8
	y = 0.8
	icon = "vindicator" // TODO change icon

	required_technologies = list(/datum/technology/mech_durand)
	required_tech_levels = list() // Add some bluespace requirement?
	cost = 4000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/phazon/chassis,
		/datum/design/research/item/mechfab/phazon/torso,
		/datum/design/research/item/mechfab/phazon/head,
		/datum/design/research/item/mechfab/phazon/left_arm,
		/datum/design/research/item/mechfab/phazon/right_arm,
		/datum/design/research/item/mechfab/phazon/left_leg,
		/datum/design/research/item/mechfab/phazon/right_leg,
		/datum/design/research/item/mechfab/phazon/armour
		)


//Mech Modules
/datum/technology/mech_modules_core
	name = "Exosuit Modules Technology"
	desc = "Roots of exosuits' modularity."
	tech_type = RESEARCH_ROBOTICS

	x = 0.25
	y = 0.6
	icon = "borgmodule"

	required_technologies = list(/datum/technology/exosuit_robotics)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(
		/datum/design/research/item/mecha/hydraulic_clamp,
		/datum/design/research/item/mecha/drill,
		/datum/design/research/item/mecha/extinguisher,
		/datum/design/research/item/mecha/cable_layer,
		/datum/design/research/item/mecha/flaregun,
		/datum/design/research/item/mecha/passenger
	)

/datum/technology/mech_utility_modules
	name = "Exosuit Utility Modules"
	desc = "Exosuit Utility Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.15
	y = 0.7
	icon = "mechrcd"

	required_technologies = list(/datum/technology/mech_modules_core)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(
							/datum/design/research/item/mecha/jetpack,
							/datum/design/research/item/mecha/ai_holder,
							/datum/design/research/item/mecha/wormhole_gen,
							/datum/design/research/item/mecha/rcd,
							/datum/design/research/item/mecha/gravcatapult,
							/datum/design/research/item/mecha/repair_droid,
							/datum/design/research/item/mecha/plasma_generator,
							/datum/design/research/item/mecha/energy_relay,
							/datum/design/research/item/mecha/sleeper,
							/datum/design/research/item/mecha/syringe_gun,
							/datum/design/research/item/mecha/diamond_drill,
							/datum/design/research/item/mecha/generator_nuclear
							)

/datum/technology/mech_teleporter_modules
	name = "Exosuit Teleporter Module"
	desc = "Exosuit Teleporter Module"
	tech_type = RESEARCH_ROBOTICS

	x = 0.1
	y = 0.8
	icon = "mechteleporter"

	required_technologies = list(/datum/technology/mech_utility_modules)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/mecha/teleporter)

/datum/technology/mech_armor_modules
	name = "Exosuit Armor Modules"
	desc = "Exosuit Armor Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.25
	y = 0.8
	icon = "mecharmor"

	required_technologies = list(/datum/technology/mech_utility_modules)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
		/datum/design/research/item/mecha/ccw_armor,
		/datum/design/research/item/mecha/proj_armor
		)

/datum/technology/mech_weaponry_modules
	name = "Exosuit Weaponry"
	desc = "Exosuit Weaponry"
	tech_type = RESEARCH_ROBOTICS

	x = 0.2
	y = 0.4
	icon = "mechgrenadelauncher"

	required_technologies = list(/datum/technology/mech_modules_core)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
							/datum/design/research/item/mecha/weapon/scattershot,
							/datum/design/research/item/mecha/weapon/laser,
							/datum/design/research/item/mecha/weapon/grenade_launcher
							)

/datum/technology/mech_heavy_weaponry_modules
	name = "Exosuit Heavy Weaponry"
	desc = "Integration of hand lethal weapon in exosuit system."
	tech_type = RESEARCH_ROBOTICS

	x = 0.1
	y = 0.45
	icon = "mechlaser"

	required_technologies = list(/datum/technology/mech_weaponry_modules)
	required_tech_levels = list()
	cost = 4000

	unlocks_designs = list(
							/datum/design/research/item/mecha/weapon/laser_heavy,
							/datum/design/research/item/mecha/weapon/ion
							)

//AI BRANCH

/datum/technology/cyborg_robo
	name = "AI Robotics"
	desc = "Positron links. Man-Machine Interface. Cyborg control systems. Artificial Intelegence mobile storages."
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.3
	icon = "posbrain"

	required_technologies = list(/datum/technology/basic_robotics)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(
							/datum/design/research/item/posibrain,
							/datum/design/research/item/mmi_radio,
							/datum/design/research/item/intellicard,
							/datum/design/research/item/paicard,
							/datum/design/research/circuit/robocontrol
							)

/datum/technology/artificial_intelligence
	name = "Artificial intelligence"
	desc = "Construction and programming of artificial intelligence."
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.2
	icon = "aicard"

	required_technologies = list(/datum/technology/cyborg_robo)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
							/datum/design/research/circuit/aicore,
							/datum/design/research/circuit/aiupload
							)

/datum/technology/artificial_intelligence_laws
	name = "Artificial intelligence: LAWS"
	desc = "Artificial intelligence laws sets."
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.1
	icon = "module"

	required_technologies = list(/datum/technology/artificial_intelligence)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
							/datum/design/research/circuit/aifixer,
							/datum/design/research/aimodule/safeguard,
							/datum/design/research/aimodule/onehuman,
							/datum/design/research/aimodule/protectstation,
							/datum/design/research/aimodule/notele,
							/datum/design/research/aimodule/quarantine,
							/datum/design/research/aimodule/oxygen,
							/datum/design/research/aimodule/freeform,
							/datum/design/research/aimodule/reset,
							/datum/design/research/aimodule/purge,
							/datum/design/research/aimodule/core/freeformcore,
							/datum/design/research/aimodule/core/asimov,
							/datum/design/research/aimodule/core/paladin,
							/datum/design/research/circuit/aicore,
							/datum/design/research/circuit/aiupload,
							/datum/design/research/circuit/borgupload
							)

/datum/technology/robot_modules
	name = "Advanced Cyborg Components"
	desc = "Advanced Cyborg Components"
	tech_type = RESEARCH_ROBOTICS

	x = 0.6
	y = 0.2
	icon = "rigscanner"

	required_technologies = list(/datum/technology/cyborg_robo)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
						/datum/design/research/item/mechfab/robot/component/jetpack,
						/datum/design/research/item/robot_upgrade/vtec,
						/datum/design/research/item/robot_upgrade/tasercooler,
						/datum/design/research/item/robot_upgrade/rcd
						)


/*
/datum/technology/basic_hardsuit_modules
	name = "Basic Hardsuit Modules"
	desc = "Basic Hardsuit Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.35
	y = 0.1
	icon = "rigscanner"

	required_technologies = list()
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list("rigsimpleai", "rigflash", "righealthscanner", "riganomalyscanner", "rigorescanner", "rigextinguisher", "rigmetalfoamspray", "rigcoolingunit")

/datum/technology/advanced_hardsuit_modules
	name = "Advanced Hardsuit Modules"
	desc = "Basic Hardsuit Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.1
	icon = "rigtaser"

	required_technologies = list(/datum/technology/basic_hardsuit_modules)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list("rigadvancedai", "riggrenadelauncherflashbang", "rigdrill", "rigselfrepair", "rigmountedtaser", "rigcombatinjector", "rigmedicalinjector")

/datum/technology/toptier_hardsuit_modules
	name = "Top-Tier Hardsuit Modules"
	desc = "Top-Tier Hardsuit Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.65
	y = 0.1
	icon = "rignuclearreactor"

	required_technologies = list(/datum/technology/advanced_hardsuit_modules)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list("rigmountedlaserrifle", "rigrcd", "rigmedteleport", "rignuclearreactor")
*/


