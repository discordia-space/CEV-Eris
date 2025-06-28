/datum/component/clothing_sanity_protection
	var/environment_cap_buff
	var/mob/living/carbon/human/current_user

/datum/component/clothing_sanity_protection/Initialize(value)
	if(!(istype(parent, /obj/item/clothing)))
		return COMPONENT_INCOMPATIBLE
	environment_cap_buff = value
	var/atom/current_parent = parent
	current_parent.description_info += "This item reduces sanity damage taken from environmental factors. \n"
	RegisterSignal(current_parent, COMSIG_CLOTH_EQUIPPED, PROC_REF(handle_sanity_buffs))

/datum/component/clothing_sanity_protection/proc/handle_sanity_buffs(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	var/obj/item/current_parent = parent
	if(current_parent.is_worn() && user.sanity)
		user.sanity.environment_cap_coeff *= environment_cap_buff
		RegisterSignal(user, COMSIG_CLOTH_DROPPED, PROC_REF(handle_sanity_debuff))
		current_user = user

/datum/component/clothing_sanity_protection/proc/handle_sanity_debuff()
	SIGNAL_HANDLER
	current_user.sanity.environment_cap_coeff /= environment_cap_buff
	UnregisterSignal(current_user, COMSIG_CLOTH_DROPPED)
	current_user = null

// Remove any references to avoid hard dels
/datum/component/clothing_sanity_protection/ClearFromParent()
	if(current_user)
		current_user.sanity.environment_cap_coeff /= environment_cap_buff
		UnregisterSignal(current_user, COMSIG_CLOTH_DROPPED)
		current_user = null
	UnregisterSignal(parent, COMSIG_CLOTH_EQUIPPED)
	var/atom/current_parent = parent
	current_parent.description_info = ""
	..()



