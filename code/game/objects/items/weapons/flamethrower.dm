/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	flags = CONDUCT | NOBLUDGEON
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 2, TECH_PLASMA = 1)
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_STEEL = 5)
	var/throw_amount = 50
	var/lit = FALSE	//on or off
	var/operating = 0//cooldown
	var/turf/previousturf = null
	var/obj/item/tank/plasma/ptank = null

	var/flamerange = 2
	var/gas_mult = 2.5


/obj/item/flamethrower/Destroy()
	if(ptank)
		69del(ptank)

	return ..()


/obj/item/flamethrower/Process()
	if(ptank.air_contents.gas69"plasma"69 < 1)
		lit = FALSE
		STOP_PROCESSING(SSobj, src)
		var/turf/T = get_turf(src)
		T.visible_message(SPAN_WARNING("The flame on \the 69src69 went out."))
		update_icon()
		return
	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src ||69.r_hand == src)
			location =69.loc
	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)
	return


/obj/item/flamethrower/update_icon()
	cut_overlays()
	if(ptank)
		overlays += "+ptank"
	if(lit)
		overlays += "+lit"
	return

/obj/item/flamethrower/afterattack(atom/target,69ob/user, proximity)
	if (!lit)
		to_chat(user, SPAN_WARNING("You press the trigger but nothing happens."))
	if (istype(target,/obj/item) && user == target.get_holding_mob())
		return
	if (get_dist(target, user) <= flamerange)
		//69ake sure our user is still holding us
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getline(user, target_turf)
			flame_turf(turflist)

/obj/item/flamethrower/attackby(obj/item/W as obj,69ob/user as69ob)
	if(user.stat || user.restrained() || user.lying)	return

	if(istype(W,/obj/item/tank/plasma))
		if(ptank)
			to_chat(user, SPAN_NOTICE("There appears to already be a plasma tank loaded in 69src69!"))
			return
		user.drop_item()
		ptank = W
		W.loc = src
		update_icon()
		return
	..()
	return


/obj/item/flamethrower/attack_self(mob/user as69ob)
	if(user.stat || user.restrained() || user.lying)	return
	user.set_machine(src)
	var/dat = text("<TT><B>Flamethrower (<A HREF='?src=\ref69src69;light=1'>69!lit ? "<font color='red'>Ignite</font>" : "Extinguish"69</a>)</B><BR>\n 69ptank ? "Tank Pressure: 69ptank.air_contents.return_pressure()69" : "No tank installed"69<BR>\nAmount to throw: <A HREF='?src=\ref69src69;amount=-100'>-</A> <A HREF='?src=\ref69src69;amount=-10'>-</A> <A HREF='?src=\ref69src69;amount=-1'>-</A> 69throw_amount69 <A HREF='?src=\ref69src69;amount=1'>+</A> <A HREF='?src=\ref69src69;amount=10'>+</A> <A HREF='?src=\ref69src69;amount=100'>+</A><BR>\n69ptank ? "<A HREF='?src=\ref69src69;remove=1'>Remove plasmatank</A> - " : ""69<A HREF='?src=\ref69src69;close=1'>Close</A></TT>")
	user << browse(dat, "window=flamethrower;size=340x160")
	onclose(user, "flamethrower")
	return


/obj/item/flamethrower/Topic(href,href_list6969)
	if(href_list69"close"69)
		usr.unset_machine()
		usr << browse(null, "window=flamethrower")
		return
	if(usr.stat || usr.restrained() || usr.lying)	return
	usr.set_machine(src)
	if(href_list69"light"69)
		if(!ptank || ptank.air_contents.gas69"plasma"69 < 1)
			to_chat(usr, SPAN_WARNING("You press the ignite button but nothing happens."))
			return
		lit = !lit
		if (lit)
			usr.visible_message(SPAN_WARNING("\The 69usr69 ignites \the 69src69."), SPAN_WARNING("You ignite \the 69src69."), "You hear sparking.")
			playsound(src.loc, 'sound/effects/sparks4.ogg', 50, 1)
			START_PROCESSING(SSobj, src)
		else
			usr.visible_message(SPAN_NOTICE("\The 69usr69 extinguish \the 69src69."), SPAN_NOTICE("You extinguish \the 69src69."))
			STOP_PROCESSING(SSobj, src)

	if(href_list69"amount"69)
		throw_amount = throw_amount + text2num(href_list69"amount"69)
		throw_amount =69ax(50,69in(5000, throw_amount))
	if(href_list69"remove"69)
		if(!ptank)	return
		to_chat(usr, SPAN_NOTICE("You remove \the 69ptank69."))
		usr.put_in_hands(ptank)
		ptank = null
		lit = 0
		usr.unset_machine()
		usr << browse(null, "window=flamethrower")
	for(var/mob/M in69iewers(1, loc))
		if((M.client &&69.machine == src))
			attack_self(M)
	update_icon()
	return


//Called from turf.dm turf/dblclick
/obj/item/flamethrower/proc/flame_turf(var/list/turflist)
	if(!lit || operating)	return
	operating = 1
	for(var/turf/T in turflist)
		if(T.density || istype(T, /turf/space))
			break
		if(!previousturf && length(turflist)>1)
			previousturf = get_turf(src)
			continue	//so we don't burn the tile we be standin on
		if(previousturf && LinkBlocked(previousturf, T))
			break
		ignite_turf(T)
		sleep(1)
	previousturf = null
	operating = 0
	for(var/mob/M in69iewers(1, loc))
		if((M.client &&69.machine == src))
			attack_self(M)
	return


/obj/item/flamethrower/proc/ignite_turf(turf/target)
	//TODO: DEFERRED Consider checking to69ake sure tank pressure is high enough before doing this...
	//Transfer 5% of current tank air contents to turf
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(0.02*(throw_amount/100))

	new/obj/effect/decal/cleanable/li69uid_fuel/flamethrower_fuel(target,air_transfer.gas69"plasma"69*gas_mult,get_dir(loc,target), get_turf(src))
	69del(air_transfer)
	//Burn it based on transfered gas
	target.hotspot_expose((ptank.air_contents.temperature*2) + 380,500) // --69ore of69y "how do I shot fire?" dickery. -- TLE
	return

/obj/item/flamethrower/full/New(var/loc)
	..()
	ptank = new /obj/item/tank/plasma/(src)
	update_icon()
	return
