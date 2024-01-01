#define HUMAN_EATING_NO_ISSUE		0
#define HUMAN_EATING_NO_MOUTH		1
#define HUMAN_EATING_BLOCKED_MOUTH	2

#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \
	equipment_tint_total += C.tint;

/mob/living/carbon/human/can_eat(var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			to_chat(src, "Where do you intend to put \the [food]? You don't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(src, SPAN_WARNING("\The [status[2]] is in the way!"))
	return 0

/mob/living/carbon/human/can_see_reagents()
	if(istype(glasses, /obj/item/clothing/glasses/powered/science))
		var/obj/item/clothing/glasses/powered/our_glasses = glasses
		if(our_glasses.active)
			return TRUE
	if(stats.check_for_shared_perk(PERK_SHARED_SEE_REAGENTS))
		return TRUE
	if(stats.getStat(STAT_COG) >= HUMAN_REQ_COG_FOR_REG || stats.getStat(STAT_BIO) >= HUMAN_REQ_BIO_FOR_REG)
		return TRUE
	if(hasCyberFlag(CSF_SEE_REAGENTS))
		return TRUE
	/*
	if(stats.check_for_shared_perk(PERK_SHARED_SEE_CONSUMER_REAGENTS))
		return 2
	*/
	return FALSE

/mob/living/carbon/human/can_force_feed(var/feeder, var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			to_chat(feeder, "Where do you intend to put \the [food]? \The [src] doesn't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(feeder, SPAN_WARNING("\The [status[2]] is in the way!"))
	return 0

/mob/living/carbon/human/proc/can_eat_status()
	if(!check_has_mouth())
		return list(HUMAN_EATING_NO_MOUTH)
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return list(HUMAN_EATING_BLOCKED_MOUTH, blocked)
	return list(HUMAN_EATING_NO_ISSUE)

#undef HUMAN_EATING_NO_ISSUE
#undef HUMAN_EATING_NO_MOUTH
#undef HUMAN_EATING_BLOCKED_MOUTH

/mob/living/carbon/human/proc/update_equipment_vision()
	flash_protection = 0
	equipment_tint_total = 0
	equipment_see_invis	= 0
	equipment_vision_flags = 0
	equipment_prescription = FALSE
	equipment_darkness_modifier = 0
	equipment_overlays.Cut()

	if(istype(head, /obj/item/clothing/head))
		add_clothing_protection(head)
	if(istype(glasses, /obj/item/clothing/glasses))
		process_glasses(glasses)
	if(istype(wear_mask, /obj/item/clothing/mask))
		add_clothing_protection(wear_mask)
	if(istype(wearing_rig,/obj/item/rig))
		process_rig(wearing_rig)
	if(istype(using_scope,/obj/item/gun))
		process_scope(using_scope)
	if(get_active_mutation(src, MUTATION_NIGHT_VISION))
		equipment_darkness_modifier += 7
		equipment_overlays |= global_hud.nvg
		if(HUDtech.Find("glassesoverlay"))
			var/obj/screen/glasses_overlay/GO = HUDtech["glassesoverlay"]
			GO.update_icon()
		equipment_see_invis = SEE_INVISIBLE_NOLIGHTING


/mob/living/carbon/human/proc/process_glasses(obj/item/clothing/glasses/G, forceactive)
	if(G && (G.active || forceactive))
		equipment_darkness_modifier += G.darkness_view
		equipment_vision_flags |= G.vision_flags
		equipment_prescription = equipment_prescription || G.prescription
		if(G.overlay)
			equipment_overlays |= G.overlay
		if(HUDtech.Find("glassesoverlay"))
			var/obj/screen/glasses_overlay/GO = HUDtech["glassesoverlay"]
			GO.update_icon()
		if(G.see_invisible >= 0)
			if(equipment_see_invis)
				equipment_see_invis = min(equipment_see_invis, G.see_invisible)
			else
				equipment_see_invis = G.see_invisible

		add_clothing_protection(G)
		G.process_hud(src)

/mob/living/carbon/human/proc/process_rig(var/obj/item/rig/O)
	if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
		if((O.offline && O.offline_vision_restriction == 2) || (!O.offline && O.vision_restriction == 2))
			equipment_tint_total += TINT_BLIND
	var/obj/item/clothing/glasses/G = O.getCurrentGlasses()
	if(G && O.visor.active)
		process_glasses(G,TRUE)

/mob/living/carbon/human/reset_layer()
	if(hiding)
		if(!(atomFlags & AF_PLANE_UPDATE_HANDLED))
			set_plane(HIDING_MOB_PLANE)
		if(!(atomFlags & AF_LAYER_UPDATE_HANDLED))
			layer = HIDING_MOB_LAYER
	else if(lying)
		if(!(atomFlags & AF_PLANE_UPDATE_HANDLED))
			set_plane(LYING_HUMAN_PLANE)
		if(!(atomFlags & AF_LAYER_UPDATE_HANDLED))
			layer = LYING_HUMAN_LAYER
	else
		..()

/mob/living/carbon/human/proc/process_scope(mob/user)
	var/obj/item/gun/A = using_scope
	equipment_darkness_modifier += A.darkness_view
	equipment_vision_flags |= A.vision_flags
	if(A.see_invisible_gun >= 0)
		if(equipment_see_invis)
			equipment_see_invis = min(equipment_see_invis, A.see_invisible_gun)
		else
			equipment_see_invis = A.see_invisible_gun

/mob/living/carbon/human/proc/adjustStatusEffect(effectType, value)
	statusEffects[effectType] += value

/mob/living/carbon/human/proc/hasCyberFlag(flagToObtain)
	for(var/bodypart in BP_ALL_LIMBS)
		if(!has_organ(bodypart))
			continue
		var/obj/item/organ/external/part = organs_by_name[bodypart]
		var/obj/item/implant/cyberinterface/interface = locate() in part.implants
		if(interface)
			for(var/obj/item/cyberstick/stick in interface.slots)
				if(stick.cyberFlags & flagToObtain)
					return TRUE
	return FALSE
