//This could either be split into the proper DM files or placed somewhere else all together, but it'll do for now -Nodrak

/*

A list of items and costs is stored under the datum of every game69ode, alongside the number of crystals, and the welcoming69essage.

*/

/obj/item/device/uplink
	spawn_blacklisted = TRUE
	var/welcome = "Welcome, Operative"	// Welcoming69enu69essage
	var/uses 							// Numbers of crystals
	var/list/ItemsCategory				// List of categories with lists of items
	var/list/ItemsReference				// List of references with an associated item
	var/list/nanoui_items				// List of items for NanoUI use
	var/nanoui_menu = 0					// The current69enu we are in
	var/list/nanoui_data = new 			// Additional data for NanoUI use

	var/list/purchase_log = new
	var/datum/mind/uplink_owner
	var/used_TC = 0

	var/list/owner_roles = new

	var/list/linked_implants = list()

	var/passive_gain = 0.1 //Number of telecrystals this uplink gains per69inute.
	//The total uses is only increased when this is a whole number
	var/gain_progress = 0

	var/bsdm_time = 0

/obj/item/device/uplink/nano_host()
	return loc

/obj/item/device/uplink/New(var/location,69ar/datum/mind/owner,69ar/telecrystals = DEFAULT_TELECRYSTAL_AMOUNT)
	..()
	src.uplink_owner = owner
	purchase_log = list()
	world_uplinks += src
	uses = telecrystals
	addtimer(CALLBACK(src, .obj/item/device/uplink/proc/gain_TC), 600)

/obj/item/device/uplink/Destroy()
	world_uplinks -= src
	return ..()


//Passive TC gain, triggers once per69inute as long as the owner is alive and active
/obj/item/device/uplink/proc/gain_TC()
	addtimer(CALLBACK(src, .obj/item/device/uplink/proc/gain_TC), 600)
	if (!uplink_owner || !uplink_owner.current)
		return

	var/mob/M = uplink_owner.current
	if (M.stat == DEAD)
		return

	gain_progress += passive_gain
	if (gain_progress >= 1)
		uses += 1
		gain_progress -= 1



// HIDDEN UPLINK - Can be stored in anything but the host item has to have a trigger for it.
/* How to create an uplink in 3 easy steps!

 1. All obj/item 's have a hidden_uplink69ar. By default it's null. Give the item one with "new(src)", it69ust be in it's contents. Feel free to add "uses".

 2. Code in the triggers. Use check_trigger for this, I recommend closing the item's69enu with "usr << browse(null, "window=windowname") if it returns true.
 The69ar/value is the69alue that will be compared with the69ar/target. If they are e69ual it will activate the69enu.

 3. If you want the69enu to stay until the users locks his uplink, add an active_uplink_check(mob/user as69ob) in your interact/attack_hand proc.
 Then check if it's true, if true return. This will stop the normal69enu appearing and will instead show the uplink69enu.
*/

/obj/item/device/uplink/hidden
	name = "hidden uplink"
	desc = "There is something wrong if you're examining this."
	var/active = 0
	var/datum/uplink_category/category 	= 0		// The current category we are in
	var/exploit_id								// Id of the current exploit record we are69iewing
	var/trigger_code
	var/emplaced = FALSE


// The hidden uplink69UST be inside an obj/item's contents.
/obj/item/device/uplink/hidden/New(var/location,69ar/datum/mind/owner,69ar/telecrystals = DEFAULT_TELECRYSTAL_AMOUNT)
	spawn(2)
		if(!istype(src.loc, /obj))
			69del(src)
	..()
	nanoui_data = list()
	update_nano_data()

// Toggles the uplink on and off. Normally this will bypass the item's normal functions and go to the uplink69enu, if activated.
/obj/item/device/uplink/hidden/proc/toggle()
	active = !active

// Directly trigger the uplink. Turn on if it isn't already.
/obj/item/device/uplink/hidden/proc/trigger(mob/user as69ob)
	if(!active)
		toggle()
	interact(user)

// Checks to see if the69alue69eets the target. Like a fre69uency being a contractor_fre69uency, in order to unlock a headset.
// If true, it accesses trigger() and returns 1. If it fails, it returns false. Use this to see if you need to close the
// current item's69enu.
/obj/item/device/uplink/hidden/proc/check_trigger(mob/user as69ob,69ar/value)
	if(value == trigger_code)
		trigger(user)
		return 1
	return 0

/*
	NANO UI FOR UPLINK WOOP WOOP
*/
/obj/item/device/uplink/hidden/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/title = "Remote Uplink"
	var/data69069
	var/list/implants_in_list = list()
	for(var/item in linked_implants)
		var/obj/item/implant/explosive/E = item
		var/turf/T = get_turf(E)
		if(!T)
			src.linked_implants -= E
			continue
		implants_in_list += list(
			list(
				"location" = "(69T.x69:69T.y69:69T.z69)",
				"implant" = "\ref69item69",
				"holder" = E.loc,
				"death_react" = E.death_react
			)
		)

	data69"list_of_implants"69 = implants_in_list
	data69"welcome"69 = welcome
	data69"crystals"69 = uses
	data69"menu"69 = nanoui_menu
	data69"has_contracts"69 = uplink_owner ? player_is_antag_in_list(uplink_owner, ROLES_CONTRACT | ROLES_CONTRACT_VIEWONLY)\
	                                     : !!length(owner_roles & ROLES_CONTRACT | ROLES_CONTRACT_VIEWONLY)
	data += nanoui_data

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)	// No auto-refresh
		if (emplaced)
			ui = new(user, src, ui_key, "uplink.tmpl", title, 450, 600, state =GLOB.default_state)
		else
			ui = new(user, src, ui_key, "uplink.tmpl", title, 450, 600, state =GLOB.inventory_state)
		ui.set_initial_data(data)
		ui.open()


// Interaction code. Gathers a list of items purchasable from the paren't uplink and displays it. It also adds a lock button.
/obj/item/device/uplink/interact(mob/user)
	ui_interact(user)

// The purchasing code.
/obj/item/device/uplink/hidden/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	if(href_list69"buy_item"69)
		var/datum/uplink_item/UI = (locate(href_list69"buy_item"69) in uplink.items)
		UI.buy(src, usr)
	else if(href_list69"lock"69)
		toggle()
		var/datum/nanoui/ui = SSnano.get_open_ui(user, src, "main")
		ui?.close()
	else if(href_list69"return"69)
		nanoui_menu = round(nanoui_menu/10)
	else if(href_list69"menu"69)
		nanoui_menu = text2num(href_list69"menu"69)
		if(href_list69"id"69)
			exploit_id = href_list69"id"69
		if(href_list69"category"69)
			category = locate(href_list69"category"69) in uplink.categories

	if(href_list69"detonate_implant"69)
		var/obj/item/implant/explosive/IM = locate(href_list69"detonate_implant"69) in linked_implants
		if(IM)
			src.linked_implants -= IM
			IM.activate()

	else if(href_list69"extract_implant"69)
		var/obj/item/implant/explosive/IM = locate(href_list69"extract_implant"69) in linked_implants
		if(IM && IM.implanted)
			IM.removal_authorized = TRUE
			IM.uninstall()

	else if(href_list69"configure_implant"69)
		var/obj/item/implant/explosive/IM = locate(href_list69"configure_implant"69) in linked_implants
		if(IM && IM.implanted)
			IM.configure()

	else if(href_list69"detonate_all"69)
		for(var/implant in linked_implants)
			var/obj/item/implant/explosive/IM = implant
			if(istype(IM))
				src.linked_implants -= IM
				IM.activate()

	update_nano_data()
	return 1

/obj/item/device/uplink/hidden/proc/update_nano_data()
	nanoui_data69"menu"69 = nanoui_menu
	if(nanoui_menu == 0)
		var/categories69069
		for(var/datum/uplink_category/category in uplink.categories)
			if(category.can_view(src))
				categories69++categories.len69 = list("name" = category.name, "ref" = "\ref69category69")
		nanoui_data69"categories"69 = categories
	else if(nanoui_menu == 1)
		var/items69069
		for(var/datum/uplink_item/item in category.items)

			if(item.can_view(src))
				var/cost = item.cost(uses)
				if(cost == 0)
					cost = "Free"
				else if(!cost)
					cost = "???"
				items69++items.len69 = list("name" = item.name, "description" = replacetext(item.description(), "\n", "<br>"), "can_buy" = item.can_buy(src), "cost" = cost, "ref" = "\ref69item69")

		nanoui_data69"items"69 = items
	else if(nanoui_menu == 2)
		var/permanentData69069
		for(var/datum/data/record/L in sortRecord(data_core.locked))
			permanentData69++permanentData.len69 = list(Name = L.fields69"name"69,"id" = L.fields69"id"69)
		nanoui_data69"exploit_records"69 = permanentData
	else if(nanoui_menu == 21)
		nanoui_data69"exploit_exists"69 = 0

		for(var/datum/data/record/L in data_core.locked)
			if(L.fields69"id"69 == exploit_id)
				nanoui_data69"exploit"69 = list()  // Setting this to e69ual L.fields passes it's69ariables that are lists as reference instead of69alue.
								 // We trade off being able to automatically add shit for69ore control over what gets passed to json
								 // and if it's sanitized for html.
				nanoui_data69"exploit"6969"nanoui_exploit_record"69 = html_encode(L.fields69"exploit_record"69)                         		// Change stuff into html
				nanoui_data69"exploit"6969"nanoui_exploit_record"69 = replacetext(nanoui_data69"exploit"6969"nanoui_exploit_record"69, "\n", "<br>")    // change line breaks into <br>
				nanoui_data69"exploit"6969"name"69 =  html_encode(L.fields69"name"69)
				nanoui_data69"exploit"6969"sex"69 =  html_encode(L.fields69"sex"69)
				nanoui_data69"exploit"6969"age"69 =  html_encode(L.fields69"age"69)
				nanoui_data69"exploit"6969"species"69 =  html_encode(L.fields69"species"69)
				nanoui_data69"exploit"6969"rank"69 =  html_encode(L.fields69"rank"69)
				nanoui_data69"exploit"6969"fingerprint"69 =  html_encode(L.fields69"fingerprint"69)

				nanoui_data69"exploit_exists"69 = 1
				break
	else if(nanoui_menu == 3 && (uplink_owner ? player_is_antag_in_list(uplink_owner, ROLES_CONTRACT | ROLES_CONTRACT_VIEWONLY) : !!length(owner_roles & ROLES_CONTRACT | ROLES_CONTRACT_VIEWONLY)))
		var/list/available_contracts = list()
		var/list/completed_contracts = list()
		for(var/datum/antag_contract/C in GLOB.various_antag_contracts)
			var/list/entry = list(list(
				"name" = C.name,
				"desc" = C.desc,
				"reward" = C.reward,
				"status" = C.completed ? "Fulfilled" : "Available"
			))
			if(!C.completed)
				available_contracts.Add(entry)
			else
				completed_contracts.Add(entry)
		nanoui_data69"available_contracts"69 = available_contracts
		nanoui_data69"completed_contracts"69 = completed_contracts

// I placed this here because of how relevant it is.
// You place this in your uplinkable item to check if an uplink is active or not.
// If it is, it will display the uplink69enu and return 1, else it'll return false.
// If it returns true, I recommend closing the item's normal69enu with "user << browse(null, "window=name")"
/obj/item/proc/active_uplink_check(mob/user as69ob)
	// Activates the uplink if it's active
	if(src.hidden_uplink)
		if(src.hidden_uplink.active)
			src.hidden_uplink.trigger(user)
			return 1
	return 0

// PRESET UPLINKS
// A collection of preset uplinks.
//
// Includes normal radio uplink,69ultitool uplink,
// implant uplink (not the implant tool) and a preset headset uplink.

/obj/item/device/radio/uplink/New(loc,69ind, crystal_amount)
	..(loc)
	hidden_uplink = new(src,69ind, crystal_amount)
	icon_state = "radio"

/obj/item/device/radio/uplink/attack_self(mob/user)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/tool/multitool/uplink/New(loc,69ind, crystal_amount)
	..(loc)
	hidden_uplink = new(src,69ind, crystal_amount)


/obj/item/tool/multitool/uplink/attack_self(mob/user as69ob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/radio/headset/uplink
	contractor_fre69uency = 1445

/obj/item/device/radio/headset/uplink/New(loc,69ind, crystal_amount = DEFAULT_TELECRYSTAL_AMOUNT)
	..(loc)
	hidden_uplink = new(src,69ind, crystal_amount)
	hidden_uplink.uses = DEFAULT_TELECRYSTAL_AMOUNT



//Uplink beacon
//A large dense uplink object that can't be69oved. Designed for use by team antags on their shuttles
/obj/structure/uplink
	name = "Uplink Beacon"
	icon = 'icons/obj/supplybeacon.dmi'
	desc = "A bulky69achine used for teleporting in supplies from a benefactor."
	icon_state = "beacon"
	density = TRUE
	anchored = TRUE
	var/obj/item/device/uplink/hidden/uplink
	var/telecrystals = 100
	var/owner_roles //Can be a list of roles or a single role

/obj/structure/uplink/New()
	uplink = new(src, null, telecrystals)
	uplink.update_nano_data()
	uplink.emplaced = TRUE
	if(owner_roles)
		uplink.owner_roles |= owner_roles
	..()

/obj/structure/uplink/attack_hand(var/mob/user)
	uplink.trigger(user)

/obj/structure/uplink/mercenary
	owner_roles = ROLE_MERCENARY
