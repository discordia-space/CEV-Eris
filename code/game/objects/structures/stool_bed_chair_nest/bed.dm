/* Beds... get your69ind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = 1
	var/material/material
	var/material/padding_material
	var/base_icon = "bed"
	var/applies_material_colour = 1

/obj/structure/bed/New(var/newloc,69ar/new_material,69ar/new_padding_material)
	..(newloc)
	color = null
	if(!new_material)
		new_material =69ATERIAL_STEEL
	material = get_material_by_name(new_material)
	if(!istype(material))
		69del(src)
		return
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	update_icon()

/obj/structure/bed/get_material()
	return69aterial

/obj/structure/bed/get_matter()
	var/list/matter = ..()
	. =69atter.Copy()
	if(material)
		LAZYAPLUS(.,69aterial.name, 5)
	if(padding_material)
		LAZYAPLUS(., padding_material.name, 1)

// Reuse the cache/code from stools, todo69aybe unify.
/obj/structure/bed/update_icon()
	// Prep icon.
	icon_state = ""
	overlays.Cut()
	// Base icon.
	var/cache_key = "69base_icon69-69material.name69"
	if(isnull(stool_cache69cache_key69))
		var/image/I = image('icons/obj/furniture.dmi', base_icon)
		if(applies_material_colour)
			I.color =69aterial.icon_colour
		stool_cache69cache_key69 = I
	overlays |= stool_cache69cache_key69
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "69base_icon69-padding-69padding_material.name69"
		if(isnull(stool_cache69padding_cache_key69))
			var/image/I =  image(icon, "69base_icon69_padding")
			I.color = padding_material.icon_colour
			stool_cache69padding_cache_key69 = I
		overlays |= stool_cache69padding_cache_key69

	// Strings.
	desc = initial(desc)
	if(padding_material)
		name = "69padding_material.display_name69 69initial(name)69" //this is not perfect but it will do for now.
		desc += " It's69ade of 69material.use_name69 and covered with 69padding_material.use_name69."
	else
		name = "69material.display_name69 69initial(name)69"
		desc += " It's69ade of 69material.use_name69."

/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) &&69over.checkpass(PASSTABLE))
		return 1
	else
		return ..()

/obj/structure/bed/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			if (prob(50))
				69del(src)
				return
		if(3)
			if (prob(5))
				69del(src)
				return

/obj/structure/bed/affect_grab(var/mob/user,69ar/mob/target)
	user.visible_message(SPAN_NOTICE("69user69 attempts to buckle 69target69 into \the 69src69!"))
	if(do_after(user, 20, src) && Adjacent(target))
		target.forceMove(loc)
		spawn(0)
			if(buckle_mob(target))
				target.visible_message(
					SPAN_DANGER("69target69 is buckled to 69src69 by 69user69!"),
					SPAN_DANGER("You are buckled to 69src69 by 69user69!"),
					SPAN_NOTICE("You hear69etal clanking.")
				)
		return TRUE

/obj/structure/bed/attackby(obj/item/W as obj,69ob/user as69ob)
	if(W.has_69uality(69UALITY_BOLT_TURNING))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dismantle()
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The 69src69 is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			user.drop_from_inventory(C)
			69del(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a69aterial69ar.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags &69ATERIAL_PADDING))
				padding_type = "69M.material.name69"
		if(!padding_type)
			to_chat(user, "You cannot pad \the 69src69 with that.")
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.loc = get_turf(src)
		to_chat(user, "You add padding to \the 69src69.")
		add_padding(padding_type)
		return

	else if (W.has_69uality(69UALITY_WIRE_CUTTING))
		if(!padding_material)
			to_chat(user, "\The 69src69 has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the 69src69.")
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		remove_padding()
	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		var/mob/living/affecting = G.affecting
		if(user_buckle_mob(affecting, user))
			69del(W)

	else if(!istype(W, /obj/item/bedsheet))
		..()

/obj/structure/bed/attack_robot(var/mob/user)
	if(Adjacent(user)) // Robots can buckle/unbuckle but not the AI.
		attack_hand(user)

//If there's blankets on the bed, got to roll them down before you can unbuckle the69ob
/obj/structure/bed/attack_hand(var/mob/user)
	var/obj/item/bedsheet/blankets = (locate(/obj/item/bedsheet) in loc)
	if (buckled_mob && blankets && !blankets.rolled && !blankets.folded)
		if (!blankets.toggle_roll(user))
			return

	//Useability tweak. If you're lying on this bed, clicking it will69ake you get up
	if (isliving(user) && user.loc == loc && user.resting)
		var/mob/living/L = user
		L.lay_down() //This69erb toggles the resting state

	.=..()

/obj/structure/bed/Move()
	. = ..()
	if(buckled_mob)
		buckled_mob.forceMove(src.loc, glide_size_override = glide_size)

/obj/structure/bed/forceMove(atom/destination,69ar/special_event, glide_size_override=0)
	. = ..()
	if(buckled_mob)
		if(isturf(src.loc))
			buckled_mob.forceMove(destination, special_event, (glide_size_override ? glide_size_override : glide_size))
		else
			unbuckle_mob()

/obj/structure/bed/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/structure/bed/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/structure/bed/proc/dismantle()
	drop_materials(drop_location())
	69del(src)

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	base_icon = "psychbed"

/obj/structure/bed/psych/New(var/newloc)
	..(newloc,69ATERIAL_WOOD,69ATERIAL_LEATHER)

/obj/structure/bed/padded/New(var/newloc)
	..(newloc,69ATERIAL_PLASTIC, "cotton")

/obj/structure/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"

/obj/structure/bed/alien/New(var/newloc)
	..(newloc,69ATERIAL_STEEL)

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = FALSE
	buckle_pixel_shift = "x=0;y=6"
	var/item_form_type = /obj/item/roller	//The folded-up object path.

/obj/structure/bed/roller/update_icon()
	if(density)
		icon_state = "up"
	else
		icon_state = "down"

/obj/structure/bed/roller/attackby(obj/item/I,69ob/living/user)
	if((69UALITY_BOLT_TURNING in I.tool_69ualities) || (69UALITY_WIRE_CUTTING in I.tool_69ualities) || istype(I, /obj/item/stack))
		return
	..()

/obj/structure/bed/roller/proc/collapse()
	visible_message("69usr69 collapses 69src69.")
	new item_form_type(get_turf(src))
	69del(src)

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	item_state = "rbed"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE // Can't be put in backpacks. Oh well. For now.
	var/structure_form_type = /obj/structure/bed/roller	//The deployed form path.

/obj/item/roller/attack_self(mob/user)
	deploy(user)



/obj/item/roller/proc/deploy(var/mob/user)
	var/turf/T = get_turf(src) //When held, this will still find the user's location
	if (istype(T))
		var/obj/structure/bed/roller/R = new structure_form_type(user.loc)
		R.add_fingerprint(user)
		69del(src)

/obj/structure/bed/roller/post_buckle_mob(mob/living/M as69ob)
	. = ..()
	if(M == buckled_mob)
		set_density(1)
		icon_state = "up"
	else
		set_density(0)
		icon_state = "down"

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if(!CanMouseDrop(over_object))	return
	if(!(ishuman(usr) || isrobot(usr)))	return
	if(buckled_mob)	return

	collapse()


/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	var/max_stored = 4
	var/list/obj/item/roller/held = list()

/obj/item/roller_holder/New()
	..()
	held.Add(new /obj/item/roller(src))

/obj/item/roller_holder/examine(var/mob/user)
	.=..()
	to_chat(user, SPAN_NOTICE("It contains 69held.len69 stored beds"))

/obj/item/roller_holder/attack_self(mob/user as69ob)

	if(!held.len)
		to_chat(user, SPAN_NOTICE("The rack is empty."))
		return

	if (!isturf(user.loc) || (locate(/obj/structure/bed/roller) in user.loc))
		to_chat(user, SPAN_WARNING("You can't deploy that here!"))
		return

	to_chat(user, SPAN_NOTICE("You deploy the roller bed."))
	var/obj/item/roller/r = pick_n_take(held)
	r.forceMove(user.loc)
	r.deploy(user)

//Picking up rollerbeds
/obj/item/roller_holder/afterattack(var/obj/target,69ar/mob/user,69ar/proximity)
	.=..()
	if (istype(target,/obj/item/roller))
		if (held.len >=69ax_stored)
			to_chat(user, SPAN_WARNING("You can't fit anymore rollerbeds in \the 69src69!"))
			return

		to_chat(user, SPAN_NOTICE("You scoop up \the 69target69 and store it in \the 69src69!"))
		target.forceMove(src)
		held.Add(target)
