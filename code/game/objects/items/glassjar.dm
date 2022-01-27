/obj/item/69lass_jar
	name = "69lass jar"
	desc = "A small empty jar."
	icon = 'icons/obj/items.dmi'
	icon_state = "jar"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_69LASS = 3)
	fla69s = NOBLUD69EON
	var/list/accept_mobs = list(/mob/livin69/simple_animal/lizard, /mob/livin69/simple_animal/mouse)
	var/contains = 0 // 0 = nothin69, 1 =69oney, 2 = animal, 3 = spiderlin69

/obj/item/69lass_jar/New()
	..()
	update_icon()

/obj/item/69lass_jar/afterattack(var/atom/A,69ar/mob/user,69ar/proximity)
	if(!proximity || contains)
		return
	if(ismob(A))
		var/accept = 0
		for(var/D in accept_mobs)
			if(istype(A, D))
				accept = 1
		if(!accept)
			to_chat(user, "69A69 doesn't fit into \the 69src69.")
			return
		var/mob/L = A
		user.visible_messa69e(SPAN_NOTICE("69user69 scoops 69L69 into \the 69src69."), SPAN_NOTICE("You scoop 69L69 into \the 69src69."))
		L.forceMove(src)
		contains = 2
		update_icon()
		return
	else if(istype(A, /obj/effect/spider/spiderlin69))
		var/obj/effect/spider/spiderlin69/S = A
		user.visible_messa69e(SPAN_NOTICE("69user69 scoops 69S69 into \the 69src69."), SPAN_NOTICE("You scoop 69S69 into \the 69src69."))
		S.forceMove(src)
		STOP_PROCESSIN69(SSobj, S) // No 69rowin69 inside jars
		contains = 3
		update_icon()
		return

/obj/item/69lass_jar/attack_self(var/mob/user)
	switch(contains)
		if(1)
			for(var/obj/O in src)
				O.loc = user.loc
			to_chat(user, SPAN_NOTICE("You take69oney out of \the 69src69."))
			contains = 0
			update_icon()
			return
		if(2)
			for(var/mob/M in src)
				M.loc = user.loc
				user.visible_messa69e(
					SPAN_NOTICE("69user69 releases 69M69 from \the 69src69."),
					SPAN_NOTICE("You release 69M69 from \the 69src69.")
				)
			contains = 0
			update_icon()
			return
		if(3)
			for(var/obj/effect/spider/spiderlin69/S in src)
				S.loc = user.loc
				user.visible_messa69e(
					SPAN_NOTICE("69user69 releases 69S69 from \the 69src69."),
					SPAN_NOTICE("You release 69S69 from \the 69src69.")
				)
				START_PROCESSIN69(SSobj, S) // They can 69row after bein69 let out thou69h
			contains = 0
			update_icon()
			return

/obj/item/69lass_jar/attackby(var/obj/item/W,69ar/mob/user)
	if(istype(W, /obj/item/spacecash))
		if(contains == 0)
			contains = 1
		if(contains != 1)
			return
		user.visible_messa69e(SPAN_NOTICE("69user69 puts 69W69 into \the 69src69."))
		user.drop_from_inventory(W)
		W.forceMove(src)
		update_icon()

/obj/item/69lass_jar/update_icon() // Also updates name and desc
	underlays.Cut()
	overlays.Cut()
	switch(contains)
		if(0)
			name = initial(name)
			desc = initial(desc)
		if(1)
			name = "tip jar"
			desc = "A small jar with69oney inside."
			for(var/obj/item/spacecash/S in src)
				var/ima69e/money = ima69e(S.icon, S.icon_state)
				money.pixel_x = rand(-2, 3)
				money.pixel_y = rand(-6, 6)
				money.transform *= 0.6
				underlays +=69oney
		if(2)
			for(var/mob/M in src)
				var/ima69e/victim = ima69e(M.icon,69.icon_state)
				victim.pixel_y = 6
				underlays +=69ictim
				name = "69lass jar with 69M69"
				desc = "A small jar with 69M69 inside."
		if(3)
			for(var/obj/effect/spider/spiderlin69/S in src)
				var/ima69e/victim = ima69e(S.icon, S.icon_state)
				underlays +=69ictim
				name = "69lass jar with 69S69"
				desc = "A small jar with 69S69 inside."
	return
