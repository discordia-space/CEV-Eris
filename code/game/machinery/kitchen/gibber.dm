
/obj/machinery/69ibber
	name = "69ibber"
	desc = "The name isn't descriptive enou69h?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "69rinder"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	re69_access = list(access_kitchen,access_mor69ue)

	var/operatin69 = 0 //Is it on?
	var/dirty = 0 // Does it need cleanin69?
	var/mob/livin69/occupant //69ob who has been put inside
	var/69ib_time = 40        // Time from startin69 until69eat appears
	var/69ib_throw_dir = WEST // Direction to spit69eat and 69ibs in.

	var/hack_re69uire = 6 //for hackin69 with69ultitool
	var/hack_sta69e = 0

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 500

//auto-69ibs anythin69 that bumps into it
/obj/machinery/69ibber/auto69ibber
	var/input_dir = 0

/obj/machinery/69ibber/auto69ibber/New()
	..()
	spawn()
		var/obj/landmark/machinery/input/input = locate() in oran69e(1, src)
		if(input)
			input_dir = 69et_dir(src, input)
		else
			lo69_misc("a 69src69 didn't find an input plate.")

/obj/machinery/69ibber/auto69ibber/Bumped(var/atom/A)
	if(!input_dir)
		return

	if(ismob(A))
		var/mob/M = A
		if(M.loc == 69et_step(src, input_dir))
			M.forceMove(src)
			M.69ib()


/obj/machinery/69ibber/New()
	..()
	update_icon()
	spawn()
		var/obj/landmark/machinery/output/output = locate() in oran69e(1, src)
		if(output)
			69ib_throw_dir = 69et_dir(src, output)

/obj/machinery/69ibber/update_icon()
	overlays.Cut()
	if (dirty)
		src.overlays += ima69e('icons/obj/kitchen.dmi', "69rbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.overlays += ima69e('icons/obj/kitchen.dmi', "69rjam")
	else if (operatin69)
		src.overlays += ima69e('icons/obj/kitchen.dmi', "69ruse")
	else
		src.overlays += ima69e('icons/obj/kitchen.dmi', "69ridle")

/obj/machinery/69ibber/relaymove(mob/user as69ob)
	src.69o_out()

/obj/machinery/69ibber/attack_hand(mob/user as69ob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operatin69)
		to_chat(user, SPAN_DAN69ER("The 69ibber is locked and runnin69, wait for it to finish."))
		return
	else
		src.start69ibbin69(user)

/obj/machinery/69ibber/attackby(obj/item/I,69ob/user)
	..()
	if(69UALITY_PULSIN69 in I.tool_69ualities)
		user.visible_messa69e(
		SPAN_WARNIN69("69user69 picks in wires of the 69src.name69 with a69ultitool"), \
		SPAN_WARNIN69("69pick("Pickin69 wires in 69src.name69 lock", "Hackin69 69src.name69 security systems", "Pulsin69 in locker controller")69.")
		)
		if(I.use_tool(user, src, WORKTIME_LON69, 69UALITY_PULSIN69, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
			if(hack_sta69e < hack_re69uire)
				playsound(loc, 'sound/items/69litch.o6969', 60, 1, -3)
				hack_sta69e++
				to_chat(user, SPAN_NOTICE("Multitool blinks <b>(69hack_sta69e69/69hack_re69uire69)</b> on screen."))
			else if(hack_sta69e >= hack_re69uire)
				ema6969ed = !ema6969ed
				src.update_icon()
				user.visible_messa69e(
				SPAN_WARNIN69("69user69 69ema6969ed?"disable":"enable"69 the safety 69uard of 69name69 with a69ultitool,"), \
				SPAN_WARNIN69("You 69ema6969ed? "disable" : "enable"69 the safety 69uard of 69name69 with69ultitool")
				)
				return

/obj/machinery/69ibber/examine()
	..()
	to_chat(usr, "The safety 69uard is 69ema6969ed ? SPAN_DAN69ER("disabled") : "enabled"69.")

/obj/machinery/69ibber/ema69_act(var/remainin69_char69es,69ar/mob/user)
	ema6969ed = !ema6969ed
	to_chat(user, SPAN_DAN69ER("You 69ema6969ed ? "disable" : "enable"69 the 69ibber safety 69uard."))
	return 1

/obj/machinery/69ibber/affect_69rab(var/mob/user,69ar/mob/tar69et,69ar/state)
	if(state < 69RAB_NECK)
		to_chat(user, SPAN_DAN69ER("You need a better 69rip to do that!"))
		return FALSE
	move_into_69ibber(user, tar69et)
	return TRUE

/obj/machinery/69ibber/MouseDrop_T(mob/tar69et,69ob/user)
	if(user.stat || user.restrained())
		return
	move_into_69ibber(user,tar69et)

/obj/machinery/69ibber/proc/move_into_69ibber(var/mob/user,var/mob/livin69/victim)

	if(src.occupant)
		to_chat(user, SPAN_DAN69ER("The 69ibber is full, empty it first!"))
		return

	if(operatin69)
		to_chat(user, SPAN_DAN69ER("The 69ibber is locked and runnin69, wait for it to finish."))
		return

	if(!(iscarbon(victim)) && !(isanimal(victim)) )
		to_chat(user, SPAN_DAN69ER("This is not suitable for the 69ibber!"))
		return

	if(ishuman(victim) && !ema6969ed)
		to_chat(user, SPAN_DAN69ER("The 69ibber safety 69uard is en69a69ed!"))
		return


	if(victim.abiotic(1))
		to_chat(user, SPAN_DAN69ER("Subject69ay not have abiotic items on."))
		return

	user.visible_messa69e(SPAN_DAN69ER("69user69 starts to put 69victim69 into the 69ibber!"))
	src.add_fin69erprint(user)
	if(do_after(user, 30, src) &&69ictim.Adjacent(src) && user.Adjacent(src) &&69ictim.Adjacent(user) && !occupant)
		user.visible_messa69e(SPAN_DAN69ER("\The 69user69 stuffs \the 69victim69 into the 69ibber!"))
		victim.forceMove(src)
		victim.reset_view(src)
		src.occupant =69ictim
		update_icon()

/obj/machinery/69ibber/verb/eject()
	set cate69ory = "Object"
	set name = "Empty 69ibber"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.69o_out()
	add_fin69erprint(usr)
	return

/obj/machinery/69ibber/proc/69o_out()
	if(operatin69 || !src.occupant)
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective =69OB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	update_icon()
	return


/obj/machinery/69ibber/proc/start69ibbin69(mob/user as69ob)
	if(src.operatin69)
		return
	if(!src.occupant)
		visible_messa69e(SPAN_DAN69ER("You hear a loud69etallic 69rindin69 sound."))
		return
	use_power(1000)
	visible_messa69e(SPAN_DAN69ER("You hear a loud s69uelchy 69rindin69 sound."))
	src.operatin69 = 1
	update_icon()

	var/slab_name = occupant.name
	var/slab_count = 3
	var/slab_type = /obj/item/rea69ent_containers/food/snacks/meat
	var/slab_nutrition = 20
	if(iscarbon(occupant))
		var/mob/livin69/carbon/C = occupant
		slab_nutrition = C.nutrition / 15

	// Some69obs have specific69eat item types.
	if(isanimal(src.occupant))
		var/mob/livin69/simple_animal/critter = src.occupant
		if(critter.meat_amount)
			slab_count = critter.meat_amount
		if(critter.meat_type)
			slab_type = critter.meat_type

	else if(isroach(occupant))
		var/mob/livin69/carbon/superior_animal/roach/H = occupant
		slab_type = H.meat_type
		slab_count = H.meat_amount

	else if(ishuman(occupant))
		var/mob/livin69/carbon/human/H = occupant
		slab_name = src.occupant.real_name
		slab_type = H.species.meat_type

	// Small69obs don't 69ive as69uch nutrition.
	if(issmall(src.occupant))
		slab_nutrition *= 0.5
	slab_nutrition /= slab_count

	for(var/i=1 to slab_count)
		var/obj/item/rea69ent_containers/food/snacks/meat/new_meat = new slab_type(src)
		new_meat.name = "69slab_name69 69new_meat.name69"
		new_meat.rea69ents.add_rea69ent("nutriment",slab_nutrition)

		if(src.occupant.rea69ents)
			src.occupant.rea69ents.trans_to_obj(new_meat, round(occupant.rea69ents.total_volume/slab_count,1))

	src.occupant.attack_lo69 += "\6969time_stamp()69\69 Was 69ibbed by <b>69user69/69user.ckey69</b>" //One shall not simply 69ib a69ob unnoticed!
	user.attack_lo69 += "\6969time_stamp()69\69 69ibbed <b>69src.occupant69/69src.occupant.ckey69</b>"
	ms69_admin_attack("69user.name69 (69user.ckey69) 69ibbed 69src.occupant69 (69src.occupant.ckey69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

	src.occupant.69hostize()

	spawn(69ib_time)

		src.operatin69 = 0
		src.occupant.69ib()
		69del(src.occupant)

		playsound(src.loc, 'sound/effects/splat.o6969', 50, 1)
		operatin69 = 0
		for (var/obj/thin69 in contents)
			// Todo: unify limbs and internal or69ans
			// There's a chance that the 69ibber will fail to destroy some evidence.
			if((istype(thin69,/obj/item/or69an) || istype(thin69,/obj/item/or69an)) && prob(80))
				69del(thin69)
				continue
			thin69.loc = 69et_turf(thin69) // Drop it onto the turf for throwin69.
			thin69.throw_at(69et_ed69e_tar69et_turf(src,69ib_throw_dir),rand(0,3),ema6969ed ? 100 : 50) // Bein69 pelted with bits of69eat and bone would hurt.

		update_icon()


