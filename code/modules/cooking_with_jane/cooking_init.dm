/proc/initialize_cooking_recipes()
	//All combination path datums, save for the default recipes we don't want.
	var/list/recipe_paths = typesof(/datum/cooking_with_jane/recipe)
	recipe_paths -= /datum/cooking_with_jane/recipe
	for (var/path in recipe_paths)
		var/datum/cooking_with_jane/recipe/example_recipe = new path()
		if(!GLOB.cwj_recipe_dictionary[example_recipe.cooking_container])
			GLOB.cwj_recipe_dictionary[example_recipe.cooking_container] = list()
		GLOB.cwj_recipe_dictionary[example_recipe.cooking_container]["[example_recipe.unique_id]"] = example_recipe

		GLOB.cwj_recipe_list += example_recipe