/datum/technology/binary_encryption_key
	name = "Binary Encrpytion Key"
	desc = "Binary Encrpytion Key"
	tech_type = RESEARCH_ILLEGAL

	x = 0.1
	y = 0.5
	icon = "binarykey"

	required_technologies = list()
	required_tech_levels = list(RESEARCH_BLUESPACE = 5)
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/binaryencrypt)

/datum/technology/chameleon_kit
	name = "Chameleon Kit"
	desc = "Chameleon Kit"
	tech_type = RESEARCH_ILLEGAL

	x = 0.3
	y = 0.5
	icon = "chamelion"

	required_technologies = list(/datum/technology/binary_encryption_key)
	required_tech_levels = list(RESEARCH_ENGINEERING = 10)
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/chameleon_kit)

/datum/technology/freedom_implant
	name = "Glass Case- 'Freedom'"
	desc = "Glass Case- 'Freedom'"
	tech_type = RESEARCH_ILLEGAL

	x = 0.5
	y = 0.5
	icon = "freedom"

	required_technologies = list(/datum/technology/chameleon_kit)
	required_tech_levels = list(RESEARCH_BIOTECH = 5)
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/implant/freedom)

/datum/technology/tyrant_aimodule
	name = "AI Core Module (T.Y.R.A.N.T.)"
	desc = "AI Core Module (T.Y.R.A.N.T.)"
	tech_type = RESEARCH_ILLEGAL

	x = 0.7
	y = 0.5
	icon = "module"

	required_technologies = list(/datum/technology/freedom_implant)
	required_tech_levels = list(RESEARCH_ROBOTICS = 5)
	cost = 3000

	unlocks_designs = list(/datum/design/research/aimodule/core/tyrant)

/datum/technology/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Borg Illegal Weapons Upgrade"
	tech_type = RESEARCH_ILLEGAL

	x = 0.9
	y = 0.5
	icon = "borgmodule"

	required_technologies = list(/datum/technology/tyrant_aimodule)
	required_tech_levels = list(RESEARCH_ROBOTICS = 10)
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/robot_upgrade/syndicate)
