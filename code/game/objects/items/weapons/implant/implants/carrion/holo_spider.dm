/obj/item/implant/carrion_spider/holographic
	name = "holographic spider"
	desc = "A spider with a peculiarly reflective surface"
	icon_state = "spiderling_holographic"
	slot_flags = SLOT_ID | SLOT_BELT | SLOT_EARS | SLOT_HOLSTER | SLOT_BACK | SLOT_MASK | SLOT_GLOVES | SLOT_HEAD | SLOT_OCLOTHING | SLOT_ICLOTHING | SLOT_FEET | SLOT_EYES
	spider_price = 5
	var/can_use = TRUE
	var/saved_name
	var/saved_description
	var/saved_item
	var/saved_type
	var/saved_icon
	var/saved_icon_state
	var/saved_layer
	var/saved_original_plane
	var/saved_dir
	var/saved_message
	var/saved_appearance
	var/saved_item_state
	var/saved_volumeClass
	var/spider_appearance
	var/saved_gender

	var/dummy_active = FALSE
	var/scan_mobs = TRUE


/obj/item/implant/carrion_spider/holographic/activate()
	..()
	toggle()

/obj/item/implant/carrion_spider/holographic/toggle_attack(mob/user)
	if(ready_to_attack)
		ready_to_attack = FALSE
		to_chat(user, SPAN_NOTICE("\The [src] wont attack nearby creatures anymore and can be used to scan creatures without attaching itself to them."))
		scan_mobs = TRUE
	else
		ready_to_attack = TRUE
		to_chat(user, SPAN_NOTICE("\The [src] is ready to attack nearby creatures or to be attached manually."))
		scan_mobs = FALSE

/obj/item/implant/carrion_spider/holographic/attack(mob/living/M, mob/living/user)
	if(!scan_mobs)
		..()

/obj/item/implant/carrion_spider/holographic/afterattack(atom/target, mob/user, proximity)
	if(istype(target, /obj/item/storage))
		return
	if(!proximity || dummy_active || !scan_mobs)
		return
	reset_data()
	playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
	to_chat(user, SPAN_NOTICE("Scanned [target]."))
	saved_name = target.name
	saved_item = target
	saved_type = target.type
	saved_icon = target.icon
	saved_icon_state = target.icon_state
	saved_description = target.desc
	saved_dir = target.dir
	saved_appearance = target.appearance
	saved_gender = target.gender
	spider_appearance = src.appearance
	saved_layer = target.layer
	saved_original_plane = target.original_plane
	if(isobj(target))
		var/obj/O = target
		saved_item_state = O.item_state
		saved_volumeClass = O.volumeClass
	if(ismob(target))
		saved_message = target.examine(user)
	return

/obj/item/implant/carrion_spider/holographic/proc/toggle()
	if(!can_use || !saved_item)
		return
	if(dummy_active)
		dummy_active = FALSE
		appearance = spider_appearance
		name = initial(name)
		desc = initial(desc)
		icon = initial(icon)
		icon_state = initial(icon_state)
		if(is_equipped(src))
			layer = ABOVE_HUD_LAYER
			plane = ABOVE_HUD_PLANE
		else
			layer = initial(layer)
			plane = calculate_plane(z, original_plane)
		item_state = initial(item_state)
		set_dir(initial(dir))
		update_icon()
		to_chat(owner_mob, SPAN_NOTICE("You deactivate the [src]."))
	else
		if(!saved_item)
			to_chat(owner_mob, SPAN_NOTICE("The [src] does not have anything scanned."))
			return
		else
			activate_holo(saved_name, saved_icon, saved_icon_state, saved_description, saved_dir, saved_appearance, saved_item_state)
			to_chat(owner_mob, SPAN_NOTICE("You activate the [src]."))

/obj/item/implant/carrion_spider/holographic/proc/activate_holo(new_name, new_icon, new_iconstate, new_description, new_dir, new_appearance, new_item_state)
	name = new_name
	desc = new_description
	icon = new_icon
	icon_state = new_iconstate
	item_state = new_item_state
	appearance = new_appearance
	set_dir(new_dir)
	if(is_equipped(src))
		plane = ABOVE_HUD_PLANE
		layer = ABOVE_HUD_LAYER
	else
		plane = calculate_plane(z, saved_original_plane)
		layer = saved_layer
	dummy_active = TRUE

/obj/item/implant/carrion_spider/holographic/proc/reset_data()
	saved_name = initial(saved_name)
	saved_item = initial(saved_item)
	saved_type = initial(saved_type)
	saved_icon = initial(saved_icon)
	saved_icon_state = initial(saved_icon_state)
	saved_description = initial(saved_description)
	saved_dir = initial(saved_dir)
	saved_message = initial(saved_message)
	saved_appearance = initial(appearance)
	saved_item_state = initial(item_state)
	saved_volumeClass = initial(saved_volumeClass)
	saved_gender = initial(saved_gender)
	saved_layer = initial(saved_layer)
	saved_original_plane = initial(saved_original_plane)

/obj/item/implant/carrion_spider/holographic/dropped(mob/living/W)
	if(dummy_active)
		layer = saved_layer
		plane = calculate_plane(z, saved_original_plane)
	else
		layer = initial(layer)
		plane = calculate_plane(z, original_plane)
	..()


/obj/item/implant/carrion_spider/holographic/examine(mob/user, var/distance = -1)
	if(dummy_active && saved_item)
		var/atom/thing = new saved_type(NULLSPACE)
		thing.examine(user, 1, "", "")
		qdel(thing)
	else
		. = ..()

/obj/item/implant/carrion_spider/holographic/attack_self(mob/user)
	if(!is_carrion(user))
		toggle()
	..()

/obj/item/implant/carrion_spider/holographic/proc/disrupt()
	if(dummy_active)
		toggle()
		can_use = 0
		spawn(5 SECONDS)
			can_use = 1

/obj/item/implant/carrion_spider/holographic/attackby()
	..()
	disrupt()

/obj/item/implant/carrion_spider/holographic/explosion_act(target_power, explosion_handler/handler)
	. = ..()
	if(QDELETED(src))
		return
	disrupt()

/obj/item/implant/carrion_spider/holographic/bullet_act()
	..()
	disrupt()
