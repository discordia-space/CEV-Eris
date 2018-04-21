var/list/holder_mob_icon_cache = list()

//Helper object for picking dionaea (and other creatures) up.
/obj/item/weapon/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	slot_flags = SLOT_HEAD | SLOT_HOLSTER

	origin_tech = null
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_holder.dmi',
		)
	pixel_y = 8

	var/last_holder

/obj/item/weapon/holder/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/holder/Destroy()
	last_holder = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/holder/Process()
	update_state()

/obj/item/weapon/holder/dropped()
	..()
	spawn(1)
		update_state()

/obj/item/weapon/holder/proc/update_state()
	if(last_holder != loc)
		for(var/mob/M in contents)
			unregister_all_movement(last_holder, M)

	if(istype(loc,/turf) || !(contents.len))
		for(var/mob/M in contents)
			var/atom/movable/mob_container = M
			mob_container.forceMove(loc, MOVED_DROP)
			M.reset_view()
		qdel(src)
	else if(last_holder != loc)
		for(var/mob/M in contents)
			register_all_movement(loc, M)

	last_holder = loc

/obj/item/weapon/holder/GetID()
	for(var/mob/M in contents)
		var/obj/item/I = M.GetIdCard()
		if(I)
			return I
	return null

/obj/item/weapon/holder/GetAccess()
	var/obj/item/I = GetID()
	return I ? I.GetAccess() : ..()

/obj/item/weapon/holder/attack_self()
	for(var/mob/M in contents)
		M.show_inv(usr)

/obj/item/weapon/holder/proc/sync(var/mob/living/M)
	dir = 2
	overlays.Cut()
	icon = M.icon
	icon_state = M.icon_state
	item_state = M.item_state
	color = M.color
	name = M.name
	desc = M.desc
	overlays |= M.overlays
	var/mob/living/carbon/human/H = loc
	last_holder = H
	register_all_movement(H, M)

	if(istype(H))
		if(H.l_hand == src)
			H.update_inv_l_hand()
		else if(H.r_hand == src)
			H.update_inv_r_hand()
		else
			H.regenerate_icons()

/obj/item/weapon/holder/drone
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 5)

/obj/item/weapon/holder/mouse
	w_class = ITEM_SIZE_TINY

/obj/item/weapon/holder/borer
	origin_tech = list(TECH_BIO = 6)

/obj/item/weapon/holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(var/mob/living/carbon/grabber, var/self_grab)

	if(!holder_type || buckled || pinned.len)
		return

	var/obj/item/weapon/holder/H = new holder_type(get_turf(src))
	src.forceMove(H)
	grabber.put_in_hands(H)

	if(self_grab)
		grabber << SPAN_NOTICE("\The [src] clambers onto you!")
		src << SPAN_NOTICE("You climb up onto \the [grabber]!")
		grabber.equip_to_slot_if_possible(H, slot_back, 0, 1)
	else
		grabber << SPAN_NOTICE("You scoop up \the [src]!")
		src << SPAN_NOTICE("\The [grabber] scoops you up!")

	grabber.status_flags |= PASSEMOTES
	H.sync(src)
	return H

/obj/item/weapon/holder/human
	icon = 'icons/mob/holder_complex.dmi'
	var/list/generate_for_slots = list(slot_l_hand_str, slot_r_hand_str, slot_back_str)
	slot_flags = SLOT_BACK

/obj/item/weapon/holder/human/sync(var/mob/living/M)
	// Generate appropriate on-mob icons.
	var/mob/living/carbon/human/owner = M
	if(istype(owner) && owner.species)

		var/skin_color = owner.skin_color
		var/hair_color = owner.hair_color
		var/eyes_color =  owner.eyes_color
		var/species_name = lowertext(owner.species.get_bodytype())

		for(var/cache_entry in generate_for_slots)
			var/cache_key = "[owner.species]-[cache_entry]-[skin_color]-[hair_color]"
			if(!holder_mob_icon_cache[cache_key])

				// Generate individual icons.
				var/icon/mob_icon = icon(icon, "[species_name]_holder_[cache_entry]_base")
				mob_icon.Blend(skin_color, ICON_ADD)
				var/icon/hair_icon = icon(icon, "[species_name]_holder_[cache_entry]_hair")
				hair_icon.Blend(hair_color, ICON_ADD)
				var/icon/eyes_icon = icon(icon, "[species_name]_holder_[cache_entry]_eyes")
				eyes_icon.Blend(eyes_color, ICON_ADD)

				// Blend them together.
				mob_icon.Blend(eyes_icon, ICON_OVERLAY)
				mob_icon.Blend(hair_icon, ICON_OVERLAY)

				// Add to the cache.
				holder_mob_icon_cache[cache_key] = mob_icon
			item_icons[cache_entry] = holder_mob_icon_cache[cache_key]

	// Handle the rest of sync().
	..(M)
