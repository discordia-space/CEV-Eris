#define TARGET_PATTERN "\\\[Target .*\\]"

/datum/ritual/targeted
	name = "targeted ritual"
	desc = "Basic ritual that does nothing."
	var/phrase = ""
	var/implant_type = /obj/item/weapon/implant/external/core_implant

/datum/ritual/targeted/get_say_phrase()
	var/datum/regex/R = regex("([TARGET_PATTERN])")

	R.Find(phrase)

	var/final_phrase = phrase

	for(var/i = 1; i<=(R.group); i+=1)
		var/list/CL = list()
		for(var/obj/item/weapon/implant/external/core_implant/C in world)
			if(istype(C, implant_type) && C.loc && is_target_valid(i,C))
				CL.Add(C.address)

		var/address = input("Select [copytext(R.group[i],2,-1)]", "Ritual target",CL[1]) in CL

		if(!address)
			return

		final_phrase = replacetextEx(final_phrase,R.group[i],address)

	return final_phrase

/datum/ritual/targeted/get_display_phrase()
	return phrase

/datum/ritual/targeted/compare(var/text)
	var/datum/regex/R = regex("[TARGET_PATTERN]")

	R.replace(phrase,".*")

	R = regex(R.text)

	R.Find(text)

	return R.index != 0

/datum/ritual/targeted/get_targets(var/text)
	var/datum/regex/R = regex("[TARGET_PATTERN]")

	R.replace(phrase,"(.*)")

	R = regex(R.text)

	R.Find(text)

	var/list/targets = list()
	for(var/T in R.group)
		for(var/obj/item/weapon/implant/external/core_implant/C in world)
			if(istype(C, implant_type) && C.loc && C.address == T)
				targets.Add(C)

	return targets

//returns true if object can be added to select list
/datum/ritual/targeted/proc/is_target_valid(var/index, var/obj/item/weapon/implant/external/core_implant/target)
	return TRUE

/datum/ritual/targeted/test
	name = "targeted ritual test"
	desc = "Basic ritual that does nothing."
	var/phrase = "Check this \[Target SHIT], you, motherfucker, named \[Target MOTHERFUCKER]"
	var/implant_type = /obj/item/weapon/implant/external/core_implant/cruciform

/datum/ritual/targeted/test/is_target_valid(var/index, var/obj/item/weapon/implant/external/core_implant/target)
	switch(index)
		if(1)
			return !ishuman(target.loc)
		if(2)
			return ishuman(target.loc)

