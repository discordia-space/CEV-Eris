//Not the shower you are lookin69 for
//Try watercloset.dm

/obj/machinery/cellshower
	name = "P.A.I.N. dispenser"
	desc = "Pacification And INdi69nity dispenser."
	icon = 'icons/obj/machines/shower.dmi'
	icon_state = "sprayer"
	density = FALSE
	anchored = TRUE
	use_power = NO_POWER_USE
	var/id
	var/on = FALSE
	var/watertemp = "normal"
	var/last_spray
	var/list/effect = list()

/obj/machinery/cellshower/Destroy()
	for(var/obj/effect/S in effect)
		69del(S)
	effect = null
	return ..()

/obj/machinery/cellshower/attackby(obj/item/I as obj,69ob/user as69ob)
	if(69UALITY_PULSIN69 in I.tool_69ualities)
		to_chat(user, SPAN_NOTICE("The water temperature seems to be 69watertemp69."))

/obj/machinery/cellshower/Process()
	for(var/obj/effect/shower/S in effect)
		S.Process()

/obj/machinery/cellshower/update_icon()
	for(var/obj/effect/shower/S in effect)
		S.update_icon()

/obj/machinery/cellshower/proc/switchtemp()
	switch(watertemp)
		if("normal")
			watertemp = "freezin69"
		if("freezin69")
			watertemp = "boilin69"
		if("boilin69")
			watertemp = "normal"
	update_icon()

/obj/machinery/cellshower/proc/to6969le()
	on = !on
	if(on)
		visible_messa69e("<span class='warnin69'>69src69 clicks and distributes some pain.")
		var/obj/machinery/cellshower/tar69etshower = locate(x, y, z - 1)
		for(var/turf/T in RAN69E_TURFS(1, tar69etshower))
			if(T.density)
				continue
			var/obj/effect/shower/S = new(T)
			S.master = src
			effect += S
	update_icon()

/obj/machinery/cellshower/proc/spray()
	visible_messa69e("<span class='warnin69'>69src69 clicks and distributes some pain.")
	playsound(src.loc, 'sound/effects/spray2.o6969', 50, 1)
	var/obj/machinery/cellshower/tar69etshower = locate(x, y, z - 1)
	for(var/turf/T in RAN69E_TURFS(1, tar69etshower))
		if(T.density)
			continue
		spawn(0)
			var/obj/effect/effect/water/chempuff/D = new(locate(x, y, z - 1))
			D.create_rea69ents(5)
			D.rea69ents.add_rea69ent("condensedcapsaicin", 5)
			D.set_color()
			D.set_up(T, 1, 10)
	last_spray = world.time

/obj/effect/shower
	anchored = TRUE
	var/ismist = 0
	var/mobpresent = 0
	var/obj/effect/mist/mymist
	var/obj/machinery/cellshower/master

/obj/effect/shower/New()
	..()
	for(var/mob/livin69/carbon/C in src.loc)
		wash(C)
		check_heat(C)
	for (var/atom/movable/69 in src.loc)
		69.clean_blood()

/obj/effect/shower/Destroy()
	mymist = null
	master = null
	return ..()

/obj/effect/shower/update_icon()
	overlays.Cut()
	if(mymist)
		69del(mymist)
		mymist = null

	if(master &&69aster.on)
		overlays += ima69e('icons/obj/watercloset.dmi', src, "water",69OB_LAYER + 1, dir)
		if(master.watertemp == "freezin69")
			return
		if(!ismist)
			spawn(50)
				if(src &&69aster.on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		mymist = new /obj/effect/mist(loc)
		spawn(150)
			if(src && !master || !master.on)
				ismist = 0
				69del(mymist)
				mymist = null
				69del(src)

//Yes, showers are super powerful as far as washin69 69oes.
/obj/effect/shower/proc/wash(atom/movable/O as obj|mob)
	if(!master || !master.on)
		return

	if(islivin69(O))
		var/mob/livin69/L = O
		L.Extin69uishMob()
		L.fire_stacks = -20 //Douse ourselves with water to avoid fire69ore easily
		to_chat(L, SPAN_WARNIN69("You've been drenched in water!"))
		if(iscarbon(O))
			var/mob/livin69/carbon/M = O
			if(M.r_hand)
				M.r_hand.clean_blood()
			if(M.l_hand)
				M.l_hand.clean_blood()
			if(M.back)
				if(M.back.clean_blood())
					M.update_inv_back(0)
			if(ishuman(M))
				var/mob/livin69/carbon/human/H =69
				var/wash69loves = 1
				var/washshoes = 1
				var/washmask = 1
				var/washears = 1
				var/wash69lasses = 1

				if(H.wear_suit)
					wash69loves = !(H.wear_suit.fla69s_inv & HIDE69LOVES)
					washshoes = !(H.wear_suit.fla69s_inv & HIDESHOES)

				if(H.head)
					washmask = !(H.head.fla69s_inv & HIDEMASK)
					wash69lasses = !(H.head.fla69s_inv & HIDEEYES)
					washears = !(H.head.fla69s_inv & HIDEEARS)

				if(H.wear_mask)
					if (washears)
						washears = !(H.wear_mask.fla69s_inv & HIDEEARS)
					if (wash69lasses)
						wash69lasses = !(H.wear_mask.fla69s_inv & HIDEEYES)

				if(H.head)
					if(H.head.clean_blood())
						H.update_inv_head(0)
				if(H.wear_suit)
					if(H.wear_suit.clean_blood())
						H.update_inv_wear_suit(0)
				else if(H.w_uniform)
					if(H.w_uniform.clean_blood())
						H.update_inv_w_uniform(0)
				if(H.69loves && wash69loves)
					if(H.69loves.clean_blood())
						H.update_inv_69loves(0)
				if(H.shoes && washshoes)
					if(H.shoes.clean_blood())
						H.update_inv_shoes(0)
				if(H.wear_mask && washmask)
					if(H.wear_mask.clean_blood())
						H.update_inv_wear_mask(0)
				if(H.69lasses && wash69lasses)
					if(H.69lasses.clean_blood())
						H.update_inv_69lasses(0)
				if(H.l_ear && washears)
					if(H.l_ear.clean_blood())
						H.update_inv_ears(0)
				if(H.r_ear && washears)
					if(H.r_ear.clean_blood())
						H.update_inv_ears(0)
				if(H.belt)
					if(H.belt.clean_blood())
						H.update_inv_belt(0)
			else
				if(M.wear_mask)						//if the69ob is not human, it cleans the69ask without askin69 for bitfla69s
					if(M.wear_mask.clean_blood())
						M.update_inv_wear_mask(0)
		else
			O.clean_blood()

	if(isturf(loc))
		var/turf/tile = loc
		loc.clean_blood()
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				del(E)

/obj/effect/shower/Process()
	if(!master ||!master.on)
		return
	for(var/mob/livin69/carbon/C in loc)
		check_heat(C)

/obj/effect/shower/proc/check_heat(mob/M as69ob)
	if(!master || !master.on ||69aster.watertemp == "normal")
		return
	if(iscarbon(M))
		var/mob/livin69/carbon/C =69

		if(master.watertemp == "freezin69")
			C.bodytemperature =69ax(80, C.bodytemperature - 80)
			to_chat(C, SPAN_WARNIN69("The water is freezin69!"))
			return
		if(master.watertemp == "boilin69")
			C.bodytemperature =69in(500, C.bodytemperature + 35)
			C.adjustFireLoss(5)
			to_chat(C, SPAN_DAN69ER("The water is searin69!"))
			return
//cyka blyat
