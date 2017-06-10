#define TARGET_PATTERN "\\\[Target .*?\\]"

/datum/ritual/targeted
	name = "targeted ritual"
	desc = "Basic ritual that does nothing."
	phrase = ""

/datum/ritual/targeted/get_say_phrase()
	if(!phrase || phrase == "")
		return

	var/regex/R = regex("([TARGET_PATTERN])","g")

	var/list/G = list()

	while(R.Find(phrase))
		G |= R.group

	var/final_phrase = phrase

	var/list/usrview = view()

	for(var/i = 1; i<=length(G); i+=1)
		var/list/CL = list()
		for(var/obj/item/weapon/implant/external/core_implant/C in world)
			C.update_address()
			if(C.loc && C.locs && C.locs[1] in usrview)
				if(istype(C, implant_type) && C.address && is_target_valid(i,C))
					CL.Add(C.address)

		var/address = null
		if(CL.len)
			address = input("Select [copytext(G[i],2,-1)]","Ritual target",CL[1]) in CL

		if(!address)
			return

		final_phrase = replacetextEx(final_phrase,G[i],address)
	return final_phrase

/datum/ritual/targeted/get_display_phrase()
	return phrase

/datum/ritual/targeted/compare(var/text)
	if(!phrase || phrase == "")
		return

	var/regex/R = regex("([TARGET_PATTERN])","g")

	var/T = replacetext(R.Replace(REGEX_QUOTE(phrase),".*"),"\\.*",".*")

	R = regex(T)

	R.Find(text)

	return R.index != null && R.index > 0

/datum/ritual/targeted/get_targets(var/text)
	var/regex/R = regex("[TARGET_PATTERN]","g")

	var/T = replacetext(R.Replace(REGEX_QUOTE(phrase),"(.*)"),"\\(.*)","(.*)")

	R = regex(T,"g")

	var/list/G = list()

	while(R.Find(text))
		G |= R.group

	var/list/targets = list()

	for(var/AD in G)
		for(var/obj/item/weapon/implant/external/core_implant/C in world)
			if(istype(C, implant_type) && C.loc && C.address == AD)
				targets.Add(C)

	return targets

//returns true if object can be added to select list
/datum/ritual/targeted/proc/is_target_valid(var/index, var/obj/item/weapon/implant/external/core_implant/target)
	return TRUE
