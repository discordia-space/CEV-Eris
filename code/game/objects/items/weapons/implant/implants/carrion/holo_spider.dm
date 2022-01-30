/obj/item/implant/carrion_spider/holographic
	name = "holographic spider"
	desc = "A spider with a peculiarly reflective surface"
	icon_state = "spiderling_breeding"
	spider_price = 5
	slot_flags = SLOT_ID | SLOT_BELT | SLOT_EARS | SLOT_HOLSTER | SLOT_BACK | SLOT_MASK | SLOT_GLOVES | SLOT_HEAD | SLOT_OCLOTHING | SLOT_ICLOTHING | SLOT_FEET | SLOT_EYES
	var/can_use = 1
	var/saved_name
	var/saved_description
	var/saved_item
	var/saved_icon
	var/saved_icon_state
	var/saved_overlays
	var/saved_dir
	var/saved_mob
	var/saved_alpha
	var/saved_opacity
	var/saved_message
	var/saved_appearance
	var/saved_item_state
	var/saved_w_class
	var/spider_appearance
	var/dummy_active = FALSE
	var/scan_mobs = TRUE

/obj/item/implant/carrion_spider/holographic/activate()
	..()
	toggle()

/obj/item/implant/carrion_spider/holographic/attack_self(mob/user)
	if(!is_carrion(user))
		toggle()
	..()


/obj/item/implant/carrion_spider/holographic/examine(mob/user)
	if(dummy_active && saved_item && saved_message)
		to_chat(user, saved_message)
	else if(dummy_active && saved_item && saved_w_class)
		to_chat(world, "ISANITEM")
		var/distance = -1
		var/message
		var/size
		switch(saved_w_class)
			if(ITEM_SIZE_TINY)
				size = "tiny"
			if(ITEM_SIZE_SMALL)
				size = "small"
				to_chat(world, "issmall")
			if(ITEM_SIZE_NORMAL)
				size = "normal-sized"
			if(ITEM_SIZE_BULKY)
				size = "bulky"
			if(ITEM_SIZE_HUGE)
				size = "huge"
			if(ITEM_SIZE_GARGANTUAN)
				size = "gargantuan"
			if(ITEM_SIZE_COLOSSAL)
				size = "colossal"
			if(ITEM_SIZE_TITANIC)
				size = "titanic"
		message += "\nIt is a [size] item."

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.stats.getPerk(PERK_MARKET_PROF))
				message += SPAN_NOTICE("\nThis item cost: [get_item_cost()][CREDITS]")

		return ..(user, distance, "", message)
			. = ..()
/obj/item/implant/carrion_spider/holographic/toggle_attack(mob/user)
	if(ready_to_attack)
		ready_to_attack = FALSE
		to_chat(user, SPAN_NOTICE("\The [src] wont attack nearby creatures anymore and can be used to scan creatures without attaching itself to them."))
		scan_mobs = TRUE
	else
		ready_to_attack = TRUE
		to_chat(user, SPAN_NOTICE("\The [src] is ready to attack nearby creatures or to be attached manually"))
		scan_mobs = FALSE

/obj/item/implant/carrion_spider/holographic/attack(mob/living/M, mob/living/user)
	if(scan_mobs)
		return
	else
		..()

/obj/item/implant/carrion_spider/holographic/afterattack(atom/target, mob/user, proximity)
	if(istype(target, /obj/item/storage)) return
	if(!proximity) return
	if(dummy_active) return
	reset_data()
	playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
	to_chat(user, SPAN_NOTICE("Scanned [target]."))
	saved_name = target.name
	saved_item = target.type
	saved_icon = target.icon
	saved_icon_state = target.icon_state
	saved_overlays = target.overlays
	saved_description = target.desc
	saved_dir = target.dir
	saved_alpha = target.alpha
	saved_opacity = target.opacity
	saved_appearance = target.appearance
	spider_appearance = src.appearance
	if(istype(target, /obj))	
		var/obj/O = new saved_item(src)
		saved_item_state = O.item_state
		saved_w_class = O.w_class
		qdel(O)
	if(istype(target, /mob))
		saved_mob = target // help
		saved_message = target.examine(user)
	return

/obj/item/implant/carrion_spider/holographic/proc/reset_data()
	saved_name = initial(saved_name)
	saved_item = initial(saved_item)
	saved_icon = initial(saved_icon)
	saved_icon_state = initial(saved_icon_state)
	saved_overlays = initial(saved_overlays)
	saved_description = initial(saved_description)
	saved_dir = initial(saved_dir)
	saved_mob = initial(saved_mob)
	saved_alpha = initial(saved_alpha)
	saved_opacity = initial(saved_opacity)
	saved_message = initial(saved_message)
	saved_appearance = initial(appearance)
	saved_item_state = initial(item_state)
	saved_w_class = initial(saved_w_class)


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
		overlays = initial(overlays)
		alpha = initial(alpha)
		opacity = initial(opacity)
		item_state = initial(item_state)
		set_dir(initial(dir))
		update_icon()
		to_chat(owner_mob, SPAN_NOTICE("You deactivate the [src]."))
	else
		if(!saved_item)
			to_chat(owner_mob, SPAN_NOTICE("The [src] does not have anything scanned."))
			return
		else
			activate_holo(saved_name, saved_icon, saved_icon_state, saved_overlays, saved_description, saved_dir, saved_alpha, saved_opacity, saved_appearance, saved_item_state)		
			to_chat(owner_mob, SPAN_NOTICE("You activate the [src]."))

/obj/item/implant/carrion_spider/holographic/proc/activate_holo(new_name, new_icon, new_iconstate, new_overlays, new_description, new_dir, new_alpha, new_opacity, new_appearance, new_item_state)
	name = new_name
	desc = new_description
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	alpha = new_alpha
	opacity = new_opacity
	appearance = new_appearance
	item_state = new_item_state
	set_dir(new_dir)
	dummy_active = TRUE


/obj/item/implant/carrion_spider/holographic/proc/disrupt()
	if(dummy_active)
		toggle()
		can_use = 0
		spawn(5 SECONDS) 
			can_use = 1

/obj/item/implant/carrion_spider/holographic/attackby()
	..()
	disrupt()

/obj/item/implant/carrion_spider/holographic/ex_act()
	..()
	disrupt()

/obj/item/implant/carrion_spider/holographic/bullet_act()
	..()
	disrupt()
