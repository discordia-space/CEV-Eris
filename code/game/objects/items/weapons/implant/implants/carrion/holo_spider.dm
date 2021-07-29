/obj/item/implant/carrion_spider/holographic
	name = "holographic spider"
	desc = "A spider with a peculiarly reflective surface"
	icon_state = "spiderling_breeding"
	spider_price = 5
	gibs_color = "#1e9fa3"
	var/can_use = 1
	var/saved_name
	var/saved_description
	var/saved_item
	var/saved_icon
	var/saved_icon_state
	var/saved_overlays
	var/saved_dir
	var/saved_mob
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
	if(dummy_active)
		if(saved_mob)
			to_chat(world, "GHHJGGHJ")
			saved_mob.examine(user)
		else if(saved_item)
			saved_item.examine(user)
		//for(var/mob/living/L in src)
			//L.examine(user)
	else
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

/obj/item/implant/carrion_spider/holographic/afterattack(atom/target, mob/user , proximity)
	if(istype(target, /obj/item/storage)) return
	if(!proximity) return
	if(dummy_active) return
	if(istype(target, /turf))
		to_chat(user, SPAN_WARNING("\The [target] is an invalid target."))
		return
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
	if(istype(target, /mob))
		saved_mob = target // help
	else
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

/obj/item/implant/carrion_spider/holographic/proc/scan_eligible(atom/I)
	if(scan_mobs && !istype(I, /turf))
		return TRUE
	return FALSE

/obj/item/implant/carrion_spider/holographic/proc/toggle()
	if(!can_use || !saved_item) return
	if(dummy_active)
		dummy_active = FALSE
		to_chat(owner_mob, SPAN_NOTICE("You deactivate the [src]."))
		name = initial(name)
		desc = initial(desc)
		icon = initial(icon)
		icon_state = initial(icon_state)
		overlays = initial(overlays)
		set_dir(initial(dir))
	else
		var/obj/O = new saved_item(src)
		if(!O) 
			to_chat(owner_mob, SPAN_NOTICE("The [src] does not have anything scanned."))
			return
		else
			activate_holo(O, saved_name, saved_icon, saved_icon_state, saved_overlays, saved_description, saved_dir)		
			to_chat(owner_mob, SPAN_NOTICE("You activate the [src]."))
			qdel(O)

/obj/item/implant/carrion_spider/holographic/proc/activate_holo(var/obj/O, new_name, new_icon, new_iconstate, new_overlays, new_description, new_dir)
	name = new_name
	desc = new_description
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	set_dir(new_dir)
	dummy_active = TRUE


/obj/item/implant/carrion_spider/holographic/proc/disrupt()
	if(dummy_active)
		toggle()
		can_use = 0
		spawn(5) 
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

