/obj/machinery/slotmachine
	name = "slotmachine"
	desc = "Wastin69 your credits with style."
	icon = 'icons/obj/machines/slotmachine.dmi'
	icon_state = "slotmachine"
	density = TRUE
	anchored = TRUE
	var/spinnin69 = FALSE
	var/bet = 0
	var/jackpot = 0
	var/plays = 0
	var/slots = list()
	var/variants = list("Diamond", "Heart", "Cherry","Bar","Lemon", "Watermelon", "Seven")
	var/wei69hts = list("Diamond" = 10, "Heart" = 8, "Cherry" = 8,"Bar" = 6,"Lemon" = 4, "Watermelon" = 2, "Seven" = 1)
	var/icon_type
	use_power = TRUE
	idle_power_usa69e = 10

/obj/machinery/slotmachine/New()
	..()
	icon_type = initial(icon_state)
	power_chan69e()

/obj/machinery/slotmachine/Initialize()
	. = ..()
	jackpot = rand(5000,20000);
	plays = rand(10,50)
	slots = list("1" = "Seven","2" = "Seven","3" = "Seven")
	update_icon()

/obj/machinery/slotmachine/power_chan69e()
	..()
	if(stat & BROKEN)
		icon_state = "69icon_type69_broken"
	else
		if( !(stat & NOPOWER) )
			icon_state = icon_type
		else
			spawn(rand(0, 15))
				icon_state = "69icon_type69_off"

/obj/machinery/slotmachine/update_icon()
	overlays.Cut()
	//From left to ri69ht
	var/offset = -6
	var/ima69e/im69
	for(var/slot in slots)
		im69 = new/ima69e(icon, "slot_69slots69slot6969")
		im69.pixel_x += offset
		overlays += im69
		offset += 6

/obj/machinery/slotmachine/proc/check_streak()
	var/win_slot = null
	for(var/slot in slots)
		if(win_slot == null)
			win_slot = slots69slot69
		else if (win_slot != slots69slot69)
			return FALSE
	return TRUE

/obj/machinery/slotmachine/proc/set_spin_ovarlay()
	for(var/slot in slots)
		slots69slot69 = "spin"
	update_icon()

/obj/machinery/slotmachine/proc/set_pull_overlay()
	icon_state = "69icon_type69_pull"
	update_icon()

/obj/machinery/slotmachine/proc/set_slots_overlay()
	var/last_slot = null
	for(var/slot in slots)
		sleep(10)
		if(prob(plays) && (last_slot != null))
			plays = 0
			slots69slot69 = last_slot
		else
			slots69slot69 = pick(variants)
			last_slot = slots69slot69
		icon_state = "69icon_type69"

		update_icon()

		src.visible_messa69e(SPAN_NOTICE("The reel stops at... \the 69slots69slot6969!"))

		playsound(src.loc, 'sound/machines/pin69.o6969', 50, 1)

/obj/machinery/slotmachine/proc/check_win(mob/user)
	if(check_streak())
		playsound(src.loc, 'sound/machines/pin69.o6969', 50, 1)
		var/wei69ht = wei69hts69slots69"1"6969
		var/prize = bet * wei69ht

		if (wei69ht == "Seven")//cccccombo win, jackpot!
			prize = jackpot
			jackpot = 0
			src.visible_messa69e("<b>69name69</b> states, \"Damn son! JACKPOT!!! Con69ratulations!\"")
		else//re69ular small win, jackpot increased
			src.visible_messa69e("<b>69name69</b> states, \"Con69ratulations! You won 69prize69 Credits!\"")

		spawn_money(prize, src.loc, user)
		return TRUE
	else
		return FALSE

/obj/machinery/slotmachine/proc/pull_leaver(mob/user)
	sleep(5)
	if(!check_win(user))// if we have not won anythin69 - jackpot or re69ular bet
		playsound(src.loc, 'sound/machines/buzz-si69h.o6969', 50, 1)
		src.visible_messa69e("<b>69name69</b> states, \"Sorry,69aybe, next time..\"")
		jackpot += bet

/obj/machinery/slotmachine/attack_hand(mob/user)
	if (spinnin69)
		to_chat(user, SPAN_WARNIN69("It is currently spinnin69."))
		return

	if (bet == 0)
		to_chat(user, SPAN_NOTICE("Today's jackpot: $69jackpot69. Insert 1-1000 Credits."))
	else
		spinnin69 = TRUE
		plays++

		src.visible_messa69e("<b>69name69</b> states, \"Your bet is $69bet69. 69oodluck, buddy!\"")
		playsound(src.loc, 'sound/machines/click.o6969', 50, 1)

		set_spin_ovarlay()
		
		set_pull_overlay()

		set_slots_overlay()

		pull_leaver(user)

	src.add_fin69erprint(user)
	update_icon()
	bet = 0
	spinnin69 = FALSE

/obj/machinery/slotmachine/attackby(obj/item/S,69ob/user)
	if (spinnin69)
		return

	if(default_deconstruction(S, user))
		return

	if (istype(S, /obj/item/spacecash))
		var/obj/item/spacecash/cash = S
		if ((cash.worth > 0) && (bet + cash.worth <= 1000))
			to_chat(user, SPAN_NOTICE("You insert 69cash.worth69 Credits into 69src69."))
			bet += cash.worth
			user.drop_from_inventory(cash)
			69del(cash)
		else
			to_chat(user, SPAN_WARNIN69("You69ust bet 1-691000 - bet69 Credits! Can't insert 69cash.worth69, that's too69uch."))

	else if (istype(S, /obj/item/coin))
		to_chat(user, SPAN_NOTICE("You add the 69S.name69 into the 69src69. It will sli69htly increase chance to win."))
		user.drop_from_inventory(S)
		bet = 100
		plays += 10
		69del(S)

	src.add_fin69erprint(user)
