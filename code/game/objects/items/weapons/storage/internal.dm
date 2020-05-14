//A storage item intended to be used by other items to provide storage functionality.
//Types that use this should consider overriding emp_act() and hear_talk(), unless they shield their contents somehow.
/obj/item/weapon/storage/internal
	var/obj/item/master_item

/obj/item/weapon/storage/internal/New(obj/item/MI)
	master_item = MI
	loc = master_item
	name = master_item.name
	verbs -= /obj/item/verb/verb_pickup	//make sure this is never picked up.
	..()

/obj/item/weapon/storage/internal/Destroy()
	master_item = null
	. = ..()

/obj/item/weapon/storage/internal/attack_hand()
	return		//make sure this is never picked up

/obj/item/weapon/storage/internal/can_be_equipped()
	return 0	//make sure this is never picked up

//Helper procs to cleanly implement internal storages - storage items that provide inventory slots for other items.
//These procs are completely optional, it is up to the master item to decide when it's storage get's opened by calling open()
//However they are helpful for allowing the master item to pretend it is a storage item itself.
//If you are using these you will probably want to override attackby() as well.
//See /obj/item/clothing/suit/storage for an example.

//items that use internal storage have the option of calling this to emulate default storage MouseDrop behaviour.
//returns TRUE if the master item's parent's MouseDrop() shouldn't be called, FALSE otherwise.
/obj/item/weapon/storage/internal/proc/handle_mousedrop(mob/living/carbon/human/user, obj/over_object)

	if (istype(user))
		if (user.incapacitated())
			return FALSE

		if(over_object == user && Adjacent(user))
			src.open(user)
			return TRUE

//items that use internal storage have the option of calling this to emulate default storage attack_hand behaviour.
//returns 1 if the master item's parent's attack_hand() should be called, 0 otherwise.
//It's strange, but no other way of doing it without the ability to call another proc's parent, really.
/obj/item/weapon/storage/internal/proc/handle_attack_hand(mob/user as mob)
	if (openable_location(user))
		src.open(user)
		return 0

	close_all()
	return 1

/obj/item/weapon/storage/internal/Adjacent(var/atom/neighbor)
	return master_item.Adjacent(neighbor)

//Returns true if the thing is in a suitable location
//If its worn and not in a pocket, its suitable
//If its on a turf next to the user, its also suitable
/obj/item/weapon/storage/internal/proc/openable_location(var/mob/user)
	.=FALSE
	if (master_item.loc == user)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.l_store == master_item)	//Prevents opening if it's in a pocket.
				return
			if(H.r_store == master_item)
				return
		return TRUE
	else if (isturf(master_item.loc) && Adjacent(user))
		return TRUE

/obj/item/weapon/storage/internal/updating/update_icon()
	if(master_item)
		master_item.update_icon()

/obj/item/weapon/melee/needle
	name = "needle and thread"
	desc = "used to sow shut things, wonder what you could use it on"
	icon = "icons/obj/items.dmi"
	icon_state = "coin_string_overlay"
/obj/item/weapon/teddy
	name = "teddy bear"
	desc = "Here to provide help at anytime"
	icon = 'icons/obj/oddities.dmi'
	icon_state = "teddy"
	var/max_w_class = ITEM_SIZE_SMALL
	var/max_storage_space = 5
	var/open = FALSE
	var/icon_open = "old_knife"
	var/icon_closed = "teddy"
	var/key = /obj/item/weapon/melee/needle
	var/obj/item/weapon/storage/internal/container

/obj/item/weapon/teddy/New()
	container = new /obj/item/weapon/storage/internal(src)
	container.max_w_class = max_w_class
	container.max_storage_space = max_storage_space

/obj/item/weapon/teddy/Destroy()
	qdel(container)
	container = null
	. = ..()

/obj/item/weapon/teddy/attack_hand(mob/user as mob)
	if(open)
		if (is_held() && !container.handle_attack_hand())
			return TRUE
	..(user)

/obj/item/weapon/teddy/MouseDrop(obj/over_object)
	if(container.handle_mousedrop(usr, over_object))
		return TRUE
	..(over_object)

/obj/item/weapon/teddy/attackby(obj/item/W, mob/user)
	if(!open)
		if((QUALITY_CUTTING in W.tool_qualities))
			to_chat(user,SPAN_NOTICE("You cut open the teddy bear"))
			icon_state = icon_open
			open = TRUE
			update_icon()
			return FALSE
		else
			return FALSE
	if(open && istype(W, key))
		open = FALSE
		to_chat(user,SPAN_NOTICE("You sew the teddy shut"))
		container.close_all()
		icon_state = icon_closed
		update_icon()
		return FALSE
	container.attackby(W, user)
	..()

/obj/item/weapon/teddy/attack_self(mob/user)
	if(!open)
		return FALSE
	..()

/obj/item/weapon/teddy/emp_act(severity)
	container.emp_act(severity)
	..()