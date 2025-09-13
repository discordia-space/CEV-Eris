/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list[10]
	/// To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/embedded_flag
	/// This is very not good, but it's much much better than calling get_rig() every update_lying_buckled_and_verb_status() call.
	var/obj/item/rig/wearing_rig
	/// This is not very good either, because I've copied it. Sorry.
	var/using_scope

/mob/living/carbon/human/Initialize(new_loc, new_species)
	hud_list[HEALTH_HUD]      = image('icons/mob/hud.dmi', src, "hudhealth100", ON_MOB_HUD_LAYER)
	hud_list[STATUS_HUD]      = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list[LIFE_HUD]        = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list[ID_HUD]          = image('icons/mob/hud.dmi', src, "hudunknown",   ON_MOB_HUD_LAYER)
	hud_list[WANTED_HUD]      = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[IMPCHEM_HUD]     = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[IMPTRACK_HUD]    = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[SPECIALROLE_HUD] = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[STATUS_HUD_OOC]  = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list[EXCELSIOR_HUD]   = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)

	GLOB.human_mob_list |= src

	if(!species)
		if(new_species)
			set_species(new_species,1)
		else
			set_species()

	if(species)
		real_name = species.get_random_name(gender)
		name = real_name
		if(mind)
			mind.name = real_name
	. = ..()



	sync_organ_dna()
	make_blood()
	generate_dna()

	sanity = new(src)

	AddComponent(/datum/component/fabric)

/mob/living/carbon/human/Destroy()
	GLOB.human_mob_list -= src

	// Prevent death from organ removal
	status_flags |= REBUILDING_ORGANS
	for(var/organ in organs)
		qdel(organ)
	organs.Cut()

	QDEL_NULL(sanity)

	return ..()

/mob/living/carbon/human/get_status_tab_items()
	// Remember that BYOND "unwraps" a list when it's added to another list, hence the use of list() matryoshkas here
	. = ..()
	if(internal)
		if(!internal.air_contents) // Leftover from the old stat() proc
			qdel(internal) // TODO: See if that is necessary, probably should just null the variable instead
		else
			. += list(list("Internal Atmosphere Info: [internal.name]"))
			. += list(list("Tank Pressure: [internal.air_contents.return_pressure()]"))
			. += list(list("Distribution Pressure: [internal.distribute_pressure]"))

	// RIG/hardsuit territory
	// TODO: /stat_rig_module/ got no reason to continue existing, delete it
	// TODO: Cache some of the stuff below on the RIG side
	if(back && istype(back,/obj/item/rig))
		var/obj/item/rig/suit = back
		. += list(list("br"))
		. += list(list("Using [suit.name]"))

		if(suit.interface_locked)
			. += list(list("-- HARDSUIT INTERFACE OFFLINE --"))
		else if(suit.control_overridden)
			. += list(list("-- HARDSUIT CONTROL OVERRIDDEN BY AI UNIT--"))
		else if(suit.security_check_enabled && !suit.check_suit_access_alternative(src))
			. += list(list("-- ACCESS DENIED --"))
		else if(suit.malfunction_delay > 1)
			. += list(list("-- CRITICAL ERROR --"))
		else
			// TODO: Consider deleting the following along with RIG's nano_ui_interact() when functionality here is comprehensive and stable enough
			// Could be replaced with "-- ACCESS GRANTED --" or some such line
			. += list(list("-- OPEN HARDSUIT INTERFACE --", "\ref[suit];open_ui=1"))
			. += list(list("Suit charge: [suit.cell ? "[suit.cell.charge]/[suit.cell.maxcharge]" : "ERROR"]"))
			. += list(list("AI control: [suit.ai_override_enabled ? "ENABLED" : "DISABLED"]", "\ref[suit];toggle_ai_control=1"))
			. += list(list("Suit status: [suit.active ? "ACTIVE" : "INACTIVE"]", "\ref[suit];toggle_seals=1"))
			. += list(list("Cover status: [suit.locked ? "LOCKED" : "UNLOCKED"]", "\ref[suit];toggle_suit_lock=1"))
			if(suit.sealing)
				. += list(list("-- ADJUSTING SEALS --"))
			else
				var/static/list/cached_images
				if(!cached_images)
					cached_images = list()

				for(var/atom/atom in list(suit.helmet, suit.gloves, suit.boots, suit.chest))
					if(isnull(atom))
						continue
					if("[atom.name]_[atom.icon_state]" in cached_images)
						continue
					client << browse_rsc(getFlatIcon(atom, no_anim = TRUE), "[atom.name]_[atom.icon_state].png")
					cached_images += "[atom.name]_[atom.icon_state]"

				var/RIG_pieces = list()
				if(suit.helmet)
					RIG_pieces += list(list("\ref[suit];toggle_piece=helmet", "[suit.helmet.name]_[suit.helmet.icon_state].png"))
				if(suit.gloves)
					RIG_pieces += list(list("\ref[suit];toggle_piece=gauntlets", "[suit.gloves.name]_[suit.gloves.icon_state].png"))
				if(suit.boots)
					RIG_pieces += list(list("\ref[suit];toggle_piece=boots", "[suit.boots.name]_[suit.boots.icon_state].png"))
				if(suit.chest)
					RIG_pieces += list(list("\ref[suit];toggle_piece=chest", "[suit.chest.name]_[suit.chest.icon_state].png"))

				var/RIG_modules = list()
				if(suit.active)
					var/module_index = 0
					for(var/obj/item/rig_module/module in suit.installed_modules)
						module_index++
						if(!("\ref[module]" in cached_images))
							client << browse_rsc(getFlatIcon(module, no_anim = TRUE), "\ref[module].png")
							cached_images += "\ref[module]"

						var/current_module = list("\ref[module].png")
						var/module_damage = "DESTROYED"
						switch(module.damage)
							if(0)
								module_damage = "status nominal"
							if(1)
								module_damage = "damaged"
							if(2)
								module_damage = "critical damage"

						current_module += list(list("[module.interface_name]: [module_damage]"))

						if(module.selectable)
							if(suit.selected_module && (module == suit.selected_module))
								current_module += list(list("Selected now"))
							else
								current_module += list(list("Select module", "\ref[suit];interact_module=[module_index];module_mode=select"))

						if(module.usable)
							current_module += list(list("[module.engage_string]", "\ref[suit];interact_module=[module_index];module_mode=engage"))

						if(module.toggleable)
							if(module.active)
								current_module += list(list("[module.deactivate_string]", "\ref[suit];interact_module=[module_index];module_mode=deactivate"))
							else
								current_module += list(list("[module.activate_string]", "\ref[suit];interact_module=[module_index];module_mode=activate"))

						if(module.charges && LAZYLEN(module.charges))
							var/datum/rig_charge/selected_rig_charge = module.charges[module.charge_selected]
							if(selected_rig_charge)
								current_module += list(list("Selected type: [selected_rig_charge.display_name], [selected_rig_charge.charges] charges left"))
							else
								current_module += list(list("No charge type is selected"))

							for(var/charge_index in module.charges)
								var/datum/rig_charge/rig_charge = module.charges[charge_index]
								current_module += list(list("Select [rig_charge.display_name], [rig_charge.charges] left", "\ref[suit];interact_module=[module_index];module_mode=select_charge_type;charge_type=[charge_index]"))

						RIG_modules += list(current_module)
				. += list(list("RIG_INTERFACE_DATA", RIG_pieces, RIG_modules))

	var/chemvessel_efficiency = get_organ_efficiency(OP_CHEMICALS)
	if(chemvessel_efficiency > 1)
		. += list(list("Chemical Storage: [carrion_stored_chemicals]/[round(0.5 * chemvessel_efficiency)]"))

	var/maw_efficiency = get_organ_efficiency(OP_MAW)
	if(maw_efficiency > 1)
		. += list(list("Gnawing hunger: [carrion_hunger]/[round(maw_efficiency/10)]"))
	var/obj/item/implant/core_implant/cruciform/C = get_core_implant(/obj/item/implant/core_implant/cruciform)
	if(C)
		. += list(list("Cruciform: [C.power]/[C.max_power]"))

/mob/living/carbon/human/flash(duration = 0, drop_items = FALSE, doblind = FALSE, doblurry = FALSE)
	if(blinded)
		return
	..(duration, drop_items, doblind, doblurry)

/mob/living/carbon/human/explosion_act(target_power, explosion_handler/handle)
	var/BombDamage = target_power - (getarmor(null, ARMOR_BOMB) + mob_bomb_defense)
	var/obj/item/rig/hardsuitChad = back
	if(back && istype(hardsuitChad))
		BombDamage -= hardsuitChad.block_explosion(src, target_power)
	var/BlockCoefficient = 0.2
	if(handle)
		var/ThrowTurf = get_turf(src)
		var/ThrowDistance = round(target_power / 100)
		if(ThrowTurf != handle.epicenter && ThrowDistance)
			ThrowTurf = get_turf_away_from_target_simple(src, handle.epicenter, 8)
			throw_at(ThrowTurf, ThrowDistance, ThrowDistance, "explosion")
		// Heroic sacrifice
		else if(ThrowTurf == handle.epicenter && lying)
			if(BombDamage > 500)
				BlockCoefficient = 0.8
		if(BombDamage < 0)
			return target_power * BlockCoefficient

	// 10% reduction for  takin cover down i guess
	if(lying && BlockCoefficient != 0.8)
		BombDamage *= 0.9
		BlockCoefficient = 0.1

	if(BombDamage > 1000)
		gib()

	else if(BombDamage > 600)
		var/earProtection = earcheck()
		if(earProtection * 100 < BombDamage)
			adjustEarDamage((BombDamage - earProtection*100)/ 10,(BombDamage - earProtection*100)/ 100)

	var/DamageToApply = round(BombDamage / 4)

	for(var/limb in BP_BY_DEPTH)
		if (limb in organ_rel_size)
			apply_damage(DamageToApply * (organ_rel_size[limb] / 100), BRUTE, limb)
	return BombDamage * BlockCoefficient

/mob/living/carbon/human/restrained()
	if(handcuffed)
		return 1
	if(istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as mob)
	if(user.incapacitated()  || !user.Adjacent(src))
		return

	var/obj/item/clothing/under/suit
	if(istype(w_uniform, /obj/item/clothing/under))
		suit = w_uniform

	user.set_machine(src)
	var/dat = "<B><HR><FONT size=3>[name]</FONT></B><BR><HR>"

	for(var/entry in species.hud.gear)
		var/slot = species.hud.gear[entry]
		if(slot in list(slot_l_store, slot_r_store))
			continue
		var/obj/item/thing_in_slot = get_equipped_item(slot)
		dat += "<BR><B>[entry]:</b> <a href='byond://?src=\ref[src];item=[slot]'>[istype(thing_in_slot) ? thing_in_slot : "nothing"]</a>"

	dat += "<BR><HR>"

/*	if(species.hud.has_hands)
		dat += "<BR><b>Left hand:</b> <A href='byond://?src=\ref[src];item=[slot_l_hand]'>[istype(l_hand) ? l_hand : "nothing"]</A>"
		dat += "<BR><b>Right hand:</b> <A href='byond://?src=\ref[src];item=[slot_r_hand]'>[istype(r_hand) ? r_hand : "nothing"]</A>"
*/

	// Do they get an option to set internals?
	if(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/space))
		if(istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank))
			dat += "<BR><A href='byond://?src=\ref[src];item=internals'>Toggle internals.</A>"

	// Other incidentals.
	if(handcuffed)
		dat += "<BR><A href='byond://?src=\ref[src];item=[slot_handcuffed]'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='byond://?src=\ref[src];item=[slot_legcuffed]'>Legcuffed</A>"

	if(suit && suit.accessories.len)
		dat += "<BR><A href='byond://?src=\ref[src];item=tie'>Remove accessory</A>"
	dat += "<BR><A href='byond://?src=\ref[src];item=splints'>Remove splints</A>"
	dat += "<BR><A href='byond://?src=\ref[src];item=pockets'>Empty pockets</A>"
	dat += "<BR><A href='byond://?src=\ref[user];refresh=1'>Refresh</A>"
	dat += "<BR><A href='byond://?src=\ref[user];mach_close=mob[name]'>Close</A>"

	var/datum/browser/panel = new(user, "mob[name]", "Mob", 340, 540)
	panel.set_content(dat)
	panel.open()


// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(atom/movable/AM)
	if(istype(AM, /obj/machinery/bot/mulebot))
		var/obj/machinery/bot/mulebot/MB = AM
		MB.RunOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(if_no_id = "No id", if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.rank ? id.rank : if_no_job
	else
		return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(if_no_id = "No id", if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.assignment ? id.assignment : if_no_job
	else
		return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(if_no_id = "Unknown")
	var/obj/item/card/id/id = GetIdCard()
	if(id)
		return id.registered_name || if_no_id
	else
		return if_no_id

//Trust me I'm an engineer
//I think we'll put this shit right here
var/list/rank_prefix = list(\
	"Ironhammer Operative" = "Operative",\
	"Ironhammer Inspector" = "Inspector",\
	"Ironhammer Medical Specialist" = "Specialist",\
	"Ironhammer Gunnery Sergeant" = "Sergeant",\
	"Ironhammer Commander" = "Lieutenant",\
	"NeoTheology Preacher" = "Reverend",\
	"Moebius Expedition Overseer" = "Overseer",\
	"Moebius Biolab Officer" = "Doctor",\
	"Captain" = "Captain",\
	)

/mob/living/carbon/human/proc/rank_prefix_name(name)
	if(get_id_rank())
		if(findtext(name, " "))
			name = copytext(name, findtext(name, " "))
		name = get_id_rank() + name
	return name

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/get_visible_name(add_id_name = TRUE)
	if((wear_mask && (wear_mask.flags_inv&HIDEFACE)) || (head && (head.flags_inv&HIDEFACE)))	//Wearing a mask which hides our face, use id-name if possible	//Likewise for hats
		return rank_prefix_name(get_id_name())

	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(id_name)
		if(id_name != face_name)
			return "[face_name] (as [rank_prefix_name(id_name)])"
		else
			return rank_prefix_name(id_name)
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/get_face_name()
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	if(!head || head.disfigured || head.is_stump() || !real_name) // || (HUSK in mutations) 	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(if_no_id = "Unknown")
	. = if_no_id
	var/obj/item/card/id/I = GetIdCard()
	if(istype(I))
		return I.registered_name

/mob/living/carbon/human/proc/get_id_rank()
	var/rank
	var/obj/item/card/id/id
	if(istype(wear_id, /obj/item/modular_computer/pda))
		id = wear_id.GetIdCard()
	if(!id)
		id = get_idcard()
	if(id)
		rank = id.rank
		if(rank_prefix[rank])
			return rank_prefix[rank]
	return ""

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetIdCard()

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(shock_damage, obj/source, siemens_coeff = 1, def_zone)
	if(status_flags & GODMODE)	return 0	//godmode

	if(!def_zone)
		def_zone = pick(BP_L_ARM, BP_R_ARM)

	var/obj/item/organ/external/affected_organ = get_organ(check_zone(def_zone))
	siemens_coeff *= get_siemens_coefficient_organ(affected_organ)

	return ..(shock_damage, source, siemens_coeff, def_zone)


/mob/living/carbon/human/Topic(href, href_list)

	if(href_list["refresh"])
		if((machine)&&(in_range(src, usr)))
			show_inv(machine)

	if(href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if(href_list["item"])
		handle_strip(href_list["item"],usr)

	if(href_list["criminal"])
		if(hasHUD(usr,"security"))

			var/modified = FALSE
			var/perpname = get_id_name(name)

			if(perpname)
				var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
				if(R)
					var/setcriminal = input(usr, "Specify a new criminal status for this person.", "Security HUD", R.get_criminalStatus()) in GLOB.security_statuses + "Cancel"
					if(hasHUD(usr, "security"))
						if(setcriminal != "Cancel")
							R.set_criminalStatus(setcriminal)
							modified = TRUE
							BITSET(hud_updateflag, WANTED_HUD)
							if(ishuman(usr))
								var/mob/living/carbon/human/U = usr
								U.handle_regular_hud_updates()
							if(isrobot(usr))
								var/mob/living/silicon/robot/U = usr
								U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, span_red("Unable to locate a data core entry for this person."))

	if(href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for(var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Criminal Status:</b> [R.fields["criminal"]]")
								to_chat(usr, "<b>Minor Crimes:</b> [R.fields["mi_crim"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["mi_crim_d"]]")
								to_chat(usr, "<b>Major Crimes:</b> [R.fields["ma_crim"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["ma_crim_d"]]")
								to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
								to_chat(usr, "<a href='byond://?src=\ref[src];secrecordComment=`'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, span_red("Unable to locate a data core entry for this person."))

	if(href_list["secrecordComment"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for(var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, text("[]", R.fields[text("com_[]", counter)]))
									counter++
								if(counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='byond://?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, span_red("Unable to locate a data core entry for this person."))

	if(href_list["secrecordadd"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/id
				if(istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								var/t1 = sanitize(input("Add Comment:", "Sec. records", null, null)  as message)
								if( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"security")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [CURRENT_SHIP_YEAR]<BR>[t1]")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [CURRENT_SHIP_YEAR]<BR>[t1]")

	if(href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for(var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in data_core.general)
						if(R.fields["id"] == E.fields["id"])

							var/setmedical = input(usr, "Specify a new medical status for this person.", "Medical HUD", R.fields["p_stat"]) in list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel")

							if(hasHUD(usr,"medical"))
								if(setmedical != "Cancel")
									R.fields["p_stat"] = setmedical
									modified = 1
									if(PDA_Manifest.len)
										PDA_Manifest.Cut()

									spawn()
										if(ishuman(usr))
											var/mob/living/carbon/human/U = usr
											U.handle_regular_hud_updates()
										if(isrobot(usr))
											var/mob/living/silicon/robot/U = usr
											U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, span_red("Unable to locate a data core entry for this person."))

	if(href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				var/obj/item/card/id/id
				if(istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Blood Type:</b> [R.fields["b_type"]]")
								to_chat(usr, "<b>DNA:</b> [R.fields["b_dna"]]")
								to_chat(usr, "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["mi_dis_d"]]")
								to_chat(usr, "<b>Major Disabilities:</b> [R.fields["ma_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["ma_dis_d"]]")
								to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
								to_chat(usr, "<a href='byond://?src=\ref[src];medrecordComment=`'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, span_red("Unable to locate a data core entry for this person."))

	if(href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				var/obj/item/card/id/id
				if(istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, text("[]", R.fields[text("com_[]", counter)]))
									counter++
								if(counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='byond://?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, span_red("Unable to locate a data core entry for this person."))

	if(href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/id
				if(istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								var/t1 = sanitize(input("Add Comment:", "Med. records", null, null)  as message)
								if( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"medical")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [CURRENT_SHIP_YEAR]<BR>[t1]")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [CURRENT_SHIP_YEAR]<BR>[t1]")

	if(href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		src.examinate(I)

	if(href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		src.examinate(M)

	..()
	return

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()
	if(!species.has_process[OP_EYES]) //No eyes, can't hurt them.
		return FLASH_PROTECTION_MAJOR

	var/eye_efficiency = get_organ_efficiency(OP_EYES)
	if(eye_efficiency <= 1)
		return FLASH_PROTECTION_MAJOR

	return flash_protection

/mob/living/carbon/human/earcheck()
	if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))
		. += 2
	if(istype(head, /obj/item/clothing/head/armor/helmet))
		. += 1
	return .

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(target_zone, brain_tag = BP_BRAIN)
	if(!species.has_process[brain_tag])
		return 0

	var/obj/item/organ/affecting = random_organ_by_process(brain_tag)

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/parent = get_organ(target_zone)
	if(!parent)
		return 0

	if(parent.w_class > affecting.w_class + 1)
		return prob(100 / 2**(parent.w_class - affecting.w_class - 1))

	return 1

/mob/living/carbon/human/IsAdvancedToolUser(silent)
	if(species.has_fine_manipulation)
		return 1
	if(!silent)
		to_chat(src, span_warning("You don't have the dexterity to use that!"))
	return 0

/mob/living/carbon/human/abiotic(full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)))
		return 1

	if( (src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract) )
		return 1

	return 0

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()
	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message(
			span_red("\The [src] begins playing \his ribcage like a xylophone. It's quite spooky."),
			span_blue("You begin to play a spooky refrain on your ribcage."),
			span_red("You hear a spooky xylophone melody.")
		)
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/carbon/human/proc/check_has_mouth()
	// Todo, check stomach organ when implemented.
	var/obj/item/organ/external/H = get_organ(BP_HEAD)
	if(!H || !(H.functions & BODYPART_REAGENT_INTAKE))
		return FALSE
	return TRUE

/mob/living/carbon/human/vomit(forced = 0)

	if(!check_has_mouth())
		return
	if(stat == DEAD)
		return
	if(!lastpuke)
		lastpuke = 1
		if(!forced)
			to_chat(src, span_warning("You feel nauseous..."))
			sleep(150)	//15 seconds until second warning
			to_chat(src, span_warning("You feel like you are about to throw up!"))
			sleep(100)	//and you have 10 more for mad dash to the bucket

		src.visible_message(span_warning("[src] throws up!"),span_warning("You throw up!"))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		var/turf/location = loc
		if(istype(location, /turf))
			location.add_vomit_floor(src, 1)

		adjustNutrition(-40)
		spawn(350)	//wait 35 seconds before next volley
			lastpuke = 0


/mob/living/carbon/human/proc/check_ability_cooldown(cooldown)
	var/time_passed = world.time - ability_last
	if(time_passed > cooldown)
		ability_last = world.time
		return TRUE
	else
		to_chat(src, span_notice("You can't use that yet! [cooldown / 10] seconds should pass after last ability activation. Only [time_passed / 10] seconds have passed."))


/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return NEUTER
	return gender

/mob/living/carbon/human/revive()
	if(species && !(species.flags & NO_BLOOD))
		vessel.add_reagent("blood",species.blood_volume-vessel.total_volume)
		fixblood()

	if(!client || !key) //Don't boot out anyone already in the mob.
		for(var/obj/item/organ/internal/vital/brain/H in world)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)

	losebreath = 0

	..()

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M)
	if(!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA[M.dna_trace])
			blood_DNA[M.dna_trace] = M.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	add_verb(src, /mob/living/carbon/human/proc/bloody_doodle)
	return 1 //we applied blood to the item

/mob/living/carbon/human/proc/get_full_print()
	if(!fingers_trace || get_active_mutation(src, MUTATION_NOPRINTS))
		return
	if(chem_effects[CE_DYNAMICFINGERS])
		return md5(chem_effects[CE_DYNAMICFINGERS])
	return fingers_trace

/mob/living/carbon/human/clean_blood(clean_feet)
	.=..()

	if(gloves)
		if(gloves.clean_blood())
			update_inv_gloves()
	else
		if(bloody_hands)
			bloody_hands = 0
			update_inv_gloves()

	gunshot_residue = null

	if(clean_feet)
		if(shoes)
			if(shoes.clean_blood())
				update_inv_shoes()
		else
			if(feet_blood_DNA && feet_blood_DNA.len)
				feet_blood_color = null
				feet_blood_DNA.Cut()
				update_inv_shoes()

	return

/mob/living/carbon/human/get_visible_implants()
	var/list/visible_implants = list()

	for(var/obj/item/organ/external/organ in organs)
		for(var/obj/item/I in (organ.implants & organ.embedded))
			visible_implants += I

	return visible_implants

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in organs)
		for(var/obj/item/O in organ.implants)
			if(is_sharp(O))	// Only sharp items can cause issues
				return TRUE
	return FALSE

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/obj/item/organ/external/organ in organs)
		if(organ.status & ORGAN_SPLINTED) //Splints prevent movement.
			continue

		for(var/obj/item/O in organ.implants)
			var/mob/living/carbon/human/H = organ.owner
			// Shrapnel hurts when you move, and implanting knives is a bad idea
			if(prob(5) && is_sharp(O) && !MOVING_DELIBERATELY(H))
				if(!organ.can_feel_pain())
					to_chat(src, span_warning("You feel [O] moving inside your [organ.name]."))
				else
					var/msg = pick( \
						span_warning("A spike of pain jolts your [organ.name] as you bump [O] inside."), \
						span_warning("Your hasty movement jostles [O] in your [organ.name] painfully."))
					to_chat(src, msg)
				organ.take_damage(3, BRUTE, organ.max_damage, 6.7, TRUE, TRUE)	// When the limb is at 60% of max health, internal organs start taking damage.
				if(organ.setBleeding())
					organ.take_damage(3, TOX)

/mob/living/carbon/human/verb/browse_sanity()
	set name		= "Show sanity"
	set desc		= "Browse your character sanity."
	set category	= "IC"
	set src			= usr
	sanity?.ui_interact(src)

/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message(span_notice("[usr] kneels down, puts \his hand on [src]'s wrist and begins counting their pulse."),\
		"You begin counting [src]'s pulse")
	else
		usr.visible_message(span_notice("[usr] begins counting their pulse."),\
		"You begin counting your pulse.")

	if(pulse())
		to_chat(usr, span_notice("[self ? "You have a" : "[src] has a"] pulse! Counting..."))
	else
		to_chat(usr, span_danger("[src] has no pulse!")	) //it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	to_chat(usr, "You must[self ? "" : " both"] remain still until counting is finished.")
	if(do_mob(usr, src, 60))
		to_chat(usr, span_notice("[self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)]."))
	else
		to_chat(usr, span_warning("You failed to check the pulse. Try again."))

/mob/living/carbon/human/proc/set_species(new_species, default_colour)
	// No more invisible screaming wheelchairs because of set_species() typos.
	if(!GLOB.all_species[new_species])
		new_species = SPECIES_HUMAN

	if(species)

		if(species.name && species.name == new_species)
			return
		if(species.language)
			remove_language(species.language)
		if(species.default_language)
			remove_language(species.default_language)
		// Clear out their species abilities.
		species.remove_inherent_verbs(src)
		holder_type = null

	species = GLOB.all_species[new_species]

	if(species.language)
		add_language(species.language)

	if(species.default_language)
		add_language(species.default_language)

	if(species.base_color && default_colour)
		//Apply colour.
		skin_color = species.base_color
	else
		skin_color = "#000000"

	if(species.holder_type)
		holder_type = species.holder_type

	icon_state = lowertext(species.name)

	if(species.has_process.len)
		for(var/process in species.has_process)
			internal_organs_by_efficiency[process] = list()

	rebuild_organs()
	src.sync_organ_dna()
	species.handle_post_spawn(src)

	maxHealth = species.total_health

	update_client_colour(0)

	spawn(0)
		if(QDELETED(src))	// Needed because mannequins will continue this proc and runtime after being qdel'd
			return
		regenerate_icons()
		if(vessel.total_volume < species.blood_volume)
			vessel.maximum_volume = species.blood_volume
			vessel.add_reagent("blood", species.blood_volume - vessel.total_volume)
		else if(vessel.total_volume > species.blood_volume)
			vessel.remove_reagent("blood", vessel.total_volume - species.blood_volume)
			vessel.maximum_volume = species.blood_volume
		fixblood()


	// Rebuild the HUD. If they aren't logged in then login() should reinstantiate it for them.
	check_HUD()
	/*
	if(client && client.screen)//HUD HERE!!!!!!!!!!
		client.screen.Cut()
		if(hud_used)
			qdel(hud_used)
		hud_used = new /datum/hud(src)
		update_hud()
	*/
	if(species)
		return 1
	else
		return 0

//Needed for augmentation
/mob/living/carbon/human/proc/rebuild_organs(from_preference)
	if(!species)
		return FALSE

	status_flags |= REBUILDING_ORGANS

	var/obj/item/organ/internal/carrion/core = random_organ_by_process(BP_SPCORE)
	var/list/organs_to_readd = list()
	if(core) //kinda wack, this whole proc should be remade
		for(var/obj/item/organ/internal/carrion/C in internal_organs)
			C.removed_mob()
			organs_to_readd += C

	var/obj/item/implant/core_implant/CI = get_core_implant()
	var/checkprefcruciform = FALSE	// To reset the cruciform to original form
	if(CI)
		checkprefcruciform = TRUE
		qdel(CI)


	if(from_preference)
		for(var/obj/item/organ/organ in (organs|internal_organs))
			qdel(organ)

		if(organs.len)
			organs.Cut()
		if(internal_organs.len)
			internal_organs.Cut()
		if(organs_by_name.len)
			organs_by_name.Cut()
		var/datum/preferences/Pref
		if(istype(from_preference, /datum/preferences))
			Pref = from_preference
		else if(client)
			Pref = client.prefs
		else
			return

		var/datum/body_modification/BM

		for(var/tag in species.has_limbs)
			BM = Pref.get_modification(tag)
			var/datum/organ_description/OD = species.has_limbs[tag]
//			var/datum/body_modification/PBM = Pref.get_modification(OD.parent_organ_base)
//			if(PBM && (PBM.nature == MODIFICATION_SILICON || PBM.nature == MODIFICATION_REMOVED))
//				BM = PBM
			if(BM.is_allowed(tag, Pref, src))
				BM.create_organ(src, OD, Pref.modifications_colors[tag])
			else
				OD.create_organ(src)

		for(var/tag in species.has_process)
			BM = Pref.get_modification(tag)
			if(BM.is_allowed(tag, Pref, src))
				BM.create_organ(src, species.has_process[tag], Pref.modifications_colors[tag])
			else
				var/organ_type = species.has_process[tag]
				new organ_type(src)

		var/datum/category_item/setup_option/core_implant/I = Pref.get_option("Core implant")
		if(I.implant_type && (!mind || mind.assigned_role != "Robot"))
			var/obj/item/implant/core_implant/C = new I.implant_type
			C.install(src)
			C.activate()
			if(mind)
				C.install_default_modules_by_job(mind.assigned_job)
				C.access.Add(mind.assigned_job.cruciform_access)
				C.security_clearance = mind.assigned_job.security_clearance

	else
		var/organ_type

		for(var/limb_tag in species.has_limbs)
			var/datum/organ_description/OD = species.has_limbs[limb_tag]
			var/obj/item/I = organs_by_name[limb_tag]
			if(I && I.type == OD.default_type)
				continue
			else if(I)
				qdel(I)
			OD.create_organ(src)

		for(var/organ_tag in species.has_process)
			organ_type = species.has_process[organ_tag]
			var/obj/item/I = random_organ_by_process(organ_tag)
			if(I && I.type == organ_type)
				continue
			else if(I)
				qdel(I)
			new organ_type(src)

		if(checkprefcruciform && client)
			var/datum/category_item/setup_option/core_implant/I = client.prefs.get_option("Core implant")
			if(I.implant_type)
				var/obj/item/implant/core_implant/C = new I.implant_type
				C.install(src)
				C.activate()
				C.install_default_modules_by_job(mind.assigned_job)
				C.access.Add(mind.assigned_job.cruciform_access)
				C.security_clearance = mind.assigned_job.security_clearance

	for(var/obj/item/organ/internal/carrion/C in organs_to_readd)
		C.replaced(get_organ(C.parent_organ_base))

	status_flags &= ~REBUILDING_ORGANS
	species.organs_spawned(src)

	update_body()

/mob/living/carbon/human/proc/post_prefinit()
	var/obj/item/implant/core_implant/C = locate() in src
	if(C)
		C.install(src)
		C.activate()
		C.install_default_modules_by_job(mind.assigned_job)
		C.access |= mind.assigned_job.cruciform_access
		C.security_clearance = mind.assigned_job.security_clearance

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if(src.stat)
		return

	if(usr != src)
		return 0 //something is terribly wrong

	if(!bloody_hands)
		remove_verb(src, /mob/living/carbon/human/proc/bloody_doodle)

	if(src.gloves)
		to_chat(src, span_warning("Your [src.gloves] are getting in the way."))
		return

	var/turf/T = src.loc
	if(!istype(T)) //to prevent doodling out of mechs and lockers
		to_chat(src, span_warning("You cannot reach the floor."))
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if(direction != "Here")
		T = get_step(T,text2dir(direction))
	if(!istype(T))
		to_chat(src, span_warning("You cannot doodle there."))
		return

	var/num_doodles = 0
	for(var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if(num_doodles > 4)
		to_chat(src, span_warning("There is no space to write on!"))
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if(message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if(length(message) > max_length)
			message += "-"
			to_chat(src, span_warning("You ran out of blood to write with!"))

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/can_inject(mob/user, error_msg, target_zone)
	. = 1
	if(!target_zone)
		if(user)
			target_zone = user.targeted_organ
		else
			// Pick an existing non-robotic limb, if possible.
			for(target_zone in BP_ALL_LIMBS)
				var/obj/item/organ/external/affecting = get_organ(target_zone)
				if(affecting && BP_IS_ORGANIC(affecting) || BP_IS_ASSISTED(affecting))
					break


	var/obj/item/organ/external/affecting = get_organ(target_zone)
	var/fail_msg
	if(!affecting)
		. = 0
		fail_msg = "They are missing that limb."
	else if(BP_IS_ROBOTIC(affecting))
		. = 0
		fail_msg = "That limb is robotic."
	else
		switch(target_zone)
			if(BP_HEAD)
				if(head && head.item_flags & THICKMATERIAL)
					. = 0
			else
				if(wear_suit && wear_suit.item_flags & THICKMATERIAL)
					. = 0
	if(!. && error_msg && user)
		if(BP_IS_LIFELIKE(affecting) && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
			fail_msg = "Skin is tough and inelastic."
		else if(!fail_msg)
			fail_msg = "There is no exposed flesh or thin material [target_zone == BP_HEAD ? "on their head" : "on their body"] to inject into."
		to_chat(user, span_warning(fail_msg))

/mob/living/carbon/human/get_flavor_text(shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & FACE)
			// Do not show flavor if face is hidden
			return

	if(client)
		flavor_text = client.prefs.flavor_text

	if(flavor_text && flavor_text != "" && !shrink)
		var/msg = trim(replacetext(flavor_text, "\n", " "))
		if(!msg) return ""
		if(length(msg) <= 40)
			return "<font color='blue'>[msg]</font>"
		else
			return "<font color='blue'>[copytext_preserve_html(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a></font>"
	return ..()

/mob/living/carbon/human/has_brain()
	if(organ_list_by_process(BP_BRAIN).len)
		return TRUE
	return FALSE

/mob/living/carbon/human/has_eyes()
	if(organ_list_by_process(BP_EYES).len)
		for(var/obj/item/organ/internal/eyes in organ_list_by_process(OP_EYES))
			if(!(eyes && istype(eyes) && !(eyes.status & ORGAN_CUT_AWAY)))
				return FALSE
			return TRUE
	return FALSE

/mob/living/carbon/human/slip(slipped_on, stun_duration=8)
	if((species.flags & NO_SLIP) || (shoes && (shoes.item_flags & NOSLIP)))
		return FALSE
	return ..(slipped_on,stun_duration)


/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()


/mob/living/carbon/human/can_stand_overridden()
	if(wearing_rig && wearing_rig.ai_can_move_suit(check_for_ai = 1))
		// Actually missing a leg will screw you up. Everything else can be compensated for.
		for(var/limbcheck in list(BP_L_LEG ,BP_R_LEG))
			var/obj/item/organ/affecting = get_organ(limbcheck)
			if(!affecting)
				return 0
		return 1
	return 0

/mob/living/carbon/human/MouseDrop(atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(holder_type && istype(H) && H.a_intent == I_HELP && !H.lying && !issmall(H) && Adjacent(H))
		get_scooped(H, (usr == src))
		return
	return ..()

/mob/living/carbon/human/verb/pull_punches()
	set name = "Hold your attacks back"
	set desc = "Try not to hurt them."
	set category = "IC"

	if(stat) return
	holding_back = !holding_back
	to_chat(src, span_notice("You are now [holding_back ? "holding back your attacks" : "not holding back your attacks"]."))
	return

/mob/living/carbon/human/verb/access_holster()
	set name = "Holster"
	set desc = "Try to access your holsters."
	set category = "IC"
	if(stat)
		return
	var/holster_found = FALSE

	for(var/obj/item/storage/pouch/holster/holster in list(back, s_store, belt, l_store, r_store))
	//found a pouch holster
		holster_found = TRUE
		if(holster.holster_verb(src))//did it do something? If not, we ignore it
			return
	//no pouch holsters, anything on our uniform then?
	if(w_uniform)
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.accessories.len)
				for(var/obj/item/clothing/accessory/holster/H in U.accessories)
					if(get_active_held_item())//do we hold something?
						H.attackby(get_active_held_item(), src)
					else
						H.attack_hand(src)
					holster_found = TRUE
					return
	//nothing at all!
	if(!holster_found)
		to_chat(src, span_notice("You don\'t have any holsters."))

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/human/proc/get_pulse(method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0
	switch(pulse())
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
		if(PULSE_NORM)
			temp = rand(60, 90)
		if(PULSE_FAST)
			temp = rand(90, 120)
		if(PULSE_2FAST)
			temp = rand(120, 160)
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
	return "[method ? temp : temp + rand(-10, 10)]"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/human/proc/pulse()
	if(stat == DEAD || !(organ_list_by_process(OP_HEART).len))
		return PULSE_NONE
	else
		return pulse

/mob/living/carbon/human/verb/lookup()
	set name = "Look up"
	set desc = "If you want to know what's above."
	set category = "IC"

	// /mob/living/handle_vision has vision not reset if the user has the machine var referencing something
	// which it will always have since it is very poorly handled in its dereferencing SPCR - 2022
	machine = null
	if(!is_physically_disabled())
		var/turf/above = GetAbove(src)
		if(shadow)
			if(client.eye == shadow)
				reset_view(0)
				return
			if(above.is_hole)
				to_chat(src, span_notice("You look up."))
				if(client)
					reset_view(shadow)
				return
		to_chat(src, span_notice("You can see [above]."))
	else
		to_chat(src, span_notice("You can't do it right now."))
	return

/mob/living/carbon/human/should_have_process(organ_check)

	var/obj/item/organ/external/affecting
	if(organ_check in list(OP_HEART, OP_LUNGS, OP_STOMACH))
		affecting = organs_by_name[BP_CHEST]
	else if(organ_check in list(OP_LIVER, OP_KIDNEYS, OP_KIDNEY_LEFT, OP_KIDNEY_RIGHT))
		affecting = organs_by_name[BP_GROIN]

	if(affecting && (BP_IS_ROBOTIC(affecting)))
		return FALSE
	return (species && species.has_process[organ_check])

/mob/living/carbon/human/proc/check_self_for_injuries()
	if(stat)
		return
	visible_message(span_notice("You examine yourself."), span_notice("[src] examines themself."))

	var/list/combined_msg = list()

	combined_msg += span_boldnotice("I check myself for injuries.")

	for(var/obj/item/organ/external/org in organs)
		var/list/status = list()
		var/brutedamage = org.brute_dam
		var/burndamage = org.burn_dam
		if(halloss > 0)
			if(prob(30))
				brutedamage += halloss
			if(prob(30))
				burndamage += halloss
		switch(brutedamage)
			if(1 to 20)
				status += "bruised"
			if(20 to 40)
				status += "wounded"
			if(40 to INFINITY)
				status += "mangled"

		switch(burndamage)
			if(1 to 10)
				status += "numb"
			if(10 to 40)
				status += "blistered"
			if(40 to INFINITY)
				status += "peeling away"

		if(org.is_stump())
			status += "MISSING"
		if(org.status & ORGAN_MUTATED)
			status += "weirdly shapen"
		if(org.nerve_struck == 2)
			status += "torpid"
		if(org.status & ORGAN_BROKEN)
			status += "hurts when touched"
		if(org.status & ORGAN_DEAD)
			status += "is bruised and necrotic"
		if(!org.is_usable())
			status += "dangling uselessly"

		var/status_text = span_notice("OK")
		if(status.len)
			status_text = span_warning(english_list(status))

		combined_msg += "My [org.name] is [status_text]."

	combined_msg += "\n"

	switch(nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			combined_msg += span_info("I'm completely stuffed!")
		if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
			combined_msg += span_info("I'm well fed!")
		if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
			combined_msg += span_info("I'm not hungry.")
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			combined_msg += span_info("I could use a bite to eat.")
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			combined_msg += span_info("I feel quite hungry.")
		if(0 to NUTRITION_LEVEL_STARVING)
			combined_msg += span_danger("I'm starving!")

	to_chat(src, boxed_message(combined_msg.Join("\n")))

/mob/living/carbon/human/need_breathe()
//	if(!(mNobreath in mutations))
//		return TRUE
//	else
	return FALSE

/mob/living/carbon/human/proc/set_remoteview(atom/A)
	remoteview_target = A
	reset_view(A)

/mob/living/carbon/human/proc/resuscitate()

	var/obj/item/organ/internal/vital/heart_organ = random_organ_by_process(OP_HEART)
	var/obj/item/organ/internal/vital/brain_organ = random_organ_by_process(BP_BRAIN)

	if((!heart_organ || heart_organ.is_broken()) && (!brain_organ || brain_organ.is_broken()))
		resuscitate_notify(1)
		return 0

	if(!heart_organ || heart_organ.is_broken())
		resuscitate_notify(2)
		return 0

	if(!brain_organ || brain_organ.is_broken())
		resuscitate_notify(3)
		return 0

	if(world.time >= (timeofdeath + NECROZTIME))
		resuscitate_notify(4)
		return 0

	var/oxyLoss = getOxyLoss()
	if(oxyLoss > 20)
		setOxyLoss(20)

	if(getBruteLoss() + getFireLoss() >= abs(CONFIG_GET(number/health_threshold_dead)))
		resuscitate_notify(5)
		timeofdeath = 0
		return 0

	visible_message(span_notice("\The [src] twitches a bit as their heart restarts!"))
	pulse = PULSE_NORM
	handle_pulse()
	timeofdeath = 0
	stat = UNCONSCIOUS
	jitteriness += 3 SECONDS
	updatehealth()
	switch_from_dead_to_living_mob_list()

	var/obj/item/implant/core_implant/cruciform/CI = get_core_implant(/obj/item/implant/core_implant/cruciform, req_activated = FALSE)
	if(CI && CI.active)
		lost_cruciforms -= CI

	if(mind)
		for(var/mob/observer/ghost/G in GLOB.player_list)
			if(G.can_reenter_corpse && G.mind == mind)
				if(alert("Do you want to enter your body?","Resuscitate","OH YES","No.") == "OH YES")
					G.reenter_corpse()
					break
				else
					break
	return 1

/mob/living/carbon/human/proc/resuscitate_notify(type)
	visible_message(span_warning("\The [src] twitches and twists intensely!"))
	for(var/mob/O in viewers(world.view, src.loc))
		if(O == src)
			continue
		if(!Adjacent(O))
			continue
		var/bio_stat = STAT_LEVEL_NONE
		if(O.stats)
			bio_stat = O.stats.getStat(STAT_BIO)
		if(isghost(O))
			bio_stat = STAT_LEVEL_GODLIKE

		if(bio_stat >= STAT_LEVEL_BASIC && prob(clamp((bio_stat / STAT_LEVEL_EXPERT) * 100, 0, 100)))
			switch(type)
				if(1) //brain and heart fail
					to_chat(O, "<font color='blue'>You can identify that [src]'s circulatory and central neural systems are failing, preventing them from resurrection.</font>")
				if(2) //heart fail
					to_chat(O, "<font color='blue'>You can identify that [src]'s circulatory system is unable to restart in this state.</font>")
				if(3) //brain fail
					to_chat(O, "<font color='blue'>You can identify that [src]'s central neural system is too damaged to be resurrected.</font>")
				if(4) //corpse is too old
					to_chat(O, "<font color='blue'>You see that rotting process in [src]'s body already gone too far. This is nothing but a corpse now.</font>")
				if(5) //too much damage
					to_chat(O, "<font color='blue'>[src]'s body is too damaged to sustain life.</font>")
		else
			to_chat(O, "<font color='red'>You're too unskilled to understand what's happening...</font>")

/mob/living/carbon/human/proc/generate_dna()
	if(!b_type)
		b_type = pick(GLOB.blood_types)

	if(!isMonkey(src))
		while(dormant_mutations.len < STARTING_MUTATIONS)
			var/datum/mutation/M = pickweight(list(
				pick(subtypesof(/datum/mutation/t0)) = 45,
				pick(subtypesof(/datum/mutation/t1)) = 25,
				pick(subtypesof(/datum/mutation/t2)) = 15,
				pick(subtypesof(/datum/mutation/t3)) = 10,
				pick(subtypesof(/datum/mutation/t4)) = 5))
			dormant_mutations |= new M

/mob/living/carbon/human/verb/blocking()
	set name = "Blocking"
	set desc = "Block an incoming melee attack, or lower your guard."
	set category = "IC"

	if(stat || restrained())
		return
	if(!blocking)
		start_blocking()
	else
		stop_blocking()

/mob/living/carbon/human/proc/start_blocking()
	if(blocking)//already blocking with an item somehow?
		return
	blocking = TRUE
	visible_message(span_warning("[src] tenses up, ready to block!"))
	if(HUDneed.Find("block"))
		var/obj/screen/block/HUD = HUDneed["block"]
		HUD.update_icon()
	update_block_overlay()
	return

/mob/living/carbon/human/proc/stop_blocking()
	if(!blocking)//already blockingn't with an item somehow?
		return
	blocking = FALSE
	visible_message(span_notice("[src] lowers \his guard."))
	if(HUDneed.Find("block"))
		var/obj/screen/block/HUD = HUDneed["block"]
		HUD.update_icon()
	update_block_overlay()
	return

/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", VV_HK_SPACER)
	VV_DROPDOWN_OPTION(VV_HK_MAKE_ROBOT, "Make Robot")
	VV_DROPDOWN_OPTION(VV_HK_MAKE_SLIME, "Make Slime")
	VV_DROPDOWN_OPTION(VV_HK_MAKE_AI, "Make AI")
	VV_DROPDOWN_OPTION(VV_HK_SET_SPECIES, "Set Species")

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_MAKE_ROBOT] && check_rights(R_FUN))
		if(alert("Confirm mob type change to robot?",,"Transform","Cancel") != "Transform") return
		usr.client.cmd_admin_robotize(src)
	if(href_list[VV_HK_MAKE_SLIME] && check_rights(R_FUN))
		if(alert("Confirm mob type change to slime?",,"Transform","Cancel") != "Transform") return
		usr.client.cmd_admin_slimeize(src)
	if(href_list[VV_HK_MAKE_AI] && check_rights(R_FUN))
		if(alert("Confirm mob type change to AI?",,"Transform","Cancel") != "Transform") return
		usr.client.cmd_admin_aiize(src)
	if(href_list[VV_HK_SET_SPECIES] && check_rights(R_SPAWN))
		var/result = input(usr, "Please choose a new species","Species") as null|anything in GLOB.all_species
		if(result)
			set_species(result)
			log_game("[key_name(usr)] has modified the bodyparts of [src] to [src.species]")
			message_admins("[key_name(usr)] has modified the bodyparts of [src] to [src.species]")

