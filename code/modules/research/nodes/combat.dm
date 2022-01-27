/datum/technology/basic_combat
	name = "Basic Combat Systems"
	desc = "Basic combat systems and integration of security database HUD in glasses."
	tech_type = RESEARCH_COMBAT

	x = 0.1
	y = 0.5
	icon = "stunbaton"

	re69uired_technologies = list()
	re69uired_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/item/hud/security)

// TO ADD: synth flashes?
/datum/technology/basic_nonlethal
	name = "Basic69on-Lethal"
	desc = "Basic69on-Lethal"
	tech_type = RESEARCH_COMBAT

	x = 0.3
	y = 0.5
	icon = "flash"

	re69uired_technologies = list(/datum/technology/basic_combat)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/item/flash)

/datum/technology/weapon_recharging
	name = "Weapon Recharging"
	desc = "Weapon Recharging"
	tech_type = RESEARCH_COMBAT

	x = 0.5
	y = 0.5
	icon = "recharger"

	re69uired_technologies = list(
								/datum/technology/basic_nonlethal)
	re69uired_tech_levels = list()
	cost = 1000

	unlocks_designs = list(
							/datum/design/research/circuit/recharger
							)

/datum/technology/advanced_nonlethal
	name = "Advanced69on-Lethal"
	desc = "Electrical-shock weapon and ammo."
	tech_type = RESEARCH_COMBAT

	x = 0.5
	y = 0.3
	icon = "stunrevolver"

	re69uired_technologies = list(/datum/technology/weapon_recharging)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(	/datum/design/research/item/weapon/stunrevolver,
						)


/*/datum/technology/sec_computers
	name = "Security Computers"
	desc = "Security Computers"
	tech_type = RESEARCH_COMBAT

	x = 0.2
	y = 0.6
	icon = "seccomputer"

	re69uired_technologies = list(/datum/technology/basic_combat)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/secdata, /datum/design/research/circuit/prisonmanage)*/

/datum/technology/basic_lethal
	name = "Basic Lethal Weapons"
	desc = "Chemical grenade design and experimental energy shells."
	tech_type = RESEARCH_COMBAT

	x = 0.6
	y = 0.5
	icon = "clarissa"

	re69uired_technologies = list(/datum/technology/weapon_recharging)
	re69uired_tech_levels = list()
	cost = 1500

	unlocks_designs = list(
							/datum/design/research/item/weapon/large_grenade,
							/datum/design/research/item/weapon/clarissa
						)

/datum/technology/exotic_weaponry
	name = "Experimental Weaponry"
	desc = "Remote temperature controling weapon."
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.3
	icon = "tempgun"

	re69uired_technologies = list(/datum/technology/basic_lethal)
	re69uired_tech_levels = list()
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/weapon/temp_gun)

/datum/technology/adv_exotic_weaponry
	name = "Advanced Experimental Weaponry"
	desc = "Special weapon system using plasma as catalyst. Special weapon core prototype that deal DNA damage to target."
	tech_type = RESEARCH_COMBAT

	x = 0.8
	y = 0.3
	icon = "teslagun"

	re69uired_technologies = list(/datum/technology/exotic_weaponry)
	re69uired_tech_levels = list()
	cost = 5000

	unlocks_designs = list(	/datum/design/research/item/weapon/decloner,
							/datum/design/research/item/weapon/plasmapistol,
							/datum/design/research/item/weapon/gunmod/penetrator
						)

/datum/technology/exotic_gunmods
	name = "Experimental Gunmods"
	desc = "Experimental gunmods that can grant a wide69ariety of effects. Use at your own risks."
	tech_type = RESEARCH_COMBAT

	x = 0.8
	y = 0.4
	icon = "toxincoater"

	re69uired_technologies = list(/datum/technology/adv_exotic_weaponry)
	re69uired_tech_levels = list()
	cost = 4000

	unlocks_designs = list(
							/datum/design/research/item/weapon/gunmod/battery_shunt,
							/datum/design/research/item/weapon/gunmod/overdrive,
							/datum/design/research/item/weapon/gunmod/toxin_coater,
							/datum/design/research/item/weapon/gunmod/isotope_diffuser,
							/datum/design/research/item/weapon/gunmod/psionic_catalyst
						)

/datum/technology/temp
	name = "Basic Temperature Ammunition"
	desc = "Incendiary ammunition for large cartridges."
	tech_type = RESEARCH_COMBAT

	x = 0.6
	y = 0.6
	icon = "ammobox"

	re69uired_technologies = list(/datum/technology/basic_lethal)
	re69uired_tech_levels = list()
	cost = 5000

	unlocks_designs = list(
							/datum/design/research/item/ammo/shotgun_incendiary,
							/datum/design/research/item/weapon/gunmod/overheat
						)


/datum/technology/adv_lethal
	name = "Advanced Lethal Weapons"
	desc = "Advanced69achinegun system"
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.7
	icon = "submachinegun"

	re69uired_technologies = list(/datum/technology/basic_lethal)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(
							/datum/design/research/item/weapon/c20r,
							/datum/design/research/item/ammo/c20r_ammo,
							/datum/design/research/item/weapon/katana
						)

/datum/technology/laser_weaponry
	name = "Laser Weaponry"
	desc = "Laser Weaponry"
	tech_type = RESEARCH_COMBAT

	x = 0.9
	y = 0.5
	icon = "gun"

	re69uired_technologies = list(/datum/technology/adv_lethal, /datum/technology/adv_exotic_weaponry)
	re69uired_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/weapon/mindflayer,  /datum/design/research/item/weapon/nuclear, /datum/design/research/item/weapon/lasercannon)

/datum/technology/basic_armor
	name = "Armor Solutions"
	desc = "Standard issue armor of69oebius paramedic teams."
	tech_type = RESEARCH_COMBAT

	x = 0.8
	y = 0.5
	icon = "traumateam"

	re69uired_technologies = list(/datum/technology/laser_weaponry)
	re69uired_tech_levels = list()
	cost = 2500
	unlocks_designs = list(/datum/design/research/item/paramedic_armor, /datum/design/research/item/paramedic_helmet)

/datum/technology/advanced_armor
	name = "Advanced Armor Solutions"
	desc = "Advanced69oidsuit with combined ballistic and ablative plating."
	tech_type = RESEARCH_COMBAT

	x = 0.8
	y = 0.6
	icon = "moebiushelm"

	re69uired_technologies = list(/datum/technology/basic_armor)
	re69uired_tech_levels = list()
	cost = 2500
	unlocks_designs = list(/datum/design/research/item/science_voidsuit)

