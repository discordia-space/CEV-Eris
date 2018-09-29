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
	var/projectile_type					//The bullet type to create when New() is called
	var/obj/item/projectile/BB = null	//The loaded bullet - make it so that the projectiles are created only when needed?
	var/spent_icon = null
	var/amount = 1
	var/maxamount = 15

/obj/item/ammo_casing/New()
	..()
	if(ispath(projectile_type))
		BB = new projectile_type(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = BB
	BB = null
	set_dir(pick(cardinal)) //spin spent casings
	update_icon()

/obj/item/ammo_casing/attack_hand(mob/user)
	if((src.amount > 1) && (src == user.get_inactive_hand()))
		src.amount -= 1
		var/obj/item/ammo_casing/new_casing = new /obj/item/ammo_casing(get_turf(user))
		new_casing.desc = src.desc
		new_casing.caliber = src.caliber
		new_casing.projectile_type = src.projectile_type
		new_casing.icon_state = src.icon_state
		new_casing.spent_icon = src.spent_icon
		new_casing.maxamount = src.maxamount
		if(ispath(new_casing.projectile_type) && src.BB)
			new_casing.BB = new new_casing.projectile_type(new_casing)
		else
			new_casing.BB = null
		new_casing.update_icon()
		src.update_icon()
		user.put_in_active_hand(new_casing)
	else
		return ..()

/obj/item/ammo_casing/attackby(obj/item/I, mob/user)
	if(I.get_tool_type(usr, list(QUALITY_SCREW_DRIVING, QUALITY_CUTTING)))
		if(!BB)
			user << "\blue There is no bullet in the casing to inscribe anything into."
			return

		var/tmp_label = ""
		var/label_text = sanitizeSafe(input(user, "Inscribe some text into \the [initial(BB.name)]","Inscription",tmp_label), MAX_NAME_LEN)
		if(length(label_text) > 20)
			user << "\red The inscription can be at most 20 characters long."
		else if(!label_text)
			user << "\blue You scratch the inscription off of [initial(BB)]."
			BB.name = initial(BB.name)
		else
			user << "\blue You inscribe \"[label_text]\" into \the [initial(BB.name)]."
			BB.name = "[initial(BB.name)] (\"[label_text]\")"
	else if(istype(I, /obj/item/ammo_casing) && (src.amount != src.maxamount) && (src.desc == I.desc))
		var/obj/item/ammo_casing/merged_casing = I
		if((!src.BB && !merged_casing.BB) || (src.BB && merged_casing.BB))
			if(merged_casing.amount > 1)
				src.amount += 1
				merged_casing.amount -= 1
				merged_casing.update_icon()
			else
				src.amount += 1
				QDEL_NULL(merged_casing)
			src.update_icon()


/obj/item/ammo_casing/update_icon()
	if(spent_icon && !BB)
		icon_state = spent_icon
	src.overlays.Cut()
	if(amount > 1)
		src.pixel_x = 0
		src.pixel_y = 0
	var/icon_amount
	for(icon_amount = 1; icon_amount < src.amount, icon_amount++)
		var/image/temp_image = image(src.icon, src.icon_state)
		temp_image.pixel_x = (-1) ** round(icon_amount/2) * round(11 * icon_amount/src.maxamount) + pick(-1, 0, 1)
		temp_image.pixel_y = (-1) ** round((icon_amount + 1)/2) * round(11 * icon_amount/src.maxamount) + pick(-1, 0, 1)
		var/matrix/temp_image_matrix = matrix()
		temp_image_matrix.Turn(round(45 * rand(0, 16) / 2))
		temp_image.transform = temp_image_matrix
		src.overlays += temp_image

/obj/item/ammo_casing/examine(mob/user)
	..()
	user << "There [(amount == 1)? "is" : "are"] [amount] round\s left!"
	if (!BB)
		user << "[(amount == 1)? "This one is" : "These ones are"] spent."

//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun

//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "place-holder-box"
	icon = 'icons/obj/ammo.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(MATERIAL_STEEL = 2)
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is not a bitflag, the load_method var on guns is.
	var/caliber = "357"
	var/ammo_mag = "default"
	var/max_ammo = 7
	var/reload_delay = 0 //when we need to make reload slower

	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo = null

	var/multiple_sprites = 0
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values

/obj/item/ammo_magazine/New()
	..()
	if(multiple_sprites)
		initialize_magazine_icondata(src)

	if(isnull(initial_ammo))
		initial_ammo = max_ammo

	if(initial_ammo)
		for(var/i in 1 to initial_ammo)
			stored_ammo += new ammo_type(src)
	update_icon()

/obj/item/ammo_magazine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(C.caliber != caliber)
			user << SPAN_WARNING("[C] does not fit into [src].")
			return
		if(stored_ammo.len >= max_ammo)
			user << SPAN_WARNING("[src] is full!")
			return
		if(C.amount > 1)
			C.amount -= 1
			var/obj/item/ammo_casing/inserted_casing = new /obj/item/ammo_casing(src)
			inserted_casing.desc = C.desc
			inserted_casing.caliber = C.caliber
			inserted_casing.projectile_type = C.projectile_type
			inserted_casing.icon_state = C.icon_state
			inserted_casing.spent_icon = C.spent_icon
			inserted_casing.maxamount = C.maxamount
			if(ispath(inserted_casing.projectile_type) && C.BB)
				inserted_casing.BB = new inserted_casing.projectile_type(inserted_casing)
			C.update_icon()
			inserted_casing.update_icon()
			stored_ammo.Insert(1, inserted_casing)
		else
			user.drop_from_inventory(C, src)
			stored_ammo.Insert(1, C) //add to the head of the list
		update_icon()
	else if(istype(W, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/other = W
		if(!src.stored_ammo.len)
			user << SPAN_WARNING("There is no ammo in [src]!")
			return
		if(!do_after(user, src.reload_delay, src))
			user << SPAN_WARNING("You stop loading ammo into [other]")
			return
		for(var/obj/item/ammo in src.stored_ammo)
			other.attackby(ammo, user)
			if(ammo in other.stored_ammo)
				src.stored_ammo -= ammo
			else
				return
		user << SPAN_NOTICE("You're done here")

/obj/item/ammo_magazine/attack_hand(mob/living/user)
	if(user.get_inactive_hand() == src && stored_ammo.len)
		var/obj/item/ammo_casing/AC = stored_ammo[1]
		if(user.put_in_active_hand(AC))
			stored_ammo -= AC
		update_icon()
	else
		return ..()

/obj/item/ammo_magazine/attack_self(mob/user)
	if(!stored_ammo.len)
		user << SPAN_NOTICE("[src] is already empty!")
		return
	user << SPAN_NOTICE("You take ammo from [src].")
	for(var/obj/item/ammo_casing/C in stored_ammo)
		C.loc = user.loc
		C.set_dir(pick(cardinal))
	stored_ammo.Cut()
	update_icon()

/obj/item/ammo_magazine/update_icon()
	if(multiple_sprites)
		//find the lowest key greater than or equal to stored_ammo.len
		var/new_state = null
		for(var/idx in 1 to icon_keys.len)
			var/ammo_count = icon_keys[idx]
			if (ammo_count >= stored_ammo.len)
				new_state = ammo_states[idx]
				break
		icon_state = (new_state)? new_state : initial(icon_state)

/obj/item/ammo_magazine/examine(mob/user)
	..()
	user << "There [(stored_ammo.len == 1)? "is" : "are"] [stored_ammo.len] round\s left!"

//magazine icon state caching
/var/global/list/magazine_icondata_keys = list()
/var/global/list/magazine_icondata_states = list()

/proc/initialize_magazine_icondata(var/obj/item/ammo_magazine/M)
	var/typestr = "[M.type]"
	if(!(typestr in magazine_icondata_keys) || !(typestr in magazine_icondata_states))
		magazine_icondata_cache_add(M)

	M.icon_keys = magazine_icondata_keys[typestr]
	M.ammo_states = magazine_icondata_states[typestr]

/proc/magazine_icondata_cache_add(var/obj/item/ammo_magazine/M)
	var/list/icon_keys = list()
	var/list/ammo_states = list()
	var/list/states = icon_states(M.icon)
	for(var/i = 0, i <= M.max_ammo, i++)
		var/ammo_state = "[M.icon_state]-[i]"
		if(ammo_state in states)
			icon_keys += i
			ammo_states += ammo_state

	magazine_icondata_keys["[M.type]"] = icon_keys
	magazine_icondata_states["[M.type]"] = ammo_states
