/obj/structure/railing
	name = "railing"
	desc = "A railing."
	icon = 'icons/obj/railing.dmi'
	density = 1
	layer = 3.2//Just above doors
	//pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1
	flags = ON_BORDER
	icon_state = "railing0"
	//layer = 4.1
	var/broken = 0
	var/health=30
	var/maxhealth=30
	//var/LeftSide = list(0,0,0)// Нужны для хранения данных
	//var/RightSide = list(0,0,0)
	var/check = 0

obj/structure/railing/New()
	if(src.anchored)
		spawn(5)
			update_icon(0)

/obj/structure/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1
//32 и 4 - в той же клетке
//
//
/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	check = 0
	//if (!anchored) return
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)// Анализ клетки, где находится сам объект
		if ((R.dir == Lturn) && R.anchored)//Проверка левой стороны
			//src.LeftSide[1] = 1
			check |= 32
			if (UpdateNeighbors)
				R.update_icon(0)
		if ((R.dir == Rturn) && R.anchored)//Проверка правой стороны
			//src.RightSide[1] = 1
			check |= 2
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, Lturn))//Анализ левой клетки от направления объекта
		if ((R.dir == src.dir) && R.anchored)
			//src.LeftSide[2] = 1
			check |= 16
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Rturn))//Анализ правой клетки от направления объекта
		if ((R.dir == src.dir) && R.anchored)
			//src.RightSide[2] = 1
			check |= 1
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))//Анализ передней-левой диагонали относительно направления объекта.
		if ((R.dir == Rturn) && R.anchored)
			check |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))//Анализ передней-правой диагонали относительно направления объекта.
		if ((R.dir == Lturn) && R.anchored)
			check |= 4
			if (UpdateNeighbors)
				R.update_icon(0)


/*	for(var/obj/structure/railing/R in get_step(src, src.dir))
		if ((R.dir == Lturn) && R.anchored)//Проверка левой стороны
			src.LeftSide[3] = 1
		if ((R.dir == Rturn) && R.anchored)//Проверка правой стороны
			src.RightSide[3] = 1*/
	//check <<"check: [check]"
	//world << "dir = [src.dir]"
	//world << "railing[LeftSide[1]][LeftSide[2]][LeftSide[3]]-[RightSide[1]][RightSide[2]][RightSide[3]]"

/obj/structure/railing/update_icon(var/UpdateNeighgors = 1)
	NeighborsCheck(UpdateNeighgors)
	//icon_state = "railing[LeftSide[1]][LeftSide[2]][LeftSide[3]]-[RightSide[1]][RightSide[2]][RightSide[3]]"
	overlays.Cut()
	if (!check || !anchored)//|| !anchored
		icon_state = "railing0"
	else
		icon_state = "railing1"
		//левая сторона
		if (check & 32)
			overlays += image ('icons/obj/railing.dmi', src, "corneroverlay")
			//world << "32 check"
		if ((check & 16) || !(check & 32) || (check & 64))
			overlays += image ('icons/obj/railing.dmi', src, "frontoverlay_l")
			//world << "16 check"
		if (!(check & 2) || (check & 1) || (check & 4))
			overlays += image ('icons/obj/railing.dmi', src, "frontoverlay_r")
			//world << "no 4 or 2 check"
			if(check & 4)
				switch (src.dir)
					if (NORTH)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_x = 32)
					if (SOUTH)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_x = -32)
					if (EAST)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_y = -32)
					if (WEST)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_y = 32)


//obj/structure/railing/proc/NeighborsCheck2()

/obj/structure/railing/verb/rotate()
	set name = "Rotate Railing Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	set_dir(turn(dir, 90))
	return


/obj/structure/railing/verb/revrotate()
	set name = "Rotate Railing Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	set_dir(turn(dir, -90))
	return

/obj/structure/railing/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/railing/attackby(obj/item/W as obj, mob/user as mob) // Это спижено у стола данного билда
	//if (!W) return

	if(istype(W, /obj/item/weapon/wrench) && !anchored)//разборка
		visible_message("<span class='notice'>[user] dismantles \the [src].</span>")
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
		var/obj/item/stack/material/mats = new /material/steel(loc)
		if (!broken && (health >= (maxhealth/2)))
			mats.amount = 2
		else
			mats.amount = 1
		qdel(src)
		return

	if(istype(W, /obj/item/weapon/weldingtool)) // ремонт
		if (health < maxhealth)
			var/obj/item/weapon/weldingtool/WT = W
			if(!WT.remove_fuel(0,user))
				if(!WT.isOn())
					return
				else
					user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
					return
			health = maxhealth
			visible_message("<span class='notice'>[user] repair \the [src].</span>")
		else
			user << "<span class='notice'>[src] look undamaged</span>"
		return

	if(istype(W, /obj/item/weapon/screwdriver))//установка
		anchored = !anchored
		update_icon()
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		user << (anchored ? "<span class='notice'>You have fastened the [src] to the floor.</span>" : "<span class='notice'>You have unfastened the [src] from the floor.</span>")
		return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				user << "<span class='danger'>There's \a [occupied] in the way.</span>"
				return
			if (G.state < 2)
				if(user.a_intent == I_HURT)
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = "head")
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
					/*var/list/L = take_damage(rand(1,5))
					// Shards. Extra damage, plus potentially the fact YOU LITERALLY HAVE A PIECE OF GLASS/METAL/WHATEVER IN YOUR FACE
					for(var/obj/item/weapon/material/shard/S in L)
						if(prob(50))
							M.visible_message("<span class='danger'>\The [S] slices [M]'s face messily!</span>",
							                   "<span class='danger'>\The [S] slices your face messily!</span>")
							M.apply_damage(10, def_zone = "head")
							if(prob(2))
								M.embed(S, def_zone = "head")*/
				else
					user << "<span class='danger'>You need a better grip to do that!</span>"
					return
			else
				G.affecting.loc = src.loc
				G.affecting.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
			qdel(W)
			return

	// Handle dismantling or placing things on the table from here on.
	if(isrobot(user))
		return

	if(W.loc != user) // This should stop mounted modules ending up outside the module.
		return

	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		//break_to_parts()
		return

	//user.drop_item(src.loc)
	return


/obj/structure/railing/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/railing/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == "disarm")
			if(prob(70))
				visible_message("<span class='notice'>[user] climbs on the [src].</span>")
				if(user.loc == src.loc)
					switch(dir)
						if(SOUTH)
							user.y--
						if(NORTH)
							user.y++
						if(WEST)
							user.x--
						if(EAST)
							user.x++
				else	H.loc = src.loc
					return 1
			else
				sleep(5)
				visible_message("<span class='warning'>[user] slipped off the edge of the [src].</span>")
				usr.weakened += 3

/obj/structure/railing/
