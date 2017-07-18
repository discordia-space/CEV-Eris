/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	var/prescription = 0
	var/toggleable = 0
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		toggle(user, !active)

/obj/item/clothing/glasses/New()
	..()
	processing_objects |= src
	if(toggleable)	// We need to spawn them switched off, because they consume power
		toggle(null, active)

/obj/item/clothing/glasses/proc/toggle(mob/user, new_state = 0)
	if(new_state)
		active = 1
		icon_state = initial(icon_state)
		flash_protection = initial(flash_protection)
		tint = initial(tint)
		if(user)
			if(activation_sound)
				user << activation_sound
			user << "<span class='notice'>[src] optical matrix activated.</span>"
	else
		active = 0
		icon_state = off_state
		flash_protection = FLASH_PROTECTION_NONE
		tint = TINT_NONE
		if(user)
			user << "<span class='notice'>[src] optical matrix shuts down.</span>"
	if(user)
		user.update_inv_glasses()
		user.update_action_buttons()

/obj/item/clothing/glasses/equipped(mob/user, slot)
	..()
	if(((toggleable || hud) && prescription) && (user.disabilities&NEARSIGHTED) && (slot == slot_glasses))
		user << "<span class='notice'>[src] optical matrix automatically adjust to your poor prescription.</span>"
