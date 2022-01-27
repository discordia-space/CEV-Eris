/*
	Some of the69endors on the ship will go a bit nuts, firing their contents, shouting abuse, and
	allowing contraband.
	It will affect a limited 69uantity of69endors, but affected ones will last forever until fixed
*/
/datum/storyevent/brand_intelligence
	id = "crazy_vendors"
	name = "brand intelligence"

	event_type =/datum/event/brand_intelligence
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE)
	tags = list(TAG_COMMUNAL, TAG_DESTRUCTIVE)

//////////////////////////////////////////////////////////


/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all69ending69achines are subverted anyway.

	var/max_infections = 6
	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine


/datum/event/brand_intelligence/announce()
	command_announcement.Announce("Rampant brand intelligence has been detected aboard 69station_name()69, please stand-by.", "Machine Learning Alert")


/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in GLOB.machines)
		if(!(V.z in GLOB.maps_data.station_levels))
			continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill()
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1
	originMachine.categories = 7 //This unlocks coin/contraband content
	infectedVendingMachines.Add(originMachine)
	log_and_message_admins("Brand Intelligence started on 69jumplink(originMachine)69,")


/datum/event/brand_intelligence/tick()
	if(!vendingMachines.len || !originMachine || originMachine.shut_up || infectedVendingMachines.len >=69ax_infections)	//if every69achine is infected, or if the original69ending69achine is69issing or has it's69oice switch flipped
		end()
		kill()
		return

	if(ISMULTIPLE(activeFor, 5))
		var/obj/machinery/vending/infectedMachine = pick(vendingMachines)
		vendingMachines.Remove(infectedMachine)
		infectedVendingMachines.Add(infectedMachine)
		infectedMachine.shut_up = 0
		infectedMachine.shoot_inventory = 1
		infectedMachine.categories = 7 //This unlocks coin/contraband content
		if(ISMULTIPLE(activeFor, 12))
			originMachine.speak(pick("Try our aggressive new69arketing strategies!", \
									 "You should buy products to feed your lifestyle obsession!", \
									 "Consume!", \
									 "Your69oney can buy happiness!", \
									 "Engage direct69arketing!", \
									 "Advertising is legalized lying! But don't let that put you off our great deals!", \
									 "You don't want to buy anything? Yeah, well I didn't want to buy your69om either.",
									 "Come and buy our products ~nya"))
