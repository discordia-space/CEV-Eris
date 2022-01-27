SUBSYSTEM_DEF(craft)
	name = "Craft"
	init_order = INIT_ORDER_CRAFT
	flags = SS_NO_FIRE
	var/list/categories //list of craft_recipe objects(datums)
	var/list/cat_names //list of strings from craft_recipe.category

	var/global/list/current_category = list()
	var/global/list/current_item = list()

/datum/controller/subsystem/craft/Initialize(timeofday)
	categories = list()
	cat_names = list()
	for(var/path in subtypesof(/datum/craft_recipe))
		var/datum/craft_recipe/CR = path
		if(!initial(CR.name))
			continue
		CR = new CR
		cat_names |= CR.category
		if(!CR.steps.len)
			if(CR.name)
				world.log << "ERROR: empty steps for craft recipe 69CR.type69"
			qdel(CR)
		if(!(CR.category in categories))
			categories69CR.category69 = list()
		categories69CR.category69 += CR
		CHECK_TICK
	return ..()

