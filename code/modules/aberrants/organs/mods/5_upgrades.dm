/obj/item/modification/organ/internal/stromal
	name = "stromal organoid"
	icon = 'icons/obj/organ_mods.dmi'
	spawn_blacklisted = FALSE	// No RNG stats, no teratoma needed. Helps illustrate the gradual increase of weirdness from regular organs to the more bizarre aberrant organs.
	bad_type = /obj/item/modification/organ/internal/stromal

/obj/item/modification/organ/internal/stromal/update_icon()
	return

// Improvement mods add a beneficial multiplier or additive modifier to organ stats.
/obj/item/modification/organ/internal/stromal/improvement
	name = "improvement organoid"
	bad_type = /obj/item/modification/organ/internal/stromal/improvement

/obj/item/modification/organ/internal/stromal/improvement/requirements
	name = "improved capillaries"
	desc = "Modified capillaries that improve substance transfer within an organ."
	icon_state = "capillary"

/obj/item/modification/organ/internal/stromal/improvement/requirements/New()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.blood_req_multiplier = 0.10
	M.nutriment_req_multiplier = 0.10
	M.oxygen_req_multiplier = 0.10
	M.prefix = "efficient"
	..()

/obj/item/modification/organ/internal/stromal/improvement/durability
	name = "durable membrane"
	desc = "A stronger membrane that allows an organ to sustain greater injury before its functions are diminished."
	icon_state = "mucous_membrane"

/obj/item/modification/organ/internal/stromal/improvement/durability/New()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.specific_organ_size_mod = 0.25
	M.min_bruised_damage_multiplier = 0.20
	M.min_broken_damage_multiplier = 0.20
	M.max_damage_multiplier = 0.20
	M.prefix = "durable"
	..()

/obj/item/modification/organ/internal/stromal/improvement/efficiency
	name = "stem cell application"
	desc = "A clump of stem cells that increases the functional efficiency of an organ when applied to parenchymal tissue."
	icon_state = "stem_cells"

/obj/item/modification/organ/internal/stromal/improvement/efficiency/New()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.organ_efficiency_multiplier = 0.10
	M.removable = FALSE		// Stem cells don't go back to being undifferentiated
	M.prefix = "enhanced"
	..()

// Augments modify organ efficiencies or other behaviors.
/obj/item/modification/organ/internal/stromal/augment
	name = "augment organoid"
	desc = ""
	bad_type = /obj/item/modification/organ/internal/stromal/augment
	
/obj/item/modification/organ/internal/stromal/augment/overclock
	name = "visceral symbiont"
	desc = "A leech-like creature that attaches itself to the viscera of an orgnanism. It mimics the function of the parent organ in exchange for blood, oxygen, and nutrients."
	icon_state = "symbiont"

/obj/item/modification/organ/internal/stromal/augment/overclock/New()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.organ_efficiency_multiplier = 0.20
	M.blood_req_multiplier = -0.20
	M.nutriment_req_multiplier = -0.20
	M.oxygen_req_multiplier = -0.20
	M.prefix = "symbiotic"
	..()

/obj/item/modification/organ/internal/stromal/augment/underclock
	name = "bypass tubules"
	desc = "A series of tubules that siphon blood away from an organ, reducing its effectiveness, to be used elsewhere in the body."
	icon_state = "tubules"

/obj/item/modification/organ/internal/stromal/augment/underclock/New()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.organ_efficiency_multiplier = -0.20		// Brings a standard organ just above the efficiency where the body is negatively impacted
	M.blood_req_multiplier = 0.20
	M.nutriment_req_multiplier = 0.20
	M.oxygen_req_multiplier = 0.20
	M.prefix = "bypassed"
	..()

/obj/item/modification/organ/internal/stromal/augment/expander
	name = "biostructure gel"
	desc = "A gel that will solidify as structural tissue of the organ it is applied to."
	icon_state = "advanced_collagen"

/obj/item/modification/organ/internal/stromal/augment/expander/New()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.specific_organ_size_mod = 0.25
	M.max_upgrade_mod = 2
	M.removable = FALSE		// Not feasible to remove
	M.prefix = "expanded"
	..()

/obj/item/modification/organ/internal/stromal/augment/silencer
	name = "masked membrane"
	desc = "An outer membrane that absorbs typical medical scanning wavelengths. Slightly impedes organ functions."
	icon_state = "stealth_composites"

/obj/item/modification/organ/internal/stromal/augment/silencer/New()
	var/datum/component/modification/organ/stromal/M = AddComponent(/datum/component/modification/organ/stromal)

	M.organ_efficiency_multiplier = -0.10
	M.scanner_hidden = TRUE
	M.prefix = "scanner-masked"
	..()

/obj/item/modification/organ/internal/parenchymal
	name = "pygmy parenchymal membrane"
	desc = "A graftable membrane for organ tissues. Contains functional tissue from one or more organs."
	description_info = "Adds/increases organ efficiencies. Size, blood, oxygen, and nutrition requirements are based on the added efficiencies."
	icon_state = "membrane"
	var/organ_eff_mod = 0.2

/obj/item/modification/organ/internal/parenchymal/New(loc, generate_organ_stats = TRUE, predefined_modifier = organ_eff_mod)
	var/datum/component/modification/organ/parenchymal/M = AddComponent(/datum/component/modification/organ/parenchymal)

	M.prefix = "multi-functional"
	..()

/obj/item/modification/organ/internal/parenchymal/large
	name = "parenchymal membrane"
	organ_eff_mod = 0.4
