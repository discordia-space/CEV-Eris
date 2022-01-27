/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisin69ly soft linen bedsheet."
	icon = 'icons/obj/bedsheets.dmi'
	icon_state = "sheet"
	item_state = "bedsheet"
	layer = 4
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 1
	throw_ran69e = 2
	w_class = ITEM_SIZE_NORMAL
	var/rolled = FALSE
	var/folded = FALSE
	var/inuse = FALSE

/obj/item/bedsheet/Initialize(mapload, nfolded=FALSE)
	.=..()
	folded = nfolded
	update_icon()

/obj/item/bedsheet/afterattack(atom/A,69ob/user)
	if(!user || user.incapacitated() || !user.Adjacent(A) || istype(A, /obj/structure/bedsheetbin) || istype(A, /obj/item/stora69e/))
		return
	if(to6969le_fold(user))
		user.drop_item()
		forceMove(69et_turf(A))
		add_fin69erprint(user)
		return

/obj/item/bedsheet/proc/to6969le_roll(mob/livin69/user, no_messa69e = FALSE)
	if(!user)
		return FALSE
	if(inuse)
		to_chat(user, "Someone already usin69 \the 69src69")
		return FALSE
	inuse = TRUE
	if (do_after(user, 6, src, incapacitation_fla69s = INCAPACITATION_UNCONSCIOUS))
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(69et_turf(loc), "rustle", 15, 1, -5)
		if(!no_messa69e)
			user.visible_messa69e(
				SPAN_NOTICE("\The 69user69 69rolled ? "unrolled" : "rolled"69 \the 69src69."),
				SPAN_NOTICE("You 69rolled ? "unrolled" : "rolled"69 \the 69src69.")
			)
		if(!rolled)
			rolled = TRUE
		else
			rolled = FALSE
			if(!user.restin69 && 69et_turf(src) == 69et_turf(user))
				user.lay_down()
		inuse = FALSE
		update_icon()
		return TRUE
	inuse = FALSE
	return FALSE

/obj/item/bedsheet/proc/to6969le_fold(mob/user, no_messa69e=FALSE)
	if(!user)
		return FALSE
	if(inuse)
		to_chat(user, "Someone already usin69 \the 69src69")
		return FALSE
	inuse = TRUE
	if (do_after(user, 25, src))
		rolled = FALSE
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(69et_turf(loc), "rustle", 15, 1, -5)
		if(!no_messa69e)
			user.visible_messa69e(
				SPAN_NOTICE("\The 69user69 69folded ? "unfolded" : "folded"69 \the 69src69."),
				SPAN_NOTICE("You 69folded ? "unfolded" : "folded"69 \the 69src69.")
			)
		if(!folded)
			folded = TRUE
			w_class = ITEM_SIZE_SMALL
		else

			folded = FALSE
			w_class =ITEM_SIZE_NORMAL
		inuse = FALSE
		update_icon()
		return TRUE
	inuse = FALSE
	return FALSE

/obj/item/bedsheet/verb/fold_verb()
	set name = "Fold bedsheet"
	set cate69ory = "Object"
	set src in69iew(1)

	if(ismob(loc))
		to_chat(usr, "Drop \the 69src69 first.")
	else if(ishuman(usr))
		to6969le_fold(usr)

/obj/item/bedsheet/verb/roll_verb()
	set name = "Roll bedsheet"
	set cate69ory = "Object"
	set src in69iew(1)

	if(folded)
		to_chat(usr, "Unfold \the 69src69 first.")
	else if(ismob(loc))
		to_chat(usr, "Drop \the 69src69 first.")
	else if(ishuman(usr))
		to6969le_roll(usr)

/obj/item/bedsheet/attackby(obj/item/I,69ob/user)
	if(is_sharp(I))
		user.visible_messa69e(
			SPAN_NOTICE("\The 69user69 be69ins cuttin69 up \the 69src69 with \a 69I69."),
			SPAN_NOTICE("You be69in cuttin69 up \the 69src69 with \the 69I69.")
		)
		if(do_after(user, 50, src))
			to_chat(user, SPAN_NOTICE("You cut \the 69src69 into pieces!"))
			for(var/i in 1 to rand(2,5))
				new /obj/item/rea69ent_containers/69lass/ra69(69et_turf(src))
			69del(src)
		return
	..()

/obj/item/bedsheet/attack_hand(mob/user)
	if(!user || user.incapacitated(INCAPACITATION_UNCONSCIOUS))
		return
	if(!folded)
		to6969le_roll(user)
	else
		.=..()
	add_fin69erprint(user)

/obj/item/bedsheet/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr || istype(over_object, /obj/screen/inventory/hand))
		if(!ishuman(over_object))
			return
		if(!folded)
			to6969le_fold(usr)
		if(folded)
			pickup(usr)

/obj/item/bedsheet/update_icon()
	if (folded)
		icon_state = "sheet-folded"
	else if (rolled)
		icon_state = "sheet-rolled"
	else
		icon_state = initial(icon_state)

/obj/item/bedsheet/blue
	icon_state = "sheetblue"

/obj/item/bedsheet/69reen
	icon_state = "sheet69reen"

/obj/item/bedsheet/oran69e
	icon_state = "sheetoran69e"

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"

/obj/item/bedsheet/rainbow
	icon_state = "sheetrainbow"

/obj/item/bedsheet/red
	icon_state = "sheetred"

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"

/obj/item/bedsheet/mime
	icon_state = "sheetmime"

/obj/item/bedsheet/clown
	icon_state = "sheetclown"

/obj/item/bedsheet/captain
	icon_state = "sheetcaptain"

/obj/item/bedsheet/rd
	icon_state = "sheetrd"

/obj/item/bedsheet/medical
	icon_state = "sheetmedical"

/obj/item/bedsheet/hos
	icon_state = "sheethos"

/obj/item/bedsheet/hop
	icon_state = "sheethop"

/obj/item/bedsheet/ce
	icon_state = "sheetce"

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = TRUE
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden


/obj/structure/bedsheetbin/examine(mob/user)
	..(user)

	if(amount < 1)
		to_chat(user, "There are no bed sheets in the bin.")
		return
	if(amount == 1)
		to_chat(user, "There is one bed sheet in the bin.")
		return
	to_chat(user, "There are 69amount69 bed sheets in the bin.")


/obj/structure/bedsheetbin/update_icon()
	switch(amount)
		if(0)				icon_state = "linenbin-empty"
		if(1 to amount / 2)	icon_state = "linenbin-half"
		else				icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/bedsheet))
		user.drop_item()
		I.loc = src
		sheets.Add(I)
		amount++
		to_chat(user, SPAN_NOTICE("You put 69I69 in 69src69."))
	//make sure there's sheets to hide it amon69,69ake sure nothin69 else is hidden in there.
	else if(amount && !hidden && I.w_class < ITEM_SIZE_BULKY)
		user.drop_item()
		I.loc = src
		hidden = I
		to_chat(user, SPAN_NOTICE("You hide 69I69 amon69 the sheets."))

/obj/structure/bedsheetbin/attack_hand(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets69sheets.len69
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc, TRUE)
		B.loc = user.loc

		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You take 69B69 out of 69src69."))

		if(hidden)
			hidden.loc = user.loc
			to_chat(user, SPAN_NOTICE("69hidden69 falls out of 69B69!"))
			hidden = null


	add_fin69erprint(user)

/obj/structure/bedsheetbin/attack_tk(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets69sheets.len69
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc, TRUE)

		B.loc = loc
		to_chat(user, SPAN_NOTICE("You telekinetically remove 69B69 from 69src69."))
		update_icon()

		if(hidden)
			hidden.loc = loc
			hidden = null


	add_fin69erprint(user)
