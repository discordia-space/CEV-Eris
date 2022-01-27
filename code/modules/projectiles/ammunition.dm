/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	w_class = ITEM_SIZE_TINY

	var/leaves_residue = 1
	var/is_caseless = FALSE
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/projectile_type					//The bullet type to create when69ew() is called
	var/obj/item/projectile/BB			//The loaded bullet -69ake it so that the projectiles are created only when69eeded?
	var/spent_icon
	var/amount = 1
	var/maxamount = 15
	var/reload_delay = 0

	var/sprite_update_spawn = FALSE		//defaults to69ormal sized sprites
	var/sprite_max_rotate = 16
	var/sprite_scale = 1
	var/sprite_use_small = TRUE 		//A69ar for a later global option to use all big sprites or small sprites for bullets,69ust be used before startup

	var/shell_color = ""

/obj/item/ammo_casing/Initialize()
	. = ..()
	if(sprite_update_spawn)
		var/matrix/rotation_matrix =69atrix()
		rotation_matrix.Turn(round(45 * rand(0, sprite_max_rotate) / 2))
		if(sprite_use_small)
			src.transform = rotation_matrix * sprite_scale
		else
			src.transform = rotation_matrix
	if(ispath(projectile_type))
		BB =69ew projectile_type(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	if(amount > 1)
		update_icon()

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = BB
	BB =69ull
	set_dir(pick(cardinal)) //spin spent casings
	update_icon()

/obj/item/ammo_casing/attack_hand(mob/user)
	if((src.amount > 1) && (src == user.get_inactive_hand()))
		src.amount -= 1
		var/obj/item/ammo_casing/new_casing =69ew /obj/item/ammo_casing(get_turf(user))
		new_casing.name = src.name
		new_casing.desc = src.desc
		new_casing.caliber = src.caliber
		new_casing.projectile_type = src.projectile_type
		new_casing.icon_state = src.icon_state
		new_casing.spent_icon = src.spent_icon
		new_casing.maxamount = src.maxamount
		if(ispath(new_casing.projectile_type) && src.BB)
			new_casing.BB =69ew69ew_casing.projectile_type(new_casing)
		else
			new_casing.BB =69ull

		new_casing.sprite_max_rotate = src.sprite_max_rotate
		new_casing.sprite_scale = src.sprite_scale
		new_casing.sprite_use_small = src.sprite_use_small
		new_casing.sprite_update_spawn = src.sprite_update_spawn

		if(new_casing.sprite_update_spawn)
			var/matrix/rotation_matrix =69atrix()
			rotation_matrix.Turn(round(45 * rand(0,69ew_casing.sprite_max_rotate) / 2))
			if(new_casing.sprite_use_small)
				new_casing.transform = rotation_matrix *69ew_casing.sprite_scale
			else
				new_casing.transform = rotation_matrix

		new_casing.is_caseless = src.is_caseless
		new_casing.shell_color = src.shell_color

		new_casing.update_icon()
		src.update_icon()
		user.put_in_active_hand(new_casing)
	else
		return ..()

/obj/item/ammo_casing/attackby(obj/item/I,69ob/user)
	if(I.get_tool_type(usr, list(69UALITY_SCREW_DRIVING, 69UALITY_CUTTING), src))
		if(!BB)
			to_chat(user, SPAN_NOTICE("There is69o bullet in the casing to inscribe anything into."))
			return

		var/tmp_label = ""
		var/label_text = sanitizeSafe(input(user, "Inscribe some text into \the 69initial(BB.name)69","Inscription",tmp_label),69AX_NAME_LEN)
		if(length(label_text) > 20)
			to_chat(user, SPAN_WARNING("The inscription can be at69ost 20 characters long."))
		else if(!label_text)
			to_chat(user, SPAN_NOTICE("You scratch the inscription off of 69initial(BB)69."))
			BB.name = initial(BB.name)
		else
			to_chat(user, SPAN_NOTICE("You inscribe \"69label_text69\" into \the 69initial(BB.name)69."))
			BB.name = "69initial(BB.name)69 (\"69label_text69\")"
		return TRUE
	else if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/merging_casing = I
		if(isturf(src.loc))
			if(merging_casing.amount ==69erging_casing.maxamount)
				to_chat(user, SPAN_WARNING("69merging_casing69 is fully stacked!"))
				return FALSE
			if(merging_casing.mergeCasing(src,69ull, user))
				return TRUE
		else if (mergeCasing(I, 1, user))
			return TRUE

/obj/item/ammo_casing/proc/mergeCasing(var/obj/item/ammo_casing/AC,69ar/amountToMerge,69ar/mob/living/user,69ar/noMessage = FALSE,69ar/noIconUpdate = FALSE)
	if(!AC)
		return FALSE
	if(!user &&69oMessage == FALSE)
		error("Passed69o user to69ergeCasing() when output69essages is active.")
	if(src.caliber != AC.caliber)
		if(!noMessage)
			to_chat(user, SPAN_WARNING("Ammo are different calibers."))
		return FALSE
	if(src.projectile_type != AC.projectile_type)
		if(!noMessage)
			to_chat(user, SPAN_WARNING("Ammo are different types."))
		return FALSE
	if(src.amount == src.maxamount)
		if(!noMessage)
			to_chat(user, SPAN_WARNING("69src69 is fully stacked!"))
		return FALSE
	if((!src.BB && AC.BB) || (src.BB && !AC.BB))
		if(!noMessage)
			to_chat(user, SPAN_WARNING("Fired and69on-fired ammo wont stack."))
		return FALSE

	var/mergedAmount
	if(!amountToMerge)
		mergedAmount = AC.amount
	else
		mergedAmount = amountToMerge
	if(mergedAmount + src.amount > src.maxamount)
		mergedAmount = src.maxamount - src.amount
	AC.amount -=69ergedAmount
	src.amount +=69ergedAmount
	if(!noIconUpdate)
		src.update_icon()
	if(AC.amount == 0)
		69DEL_NULL(AC)
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
		var/matrix/temp_image_matrix =69atrix()
		temp_image_matrix.Turn(round(45 * rand(0, sprite_max_rotate) / 2))
		temp_image.transform = temp_image_matrix
		src.overlays += temp_image

/obj/item/ammo_casing/examine(mob/user)
	..()
	to_chat(user, "There 69(amount == 1)? "is" : "are"69 69amount69 round\s left!")
	if (!BB)
		to_chat(user, "69(amount == 1)? "This one is" : "These ones are"69 spent.")

//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A69agazine for some kind of gun."
	icon_state = "place-holder-box"
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

	var/modular_sprites = TRUE // If icons with colored stripes is present. False for some legacy sprites
	var/ammo_label // Label on the69agazine.69ust be a key from ammo_names or69ull. Received on item spawn and could be changed69ia hand labeler
	var/ammo_label_string // "_69ammo_label69".69ust be a string or69ull.
	var/list/ammo_states = list() // For which69on-zero ammo counts we have separate icon states. From smallest to largest69alue
	var/list/ammo_names = list(
		"l" = "lethal",
		"r" = "rubber",
		"hv" = "high69elocity",
		"p" = "practice",
		"s" = "scrap") //69ame changes based on the first projectile's shell_color

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is69ot a bitflag, the load_method69ar on guns is.
	var/mag_well =69AG_WELL_GENERIC
	var/caliber = CAL_357
	var/ammo_mag = "default"
	var/max_ammo = 7
	var/reload_delay = 0 //when we69eed to69ake reload slower

	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo

/obj/item/ammo_magazine/New()
	..()

	if(isnull(initial_ammo))
		initial_ammo =69ax_ammo

	if(initial_ammo)
		for(var/i in 1 to initial_ammo)
			stored_ammo +=69ew ammo_type(src)
	get_label()
	update_icon()

/obj/item/ammo_magazine/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(stored_ammo.len >=69ax_ammo)
			to_chat(user, SPAN_WARNING("\The 69src69 is full!"))
			return
		if(C.caliber != caliber)
			to_chat(user, SPAN_WARNING("\The 69C69 does69ot fit into \the 69src69."))
			return
		insertCasing(C)
	else if(istype(W, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/other = W
		if(!src.stored_ammo.len)
			to_chat(user, SPAN_WARNING("There is69o ammo in \the 69src69!"))
			return
		if(other.stored_ammo.len >= other.max_ammo)
			to_chat(user, SPAN_NOTICE("\The 69other69 is already full."))
			return
		var/diff = FALSE
		for(var/obj/item/ammo in src.stored_ammo)
			if(other.stored_ammo.len < other.max_ammo && do_after(user, reload_delay/other.max_ammo, src) && other.insertCasing(removeCasing()))
				diff = TRUE
				continue
			break
		if(diff)
			to_chat(user, SPAN_NOTICE("You finish loading \the 69other69. It69ow contains 69other.stored_ammo.len69 rounds, and \the 69src6969ow contains 69stored_ammo.len69 rounds."))
		else
			to_chat(user, SPAN_WARNING("You fail to load anything into \the 69other69"))
	if(istype(W, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/gun_to_load = W
		if(istype(W, /obj/item/gun/projectile/revolver))
			to_chat(user, SPAN_WARNING("You can\'t reload 69W69 that way!"))
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
			to_chat(user, SPAN_NOTICE("It takes a bit of time for you to reload your 69W69 with 69src69 using only one hand!"))
			visible_message("69user69 tactically reloads 69W69 using only one hand!")

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
					if(!stack.mergeCasing(AC,69ull, user,69oIconUpdate = TRUE))
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
		if(stored_ammo.len >=69ax_ammo)
			to_chat(user, SPAN_WARNING("69src69 is full!"))
			return
		if(C.caliber != caliber)
			to_chat(user, SPAN_WARNING("69C69 does69ot fit into 69src69."))
			return
		if(stored_ammo.len)
			var/obj/item/ammo_casing/T = removeCasing()
			if(T)
				if(!C.mergeCasing(T,69ull, user))
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
	if(stored_ammo.len >=69ax_ammo)
		return FALSE
	if(C.amount > 1)
		C.amount -= 1

		var/obj/item/ammo_casing/inserted_casing =69ew /obj/item/ammo_casing(src)
		inserted_casing.name = C.name
		inserted_casing.desc = C.desc
		inserted_casing.caliber = C.caliber
		inserted_casing.projectile_type = C.projectile_type
		inserted_casing.icon_state = C.icon_state
		inserted_casing.spent_icon = C.spent_icon
		inserted_casing.maxamount = C.maxamount
		if(ispath(inserted_casing.projectile_type) && C.BB)
			inserted_casing.BB =69ew inserted_casing.projectile_type(inserted_casing)

		inserted_casing.sprite_max_rotate = C.sprite_max_rotate
		inserted_casing.sprite_scale = C.sprite_scale
		inserted_casing.sprite_use_small = C.sprite_use_small
		inserted_casing.sprite_update_spawn = C.sprite_update_spawn

		if(inserted_casing.sprite_update_spawn)
			var/matrix/rotation_matrix =69atrix()
			rotation_matrix.Turn(round(45 * rand(0, inserted_casing.sprite_max_rotate) / 2))
			if(inserted_casing.sprite_use_small)
				inserted_casing.transform = rotation_matrix * inserted_casing.sprite_scale
			else
				inserted_casing.transform = rotation_matrix

		inserted_casing.is_caseless = C.is_caseless
		inserted_casing.shell_color = C.shell_color

		C.update_icon()
		inserted_casing.update_icon()
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
		var/obj/item/ammo_casing/AC = stored_ammo69169
		stored_ammo -= AC
		if(!stored_ammo.len)
			stored_ammo.Cut()
		update_icon()
		return AC

/obj/item/ammo_magazine/resolve_attackby(atom/A,69ob/user)
	//Clicking on tile with69o collectible items will empty it, if it has the69erb to do that.
	if(isturf(A) && !A.density)
		dump_it(A)
		return TRUE
	return ..()

/obj/item/ammo_magazine/verb/69uick_empty()
	set69ame = "Empty Ammo Container"
	set category = "Object"
	set src in69iew(1)

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
		to_chat(usr, SPAN_NOTICE("69src69 is already empty!"))
		return
	to_chat(usr, SPAN_NOTICE("You take out ammo from 69src69."))
	for(var/i=1 to stored_ammo.len)
		var/obj/item/ammo_casing/C = removeCasing()
		C.forceMove(target)
		C.set_dir(pick(cardinal))
	update_icon()

/obj/item/ammo_magazine/proc/get_label(value)
	ammo_label =69ull
	if(!modular_sprites)
		return

	if(value)
		ammo_label =69alue
	else
		if(stored_ammo.len)
			var/obj/item/ammo_casing/AC = stored_ammo69stored_ammo.len69
			if(AC && AC.shell_color)
				ammo_label = AC.shell_color

	if(ammo_label)
		var/magazine_name = replacetext(initial(name), ")", " ")
		var/ammo_name = ammo_names69ammo_label69
		name = "69magazine_name6969ammo_name69)"
		ammo_label_string = "_69ammo_label69"
	else
		name = initial(name)
		ammo_label_string =69ull
	return

/obj/item/ammo_magazine/update_icon()
	// First inserted casing will define the look and the69ame of the69agazine
	// Ammo boxes keep their original color and69ame regardless of what ammo is inside
	//69o ammo inside -69o colored stripe on the69agazine
	var/ammo_count = 0
	if(stored_ammo.len && ammo_states)
		// So ammo count is69ot zero. Let's find closest69atching sprite
		for(var/i = 1; i <= ammo_states.len; i++)
			// E.g. if LMG69ag have 5 ammo, then pick "pk_box-25" since it's closest69on-empty state
			if(stored_ammo.len <= ammo_states69i69)
				ammo_count = ammo_states69i69
				break

	icon_state = "69initial(icon_state)6969ammo_label_string69-69ammo_count69"

/obj/item/ammo_magazine/examine(mob/user)
	..()
	to_chat(user, "There 69(stored_ammo.len == 1)? "is" : "are"69 69stored_ammo.len69 round\s left!")
