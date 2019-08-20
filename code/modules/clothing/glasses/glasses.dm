/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/inventory/eyes/icon.dmi'
	var/prescription = FALSE
	var/toggleable = FALSE
	var/off_state = "degoggles"
	var/active = TRUE
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any

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

/obj/item/clothing/glasses/equipped(mob/user, slot)
	..()
	if(((toggleable || hud) && prescription) && (user.disabilities&NEARSIGHTED) && (slot == slot_glasses))
		to_chat(user, SPAN_NOTICE("[src] optical matrix automatically adjust to your poor prescription."))
