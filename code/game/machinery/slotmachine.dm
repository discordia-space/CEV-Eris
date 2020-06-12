/obj/machinery/slotmachine
	name = "slotmachine"
	desc = "Wasting your credits with style."
	icon = 'icons/obj/slotmachine.dmi'
	icon_state = "slotmachine"
	density = 1
	anchored = 1.0
	var/spinning = 0
	var/bet = 0
	var/jackpot = 0
	var/plays = 0
	var/slots = list()
	var/icon_type
	use_power = 1
	idle_power_usage = 10
	//var/list/fruits = list("Cherry","Apple","Blueberry","Bell","Watermelon","JACKPOT")

/obj/machinery/slotmachine/New()
	..()
	icon_type = initial(icon_state)
	power_change()

/obj/machinery/slotmachine/Initialize()
	. = ..()
	jackpot = rand(20000,50000);
	plays = rand(1,50)
	slots = list("1" = "Seven","2" = "Seven","3" = "Seven")
	update_icon()

/obj/machinery/slotmachine/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "[icon_type]_broken"
	else
		if( !(stat & NOPOWER) )
			icon_state = icon_type
		else
			spawn(rand(0, 15))
				icon_state = "[icon_type]_off"

/obj/machinery/slotmachine/update_icon()
	overlays.Cut()
	//From left to right
	var/offset = -6
	var/image/img
	for(var/slot in slots)
		img = new/image(src.icon, "slot_[slots[slot]]")
		img.pixel_x += offset
		overlays += img
		offset += 6

/obj/machinery/slotmachine/proc/check_win()
	var/win_slot = null
	for(var/slot in slots)
		if(win_slot == null)
			win_slot = slots[slot]
		else if (win_slot != slots[slot])
			return 0
	return 1

/obj/machinery/slotmachine/attack_hand(mob/user as mob)
	if (spinning)
		to_chat(usr, SPAN_WARNING("It is currently spinning."))
		return
	if (bet == 0)
		to_chat(user, SPAN_NOTICE("Today's jackpot: $[jackpot]. Insert 1-1000 Credits."))
	else
		spinning = 1
		plays++
		for(var/slot in slots)
			slots[slot] = "spin"
		update_icon()
		src.visible_message("<b>[name]</b> states, \"Your bet is $[bet]. Goodluck, buddy!\"")
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		icon_state = "[icon_type]_pull"
		update_icon()
		var/last_slot = null
		for(var/slot in slots)
			sleep(10)
			if(prob(plays) && (last_slot != null))
				plays = 0
				slots[slot] = last_slot
			else
				slots[slot] = pick("Seven", "Diamond", "Cherry","Bar","Lemon","Heart","Watermelon")
				last_slot = slots[slot]
			icon_state = "[icon_type]"
			update_icon()
			visible_message(SPAN_NOTICE("The reel stops at... \the [slots[slot]]!"))
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 1)
		sleep(5)
		if (check_win())
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 1)
			var/list/fruits = list("Diamond" = 10, "Heart" = 8, "Cherry" = 8,"Bar" = 6,"Lemon" = 4, "Watermelon" = 2, "Seven" = 1)
			var/prize = bet*fruits[slots["1"]]
			if (slots["1"] == "Seven")
				prize = jackpot
				jackpot = 0
				src.visible_message("<b>[name]</b> states, \"Damn son! JACKPOT!!! Congratulations!\"")
			else
				src.visible_message("<b>[name]</b> states, \"Congratulations! You won [prize] Credits!\"")
			spawn_money(prize,src.loc,user)
		else
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
			src.visible_message("<b>[name]</b> states, \"Sorry, maybe, next time..\"")
			jackpot += bet

	src.add_fingerprint(user)
	update_icon()
	bet = 0
	spinning = 0

/obj/machinery/slotmachine/attackby(obj/item/S as obj, mob/user as mob)
	if (spinning)
		return
	if (istype(S, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/cash = S
		if ((cash.worth > 0) && (cash.worth<=1000) && (bet + cash.worth <= 1000))
			user << "<span class='info'>You insert [cash.worth] Credits into [src].</span>"
			bet += cash.worth
			user.drop_from_inventory(cash)
			qdel(cash)
		else
			user << "\red You must bet 1-1000 Credits!"
	else if (istype(S, /obj/item/weapon/coin))
		user << SPAN_NOTICE("You add the [S.name] into the [src]. It will slightly increase chance to win.")
		user.drop_from_inventory(S)
		bet = 100
		plays = 45
		qdel(S)
	src.add_fingerprint(user)
	return
