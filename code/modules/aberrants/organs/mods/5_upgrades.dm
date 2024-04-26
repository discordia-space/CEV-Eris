/obj/item/modification/organ/internal/stromal
	name = "stromal organoid"
	icon = 'icons/obj/organ_mods.dmi'
	bad_type = /obj/item/modification/organ/internal/stromal
	use_generated_icon = FALSE
	organ_size = 0

// Printable mods

/obj/item/modification/organ/internal/stromal/requirements
	name = "improved capillaries"
	desc = "A set of modified capillaries that improve substance transfer within an organ."
	icon_state = "capillary"

/obj/item/modification/organ/internal/stromal/requirements/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.modifications = list(
		ORGAN_BLOOD_REQ_MULT = -0.50,
		ORGAN_NUTRIMENT_REQ_MULT = -0.50,
		ORGAN_OXYGEN_REQ_MULT = -0.50,
		ATOM_PREFIX = "efficient"
	)
	..()

/obj/item/modification/organ/internal/stromal/durability
	name = "durable membrane"
	desc = "A stronger membrane that allows an organ to sustain greater injury before its functions are diminished."
	icon_state = "thick_membrane"

/obj/item/modification/organ/internal/stromal/durability/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.modifications = list(
		ORGAN_SPECIFIC_SIZE_MULT = 0.20,
		ORGAN_MIN_BRUISED_DAMAGE_MULT = 0.20,
		ORGAN_MIN_BROKEN_DAMAGE_MULT = 0.20,
		ORGAN_MAX_DAMAGE_MULT = 0.20,
		ATOM_PREFIX = "durable"
	)
	..()

/obj/item/modification/organ/internal/stromal/efficiency
	name = "stem cell application"
	desc = "A clump of stem cells that permanently increases the functional efficiency of an organ."
	icon_state = "stem_cells"

/obj/item/modification/organ/internal/stromal/efficiency/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.removable = FALSE		// Stem cells don't go back to being undifferentiated

	M.modifications = list(
		ORGAN_EFFICIENCY_MULT = 0.10,
		ATOM_PREFIX = "enhanced"
	)
	..()

/obj/item/modification/organ/internal/stromal/overclock
	name = "visceral symbiont"
	desc = "A leech-like creature that attaches itself to the viscera of an orgnanism. It mimics the function of the parent organ in exchange for blood, oxygen, and nutrients."
	icon_state = "symbiont"

/obj/item/modification/organ/internal/stromal/overclock/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.modifications = list(
		ORGAN_EFFICIENCY_MULT = 0.20,
		ORGAN_BLOOD_REQ_MULT = 0.20,
		ORGAN_NUTRIMENT_REQ_MULT = 0.20,
		ORGAN_OXYGEN_REQ_MULT = 0.20,
		ORGAN_SPECIFIC_SIZE_MULT = 0.20,
		ATOM_PREFIX = "symbiotic"
	)
	..()

/obj/item/modification/organ/internal/stromal/underclock
	name = "bypass tubules"
	desc = "A series of tubules that siphon blood away from an organ, reducing its effectiveness, to be used elsewhere in the body."
	icon_state = "tubules"

/obj/item/modification/organ/internal/stromal/underclock/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.modifications = list(
		ORGAN_EFFICIENCY_MULT = -0.20,
		ORGAN_BLOOD_REQ_MULT = -0.20,
		ORGAN_NUTRIMENT_REQ_MULT = -0.20,
		ORGAN_OXYGEN_REQ_MULT = -0.20,
		ORGAN_SPECIFIC_SIZE_MULT = -0.20,
		ATOM_PREFIX = "bypassed"
	)
	..()

/obj/item/modification/organ/internal/stromal/expander
	name = "biostructure gel"
	desc = "A gel that will permanently solidify as structural tissue of the organ it is applied to."
	icon_state = "advanced_collagen"

/obj/item/modification/organ/internal/stromal/expander/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.removable = FALSE		// Not feasible to remove

	M.modifications = list(
		ORGAN_SPECIFIC_SIZE_BASE = 0.20,
		UPGRADE_MAXUPGRADES = 2,
		ATOM_PREFIX = "expanded"
	)
	..()

/obj/item/modification/organ/internal/stromal/silencer
	name = "masked membrane"
	desc = "An outer membrane that absorbs typical medical scanning wavelengths. Slightly impedes organ functions and reduces organ size."
	icon_state = "stealth_composites"

/obj/item/modification/organ/internal/stromal/silencer/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.modifications = list(
		ORGAN_EFFICIENCY_MULT = -0.10,
		ORGAN_SPECIFIC_SIZE_MULT = -0.10,
		ORGAN_SCANNER_HIDDEN = TRUE,
		ATOM_PREFIX = "scanner-masked"
	)
	..()

/obj/item/modification/organ/internal/parenchymal
	name = "pygmy parenchymal membrane"
	desc = "A graftable membrane for organ tissues. Contains functional tissue from one or more organs."
	description_info = "Adds/increases organ efficiencies. Size, blood, oxygen, and nutrition requirements are based on the added efficiencies."
	icon_state = "membrane"
	var/organ_eff_mod = 0.20

/obj/item/modification/organ/internal/parenchymal/Initialize(loc, generate_organ_stats = TRUE, predefined_modifier = organ_eff_mod, num_eff = 1)
	var/datum/component/modification/organ/parenchymal/M = AddComponent(/datum/component/modification/organ/parenchymal)

	//M.multiples_allowed = TRUE	// Stacking these causes UI issues. Not important enough to make a fix right now.

	M.modifications = list(
		ATOM_PREFIX = "grafted"
	)
	..()

/obj/item/modification/organ/internal/parenchymal/large
	name = "parenchymal membrane"
	organ_eff_mod = 0.40

// Junk loot or craftables

/obj/item/modification/organ/internal/electromechanical
	bad_type = /obj/item/modification/organ/internal/electromechanical
	spawn_blacklisted = FALSE
	use_generated_icon = FALSE

/obj/item/modification/organ/internal/electromechanical/bone_braces
	name = "bone braces"
	desc = "Little metal bits that bones can be reinforced with."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone_braces"
	matter = list(MATERIAL_PLASTEEL = 3)
	price_tag = 90
	organ_size = 0

/obj/item/modification/organ/internal/electromechanical/bone_braces/Initialize()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.apply_to_types = list(/obj/item/organ/internal/bone)
	M.install_stat = STAT_MEC
	M.install_difficulty = FAILCHANCE_VERY_EASY - 10
	M.removal_stat = STAT_MEC
	M.removal_difficulty = FAILCHANCE_VERY_EASY - 10
	M.examine_msg = "Can be attached to bones."
	M.examine_difficulty = STAT_LEVEL_BASIC

	M.modifications = list(
		ORGAN_EFFICIENCY_NEW_MOD = list(OP_BONE = 0.33),
		ATOM_PREFIX = "reinforced"
	)
	..()
