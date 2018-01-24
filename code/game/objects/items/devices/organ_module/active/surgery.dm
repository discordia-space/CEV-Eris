/obj/item/organ_module/active/surgial
	name = "embed surgial module"
	verb_name = "Deploy surgial tool"
	icon_state = "multitool"
	allowed_organs = list(BP_R_ARM, BP_L_ARM)
	var/list/items = list(
		/obj/item/weapon/bonesetter,
		/obj/item/weapon/cautery,
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/hemostat,
		/obj/item/weapon/retractor,
		/obj/item/weapon/scalpel,
		/obj/item/weapon/surgicaldrill,
		/obj/item/weapon/bonegel,
		/obj/item/weapon/FixOVein
	)

/obj/item/organ_module/active/surgial/New()
	..()
	var/list/paths = items.Copy()
	items.Cut()
	for(var/path in paths)
		var/obj/item/I = new path (src)
		I.canremove = FALSE
		items += I

/obj/item/organ_module/active/surgial/activate(mob/living/carbon/human/H, obj/item/organ/external/E)
	H << "Actiavate"
	var/target_hand = E.organ_tag == BP_L_ARM ? slot_l_hand : slot_r_hand
	var/obj/I = H.get_active_hand()
	if(I)
		H << "Item in hand"
		if(I in items)
			H.drop_from_inventory(I, src)
			H.visible_message(
				SPAN_WARNING("[H] retract \his [I] into [E]."),
				SPAN_NOTICE("You retract your [I] into [E].")
			)
		else
			H << SPAN_WARNING("You must drop [I] before tool can be extend.")
	else
		var/obj/item = input(H, "Select item for deploy") as null|anything in src
		if(!item || !src.loc in H.organs || H.incapacitated())
			return
		if(H.equip_to_slot_if_possible(item, target_hand))
			H.visible_message(
				SPAN_WARNING("[H] extend \his [item] from [E]."),
				SPAN_NOTICE("You extend your [item] from [E].")
			)
