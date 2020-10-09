SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 30 SECONDS
	priority = SS_PRIORITY_SUPPLY
	flags = SS_NO_FIRE

/datum/controller/subsystem/supply
	//supply points
	var/centcom_message = ""
	var/list/exports = list() //List of export datums
	var/contraband = 0
	var/hacked = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	//shuttle movement
	var/movetime = 300
	var/datum/shuttle/autodock/ferry/supply/shuttle

/datum/controller/subsystem/supply/Initialize(start_timeofday)
	ordernum = rand(1, 9000)

	for(var/typepath in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/P = new typepath()
		supply_packs[P.name] = P

	return ..()


/datum/controller/subsystem/supply/stat_entry()
	..("Credits: [get_account_credits(department_accounts[DEPARTMENT_GUILD])]")

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(isliving(A))
		return TRUE
	if(istype(A, /obj/item/weapon/disk/nuclear))
		return TRUE
	if(istype(A, /obj/machinery/nuclearbomb))
		return TRUE
	if(istype(A, /obj/item/device/radio/beacon))
		return TRUE

	for(var/i in 1 to A.contents.len)
		var/atom/B = A.contents[i]
		if(.(B))
			return TRUE

//Sellin
/datum/controller/subsystem/supply/proc/sell()
	var/msg = ""
	var/sold_atoms = ""
	var/points = 0

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/AM in subarea)
			if(AM.anchored)
				continue
			SEND_SIGNAL(shuttle, COMSIG_SHUTTLE_SUPPLY, AM)
			sold_atoms += export_item_and_contents(AM, contraband, hacked, dry_run = FALSE)

	for(var/a in exports)
		var/datum/export/E = a
		var/export_text = E.total_printout()
		if(!export_text)
			continue

		msg += "[export_text]<br>"
		points += E.total_cost

	msg += "<br>Total exports value: [points] credits.<br>"
	exports.Cut()

	var/datum/money_account/GA = department_accounts[DEPARTMENT_GUILD]
	var/datum/transaction/T = new(points, "Asters Guild", "Exports", "Asters Automated Trading System")
	T.apply_to(GA)

	centcom_message = msg


//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!shoppinglist.len)
		return

	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue

			var/contcount
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				contcount++
			if(contcount)
				continue
			clear_turfs += T

	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break

		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		var/datum/supply_order/SO = S
		var/datum/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.name = "[SP.name][SO.reason ? " ([SO.reason])":"" ]"

		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip
		if(!SP.contraband)
			slip = new /obj/item/weapon/paper/manifest(A)
			slip.is_copy = 0
			slip.info = "<h3>Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.id]<br>"
			slip.info +="Destination: [station_name]<br>"
			slip.info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(isnum(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()
			else
				to_chat(world, "<span class='danger'>Supply pack with invalid access restriction [SP.access] encountered!</span>")

		var/list/contains
		if(istype(SP,/datum/supply_pack/randomised))
			var/datum/supply_pack/randomised/SPR = SP
			contains = list()
			if(SPR.contains.len)
				for(var/j=1,j<=SPR.num_contained,j++)
					contains += pick(SPR.contains)
		else
			contains = SP.contains

		for(var/typepath in contains)
			if(!typepath)
				continue

			var/atom/B2 = new typepath(A)
			if(SP.amount && B2:amount) B2:amount = SP.amount
			if(slip) slip.info += "<li>[B2.name]</li>" //add the item to the manifest

		//manifest finalisation
		if(slip)
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
			slip.update_icon()

	shoppinglist.Cut()
	return

//Deducts credits from the guild account to pay for external purchases
/proc/pay_for_order(datum/supply_order/order, terminal)
	var/datum/money_account/GA = department_accounts[DEPARTMENT_GUILD]
	if (!GA)
		return FALSE

	return charge_to_account(GA.account_number, order.orderer, "Order of [order.object.name]", terminal, order.object.cost)
