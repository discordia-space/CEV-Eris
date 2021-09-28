// Basically they are for the firing range
/obj/structure/target_stake
	name = "target stake"
	desc = "A thin platform with negatively-magnetized wheels."
	icon = 'icons/obj/objects.dmi'
	icon_state = "target_stake"
	density = TRUE
	w_class = ITEM_SIZE_HUGE
	flags = CONDUCT
	var/obj/item/target/pinned_target // the current pinned target

	Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
		..()
		// Move the pinned target along with the stake
		if(pinned_target in view(3, src))
			pinned_target.forceMove(loc, glide_size_override=glide_size_override)

		else // Sanity check: if the pinned target can't be found in immediate view
			pinned_target = null
			density = TRUE

	attackby(obj/item/W as obj, mob/user as mob)
		// Putting objects on the stake. Most importantly, targets
		if(pinned_target)
			return // get rid of that pinned target first!

		if(istype(W, /obj/item/target))
			density = FALSE
			W.set_density(TRUE)
			user.remove_from_mob(W)
			W.loc = loc
			W.layer = 3.1
			pinned_target = W
			to_chat(user, "You slide the target into the stake.")
		return

	attack_hand(mob/user as mob)
		// taking pinned targets off!
		if(pinned_target)
			density = TRUE
			pinned_target.set_density(FALSE)
			pinned_target.layer = OBJ_LAYER

			pinned_target.loc = user.loc
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(pinned_target)
					to_chat(user, "You take the target out of the stake.")
			else
				pinned_target.loc = get_turf(user)
				to_chat(user, "You take the target out of the stake.")

			pinned_target = null
