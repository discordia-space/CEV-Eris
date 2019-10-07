/obj/item/organ/internal
	var/list/owner_verbs = list()

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs -= src
		owner.internal_organs_by_name -= src.organ_tag

	return ..()

/obj/item/organ/internal/install()
	..()
	if(owner)
		for(var/proc_path in owner_verbs)
			verbs += proc_path
/obj/item/organ/internal/Process()
	..()
	handle_regeneration()

/obj/item/organ/internal/removed()
	..()
	for(var/verb_path in owner_verbs)
		verbs -= verb_path

/obj/item/organ/internal/proc/take_internal_damage(amount, var/silent=0)
	if(BP_IS_ROBOTIC(src))
		damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && can_feel_pain() && parent_organ && (amount > 5 || prob(10)))
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				var/degree = ""
				if(is_bruised())
					degree = " a lot"
				if(damage < 5)
					degree = " a bit"
				owner.custom_pain("Something inside your [parent.name] hurts[degree].", amount, affecting = parent)

/obj/item/organ/internal/proc/handle_regeneration()
	if(!damage || BP_IS_ROBOTIC(src) || !owner || owner.chem_effects[CE_TOXIN] || owner.is_asystole())
		return
	if(damage < 0.1*max_damage)
		heal_damage(0.1)

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/heal_damage(amount , var/natural = TRUE)
	if (natural && !can_recover())
		return
	if(owner.chem_effects[CE_BLOODCLOT])
		amount *= 1 + owner.chem_effects[CE_BLOODCLOT]
	damage = between(0, damage - round(amount, 0.1), max_damage)