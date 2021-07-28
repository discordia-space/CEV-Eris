/obj/item/weapon/implant/carrion_spider/holographic
	name = "holographic spider"
	icon_state = "spiderling_breeding"
	spider_price = 5
	var/can_use = 1
	var/saved_item
	var/saved_icon
	var/saved_icon_state
	var/saved_overlays
	var/dummy_active = FALSE
	var/scan_mobs = FALSE
	var/nosize = FALSE

/obj/item/weapon/implant/carrion_spider/holographic/activate()
	..()
	toggle()

/obj/item/weapon/implant/carrion_spider/holographic/attack_self(mob/user)
	if(!is_carrion(user))
		toggle()
	..()


/obj/item/weapon/implant/carrion_spider/holographic/toggle_attack(mob/user)
	if (ready_to_attack)
		ready_to_attack = FALSE
		to_chat(user, SPAN_NOTICE("\The [src] wont attack nearby creatures anymore."))
		scan_mobs = FALSE
	else if(scan_mobs)
		ready_to_attack = TRUE
		to_chat(user, SPAN_NOTICE("\The [src] is ready to attack nearby creatures."))
		scan_mobs = FALSE
	else 
		to_chat(user, SPAN_NOTICE("\The [src] can now be used to scan creatures without attaching itself to them."))
		scan_mobs = TRUE

/obj/item/weapon/implant/carrion_spider/holographic/attack(mob/living/M, mob/living/user)
	if(scan_mobs)
		return
	else
		..()

/obj/item/weapon/implant/carrion_spider/holographic/afterattack(atom/target, mob/user , proximity)
	if(istype(target, /obj/item/weapon/storage)) return
	if(!proximity) return
	if(!dummy_active)
		if(scan_item(target))
			playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
			to_chat(user, SPAN_NOTICE("Scanned [target]."))
			saved_item = target.type
			saved_icon = target.icon
			saved_icon_state = target.icon_state
			saved_overlays = target.overlays
			return
		to_chat(user, SPAN_WARNING("\The [target] is an invalid target."))


/obj/item/weapon/implant/carrion_spider/holographic/proc/scan_item(atom/I)
	if(istype(I, /turf))
		return FALSE
	return TRUE

/obj/item/weapon/implant/carrion_spider/holographic/proc/toggle()
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
		nosize = FALSE
	else
		var/obj/O = new saved_item(src)
		if(!O) return
		activate_holo(O, saved_icon, saved_icon_state, saved_overlays)
		if(istype(O, /obj/structure) || istype(O, /mob))
			nosize = TRUE
		qdel(O)
		to_chat(owner_mob, SPAN_NOTICE("You activate the [src]."))


/obj/item/weapon/implant/carrion_spider/holographic/proc/disrupt(var/delete_dummy = 1)
	if(dummy_active)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
		toggle()
		can_use = 0
		spawn(5) can_use = 1

/obj/item/weapon/implant/carrion_spider/holographic/proc/activate_holo(var/obj/O, new_icon, new_iconstate, new_overlays)
	name = O.name
	desc = O.desc
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	set_dir(O.dir)
	dummy_active = TRUE

/obj/item/weapon/implant/carrion_spider/holographic/attackby()
	..()
	disrupt()

/obj/item/weapon/implant/carrion_spider/holographic/ex_act()
	..()
	disrupt()

/obj/item/weapon/implant/carrion_spider/holographic/bullet_act()
	..()
	disrupt()

/obj/item/weapon/implant/carrion_spider/holographic/examine(user, distance = -1)
	var/message
	var/size
	switch(w_class)
		if(ITEM_SIZE_TINY)
			size = "tiny"
		if(ITEM_SIZE_SMALL)
			size = "small"
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
			
	if(nosize)
		message += "\nIt is a [size] item."

	for(var/Q in tool_qualities)
		message += "\n<blue>It possesses [tool_qualities[Q]] tier of [Q] quality.<blue>"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.stats.getPerk(PERK_MARKET_PROF))
			message += SPAN_NOTICE("\nThis item cost: [get_item_cost()][CREDITS]")

	return ..(user, distance, "", message)
