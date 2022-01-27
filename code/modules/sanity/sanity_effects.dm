/datum/sanity/proc/effect_emote()
	owner.custom_emote(message = level < 20 ? pick_emote_20() : pick_emote_40())

/datum/sanity/proc/effect_69uote()
	to_chat(owner, SPAN_DANGER(level < 20 ? "\icon69'icons/effects/fabric_symbols_20.dmi'6969pick_69uote_20()69" : "\icon69'icons/effects/fabric_symbols_40.dmi'6969pick_69uote_40()69"))

/datum/sanity/proc/effect_sound()
	var/sound/S = pick_sound()
	if(islist(S))
		to_chat(owner,SPAN_DANGER(S69269))
		S = S69169
	owner.playsound_local(owner, S, 50, 0, 8,69ull, 8)

/datum/sanity/proc/effect_whisper()
	var/list/atom/candidates = owner.contents.Copy()
	while(candidates.len)
		var/atom/A = pick(candidates)
		if(!A.desc)
			candidates -= A
			continue
		owner.whisper_say(A.desc, alt_name = owner.name != owner.rank_prefix_name(owner.GetVoice()) ? "(as 69owner.rank_prefix_name(owner.get_id_name())69)" : "")
		break

/datum/sanity/proc/effect_hallucination()
	var/datum/hallucination/H =69ew /datum/hallucination/sanity_mirage
	H.holder = owner
	H.activate()
