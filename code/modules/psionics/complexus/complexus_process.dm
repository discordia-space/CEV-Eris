/datum/psi_complexus/proc/update(force)

	set waitfor = FALSE

	var/last_rating = rating
	var/highest_faculty
	var/highest_rank = 0
	var/combined_rank = 0
	for(var/faculty in ranks)
		var/check_rank = get_rank(faculty)
		if(check_rank == 1)
			LAZYADD(latencies, faculty)
		else
			if(check_rank <= 0)
				ranks -= faculty
			LAZYREMOVE(latencies, faculty)
		combined_rank += check_rank
		if(!highest_faculty || highest_rank < check_rank)
			highest_faculty = faculty
			highest_rank = check_rank

	// To determine powerlevel we add up every source of power: this will be Chem Signals, Genetic Mutations (only the highest grade), and Perks
	power_level = (get_active_mutation(owner, MUTATION_PSI_HIGH) ? 3 : (get_active_mutation(owner, MUTATION_PSI_LOW) ? 2 : 0)) + power_bonus

	UNSETEMPTY(latencies)
	var/rank_count = max(1, LAZYLEN(ranks))
	if(force || last_rating != ceil(combined_rank/rank_count))
		if(highest_rank <= 1)
			if(highest_rank == 0)
				qdel(src)
			return
		else
			rebuild_power_cache = TRUE
			sound_to(owner, 'sound/effects/psi/power_unlock.ogg')
			rating = ceil(combined_rank/rank_count)

			// We use a rating system relying on Genetics - the power_level variable
			max_stamina = 10 + power_level * 15 // Operant: 40, Paramount: 85

			//cost_modifier = 1
			//if(power_level > 1)
			//	cost_modifier -= min(1, max(0.1, (power_level-1) / 10))
			if(!ui)
				ui = new(owner)
				if(owner.client)
					owner.client.screen += ui.components
					owner.client.screen += ui
			else
				if(owner.client)
					owner.client.screen |= ui.components
					owner.client.screen |= ui
			if(!suppressed && owner.client)
				for(var/thing in SSpsi.all_aura_images)
					owner.client.images |= thing

			var/image/aura_image = get_aura_image()
			if(power_level >= PSI_RANK_PARAMOUNT) // spooky boosters
				aura_color = "#000000" // black

			aura_image.blend_mode = BLEND_ADD

			if(!highest_faculty)
				aura_color = "#cc00cc" // magenta - generalist
			else if(highest_faculty == PSI_COERCION)
				aura_color = "#3333cc" // blue - disarm
			else if(highest_faculty == PSI_PSYCHOKINESIS)
				aura_color = "#cccc33" // yellow - grab
			else if(highest_faculty == PSI_REDACTION)
				aura_color = "#33cc33" // green - help
			else if(highest_faculty == PSI_ENERGISTICS)
				aura_color = "#cc3333" // red - harm

			aura_image.pixel_x = -64 - owner.default_pixel_x
			aura_image.pixel_y = -64 - owner.default_pixel_y

	if(!announced && owner && owner.client && !QDELETED(src))
		announced = TRUE
		to_chat(owner, "<hr>")
		to_chat(owner, SPAN_NOTICE("You are <b>psionic</b>, touched by powers beyond understanding."))
		to_chat(owner, SPAN_NOTICE("<b>Shift-left-click your Psi icon</b> on the bottom right to <b>view a summary of how to use them</b>, or <b>left click</b> it to <b>suppress or unsuppress</b> your psionics. Beware: overusing your gifts can have <b>deadly consequences</b>."))
		to_chat(owner, "<hr>")

/datum/psi_complexus/Process()
	var/update_hud
	var/recovery_bonus = 1 + CLAMP(owner.stats.getStat(STAT_COG) / 160, 0, 0.5) // Used for heat dissipation

	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.metabolism_effects.adjust_nsa(heat_buildup, "Psi Complexus")

	if(armor_cost)
		//var/value = max(1, ceil(armor_cost * cost_modifier))
		var/value = max(1, ceil(armor_cost))
		if(value <= stamina)
			stamina -= value
		else
			backblast(abs(stamina - value))
			stamina = 0
		update_hud = TRUE
		armor_cost = 0

	if(stun)
		stun--
		if(stun)
			if(!suppressed)
				suppressed = TRUE
				update_hud = TRUE
		else
			to_chat(owner, SPAN_NOTICE("You have recovered your mental composure."))
			update_hud = TRUE
	else
		var/psi_leech = owner.do_psionics_check()
		if(psi_leech)
			if(stamina > 10)
				stamina = max(0, stamina - rand(15,20))
				to_chat(owner, SPAN_DANGER("You feel your psi-power leeched away by \the [psi_leech]..."))
			else
				stamina++
		else if(stamina < max_stamina)
			if(owner.stat == CONSCIOUS)
				stamina = min(max_stamina, stamina + rand(1,power_level+1)) // Operant avg is 2, Paramount is 3.5
			else if(owner.stat == UNCONSCIOUS)
				stamina = min(max_stamina, stamina + rand(power_level,power_level*2))
		else if(stamina > max_stamina)
			stamina = max_stamina
		if(heat_buildup)
			if(owner.stat == CONSCIOUS)
				heat_buildup = max(0, heat_buildup - recovery_bonus)
			else if(owner.stat == UNCONSCIOUS)
				heat_buildup = min(0, heat_buildup - rand(1,3) * recovery_bonus)

		if(owner.stat == CONSCIOUS && stamina && !suppressed && get_rank(PSI_REDACTION) >= PSI_RANK_OPERANT)
			attempt_regeneration()

	var/next_aura_size = max(0.1,((stamina/max_stamina)*power_level)/2)
	var/next_aura_alpha = round(((suppressed ? max(0,rating - 2) : rating)/5)*255)

	if(next_aura_alpha != last_aura_alpha || next_aura_size != last_aura_size || aura_color != last_aura_color)
		last_aura_size =  next_aura_size
		last_aura_alpha = next_aura_alpha
		last_aura_color = aura_color
		animate(
			get_aura_image(),
			alpha = next_aura_alpha,
			transform = matrix().Update(scale_x = next_aura_size, scale_y = next_aura_size),
			color = aura_color,
			time = 3
		)

	if(update_hud)
		ui.update_icon()

/datum/psi_complexus/proc/attempt_regeneration()

	var/heal_general =  FALSE
	var/heal_poison =   FALSE
	var/heal_internal = FALSE
	var/heal_bleeding = FALSE
	var/heal_rate =     0
	var/mend_prob =     0

	var/use_rank = get_rank(PSI_REDACTION)
	if(use_rank >= PSI_RANK_PARAMOUNT)
		heal_general = TRUE
		heal_poison = TRUE
		heal_internal = TRUE
		heal_bleeding = TRUE
		mend_prob = 50
		heal_rate = 7
	else if(use_rank == PSI_RANK_GRANDMASTER)
		heal_poison = TRUE
		heal_internal = TRUE
		heal_bleeding = TRUE
		mend_prob = 20
		heal_rate = 5
	else if(use_rank == PSI_RANK_MASTER)
		heal_internal = TRUE
		heal_bleeding = TRUE
		mend_prob = 10
		heal_rate = 3
	else if(use_rank == PSI_RANK_OPERANT)
		heal_bleeding = TRUE
		mend_prob = 5
		heal_rate = 1
	else
		return

	if(!heal_rate || stamina < heal_rate)
		return // Don't backblast from trying to heal ourselves thanks.

	if(ishuman(owner))

		var/mob/living/carbon/human/H = owner

		// Fix some pain.
		if(heal_rate > 0)
			H.shock_stage = max(0, H.shock_stage - max(1, round(heal_rate/2)))

		// Mend internal damage.
		if(prob(mend_prob))

			// Attempt miracle if we're paramount.
			if(heal_general && H.stat == DEAD)
				var/obj/item/organ/internal/vital/heart_organ = H.random_organ_by_process(OP_HEART)
				var/obj/item/organ/internal/vital/brain_organ = H.random_organ_by_process(BP_BRAIN)

				if(!H.is_asystole() && !(heart_organ && brain_organ) || (heart_organ.is_broken() || brain_organ.is_broken()))
					H.visible_message(SPAN_WARNING("\The [src] cannot be resuscitated in this state!"))
				else if (spend_power(heal_rate))
					H.resuscitate()

			// Heal organ damage.
			if(heal_internal)
				for(var/obj/item/organ/internal/I in H.internal_organs)

					if(BP_IS_ROBOTIC(I) || BP_IS_CRYSTAL(I))
						continue

					if(I && istype(I))
						var/list/current_wounds = I.GetComponents(/datum/component/internal_wound)
						if(LAZYLEN(current_wounds) && prob(heal_rate * 10) && spend_power(heal_rate))
							SEND_SIGNAL_OLD(I, COMSIG_IORGAN_REMOVE_WOUND, pick(current_wounds))
							to_chat(H, SPAN_NOTICE("Your innards itch as your autoredactive faculty mends your [I.name]."))

			// Heal broken bones.
			if(length(H.bad_external_organs))
				for(var/obj/item/organ/external/E in H.bad_external_organs)

					if(BP_IS_ROBOTIC(E))
						continue

					if(heal_internal && (E.status & ORGAN_BROKEN) && E.damage < (E.min_broken_damage * ORGAN_HEALTH_MULTIPLIER)) // So we don't mend and autobreak.
						if(spend_power(heal_rate))
							if(E.mend_fracture())
								to_chat(H, SPAN_NOTICE("Your autoredactive faculty coaxes together the shattered bones in your [E.name]."))
								return

					if(heal_bleeding)

						for(var/datum/wound/W in E.wounds)

							if(W.bleeding() && spend_power(heal_rate))
								to_chat(H, SPAN_NOTICE("Your autoredactive faculty knits together severed veins, stemming the bleeding from \a [W.desc] on your [E.name]."))
								W.bleed_timer = 0
								W.clamped = TRUE
								E.status &= ~ORGAN_BLEEDING
								return

	// Heal radiation, cloneloss and poisoning.
	if(heal_poison)

		if(owner.radiation && spend_power(heal_rate))
			if(prob(25))
				to_chat(owner, SPAN_NOTICE("Your autoredactive faculty repairs some of the radiation damage to your body."))
			owner.radiation = max(0, owner.radiation - heal_rate)
			return

		if(owner.getCloneLoss() && spend_power(heal_rate))
			if(prob(25))
				to_chat(owner, SPAN_NOTICE("Your autoredactive faculty stitches together some of your mangled DNA."))
			owner.adjustCloneLoss(-heal_rate)
			return

	// Heal everything left.
	if(heal_general && prob(mend_prob) && (owner.getBruteLoss() || owner.getFireLoss() || owner.getOxyLoss()) && spend_power(heal_rate))
		owner.adjustBruteLoss(-(heal_rate))
		owner.adjustFireLoss(-(heal_rate))
		owner.adjustOxyLoss(-(heal_rate))
		if(prob(25))
			to_chat(owner, SPAN_NOTICE("Your skin crawls as your autoredactive faculty heals your body."))
