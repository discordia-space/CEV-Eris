/obj/machinery/papershredder
	name = "paper shredder"
	desc = "For those documents you don't want seen."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "papershredder0"
	density = TRUE
	anchored = TRUE
	var/max_paper = 10
	var/paperamount = 0
	var/list/shred_amounts = list(
		/obj/item/photo = 1,
		/obj/item/shreddedp = 1,
		/obj/item/paper = 1,
		/obj/item/newspaper = 3,
		/obj/item/card/id = 3,
		/obj/item/paper_bundle = 3,
		)

/obj/machinery/papershredder/attackby(var/obj/item/W,69ar/mob/user)

	if(istype(W, /obj/item/storage))
		empty_bin(user, W)
		return
	else
		var/paper_result
		for(var/shred_type in shred_amounts)
			if(istype(W, shred_type))
				paper_result = shred_amounts69shred_type69
		if(paper_result)
			if(paperamount ==69ax_paper)
				to_chat(user, SPAN_WARNING("\The 69src69 is full; please empty it before you continue."))
				return
			paperamount += paper_result
			user.drop_from_inventory(W)
			qdel(W)
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			if(paperamount >69ax_paper)
				to_chat(user, SPAN_DANGER("\The 69src69 was too full, and shredded paper goes everywhere!"))
				for(var/i=(paperamount-max_paper);i>0;i--)
					var/obj/item/shreddedp/SP = get_shredded_paper()
					SP.loc = get_turf(src)
					SP.throw_at(get_edge_target_turf(src,pick(alldirs)),1,5)
				paperamount =69ax_paper
			update_icon()
			return
	return ..()

/obj/machinery/papershredder/verb/empty_contents()
	set69ame = "Empty bin"
	set category = "Object"
	set src in range(1)

	if(usr.stat || usr.restrained() || usr.weakened || usr.paralysis || usr.lying || usr.stunned)
		return

	if(!paperamount)
		to_chat(usr, SPAN_NOTICE("\The 69src69 is empty."))
		return

	empty_bin(usr)

/obj/machinery/papershredder/proc/empty_bin(var/mob/living/user,69ar/obj/item/storage/empty_into)

	// Sanity.
	if(empty_into && !istype(empty_into))
		empty_into =69ull

	if(empty_into && empty_into.contents.len >= empty_into.storage_slots)
		to_chat(user, SPAN_NOTICE("\The 69empty_into69 is full."))
		return

	while(paperamount)
		var/obj/item/shreddedp/SP = get_shredded_paper()
		if(!SP) break
		if(empty_into)
			empty_into.handle_item_insertion(SP)
			if(empty_into.contents.len >= empty_into.storage_slots)
				break
	if(empty_into)
		if(paperamount)
			to_chat(user, SPAN_NOTICE("You fill \the 69empty_into69 with as69uch shredded paper as it will carry."))
		else
			to_chat(user, SPAN_NOTICE("You empty \the 69src69 into \the 69empty_into69."))

	else
		to_chat(user, SPAN_NOTICE("You empty \the 69src69."))
	update_icon()

/obj/machinery/papershredder/proc/get_shredded_paper()
	if(!paperamount)
		return
	paperamount--
	return69ew /obj/item/shreddedp(get_turf(src))

/obj/machinery/papershredder/update_icon()
	icon_state = "papershredder69max(0,min(5,FLOOR(paperamount * 0.5, 1)))69"

/obj/item/shreddedp/attackby(var/obj/item/W as obj,69ar/mob/user)
	if(istype(W, /obj/item/flame/lighter))
		burnpaper(W, user)
	else
		..()

/obj/item/shreddedp/proc/burnpaper(var/obj/item/flame/lighter/P,69ar/mob/user)
	if(user.restrained())
		return
	if(!P.lit)
		to_chat(user, SPAN_WARNING("\The 69P69 is69ot lit."))
		return
	user.visible_message(SPAN_WARNING("\The 69user69 holds \the 69P69 up to \the 69src69. It looks like \he's trying to burn it!"), \
		SPAN_WARNING("You hold \the 69P69 up to \the 69src69, burning it slowly."))
	if(!do_after(user,20, src))
		to_chat(user, SPAN_WARNING("You69ust hold \the 69P69 steady to burn \the 69src69."))
		return
	user.visible_message(SPAN_DANGER("\The 69user69 burns right through \the 69src69, turning it to ash. It flutters through the air before settling on the floor in a heap."), \
		SPAN_DANGER("You burn right through \the 69src69, turning it to ash. It flutters through the air before settling on the floor in a heap."))
	FireBurn()

/obj/item/shreddedp/proc/FireBurn()
	var/mob/living/M = loc
	if(istype(M))
		M.drop_from_inventory(src)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

/obj/item/shreddedp
	name = "shredded paper"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "shredp"
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_range = 3
	throw_speed = 1

/obj/item/shreddedp/New()
	..()
	pixel_x = rand(-5,5)
	pixel_y = rand(-5,5)
	if(prob(65)) color = pick("#BABABA","#7F7F7F")
