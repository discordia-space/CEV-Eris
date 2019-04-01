/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list[10]
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/obj/item/weapon/rig/wearing_rig // This is very not good, but it's much much better than calling get_rig() every update_lying_buckled_and_verb_status() call.

/mob/living/carbon/human/New(var/new_loc, var/new_species = null)
	body_build = get_body_build(gender)

	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

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

	hud_list[HEALTH_HUD]      = image('icons/mob/hud.dmi', src, "hudhealth100", ON_MOB_HUD_LAYER)
	hud_list[STATUS_HUD]      = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list[LIFE_HUD]        = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list[ID_HUD]          = image('icons/mob/hud.dmi', src, "hudunknown",   ON_MOB_HUD_LAYER)
	hud_list[WANTED_HUD]      = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[IMPCHEM_HUD]     = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[IMPTRACK_HUD]    = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[SPECIALROLE_HUD] = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list[STATUS_HUD_OOC]  = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)



	GLOB.human_mob_list |= src
	..()

	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		sync_organ_dna()
	make_blood()

/mob/living/carbon/human/Destroy()
	GLOB.human_mob_list -= src
	for(var/organ in organs)
		qdel(organ)
	return ..()

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Intent:", "[a_intent]")
		stat("Move Mode:", "[move_intent.name]")
		if(evacuation_controller)
			var/eta_status = evacuation_controller.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)

		if (internal)
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		var/obj/item/organ/internal/xenos/plasmavessel/P = internal_organs_by_name[BP_PLASMA]
		if(P)
			stat(null, "Plasma Stored: [P.stored_plasma]/[P.max_plasma]")

		if(back && istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/suit = back
			var/cell_status = "ERROR"
			if(suit.cell) cell_status = "[suit.cell.charge]/[suit.cell.maxcharge]"
			stat(null, "Suit charge: [cell_status]")

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)

		var/obj/item/weapon/implant/core_implant/cruciform/C = get_cruciform()
		if (C)
			stat("Cruciform", "[C.power]/[C.max_power]")

/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		if (HUDtech.Find("flash"))
			flick("flash", HUDtech["flash"])

	var/shielded = 0
	var/b_loss = null
	var/f_loss = null
	var/bomb_defense = getarmor(null, "bomb")
	switch (severity)
		if (1.0)
			b_loss += 500
			if (!prob(bomb_defense))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if (2.0)
			if (!shielded)
				b_loss += 60

			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if (prob(70) && !shielded)
				Paralyse(10)

		if(3.0)
			b_loss += 30
			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if (prob(50) && !shielded)
				Paralyse(10)
	if (bomb_defense)
		b_loss = max(b_loss - bomb_defense, 0)
		f_loss = max(f_loss - bomb_defense, 0)
	var/update = 0

	// focus most of the blast on one organ
	var/obj/item/organ/external/take_blast = pick(organs)
	update |= take_blast.take_damage(b_loss * 0.9, f_loss * 0.9, used_weapon = "Explosive blast")

	// distribute the remaining 10% on all limbs equally
	b_loss *= 0.1
	f_loss *= 0.1

	var/weapon_message = "Explosive Blast"

	for(var/obj/item/organ/external/temp in organs)
		switch(temp.name)
			if(BP_HEAD)
				update |= temp.take_damage(b_loss * 0.2, f_loss * 0.2, used_weapon = weapon_message)
			if(BP_CHEST)
				update |= temp.take_damage(b_loss * 0.4, f_loss * 0.4, used_weapon = weapon_message)
			else
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
	if(update)
		UpdateDamageIcon()


/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as mob)
	if(user.incapacitated()  || !user.Adjacent(src))
		return

	var/obj/item/clothing/under/suit = null
	if (istype(w_uniform, /obj/item/clothing/under))
		suit = w_uniform

	user.set_machine(src)
	var/dat = "<B><HR><FONT size=3>[name]</FONT></B><BR><HR>"

	for(var/entry in species.hud.gear)
		var/slot = species.hud.gear[entry]
		if(slot in list(slot_l_store, slot_r_store))
			continue
		var/obj/item/thing_in_slot = get_equipped_item(slot)
		dat += "<BR><B>[entry]:</b> <a href='?src=\ref[src];item=[slot]'>[istype(thing_in_slot) ? thing_in_slot : "nothing"]</a>"

	dat += "<BR><HR>"

/*	if(species.hud.has_hands)
		dat += "<BR><b>Left hand:</b> <A href='?src=\ref[src];item=[slot_l_hand]'>[istype(l_hand) ? l_hand : "nothing"]</A>"
		dat += "<BR><b>Right hand:</b> <A href='?src=\ref[src];item=[slot_r_hand]'>[istype(r_hand) ? r_hand : "nothing"]</A>"*/

	// Do they get an option to set internals?
	if(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space))
		if(istype(back, /obj/item/weapon/tank) || istype(belt, /obj/item/weapon/tank) || istype(s_store, /obj/item/weapon/tank))
			dat += "<BR><A href='?src=\ref[src];item=internals'>Toggle internals.</A>"

	// Other incidentals.
	if(handcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_handcuffed]'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_legcuffed]'>Legcuffed</A>"

	if(suit && suit.accessories.len)
		dat += "<BR><A href='?src=\ref[src];item=tie'>Remove accessory</A>"
	dat += "<BR><A href='?src=\ref[src];item=splints'>Remove splints</A>"
	dat += "<BR><A href='?src=\ref[src];item=pockets'>Empty pockets</A>"
	dat += "<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>"
	dat += "<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>"

	user << browse(dat, text("window=mob[name];size=340x540"))
	onclose(user, "mob[name]")
	return

// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	if(istype(AM, /obj/machinery/bot/mulebot))
		var/obj/machinery/bot/mulebot/MB = AM
		MB.RunOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/weapon/card/id/id = GetIdCard()
	if(istype(id))
		return id.rank ? id.rank : if_no_job
	else
		return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/weapon/card/id/id = GetIdCard()
	if(istype(id))
		return id.assignment ? id.assignment : if_no_job
	else
		return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/weapon/card/id/id = GetIdCard()
	if(id)
		return id.registered_name || if_no_id
	else
		return if_no_id

//Trust me I'm an engineer
//I think we'll put this shit right here
var/list/rank_prefix = list(\
	"Ironhammer Operative" = "Operative",\
	"Inspector" = "Inspector",\
	"Gunnery Sergeant" = "Sergeant",\
	"Ironhammer Commander" = "Lieutenant",\
	"Captain" = "Captain",\
	)

/mob/living/carbon/human/proc/rank_prefix_name(name)
	if(get_id_rank())
		if(findtext(name, " "))
			name = copytext(name, findtext(name, " "))
		name = get_id_rank() + name
	return name

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
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
	if(!head || head.disfigured || head.is_stump() || !real_name || (HUSK in mutations) )	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	var/obj/item/weapon/card/id/I = GetIdCard()
	if(istype(I))
		return I.registered_name

/mob/living/carbon/human/proc/get_id_rank()
	var/rank
	var/obj/item/weapon/card/id/id
	if (istype(wear_id, /obj/item/modular_computer/pda))
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
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)
	if(status_flags & GODMODE)	return 0	//godmode

	if (!def_zone)
		def_zone = pick(BP_L_ARM, BP_R_ARM)

	var/obj/item/organ/external/affected_organ = get_organ(check_zone(def_zone))
	var/siemens_coeff = base_siemens_coeff * get_siemens_coefficient_organ(affected_organ)

	return ..(shock_damage, source, siemens_coeff, def_zone)


/mob/living/carbon/human/Topic(href, href_list)

	if (href_list["refresh"])
		if((machine)&&(in_range(src, usr)))
			show_inv(machine)

	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if(href_list["item"])
		handle_strip(href_list["item"],usr)

	if (href_list["criminal"])
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
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/weapon/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								usr << "<b>Name:</b> [R.fields["name"]]	<b>Criminal Status:</b> [R.fields["criminal"]]"
								usr << "<b>Minor Crimes:</b> [R.fields["mi_crim"]]"
								usr << "<b>Details:</b> [R.fields["mi_crim_d"]]"
								usr << "<b>Major Crimes:</b> [R.fields["ma_crim"]]"
								usr << "<b>Details:</b> [R.fields["ma_crim_d"]]"
								usr << "<b>Notes:</b> [R.fields["notes"]]"
								usr << "<a href='?src=\ref[src];secrecordComment=`'>\[View Comment Log\]</a>"
								read = 1

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["secrecordComment"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/weapon/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									usr << text("[]", R.fields[text("com_[]", counter)])
									counter++
								if (counter == 1)
									usr << "No comment found"
								usr << "<a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>"

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["secrecordadd"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/weapon/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								var/t1 = sanitize(input("Add Comment:", "Sec. records", null, null)  as message)
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"security")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			var/obj/item/weapon/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["id"] == E.fields["id"])

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
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				var/obj/item/weapon/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								usr << "<b>Name:</b> [R.fields["name"]]	<b>Blood Type:</b> [R.fields["b_type"]]"
								usr << "<b>DNA:</b> [R.fields["b_dna"]]"
								usr << "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]"
								usr << "<b>Details:</b> [R.fields["mi_dis_d"]]"
								usr << "<b>Major Disabilities:</b> [R.fields["ma_dis"]]"
								usr << "<b>Details:</b> [R.fields["ma_dis_d"]]"
								usr << "<b>Notes:</b> [R.fields["notes"]]"
								usr << "<a href='?src=\ref[src];medrecordComment=`'>\[View Comment Log\]</a>"
								read = 1

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				var/obj/item/weapon/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									usr << text("[]", R.fields[text("com_[]", counter)])
									counter++
								if (counter == 1)
									usr << "No comment found"
								usr << "<a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>"

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/weapon/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								var/t1 = sanitize(input("Add Comment:", "Med. records", null, null)  as message)
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"medical")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		src.examinate(I)

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		src.examinate(M)

	..()
	return

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()
	if(!species.has_organ[BP_EYES]) //No eyes, can't hurt them.
		return FLASH_PROTECTION_MAJOR

	if(internal_organs_by_name[BP_EYES]) // Eyes are fucked, not a 'weak point'.
		var/obj/item/organ/I = internal_organs_by_name[BP_EYES]
		if(I.status & ORGAN_CUT_AWAY)
			return FLASH_PROTECTION_MAJOR

	return flash_protection

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(var/target_zone, var/brain_tag = BP_BRAIN)
	if(!species.has_organ[brain_tag])
		return 0

	var/obj/item/organ/affecting = internal_organs_by_name[brain_tag]

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent_organ != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/parent = get_organ(target_zone)
	if(!parent)
		return 0

	if(parent.w_class > affecting.w_class + 1)
		return prob(100 / 2**(parent.w_class - affecting.w_class - 1))

	return 1

/mob/living/carbon/human/IsAdvancedToolUser(var/silent)
	if(species.has_fine_manipulation)
		return 1
	if(!silent)
		src << SPAN_WARNING("You don't have the dexterity to use that!")
	return 0

/mob/living/carbon/human/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)))
		return 1

	if( (src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract) )
		return 1

	return 0


/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()
	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message("\red \The [src] begins playing \his ribcage like a xylophone. It's quite spooky.","\blue You begin to play a spooky refrain on your ribcage.","\red You hear a spooky xylophone melody.")
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/carbon/human/proc/check_has_mouth()
	// Todo, check stomach organ when implemented.
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(!H || !H.can_intake_reagents)
		return 0
	return 1

/mob/living/carbon/human/proc/vomit()

	if(!check_has_mouth())
		return
	if(stat == DEAD)
		return
	if(!lastpuke)
		lastpuke = 1
		src << SPAN_WARNING("You feel nauseous...")
		spawn(150)	//15 seconds until second warning
			src << SPAN_WARNING("You feel like you are about to throw up!")
			spawn(100)	//and you have 10 more for mad dash to the bucket
				Stun(5)

				src.visible_message(SPAN_WARNING("[src] throws up!"),SPAN_WARNING("You throw up!"))
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

				var/turf/location = loc
				if (istype(location, /turf/simulated))
					location.add_vomit_floor(src, 1)

				nutrition -= 40
				adjustToxLoss(-3)
				spawn(350)	//wait 35 seconds before next volley
					lastpuke = 0

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mMorph in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation",facial_color) as color
	if(new_facial)
		facial_color = new_facial

	var/new_hair = input("Please select hair color.", "Character Generation",hair_color) as color
	if(new_hair)
		hair_color = new_hair

	var/new_eyes = input("Please select eye color.", "Character Generation",eyes_color) as color
	if(new_eyes)
		eyes_color = new_eyes
		update_eyes()

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", "[35-s_tone]")  as text

	if (!new_tone)
		new_tone = 35
	s_tone = max(min(round(text2num(new_tone)), 220), 1)
	s_tone =  -s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as null|anything in hairs

	// if new style selected (not cancel)
	if (new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else
			gender = FEMALE
	regenerate_icons()
	check_dna()

	visible_message("\blue \The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!", "\blue You change your appearance!", "\red Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!")

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in world)
		creatures += h
	var/mob/target = input("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/say = sanitize(input("What do you wish to say"))
	if(mRemotetalk in target.mutations)
		target.show_message("\blue You hear [src.real_name]'s voice: [say]")
	else
		target.show_message("\blue You hear a voice that seems to echo around the room: [say]")
	usr.show_message("\blue You project your mind into [target.real_name]: [say]")
	log_say("[key_name(usr)] sent a telepathic message to [key_name(target)]: [say]")
	for(var/mob/observer/ghost/G in world)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target = null
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in world)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat!=CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if (target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target = null
		reset_view(0)

/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return NEUTER
	return gender

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()

	if(species && !(species.flags & NO_BLOOD))
		vessel.add_reagent("blood",species.blood_volume-vessel.total_volume)
		fixblood()

	// Fix up all organs.
	// This will ignore any prosthetics in the prefs currently.
	rebuild_organs()

	if(!client || !key) //Don't boot out anyone already in the mob.
		for (var/obj/item/organ/internal/brain/H in world)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)


	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	losebreath = 0

	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[BP_LUNGS]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[BP_LUNGS]

	if(L && !L.is_bruised())
		src.custom_pain("You feel a stabbing pain in your chest!", 1)
		L.bruise()

/*
/mob/living/carbon/human/verb/simulate()
	set name = "sim"
	set background = 1

	var/damage = input("Wound damage","Wound damage") as num

	var/germs = 0
	var/tdamage = 0
	var/ticks = 0
	while (germs < 2501 && ticks < 100000 && round(damage/10)*20)
		log_misc("VIRUS TESTING: [ticks] : germs [germs] tdamage [tdamage] prob [round(damage/10)*20]")
		ticks++
		if (prob(round(damage/10)*20))
			germs++
		if (germs == 100)
			world << "Reached stage 1 in [ticks] ticks"
		if (germs > 100)
			if (prob(10))
				damage++
				germs++
		if (germs == 1000)
			world << "Reached stage 2 in [ticks] ticks"
		if (germs > 1000)
			damage++
			germs++
		if (germs == 2500)
			world << "Reached stage 3 in [ticks] ticks"
	world << "Mob took [tdamage] tox damage"
*/
//returns 1 if made bloody, returns 0 otherwise

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA[M.dna.unique_enzymes])
			blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/proc/get_full_print()
	if(!dna ||!dna.uni_identity)
		return
	return md5(dna.uni_identity)

/mob/living/carbon/human/clean_blood(var/clean_feet)
	.=..()

	if(gloves)
		if(gloves.clean_blood())
			update_inv_gloves()
		gloves.germ_level = 0
	else
		if(bloody_hands)
			bloody_hands = 0
			update_inv_gloves()
		germ_level = 0

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

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/weapon/O in organ.implants)
			if(!istype(O,/obj/item/weapon/implant) && (O.w_class > class) && !istype(O,/obj/item/weapon/material/shard/shrapnel))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/weapon/implant)) //implant type items do not cause embedding effects, see handle_embedded_objects()
				return 1
	return 0

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/obj/item/organ/external/organ in src.organs)
		if(organ.status & ORGAN_SPLINTED) //Splints prevent movement.
			continue
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/weapon/implant) && prob(5)) //Moving with things stuck in you could be bad.
				// All kinds of embedded objects cause bleeding.
				if(species.flags & NO_PAIN)
					src << SPAN_WARNING("You feel [O] moving inside your [organ.name].")
				else
					var/msg = pick( \
						SPAN_WARNING("A spike of pain jolts your [organ.name] as you bump [O] inside."), \
						SPAN_WARNING("Your movement jostles [O] in your [organ.name] painfully."), \
						SPAN_WARNING("Your movement jostles [O] in your [organ.name] painfully."))
					src << msg

				organ.take_damage(rand(1,3), 0, 0)
				if(organ.setBleeding())
					src.adjustToxLoss(rand(1,3))

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
		usr.visible_message(SPAN_NOTICE("[usr] kneels down, puts \his hand on [src]'s wrist and begins counting their pulse."),\
		"You begin counting [src]'s pulse")
	else
		usr.visible_message(SPAN_NOTICE("[usr] begins counting their pulse."),\
		"You begin counting your pulse.")

	if(pulse())
		usr << "<span class='notice'>[self ? "You have a" : "[src] has a"] pulse! Counting...</span>"
	else
		usr << SPAN_DANGER("[src] has no pulse!")	//it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	usr << "You must[self ? "" : " both"] remain still until counting is finished."
	if(do_mob(usr, src, 60))
		usr << "<span class='notice'>[self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)].</span>"
	else
		usr << SPAN_WARNING("You failed to check the pulse. Try again.")

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour)
	if(!dna)
		if(!new_species)
			new_species = "Human"
	else
		if(!new_species)
			new_species = dna.species
		else
			dna.species = new_species

	// No more invisible screaming wheelchairs because of set_species() typos.
	if(!all_species[new_species])
		new_species = "Human"

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

	species = all_species[new_species]

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

	rebuild_organs()
	src.sync_organ_dna()
	species.handle_post_spawn(src)

	maxHealth = species.total_health

	spawn(0)
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

#define MODIFICATION_ORGANIC 1
#define MODIFICATION_SILICON 2
#define MODIFICATION_REMOVED 3

//Needed for augmentation
/mob/living/carbon/human/proc/rebuild_organs(var/from_preference = 0)
	if(!species)
		return 0

	for(var/obj/item/organ/organ in (organs|internal_organs))
		qdel(organ)

	if(organs.len)
		organs.Cut()
	if(internal_organs.len)
		internal_organs.Cut()
	if(organs_by_name.len)
		organs_by_name.Cut()
	if(internal_organs_by_name.len)
		internal_organs_by_name.Cut()


	if(from_preference)
		var/datum/preferences/Pref
		if(istype(from_preference, /datum/preferences))
			Pref = from_preference
		else if(client)
			Pref = client.prefs
		else
			return

		var/datum/body_modification/BM = null

		for(var/tag in species.has_limbs)
			BM = Pref.get_modification(tag)
			var/datum/organ_description/OD = species.has_limbs[tag]
			var/datum/body_modification/PBM = Pref.get_modification(OD.parent_organ)
			if(PBM && (PBM.nature == MODIFICATION_SILICON || PBM.nature == MODIFICATION_REMOVED))
				BM = PBM
			if(BM.is_allowed(tag, Pref))
				BM.create_organ(src, OD, Pref.modifications_colors[tag])
			else
				OD.create_organ(src)

		for(var/tag in species.has_organ)
			BM = Pref.get_modification(tag)
			if(BM.is_allowed(tag, Pref))
				BM.create_organ(src, species.has_organ[tag], Pref.modifications_colors[tag])
			else
				var/organ_type = species.has_organ[tag]
				new organ_type(src)

	else
		var/organ_type = null

		for(var/limb_tag in species.has_limbs)
			var/datum/organ_description/OD = species.has_limbs[limb_tag]
			OD.create_organ(src)

		for(var/organ_tag in species.has_organ)
			organ_type = species.has_organ[organ_tag]
			new organ_type(src)

	species.organs_spawned(src)

	update_body()

#undef MODIFICATION_REMOVED
#undef MODIFICATION_ORGANIC
#undef MODIFICATION_SILICON

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		src << SPAN_WARNING("Your [src.gloves] are getting in the way.")
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		src << SPAN_WARNING("You cannot reach the floor.")
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		src << SPAN_WARNING("You cannot doodle there.")
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		src << SPAN_WARNING("There is no space to write on!")
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			src << SPAN_WARNING("You ran out of blood to write with!")

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/can_inject(var/mob/user, var/error_msg, var/target_zone)
	. = 1

	if(!target_zone)
		if(user)
			target_zone = user.targeted_organ
		else
			// Pick an existing non-robotic limb, if possible.
			for(target_zone in BP_ALL_LIMBS)
				var/obj/item/organ/external/affecting = get_organ(target_zone)
				if(affecting && affecting.robotic < ORGAN_ROBOT)
					break


	var/obj/item/organ/external/affecting = get_organ(target_zone)
	var/fail_msg
	if(!affecting)
		. = 0
		fail_msg = "They are missing that limb."
	else if (affecting.robotic >= ORGAN_ROBOT)
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
		if(!fail_msg)
			fail_msg = "There is no exposed flesh or thin material [target_zone == BP_HEAD ? "on their head" : "on their body"] to inject into."
		to_chat(user, SPAN_WARNING(fail_msg))

/mob/living/carbon/human/print_flavor_text(var/shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & FACE)
			// Do not show flavor if face is hidden
			return

	if(client)
		flavor_text = client.prefs.flavor_text

	if (flavor_text && flavor_text != "" && !shrink)
		var/msg = trim(replacetext(flavor_text, "\n", " "))
		if(!msg) return ""
		if(lentext(msg) <= 40)
			return "<font color='blue'>[russian_to_cp1251(msg)]</font>"
		else
			return "<font color='blue'>[copytext_preserve_html(russian_to_cp1251(msg), 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a></font>"
	return ..()

/mob/living/carbon/human/getDNA()
	if(species.flags & NO_SCAN)
		return null
	..()

/mob/living/carbon/human/setDNA()
	if(species.flags & NO_SCAN)
		return
	..()

/mob/living/carbon/human/has_brain()
	return istype(internal_organs_by_name[BP_BRAIN], /obj/item/organ/internal/brain)

/mob/living/carbon/human/has_eyes()
	if(internal_organs_by_name[BP_EYES])
		var/obj/item/organ/internal/eyes = internal_organs_by_name[BP_EYES]
		if(eyes && istype(eyes) && !(eyes.status & ORGAN_CUT_AWAY))
			return 1
	return 0

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	if((species.flags & NO_SLIP) || (shoes && (shoes.item_flags & NOSLIP)))
		return 0
	..(slipped_on,stun_duration)

/mob/living/carbon/human/proc/undislocate()
	set category = "Object"
	set name = "Undislocate Joint"
	set desc = "Pop a joint back into place. Extremely painful."
	set src in view(1)

	if(!isliving(usr) || !usr.can_click())
		return

	usr.setClickCooldown(20)

	if(usr.stat > 0)
		usr << "You are unconcious and cannot do that!"
		return

	if(usr.restrained())
		usr << "You are restrained and cannot do that!"
		return

	var/mob/S = src
	var/mob/U = usr
	var/self = null
	if(S == U)
		self = 1 // Removing object from yourself.

	var/list/limbs = list()
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/current_limb = organs_by_name[limb]
		if(current_limb && current_limb.dislocated == 2)
			limbs |= limb
	var/choice = input(usr,"Which joint do you wish to relocate?") as null|anything in limbs

	if(!choice)
		return

	var/obj/item/organ/external/current_limb = organs_by_name[choice]

	if(self)
		src << SPAN_WARNING("You brace yourself to relocate your [current_limb.joint]...")
	else
		U << SPAN_WARNING("You begin to relocate [S]'s [current_limb.joint]...")

	if(!do_after(U, 30, src))
		return
	if(!choice || !current_limb || !S || !U)
		return

	if(self)
		src << SPAN_DANGER("You pop your [current_limb.joint] back in!")
	else
		U << SPAN_DANGER("You pop [S]'s [current_limb.joint] back in!")
		S << SPAN_DANGER("[U] pops your [current_limb.joint] back in!")
	current_limb.undislocate()

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

/mob/living/carbon/human/MouseDrop(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(holder_type && istype(H) && H.a_intent == I_HELP && !H.lying && !issmall(H) && Adjacent(H))
		get_scooped(H, (usr == src))
		return
	return ..()

/mob/living/carbon/human/verb/pull_punches()
	set name = "Pull Punches"
	set desc = "Try not to hurt them."
	set category = "IC"

	if(stat) return
	pulling_punches = !pulling_punches
	src << "<span class='notice'>You are now [pulling_punches ? "pulling your punches" : "not pulling your punches"].</span>"
	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/human/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
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
	var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
	if(!H)
		return PULSE_NONE
	else
		return H.pulse

/mob/living/carbon/human/verb/lookup()
	set name = "Look up"
	set desc = "If you want to know what's above."
	set category = "IC"

	if(!is_physically_disabled())
		var/turf/above = GetAbove(src)
		if(shadow)
			if(client.eye == shadow)
				reset_view(0)
				return
			if(above.is_hole)
				src << SPAN_NOTICE("You look up.")
				if(client)
					reset_view(shadow)
				return
		src << SPAN_NOTICE("You can see [above].")
	else
		src << SPAN_NOTICE("You can't do it right now.")
	return

/mob/living/carbon/human/should_have_organ(var/organ_check)

	var/obj/item/organ/external/affecting
	if(organ_check in list(BP_HEART, BP_LUNGS))
		affecting = organs_by_name[BP_CHEST]
	else if(organ_check in list(BP_LIVER, BP_KIDNEYS))
		affecting = organs_by_name[BP_GROIN]

	if(affecting && (affecting.robotic >= ORGAN_ROBOT))
		return FALSE
	return (species && species.has_organ[organ_check])

/mob/living/carbon/human/has_appendage(var/appendage_check)	//returns TRUE if found, 2 or 3 if limb is robotic, FALSE if not found

	if (appendage_check == BP_CHEST)
		return TRUE

	var/obj/item/organ/external/appendage
	appendage = organs_by_name[appendage_check]

	if(appendage && !appendage.is_stump())
		if(appendage.robotic >= ORGAN_ROBOT)
			return appendage.robotic
		else return TRUE
	return FALSE

