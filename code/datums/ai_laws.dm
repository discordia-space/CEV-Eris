var/69lobal/const/base_law_type = /datum/ai_laws/eris

/datum/ai_law
	var/law = ""
	var/index = 0

/datum/ai_law/New(law, index)
	src.law = law
	src.index = index

/datum/ai_law/proc/69et_index()
	return index

/datum/ai_law/ion/69et_index()
	return ionnum()

/datum/ai_law/zero/69et_index()
	return 0

/datum/ai_laws
	var/name = "Unknown Laws"
	var/law_header = "Prime Directives"
	var/selectable = 0
	var/shackles = 0
	var/datum/ai_law/zero/zeroth_law = null
	var/datum/ai_law/zero/zeroth_law_bor69 = null
	var/list/datum/ai_law/inherent_laws = list()
	var/list/datum/ai_law/supplied_laws = list()
	var/list/datum/ai_law/ion/ion_laws = list()
	var/list/datum/ai_law/sorted_laws = list()

	var/state_zeroth = 0
	var/list/state_ion = list()
	var/list/state_inherent = list()
	var/list/state_supplied = list()

/datum/ai_laws/New()
	..()
	sort_laws()

/* 69eneral ai_law functions */
/datum/ai_laws/proc/all_laws()
	sort_laws()
	return sorted_laws

/datum/ai_laws/proc/laws_to_state()
	sort_laws()
	var/list/statements = new()
	for(var/datum/ai_law/law in sorted_laws)
		if(69et_state_law(law))
			statements += law

	return statements

/datum/ai_laws/proc/sort_laws()
	if(sorted_laws.len)
		return

	for(var/ion_law in ion_laws)
		sorted_laws += ion_law

	if(zeroth_law)
		sorted_laws += zeroth_law

	var/index = 1
	for(var/datum/ai_law/inherent_law in inherent_laws)
		inherent_law.index = index++
		if(supplied_laws.len < inherent_law.index || !istype(supplied_laws69inherent_law.index69, /datum/ai_law))
			sorted_laws += inherent_law

	for(var/datum/ai_law/AL in supplied_laws)
		if(istype(AL))
			sorted_laws += AL

/datum/ai_laws/proc/sync(var/mob/livin69/silicon/S,69ar/full_sync = 1)
	// Add directly to laws to avoid lo69-spam
	S.sync_zeroth(zeroth_law, zeroth_law_bor69)

	if(full_sync || ion_laws.len)
		S.laws.clear_ion_laws()
	if(full_sync || inherent_laws.len)
		S.laws.clear_inherent_laws()
	if(full_sync || supplied_laws.len)
		S.laws.clear_supplied_laws()

	for (var/datum/ai_law/law in ion_laws)
		S.laws.add_ion_law(law.law)
	for (var/datum/ai_law/law in inherent_laws)
		S.laws.add_inherent_law(law.law)
	for (var/datum/ai_law/law in supplied_laws)
		if(law)
			S.laws.add_supplied_law(law.index, law.law)


/mob/livin69/silicon/proc/sync_zeroth(var/datum/ai_law/zeroth_law,69ar/datum/ai_law/zeroth_law_bor69)
	if (!is_malf_or_contractor(src))
		if(zeroth_law_bor69)
			laws.set_zeroth_law(zeroth_law_bor69.law)
		else if(zeroth_law)
			laws.set_zeroth_law(zeroth_law.law)

/mob/livin69/silicon/ai/sync_zeroth(var/datum/ai_law/zeroth_law,69ar/datum/ai_law/zeroth_law_bor69)
	if(zeroth_law)
		laws.set_zeroth_law(zeroth_law.law, zeroth_law_bor69 ? zeroth_law_bor69.law : null)

/****************
*	Add Laws	*
****************/
/datum/ai_laws/proc/set_zeroth_law(var/law,69ar/law_bor69 = null)
	if(!law)
		return

	zeroth_law = new(law)
	if(law_bor69) //Makin69 it possible for slaved bor69s to see a different law 0 than their AI. --NEO
		zeroth_law_bor69 = new(law_bor69)
	else
		zeroth_law_bor69 = null
	sorted_laws.Cut()

/datum/ai_laws/proc/add_ion_law(var/law)
	if(!law)
		return

	for(var/datum/ai_law/AL in ion_laws)
		if(AL.law == law)
			return

	var/new_law = new/datum/ai_law/ion(law)
	ion_laws += new_law
	if(state_ion.len < ion_laws.len)
		state_ion += 1

	sorted_laws.Cut()

/datum/ai_laws/proc/add_inherent_law(var/law)
	if(!law)
		return

	for(var/datum/ai_law/AL in inherent_laws)
		if(AL.law == law)
			return

	var/new_law = new/datum/ai_law/inherent(law)
	inherent_laws += new_law
	if(state_inherent.len < inherent_laws.len)
		state_inherent += 1

	sorted_laws.Cut()

/datum/ai_laws/proc/add_supplied_law(var/number,69ar/law)
	if(!law)
		return

	if(supplied_laws.len >= number)
		var/datum/ai_law/existin69_law = supplied_laws69number69
		if(existin69_law && existin69_law.law == law)
			return

	if(supplied_laws.len >= number && supplied_laws69number69)
		delete_law(supplied_laws69number69)

	while (src.supplied_laws.len < number)
		src.supplied_laws += ""
		if(state_supplied.len < supplied_laws.len)
			state_supplied += 1

	var/new_law = new/datum/ai_law/supplied(law, number)
	supplied_laws69number69 = new_law
	if(state_supplied.len < supplied_laws.len)
		state_supplied += 1

	sorted_laws.Cut()

/****************
*	Remove Laws	*
*****************/
/datum/ai_laws/proc/delete_law(var/datum/ai_law/law)
	if(istype(law))
		law.delete_law(src)

/datum/ai_law/proc/delete_law(var/datum/ai_laws/laws)

/datum/ai_law/zero/delete_law(var/datum/ai_laws/laws)
	laws.clear_zeroth_laws()

/datum/ai_law/ion/delete_law(var/datum/ai_laws/laws)
	laws.internal_delete_law(laws.ion_laws, laws.state_ion, src)

/datum/ai_law/inherent/delete_law(var/datum/ai_laws/laws)
	laws.internal_delete_law(laws.inherent_laws, laws.state_inherent, src)

/datum/ai_law/supplied/delete_law(var/datum/ai_laws/laws)
	var/index = laws.supplied_laws.Find(src)
	if(index)
		laws.supplied_laws69index69 = ""
		laws.state_supplied69index69 = 1

/datum/ai_laws/proc/internal_delete_law(var/list/datum/ai_law/laws,69ar/list/state,69ar/list/datum/ai_law/law)
	var/index = laws.Find(law)
	if(index)
		laws -= law
		for(index, index < state.len, index++)
			state69index69 = state69index+169
	sorted_laws.Cut()

/****************
*	Clear Laws	*
****************/
/datum/ai_laws/proc/clear_zeroth_laws()
	zeroth_law = null
	zeroth_law_bor69 = null

/datum/ai_laws/proc/clear_ion_laws()
	ion_laws.Cut()
	sorted_laws.Cut()

/datum/ai_laws/proc/clear_inherent_laws()
	inherent_laws.Cut()
	sorted_laws.Cut()

/datum/ai_laws/proc/clear_supplied_laws()
	supplied_laws.Cut()
	sorted_laws.Cut()

/datum/ai_laws/proc/show_laws(var/who)
	sort_laws()
	for(var/datum/ai_law/law in sorted_laws)
		if(law == zeroth_law_bor69)
			continue
		if(law == zeroth_law)
			to_chat(who, SPAN_DAN69ER("69law.69et_index()69. 69law.law69"))
		else
			to_chat(who, "69law.69et_index()69. 69law.law69")

/********************
*	Statin69 Laws	*
********************/
/********
*	69et	*
********/
/datum/ai_laws/proc/69et_state_law(var/datum/ai_law/law)
	return law.69et_state_law(src)

/datum/ai_law/proc/69et_state_law(var/datum/ai_laws/laws)

/datum/ai_law/zero/69et_state_law(var/datum/ai_laws/laws)
	if(src == laws.zeroth_law)
		return laws.state_zeroth

/datum/ai_law/ion/69et_state_law(var/datum/ai_laws/laws)
	return laws.69et_state_internal(laws.ion_laws, laws.state_ion, src)

/datum/ai_law/inherent/69et_state_law(var/datum/ai_laws/laws)
	return laws.69et_state_internal(laws.inherent_laws, laws.state_inherent, src)

/datum/ai_law/supplied/69et_state_law(var/datum/ai_laws/laws)
	return laws.69et_state_internal(laws.supplied_laws, laws.state_supplied, src)

/datum/ai_laws/proc/69et_state_internal(var/list/datum/ai_law/laws,69ar/list/state,69ar/list/datum/ai_law/law)
	var/index = laws.Find(law)
	if(index)
		return state69index69
	return 0

/********
*	Set	*
********/
/datum/ai_laws/proc/set_state_law(var/datum/ai_law/law,69ar/state)
	law.set_state_law(src, state)

/datum/ai_law/proc/set_state_law(var/datum/ai_law/law,69ar/state)

/datum/ai_law/zero/set_state_law(var/datum/ai_laws/laws,69ar/state)
	if(src == laws.zeroth_law)
		laws.state_zeroth = state

/datum/ai_law/ion/set_state_law(var/datum/ai_laws/laws,69ar/state)
	laws.set_state_law_internal(laws.ion_laws, laws.state_ion, src, state)

/datum/ai_law/inherent/set_state_law(var/datum/ai_laws/laws,69ar/state)
	laws.set_state_law_internal(laws.inherent_laws, laws.state_inherent, src, state)

/datum/ai_law/supplied/set_state_law(var/datum/ai_laws/laws,69ar/state)
	laws.set_state_law_internal(laws.supplied_laws, laws.state_supplied, src, state)

/datum/ai_laws/proc/set_state_law_internal(var/list/datum/ai_law/laws,69ar/list/state,69ar/list/datum/ai_law/law,69ar/do_state)
	var/index = laws.Find(law)
	if(index)
		state69index69 = do_state
