/obj/item/craft
	icon = 'icons/obj/crafts.dmi'
	icon_state = "device"
	spawn_tags = null
	var/datum/craft_recipe/recipe
	var/step = 1


/obj/item/craft/New(loc, new_recipe)
	..(loc)
	recipe = new_recipe
	src.name = "crafting [recipe.name]"
	src.icon_state = recipe.icon_state
	update()


/obj/item/craft/proc/update()
	step = recipe.get_actual_step()
	desc = recipe.get_description(step)

/obj/item/craft/proc/continue_crafting(obj/item/I, mob/living/user)
	if(user && istype(loc, /turf))
		user.face_atom(src) //Look at what you're doing please

	if(recipe.try_step(step, I, user, src)) //First step is
		var/datum/craft_step/CS = recipe.steps[step]
		if(CS.completed && recipe.is_compelete(step+1))
			recipe.spawn_result(src, user)
		else
			update()
		return TRUE //Returning true here will prevent afterattack effects for ingredients and tools used on us

	return FALSE

/obj/item/craft/attackby(obj/item/I, mob/living/user)
	return continue_crafting(I, user)

/obj/item/craft/MouseDrop_T(atom/A, mob/user, src_location, over_location, src_control, over_control, params)
	return continue_crafting(A, user)
