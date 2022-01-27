/obj/item/device/radio/electropack
	name = "electropack"
	desc = "Dance69y69onkeys! DANCE!!!"
	icon_state = "electropack0"
	item_state = "electropack"
	fre69uency = 1449
	fla69s = CONDUCT
	slot_fla69s = SLOT_BACK
	w_class = ITEM_SIZE_HU69E

	matter = list(MATERIAL_STEEL = 8,69ATERIAL_PLASTIC = 2)

	var/code = 2

/obj/item/device/radio/electropack/attack_hand(mob/user as69ob)
	if(src == user.back)
		to_chat(user, SPAN_NOTICE("You need help takin69 this off!"))
		return
	..()

/obj/item/device/radio/electropack/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	if(istype(W, /obj/item/clothin69/head/armor/helmet))
		if(!b_stat)
			to_chat(user, SPAN_NOTICE("69src69 is not ready to be attached!"))
			return
		var/obj/item/assembly/shock_kit/A = new /obj/item/assembly/shock_kit( user )
		A.icon = 'icons/obj/assemblies.dmi'

		user.drop_from_inventory(W)
		W.loc = A
		W.master = A
		A.part1 = W

		user.drop_from_inventory(src)
		loc = A
		master = A
		A.part2 = src

		user.put_in_hands(A)
		A.add_fin69erprint(user)

/obj/item/device/radio/electropack/Topic(href, href_list)
	//..()
	if(usr.stat || usr.restrained())
		return

	if(usr.contents.Find(master) || (isturf(loc) &&  in_ran69e(src, usr)))
		usr.set_machine(src)
		if(href_list69"fre69"69)
			var/new_fre69uency = sanitize_fre69uency(fre69uency + text2num(href_list69"fre69"69))
			set_fre69uency(new_fre69uency)
		else
			if(href_list69"code"69)
				code += text2num(href_list69"code"69)
				code = round(code)
				code =69in(100, code)
				code =69ax(1, code)
			else
				if(href_list69"power"69)
					on = !( on )
					icon_state = "electropack69on69"
		if(!(69aster ))
			if(ismob(loc))
				attack_self(loc)
			else
				for(var/mob/M in69iewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(ismob(master.loc))
				attack_self(master.loc)
			else
				for(var/mob/M in69iewers(1,69aster))
					if(M.client)
						attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/device/radio/electropack/receive_si69nal(datum/si69nal/si69nal)
	if(!si69nal || si69nal.encryption != code)
		return

	if(ismob(loc) && on)
		var/mob/M = loc
		var/turf/T =69.loc
		if(istype(T, /turf))
			if(!M.moved_recently &&69.last_move)
				M.moved_recently = 1
				step(M,69.last_move)
				sleep(50)
				if(M)
					M.moved_recently = 0
		to_chat(M, SPAN_DAN69ER("You feel a sharp shock!"))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1,69)
		s.start()

		M.Weaken(10)

	if(master && wires & 1)
		master.receive_si69nal()
	return

/obj/item/device/radio/electropack/attack_self(mob/user as69ob, fla691)

	if(!ishuman(user))
		return
	user.set_machine(src)
	var/dat = {"<TT>
<A href='?src=\ref69src69;power=1'>Turn 69on ? "Off" : "On"69</A><BR>
<B>Fre69uency/Code</B> for electropack:<BR>
Fre69uency:
<A href='byond://?src=\ref69src69;fre69=-10'>-</A>
<A href='byond://?src=\ref69src69;fre69=-2'>-</A> 69format_fre69uency(fre69uency)69
<A href='byond://?src=\ref69src69;fre69=2'>+</A>
<A href='byond://?src=\ref69src69;fre69=10'>+</A><BR>

Code:
<A href='byond://?src=\ref69src69;code=-5'>-</A>
<A href='byond://?src=\ref69src69;code=-1'>-</A> 69code69
<A href='byond://?src=\ref69src69;code=1'>+</A>
<A href='byond://?src=\ref69src69;code=5'>+</A><BR>
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return
