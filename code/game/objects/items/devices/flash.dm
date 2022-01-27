/obj/item/device/flash
	name = "flash"
	desc = "Used for blindin69 and bein69 an asshole."
	icon_state = "flash"
	item_state = "flashtool"
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_ran69e = 10
	price_ta69 = 300
	fla69s = CONDUCT
	ori69in_tech = list(TECH_MA69NET = 2, TECH_COMBAT = 1)
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_69LASS = 1)
	rarity_value = 25

	var/times_used = 0 //Number of times it's been used.
	var/broken = 0     //Is the flash burnt out?
	var/last_used = 0 //last world.time it was used.

/obj/item/device/flash/proc/clown_check(var/mob/user)
	if(user && (CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNIN69("\The 69src69 slips out of your hand."))
		user.drop_item()
		return 0
	return 1

/obj/item/device/flash/proc/flash_rechar69e()
	//capacitor rechar69es over time
	for(var/i=0, i<3, i++)
		if(last_used+600 > world.time)
			break
		last_used += 600
		times_used -= 2
	last_used = world.time
	times_used =69ax(0,round(times_used)) //sanity

//attack_as_weapon
/obj/item/device/flash/attack(mob/livin69/M,69ob/livin69/user,69ar/tar69et_zone)
	if(!user || !M)	return	//sanity

	M.attack_lo69 += text("\6969time_stamp()69\69 <font color='oran69e'>Has been flashed (attempt) with 69src.name69  by 69user.name69 (69user.ckey69)</font>")
	user.attack_lo69 += text("\6969time_stamp()69\69 <font color='red'>Used the 69src.name69 to flash 69M.name69 (69M.ckey69)</font>")
	ms69_admin_attack("69user.name69 (69user.ckey69) Used the 69src.name69 to flash 69M.name69 (69M.ckey69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	if(!clown_check(user))	return
	if(broken)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is broken."))
		return

	flash_rechar69e()

	//spammin69 the flash before it's fully char69ed (60seconds) increases the chance of it  breakin69
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a69inute it has a 10% chance to break!
				broken = 1
				to_chat(user, SPAN_WARNIN69("The bulb has burnt out!"))
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a69inute
			to_chat(user, SPAN_WARNIN69("*click* *click*"))
			return
	playsound(src.loc, 'sound/weapons/flash.o6969', 100, 1)
	var/flashfail = 0

	if(iscarbon(M))
		if(M.stat!=DEAD)
			var/mob/livin69/carbon/C =69
			var/safety = C.eyecheck()
			if(safety < FLASH_PROTECTION_MODERATE)
				var/flash_stren69th = 10
				if(ishuman(M))
					var/mob/livin69/carbon/human/H =69
					flash_stren69th *= H.species.flash_mod
				if(flash_stren69th > 0)
					M.Weaken(flash_stren69th)
					if (M.HUDtech.Find("flash"))
						flick("e_flash",69.HUDtech69"flash"69)
			else
				flashfail = 1

	else if(isrobot(M))
		M.Weaken(rand(5,10))
		if (M.HUDtech.Find("flash"))
			flick("e_flash",69.HUDtech69"flash"69)
	else
		flashfail = 1

	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			69del(animation)

	if(!flashfail)
		flick("flash2", src)
		if(!issilicon(M))

			user.visible_messa69e("<span class='disarm'>69user69 blinds 69M69 with the flash!</span>")
		else

			user.visible_messa69e(SPAN_NOTICE("69user69 overloads 69M69's sensors with the flash!"))
	else

		user.visible_messa69e(SPAN_NOTICE("69user69 fails to blind 69M69 with the flash!"))

	return




/obj/item/device/flash/attack_self(mob/livin69/carbon/user as69ob, fla69 = 0, emp = 0)
	if(!user || !clown_check(user)) 	return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(broken)
		user.show_messa69e(SPAN_WARNIN69("The 69src.name69 is broken"), 2)
		return

	flash_rechar69e()

	//spammin69 the flash before it's fully char69ed (60seconds) increases the chance of it  breakin69
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))	//if you use it 5 times in a69inute it has a 10% chance to break!
				broken = 1
				to_chat(user, SPAN_WARNIN69("The bulb has burnt out!"))
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a69inute
			user.show_messa69e(SPAN_WARNIN69("*click* *click*"), 2)
			return
	playsound(src.loc, 'sound/weapons/flash.o6969', 100, 1)
	flick("flash2", src)
	if(user && isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			69del(animation)

	for(var/mob/livin69/carbon/M in oviewers(3, null))
		var/safety =69.eyecheck()
		if(safety < FLASH_PROTECTION_MODERATE)
			if(!M.blinded)
				if (M.HUDtech.Find("flash"))
					flick("flash",69.HUDtech69"flash"69)

	return

/obj/item/device/flash/emp_act(severity)
	if(broken)	return
	flash_rechar69e()
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))
				broken = 1
				icon_state = "flashburnt"
				return
			times_used++
			if(iscarbon(loc))
				var/mob/livin69/carbon/M = loc
				var/safety =69.eyecheck()
				if(safety < FLASH_PROTECTION_MODERATE)
					M.Weaken(10)
					if (M.HUDtech.Find("flash"))
						flick("e_flash",69.HUDtech69"flash"69)
					for(var/mob/O in69iewers(M, null))
						O.show_messa69e("<span class='disarm'>69M69 is blinded by the flash!</span>")
	..()
