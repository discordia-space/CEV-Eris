/datum/sanity/proc/effect_emote()
	owner.custom_emote(message = level < 20 ? pick_emote_20() : pick_emote_40())

/datum/sanity/proc/effect_quote()
	to_chat(owner, SPAN_DANGER(level < 20 ? "\icon['icons/effects/fabric_symbols_20.dmi'][pick_quote_20()]" : "\icon['icons/effects/fabric_symbols_40.dmi'][pick_quote_40()]"))

/datum/sanity/proc/effect_sound()
	var/sound/S = pick_sound()
	if(islist(S))
		to_chat(owner,SPAN_DANGER(S[2]))
		S = S[1]
	owner.playsound_local(owner, S, 50, 0, 8, null, 8)

/datum/sanity/proc/effect_whisper()
	var/list/atom/candidates = owner.contents.Copy()
	while(candidates.len)
		var/atom/A = pick(candidates)
		if(!A.desc)
			candidates -= A
			continue
		owner.whisper_say(A.desc, alt_name = owner.name != owner.rank_prefix_name(owner.GetVoice()) ? "(as [owner.rank_prefix_name(owner.get_id_name())])" : "")
		break

/datum/sanity/proc/effect_hallucination()
	var/datum/hallucination/H = new /datum/hallucination/sanity_mirage
	H.holder = owner
	H.activate()
