/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/inventory/eyes/icon.dmi'
	spawn_tags = SPAWN_TAG_GLASSES
	bad_type = /obj/item/clothing/glasses
	style_coverage = COVERS_EYES
	var/prescription = FALSE
	var/toggleable = FALSE
	var/off_state = "black_goggles"
	var/active = TRUE
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay
	var/obj/item/clothing/glasses/hud/hud	// Hud glasses, if any

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		toggle(user, !active)

/obj/item/clothing/glasses/New()
	..()
	START_PROCESSING(SSobj, src)
	if(toggleable)	// We need to spawn them switched off, because they consume power
		toggle(null, active)

/obj/item/clothing/glasses/proc/toggle(mob/user, new_state = 0)
	if(new_state)
		active = TRUE
		icon_state = initial(icon_state)
		flash_protection = initial(flash_protection)
		tint = initial(tint)
		if(user)
			if(activation_sound)
				user << activation_sound
			to_chat(user, SPAN_NOTICE("[src] optical matrix activated."))
	else
		active = FALSE
		icon_state = off_state
		flash_protection = FLASH_PROTECTION_NONE
		tint = TINT_NONE
		if(user)
			to_chat(user, SPAN_NOTICE("[src] optical matrix shuts down."))
	if(user)
		user.update_inv_glasses()
		user.update_action_buttons()
		if(ishuman(user))
			var/mob/living/carbon/human/beingofeyes = user
			beingofeyes.update_equipment_vision()

/obj/item/clothing/glasses/proc/process_hud(mob/M)
	if(hud)
		hud.process_hud(M)

/obj/item/clothing/glasses/equipped(mob/user, slot)
	..()
	if(((toggleable || hud) && prescription) && (get_active_mutation(user, MUTATION_NEARSIGHTED)) && (slot == slot_glasses))
		to_chat(user, SPAN_NOTICE("[src] optical matrix automatically adjust to your poor prescription."))

/obj/item/clothing/glasses/attackby(obj/item/Z, mob/user)
	if(istype(Z,/obj/item/clothing/glasses/attachable_lenses))
		var/obj/item/clothing/glasses/attachable_lenses/lenses = Z
		lenses.handle_insertion(src, user)

/obj/item/clothing/glasses/emp_act(severity)
	. = ..()
	if(hud)
		hud.emp_act(severity)
