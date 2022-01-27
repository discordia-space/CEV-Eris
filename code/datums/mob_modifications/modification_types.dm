/datum/mobModification/memory
	var/_memory = ""

/datum/mobModification/memory/addData(var/value)
	_memory += "\n69value69"

/datum/mobModification/memory/apply(var/mob/M)
	if(!..())
		return
	if(M.mind)
		if(replace)
			M.mind.memory = _memory
		else
			M.mind.memory += _memory

// ############################
/datum/mobModification/stats
	var/list/_stats = list()

// keep "time" null or 0 for permanent buff
/datum/mobModification/stats/addData(var/name,69ar/value,69ar/time = 0)
	_stats69name69 = list("value" =69alue, "time" = time)

/datum/mobModification/stats/apply(var/mob/M)
	if(!..())
		return
	if(M.stats)
		for(var/name in _stats)
			var/list/entry = _stats69name69
			if(replace)
				M.stats.setStat(name, 0)
			if(entry69"time"69)
				M.stats.addTempStat(name, entry69"value"69, entry69"time"69)
			else
				M.stats.changeStat(name, entry69"value"69)

// ############################
/datum/mobModification/languages
	var/list/_languages = list()

/datum/mobModification/languages/addData(var/value)
	_languages.Add(value)

/datum/mobModification/languages/apply(var/mob/M)
	if(!..())
		return
	var/mob/living/L =69
	if(!istype(L))
		return
	if(replace)
		for(var/lang in L.languages)
			L.remove_language(lang)
	for(var/lang in _languages)
		L.add_language(lang)
	if(replace)
		L.set_default_language(_languages69169)

// ############################
/datum/mobModification/craftingRecipes
	var/list/_craftingRecipes = list()

/datum/mobModification/craftingRecipes/addData(var/value)
	_craftingRecipes.Add(value)

/datum/mobModification/craftingRecipes/apply(var/mob/M)
	if(!..())
		return
	for(var/recipe in _craftingRecipes)
		M.mind.knownCraftRecipes.Add(recipe)

// ############################
// this is used to create custom69odifications
// for example you need to change69obs both legs with prothetic ones with installed upgrades...
// and since you need create instances of legs and add upgrades to them this datum is for you...
/datum/mobModification/custom

/datum/mobModification/custom/New()
	. = ..()
	if(_content() == -1)
		qdel(src)

// fill content of custom69odification in this proc
/datum/mobModification/custom/proc/_content()
	log_debug("/datum/mobModification is created incorrectly, override _content() proc and apply data there.")
	return -1