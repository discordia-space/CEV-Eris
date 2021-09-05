/datum/component/clothing_sanity_protection
	dupe_mode = COMPONENT_DUPE_HIGHLANDER
	var/environment_cap_buff
	var/mob/living/carbon/human/current_user

/datum/component/clothing_sanity_protection/Initialize(value)
	if(!(istype(parent, /obj/item/clothing)))
		return COMPONENT_INCOMPATIBLE
	environment_cap_buff = value
	RegisterSignal(parent, COMSIG_CLOTH_EQUIPPED, .proc/handle_sanity_buffs)

/datum/component/clothing_sanity_protection/proc/handle_sanity_buffs(mob/living/carbon/human/user)
	var/obj/item/current_parent = parent
	if(current_parent.is_worn())
		user.sanity.environment_cap_coeff *= environment_cap_buff
		RegisterSignal(user, COMSIG_CLOTH_DROPPED, .proc/handle_sanity_debuff)
		current_user = user

/datum/component/clothing_sanity_protection/proc/handle_sanity_debuff()
	current_user.sanity.environment_cap_coeff /= environment_cap_buff
	UnregisterSignal(current_user, COMSIG_CLOTH_DROPPED)
	current_user = null



