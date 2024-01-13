/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	w_class = ITEM_SIZE_TINY

	price_tag = 0.2

	var/leaves_residue = 1
	var/is_caseless = FALSE
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/projectile_type					//The bullet type to create when New() is called
	var/obj/item/projectile/BB			//The loaded bullet - make it so that the projectiles are created only when needed?
	var/spent_icon
	var/amount = 1
	var/maxamount = 15
	var/reload_delay = 0

	var/sprite_update_spawn = FALSE		//defaults to normal sized sprites
	var/sprite_max_rotate = 16
	var/sprite_scale = 1
	var/sprite_use_small = TRUE 		//A var for a later global option to use all big sprites or small sprites for bullets, must be used before startup

	var/shell_color = ""

/obj/item/ammo_casing/Initialize()
	. = ..()
	if(sprite_update_spawn)
		var/matrix/rotation_matrix = matrix()
		rotation_matrix.Turn(round(45 * rand(0, sprite_max_rotate) / 2))
		if(sprite_use_small)
			src.transform = rotation_matrix * sprite_scale
		else
			src.transform = rotation_matrix
	if(ispath(projectile_type))
		BB = new projectile_type(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	if(amount > 1)
		update_icon()

/obj/item/ammo_casing/Destroy()
	make_young()
	QDEL_NULL(BB)
	return ..()

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = BB
	BB = null
	set_dir(pick(cardinal)) //spin spent casings
	update_icon()

/// special case where is the location is specified as a ammo_Casing , it will clone all relevant vars
/obj/item/ammo_casing/New(loc, ...)
	. = ..()
	if(istype(loc, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = loc
		src.amount = 1 // otherwise duplicating the type will make Type/Prespawned start with too large an amount
		C.update_icon()
		update_icon()


/obj/item/ammo_casing/attack_hand(mob/user)
	if((src.amount > 1) && (src == user.get_inactive_hand()))
		src.amount -= 1
		var/obj/item/ammo_casing/new_casing = new src.type(src)
		new_casing.forceMove(get_turf(user))
		user.put_in_active_hand(new_casing)
	else
		return ..()

/obj/item/ammo_casing/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/merging_casing = I
		if(isturf(src.loc))
			if(merging_casing.amount == merging_casing.maxamount)
				to_chat(user, SPAN_WARNING("[merging_casing] is fully stacked!"))
				return FALSE
			if(merging_casing.mergeCasing(src, null, user))
				return TRUE
		else if (mergeCasing(I, 1, user))
			return TRUE

/obj/item/ammo_casing/proc/mergeCasing(var/obj/item/ammo_casing/AC, var/amountToMerge, var/mob/living/user, var/noMessage = FALSE, var/noIconUpdate = FALSE)
	if(!AC)
		return FALSE
	if(!user && noMessage == FALSE)
		error("Passed no user to mergeCasing() when output messages is active.")
	if(src.type != AC.type)
		if(!noMessage)
			to_chat(user, SPAN_WARNING("Ammo are different types."))
		return FALSE
	if(src.amount == src.maxamount)
		if(!noMessage)
			to_chat(user, SPAN_WARNING("[src] is fully stacked!"))
		return FALSE
	if((!src.BB && AC.BB) || (src.BB && !AC.BB))
		if(!noMessage)
			to_chat(user, SPAN_WARNING("Fired and non-fired ammo wont stack."))
		return FALSE

	var/mergedAmount
	if(!amountToMerge)
		mergedAmount = AC.amount
	else
		mergedAmount = amountToMerge
	if(mergedAmount + src.amount > src.maxamount)
		mergedAmount = src.maxamount - src.amount
	AC.amount -= mergedAmount
	src.amount += mergedAmount
	if(!noIconUpdate)
		src.update_icon()
	if(AC.amount == 0)
		QDEL_NULL(AC)
	else
		if(!noIconUpdate)
			AC.update_icon()
	return TRUE

/obj/item/ammo_casing/update_icon()
	if(spent_icon && !BB)
		icon_state = spent_icon
	src.overlays.Cut()
	if(amount > 1)
		src.pixel_x = 0
		src.pixel_y = 0

	for(var/icon_amount = 1; icon_amount < src.amount, icon_amount++)
		var/image/temp_image = image(src.icon, src.icon_state)
		var/coef = round(14 * icon_amount/src.maxamount)

		temp_image.pixel_x = rand(coef, -coef)
		temp_image.pixel_y = rand(coef, -coef)
		var/matrix/temp_image_matrix = matrix()
		temp_image_matrix.Turn(round(45 * rand(0, sprite_max_rotate) / 2))
		temp_image.transform = temp_image_matrix
		src.overlays += temp_image

/obj/item/ammo_casing/examine(mob/user)
	..()
	to_chat(user, "There [(amount == 1)? "is" : "are"] [amount] round\s left!")
	if (!BB)
		to_chat(user, "[(amount == 1)? "This one is" : "These ones are"] spent.")

/obj/item/ammo_casing/get_item_cost(export)
	. = round(..() * amount)
	if(BB)
		. *= 2 // being loaded increases the value by 100%

/obj/item/ammo_casing/get_matter()
	. = matter?.Copy() // return starts at default matter
	if(isnull(.)) // if the casing is matterless, handling is pointless.
		return
	else if(amount > 1) // if there is only one, there is no need to multiply
		for(var/mattertype in .)
			.[mattertype] *= amount // multiply matter appropriately

//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "place-holder-box"
	description_info = "Can be reloaded quickly by clicking on a ammo-box of the corresponding caliber"
	icon = 'icons/obj/ammo_mags.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(MATERIAL_STEEL = 2)
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10

	spawn_tags = SPAWN_TAG_AMMO
	rarity_value = 10
	bad_type = /obj/item/ammo_magazine
	price_tag = 60

	var/modular_sprites = TRUE // If icons with colored stripes is present. False for some legacy sprites
	var/ammo_label // Label on the magazine. Must be a key from ammo_names or null. Received on item spawn and could be changed via hand labeler
	var/ammo_label_string // "_[ammo_label]". Must be a string or null.
	var/list/ammo_states = list() // For which non-zero ammo counts we have separate icon states. From smallest to largest value
	var/list/ammo_names = list(
		"l" = "lethal",
		"r" = "rubber",
		"hv" = "high velocity",
		"p" = "practice",
		"s" = "scrap") // Name changes based on the first projectile's shell_color

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is not a bitflag, the load_method var on guns is.
	var/mag_well = MAG_WELL_GENERIC
	var/caliber = CAL_357
	var/ammo_mag = "default"
	var/max_ammo = 7
	var/reload_delay = 0 //when we need to make reload slower

	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo

/obj/item/ammo_magazine/New()
	..()

	if(isnull(initial_ammo))
		initial_ammo = max_ammo

	if(initial_ammo)
		for(var/i in 1 to initial_ammo)
			stored_ammo += new ammo_type(src)
	get_label()
	update_icon()

/obj/item/ammo_magazine/Destroy()
	make_young()
	QDEL_LIST(contents)		// Normally, we don't want to do this, but this is an exception
	QDEL_LIST(stored_ammo)
	return ..()

/obj/item/ammo_magazine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(stored_ammo.len >= max_ammo)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return
		if(C.caliber != caliber)
			to_chat(user, SPAN_WARNING("\The [C] does not fit into \the [src]."))
			return
		insertCasing(C)
	else if(istype(W, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/other = W
		if(!src.stored_ammo.len)
			to_chat(user, SPAN_WARNING("There is no ammo in \the [src]!"))
			return
		if(other.stored_ammo.len >= other.max_ammo)
			to_chat(user, SPAN_NOTICE("\The [other] is already full."))
			return
		var/diff = FALSE
		for(var/obj/item/ammo in src.stored_ammo)
			if(other.stored_ammo.len < other.max_ammo && do_after(user, reload_delay/other.max_ammo, src) && other.insertCasing(removeCasing()))
				diff = TRUE
				continue
			break
		if(diff)
			to_chat(user, SPAN_NOTICE("You finish loading \the [other]. It now contains [other.stored_ammo.len] rounds, and \the [src] now contains [stored_ammo.len] rounds."))
		else
			to_chat(user, SPAN_WARNING("You fail to load anything into \the [other]"))
	if(istype(W, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/gun_to_load = W
		if(istype(W, /obj/item/gun/projectile/revolver))
			to_chat(user, SPAN_WARNING("You can\'t reload [W] that way!"))
			return
		if(gun_to_load.can_dual && !gun_to_load.ammo_magazine)
			if(!do_after(user, 0.5 SECONDS, src))
				return
			if(loc && istype(loc, /obj/item/storage))
				var/obj/item/storage/S = loc
				gun_to_load.load_ammo(src, user)
				S.refresh_all()
			else
				gun_to_load.load_ammo(src, user)
			to_chat(user, SPAN_NOTICE("It takes a bit of time for you to reload your [W] with [src] using only one hand!"))
			visible_message("[user] tactically reloads [W] using only one hand!")

/obj/item/ammo_magazine/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && stored_ammo.len)
		var/obj/item/ammo_casing/stack = removeCasing()
		if(stack)
			if(stored_ammo.len)
				// We end on -1 since we already removed one
				for(var/i = 1, i <= stack.maxamount - 1, i++)
					if(!stored_ammo.len)
						break
					var/obj/item/ammo_casing/AC = removeCasing()
					if(!stack.mergeCasing(AC, null, user, noIconUpdate = TRUE))
						insertCasing(AC)
						break
			stack.update_icon()
			user.put_in_active_hand(stack)
		return
	..()

/obj/item/ammo_magazine/AltClick(var/mob/living/user)
	var/obj/item/W = user.get_active_hand()
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(stored_ammo.len >= max_ammo)
			to_chat(user, SPAN_WARNING("[src] is full!"))
			return
		if(C.caliber != caliber)
			to_chat(user, SPAN_WARNING("[C] does not fit into [src]."))
			return
		if(stored_ammo.len)
			var/obj/item/ammo_casing/T = removeCasing()
			if(T)
				if(!C.mergeCasing(T, null, user))
					insertCasing(T)
	else if(!W)
		if(user.get_inactive_hand() == src && stored_ammo.len)
			var/obj/item/ammo_casing/AC = removeCasing()
			if(AC)
				user.put_in_active_hand(AC)

/obj/item/ammo_magazine/proc/insertCasing(var/obj/item/ammo_casing/C)
	if(!istype(C))
		return FALSE
	if(C.caliber != caliber)
		return FALSE
	if(stored_ammo.len >= max_ammo)
		return FALSE
	if(C.amount > 1)
		C.amount -= 1

		var/obj/item/ammo_casing/inserted_casing = new C.type(C)
		stored_ammo.Insert(1, inserted_casing)
	else
		if(ismob(C.loc))
			var/mob/M = C.loc
			M.remove_from_mob(C)
		C.forceMove(src)
		stored_ammo.Insert(1, C) //add to the head of the list
	update_icon()
	return TRUE

/obj/item/ammo_magazine/proc/removeCasing()
	if(stored_ammo.len)
		var/obj/item/ammo_casing/AC = stored_ammo[1]
		stored_ammo -= AC
		if(!stored_ammo.len)
			stored_ammo.Cut()
		update_icon()
		return AC

/obj/item/ammo_magazine/resolve_attackby(atom/A, mob/user)
	//Clicking on tile with no collectible items will empty it, if it has the verb to do that.
	if(isturf(A) && !A.density)
		dump_it(A)
		return TRUE
	return ..()

/obj/item/ammo_magazine/verb/quick_empty()
	set name = "Empty Ammo Container"
	set category = "Object"
	set src in view(1)

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	dump_it(T, usr)

/obj/item/ammo_magazine/proc/dump_it(var/turf/target) //bogpilled
	if(!istype(target))
		return
	if(!Adjacent(usr))
		return
	if(!stored_ammo.len)
		to_chat(usr, SPAN_NOTICE("[src] is already empty!"))
		return
	to_chat(usr, SPAN_NOTICE("You take out ammo from [src]."))
	for(var/i=1 to stored_ammo.len)
		var/obj/item/ammo_casing/C = removeCasing()
		C.forceMove(target)
		C.set_dir(pick(cardinal))
	update_icon()

/obj/item/ammo_magazine/proc/get_label(value)
	ammo_label = null
	if(!modular_sprites)
		return

	if(value)
		ammo_label = value
	else
		if(stored_ammo.len)
			var/obj/item/ammo_casing/AC = stored_ammo[stored_ammo.len]
			if(AC && AC.shell_color)
				ammo_label = AC.shell_color

	if(ammo_label)
		var/magazine_name = replacetext(initial(name), ")", " ")
		var/ammo_name = ammo_names[ammo_label]
		name = "[magazine_name][ammo_name])"
		ammo_label_string = "_[ammo_label]"
	else
		name = initial(name)
		ammo_label_string = null
	return

/obj/item/ammo_magazine/update_icon()
	// First inserted casing will define the look and the name of the magazine
	// Ammo boxes keep their original color and name regardless of what ammo is inside
	// No ammo inside - no colored stripe on the magazine
	var/ammo_count = 0
	if(stored_ammo.len && ammo_states)
		// So ammo count is not zero. Let's find closest matching sprite
		for(var/i = 1; i <= ammo_states.len; i++)
			// E.g. if LMG mag have 5 ammo, then pick "pk_box-25" since it's closest non-empty state
			if(stored_ammo.len <= ammo_states[i])
				ammo_count = ammo_states[i]
				break

	icon_state = "[initial(icon_state)][ammo_label_string]-[ammo_count]"

/obj/item/ammo_magazine/examine(mob/user)
	..()
	to_chat(user, "There [(stored_ammo.len == 1)? "is" : "are"] [stored_ammo.len] round\s left!")

/obj/item/ammo_magazine/get_item_cost(export)
	. = ..()
	for(var/obj/item/ammo_casing/i in stored_ammo)
		. += i.get_item_cost(export)
