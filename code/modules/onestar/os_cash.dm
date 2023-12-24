// Using stacks since /obj/item/spacecash has no support for different currencies. Shit code, but cash-handling will need a rework to support alt currencies.
/obj/item/stack/os_cash
	name = "One Star Yuan"
	desc = "Offical One Star Yuan coins, used across the ancient empire. Only compatible with One Star vendors."
	icon = 'icons/obj/os_cash.dmi'
	icon_state = "oscash"
	volumeClass = ITEM_SIZE_TINY
	singular_name = "coin"
	amount = 1
	max_amount = 1000
	stacktype = /obj/item/stack/os_cash
	novariants = TRUE					// Skips base /obj/item/stack update_icon() checks
	spawn_blacklisted = TRUE			// Off-ship item
	bad_type = /obj/item/stack/os_cash	// Base type
	price_tag = 10						// 10-to-1 exchange rate with Eris credits

/obj/item/stack/os_cash/update_icon()
	switch(amount)
		if(1)
			icon_state = "[initial(icon_state)]1"
		if(2 to 6)
			icon_state = "[initial(icon_state)]5"
		if(6 to 11)
			icon_state = "[initial(icon_state)]10"
		if(11 to 21)
			icon_state = "[initial(icon_state)]20"
		if(21 to 51)
			icon_state = "[initial(icon_state)]50"
		if(51 to 101)
			icon_state = "[initial(icon_state)]100"
		if(101 to 201)
			icon_state = "[initial(icon_state)]200"
		if(201 to 501)
			icon_state = "[initial(icon_state)]500"
		if(501 to 1001)
			icon_state = "[initial(icon_state)]1000"

	..()

/obj/item/stack/os_cash/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		split_cash(user)
	else
		..()

/obj/item/stack/os_cash/attack_self(mob/user)
	split_cash(user)

/obj/item/stack/os_cash/proc/split_cash(mob/user)
	var/count = input(user, "How many coins do you want to take? (0 to [amount])", "Take Money") as num
	count = round(CLAMP(count, 0, max_amount))

	if(!count)
		return
	else if(!Adjacent(user))
		to_chat(user, SPAN_WARNING("You need to be in arm's reach for that!"))
		return

	amount -= count

	if(!amount)
		user.drop_from_inventory(src)
		qdel(src)

	var/obj/item/stack/os_cash/coin_stack = new (user.loc)
	coin_stack.amount = count
	coin_stack.update_icon()
	user.put_in_hands(coin_stack)
	update_icon()

/obj/item/stack/os_cash/random
	rand_min = 1
	rand_max = 1000

/obj/item/stack/os_cash/full
	amount = 1000
