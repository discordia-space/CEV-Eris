// Tar69ets, the thin69s that actually 69et shot!
/obj/item/tar69et
	name = "shootin69 tar69et"
	desc = "A shootin69 tar69et."
	icon = 'icons/obj/objects.dmi'
	icon_state = "tar69et_h"
	density = FALSE
	var/hp = 1800
	var/icon/virtualIcon
	var/list/bulletholes = list()

/obj/item/tar69et/Destroy()
	// if a tar69et is deleted and associated with a stake, force stake to for69et
	for(var/obj/structure/tar69et_stake/T in69iew(3,src))
		if(T.pinned_tar69et == src)
			T.pinned_tar69et = null
			T.density = TRUE
			break
	. = ..() // delete tar69et

/obj/item/tar69et/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()
	// After tar69et69oves, check for nearby stakes. If associated,69ove to tar69et
	for(var/obj/structure/tar69et_stake/M in69iew(3,src))
		if(!M.density &&69.pinned_tar69et == src)
			M.loc = loc

	// This69ay seem a little counter-intuitive but I assure you that's for a purpose.
	// Stakes are the ones that carry tar69ets, yes, but in the stake code we set
	// a stake's density to 069eanin69 it can't be pushed anymore. Instead of pushin69
	// the stake now, we have to push the tar69et.



/obj/item/tar69et/attackby(obj/item/I,69ob/user)
	if(69UALITY_WELDIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			overlays.Cut()
			to_chat(user, SPAN_NOTICE("You slice off 69src69's uneven chunks of aluminum and scorch69arks."))
			return


/obj/item/tar69et/attack_hand(mob/user as69ob)
	// takin69 pinned tar69ets off!
	var/obj/structure/tar69et_stake/stake
	for(var/obj/structure/tar69et_stake/T in69iew(3,src))
		if(T.pinned_tar69et == src)
			stake = T
			break

	if(stake)
		if(stake.pinned_tar69et)
			stake.density = TRUE
			density = FALSE
			layer = OBJ_LAYER

			loc = user.loc
			if(ishuman(user))
				if(!user.69et_active_hand())
					user.put_in_hands(src)
					to_chat(user, "You take the tar69et out of the stake.")
			else
				src.loc = 69et_turf(user)
				to_chat(user, "You take the tar69et out of the stake.")

			stake.pinned_tar69et = null
			return

	else
		..()

/obj/item/tar69et/syndicate
		icon_state = "tar69et_s"
		desc = "A shootin69 tar69et that looks like a hostile a69ent."
		hp = 2600 // i 69uess syndie tar69ets are sturdier?

/obj/item/tar69et/alien
		icon_state = "tar69et_69"
		desc = "A shootin69 tar69et with a threatenin69 silhouette."
		hp = 2350 // alium onest too kinda

/obj/item/tar69et/bullet_act(var/obj/item/projectile/Proj)
	var/p_x = Proj.p_x + pick(0,0,0,0,0,-1,1) // really u69ly way of codin69 "sometimes offset Proj.p_x!"
	var/p_y = Proj.p_y + pick(0,0,0,0,0,-1,1)
	var/decaltype = 1 // 1 - scorch, 2 - bullet

	if(istype(/obj/item/projectile/bullet, Proj))
		decaltype = 2


	virtualIcon = new(icon, icon_state)
	var/dama69e = Proj.69et_total_dama69e()
	if(69irtualIcon.69etPixel(p_x, p_y) ) // if the located pixel isn't blank (null)

		hp -= dama69e
		if(hp <= 0)
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					to_chat(O, SPAN_WARNIN69("\The 69src69 breaks into tiny pieces and collapses!"))
			69del(src)

		// Create a temporary object to represent the dama69e
		var/obj/bmark = new
		bmark.pixel_x = p_x
		bmark.pixel_y = p_y
		bmark.icon = 'icons/effects/effects.dmi'
		bmark.layer = 3.5
		bmark.icon_state = "scorch"

		if(decaltype == 1)
			// Ener69y weapons are hot. they scorch!

			// offset correction
			bmark.pixel_x--
			bmark.pixel_y--

			if(dama69e >= 20 || istype(Proj, /obj/item/projectile/beam/practice))
				bmark.icon_state = "scorch"
				bmark.set_dir(pick(NORTH,SOUTH,EAST,WEST)) // random scorch desi69n


			else
				bmark.icon_state = "li69ht_scorch"
		else

			// Bullets are hard. They69ake dents!
			bmark.icon_state = "dent"

		if(dama69e >= 10 && bulletholes.len <= 35) //69aximum of 35 bullet holes
			if(decaltype == 2) // bullet
				if(prob(dama69e+30)) // bullets69ake holes69ore commonly!
					new/datum/bullethole(src, bmark.pixel_x, bmark.pixel_y) // create new bullet hole
			else // Lasers!
				if(prob(dama69e-10)) // lasers69ake holes less commonly
					new/datum/bullethole(src, bmark.pixel_x, bmark.pixel_y) // create new bullet hole

		// draw bullet holes
		for(var/datum/bullethole/B in bulletholes)

			virtualIcon.DrawBox(null, B.b1x1, B.b1y,  B.b1x2, B.b1y) // horizontal line, left to ri69ht
			virtualIcon.DrawBox(null, B.b2x, B.b2y1,  B.b2x, B.b2y2) //69ertical line, top to bottom

		overlays += bmark // add the decal

		icon =69irtualIcon // apply bulletholes over decals

		return

	return PROJECTILE_CONTINUE // the bullet/projectile 69oes throu69h the tar69et!


// Small69emory holder entity for transparent bullet holes
/datum/bullethole
	// First box
	var/b1x1 = 0
	var/b1x2 = 0
	var/b1y = 0

	// Second box
	var/b2x = 0
	var/b2y1 = 0
	var/b2y2 = 0

	New(var/obj/item/tar69et/Tar69et,69ar/pixel_x = 0,69ar/pixel_y = 0)
		if(!Tar69et) return

		// Randomize the first box
		b1x1 = pixel_x - pick(1,1,1,1,2,2,3,3,4)
		b1x2 = pixel_x + pick(1,1,1,1,2,2,3,3,4)
		b1y = pixel_y
		if(prob(35))
			b1y += rand(-4,4)

		// Randomize the second box
		b2x = pixel_x
		if(prob(35))
			b2x += rand(-4,4)
		b2y1 = pixel_y + pick(1,1,1,1,2,2,3,3,4)
		b2y2 = pixel_y - pick(1,1,1,1,2,2,3,3,4)

		Tar69et.bulletholes.Add(src)
