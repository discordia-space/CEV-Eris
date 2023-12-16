//Not the shower you are looking for
//Try watercloset.dm

/obj/machinery/cellshower
	name = "P.A.I.N. dispenser"
	desc = "Pacification And INdignity dispenser."
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
		qdel(S)
	effect = null
	return ..()

/obj/machinery/cellshower/attackby(obj/item/I as obj, mob/user as mob)
	if(QUALITY_PULSING in I.tool_qualities)
		to_chat(user, SPAN_NOTICE("The water temperature seems to be [watertemp]."))

/obj/machinery/cellshower/Process()
	for(var/obj/effect/shower/S in effect)
		S.Process()

/obj/machinery/cellshower/update_icon()
	for(var/obj/effect/shower/S in effect)
		S.update_icon()

/obj/machinery/cellshower/proc/switchtemp()
	switch(watertemp)
		if("normal")
			watertemp = "freezing"
		if("freezing")
			watertemp = "boiling"
		if("boiling")
			watertemp = "normal"
	update_icon()

/obj/machinery/cellshower/proc/toggle()
	on = !on
	if(on)
		visible_message("<span class='warning'>[src] clicks and distributes some pain.")
		var/obj/machinery/cellshower/targetshower = locate(x, y, z - 1)
		for(var/turf/T in RANGE_TURFS(1, targetshower))
			if(T.density)
				continue
			var/obj/effect/shower/S = new(T)
			S.master = src
			effect += S
	update_icon()

/obj/machinery/cellshower/proc/spray()
	visible_message("<span class='warning'>[src] clicks and distributes some pain.")
	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1)
	var/obj/machinery/cellshower/targetshower = locate(x, y, z - 1)
	for(var/turf/T in RANGE_TURFS(1, targetshower))
		if(T.density)
			continue
		spawn(0)
			var/obj/effect/effect/water/chempuff/D = new(locate(x, y, z - 1))
			D.create_reagents(5)
			D.reagents.add_reagent("condensedcapsaicin", 5)
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
	for(var/mob/living/carbon/C in src.loc)
		wash(C)
		check_heat(C)
	for (var/atom/movable/G in src.loc)
		G.clean_blood()

/obj/effect/shower/Destroy()
	mymist = null
	master = null
	return ..()

/obj/effect/shower/update_icon()
	overlays.Cut()
	if(mymist)
		qdel(mymist)
		mymist = null

	if(master && master.on)
		overlays += image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir)
		if(master.watertemp == "freezing")
			return
		if(!ismist)
			spawn(50)
				if(src && master.on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		mymist = new /obj/effect/mist(loc)
		spawn(150)
			if(src && !master || !master.on)
				ismist = 0
				qdel(mymist)
				mymist = null
				qdel(src)

//Yes, showers are super powerful as far as washing goes.
/obj/effect/shower/proc/wash(atom/movable/O as obj|mob)
	if(!master || !master.on)
		return

	if(isliving(O))
		var/mob/living/L = O
		L.ExtinguishMob()
		L.fire_stacks = -20 //Douse ourselves with water to avoid fire more easily
		to_chat(L, SPAN_WARNING("You've been drenched in water!"))
		if(iscarbon(O))
			var/mob/living/carbon/M = O
			if(M.r_hand)
				M.r_hand.clean_blood()
			if(M.l_hand)
				M.l_hand.clean_blood()
			if(M.back)
				if(M.back.clean_blood())
					M.update_inv_back(0)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/washgloves = 1
				var/washshoes = 1
				var/washmask = 1
				var/washears = 1
				var/washglasses = 1

				if(H.wear_suit)
					washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
					washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

				if(H.head)
					washmask = !(H.head.flags_inv & HIDEMASK)
					washglasses = !(H.head.flags_inv & HIDEEYES)
					washears = !(H.head.flags_inv & HIDEEARS)

				if(H.wear_mask)
					if (washears)
						washears = !(H.wear_mask.flags_inv & HIDEEARS)
					if (washglasses)
						washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

				if(H.head)
					if(H.head.clean_blood())
						H.update_inv_head(0)
				if(H.wear_suit)
					if(H.wear_suit.clean_blood())
						H.update_inv_wear_suit(0)
				else if(H.w_uniform)
					if(H.w_uniform.clean_blood())
						H.update_inv_w_uniform(0)
				if(H.gloves && washgloves)
					if(H.gloves.clean_blood())
						H.update_inv_gloves(0)
				if(H.shoes && washshoes)
					if(H.shoes.clean_blood())
						H.update_inv_shoes(0)
				if(H.wear_mask && washmask)
					if(H.wear_mask.clean_blood())
						H.update_inv_wear_mask(0)
				if(H.glasses && washglasses)
					if(H.glasses.clean_blood())
						H.update_inv_glasses(0)
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
				if(M.wear_mask)						//if the mob is not human, it cleans the mask without asking for bitflags
					if(M.wear_mask.clean_blood())
						M.update_inv_wear_mask(0)
		else
			O.clean_blood()

	if(isturf(loc))
		var/turf/tile = loc
		loc.clean_blood()
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				qdel(E)

/obj/effect/shower/Process()
	if(!master ||!master.on)
		return
	for(var/mob/living/carbon/C in loc)
		check_heat(C)

/obj/effect/shower/proc/check_heat(mob/M as mob)
	if(!master || !master.on || master.watertemp == "normal")
		return
	if(iscarbon(M))
		var/mob/living/carbon/C = M

		if(master.watertemp == "freezing")
			C.bodytemperature = max(80, C.bodytemperature - 80)
			to_chat(C, SPAN_WARNING("The water is freezing!"))
			return
		if(master.watertemp == "boiling")
			C.bodytemperature = min(500, C.bodytemperature + 35)
			C.adjustFireLoss(5)
			to_chat(C, SPAN_DANGER("The water is searing!"))
			return
//cyka blyat
