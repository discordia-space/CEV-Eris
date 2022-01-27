#define ONLY_DEPLOY 1
#define ONLY_RETRACT 2
#define SEAL_DELAY 25


#define RIG_SECURITY 1
#define RIG_AI_OVERRIDE 2
#define RIG_SYSTEM_CONTROL 4
#define RIG_INTERFACE_LOCK 8
#define RIG_INTERFACE_SHOCK 16
/*
 * Defines the behavior of hardsuits/rigs/power armour.
 */

/obj/item/rig
	name = "hardsuit control69odule"
	icon = 'icons/obj/rig_modules.dmi'
	desc = "A back-mounted hardsuit deployment and control69echanism."
	slot_flags = SLOT_BACK
	req_one_access = list()
	req_access = list()
	w_class = ITEM_SIZE_BULKY
	item_flags = DRAG_AND_DROP_UNEQUIP|EQUIP_SOUNDS
	spawn_tags = SPAWN_TAG_RIG
	rarity_value = 10
	bad_type = /obj/item/rig //TODO: Resprite these, remove old bay leftover RIGs, add a RIG to69oeb R&D, add69ore RIGs in general

	// These69alues are passed on to all component pieces.
	armor = list(
		melee = 30,
		bullet = 20,
		energy = 20,
		bomb = 25,
		bio = 100,
		rad = 50
	)
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.1
	permeability_coefficient = 0.1
	unacidable = 1
	slowdown = HEAVY_SLOWDOWN //69ery slow, but gimbal69akes aim steady
	stiffness = LIGHT_STIFFNESS
	obscuration = LIGHT_OBSCURATION

	var/interface_path = "hardsuit.tmpl"
	var/ai_interface_path = "hardsuit.tmpl"
	var/interface_title = "Hardsuit Controller"
	var/wearer_move_delay //Used for AI69oving.
	var/ai_controlled_move_delay = 10
	var/aimove_power_usage = 200							  // Power usage per tile traveled when suit is69oved by AI in IIS. In joules.
	var/drain = 1											  // Power drained per tick when the suit is sealed. In 10 joule steps.


	// Keeps track of what this rig should spawn with.
	var/suit_type = "hardsuit"
	var/list/initial_modules = list()
	var/chest_type = /obj/item/clothing/suit/space/rig
	var/helm_type =  /obj/item/clothing/head/space/rig
	var/boot_type =  /obj/item/clothing/shoes/magboots/rig
	var/glove_type = /obj/item/clothing/gloves/rig
	var/cell_type =  /obj/item/cell/large/high
	var/air_type =   /obj/item/tank/oxygen

	//Component/device holders.
	var/obj/item/tank/air_supply                       // Air tank, if any.
	var/obj/item/clothing/shoes/boots                  // Deployable boots, if any.
	var/obj/item/clothing/suit/space/rig/chest                // Deployable chestpiece, if any.
	var/obj/item/clothing/head/space/rig/helmet				 // Deployable helmet, if any.
	var/obj/item/clothing/gloves/rig/gloves					// Deployable gauntlets, if any.
	var/obj/item/cell/large/cell						// Power supply, if any.
	var/obj/item/rig_module/selected_module      		      // Primary system (used with69iddle-click)
	var/obj/item/rig_module/vision/visor                      // Kinda shitty to have a69ar for a69odule, but saves time.
	var/obj/item/rig_module/voice/speech                      // As above.
	var/obj/item/rig_module/storage/storage					  //69ar for installed storage69odule, if any
	var/mob/living/carbon/human/wearer                        // The person currently wearing the rig.
	var/list/installed_modules = list()                       // Power consumption/use bookkeeping.

	// Rig status69ars.
	var/active = FALSE
	var/open = 0                                              // Access panel status.
	var/locked = 1 // Lock status. 0 = unlocked, 1 = locked with ID, -1 = broken lock, permanantly unlocked
	var/subverted = 0
	var/interface_locked = 0
	var/control_overridden = 0
	var/ai_override_enabled = 0
	var/security_check_enabled = 1
	var/malfunctioning = 0
	var/malfunction_delay = 0
	var/electrified = 0
	var/locked_down = 0

	var/seal_delay = SEAL_DELAY
	var/sealing                                               // Keeps track of seal status independantly of canremove.
	var/offline = 1                                           // Should we be applying suit69aluses?
	var/offline_slowdown = HEAVY_SLOWDOWN * 3                 // If the suit is deployed and unpowered, it sets slowdown to this.
	var/vision_restriction
	var/offline_vision_restriction = 1                        // 0 - none, 1 - welder69ision, 2 - blind.69aybe69ove this to helmets.
	var/airtight = 1 //If set, will adjust AIRTIGHT and STOPPRESSUREDAMAGE flags on components. Otherwise it should leave them untouched.

	var/emp_protection = 0

	var/rig_wear_slot = slot_back //Changing this allows for rigs that are worn as a belt or a tie or something

	// Wiring! How exciting.
	var/datum/wires/rig/wires
	var/datum/effect/effect/system/spark_spread/spark_system


	//Stuff rigs can store

	var/list/extra_allowed = list()


/obj/item/rig/proc/getCurrentGlasses()
	if(wearer &&69isor &&69isor &&69isor.vision &&69isor.vision.glasses && (!helmet || (wearer.head && helmet == wearer.head)))
		return69isor.vision.glasses

/obj/item/rig/examine()
	..()
	if(wearer)
		for(var/obj/item/piece in list(helmet,gloves,chest,boots))
			if(!piece || piece.loc != wearer)
				continue
			to_chat(usr, "\icon69piece69 \The 69piece69 69piece.gender == PLURAL ? "are" : "is"69 deployed.")

	if(loc == usr)
		to_chat(usr, "The69aintenance panel is 69open ? "open" : "closed"69.")
		to_chat(usr, "Hardsuit systems are 69offline ? "<font color='red'>offline</font>" : "<font color='green'>online</font>"69.")

/obj/item/rig/Initialize()
	. = ..()

	item_state = icon_state
	wires = new(src)

	//Add on any extra items allowed into suit storage
	if (extra_allowed.len)
		allowed |= extra_allowed

	if((!req_access || !req_access.len) && (!req_one_access || !req_one_access.len))
		locked = FALSE

	spark_system = new()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	START_PROCESSING(SSobj, src)



	// Create and initialize our69arious segments.
	if(cell_type)
		cell = new cell_type(src)
	if(air_type)
		air_supply = new air_type(src)
	if(glove_type)
		gloves = new glove_type(src)
		verbs |= /obj/item/rig/proc/toggle_gauntlets
	if(helm_type)
		helmet = new helm_type(src)
		verbs |= /obj/item/rig/proc/toggle_helmet
		helmet.obscuration = obscuration
	if(boot_type)
		boots = new boot_type(src)
		verbs |= /obj/item/rig/proc/toggle_boots
	if(chest_type)
		chest = new chest_type(src)
		chest.equip_delay = 0
		if(allowed)
			chest.allowed |= allowed
		chest.slowdown = offline_slowdown
		chest.stiffness = stiffness
		verbs |= /obj/item/rig/proc/toggle_chest

	if(initial_modules && initial_modules.len)
		for(var/path in initial_modules)
			var/obj/item/rig_module/module = new path(src)
			install(module)

	for(var/obj/item/piece in list(gloves,helmet,boots,chest))
		if(!istype(piece))
			continue
		piece.canremove = 0
		piece.name = "69suit_type69 69initial(piece.name)69"
		piece.desc = "It seems to be part of a 69name69."
		piece.icon_state = "69initial(icon_state)69"
		piece.min_cold_protection_temperature =69in_cold_protection_temperature
		piece.max_heat_protection_temperature =69ax_heat_protection_temperature
		if(piece.siemens_coefficient > siemens_coefficient) //So that insulated gloves keep their insulation.
			piece.siemens_coefficient = siemens_coefficient
		piece.permeability_coefficient = permeability_coefficient
		piece.unacidable = unacidable
		if(armor) piece.armor = armor

	update_icon(1)

/obj/item/rig/Destroy()
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		QDEL_NULL(piece)
	for(var/a in installed_modules)
		uninstall(a)
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(wires)
	QDEL_NULL(spark_system)
	return ..()

/obj/item/rig/handle_atom_del(atom/A)
	if(A == cell) // Clear a cell that has,69ost likely, exploded
		cell = null
	..()

/obj/item/rig/proc/suit_is_deployed()
	if(!istype(wearer) || loc != wearer || wearer.back != src)
		return 0
	if(helm_type && !(helmet && wearer.head == helmet))
		return 0
	if(glove_type && !(gloves && wearer.gloves == gloves))
		return 0
	if(boot_type && !(boots && wearer.shoes == boots))
		return 0
	if(chest_type && !(chest && wearer.wear_suit == chest))
		return 0
	return 1

/obj/item/rig/proc/reset()
	offline = 2
	canremove = 1
	active = FALSE
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(!piece) continue
		piece.icon_state = "69initial(icon_state)69"
		if(airtight)
			piece.item_flags &= ~(STOPPRESSUREDAMAGE|AIRTIGHT)
	update_icon(1)

/obj/item/rig/proc/toggle_seals(var/mob/initiator,var/instant)

	if(sealing) return

	// Seal toggling can be initiated by the suit AI, too
	if(!wearer)
		to_chat(initiator, SPAN_DANGER("Cannot toggle suit: The suit is currently not being worn by anyone."))
		return 0

	if(!check_power_cost(wearer))
		return 0



	var/seal_target = !active

	//Only force deploy when we're turning it on, not when removing it
	if (seal_target)
		deploy(wearer,instant)

	var/failed_to_seal

	canremove = 0 // No removing the suit while unsealing.
	sealing = 1

	if(seal_target && !suit_is_deployed())
		wearer.visible_message(SPAN_DANGER("69wearer69's suit flashes an error light."),SPAN_DANGER("Your suit flashes an error light. It can't function properly without being fully deployed."))
		failed_to_seal = 1

	if(!failed_to_seal)

		if(!instant)
			wearer.visible_message("<font color='blue'>69wearer69's suit emits a quiet hum as it begins to adjust its seals.</font>","<font color='blue'>With a quiet hum, the suit begins running checks and adjusting components.</font>")
			if(seal_delay && !do_after(wearer,seal_delay, src))
				if(wearer) to_chat(wearer, SPAN_WARNING("You69ust remain still while the suit is adjusting the components."))
				failed_to_seal = 1

		if(!wearer)
			failed_to_seal = 1
		else
			for(var/list/piece_data in list(list(wearer.shoes,boots,"boots",boot_type),list(wearer.gloves,gloves,"gloves",glove_type),list(wearer.head,helmet,"helmet",helm_type),list(wearer.wear_suit,chest,"chest",chest_type)))

				var/obj/item/piece = piece_data69169
				var/obj/item/compare_piece = piece_data69269
				var/msg_type = piece_data69369
				var/piece_type = piece_data69469

				if(!piece || !piece_type)
					continue

				if(!istype(wearer) || !istype(piece) || !istype(compare_piece) || !msg_type)
					if(wearer) to_chat(wearer, SPAN_WARNING("You69ust remain still while the suit is adjusting the components."))
					failed_to_seal = 1
					break

				if(!failed_to_seal && wearer.back == src && piece == compare_piece)

					if(seal_delay && !instant && !do_after(wearer,seal_delay,src,needhand=0))
						failed_to_seal = 1

					piece.icon_state = "69initial(icon_state)6969seal_target ? "_sealed" : ""69"
					switch(msg_type)
						if("boots")
							to_chat(wearer, "<font color='blue'>\The 69piece69 69seal_target ? "seal around your feet" : "relax their grip on your legs"69.</font>")
							wearer.update_inv_shoes()
						if("gloves")
							to_chat(wearer, "<font color='blue'>\The 69piece69 69seal_target ? "tighten around your fingers and wrists" : "become loose around your fingers"69.</font>")
							wearer.update_inv_gloves()
						if("chest")
							to_chat(wearer, "<font color='blue'>\The 69piece69 69seal_target ? "cinches tight again your chest" : "releases your chest"69.</font>")
							wearer.update_inv_wear_suit()
						if("helmet")
							to_chat(wearer, "<font color='blue'>\The 69piece69 hisses 69seal_target ? "closed" : "open"69.</font>")
							wearer.update_inv_head()
							if(helmet)
								helmet.update_light(wearer)

					//sealed pieces become airtight, protecting against diseases
					if (seal_target)
						piece.armor.bio = 100
					else
						piece.armor.bio = armor.bio

				else
					failed_to_seal = 1

		if((wearer && !(istype(wearer) && wearer.back == src)) || (seal_target && !suit_is_deployed()))
			failed_to_seal = 1

	sealing = null

	if(failed_to_seal)
		for(var/obj/item/piece in list(helmet,boots,gloves,chest))
			if(!piece) continue
			piece.icon_state = "69initial(icon_state)6969seal_target ? "" : "_sealed"69"
		canremove = !active

		if(airtight)
			update_component_sealed()
		update_icon(1)
		return 0

	// Success!
	active = seal_target
	canremove = !active
	to_chat(wearer, "<font color='blue'><b>Your entire suit 69active ? "tightens around you as the components lock into place" : "loosens as the components relax"69.</b></font>")

	if(wearer != initiator)
		to_chat(initiator, "<font color='blue'>Suit adjustment complete. Suit is now 69active ? "unsealed" : "sealed"69.</font>")

	if(canremove)
		for(var/obj/item/rig_module/module in installed_modules)
			module.deactivate()
	if(airtight)
		update_component_sealed()
	update_icon(1)

/obj/item/rig/proc/update_component_sealed()
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(canremove)
			piece.item_flags &= ~(STOPPRESSUREDAMAGE|AIRTIGHT)
		else
			piece.item_flags |=  (STOPPRESSUREDAMAGE|AIRTIGHT)
	update_icon(1)

/obj/item/rig/Process()

	// If we've lost any parts, grab them back.
	var/mob/living/M
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		if(piece.loc != src && !(wearer && piece.loc == wearer))
			if(isliving(piece.loc))
				M = piece.loc
				M.drop_from_inventory(piece)
			piece.forceMove(src)

	if(active && cell) // dains power from the cell whenever the suit is sealed
		cell.use(drain*0.1)

	if(!istype(wearer) || loc != wearer || wearer.back != src || canremove || !cell || cell.is_empty())
		if(!cell || cell.is_empty())
			if(electrified > 0)
				electrified = 0
			if(!offline)
				if(istype(wearer))
					if(!canremove)
						if (offline_slowdown < 3)
							to_chat(wearer, SPAN_DANGER("Your suit beeps stridently, and suddenly goes dead."))
						else
							to_chat(wearer, SPAN_DANGER("Your suit beeps stridently, and suddenly you're wearing a leaden69ass of69etal and plastic composites instead of a powered suit."))
					if(offline_vision_restriction == 1)
						to_chat(wearer, SPAN_DANGER("The suit optics flick_light and die, leaving you with restricted69ision."))
					else if(offline_vision_restriction == 2)
						to_chat(wearer, SPAN_DANGER("The suit optics drop out completely, drowning you in darkness."))
		if(!offline)
			offline = 1
	else
		if(offline)
			offline = 0
			if(istype(wearer) && !wearer.wearing_rig)
				wearer.wearing_rig = src
			chest.slowdown = initial(slowdown)

	if(offline)
		if(offline == 1)
			for(var/obj/item/rig_module/module in installed_modules)
				module.deactivate()
			offline = 2
			chest.slowdown = offline_slowdown
		return

	if(cell && cell.charge > 0 && electrified > 0)
		electrified--

	if(malfunction_delay > 0)
		malfunction_delay--
	else if(malfunctioning)
		malfunctioning--
		malfunction()

	for(var/obj/item/rig_module/module in installed_modules)
		cell.use(module.Process()*10)

/obj/item/rig/proc/check_power_cost(var/mob/living/user,69ar/cost,69ar/use_unconcious,69ar/obj/item/rig_module/mod,69ar/user_is_ai)

	if(!istype(user))
		return 0

	var/fail_msg

	if(!user_is_ai)
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.back != src)
			fail_msg = SPAN_WARNING("You69ust be wearing \the 69src69 to do this.")
		else if(user.incorporeal_move)
			fail_msg = SPAN_WARNING("You69ust be solid to do this.")
	if(sealing)
		fail_msg = SPAN_WARNING("The hardsuit is in the process of adjusting seals and cannot be activated.")
	else if(!fail_msg && ((use_unconcious && user.stat > 1) || (!use_unconcious && user.stat)))
		fail_msg = SPAN_WARNING("You are in no fit state to do that.")
	else if(!cell)
		fail_msg = SPAN_WARNING("There is no cell installed in the suit.")
	else if(cost && cell.charge < cost * 10) //TODO: Cellrate?
		fail_msg = SPAN_WARNING("Not enough stored power.")

	if(fail_msg)
		to_chat(user, fail_msg)
		return 0

	// This is largely for cancelling stealth and whatever.
	if(mod &&69od.disruptive)
		for(var/obj/item/rig_module/module in (installed_modules -69od))
			if(module.active &&69odule.disruptable)
				module.deactivate()

	cell.use(cost*10)
	return 1

/obj/item/rig/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS,69ar/nano_state =GLOB.inventory_state)
	if(!user)
		return

	var/list/data = list()

	if(selected_module)
		data69"primarysystem"69 = "69selected_module.interface_name69"

	if(loc != user)
		data69"ai"69 = 1

	data69"active"69 =     "69active69"
	data69"sealing"69 =   "69sealing69"
	data69"helmet"69 =    (helmet ? "69helmet.name69" : "None.")
	data69"gauntlets"69 = (gloves ? "69gloves.name69" : "None.")
	data69"boots"69 =     (boots ?  "69boots.name69" :  "None.")
	data69"chest"69 =     (chest ?  "69chest.name69" :  "None.")

	data69"charge"69 =       cell ? round(cell.charge,1) : 0
	data69"maxcharge"69 =    cell ? cell.maxcharge : 0
	data69"chargestatus"69 = cell ? FLOOR((cell.charge/cell.maxcharge)*50, 1) : 0

	data69"emagged"69 =       subverted
	data69"coverlock"69 =     locked
	data69"interfacelock"69 = interface_locked
	data69"aicontrol"69 =     control_overridden
	data69"aioverride"69 =    ai_override_enabled
	data69"securitycheck"69 = security_check_enabled
	data69"malf"69 =         69alfunction_delay


	var/list/module_list = list()
	var/i = 1
	for(var/obj/item/rig_module/module in installed_modules)
		var/list/module_data = list(
			"index" =             i,
			"name" =              "69module.interface_name69",
			"desc" =              "69module.interface_desc69",
			"can_use" =           "69module.usable69",
			"can_select" =        "69module.selectable69",
			"can_toggle" =        "69module.toggleable69",
			"is_active" =         "69module.active69",
			"engagecost" =       69odule.use_power_cost*10,
			"activecost" =       69odule.active_power_cost*10,
			"passivecost" =      69odule.passive_power_cost*10,
			"engagestring" =     69odule.engage_string,
			"activatestring" =   69odule.activate_string,
			"deactivatestring" = 69odule.deactivate_string,
			"damage" =           69odule.damage
			)

		if(module.charges &&69odule.charges.len)

			module_data69"charges"69 = list()
			var/datum/rig_charge/selected =69odule.charges69module.charge_selected69
			module_data69"chargetype"69 = selected ? "69selected.display_name69" : "none"

			for(var/chargetype in69odule.charges)
				var/datum/rig_charge/charge =69odule.charges69chargetype69
				module_data69"charges"69 += list(list("caption" = "69chargetype69 (69charge.charges69)", "index" = "69chargetype69"))

		module_list += list(module_data)
		i++

	if(module_list.len)
		data69"modules"69 =69odule_list

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, ((loc != user) ? ai_interface_path : interface_path), interface_title, 480, 550, state = nano_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/rig/proc/get_species_icon()
	return 'icons/mob/rig_back.dmi'

/obj/item/rig/update_icon(var/update_mob_icon)
	if(installed_modules.len)
		for(var/obj/item/rig_module/module in installed_modules)
			if(module.suit_overlay && !module.suit_overlay_mob_only)
				chest.overlays += image("icon" = 'icons/mob/rig_modules.dmi', "icon_state" =69odule.suit_overlay, "dir" = SOUTH)

/obj/item/rig/proc/check_suit_access(var/mob/living/carbon/human/user)

	if(!security_check_enabled)
		return 1

	if(istype(user))
		if(malfunction_check(user))
			return 0
		if(user.back != src)
			return 0
		else if(!allowed(user))
			to_chat(user, SPAN_DANGER("Unauthorized user. Access denied."))
			return 0

	else if(!ai_override_enabled)
		to_chat(user, SPAN_DANGER("Synthetic access disabled. Please consult hardware provider."))
		return 0

	return 1

//TODO: Fix Topic69ulnerabilities for69alfunction and AI override.
/obj/item/rig/Topic(href,href_list)
	if(!check_suit_access(usr))
		return 0

	if(href_list69"toggle_piece"69)
		if(ishuman(usr) && (usr.stat || usr.stunned || usr.lying))
			return 0
		toggle_piece(href_list69"toggle_piece"69, usr)
	else if(href_list69"toggle_seals"69)
		toggle_seals(usr)
	else if(href_list69"interact_module"69)

		var/module_index = text2num(href_list69"interact_module"69)

		if(module_index > 0 &&69odule_index <= installed_modules.len)
			var/obj/item/rig_module/module = installed_modules69module_index69
			switch(href_list69"module_mode"69)
				if("activate")
					module.activate()
				if("deactivate")
					module.deactivate()
				if("engage")
					module.engage()
				if("select")
					selected_module =69odule
				if("select_charge_type")
					module.charge_selected = href_list69"charge_type"69
	else if(href_list69"toggle_ai_control"69)
		ai_override_enabled = !ai_override_enabled
		notify_ai("Synthetic suit control has been 69ai_override_enabled ? "enabled" : "disabled"69.")
	else if(href_list69"toggle_suit_lock"69)
		if (locked != -1)
			locked = !locked

	usr.set_machine(src)
	add_fingerprint(usr)
	return 0

/obj/item/rig/proc/notify_ai(var/message)
	for(var/obj/item/rig_module/ai_container/module in installed_modules)
		if(module.integrated_ai &&69odule.integrated_ai.client && !module.integrated_ai.stat)
			to_chat(module.integrated_ai, "69message69")
			. = 1

//Delayed equipping of rigs
/obj/item/rig/pre_equip(var/mob/user,69ar/slot)
	if (active)
		//Can't take it off while it's engaged
		return TRUE

	if (slot == rig_wear_slot)
		if(seal_delay > 0)
			user.visible_message(
				SPAN_NOTICE("69user69 starts putting on \the 69src69..."),
				SPAN_NOTICE("You start putting on \the 69src69...")
			)
			if(!do_after(user,seal_delay,src))
				return TRUE //A nonzero return69alue will cause the equipping operation to fail
	//Delayed unequipping too
	else if (is_worn())
		retract()
		if(seal_delay > 0)
			user.visible_message(
				SPAN_NOTICE("69user69 starts taking off \the 69src69..."),
				SPAN_NOTICE("You start taking off \the 69src69...")
			)
			if(!do_after(user,seal_delay,src))
				return TRUE //A nonzero return69alue will cause the equipping operation to fail


/obj/item/rig/equipped(var/mob/user,69ar/slot)
	..()
	if (slot == rig_wear_slot)
		user.visible_message(
			SPAN_NOTICE("<b>69user69 struggles into \the 69src69.</b>"),
			SPAN_NOTICE("<b>You struggle into \the 69src69.</b>")
		)
		wearer = user
		wearer.wearing_rig = src
		update_icon()


/obj/item/rig/proc/toggle_piece(piece,69ob/initiator, deploy_mode)

	if(sealing || !cell || cell.is_empty())
		return

	if(!istype(wearer) || !wearer.back == src)
		return

	if(initiator == wearer && (usr && (usr.stat||usr.paralysis||usr.stunned))) // If the initiator isn't wearing the suit it's probably an AI.
		return

	var/obj/item/check_slot
	var/equip_to
	var/obj/item/clothing/use_obj

	if(!wearer)
		return

	switch(piece)
		if("helmet")
			equip_to = slot_head
			use_obj = helmet
			check_slot = wearer.head
		if("gauntlets")
			equip_to = slot_gloves
			use_obj = gloves
			check_slot = wearer.gloves
		if("boots")
			equip_to = slot_shoes
			use_obj = boots
			check_slot = wearer.shoes
		if("chest")
			equip_to = slot_wear_suit
			use_obj = chest
			check_slot = wearer.wear_suit

	if(use_obj)
		if(check_slot == use_obj && deploy_mode != ONLY_DEPLOY)
			if (active && !(use_obj.retract_while_active))
				to_chat(wearer, SPAN_DANGER("The 69use_obj69 is locked in place while 69src69 is active. You69ust deactivate it first!"))
				return

			var/mob/living/carbon/human/holder

			if(use_obj)
				holder = use_obj.loc
				if(istype(holder))
					if(use_obj && check_slot == use_obj)
						use_obj.canremove = 1
						if (wearer.unEquip(use_obj, src))
							if(use_obj.overslot)
								use_obj.remove_overslot_contents(wearer)
							to_chat(wearer, "<font color='blue'><b>Your 69use_obj.name69 69use_obj.gender == PLURAL ? "retract" : "retracts"69 swiftly.</b></font>")
						use_obj.canremove = 0


		else if (deploy_mode != ONLY_RETRACT)
			if(check_slot && check_slot == use_obj)
				return

			if(!wearer.equip_to_slot_if_possible(use_obj, equip_to, TRUE)) //Disable_warning
				use_obj.forceMove(src)
				if(check_slot)
					to_chat(initiator, SPAN_DANGER("You are unable to deploy \the 69piece69 as \the 69check_slot69 69check_slot.gender == PLURAL ? "are" : "is"69 in the way."))
					return
			else
				to_chat(wearer, SPAN_NOTICE("Your 69use_obj.name69 69use_obj.gender == PLURAL ? "deploy" : "deploys"69 swiftly."))

	if(piece == "helmet" && helmet)
		helmet.update_light(wearer)

/obj/item/rig/proc/deploy(mob/M,var/sealed)

	var/mob/living/carbon/human/H =69

	if(!H || !istype(H)) return

	if(H.back != src)
		return

	if(sealed)
		if(H.head)
			var/obj/item/garbage = H.head
			H.drop_from_inventory(garbage)
			H.head = null
			qdel(garbage)

		if(H.gloves)
			var/obj/item/garbage = H.gloves
			H.drop_from_inventory(garbage)
			H.gloves = null
			qdel(garbage)

		if(H.shoes)
			var/obj/item/garbage = H.shoes
			H.drop_from_inventory(garbage)
			H.shoes = null
			qdel(garbage)

		if(H.wear_suit)
			var/obj/item/garbage = H.wear_suit
			H.drop_from_inventory(garbage)
			H.wear_suit = null
			qdel(garbage)

	for(var/piece in list("helmet","gauntlets","chest","boots"))
		toggle_piece(piece, H, ONLY_DEPLOY)

/obj/item/rig/dropped(var/mob/user)
	..()
	remove()

/obj/item/rig/proc/retract()
	if (wearer)
		for(var/piece in list("helmet","chest","gauntlets","boots"))
			toggle_piece(piece, wearer, ONLY_RETRACT)

/obj/item/rig/proc/remove()
	retract()
	if(wearer)
		wearer.wearing_rig = null
		wearer = null

//Todo
/obj/item/rig/proc/malfunction()
	return 0

/obj/item/rig/emp_act(severity_class)
	//set69alfunctioning
	if(emp_protection < 30) //for ninjas, really.
		malfunctioning += 10
		if(malfunction_delay <= 0)
			malfunction_delay =69ax(malfunction_delay, round(30/severity_class))

	//drain some charge
	if(cell) cell.emp_act(severity_class + 15)

	//possibly damage some69odules
	take_hit((100/severity_class), "electrical pulse", 1)

/obj/item/rig/proc/shock(mob/user)
	if (!user)
		return 0

	if (electrocute_mob(user, cell, src)) //electrocute_mob() handles removing charge from the cell, no need to do that here.
		spark_system.start()
		if(user.stunned)
			return 1
	return 0

/obj/item/rig/proc/take_hit(damage, source, is_emp=0)

	if(!installed_modules.len)
		return

	var/chance
	if(!is_emp)
		chance = 2*max(0, damage - (chest? chest.breach_threshold : 0))
	else
		//Want this to be roughly independant of the number of69odules,69eaning that X emp hits will disable Y% of the suit's69odules on average.
		//that way people designing hardsuits don't have to worry (as69uch) about how adding that extra69odule will affect emp resiliance by 'soaking' hits for other69odules
		chance = 2*max(0, damage - emp_protection)*min(installed_modules.len/15, 1)

	if(!prob(chance))
		return

	//deal addition damage to already damaged69odule first.
	//This way the chances of a69odule being disabled aren't so remote.
	var/list/valid_modules = list()
	var/list/damaged_modules = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.damage < 2)
			valid_modules |=69odule
			if(module.damage > 0)
				damaged_modules |=69odule

	var/obj/item/rig_module/dam_module = null
	if(damaged_modules.len)
		dam_module = pick(damaged_modules)
	else if(valid_modules.len)
		dam_module = pick(valid_modules)

	if(!dam_module) return

	dam_module.damage++

	if(!source)
		source = "hit"

	if(wearer)
		if(dam_module.damage >= 2)
			to_chat(wearer, SPAN_DANGER("The 69source69 has disabled your 69dam_module.interface_name69!"))
		else
			to_chat(wearer, SPAN_WARNING("The 69source69 has damaged your 69dam_module.interface_name69!"))
	dam_module.deactivate()

/obj/item/rig/proc/malfunction_check(var/mob/living/carbon/human/user)
	if(malfunction_delay)
		if(offline)
			to_chat(user, SPAN_DANGER("The suit is completely unresponsive."))
		else
			to_chat(user, SPAN_DANGER("ERROR: Hardware fault. Rebooting interface..."))
		return 1
	return 0

/obj/item/rig/get_cell()
	return cell

/obj/item/rig/proc/ai_can_move_suit(var/mob/user,69ar/check_user_module = 0,69ar/check_for_ai = 0)

	if(check_for_ai)
		if(!(locate(/obj/item/rig_module/ai_container) in contents))
			return 0
		var/found_ai
		for(var/obj/item/rig_module/ai_container/module in contents)
			if(module.damage >= 2)
				continue
			if(module.integrated_ai &&69odule.integrated_ai.client && !module.integrated_ai.stat)
				found_ai = 1
				break
		if(!found_ai)
			return 0

	if(check_user_module)
		if(!user || !user.loc || !user.loc.loc)
			return 0
		var/obj/item/rig_module/ai_container/module = user.loc.loc
		if(!istype(module) ||69odule.damage >= 2)
			to_chat(user, SPAN_WARNING("Your host69odule is unable to interface with the suit."))
			return 0

	if(offline || !cell || cell.is_empty() || locked_down)
		if(user) user << SPAN_WARNING("Your host rig is unpowered and unresponsive.")
		return 0
	if(!wearer || wearer.back != src)
		if(user) user << SPAN_WARNING("Your host rig is not being worn.")
		return 0
	if(!wearer.stat && !control_overridden && !ai_override_enabled)
		if(user) user << SPAN_WARNING("You are locked out of the suit servo controller.")
		return 0
	return 1

/obj/item/rig/proc/force_rest(var/mob/user)
	if(!ai_can_move_suit(user, check_user_module = 1))
		return
	wearer.lay_down()
	to_chat(user, "<span class='notice'>\The 69wearer69 is now 69wearer.resting ? "resting" : "getting up"69.</span>")

/obj/item/rig/proc/forced_move(var/direction,69ar/mob/user)
	if(malfunctioning)
		direction = pick(GLOB.cardinal)

	if(world.time < wearer_move_delay)
		return

	if(!wearer || !wearer.loc || !ai_can_move_suit(user, check_user_module = 1))
		return

	// AIs are a bit slower than regular and ignore69ove intent.
	wearer_move_delay = world.time + ai_controlled_move_delay

	cell.use(aimove_power_usage * CELLRATE)
	wearer.DoMove(direction, user)

// This returns the rig if you are contained inside one, but not if you are wearing it
/atom/proc/get_rig()
	if(loc)
		return loc.get_rig()
	return null

/obj/item/rig/get_rig()
	return src

/mob/living/carbon/human/get_rig()
	return back


//Used in random rig spawning for cargo
//Randomly deletes69odules
/obj/item/rig/proc/lose_modules(var/probability)
	for(var/obj/item/rig_module/module in installed_modules)
		if (probability)
			qdel(module)


//Fiddles with some wires to possibly69ake the suit69alfunction a little
/obj/item/rig/proc/misconfigure(var/probability)
	if (prob(probability))
		wires.UpdatePulsed(RIG_SECURITY)//Fiddle with access
	if (prob(probability))
		wires.UpdatePulsed(RIG_AI_OVERRIDE)//frustrate the AI
	if (prob(probability))
		wires.UpdateCut(RIG_SYSTEM_CONTROL)//break the suit
	if (prob(probability))
		wires.UpdatePulsed(RIG_INTERFACE_LOCK)
	if (prob(probability))
		wires.UpdateCut(RIG_INTERFACE_SHOCK)
	if (prob(probability))
		subverted = 1

//Drains, rigs or removes the cell
/obj/item/rig/proc/sabotage_cell()
	if (!cell)
		return

	if (prob(50))
		cell.charge = rand(0, cell.charge*0.5)
	else if (prob(15))
		cell.rigged = 1
	else
		cell = null

//Depletes or removes the airtank
/obj/item/rig/proc/sabotage_tank()
	if (!air_supply)
		return

	if (prob(70))
		air_supply.remove_air(air_supply.air_contents.total_moles)
	else
		QDEL_NULL(air_supply)

/obj/item/rig/clean_blood()
	..()
	if(chest)
		chest.clean_blood()
	if(boots)
		boots.clean_blood()
	if(helmet)
		helmet.clean_blood()
	if(gloves)
		gloves.clean_blood()
	var/obj/glasses = getCurrentGlasses()
	if(glasses)
		glasses.clean_blood()

/obj/item/rig/decontaminate()
	..()
	if(chest)
		chest.decontaminate()
	if(boots)
		boots.decontaminate()
	if(helmet)
		helmet.decontaminate()
	if(gloves)
		gloves.decontaminate()
	var/obj/item/glasses = getCurrentGlasses()
	if(glasses)
		glasses.decontaminate()

/obj/item/rig/make_young()
	..()
	if(chest)
		chest.make_young()
	if(boots)
		boots.make_young()
	if(helmet)
		helmet.make_young()
	if(gloves)
		gloves.make_young()
	var/obj/glasses = getCurrentGlasses()
	if(glasses)
		glasses.make_young()

#undef ONLY_DEPLOY
#undef ONLY_RETRACT
#undef SEAL_DELAY
