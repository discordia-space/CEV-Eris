/*
	Telekinesis

	This needs more thinking out, but I might as well.
*/
var/const/tk_maxrange = 15

/*
	Telekinetic attack:

	By default, emulate the user's unarmed attack
*/
/atom/proc/attack_tk(mob/user)
	if(user.stat) return
	user.UnarmedAttack(src, 0) // attack_hand, attack_paw, etc
	return

/*
	This is similar to item attack_self, but applies to anything
	that you can grab with a telekinetic grab.

	It is used for manipulating things at range, for example, opening and closing closets.
	There are not a lot of defaults at this time, add more where appropriate.
*/
/atom/proc/attack_self_tk(mob/user)
	return

/obj/attack_tk(mob/user)
	if(user.stat) return
	if(anchored)
		..()
		return

	var/obj/item/tk_grab/O = new(src)
	user.put_in_active_hand(O)
	O.host = user
	O.focus_object(src)
	return

/obj/item/attack_tk(mob/user)
	if(user.stat || !isturf(loc))
		return

	var/obj/item/tk_grab/O = new(src)
	user.put_in_active_hand(O)
	O.host = user
	O.focus_object(src)

/mob/attack_tk(mob/user)
	return // needs more thinking about

/*
	TK Grab Item (the workhorse of old TK)

	* If you have not grabbed something, do a normal tk attack
	* If you have something, throw it at the target.  If it is already adjacent, do a normal attackby()
	* If you click what you are holding, or attack_self(), do an attack_self_tk() on it.
	* Deletes itself if it is ever not in your hand, or if you should have no access to TK.
*/
/obj/item/tk_grab
	name = "Telekinetic Grab"
	desc = "Magic"
	icon = 'icons/obj/magic.dmi'//Needs sprites
	icon_state = "2"
	flags = NOBLUDGEON
	//item_state = null
	volumeClass = ITEM_SIZE_COLOSSAL
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	spawn_tags = null

	var/last_throw = 0
	var/atom/movable/focus
	var/mob/living/host

/obj/item/tk_grab/dropped(mob/user)
	if(focus && user && loc != user && loc != user.loc) // drop_item() gets called when you tk-attack a table/closet with an item
		if(focus.Adjacent(loc))
			focus.loc = loc
	loc = null
	spawn(1)
		qdel(src)
	return

//stops TK grabs being equipped anywhere but into hands
/obj/item/tk_grab/equipped(mob/user, var/slot)
	..()
	if( (slot == slot_l_hand) || (slot== slot_r_hand) )	return
	qdel(src)
	return

/obj/item/tk_grab/attack_self(mob/user)
	if(focus)
		focus.attack_self_tk(user)

/obj/item/tk_grab/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity)//TODO: go over this
	if(!target || !user || last_throw + 3 > world.time)
		return

	if(isobj(target) && !isturf(target.loc))
		return

	if(!host || host != user || !get_active_mutation(user, MUTATION_TELEKINESIS))
		qdel(src)
		return

	var/d = get_dist(user, target)
	if(focus)
		d = max(d, get_dist(user, focus)) // whichever is further

	if(!d)
		return

	if(d > tk_maxrange)
		to_chat(user, SPAN_NOTICE("Your mind won't reach that far."))
		return

	if(!focus)
		focus_object(target, user)
		return

	if(target == focus)
		target.attack_self_tk(user)
		return // todo: something like attack_self not laden with assumptions inherent to attack_self


	if(!istype(target, /turf) && istype(focus,/obj/item) && target.Adjacent(focus))
		var/obj/item/I = focus
		var/resolved = target.attackby(I, user, user:get_organ_target())
		if(!resolved && target && I)
			I.afterattack(target, user, 1) // for splashing with beakers
	else
		apply_focus_overlay()
		focus.throw_at(target, 10, 1, user)
		last_throw = world.time
	return

/obj/item/tk_grab/attack(mob/living/M, mob/living/user, def_zone, damageMultiplier)
	return


/obj/item/tk_grab/proc/focus_object(obj/target, mob/living/user)
	if(!isobj(target))
		return//Cant throw non objects atm might let it do mobs later
	if(target.anchored || !isturf(target.loc))
		qdel(src)
		return
	focus = target
	update_icon()
	apply_focus_overlay()
	return

/obj/item/tk_grab/proc/apply_focus_overlay()
	if(!focus)
		return
	new /obj/effect/overlay/pulse(get_turf(focus), 5)

/obj/item/tk_grab/update_icon()
	overlays.Cut()
	if(focus)
		var/old_layer = focus.layer
		var/old_plane = focus.plane
		focus.layer = layer+0.01
		focus.set_plane(ABOVE_HUD_PLANE)
		overlays += focus //this is kind of ick, but it's better than using icon()
		focus.layer = old_layer
		focus.set_plane(old_plane)
