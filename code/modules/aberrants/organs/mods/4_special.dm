// =================================================
// ===============     MEMBRANES     ===============
// =================================================

/obj/item/modification/organ/internal/on_item_examine
	bad_type = /obj/item/modification/organ/internal/on_item_examine

/obj/item/modification/organ/internal/on_item_examine/brainloss
	name = "eldritch membrane"
	desc = "A graftable outer membrane for organ tissues. The alien textures are painful to look at."

/obj/item/modification/organ/internal/on_item_examine/brainloss/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0)
	AddComponent(/datum/component/modification/organ/on_item_examine/brainloss)
	..()


/obj/item/modification/organ/internal/on_pickup

/obj/item/modification/organ/internal/on_pickup/shock
	name = "shocking membrane"
	desc = "A graftable outer membrane for organ tissues. There is bioelectric phenomena present and it hurts to touch."
	icon_state = "membrane-hive"

/obj/item/modification/organ/internal/on_pickup/shock/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0)
	AddComponent(/datum/component/modification/organ/on_pickup/shock)
	..()

/obj/item/modification/organ/internal/on_pickup/shock/update_icon()
	return

/obj/item/modification/organ/internal/on_pickup/shock/powerful
	name = "powerful shocking membrane"
	desc = "A graftable outer membrane for organ tissues. There is significant bioelectric phenomena present and it hurts to touch."

/obj/item/modification/organ/internal/on_pickup/shock/powerful/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0)
	var/datum/component/modification/organ/M = AddComponent(/datum/component/modification/organ/on_pickup/shock/powerful)
	M.modifications[ORGAN_SPECIFIC_SIZE_BASE] = 0
	M.modifications[ORGAN_SPECIFIC_SIZE_MULT] = -0.60
	M.removable = FALSE
	..()


/obj/item/modification/organ/internal/on_cooldown
	bad_type = /obj/item/modification/organ/internal/on_cooldown

/obj/item/modification/organ/internal/on_cooldown/chemical_effect
	name = "endocrinal membrane"
	desc = "A graftable membrane for organ tissues. Secretes hormones when the primary organ function triggers."
	description_info = "Produces a hormone when the primary function triggers."
	var/effect_path = null

/obj/item/modification/organ/internal/on_cooldown/chemical_effect/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/special_args)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	if(special_args?.len >= 1)
		S.effect = special_args[1]
	else if(effect_path)
		S.effect = effect_path
	..()

/obj/item/modification/organ/internal/on_cooldown/reagents_blood
	name = "hepatic membrane"
	desc = "A graftable membrane for organ tissues. Secretes a reagent when the primary organ function triggers."
	description_info = "Produces a reagent when the primary function triggers."
	var/reagent_path = null

/obj/item/modification/organ/internal/on_cooldown/reagents_blood/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/special_args)
	var/datum/component/modification/organ/on_cooldown/reagents_blood/S = AddComponent(/datum/component/modification/organ/on_cooldown/reagents_blood)

	if(special_args?.len >= 1)
		S.reagent = special_args[1]
	else if(reagent_path)
		S.reagent = reagent_path
	..()

/obj/item/modification/organ/internal/on_cooldown/stat_boost
	name = "intracrinal membrane"
	desc = "A graftable membrane for organ tissues. Secretes stimulating hormones when the primary organ function triggers."
	description_info = "Slightly increases a stat when the primary function triggers."
	var/stat = null
	var/modifier = 10

/obj/item/modification/organ/internal/on_cooldown/stat_boost/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/special_args)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	if(special_args?.len >= 2)
		S.stat = special_args[1]
		S.boost = special_args[2]
	else if(stat)
		S.stat = stat
		S.boost = modifier
	..()

// =================================================
// ===============     ORGANOIDS     ===============
// =================================================

/obj/item/modification/organ/internal/symbiotic
	name = "parasitic organoid"
	icon_state = "parasitic_organoid"
	desc = "Functional tissue of one or more organs in graftable form. Inhibits organ functions, but allows for painful implantation of organs."
	use_generated_icon = FALSE
	var/organ_mod = -0.10

/obj/item/modification/organ/internal/symbiotic/Initialize(loc, generate_organ_stats = TRUE, predefined_modifier = organ_mod, num_eff = 1, list/special_args)
	var/datum/component/modification/organ/symbiotic/S = AddComponent(/datum/component/modification/organ/symbiotic)
	S.modifications[ORGAN_SPECIFIC_SIZE_MULT] = 0.10
	..(loc, TRUE, organ_mod)

/obj/item/modification/organ/internal/symbiotic/commensal
	name = "commensalistic organoid"
	desc = "Functional tissue of one or more organs in graftable form. Allows for painful implantation of organs."
	organ_mod = null

/obj/item/modification/organ/internal/symbiotic/mutual
	name = "mutualistic organoid"
	desc = "Functional tissue of one or more organs in graftable form. Supplements organ functions and allows for painful implantation of organs."
	organ_mod = 0.1

/obj/item/modification/organ/internal/deployable
	name = "protractile organoid"
	icon_state = "parasitic_organoid"		// temp
	desc = "Functional tissue of one or more organs in graftable form. Allows for protraction/retraction of an appendage."

/obj/item/modification/organ/internal/deployable/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/special_args)
	var/datum/component/modification/organ/deployable/D = AddComponent(/datum/component/modification/organ/deployable)
	D.stored_type = special_args[1]
	D.modifications[ITEM_VERB_NAME] = special_args[2]
	..()
