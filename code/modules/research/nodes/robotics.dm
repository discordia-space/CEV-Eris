/datum/technology/basic_robotics
	name = "Basic Robotics"
	desc = "Basic Robotics"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.4
	icon = "cyborganalyzer"

	re69uired_technologies = list()
	re69uired_tech_levels = list()
	cost = 0

	unlocks_designs = list(
			/datum/design/research/circuit/mech_recharger,
			/datum/design/research/circuit/recharge_station,
			/datum/design/research/item/medical/robot_scanner,
			/datum/design/research/item/mmi
		)

//EXOSUIT BRANCH____________________________________________________________________________________________________________________________________________

/datum/technology/cheap_exo_components
	name = "Basic Exosuit Components"
	desc = "Basics of exosuit production. Simple but cost-effective."
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.5
	icon = "ripley"

	re69uired_technologies = list(/datum/technology/basic_robotics)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list(
		/datum/design/research/circuit/mechfab,
		/datum/design/research/item/exosuit/floodlight,
		/datum/design/research/circuit/exosuit/utility,
		/datum/design/research/item/mechfab/exosuit/sensors/cheap,
		/datum/design/research/item/mechfab/exosuit/chassis/cheap,
		/datum/design/research/item/mechfab/exosuit/manipulators/cheap,
		/datum/design/research/item/mechfab/exosuit/propulsion/cheap
		)

/datum/technology/light_exo_components
	name = "Light Exosuit Components"
	desc = "Light exosuit components using reinforced plastics for a lighter, but less durable exosuit. Includes69V sensors."
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.4
	icon = "odyssey"

	re69uired_technologies = list(/datum/technology/cheap_exo_components)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list(
		/datum/design/research/item/mechfab/exosuit/sensors/light,
		/datum/design/research/item/mechfab/exosuit/chassis/light,
		/datum/design/research/item/mechfab/exosuit/manipulators/light,
		/datum/design/research/item/mechfab/exosuit/propulsion/light
	)


/datum/technology/combat_exo_components
	name = "Combat Exosuit Components"
	desc = "Exosuit components designed for combat, with enhanced durability and thermal sensors."
	tech_type = RESEARCH_ROBOTICS

	x = 0.6
	y = 0.6
	icon = "gygax"

	re69uired_technologies = list(/datum/technology/cheap_exo_components)
	re69uired_tech_levels = list()
	cost = 1000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/exosuit/sensors/combat,
		/datum/design/research/item/mechfab/exosuit/chassis/combat,
		/datum/design/research/item/mechfab/exosuit/manipulators/combat,
		/datum/design/research/item/mechfab/exosuit/propulsion/combat
		)

/datum/technology/mech_combat_armor
	name = "Combat Armor"
	desc = "Exosuit combat armor plates."
	tech_type = RESEARCH_ROBOTICS

	x = 0.8
	y = 0.6
	icon = "mecharmor"

	re69uired_technologies = list(/datum/technology/mech_weaponry_modules)
	re69uired_tech_levels = list()
	cost = 3000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/exosuit/armour/combat
	)

/*
/datum/technology/mech_gyrax_ultra
	name = "Gygax Ultra"
	desc = "Gygax Ultra"
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.9
	icon = "gygaxultra"

	re69uired_technologies = list(/datum/technology/mech_gygax)
	re69uired_tech_levels = list()
	cost = 4000

	unlocks_designs = list("ultra_main", "ultra_peri", "ultra_targ")
*/

/datum/technology/heavy_exo_components
	name = "Heavy Exosuit Components"
	desc = "Exosuit components designed for pure durability, heavy and uncompromising. Their functionality leaves a lot to be desired, however."
	tech_type = RESEARCH_ROBOTICS

	x = 0.6
	y = 0.4
	icon = "durand"

	re69uired_technologies = list(/datum/technology/cheap_exo_components)
	re69uired_tech_levels = list()
	cost = 3000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/exosuit/sensors/heavy,
		/datum/design/research/item/mechfab/exosuit/chassis/heavy,
		/datum/design/research/item/mechfab/exosuit/manipulators/heavy,
		/datum/design/research/item/mechfab/exosuit/propulsion/heavy
	)

/datum/technology/mech_propulsion_alt
	name = "Alternative Exosuit Propulsion Systems"
	desc = "Two69ew alternative, specialized designs for exosuit propulsion: 69uad-legs specialized for turning, and tracks specialized for speed and durability at the expense of turning."
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.6
	icon = "spiderlegs"

	re69uired_technologies = list(/datum/technology/cheap_exo_components)
	re69uired_tech_levels = list()
	cost = 3000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/exosuit/propulsion/69uad,
		/datum/design/research/item/mechfab/exosuit/propulsion/tracks
	)

/*
/datum/technology/mech_phazon
	name = "ERROR"
	desc = "ERRORPhazon - the battle scout exosuitERROR"
	tech_type = RESEARCH_ROBOTICS

	x = 0.8
	y = 0.8
	icon = "vindicator" // TODO change icon

	re69uired_technologies = list(/datum/technology/mech_durand)
	re69uired_tech_levels = list() // Add some bluespace re69uirement?
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
*/

//Mech69odules
/datum/technology/mech_medical_modules
	name = "Medical69odules"
	desc = "Exosuit69edical systems"

	tech_type = RESEARCH_ROBOTICS

	x = 0.2
	y = 0.5
	icon = "sleeper"

	re69uired_technologies = list(/datum/technology/cheap_exo_components)

	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list(
		/datum/design/research/circuit/exosuit/medical,
		/datum/design/research/item/exosuit/sleeper
	)

/datum/technology/mech_utility_modules
	name = "Utility69odules"
	desc = "Exosuit's utility systems"
	tech_type = RESEARCH_ROBOTICS

	x = 0.3
	y = 0.6
	icon = "cyborganalyzer"

	re69uired_technologies = list(/datum/technology/cheap_exo_components)

	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
		/datum/design/research/item/exosuit/drill,
		/datum/design/research/item/exosuit/extinguisher,
		/datum/design/research/item/exosuit/hydraulic_clamp,
		/datum/design/research/item/mechfab/exosuit/chassis/pod,
		/datum/design/research/item/exosuit/weapon/plasma
	)

/datum/technology/mech_teleporter_modules
	name = "Gravity Catapult"
	desc = "Exosuit gravity catapult69odule"
	tech_type = RESEARCH_ROBOTICS

	x = 0.2
	y = 0.6
	icon = "mechteleporter"

	re69uired_technologies = list(/datum/technology/mech_utility_modules)
	re69uired_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/exosuit/gravity_catapult)

/datum/technology/mech_util_armor
	name = "Utility Armor"
	desc = "Exosuit combat armor plates reinforced EM protection and radiation protection."
	tech_type = RESEARCH_ROBOTICS

	x = 0.3
	y = 0.7
	icon = "mecharmor"

	re69uired_technologies = list(
		/datum/technology/cheap_exo_components,
		/datum/technology/mech_utility_modules
	)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
			/datum/design/research/item/mechfab/exosuit/armour/radproof,
			/datum/design/research/item/mechfab/exosuit/armour/em
		)

/datum/technology/mech_weaponry_modules
	name = "Combat Systems"
	desc = "Exosuit-mounted weapons."
	tech_type = RESEARCH_ROBOTICS

	x = 0.7
	y = 0.6
	icon = "mechgrenadelauncher"

	re69uired_technologies = list(
		/datum/technology/cheap_exo_components,
		/datum/technology/combat_exo_components
		)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
			/datum/design/research/circuit/exosuit/ballistics,
			/datum/design/research/item/exosuit/taser,
			/datum/design/research/item/exosuit/weapon/ion
		)

/datum/technology/mech_heavy_weaponry_modules
	name = "Advanced Weaponry"
	desc = "Exosuit-mounted heaavy energy weapons."
	tech_type = RESEARCH_ROBOTICS

	x = 0.7
	y = 0.7
	icon = "mechlaser"

	re69uired_technologies = list(/datum/technology/mech_weaponry_modules)
	re69uired_tech_levels = list()
	cost = 5000

	unlocks_designs = list(
			/datum/design/research/item/exosuit/weapon/laser,
			/datum/design/research/item/exosuit/weapon/pk
		)

//AI BRANCH_________________________________________________________________________________________________________________________________________________

/datum/technology/cyborg_robo
	name = "AI Robotics"
	desc = "Positron links.69an-Machine Interface. Cyborg control systems. Artificial Intelegence69obile storages."
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.3
	icon = "posbrain"

	re69uired_technologies = list(/datum/technology/basic_robotics)
	re69uired_tech_levels = list()
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
	y = 0.3
	icon = "aicard"

	re69uired_technologies = list(/datum/technology/cyborg_robo)
	re69uired_tech_levels = list()
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
	y = 0.2
	icon = "module"

	re69uired_technologies = list(/datum/technology/artificial_intelligence)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
							/datum/design/research/circuit/aifixer,
							/datum/design/research/aimodule/safeguard,
							/datum/design/research/aimodule/onehuman,
							/datum/design/research/aimodule/protectstation,
							/datum/design/research/aimodule/notele,
							/datum/design/research/aimodule/69uarantine,
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
	y = 0.3
	icon = "rigscanner"

	re69uired_technologies = list(/datum/technology/cyborg_robo)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
		/datum/design/research/item/mechfab/robot/component/jetpack,
		/datum/design/research/item/robot_upgrade/vtec,
		/datum/design/research/item/robot_upgrade/tasercooler,
		/datum/design/research/item/robot_upgrade/rcd,
		/datum/design/research/circuit/repair_station,
	)

/*
/datum/technology/basic_hardsuit_modules
	name = "Basic Hardsuit69odules"
	desc = "Basic Hardsuit69odules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.35
	y = 0.1
	icon = "rigscanner"

	re69uired_technologies = list()
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list("rigsimpleai", "rigflash", "righealthscanner", "riganomalyscanner", "rigorescanner", "rigextinguisher", "rigmetalfoamspray", "rigcoolingunit")

/datum/technology/advanced_hardsuit_modules
	name = "Advanced Hardsuit69odules"
	desc = "Basic Hardsuit69odules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.1
	icon = "rigtaser"

	re69uired_technologies = list(/datum/technology/basic_hardsuit_modules)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list("rigadvancedai", "riggrenadelauncherflashbang", "rigdrill", "rigselfrepair", "rigmountedtaser", "rigcombatinjector", "rigmedicalinjector")

/datum/technology/toptier_hardsuit_modules
	name = "Top-Tier Hardsuit69odules"
	desc = "Top-Tier Hardsuit69odules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.65
	y = 0.1
	icon = "rignuclearreactor"

	re69uired_technologies = list(/datum/technology/advanced_hardsuit_modules)
	re69uired_tech_levels = list()
	cost = 5000

	unlocks_designs = list("rigmountedlaserrifle", "rigrcd", "rigmedteleport", "rignuclearreactor")
*/


