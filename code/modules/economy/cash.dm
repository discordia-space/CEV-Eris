#define CASH_PER_STAT 5000 // The cost of a single level of a statistic

/obj/item/spacecash
	name = "coin"
	desc = "It's worth something. Probably."
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash100"
	throw_speed = 1
	throw_range = 2
	volumeClass = ITEM_SIZE_SMALL
	bad_type = /obj/item/spacecash
	weight = 1
	var/worth = 0
	var/maxWorth = 5000

/obj/item/spacecash/get_item_cost(export)
	return worth

/obj/item/spacecash/getWeight()
	return (worth + 1) * initial(weight)

/obj/item/spacecash/proc/updateCashWeight()
	recalculateWeights(getWeight() - weight)

/obj/item/spacecash/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/spacecash) && !istype(W, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/bundle/bundle
		if(istype(W, /obj/item/spacecash/bundle))
			bundle = W
		else
			var/obj/item/spacecash/cash = W
			bundle = new (loc)
			bundle.worth = cash.worth
			user.drop_from_inventory(cash)
			qdel(cash)
		if(bundle.worth == 5000)
			to_chat(user, SPAN_NOTICE("The bundle is already full!"))
			return

		var/drainedWorth = clamp(worth, 0, max(bundle.maxWorth - bundle.worth, 0))

		bundle.worth += drainedWorth
		bundle.updateCashWeight()
		src.worth -= drainedWorth
		updateCashWeight()
		bundle.update_icon()
		update_icon()
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(worth == 0)
				H.drop_from_inventory(src)
			H.drop_from_inventory(bundle)
			H.put_in_hands(bundle)
		to_chat(user, SPAN_NOTICE("You add [drainedWorth] credits worth of money to the bundles.<br>It holds [bundle.worth] credits now."))
		if(worth == 0)
			qdel(src)


/obj/item/spacecash/Destroy()
	. = ..()
	worth = 0 // Prevents money from be duplicated anytime.


/obj/item/spacecash/bundle
	icon_state = ""


/obj/item/spacecash/bundle/update_icon()
	cut_overlays()
	var/remaining_worth = worth
	var/iteration = 0
	var/coins_only = TRUE
	var/list/coin_denominations = list(10, 5, 1)
	var/list/banknote_denominations = list(1000, 500, 200, 100, 50, 20)
	for(var/i in banknote_denominations)
		while(remaining_worth >= i && iteration < 50)
			remaining_worth -= i
			iteration++
			var/image/banknote = image('icons/obj/items.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			banknote.transform = M
			overlays += banknote
			coins_only = FALSE

	if(remaining_worth)
		for(var/i in coin_denominations)
			while(remaining_worth >= i && iteration < 50)
				remaining_worth -= i
				iteration++
				var/image/coin = image('icons/obj/items.dmi', "spacecash[i]")
				var/matrix/M = matrix()
				M.Translate(rand(-6, 6), rand(-4, 8))
				coin.transform = M
				overlays += coin

	if(coins_only)
		if(worth == 1)
			name = "coin"
			desc = "A single credit."
			gender = NEUTER

		else
			name = "coins"
			desc = "Total of [worth] credits."
			gender = PLURAL
	else
		name = "[worth] credits"
		desc = "Cold hard cash."
		gender = NEUTER


/obj/item/spacecash/bundle/attack_self()
	var/amount = input(usr, "How many credits do you want to take? (0 to [worth])", "Take Money", 20) as num
	amount = round(CLAMP(amount, 0, worth))
	if(!amount)
		return

	else if(!Adjacent(usr))
		to_chat(usr, SPAN_WARNING("You need to be in arm's reach for that!"))
		return

	worth -= amount
	recalculateWeights(getWeight() - weight)

	if(!worth)
		usr.drop_from_inventory(src)
		qdel(src)

	var/obj/item/spacecash/bundle/bundle = new (usr.loc)
	bundle.worth = amount
	bundle.updateCashWeight()
	bundle.update_icon()
	usr.put_in_hands(bundle)
	update_icon()


/obj/item/spacecash/bundle/Initialize()
	. = ..()
	update_icon()
	AddComponent(/datum/component/inspiration, CALLBACK(src, PROC_REF(return_stats)))
	updateCashWeight()

/// Returns a list to use with inspirations. It can be empty if there's not enough money in the bundle. Important side-effects: converts worth to points, thus reducing worth.
/obj/item/spacecash/bundle/proc/return_stats()
	RETURN_TYPE(/list)
	var/points = min(worth / CASH_PER_STAT, 30) // capped at 30 points per bundle, costs 150k
	var/list/stats = list()
	// Distribute points evenly with random statistics. Just skips the loop if there's not enough money in the bundle, resulting in an empty list.
	while(points > 0)
		stats[pick(ALL_STATS)] += 1 // Picks a random stat, if not present it adds it with a value of 1, else it increases the value by 1
		points--
	worth -= points * CASH_PER_STAT
	update_icon()
	if(!worth)
		qdel(src)
	return stats


/obj/item/spacecash/bundle/c1
	worth = 1

/obj/item/spacecash/bundle/c5
	worth = 5

/obj/item/spacecash/bundle/c10
	worth = 10

/obj/item/spacecash/bundle/c20
	worth = 20

/obj/item/spacecash/bundle/c50
	worth = 50

/obj/item/spacecash/bundle/c100
	worth = 100

/obj/item/spacecash/bundle/c200
	worth = 200

/obj/item/spacecash/bundle/c500
	worth = 500

// Exists here specifically for vagabond since they do not have bank accounts and used to have around 800 credits.
/obj/item/spacecash/bundle/vagabond/Initialize()
	worth = rand(700, 900)
	. = ..()

/obj/item/spacecash/bundle/c1000
	worth = 1000


/proc/spawn_money(sum, spawnloc, mob/living/carbon/human/H)
	while(sum > 0)
		var/obj/item/spacecash/bundle/bundle = new(spawnloc)
		bundle.worth = clamp(sum, 0, 5000)
		sum -= bundle.worth
		bundle.updateCashWeight()
		bundle.update_icon()
		if(istype(H) && !H.get_active_hand())
			H.put_in_hands(bundle)


/obj/item/spacecash/ewallet
	name = "Charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	weight = 50
	var/owner_name = "" // So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/spacecash/ewallet/getWeight()
	return initial(weight)

/obj/item/spacecash/ewallet/examine(mob/user)
	var/description = ""
	if(user in view(2) || user == loc)
		description += span_blue("Charge card's owner: [owner_name]. Credits remaining: [worth].")
	..(user, afterDesc = description)


#undef CASH_PER_STAT
