/mob/observer/cyber_entity/IceHolder/cyberassassin
	name = "Assassin"
	icon_state = "cyberassassin"

	distance_to_apc = 3
	Might = 30
	maxHP = 100

	init_subroutines = list(
		/datum/subroutine/attack{TimeLocksFor = 3 SECONDS},
		)

	CollectStates()
		. = ..()
		states = list(
			ICE_STANCE_OVERWATCH = STATE_ICON_COLOR("cyberassassin", CYBERSPACE_MAIN_COLOR),
			ICE_STANCE_ATTACK = STATE_ICON_COLOR("cyberassassin_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_ATTACKING = STATE_ICON_COLOR("cyberassassin_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_DEAD = STATE_ICON_COLOR("cyberassassin", CYBERSPACE_SHADOW_COLOR),
		)
		. = ..()

/mob/observer/cyber_entity/IceHolder/spooklet
	name = "Elder Warrior"
	icon_state = "skeleton"

	distance_to_apc = 3
	Might = 40
	maxHP = 300

	init_subroutines = list(
		/datum/subroutine/attack{TimeLocksFor = 5 SECONDS},
		)

	CollectStates()
		states = list(
			ICE_STANCE_OVERWATCH = STATE_ICON_COLOR("skeleton", CYBERSPACE_MAIN_COLOR),
			ICE_STANCE_ATTACK = STATE_ICON_COLOR("skeleton_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_ATTACKING = STATE_ICON_COLOR("skeleton_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_DEAD = STATE_ICON_COLOR("skeleton_hostile", CYBERSPACE_SHADOW_COLOR),
		)
		. = ..()

/mob/observer/cyber_entity/IceHolder/spearman
	name = "Spearman"
	icon_state = "assyrian"
	distance_to_apc = 3

	Might = 10
	maxHP = 150

	init_subroutines = list(
		/datum/subroutine/attack{TimeLocksFor = 1 SECONDS},
		)

	CollectStates()
		states = list(
			ICE_STANCE_OVERWATCH = STATE_ICON_COLOR("assyrian", CYBERSPACE_MAIN_COLOR),
			ICE_STANCE_ATTACK = STATE_ICON_COLOR("assyrian_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_ATTACKING = STATE_ICON_COLOR("assyrian_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_DEAD = STATE_ICON_COLOR("assyrian", CYBERSPACE_SHADOW_COLOR),
		)
		. = ..()

/mob/observer/cyber_entity/IceHolder/black_ice
	name = "???"
	icon_state = "faceless_hostile"

	distance_to_apc = 2
	Might = 10
	maxHP = 200

	init_subroutines = list(
		/datum/subroutine/attack{TimeLocksFor = 3 SECONDS},
		/datum/subroutine/damageBrain{ForcedDamageValue = 20}
		)

	CollectStates()
		states = list(
			ICE_STANCE_OVERWATCH = STATE_ICON_COLOR("faceless", "#886666"),
			ICE_STANCE_ATTACK = STATE_ICON_COLOR("faceless_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_ATTACKING = STATE_ICON_COLOR("faceless_hostile", CYBERSPACE_SECURITY),
			ICE_STANCE_DEAD = STATE_ICON_COLOR("faceless", CYBERSPACE_SHADOW_COLOR),
		)
		. = ..()

