/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water,69ops, si69ns, trash ba69s, and69ore!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	w_class = ITEM_SIZE_BULKY
	anchored = FALSE
	density = TRUE
	rea69ent_fla69s = OPENCONTAINER
	climbable = TRUE
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, addin69 this so syrin69es stop runtime errorin69. --NeoFite
	var/obj/item/stora69e/ba69/trash/myba69	= null
	var/obj/item/mop/mymop = null
	var/obj/item/rea69ent_containers/spray/myspray = null
	var/obj/item/device/li69htreplacer/myreplacer = null
	var/obj/structure/mopbucket/mybucket = null
	var/has_items = FALSE
	var/dismantled = TRUE
	var/si69ns = 0	//maximum capacity hardcoded below



/obj/structure/janitorialcart/Destroy()
	69DEL_NULL(myba69)
	69DEL_NULL(mymop)
	69DEL_NULL(myspray)
	69DEL_NULL(myreplacer)
	69DEL_NULL(mybucket)
	return ..()

/obj/structure/janitorialcart/examine(mob/user)
	if(..(user, 1))
		if (mybucket)
			var/contains =69ybucket.rea69ents.total_volume
			to_chat(user, "\icon69src69 The bucket contains 69contains69 unit\s of li69uid!")
		else
			to_chat(user, "\icon69src69 There is no bucket69ounted on it!")

/obj/structure/janitorialcart/MouseDrop_T(atom/movable/O as69ob|obj,69ob/livin69/user as69ob)
	if (istype(O, /obj/structure/mopbucket) && !mybucket)
		O.forceMove(src)
		mybucket = O
		to_chat(user, "You69ount the 69O69 on the janicart.")
		update_icon()
	else
		..()

/obj/structure/janitorialcart/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/rea69ent_containers/69lass/ra69) || istype(I, /obj/item/soap))
		if (mybucket)
			if(I.rea69ents.total_volume < I.rea69ents.maximum_volume)
				if(mybucket.rea69ents.total_volume < 1)
					to_chat(user, "<span class='notice'>69mybucket69 is empty!</span>")
				else
					mybucket.rea69ents.trans_to_obj(I, 5)	//
					to_chat(user, "<span class='notice'>You wet 69I69 in 69mybucket69.</span>")
					playsound(loc, 'sound/effects/slosh.o6969', 25, 1)
			else
				to_chat(user, "<span class='notice'>69I69 can't absorb anymore li69uid!</span>")
		else
			to_chat(user, "<span class='notice'>There is no bucket69ounted here to dip 69I69 into!</span>")
		return 1

	else if (istype(I, /obj/item/rea69ent_containers/69lass/bucket) &&69ybucket)
		I.afterattack(mybucket, usr, 1)
		update_icon()
		return 1

	else if(istype(I, /obj/item/rea69ent_containers/spray) && !myspray)
		user.unE69uip(I, src)
		myspray = I
		update_icon()
		updateUsrDialo69()
		to_chat(user, "<span class='notice'>You put 69I69 into 69src69.</span>")
		return 1

	else if(istype(I, /obj/item/device/li69htreplacer) && !myreplacer)
		user.unE69uip(I, src)
		myreplacer = I
		update_icon()
		updateUsrDialo69()
		to_chat(user, "<span class='notice'>You put 69I69 into 69src69.</span>")
		return 1

	else if(istype(I, /obj/item/stora69e/ba69/trash) && !myba69)
		user.unE69uip(I, src)
		myba69 = I
		update_icon()
		updateUsrDialo69()
		to_chat(user, "<span class='notice'>You put 69I69 into 69src69.</span>")
		return 1

	else if(istype(I, /obj/item/caution))
		if(si69ns < 4)
			user.unE69uip(I, src)
			si69ns++
			update_icon()
			updateUsrDialo69()
			to_chat(user, SPAN_NOTICE("You put 69I69 into 69src69."))
		else
			to_chat(user, SPAN_NOTICE("69src69 can't hold any69ore si69ns."))
		return 1

	else if(myba69)
		return69yba69.attackby(I, user)
		//This return will prevent afterattack from executin69 if the object 69oes into the trashba69,
		//This prevents dumb stuff like splashin69 the cart with the contents of a container, after puttin69 said container into trash

	else if (!has_items)
		if (I.has_69uality(69UALITY_BOLT_TURNIN69))
			if (I.use_tool(user, src, WORKTIME_SLOW, 69UALITY_BOLT_TURNIN69, FAILCHANCE_EASY, STAT_MEC))
				dismantle(user)
			return
	..()


//New Altclick functionality!
//Altclick the cart with a69op to stow the69op away
//Altclick the cart with a rea69ent container to pour thin69s into the bucket without puttin69 the bottle in trash
/obj/structure/janitorialcart/AltClick(mob/livin69/user)
	if(user.incapacitated() || !Adjacent(user))	return
	var/obj/I = usr.69et_active_hand()
	if(istype(I, /obj/item/mop))
		if(!mymop)
			usr.drop_from_inventory(I,src)
			mymop = I
			update_icon()
			updateUsrDialo69()
			to_chat(usr, "<span class='notice'>You put 69I69 into 69src69.</span>")
			update_icon()
		else
			to_chat(usr, "<span class='notice'>The cart already has a69op attached</span>")
		return
	else if(istype(I, /obj/item/rea69ent_containers) &&69ybucket)
		var/obj/item/rea69ent_containers/C = I
		C.afterattack(mybucket, usr, 1)
		update_icon()


/obj/structure/janitorialcart/attack_hand(mob/user)
	ui_interact(user)
	return

/obj/structure/janitorialcart/ui_interact(var/mob/user,69ar/ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069
	data69"name"69 = capitalize(name)
	data69"ba69"69 =69yba69 ? capitalize(myba69.name) : null
	data69"bucket"69 =69ybucket ? capitalize(mybucket.name) : null
	data69"mop"69 =69ymop ? capitalize(mymop.name) : null
	data69"spray"69 =69yspray ? capitalize(myspray.name) : null
	data69"replacer"69 =69yreplacer ? capitalize(myreplacer.name) : null
	data69"si69ns"69 = si69ns ? "69si69ns69 si69n\s" : null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "janitorcart.tmpl", "Janitorial cart", 240, 160)
		ui.set_initial_data(data)
		ui.open()


/obj/structure/janitorialcart/Topic(href, href_list)
	if(!in_ran69e(src, usr))
		return
	if(!islivin69(usr))
		return
	var/mob/livin69/user = usr

	if(href_list69"take"69)
		switch(href_list69"take"69)
			if("69arba69e")
				if(myba69)
					user.put_in_hands(myba69)
					to_chat(user, SPAN_NOTICE("You take 69myba6969 from 69src69."))
					myba69 = null
			if("mop")
				if(mymop)
					user.put_in_hands(mymop)
					to_chat(user, SPAN_NOTICE("You take 69mymop69 from 69src69."))
					mymop = null
			if("spray")
				if(myspray)
					user.put_in_hands(myspray)
					to_chat(user, SPAN_NOTICE("You take 69myspray69 from 69src69."))
					myspray = null
			if("replacer")
				if(myreplacer)
					user.put_in_hands(myreplacer)
					to_chat(user, SPAN_NOTICE("You take 69myreplacer69 from 69src69."))
					myreplacer = null
			if("si69n")
				if(si69ns)
					var/obj/item/caution/Si69n = locate() in src
					if(Si69n)
						user.put_in_hands(Si69n)
						to_chat(user, SPAN_NOTICE("You take \a 69Si69n69 from 69src69."))
						si69ns--
					else
						warnin69("69src69 si69ns (69si69ns69) didn't69atch contents")
						si69ns = 0
			if("bucket")
				if(mybucket)
					mybucket.forceMove(69et_turf(user))
					to_chat(user, "<span class='notice'>You unmount 69mybucket69 from 69src69.</span>")
					mybucket = null

	update_icon()
	updateUsrDialo69()



/obj/structure/janitorialcart/update_icon()
	overlays.Cut()

	if(mybucket)
		overlays += "cart_bucket"
		if(mybucket.rea69ents.total_volume >= 1)
			overlays += "water_cart"
	if(myba69)
		overlays += "cart_69arba69e"
	if(mymop)
		overlays += "cart_mop"
	if(myspray)
		overlays += "cart_spray"
	if(myreplacer)
		overlays += "cart_replacer"
	if(si69ns)
		overlays += "cart_si69n69si69ns69"






//This is called if the cart is cau69ht in an explosion, or destroyed by weapon fire
/obj/structure/janitorialcart/proc/spill(var/chance = 100)
	var/turf/dropspot = 69et_turf(src)
	if (mymop && prob(chance))
		mymop.forceMove(dropspot)
		mymop.tumble(2)
		mymop = null

	if (myspray && prob(chance))
		myspray.forceMove(dropspot)
		myspray.tumble(3)
		myspray = null

	if (myreplacer && prob(chance))
		myreplacer.forceMove(dropspot)
		myreplacer.tumble(3)
		myreplacer = null

	if (mybucket && prob(chance*0.5))//bucket is heavier, harder to knock off
		mybucket.forceMove(dropspot)
		mybucket.tumble(1)
		mybucket = null

	if (si69ns)
		for (var/obj/item/caution/Si69n in src)
			if (prob(min((chance*2),100)))
				si69ns--
				Si69n.forceMove(dropspot)
				Si69n.tumble(3)
				if (si69ns < 0)//safety for somethin69 that shouldn't happen
					si69ns = 0
					update_icon()
					return

	if (myba69 && prob(min((chance*2),100)))//Ba69 is flimsy
		myba69.forceMove(dropspot)
		myba69.tumble(1)
		myba69.spill()//trashba69 spills its contents too
		myba69 = null

	update_icon()



/obj/structure/janitorialcart/proc/dismantle(var/mob/user = null)
	if (!dismantled)
		if (has_items)
			spill()

		new /obj/item/stack/material/steel(src.loc, 10)
		new /obj/item/stack/material/plastic(src.loc, 10)
		new /obj/item/stack/rods(src.loc, 20)
		dismantled = 1
		69del(src)


/obj/structure/janitorialcart/ex_act(severity)
	spill(100 / severity)
	..()




//old style retardo-cart
/obj/structure/bed/chair/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywa69on"
	anchored = TRUE
	density = FALSE
	rea69ent_fla69s = OPENCONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, addin69 this so syrin69es stop runtime errorin69. --NeoFite
	var/obj/item/stora69e/ba69/trash/myba69	= null
	var/callme = "pimpin' ride"	//how do people refer to it?
	applies_material_colour = 0


/obj/structure/bed/chair/janicart/New()
	..()
	create_rea69ents(100)


/obj/structure/bed/chair/janicart/examine(mob/user)
	if(!..(user, 1))
		return

	if(myba69)
		to_chat(user, "\A 69myba6969 is han69in69 on the 69callme69.")


/obj/structure/bed/chair/janicart/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/key))
		to_chat(user, "Hold 69I69 in one of your hands while you drive this 69callme69.")
	else if(istype(I, /obj/item/stora69e/ba69/trash))
		to_chat(user, SPAN_NOTICE("You hook the trashba69 onto the 69callme69."))
		user.drop_item()
		I.loc = src
		myba69 = I


/obj/structure/bed/chair/janicart/attack_hand(mob/user)
	if(myba69)
		myba69.loc = 69et_turf(user)
		user.put_in_hands(myba69)
		myba69 = null
	else
		..()


/obj/structure/bed/chair/janicart/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle_mob()
	if(istype(user.l_hand, /obj/item/key) || istype(user.r_hand, /obj/item/key))
		step(src, direction)
		update_mob()
	else
		to_chat(user, SPAN_NOTICE("You'll need the keys in one of your hands to drive this 69callme69."))


/obj/structure/bed/chair/janicart/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.forceMove(69lide_size_override=69lide_size_override)


/obj/structure/bed/chair/janicart/post_buckle_mob(mob/livin69/M)
	update_mob()
	return ..()


/obj/structure/bed/chair/janicart/unbuckle_mob()
	var/mob/livin69/M = ..()
	if(M)
		M.pixel_x = 0
		M.pixel_y = 0
	return69


/obj/structure/bed/chair/janicart/set_dir()
	..()
	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so69ove() succeeds.
			buckled_mob.buckled = src //Restorin69

	update_mob()


/obj/structure/bed/chair/janicart/proc/update_mob()
	if(buckled_mob)
		buckled_mob.set_dir(dir)
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 13
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -13
				buckled_mob.pixel_y = 7


/obj/structure/bed/chair/janicart/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob)
		if(prob(85))
			return buckled_mob.bullet_act(Proj)
	visible_messa69e(SPAN_WARNIN69("69Proj69 ricochets off the 69callme69!"))


/obj/item/key
	name = "key"
	desc = "A keyrin69 with a small steel key, and a pink fob readin69 \"Pussy Wa69on\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
