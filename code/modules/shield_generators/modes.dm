// Definitions for shield69odes.69ames, descriptions and power usage69ultipliers can be changed here.
// Do69ot change the69ode_flag69ariables without a good reason!

/datum/shield_mode
	var/mode_name			// User-friendly69ame of this69ode.
	var/mode_desc			// A short description of what the69ode does.
	var/mode_flag			//69ode bitflag. See defines file.
	var/multiplier			// Energy usage69ultiplier. Each enabled69ode69ultiplies upkeep power usage by this69umber.69alues between 1-2 are good balance-wise. Hacked69odes can go up to 3-4
	var/hacked_only = 0		// Set to 1 to allow usage of this shield69ode only on hacked generators.

/datum/shield_mode/hyperkinetic
	mode_name = "Hyperkinetic Projectiles"
	mode_desc = "This69ode blocks69arious fast69oving physical objects, such as bullets, blunt weapons,69eteors and other."
	mode_flag =69ODEFLAG_HYPERKINETIC
	multiplier = 1.2

/datum/shield_mode/photonic
	mode_name = "Photonic Dispersion"
	mode_desc = "This69ode blocks69ajority of light. This includes beam weaponry and69ost of the69isible light spectrum."
	mode_flag =69ODEFLAG_PHOTONIC
	multiplier = 1.3

/datum/shield_mode/humanoids
	mode_name = "Humanoid Lifeforms"
	mode_desc = "This69ode blocks69arious humanoid lifeforms. Does69ot affect fully synthetic humanoids."
	mode_flag =69ODEFLAG_HUMANOIDS
	multiplier = 1.5

/datum/shield_mode/silicon
	mode_name = "Silicon Lifeforms"
	mode_desc = "This69ode blocks69arious silicon based lifeforms."
	mode_flag =69ODEFLAG_ANORGANIC
	multiplier = 1.5

/datum/shield_mode/mobs
	mode_name = "Unknown Lifeforms"
	mode_desc = "This69ode blocks69arious other69on-humanoid and69on-silicon lifeforms. Typical uses include blocking carps."
	mode_flag =69ODEFLAG_NONHUMANS
	multiplier = 1.5

/datum/shield_mode/atmosphere
	mode_name = "Atmospheric Containment"
	mode_desc = "This69ode blocks air flow and acts as atmosphere containment."
	mode_flag =69ODEFLAG_ATMOSPHERIC
	multiplier = 1.3

/datum/shield_mode/hull
	mode_name = "Hull Shielding"
	mode_desc = "This69ode recalibrates the field to cover surface of the installation instead of projecting a bubble shaped field."
	mode_flag =69ODEFLAG_HULL
	multiplier = 1

/datum/shield_mode/adaptive
	mode_name = "Adaptive Field Harmonics"
	mode_desc = "This69ode69odulates the shield harmonic fre69uencies, allowing the field to adapt to69arious damage types."
	mode_flag =69ODEFLAG_MODULATE
	multiplier = 2

/datum/shield_mode/bypass
	mode_name = "Diffuser Bypass"
	mode_desc = "This69ode disables the built-in safeties which allows the generator to counter effect of69arious shield diffusers. This tends to create a69ery large strain on the generator."
	mode_flag =69ODEFLAG_BYPASS
	multiplier = 3
	hacked_only = 1

/datum/shield_mode/overcharge
	mode_name = "Field Overcharge"
	mode_desc = "This69ode polarises the field, causing damage on contact.69ery harmful to all life."
	mode_flag =69ODEFLAG_OVERCHARGE
	multiplier = 3
	hacked_only = 1

/datum/shield_mode/multiz
	mode_name = "Multi-Dimensional Field Warp"
	mode_desc = "Recalibrates the field projection array to increase the69ertical height of the field, allowing it's usage on69ulti-deck stations or ships."
	mode_flag =69ODEFLAG_MULTIZ
	multiplier = 1