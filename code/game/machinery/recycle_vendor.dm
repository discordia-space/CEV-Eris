/obj/machinery/amerecycler
	name = "recycling and material vendor"
	desc = "Recycle today for a better tomorrow!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "recycle"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 211	//same as softdrinks vendor
	var/vend_power_usage = 500

	var/obj/machinery/amesilo/silo
	var/list/saleworthy_items = list()
	var/sales_paused = FALSE
	var/datum/wires/recycle_vendor/wires
	var/wire_flags = 0
	var/moneyinput


/obj/machinery/amerecycler/New(loc, ...)
	. = ..()
	wires = new(src)
	update_icon()

/obj/machinery/amerecycler/LateInitialize()
	. = ..()
	for(var/machinetocheck in GLOB.machines)
		if(istype(machinetocheck, /obj/machinery/amesilo))
			var/obj/machinery/amesilo/tocheck = machinetocheck
			if(tocheck.prime) // there can only be one.
				var/area/areachecked = get_area(tocheck)
				var/area/my_area = get_area(src)
				if(my_area.vessel != areachecked.vessel) // as long as you're paying taxes in SOME area, it doesn't matter which.
					continue
				silo = tocheck
				silo.linked.Add(src)

/obj/machinery/amerecycler/Destroy()
	qdel(wires)
	eject_stored_item()
	..()


/obj/machinery/amerecycler/update_icon()
	overlays.Cut()
	if(stat & BROKEN)
		icon_state = "recycle_broken"
		return

	icon_state = "recycle"

	if(stat & NOPOWER || !anchored)
		return

	if(!silo || silo?.stat & NOPOWER)
		overlays += "recycle_screen_red"
		overlays += "recycle_button_top_red"
		overlays += "recycle_button_bottom_red"
	else
		overlays += sales_paused				? "recycle_screen_red"			: "recycle_screen_green"
		overlays += silo.materials_stored.len	? "recycle_button_top_green"	: "recycle_button_top_red"
		overlays += silo.budget > 500			? "recycle_button_bottom_green"	: "recycle_button_bottom_red"

	if(panel_open)
		overlays += "recycle_panel"


/obj/machinery/amerecycler/attackby(obj/item/I, mob/living/user)
	if(user.incapacitated() || user.stat || !user.Adjacent(user))
		// TODO: Standardized check for that kind of stuff -- KIROV
		return

	if(BITTEST(wire_flags, WIRE_SHOCK) && shock(user, 100))
		return

	if(user.a_intent != I_HURT)
		var/tool_type = I.get_tool_type(user, list(QUALITY_SCREW_DRIVING), src)
		if(tool_type == QUALITY_SCREW_DRIVING)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				panel_open = !panel_open
				to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance panel."))
				update_icon()
			return

	if(istype(I, /obj/item/spacecash))
		if(istype(I, /obj/item/spacecash/ewallet))
			to_chat(user, SPAN_WARNING("[src] is cash-only."))
			return
		var/obj/item/spacecash/doshdoshdosh = I
		to_chat(user, SPAN_NOTICE("You feed [I] to \the [src]."))
		moneyinput += doshdoshdosh.worth
		qdel(I)
		return TRUE

	if(istype(I, /obj/item/card/id))
		to_chat(user, SPAN_WARNING("[src] is cash-only."))
		return

	if(sales_paused || !user.unEquip(I))
		return

	if(I.contents.len)
		if(istype(I, /obj/item/storage/deferred))
			var/obj/item/storage/deferred/fillinsides
			fillinsides.populate_contents()
		var/success = TRUE
		if(istype(I, /obj/item/storage/secure))
			var/obj/item/storage/secure/lockable = I
			if(lockable.locked)
				to_chat(user, (SPAN_WARNING("[I] is locked.")))
				success = FALSE
		if(success && istype(I, /obj/item/storage))
			var/obj/item/storage/todump = I
			for(var/obj/item/emptyit in todump.contents)
				 // there are better options than to lie when you cannot see a way to get what you want.
				if(evaluate_stored_item(emptyit))
					todump.remove_from_storage(emptyit, src)
				else
					todump.remove_from_storage(emptyit, get_turf(src))

	if(evaluate_stored_item(I))
		I.forceMove(src)
	else
		I.forceMove(get_turf(src))
	update_icon()


/obj/machinery/amerecycler/power_change()
	..()
	update_icon()


/obj/machinery/amerecycler/attack_hand(mob/user)
	if(user.incapacitated() || user.stat || !user.Adjacent(user))
		return

	if(BITTEST(wire_flags, WIRE_SHOCK) && shock(user, 100))
		return

	wires.Interact(user)
	ui_interact(user)


/obj/machinery/amerecycler/AltClick(mob/user)
	if(user.incapacitated() || user.stat || !user.Adjacent(user))
		return

	eject_stored_item()


/obj/machinery/amerecycler/proc/eject_stored_item(obj/stored_item_object)
	if(stored_item_object)
		stored_item_object.forceMove(loc)
		if(stored_item_object in saleworthy_items)
			saleworthy_items.Remove(stored_item_object)
	else
		for(var/obj/item/item in saleworthy_items)
			item.forceMove(loc)
		saleworthy_items.Cut()

	flick("recycle_vend", src)
	update_icon()
	

/obj/machinery/amerecycler/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	sales_paused = TRUE
	to_chat(user, SPAN_NOTICE("[src]'s display flashes red."))
	update_icon()

/obj/machinery/amerecycler/proc/evaluate_stored_item(obj/evaluated)
	if(!silo)
		return FALSE // if there is no silo, it is not stored

	var/valueofitem = 0
	var/list/intermediary = evaluated.get_matter()
	var/matsinitem = intermediary?.Copy()
	for(var/obj/O in evaluated.GetAllContents()) // can now recycle empty shells to get at the contents
		if(length(O.get_matter()))
			matsinitem += O.get_matter()
	if(length(matsinitem) < 1)
		return FALSE
	for(var/i in matsinitem)
		if(!(i in silo.materials_supported)) // determine all materials are suitable
			return FALSE // if it does not contain the right materials, it is not stored
		var/material/mat = get_material_by_name(i)
		var/obj/item/stack/material/M = mat.stack_type
		valueofitem += initial(M.price_tag) * matsinitem[i]
	saleworthy_items[evaluated] = valueofitem // add this to the list
	. = TRUE // and store it


/obj/machinery/amerecycler/proc/recycle_and_pay(obj/itemtorecycle)
	var/combinedvalue = 0
	var/list/stufftorecycle = list()
	if(silo.stat & NOPOWER)
		flick("recycle_screen_red", overlays[1])
		return	
	else if(itemtorecycle)
		stufftorecycle.Add(itemtorecycle)
	else
		stufftorecycle |= saleworthy_items
	if(!length(stufftorecycle))
		return
	for(var/toadd in stufftorecycle)
		combinedvalue += round(saleworthy_items[toadd] * 0.8) // 20% fee on vendor, rounded up.
	if(!combinedvalue || combinedvalue > silo?.my_account.money) // can we afford it all?
		flick("recycle_screen_red", overlays[1])
		if(!BITTEST(wire_flags, WIRE_SPEAKER))
			audible_message("[src] outputs \"Error: Funding Insufficient.\"")
		return
	var/list/combinedmats = list()
	for(var/obj/item/getthisone in stufftorecycle)
		var/list/intermediary = getthisone.get_matter()
		var/list/matter = intermediary?.Copy()
		for(var/obj/O in getthisone.GetAllContents()) // can now recycle empty shells to get at the contents
			if(length(O.get_matter()))
				matter += O.get_matter()
		for(var/toadd in matter)
			combinedmats[toadd] += matter[toadd]
		var/sellvalue = saleworthy_items[getthisone] * 0.8 // 20% fee
		sellvalue = round(sellvalue) // don't make it round and you won't lose your money
		var/datum/transaction/T = new(-sellvalue, "", "Recycling payout for [getthisone.name]", src)
		T.apply_to(silo.my_account)
		qdel(getthisone) // we first add the item to the garbage queue

	if(length(stufftorecycle) > 1)
		saleworthy_items.Cut() // we melted it all, because we could afford it all.
	else
		saleworthy_items.Remove(stufftorecycle[1])
	stufftorecycle = null // then we remove what should be the remaining references
	playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 50, 1)
	silo.addmaterial(combinedmats)
	spawn_money(combinedvalue, loc)
	use_power(vend_power_usage)
	silo.updatesubsidy()
	flick("recycle_vend", src)
	update_icon()

	if(combinedvalue < 50 && prob(10)) // selling less than around 32 sheets worth at a time is awfully small
		speak("Ты бы еще консервных банок насобирал!")

/obj/machinery/amerecycler/proc/recycle_and_output(obj/itemtorecycle)
	if(!silo || silo.stat & NOPOWER)
		flick("recycle_screen_red", overlays[1])
		return
	var/list/stufftorecycle = list()
	if(itemtorecycle)
		stufftorecycle.Add(itemtorecycle)
	else
		stufftorecycle |= saleworthy_items
	if(!length(stufftorecycle))
		return
	var/combinedvalue = 0
	for(var/currentitem in stufftorecycle)
		combinedvalue += CEILING(saleworthy_items[currentitem] / 5, 1) // add all the fees together, rounded as it actually does.
	if(combinedvalue > moneyinput) // if it's too much, cancel it all
		flick("recycle_screen_red", overlays[1])
		if(!BITTEST(wire_flags, WIRE_SPEAKER))
			audible_message("[src] outputs \"Error: Input Insufficient.\"")
		return FALSE
	var/list/totalmaterials = list()
	for(var/obj/currentitem in stufftorecycle)
		var/currentitemsvalue = saleworthy_items[currentitem] // key is item, item value is associated with item
		var/list/intermediary = currentitem.get_matter()
		var/currentitemmaterials = intermediary?.Copy()
		for(var/obj/O in currentitem.GetAllContents()) // can now recycle empty shells to get at the contents
			if(length(O.get_matter()))
				currentitemmaterials += O.get_matter()
		for(var/materialtype in currentitemmaterials) // add them together so they can stack
			var/amount = currentitemmaterials[materialtype]
			totalmaterials[materialtype] += amount
		currentitemsvalue *= 0.2 // 20% fee to recycle
		currentitemsvalue = CEILING(currentitemsvalue, 1) // good luck keeping your money here, although this is still cheaper than rounding twice
		moneyinput -= currentitemsvalue
		var/datum/transaction/T = new(currentitemsvalue, "", "Recycling fee for [currentitem.name]", src)
		T.apply_to(silo.my_account)
		silo.taxdebt += currentitemsvalue/32
		qdel(currentitem) // we first add the item to the garbage queue

	if(length(stufftorecycle) > 1)
		saleworthy_items.Cut() // we melted it all, because we could afford it all.
	else
		saleworthy_items.Remove(stufftorecycle[1])
	stufftorecycle = null // then we remove what should be the remaining references

	for(var/materialtype in totalmaterials) // actually spawn the stacks
		var/amount = totalmaterials[materialtype]
		var/material/materialfound = get_material_by_name(materialtype)
		var/obj/item/stack/material/stackspawned = materialfound.stack_type
		if(stackspawned) // ensure the stack has a type
			var/maxamount = initial(stackspawned.max_amount)
			var/flat = maxamount*round(amount/maxamount) // some are full if this is positive
			var/remainder = amount - flat // and one's not if this is positive
			if(flat)
				for(var/increment = 1, increment < round(amount/maxamount), increment++)
					stackspawned = new materialfound.stack_type(get_turf(src))
					stackspawned.amount = maxamount
					stackspawned.update_strings()
					stackspawned.update_icon()
			if(remainder)
				stackspawned = new materialfound.stack_type(get_turf(src))
				stackspawned.amount = remainder
				stackspawned.update_strings()
				stackspawned.update_icon()		
	flick("recycle_vend", src)

/obj/machinery/amerecycler/Process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!BITTEST(wire_flags, WIRE_SPEAKER) && prob(1)) // Flag is set when value is not default
		speak(pick(
			"Bitch, don\'t you wanna start making some real fucking money?!",
			"Recycle. Everybody\'s doing it.",
			"Recycling is the only option.",
			"Recycling is a cool thing to do.",
			"Recycling Rocks.",
			"I pity the fool who doesn\'t recycle."))

	if(BITTEST(wire_flags, WIRE_THROW) && prob(2))
		throw_item()


/obj/machinery/amerecycler/ui_status()
	. = ..()
	if(stat & NOPOWER)
		. = UI_DISABLED


/obj/machinery/amerecycler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FrontNode")
		ui.open()

/obj/machinery/amerecycler/ui_data(mob/user)
	var/list/data = list()
	var/access = BITTEST(wire_flags, WIRE_ID_SCAN) ? list() : user.GetAccess() // grab the access if the scanner works

	data["salesactive"] = sales_paused ? null :TRUE 
	data["budget"] = silo?.my_account?.money
	data["siloactive"] = (isnull(silo) || silo.stat & NOPOWER) ? null :TRUE // TGUI does not use FALSE as its boolean false

	data["dosh"] = moneyinput
	var/list/itemnamearray = list() // TGUI can only access arrays flexibly when they are not associated
	var/list/itempricearray = list() // so we have to separate the lists into arrays with matching indexes
	var/list/itemiconarray = list()
	for(var/obj/data2do in saleworthy_items)
		itemnamearray.Add(data2do.name) // string as item name
		itempricearray.Add(saleworthy_items[data2do]) 
		itemiconarray.Add(icon2base64html(data2do.type)) // whatever html formatted images are
	data["itemnames"] = itemnamearray
	data["icons"] = itemiconarray
	data["itemprices"] = itempricearray
	if(silo) // display the config and material exchange
		if(silo.required_access in access)
			data["authorization"] = TRUE
		var/list/maticonarray = list()
		var/list/matnumarray = list()
		var/list/matnamearray = list()
		var/list/matvaluearray = list()
		for(var/mat in silo.materials_stored)
			var/material/currentmat = get_material_by_name(mat)
			matnamearray.Add(currentmat.name)// string as mat name
			var/obj/item/stack/material/currentstack = currentmat.stack_type
			matvaluearray.Add(initial(currentstack.price_tag)) // num
			maticonarray.Add(icon2base64html(currentstack)) // string as html?? icon??
			matnumarray.Add(silo.materials_stored[mat]) // num
		data["matnums"] = matnumarray
		data["matnames"] = matnamearray
		data["matvalues"] = matvaluearray
		data["maticons"] = maticonarray	

	return data

/obj/machinery/amerecycler/ui_act(action, params)
	. = ..()
	if(get_dist(usr, src) > 1) // remote operation is not currently legal, if you want to allow a case, change this check.
		. = TRUE
	if(.)
		return
	if(silo && !(silo.stat & NOPOWER))
		switch(action)
			if("sell_item")
				if(params["chosen"])
					if(params["chosen"] > length(saleworthy_items))
						return FALSE
					recycle_and_pay(saleworthy_items[params["chosen"]])
				else
					recycle_and_pay()
				return TRUE
			if("recycle_item")
				if(params["chosen"])
					if(params["chosen"] > length(saleworthy_items))
						return FALSE

					recycle_and_output(saleworthy_items[params["chosen"]])
				else
					recycle_and_output()
				return TRUE
			if("buy_mat")
				var/buyamount = params["amount"]
				if(params["matselected"] > length(silo.materials_stored))
					return FALSE
				var/materialtobuy = silo.materials_stored[params["matselected"]]
				buyamount = clamp(buyamount, 0, silo.materials_stored[materialtobuy])
				var/material/middlemat = get_material_by_name(materialtobuy) // this only exists to allow reading the var
				var/obj/item/stack/material/toread = middlemat.stack_type
				var/buyprice = initial(toread.price_tag) * buyamount * 1.2
				if(moneyinput < buyprice)
					return FALSE
				moneyinput -= buyprice
				var/datum/transaction/T = new(buyprice, "", "Material Purchase", src)
				T.apply_to(silo.my_account)
				silo.taxdebt += buyprice/32
				silo.ejectmaterial(materialtobuy, buyamount, get_turf(src))
				flick("recycle_vend", src)
				. = TRUE

	switch(action) // these ones are local
		if("toggle_sales")
			var/obj/item/card/id/IDToCheck = BITTEST(wire_flags, WIRE_ID_SCAN) ? list() : usr.GetIdCard() // grab the access if the scanner works
			if(silo.required_access in IDToCheck.access)
				sales_paused = !sales_paused
			else
				return TRUE
		
		if("eject_item")
			if(params["chosen"] > length(saleworthy_items))
				return FALSE
			eject_stored_item(saleworthy_items[params["chosen"]])
			flick("recycle_vend", src)
			return TRUE
		
		if("ejectdosh")
			if(moneyinput <= 0)
				return FALSE
			spawn_money(moneyinput, get_turf(src), usr)
			flick("recycle_vend", src)
			moneyinput = 0
			return TRUE
	update_icon()

#define MINIMUM_BUDGET 800 // tax purposes

/obj/machinery/amesilo
	name = "automated material exchange silo"
	desc = "Stores the materials sold by the AME network."
	icon = 'icons/obj/machines/squaremachines.dmi'
	icon_state = "silo"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 1000	//same as bluespace relay
	var/prime = FALSE

	// Can't use subtypeof(), since we have lots of useless materials
	var/list/materials_supported = list(
		MATERIAL_STEEL,
		MATERIAL_GLASS,
		MATERIAL_PLASTIC,
		MATERIAL_WOOD,
		MATERIAL_SILVER,
		MATERIAL_GOLD,
		MATERIAL_URANIUM,
		MATERIAL_CARDBOARD,
		MATERIAL_PLASMA,
		MATERIAL_PLATINUM,
		MATERIAL_PLASTEEL,
		MATERIAL_DIAMOND,
		MATERIAL_PLASMAGLASS)
	var/list/materials_stored = list()
	var/datum/weakref/lastprime
	var/locked = FALSE
	var/budget = 4000
	var/datum/money_account/my_account
	var/datum/money_account/associate_account
	var/maxcapacity = 8640 // 12 level 3 matter bins applied to the highcapacity lathes
	var/sellthreshold = 7920 // after 11, the threshold is met
	var/required_access
	var/datum/money_account/moneycard
	var/obj/item/spacecash/ewallet/chargecard
	var/obj/item/spacecash/bundle/PakKash
	var/list/linked = list()
	var/list/PortMats = list()
	var/taxdebt = 0

/obj/machinery/amesilo/LateInitialize()
	. = ..()
	update_icon()
	var/area/areatocheck = get_area(src)
	if(areatocheck.vessel != "CEV Eris") // this machine pays taxes, and so should you.
		return FALSE
	for(var/machinetocheck in GLOB.machines)
		if(istype(machinetocheck, /obj/machinery/amesilo))
			var/obj/machinery/amesilo/tocheck = machinetocheck
			if(tocheck.prime) // there can only be one.
				if(tocheck == src)
					lastprime = null
					break // but I am the one
				lastprime = WEAKREF(tocheck)
				return
	prime = TRUE
	associate_account = department_accounts[DEPARTMENT_GUILD] // this will be null during global atom init but set during gametime
	if(!external_accounts["AME"])
		var/datum/money_account/M = new()
		M.owner_name = "AME"
		M.account_name = "AME Currency Account"
		M.account_number = rand(111111, 999999)
		var/datum/transaction/T = new(2000, "AME", "Account creation", "Asters Automated Material Exchange Re-Initialization Procedure")
		T.apply_to(M)
		all_money_accounts.Add(M)
		external_accounts["AME"] = M
		my_account = M
		var/datum/transaction/hashfodder = T // grab transaction that establishes creation time of account
		var/hash = md5("AME"+hashfodder.time) // hash the account name and the creation time of the account
		var/list/fullpin = list()
		var/texttoadd
		for(var/incrementor = 1, length(fullpin) < 6 && incrementor < 99, incrementor++) 
			if(length(fullpin) > 3 && prob(10)) // pins can be up to six in length, but also down to four. due to rand(1111, 111111) generation, 4 is <1% and 6 is ~90%.
				break
			texttoadd = copytext("[text2ascii(hash,incrementor)]", 2, 3) // grabs the second digit of the byte of the hash corresponding to incrementor
			if(length(fullpin) == 0 && texttoadd == "0") // the first digit cannot be 0
				continue
			fullpin.Add(texttoadd) // as a whole, this loop creates a list of digits that should be nearly equally likely to be any digit, with a bias for numbers from 8 to 2.
		M.remote_access_pin = jointext(fullpin,null)
	else
		my_account = external_accounts["AME"]
	for(var/machinetocheck in GLOB.machines) // link the recyclers
		if(istype(machinetocheck, /obj/machinery/amerecycler))
			var/area/areachecked = get_area(machinetocheck)
			var/area/my_area = get_area(src)
			if(areachecked.vessel == my_area.vessel) // they pay taxes to the same captain
				var/obj/machinery/amerecycler/toreset = machinetocheck
				toreset.silo = src
				toreset.update_icon()
				linked.Add(toreset)

/obj/machinery/amesilo/proc/setaccount(accountnumber)
	var/accountgrabbed = get_account(accountnumber)
	if(accountgrabbed)
		associate_account = accountgrabbed

/obj/machinery/amesilo/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/spacecash))
		if(istype(I, /obj/item/spacecash/ewallet))
			var/obj/item/spacecash/ewallet/chargedcard = I
			chargecard = chargedcard
			to_chat(user, SPAN_NOTICE("You register [I] with [src]."))
		else if(istype(I, /obj/item/spacecash/bundle))
			user.remove_from_mob(I, drop = FALSE)
			I.forceMove(src)
			PakKash = I
			to_chat(user, SPAN_NOTICE("You feed [I] to the PakPort on [src]."))
			spawn(10 SECONDS)
				if(PakKash && !QDELING(PakKash))
					PakKash.forceMove(get_turf(src))
					visible_message("[PakKash] falls out of [src].", "You hear a mute impact with the floor alongside quiet clinking.")
	if(istype(I, /obj/item/card/id))
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")		
		var/obj/item/card/id/swiped = I
		if(!required_access)
			if(!length(swiped.access) > 0)
				to_chat(user, SPAN_WARNING("[src] has not been fully initialized!\n Use a door privileged card upon [src] to initialize it."))
				return TRUE
			required_access = swiped.access[1] // just grab the first one and let them reset it for themselves
			to_chat(user, SPAN_NOTICE("You have set the required access of \the [src] to one of the access codes within [swiped]."))
			return TRUE
		var/datum/money_account/accountgot = get_account(swiped.associated_account_number)
		if(accountgot.security_level != 0)
			var/attempt_pin = input("Enter pin code", "Silo transaction") as num
			moneycard = attempt_account_access(swiped.associated_account_number, attempt_pin, 2)
			if(moneycard)
				to_chat(user, SPAN_NOTICE("You have logged in to the [accountgot.get_name()] account successfully."))
		else
			moneycard = accountgot
			to_chat(user, SPAN_NOTICE("You have logged in to the [accountgot.get_name()] account."))
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/input = I
		if(input.material.name in materials_supported)
			to_chat(user, SPAN_NOTICE("You feed [I] into [src]."))
			user.remove_from_mob(I, drop = FALSE)
			I.forceMove(src)
			PortMats |= I
		else
			to_chat(user, SPAN_WARNING("[I] is a material not supported by the AME Network."))


/obj/machinery/amesilo/Destroy()
	. = ..()
	selleverything()
	if(my_account.money > MINIMUM_BUDGET)
		var/cleanamount = round(taxdebt)
		var/datum/transaction/pay = new(cleanamount, my_account.get_name(), "Final Payment of [src]", src)
		var/datum/transaction/tax = new(-cleanamount, moneycard.get_name(), "Final Payment of [src]", src)
		tax.apply_to(my_account)
		pay.apply_to(department_accounts[DEPARTMENT_COMMAND])
		taxdebt = 0
	lastprime = null
	QDEL_NULL(PakKash)
	if(prime) // we are prime, so recyclers may have us as their silo
		for(var/obj/machinery/amerecycler/toreset in linked) // unlink the recyclers
			toreset.silo = null
			toreset.update_icon()
	linked = list()

/obj/machinery/amesilo/proc/selleverything()
	for(var/tosell in materials_stored)
		sellonething(tosell, materials_stored[tosell])

/obj/machinery/amesilo/proc/sellonething(materialtosell, amount)
	if(!(materialtosell in materials_stored))
		return FALSE // cannot sell what you do not have
	amount = clamp(amount, 0, materials_stored[materialtosell]) // can only sell as much as is stored
	var/material/mat = get_material_by_name(materialtosell)
	var/obj/item/stack/material/M = mat.stack_type
	if(!M)
		return FALSE // false materials do not crash if they are not accessed
	var/cost = initial(M.price_tag) * amount
	materials_stored[materialtosell] -= amount
	var/datum/transaction/T = new(cost, my_account.get_name(), "Export", TRADE_SYSTEM_IC_NAME)
	T.apply_to(my_account)
	taxdebt += cost/16 // taxed double
	. = TRUE
	applybudget() // excess income is sent to associate account

#define SPRITECAPACITY 12 // the current sprite has room for 12
/obj/machinery/amesilo/update_icon()
	var/highestthreshold = 0
	for(var/mattocheck in materials_stored)
		var/current = CEILING(materials_stored[mattocheck]/(maxcapacity/SPRITECAPACITY),1)
		if(current > highestthreshold)
			highestthreshold = current
	icon_state = initial(icon_state)+"[highestthreshold]"

/obj/machinery/amesilo/power_change()
	..()
	for(var/obj/machinery/amerecycler/toupdate in linked)
		toupdate.update_icon()

/obj/machinery/amesilo/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(get_dist_euclidian(user, src) <= 2)
		to_chat(user, "[src] is using [copytext_char(icon_state, length(initial(icon_state))+1,0)] out of [SPRITECAPACITY] contained storage modules.")


/obj/machinery/amesilo/proc/applybudget()
	settledebt() // taxes first
	if((my_account?.money > budget+1) && associate_account)
		var/difference = round(my_account.money - budget)
		var/datum/transaction/frommine = new(difference, my_account.get_name(), "Associate Payment", src)
		frommine.apply_to(associate_account)
		var/datum/transaction/tomine = new(-difference, associate_account.get_name(), "Associate Payment", src)
		tomine.apply_to(my_account)

/obj/machinery/amesilo/proc/setbudget(newbudget)
	budget = max(MINIMUM_BUDGET, newbudget) // be able to buy at least a little
	. = budget
	applybudget()

/obj/machinery/amesilo/proc/setthreshold(newthreshold)
	sellthreshold = clamp(newthreshold, 720, maxcapacity) // be able to sell at least a little to actual players
	for(var/torectify in materials_stored)
		if(materials_stored[torectify] > sellthreshold)
			sellonething(torectify, materials_stored[torectify] - sellthreshold) // sell only excess


/obj/machinery/amesilo/proc/addmaterial(toadd)
	if(!islist(toadd))
		if(istype(toadd, /obj/item/stack/material))
			var/obj/item/stack/material/materialadded = toadd
			var/matname = materialadded.material.name
			materials_stored[matname] += materialadded.amount
			qdel(materialadded)
			if(materials_stored[matname] > sellthreshold) // autosell excess
				sellonething(matname, materials_stored[matname] - sellthreshold)
			return TRUE // we handled everything, yay!
		else
			error("AME silo can only take material stack items and processed lists.")
			return FALSE
	var/list/processthis = toadd
	for(var/matname in processthis)
		if(!istext(matname))
			continue // don't take this as an excuse to feed the proc garbage
		if(!((matname in materials_supported) && isnum(processthis[matname])))
			continue // compatible text only
		materials_stored[matname] += processthis[matname]
		if(materials_stored[matname] > sellthreshold)
			sellonething(matname, materials_stored[matname] - sellthreshold) // sell excess
		
/obj/machinery/amesilo/proc/updatesubsidy()
	if(my_account.money <= 400)
		if(department_accounts[DEPARTMENT_COMMAND])
			var/datum/money_account/commandaccount = department_accounts[DEPARTMENT_COMMAND]
			if(commandaccount.money < MINIMUM_BUDGET)
				return FALSE
			var/totransfer = MINIMUM_BUDGET-my_account.money
			taxdebt += totransfer
			var/datum/transaction/frommine = new(-totransfer, my_account.get_name(), "Subsidy Payment", src)
			frommine.apply_to(commandaccount)
			var/datum/transaction/tomine = new(totransfer, commandaccount.get_name(), "Subsidy Payment", src)
			tomine.apply_to(my_account)

/obj/machinery/amesilo/proc/ejectmaterial(materialtoremove, amount, atom/location)
	if(!materials_stored[materialtoremove])
		return FALSE
	amount = clamp(amount, 0, materials_stored[materialtoremove]) // can only eject as much as you have
	if(amount == 0)
		return FALSE
	var/material/materialfound = get_material_by_name(materialtoremove)
	var/obj/item/stack/material/stackspawned = materialfound.stack_type
	if(stackspawned) // ensure the stack has a type
		materials_stored[materialtoremove] -= amount // checks have gone through, remove amount
		. = list() // this proc returns a list of material stacks
		var/maxamount = initial(stackspawned.max_amount)
		var/flat = maxamount*round(amount/maxamount) // some are full if this is positive
		var/remainder = amount - flat // and one's not if this is positive
		if(flat)
			for(var/increment = 0, increment < round(amount/maxamount), increment++)
				stackspawned = new materialfound.stack_type(location)
				. += stackspawned
				stackspawned.amount = maxamount
				stackspawned.update_strings()
				stackspawned.update_icon()
		if(remainder)
			stackspawned = new materialfound.stack_type(location)
			. += stackspawned
			stackspawned.amount = remainder
			stackspawned.update_strings()
			stackspawned.update_icon()
	else // stored non-materials are no excuse to error
		. = FALSE

/obj/machinery/amesilo/proc/resetprime() // this proc adds prime status when all other silos do not have prime
	var/area/checkarea = get_area(src)
	if(checkarea.vessel != "CEV Eris") // this machine pays taxes, and so should you.
		return FALSE
	for(var/machinetocheck in GLOB.machines)
		if(istype(machinetocheck, /obj/machinery/amesilo))
			var/obj/machinery/amesilo/tocheck = machinetocheck
			if(tocheck.prime) // there can only be one.
				if(tocheck == src)
					lastprime = null
					break // but I am the one
				lastprime = WEAKREF(tocheck)
				return
	prime = TRUE
	update_icon()
	associate_account = department_accounts[DEPARTMENT_GUILD]
	if(!external_accounts["AME"])
		error("[src], which creates AME account on creation, fails to find AME account")
	my_account = external_accounts["AME"]
	for(var/machinetocheck in GLOB.machines) // link the recyclers
		if(istype(machinetocheck, /obj/machinery/amerecycler))
			var/area/area_checked = get_area(machinetocheck)
			var/area/this_area = get_area(src)
			if(area_checked.vessel == this_area.vessel) // they pay taxes to the same captain
				var/obj/machinery/amerecycler/toreset = machinetocheck
				toreset.silo = src
				toreset.update_icon()

/obj/machinery/amesilo/proc/settledebt()
	if(my_account.money > MINIMUM_BUDGET && taxdebt >= 100) // the taxes are paid in chunks of 100,
		var/sendthis = round(min(taxdebt, my_account.money - MINIMUM_BUDGET)/100)
		if(sendthis <= 0) // and only if they wouldn't trigger a subsidy.
			return FALSE
		var/datum/transaction/pay = new(sendthis, my_account.get_name(), "Tax Payment", src)
		var/datum/transaction/tax = new(-sendthis, moneycard.get_name(), "Tax Payment", src)
		tax.apply_to(my_account)
		pay.apply_to(department_accounts[DEPARTMENT_COMMAND])
		taxdebt = max(0, taxdebt-sendthis)

/obj/machinery/amesilo/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	required_access = null // you bypass the access, surely this means you get all the money?
	to_chat(user, SPAN_NOTICE("You wipe [src]'s access cache."))
	selleverything() // haha you thought
	to_chat(user, SPAN_DANGER("You triggered the anti-tamper failsafe!"))


/obj/machinery/amesilo/ui_status()
	. = ..()
	if(stat & NOPOWER)
		. = UI_DISABLED

/obj/machinery/amesilo/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StorageNode", name)
		ui.open()
		ui.set_autoupdate(TRUE) // for monitoring stocks and budget


/obj/machinery/amesilo/ui_data(mob/user)
	var/list/data = list()
	if(!prime)
		var/obj/machinery/amesilo/otherprime = lastprime?.resolve()
		if(istype(otherprime))
			var/area/A = get_area(otherprime)
			var/displayed_area = A ? " - [strip_improper(A.name)]" : ""
			var/obj/map_data/M = GLOB.maps_data.all_levels[otherprime.z]
			if(M.custom_z_names)
				data["otherprimeloc"] = "[otherprime.x]:[otherprime.y], [M.custom_z_name(otherprime.z)][displayed_area]"
			else
				data["otherprimeloc"] = "[otherprime.x]:[otherprime.y], [otherprime.z][displayed_area]"
	
		else if(isnull(otherprime))
			data["otherprimeloc"] = "Prime does not exist, please reset to set Prime."
		else
			CRASH("[src] found error in otherprime var set at [otherprime]")
	data["budget"] = my_account?.money
	data["dosh"] = moneycard? moneycard.money : chargecard?.worth // if we have an account to charge, use that. if not, if chargecard isn't null, great, if it is, great too.
	var/list/matnamearray = list() // TGUI can only access arrays flexibly when they are not associated
	var/list/matnumarray = list() // so we have to separate the list into several arrays with matching indexes
	var/list/matvaluearray = list()
	var/list/maticonarray = list()
	for(var/mat in materials_stored)
		matnumarray.Add(materials_stored[mat]) // num
		var/material/currentmat = get_material_by_name(mat)
		matnamearray.Add(currentmat.name) // string as mat name
		var/obj/item/stack/material/currentstack = currentmat.stack_type
		matvaluearray.Add(initial(currentstack.price_tag))
		maticonarray.Add(icon2base64html(currentstack))
	data["matnums"] = matnumarray
	data["matnames"] = matnamearray
	data["matvalues"] = matvaluearray
	data["maticons"] = maticonarray
	var/obj/item/card/id/IDToCheck = user.GetIdCard()
	if(required_access in IDToCheck.access)
		data["authorization"] = TRUE
		data["IDcodereq"] = required_access
		data["accountname"] = associate_account?.get_name()
		data["accountnum"] = associate_account?.account_number
		data["sellthreshold"] = sellthreshold
		var/list/idlist = get_all_access_datums_by_id()
		var/list/desclist = list()
		for(var/identry in IDToCheck.access)
			var/datum/access/currentdatum = idlist["[identry]"]
			desclist.Add(currentdatum.desc)
		data["idnums"] = IDToCheck.access
		data["iddescs"] = desclist
	if(PortMats.len)
		var/list/maticonarrayB = list()
		var/list/matnumarrayB = list()
		var/list/matvaluearrayB = list()
		var/list/matnamearrayB = list()
		for(var/obj/item/stack/material/mat in PortMats)
			matvaluearrayB.Add(mat.price_tag)
			matnumarrayB.Add(mat.amount)
			maticonarrayB.Add(icon2base64html(mat.type))
			matnamearrayB.Add(mat.name)
		data["portmatvalues"] = matvaluearrayB
		data["portmatamounts"] = matnumarrayB
		data["portmaticons"] = maticonarrayB
		data["portmatnames"] = matnamearrayB
	return data


/obj/machinery/amesilo/ui_act(action, params)
	. = ..()
	if(get_dist(usr, src) > 1 || stat & NOPOWER)
		return TRUE
	var/obj/item/card/id/IDToCheck = usr.GetIdCard()
	if(required_access in IDToCheck.access)
		switch(action)
			if("setID")
				if(params["newID"] in IDToCheck.access)
					required_access = params["newID"]
				
			if("setbudget")
				if(!isnum(params["newbudget"]))
					return FALSE
				setbudget(params["newbudget"])

			if("setthreshold")
				if(!isnum(params["newthreshold"]))
					return FALSE
				setthreshold(params["newthreshold"])
			if("setaccount")
				if(!isnum(params["newID"]))
					return FALSE
				else
					setaccount(params["newID"])

	switch(action)
		if("resetprime")
			if(prime)
				return FALSE
			resetprime()
		if("sellmat")
			if(params["selected"]) // they chose one and not just all o' them
				if(!isnum(params["selected"])) // indexed by numbers
					return FALSE

				var/roundedselected = round(params["selected"])
				if(roundedselected > length(PortMats) || roundedselected < 1)
					return FALSE
				var/obj/item/stack/material/chosen = PortMats[roundedselected]
				var/currentprice = chosen.price_tag * chosen.amount * 0.9
				currentprice = round(currentprice) // don't make it round and you won't lose your money
				if(my_account.money < currentprice)
					return TRUE

				if(moneycard)
					if(moneycard.suspended)
						return TRUE
				else if(!chargecard) // no card to pay
					return TRUE
				PortMats.Cut(roundedselected, roundedselected+1)
				addmaterial(chosen)
				if(moneycard)
					var/datum/transaction/bin = new(currentprice, my_account.get_name(), "Material Sale", src)
					bin.apply_to(moneycard)
					var/datum/transaction/out = new(-currentprice, moneycard.get_name(), "Material Sale", src)
					out.apply_to(my_account)
				else
					chargecard.worth += currentprice
					var/datum/transaction/T = new(-currentprice, chargecard.owner_name, "Material Sale", src)
					T.apply_to(my_account)
			else
				var/currentprice = 0
				for(var/obj/item/stack/material/tosell in PortMats) // first loop through the list and find the total price
					currentprice += tosell.price_tag * tosell.amount * 0.9
				currentprice = round(currentprice) // don't make it round and you won't lose your money
				if(currentprice > my_account.money) // if it's not possible to buy them all, buy none of them, force them to stop HREFing and start using the UI
					return TRUE
				if(moneycard)
					if(moneycard.suspended)
						return TRUE
				else if(!chargecard) // no card to pay
					return TRUE
				for(var/obj/item/stack/material/tosell in PortMats)
					addmaterial(tosell)
				PortMats.Cut()
				if(moneycard)
					var/datum/transaction/out = new(currentprice, my_account.get_name(), "Material Sale", src)
					out.apply_to(moneycard)
					var/datum/transaction/bin = new(-currentprice, moneycard.get_name(), "Material Sale", src)
					bin.apply_to(my_account)
				else
					chargecard.worth += currentprice
					var/datum/transaction/T = new(-currentprice, chargecard.owner_name, "Material Sale", src)
					T.apply_to(my_account)
			updatesubsidy()


		if("buymat")
			if(params["matselected"] > length(materials_stored))
				return FALSE
			var/materialtobuy = materials_stored[params["matselected"]]
			var/material/mat = get_material_by_name(materialtobuy)
			var/obj/item/stack/material/stack = mat.stack_type
			var/amountchoice = params["amount"]
			amountchoice = clamp(amountchoice, 0, materials_stored[materialtobuy])
			var/buyprice = (initial(stack.price_tag) * amountchoice) * 1.1 // the price for the materials plus the 10% fee
			buyprice = CEILING(buyprice, 1) // don't make it round and you won't lose your money
			if(moneycard)
				if(moneycard.suspended)
					return TRUE
				if(buyprice > moneycard.money)
					return TRUE
				else
					var/datum/transaction/bin = new(-buyprice, my_account.get_name(), "Material Purchase", src)
					if(bin.apply_to(moneycard))
						var/datum/transaction/out = new(buyprice, moneycard.get_name(), "Material Purchase", src)
						out.apply_to(my_account)
					else
						return TRUE

			else if(chargecard)
				if(buyprice > chargecard.worth)
					return TRUE
				else
					chargecard.worth -= buyprice
					var/datum/transaction/T = new(buyprice, chargecard.owner_name, "Material Purchase", src)
					T.apply_to(my_account)
			taxdebt += buyprice/32
			settledebt()
			ejectmaterial(materialtobuy, amountchoice, get_turf(src))

		if("eject")
			if(params["selected"])
				if(!isnum(params["selected"]))
					return FALSE
				var/roundedselected = round(params["selected"])
				if(roundedselected > length(PortMats) || roundedselected < 1)
					return FALSE
				var/obj/item/stack/material/chosen = PortMats[roundedselected]
				chosen.forceMove(get_turf(src))
				PortMats.Cut(roundedselected, roundedselected+1)
			else
				for(var/obj/item/stack/tomove in PortMats)
					tomove.forceMove(get_turf(src))
				PortMats.Cut()

		if("logout")
			if(moneycard || chargecard)
				moneycard = null
				chargecard = null
			else
				return FALSE

	
#undef MINIMUM_BUDGET
#undef SPRITECAPACITY
