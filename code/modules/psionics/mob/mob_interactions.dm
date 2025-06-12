#define INVOKE_PSI_POWERS(holder, powers, target, return_on_invocation) \
	if(holder && holder.psi && holder.psi.can_use()) { \
		for(var/thing in powers) { \
			var/decl/psionic_power/power = thing; \
			var/obj/item/result = power.invoke(holder, target); \
			if(result) { \
				power.handle_post_power(holder, target); \
				if(istype(result)) { \
					sound_to(holder, sound('sound/effects/psi/power_evoke.ogg')); \
					LAZYADD(holder.psi.manifested_items, result); \
					holder.put_in_hands(result); \
				} \
				return return_on_invocation; \
			} \
		} \
	}

/mob/living/UnarmedAttack(atom/A, proximity)
	. = ..()
	if(. && psi)
		INVOKE_PSI_POWERS(src, psi.get_melee_powers(SSpsi.faculties_by_intent[a_intent]), A, FALSE)
		src.visible_message(SPAN_NOTICE("Holder is [src]. Target is [A].")) // TODO: REMOVE LINE

/mob/living/RangedAttack(atom/A, params)
	if(psi)
		INVOKE_PSI_POWERS(src, psi.get_ranged_powers(SSpsi.faculties_by_intent[a_intent]), A, TRUE)
		src.visible_message(SPAN_NOTICE("Holder is [src]. Target is [A].")) // TODO: REMOVE LINE
	. = ..()

/mob/living/proc/check_psi_grab(obj/item/grab/grab)
	src.visible_message(SPAN_NOTICE("Holder is [src]. Target is [grab.affecting].")) // TODO: REMOVE LINE
	if(psi && ismob(grab.affecting))
		INVOKE_PSI_POWERS(src, psi.get_grab_powers(SSpsi.faculties_by_intent[a_intent]), grab.affecting, FALSE)

/mob/living/attack_empty_hand(bp_hand)
	if(psi)
		INVOKE_PSI_POWERS(src, psi.get_manifestations(), src, FALSE)
		src.visible_message(SPAN_NOTICE("Holder is [src]. Target is [src].")) // TODO: REMOVE LINE
	. = ..()

#undef INVOKE_PSI_POWERS
