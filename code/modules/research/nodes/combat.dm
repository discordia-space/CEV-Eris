/datum/technology/basic_combat
	name = "Basic Combat Systems"
	desc = "Basic Combat Systems"
	tech_type = RESEARCH_COMBAT

	x = 0.1
	y = 0.5
	icon = "stunbaton"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

// TO ADD: synth flashes?
/datum/technology/basic_nonlethal
	name = "Basic Non-Lethal"
	desc = "Basic Non-Lethal"
	tech_type = RESEARCH_COMBAT

	x = 0.3
	y = 0.5
	icon = "flash"

	required_technologies = list(/datum/technology/basic_combat)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/item/flash)

/datum/technology/advanced_nonlethal
	name = "Advanced Non-Lethal"
	desc = "Advanced Non-Lethal"
	tech_type = RESEARCH_COMBAT

	x = 0.3
	y = 0.3
	icon = "stunrevolver"

	required_technologies = list(/datum/technology/basic_nonlethal)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/item/weapon/stunrevolver, /datum/design/research/item/ammo/shotgun_stun)

/datum/technology/weapon_recharging
	name = "Weapon Recharging"
	desc = "Weapon Recharging"
	tech_type = RESEARCH_COMBAT

	x = 0.5
	y = 0.5
	icon = "recharger"

	required_technologies = list(/datum/technology/advanced_nonlethal)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/sec_computers
	name = "Security Computers"
	desc = "Security Computers"
	tech_type = RESEARCH_COMBAT

	x = 0.1
	y = 0.7
	icon = "seccomputer"

	required_technologies = list(/datum/technology/basic_combat)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/secdata, /datum/design/research/circuit/prisonmanage)

/datum/technology/basic_lethal
	name = "Basic Lethal Weapons"
	desc = "Basic Lethal Weapons"
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.5
	icon = "ammobox"

	required_technologies = list(/datum/technology/weapon_recharging)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/weapon/large_grenade)

/datum/technology/exotic_weaponry
	name = "Exotic Weaponry"
	desc = "Exotic Weaponry"
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.3
	icon = "tempgun"

	required_technologies = list(/datum/technology/basic_lethal)
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/weapon/temp_gun)

/datum/technology/adv_exotic_weaponry
	name = "Advanced Exotic Weaponry"
	desc = "Advanced Exotic Weaponry"
	tech_type = RESEARCH_COMBAT

	x = 0.9
	y = 0.3
	icon = "teslagun"

	required_technologies = list(/datum/technology/exotic_weaponry)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/weapon/decloner, /datum/design/research/item/weapon/plasmapistol)

/datum/technology/adv_lethal
	name = "Advanced Lethal Weapons"
	desc = "Advanced Lethal Weapons"
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.7
	icon = "submachinegun"

	required_technologies = list(/datum/technology/basic_lethal)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list("smg")

/datum/technology/laser_weaponry
	name = "Laser Weaponry"
	desc = "Laser Weaponry"
	tech_type = RESEARCH_COMBAT

	x = 0.9
	y = 0.7
	icon = "gun"

	required_technologies = list(/datum/technology/adv_lethal, /datum/technology/adv_exotic_weaponry)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/weapon/nuclear_gun, /datum/design/research/item/weapon/lasercannon)

