//Simple toggleabse69odule. Just put holding in hands or get it back
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
	if(H.e69uip_to_slot_if_possible(holding, slot))
		H.visible_message(
			SPAN_WARNING("69H69 extend \his 69holding.name69 from 69E69."),
			SPAN_NOTICE("You extend your 69holding.name69 from 69E69.")
		)

/obj/item/organ_module/active/simple/proc/retract(mob/living/carbon/human/H, obj/item/organ/external/E)
	if(holding.loc == src)
		return

	if(ismob(holding.loc))
		var/mob/M = holding.loc
		M.drop_from_inventory(holding)
		M.visible_message(
			SPAN_WARNING("69M69 retract \his 69holding.name69 into 69E69."),
			SPAN_NOTICE("You retract your 69holding.name69 into 69E69.")
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

/obj/item/organ_module/active/simple/organ_removed(var/obj/item/organ/external/E,69ar/mob/living/carbon/human/H)
	retract(H, E)
	..()

