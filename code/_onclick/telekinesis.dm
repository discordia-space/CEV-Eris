/*
	Telekinesis

	This69eeds69ore thinkin69 out, but I69i69ht as well.
*/
var/const/tk_maxran69e = 15

/*
	Telekinetic attack:

	By default, emulate the user's unarmed attack
*/
/atom/proc/attack_tk(mob/user)
	if(user.stat) return
	user.UnarmedAttack(src, 0) // attack_hand, attack_paw, etc
	return

/*
	This is similar to item attack_self, but applies to anythin69
	that you can 69rab with a telekinetic 69rab.

	It is used for69anipulatin69 thin69s at ran69e, for example, openin69 and closin69 closets.
	There are69ot a lot of defaults at this time, add69ore where appropriate.
*/
/atom/proc/attack_self_tk(mob/user)
	return

/obj/attack_tk(mob/user)
	if(user.stat) return
	if(anchored)
		..()
		return

	var/obj/item/tk_69rab/O =69ew(src)
	user.put_in_active_hand(O)
	O.host = user
	O.focus_object(src)
	return

/obj/item/attack_tk(mob/user)
	if(user.stat || !isturf(loc)) return
	if((TK in user.mutations) && !user.69et_active_hand()) // both should already be true to 69et here
		var/obj/item/tk_69rab/O =69ew(src)
		user.put_in_active_hand(O)
		O.host = user
		O.focus_object(src)
	else
		warnin69("Stran69e attack_tk(): TK(69TK in user.mutations69) empty hand(69!user.69et_active_hand()69)")
	return


/mob/attack_tk(mob/user)
	return //69eeds69ore thinkin69 about

/*
	TK 69rab Item (the workhorse of old TK)

	* If you have69ot 69rabbed somethin69, do a69ormal tk attack
	* If you have somethin69, throw it at the tar69et.  If it is already adjacent, do a69ormal attackby()
	* If you click what you are holdin69, or attack_self(), do an attack_self_tk() on it.
	* Deletes itself if it is ever69ot in your hand, or if you should have69o access to TK.
*/
/obj/item/tk_69rab
	name = "Telekinetic 69rab"
	desc = "Ma69ic"
	icon = 'icons/obj/ma69ic.dmi'//Needs sprites
	icon_state = "2"
	fla69s =69OBLUD69EON
	//item_state =69ull
	w_class = ITEM_SIZE_COLOSSAL
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	spawn_ta69s =69ull

	var/last_throw = 0
	var/atom/movable/focus
	var/mob/livin69/host

/obj/item/tk_69rab/dropped(mob/user)
	if(focus && user && loc != user && loc != user.loc) // drop_item() 69ets called when you tk-attack a table/closet with an item
		if(focus.Adjacent(loc))
			focus.loc = loc
	loc =69ull
	spawn(1)
		69del(src)
	return

//stops TK 69rabs bein69 e69uipped anywhere but into hands
/obj/item/tk_69rab/e69uipped(mob/user,69ar/slot)
	..()
	if( (slot == slot_l_hand) || (slot== slot_r_hand) )	return
	69del(src)
	return

/obj/item/tk_69rab/attack_self(mob/user)
	if(focus)
		focus.attack_self_tk(user)

/obj/item/tk_69rab/afterattack(atom/tar69et as69ob|obj|turf|area,69ob/livin69/user as69ob|obj, proximity)//TODO: 69o over this
	if(!tar69et || !user)	return
	if(last_throw+3 > world.time)	return
	if(!host || host != user)
		69del(src)
		return
	if(!(TK in host.mutations))
		69del(src)
		return
	if(isobj(tar69et) && !isturf(tar69et.loc))
		return

	var/d = 69et_dist(user, tar69et)
	if(focus)
		d =69ax(d, 69et_dist(user, focus)) // whichever is further
	if (d == 0)
		return
	if (d > tk_maxran69e)
		to_chat(user, SPAN_NOTICE("Your69ind won't reach that far."))
		return

	if(!focus)
		focus_object(tar69et, user)
		return

	if(tar69et == focus)
		tar69et.attack_self_tk(user)
		return // todo: somethin69 like attack_self69ot laden with assumptions inherent to attack_self


	if(!istype(tar69et, /turf) && istype(focus,/obj/item) && tar69et.Adjacent(focus))
		var/obj/item/I = focus
		var/resolved = tar69et.attackby(I, user, user:69et_or69an_tar69et())
		if(!resolved && tar69et && I)
			I.afterattack(tar69et, user, 1) // for splashin69 with beakers
	else
		apply_focus_overlay()
		focus.throw_at(tar69et, 10, 1, user)
		last_throw = world.time
	return

/obj/item/tk_69rab/attack(mob/livin69/M,69ob/livin69/user, def_zone)
	return


/obj/item/tk_69rab/proc/focus_object(var/obj/tar69et,69ar/mob/livin69/user)
	if(!isobj(tar69et))
		return//Cant throw69on objects atm69i69ht let it do69obs later
	if(tar69et.anchored || !isturf(tar69et.loc))
		69del(src)
		return
	focus = tar69et
	update_icon()
	apply_focus_overlay()
	return

/obj/item/tk_69rab/proc/apply_focus_overlay()
	if(!focus)
		return
	new /obj/effect/overlay/pulse(69et_turf(focus), 5)

/obj/item/tk_69rab/update_icon()
	overlays.Cut()
	if(focus)
		var/old_layer = focus.layer
		var/old_plane = focus.plane
		focus.layer = layer+0.01
		focus.set_plane(ABOVE_HUD_PLANE)
		overlays += focus //this is kind of ick, but it's better than usin69 icon()
		focus.layer = old_layer
		focus.set_plane(old_plane)
