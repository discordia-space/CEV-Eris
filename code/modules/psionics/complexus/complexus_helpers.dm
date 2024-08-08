/datum/psi_complexus/proc/cancel()
	sound_to(owner, sound('sound/effects/psi/power_fail.ogg'))
	if(LAZYLEN(manifested_items))
		for(var/thing in manifested_items)
			owner.drop_from_inventory(thing)
			qdel(thing)
		manifested_items = null

/datum/psi_complexus/proc/stunned(amount)
	var/old_stun = stun
	stun = max(stun, amount)
	if(amount && !old_stun)
		to_chat(owner, SPAN_DANGER("Your concentration has been shattered! You cannot focus your psi power!"))
		ui.update_icon()
	cancel()

/datum/psi_complexus/proc/get_armour(armourtype)
	if(use_psi_armour && can_use_passive())
		return round(clamp(clamp(4 * rating, 0, 20) * get_rank(SSpsi.armour_faculty_by_type[armourtype]), 0, 100) * (stamina/max_stamina))
	else
		return 0

/datum/psi_complexus/proc/get_rank(faculty)
	return LAZYACCESS(ranks, faculty)

/datum/psi_complexus/proc/set_rank(faculty, rank, defer_update, temporary)
	if(get_rank(faculty) != rank)
		LAZYSET(ranks, faculty, rank)
		if(!temporary)
			LAZYSET(base_ranks, faculty, rank)
		if(!defer_update)
			update()

/datum/psi_complexus/proc/set_power(amount = 0, additive = FALSE, defer_update)
	power_bonus = additive ? (power_bonus + amount) : amount
	if(!defer_update)
		update()

/datum/psi_complexus/proc/set_cooldown(value)
	next_power_use = world.time + value
	ui.update_icon()

/datum/psi_complexus/proc/can_use_passive()
	return (owner.stat == CONSCIOUS && !suppressed && !stun)

/datum/psi_complexus/proc/can_use(incapacitation_flags)
	return (owner.stat == CONSCIOUS && (!incapacitation_flags || !owner.incapacitated(incapacitation_flags)) && !suppressed && !stun && world.time >= next_power_use)

/datum/psi_complexus/proc/spend_power(value = 0, check_incapacitated)
	. = FALSE
	if(isnull(check_incapacitated))
		check_incapacitated = (INCAPACITATION_STUNNED|INCAPACITATION_UNCONSCIOUS)
	if(can_use(check_incapacitated))
		//value = max(1, ceil(value * cost_modifier))
		value = max(1,ceil(value))
		if(value <= stamina)
			stamina -= value
			ui.update_icon()
			. = TRUE
		else
			backblast(abs(stamina - value))
			stamina = 0
			. = FALSE
		ui.update_icon()

/datum/psi_complexus/proc/spend_power_armor(value = 0)
	armor_cost += value

/datum/psi_complexus/proc/hide_auras()
	if(owner.client)
		for(var/thing in SSpsi.all_aura_images)
			owner.client.images -= thing

/datum/psi_complexus/proc/show_auras()
	if(owner.client)
		for(var/image/I in SSpsi.all_aura_images)
			owner.client.images |= I

/datum/psi_complexus/proc/backblast(var/value)

	// Can't backblast if you're controlling your power.
	if(!owner || suppressed)
		return FALSE

	// NSA effect
	heat_buildup += value

	// Apply armor from cognition
	value = max(value - CLAMP(owner.stats.getStat(STAT_COG) / 40, 0, 2) - 2, 0)
	if(!value)
		to_chat(owner, SPAN_WARNING("You feel energistic dissipate across your psyche."))
		set_cooldown(100 / power_level)
		return FALSE // Completely blocked

	sound_to(owner, sound('sound/effects/psi/power_feedback.ogg'))
	to_chat(owner, SPAN_DANGER("Wild energistic feedback blasts across your psyche!"))
	stunned(value * 2)
	set_cooldown(value * 100 / power_level)

	if(prob(value*10)) owner.emote("scream")


	// Your head asplode.
	owner.adjustBrainLoss(value * 3 - CLAMP(owner.stats.getStat(STAT_TGH) / 8, 0, 10)) // Most blasts will cause around 24 brainloss at most, reduced by both cognition and toughness (max 6 by cognition, max 10 by toughness)

	if(ishuman(owner))
		var/mob/living/carbon/human/pop = owner
		if(pop.random_organ_by_process(BP_BRAIN))
			var/obj/item/organ/internal/vital/brain/sponge = pop.random_organ_by_process(BP_BRAIN)
			if(sponge && sponge.is_broken())
				var/obj/item/organ/external/affecting = pop.get_organ(sponge.parent)
				if(affecting && !affecting.is_stump())
					affecting.droplimb(FALSE, DROPLIMB_BLUNT)
					if(sponge) qdel(sponge)

/datum/psi_complexus/proc/reset()
	aura_color = initial(aura_color)
	ranks = base_ranks ? base_ranks.Copy() : null
	max_stamina = initial(max_stamina)
	stamina = min(stamina, max_stamina)
	cancel()
	update()
