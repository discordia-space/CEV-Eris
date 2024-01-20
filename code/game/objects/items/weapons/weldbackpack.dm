/obj/item/weldpack
	name = "welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack"
	volumeClass = ITEM_SIZE_BULKY
	var/max_fuel = 350


/obj/item/weldpack/canister
	name = "canister"
	desc = "You may need it for draging around additional fuel."
	slot_flags = null
	icon_state = "canister"
	volumeClass = ITEM_SIZE_NORMAL
	max_fuel = 100
	rarity_value = 25
	spawn_tags = SPAWN_TAG_ITEM_UTILITY

/obj/item/weldpack/Initialize(mapload)
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)
	. = ..()

/obj/item/weldpack/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, SPAN_NOTICE("You crack the cap off the top of the pack and fill it back up again from the tank."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, SPAN_WARNING("The pack is already full!"))
		return

/obj/item/weldpack/examine(mob/user)
	..(user, afterDesc ="\icon[src] [reagents.total_volume] units of fuel left!")

/obj/item/weldpack/proc/explode()
	explosion(get_turf(src), reagents.total_volume/2, 50)
	qdel(src)
