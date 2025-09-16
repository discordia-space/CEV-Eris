//Simple toggleabse module. Just put holding in hands or get it back
/obj/item/organ_module/active/simple
	var/obj/item/holding = null
	var/holding_type = null

/obj/item/organ_module/active/simple/New()
	..()
	if(holding_type)
		holding = new holding_type(src)
		holding.canremove = 0

/obj/item/organ_module/active/simple/proc/deploy(mob/living/carbon/human/H, obj/item/organ/external/E)
	var/slot = null
	if(E.organ_tag in list(BP_L_ARM))
		slot = slot_l_hand
	else if(E.organ_tag in list(BP_R_ARM))
		slot = slot_r_hand
	if(H.equip_to_slot_if_possible(holding, slot))
		H.visible_message(
			span_warning("[H] extend \his [holding.name] from [E]."),
			span_notice("You extend your [holding.name] from [E].")
		)

/obj/item/organ_module/active/simple/proc/retract(mob/living/carbon/human/H, obj/item/organ/external/E)
	if(holding.loc == src)
		return

	if(ismob(holding.loc))
		var/mob/M = holding.loc
		M.drop_from_inventory(holding)
		M.visible_message(
			span_warning("[M] retracts \his [holding.name] into [E]."),
			span_notice("You retract your [holding.name] into [E].")
		)
	holding.forceMove(src)


/obj/item/organ_module/active/simple/activate(mob/living/carbon/human/H, obj/item/organ/external/E)
	if(!can_activate(H, E))
		return

	if(holding.loc == src) //item not in hands
		deploy(H, E)
	else //retract item
		retract(H, E)

/obj/item/organ_module/active/simple/deactivate(mob/living/carbon/human/H, obj/item/organ/external/E)
	retract(H, E)

/obj/item/organ_module/active/simple/organ_removed(obj/item/organ/external/E, mob/living/carbon/human/H)
	retract(H, E)
	..()

