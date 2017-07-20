/obj/item/weapon/spacecash
	name = "0 Credit"
	desc = "It's worth 0 Credits."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = 2.0
	var/access = list()
	access = access_crate_cash
	var/worth = 0

/obj/item/weapon/spacecash/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/spacecash))
		if(istype(W, /obj/item/weapon/spacecash/ewallet)) return 0

		var/obj/item/weapon/spacecash/bundle/bundle
		if(!istype(W, /obj/item/weapon/spacecash/bundle))
			var/obj/item/weapon/spacecash/cash = W
			user.drop_from_inventory(cash)
			bundle = new (src.loc)
			bundle.worth += cash.worth
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += src.worth
		bundle.update_icon()
		if(ishuman(user))
			var/mob/living/carbon/human/h_user = user
			h_user.drop_from_inventory(src)
			h_user.drop_from_inventory(bundle)
			h_user.put_in_hands(bundle)
		user << "<span class='notice'>You add [src.worth] Credits worth of money to the bundles.<br>It holds [bundle.worth] Credits now.</span>"
		qdel(src)

/obj/item/weapon/spacecash/bundle
	name = "pile of credits"
	icon_state = ""
	desc = "They are worth 0 Credits."
	worth = 0

/obj/item/weapon/spacecash/bundle/update_icon()
	overlays.Cut()
	var/sum = src.worth
	var/num = 0
	var/list/denominations = list(1000,500,200,100,50,20,10,1)
	for(var/i in denominations)
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/items.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			src.overlays += banknote
	if(num == 0) // Less than one credit, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/items.dmi', "spacecash1")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		src.overlays += banknote
	src.desc = "They are worth [worth] Credits."
	if(worth in denominations)
		src.name = "[worth] Credit"
	else
		src.name = "pile of credits"

/obj/item/weapon/spacecash/bundle/attack_self()
	var/amount = input(usr, "How many Credits do you want to take? (0 to [src.worth])", "Take Money", 20) as num
	amount = round(Clamp(amount, 0, src.worth))
	if(amount==0) return 0

	src.worth -= amount
	src.update_icon()
	if(!worth)
		usr.drop_from_inventory(src)
	if(amount in list(1000,500,200,100,50,20,1))
		var/cashtype = text2path("/obj/item/weapon/spacecash/bundle/c[amount]")
		var/obj/cash = new cashtype (usr.loc)
		usr.put_in_hands(cash)
	else
		var/obj/item/weapon/spacecash/bundle/bundle = new (usr.loc)
		bundle.worth = amount
		bundle.update_icon()
		usr.put_in_hands(bundle)
	if(!worth)
		qdel(src)

/obj/item/weapon/spacecash/bundle/c1
	name = "1 Credit"
	icon_state = "spacecash1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/weapon/spacecash/bundle/c10
	name = "10 Credit"
	icon_state = "spacecash10"
	desc = "It's worth 10 Credits."
	worth = 10

/obj/item/weapon/spacecash/bundle/c20
	name = "20 Credit"
	icon_state = "spacecash20"
	desc = "It's worth 20 Credits."
	worth = 20

/obj/item/weapon/spacecash/bundle/c50
	name = "50 Credit"
	icon_state = "spacecash50"
	desc = "It's worth 50 Credits."
	worth = 50

/obj/item/weapon/spacecash/bundle/c100
	name = "100 Credit"
	icon_state = "spacecash100"
	desc = "It's worth 100 Credits."
	worth = 100

/obj/item/weapon/spacecash/bundle/c200
	name = "200 Credit"
	icon_state = "spacecash200"
	desc = "It's worth 200 Credits."
	worth = 200

/obj/item/weapon/spacecash/bundle/c500
	name = "500 Credit"
	icon_state = "spacecash500"
	desc = "It's worth 500 Credits."
	worth = 500

/obj/item/weapon/spacecash/bundle/c1000
	name = "1000 Credit"
	icon_state = "spacecash1000"
	desc = "It's worth 1000 Credits."
	worth = 1000

proc/spawn_money(var/sum, spawnloc, mob/living/carbon/human/human_user as mob)
	if(sum in list(1000,500,200,100,50,20,10,1))
		var/cash_type = text2path("/obj/item/weapon/spacecash/bundle/c[sum]")
		var/obj/cash = new cash_type (usr.loc)
		if(ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(cash)
	else
		var/obj/item/weapon/spacecash/bundle/bundle = new (spawnloc)
		bundle.worth = sum
		bundle.update_icon()
		if (ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(bundle)
	return

/obj/item/weapon/spacecash/ewallet
	name = "Charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/weapon/spacecash/ewallet/examine(mob/user)
	..(user)
	if (!(user in view(2)) && user!=src.loc) return
	user << "\blue Charge card's owner: [src.owner_name]. Credits remaining: [src.worth]."
