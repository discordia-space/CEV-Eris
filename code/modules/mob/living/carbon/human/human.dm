/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list691069
	var/embedded_flag	  //To check if we've69eed to roll for damage on69ovement while an item is imbedded in us.
	var/obj/item/rig/wearing_rig // This is69ery69ot good, but it's69uch69uch better than calling get_rig() every update_lying_buckled_and_verb_status() call.
	var/obj/item/gun/using_scope // This is69ot69ery good either, because I've copied it. Sorry.

/mob/living/carbon/human/New(var/new_loc,69ar/new_species)

	if(!dna)
		dna =69ew /datum/dna(null)
		// Species69ame is handled by set_species()

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

	hud_list69HEALTH_HUD69      = image('icons/mob/hud.dmi', src, "hudhealth100", ON_MOB_HUD_LAYER)
	hud_list69STATUS_HUD69      = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list69LIFE_HUD69        = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list69ID_HUD69          = image('icons/mob/hud.dmi', src, "hudunknown",   ON_MOB_HUD_LAYER)
	hud_list69WANTED_HUD69      = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list69IMPCHEM_HUD69     = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list69IMPTRACK_HUD69    = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list69SPECIALROLE_HUD69 = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)
	hud_list69STATUS_HUD_OOC69  = image('icons/mob/hud.dmi', src, "hudhealthy",   ON_MOB_HUD_LAYER)
	hud_list69EXCELSIOR_HUD69   = image('icons/mob/hud.dmi', src, "hudblank",     ON_MOB_HUD_LAYER)



	GLOB.human_mob_list |= src
	..()

	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		sync_organ_dna()
	make_blood()

	sanity =69ew(src)

	AddComponent(/datum/component/fabric)

/mob/living/carbon/human/Destroy()
	GLOB.human_mob_list -= src

	// Prevent death from organ removal
	status_flags |= REBUILDING_ORGANS
	for(var/organ in organs)
		qdel(organ)
	organs.Cut()
	return ..()

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Intent:", "69a_intent69")
		stat("Move69ode:", "69move_intent.name69")
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

		if(back && istype(back,/obj/item/rig))
			var/obj/item/rig/suit = back
			var/cell_status = "ERROR"
			if(suit.cell) cell_status = "69suit.cell.charge69/69suit.cell.maxcharge69"
			stat(null, "Suit charge: 69cell_status69")

		var/chemvessel_efficiency = get_organ_efficiency(OP_CHEMICALS)
		if(chemvessel_efficiency > 1)
			stat("Chemical Storage", "69carrion_stored_chemicals69/69round(0.5 * chemvessel_efficiency)69")

		var/maw_efficiency = get_organ_efficiency(OP_MAW)
		if(maw_efficiency > 1)
			stat("Gnawing hunger", "69carrion_hunger69/69round(maw_efficiency/10)69")

		var/obj/item/implant/core_implant/cruciform/C = get_core_implant(/obj/item/implant/core_implant/cruciform)
		if (C)
			stat("Cruciform", "69C.power69/69C.max_power69")

/mob/living/carbon/human/ex_act(severity, epicenter)
	if(!blinded)
		if (HUDtech.Find("flash"))
			flick("flash", HUDtech69"flash"69)

	var/b_loss = 0
	var/bomb_defense = getarmor(null, ARMOR_BOMB) +69ob_bomb_defense
	var/target_turf //69ull69eans epicenter is same tile
	if (epicenter != get_turf(src))
		target_turf = get_turf_away_from_target_simple(src, epicenter, 8)
	var/throw_distance = 8 - 2*severity
	var/not_slick = TRUE
	if (target_turf) // this69eans explosions on the same tile will69ot fling you
		throw_at(target_turf, throw_distance, 5)
		not_slick = FALSE // only explosions that fling you can be survived with slickness
	if (slickness < (9-(2*severity)) * 10)
		Weaken(severity) // If they don't get knocked out , weaken them for a bit.
		not_slick = TRUE // if you don't have enough slickness, you can't safely ride the boom
	else
		slickness -= (9-(2*severity)) * 10 // awesome feats aren't something you can do constantly.

	switch (severity)
		if (1)
			if (not_slick)
				b_loss += 500
				if (!prob(bomb_defense))
					gib()
					return
			else
				visible_message(SPAN_WARNING("69src69 rides the shockwave!"))
				dodge_time = get_game_time()
				confidence = FALSE
				slickness = 0 // this69ost likely would otherwise gib src, so it empties slickness.

		if (2)
			if (not_slick)
				b_loss = 150
				if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
					adjustEarDamage(30,120)
			else
				visible_message(SPAN_WARNING("69src69 rides the shockwave!"))
				dodge_time = get_game_time()
				confidence = FALSE

		if(3)
			if (not_slick)
				b_loss += 100
				if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
					adjustEarDamage(15,60)
			else
				visible_message(SPAN_WARNING("69src69 rides the shockwave!"))
				dodge_time = get_game_time()
				confidence = FALSE




	if (bomb_defense)
		b_loss =69ax(b_loss - bomb_defense, 0)

	var/organ_hit = BP_CHEST //Chest is hit first
	var/exp_damage = 0
	while (b_loss > 0)
		b_loss -= exp_damage
		exp_damage = rand(0, b_loss)
		src.apply_damage(exp_damage, BRUTE, organ_hit)
		organ_hit = pickweight(list(BP_HEAD = 0.2, BP_GROIN = 0.2, BP_R_ARM = 0.1, BP_L_ARM = 0.1, BP_R_LEG = 0.1, BP_L_LEG = 0.1))  //We determine some other body parts that should be hit

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as69ob)
	if(user.incapacitated()  || !user.Adjacent(src))
		return

	var/obj/item/clothing/under/suit
	if (istype(w_uniform, /obj/item/clothing/under))
		suit = w_uniform

	user.set_machine(src)
	var/dat = "<B><HR><FONT size=3>69name69</FONT></B><BR><HR>"

	for(var/entry in species.hud.gear)
		var/slot = species.hud.gear69entry69
		if(slot in list(slot_l_store, slot_r_store))
			continue
		var/obj/item/thing_in_slot = get_equipped_item(slot)
		dat += "<BR><B>69entry69:</b> <a href='?src=\ref69src69;item=69slot69'>69istype(thing_in_slot) ? thing_in_slot : "nothing"69</a>"

	dat += "<BR><HR>"

/*	if(species.hud.has_hands)
		dat += "<BR><b>Left hand:</b> <A href='?src=\ref69src69;item=69slot_l_hand69'>69istype(l_hand) ? l_hand : "nothing"69</A>"
		dat += "<BR><b>Right hand:</b> <A href='?src=\ref69src69;item=69slot_r_hand69'>69istype(r_hand) ? r_hand : "nothing"69</A>"*/

	// Do they get an option to set internals?
	if(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/space))
		if(istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank))
			dat += "<BR><A href='?src=\ref69src69;item=internals'>Toggle internals.</A>"

	// Other incidentals.
	if(handcuffed)
		dat += "<BR><A href='?src=\ref69src69;item=69slot_handcuffed69'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='?src=\ref69src69;item=69slot_legcuffed69'>Legcuffed</A>"

	if(suit && suit.accessories.len)
		dat += "<BR><A href='?src=\ref69src69;item=tie'>Remove accessory</A>"
	dat += "<BR><A href='?src=\ref69src69;item=splints'>Remove splints</A>"
	dat += "<BR><A href='?src=\ref69src69;item=pockets'>Empty pockets</A>"
	dat += "<BR><A href='?src=\ref69user69;refresh=1'>Refresh</A>"
	dat += "<BR><A href='?src=\ref69user69;mach_close=mob69name69'>Close</A>"

	user << browse(dat, text("window=mob69name69;size=340x540"))
	onclose(user, "mob69name69")
	return

// called when something steps onto a human
// this handles69ulebots and69ehicles
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	if(istype(AM, /obj/machinery/bot/mulebot))
		var/obj/machinery/bot/mulebot/MB = AM
		MB.RunOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id",69ar/if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.rank ? id.rank : if_no_job
	else
		return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id",69ar/if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.assignment ? id.assignment : if_no_job
	else
		return if_no_id

//gets69ame from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/card/id/id = GetIdCard()
	if(id)
		return id.registered_name || if_no_id
	else
		return if_no_id

//Trust69e I'm an engineer
//I think we'll put this shit right here
var/list/rank_prefix = list(\
	"Ironhammer Operative" = "Operative",\
	"Ironhammer Inspector" = "Inspector",\
	"Ironhammer69edical Specialist" = "Specialist",\
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
		name = get_id_rank() +69ame
	return69ame

//repurposed proc.69ow it combines get_id_name() and get_face_name() to determine a69ob's69ame69ariable.69ade into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if((wear_mask && (wear_mask.flags_inv&HIDEFACE)) || (head && (head.flags_inv&HIDEFACE)))	//Wearing a69ask which hides our face, use id-name if possible	//Likewise for hats
		return rank_prefix_name(get_id_name())

	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(id_name)
		if(id_name != face_name)
			return "69face_name69 (as 69rank_prefix_name(id_name)69)"
		else
			return rank_prefix_name(id_name)
	return face_name

//Returns "Unknown" if facially disfigured and real_name if69ot. Useful for setting69ame when polyacided or when updating a human's69ame69ariable
/mob/living/carbon/human/get_face_name()
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	if(!head || head.disfigured || head.is_stump() || !real_name || (HUSK in69utations) )	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets69ame from ID or PDA itself, ID inside PDA doesn't69atter
//Useful when player is being seen by other69obs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	var/obj/item/card/id/I = GetIdCard()
	if(istype(I))
		return I.registered_name

/mob/living/carbon/human/proc/get_id_rank()
	var/rank
	var/obj/item/card/id/id
	if (istype(wear_id, /obj/item/modular_computer/pda))
		id = wear_id.GetIdCard()
	if(!id)
		id = get_idcard()
	if(id)
		rank = id.rank
		if(rank_prefix69rank69)
			return rank_prefix69rank69
	return ""

//gets ID card object from special clothes slot or69ull.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetIdCard()

//Removed the horrible safety parameter. It was only being used by69inja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(shock_damage, obj/source, siemens_coeff = 1, def_zone)
	if(status_flags & GODMODE)	return 0	//godmode

	if (!def_zone)
		def_zone = pick(BP_L_ARM, BP_R_ARM)

	var/obj/item/organ/external/affected_organ = get_organ(check_zone(def_zone))
	siemens_coeff *= get_siemens_coefficient_organ(affected_organ)

	return ..(shock_damage, source, siemens_coeff, def_zone)


/mob/living/carbon/human/Topic(href, href_list)

	if (href_list69"refresh"69)
		if((machine)&&(in_range(src, usr)))
			show_inv(machine)

	if (href_list69"mach_close"69)
		var/t1 = text("window=6969", href_list69"mach_close"69)
		unset_machine()
		src << browse(null, t1)

	if(href_list69"item"69)
		handle_strip(href_list69"item"69,usr)

	if (href_list69"criminal"69)
		if(hasHUD(usr,"security"))

			var/modified = FALSE
			var/perpname = get_id_name(name)

			if(perpname)
				var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
				if(R)
					var/setcriminal = input(usr, "Specify a69ew criminal status for this person.", "Security HUD", R.get_criminalStatus()) in GLOB.security_statuses + "Cancel"
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
				to_chat(usr, "\red Unable to locate a data core entry for this person.")

	if (href_list69"secrecord"69)
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields69"name"69 == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields69"id"69 == E.fields69"id"69)
							if(hasHUD(usr,"security"))
								to_chat(usr, "<b>Name:</b> 69R.fields69"name"6969	<b>Criminal Status:</b> 69R.fields69"criminal"6969")
								to_chat(usr, "<b>Minor Crimes:</b> 69R.fields69"mi_crim"6969")
								to_chat(usr, "<b>Details:</b> 69R.fields69"mi_crim_d"6969")
								to_chat(usr, "<b>Major Crimes:</b> 69R.fields69"ma_crim"6969")
								to_chat(usr, "<b>Details:</b> 69R.fields69"ma_crim_d"6969")
								to_chat(usr, "<b>Notes:</b> 69R.fields69"notes"6969")
								to_chat(usr, "<a href='?src=\ref69src69;secrecordComment=`'>\69View Comment Log\69</a>")
								read = 1

			if(!read)
				to_chat(usr, "\red Unable to locate a data core entry for this person.")

	if (href_list69"secrecordComment"69)
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields69"name"69 == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields69"id"69 == E.fields69"id"69)
							if(hasHUD(usr,"security"))
								read = 1
								var/counter = 1
								while(R.fields69text("com_6969", counter)69)
									to_chat(usr, text("6969", R.fields69text("com_6969", counter)69))
									counter++
								if (counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='?src=\ref69src69;secrecordadd=`'>\69Add comment\69</a>")

			if(!read)
				to_chat(usr, "\red Unable to locate a data core entry for this person.")

	if (href_list69"secrecordadd"69)
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields69"name"69 == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields69"id"69 == E.fields69"id"69)
							if(hasHUD(usr,"security"))
								var/t1 = sanitize(input("Add Comment:", "Sec. records",69ull,69ull)  as69essage)
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"security")) )
									return
								var/counter = 1
								while(R.fields69text("com_6969", counter)69)
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields69text("com_69counter69")69 = text("Made by 69U.get_authentification_name()69 (69U.get_assignment()69) on 69time2text(world.realtime, "DDD69MM DD hh:mm:ss")69, 69game_year69<BR>69t169")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields69text("com_69counter69")69 = text("Made by 69U.name69 (69U.modtype69 69U.braintype69) on 69time2text(world.realtime, "DDD69MM DD hh:mm:ss")69, 69game_year69<BR>69t169")

	if (href_list69"medical"69)
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields69"name"69 == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields69"id"69 == E.fields69"id"69)

							var/setmedical = input(usr, "Specify a69ew69edical status for this person.", "Medical HUD", R.fields69"p_stat"69) in list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel")

							if(hasHUD(usr,"medical"))
								if(setmedical != "Cancel")
									R.fields69"p_stat"69 = setmedical
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
				to_chat(usr, "\red Unable to locate a data core entry for this person.")

	if (href_list69"medrecord"69)
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				var/obj/item/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields69"name"69 == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields69"id"69 == E.fields69"id"69)
							if(hasHUD(usr,"medical"))
								to_chat(usr, "<b>Name:</b> 69R.fields69"name"6969	<b>Blood Type:</b> 69R.fields69"b_type"6969")
								to_chat(usr, "<b>DNA:</b> 69R.fields69"b_dna"6969")
								to_chat(usr, "<b>Minor Disabilities:</b> 69R.fields69"mi_dis"6969")
								to_chat(usr, "<b>Details:</b> 69R.fields69"mi_dis_d"6969")
								to_chat(usr, "<b>Major Disabilities:</b> 69R.fields69"ma_dis"6969")
								to_chat(usr, "<b>Details:</b> 69R.fields69"ma_dis_d"6969")
								to_chat(usr, "<b>Notes:</b> 69R.fields69"notes"6969")
								to_chat(usr, "<a href='?src=\ref69src69;medrecordComment=`'>\69View Comment Log\69</a>")
								read = 1

			if(!read)
				to_chat(usr, "\red Unable to locate a data core entry for this person.")

	if (href_list69"medrecordComment"69)
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				var/obj/item/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields69"name"69 == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields69"id"69 == E.fields69"id"69)
							if(hasHUD(usr,"medical"))
								read = 1
								var/counter = 1
								while(R.fields69text("com_6969", counter)69)
									to_chat(usr, text("6969", R.fields69text("com_6969", counter)69))
									counter++
								if (counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='?src=\ref69src69;medrecordadd=`'>\69Add comment\69</a>")

			if(!read)
				to_chat(usr, "\red Unable to locate a data core entry for this person.")

	if (href_list69"medrecordadd"69)
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/id
				if (istype(wear_id, /obj/item/modular_computer/pda))
					id = wear_id.GetIdCard()
				if(!id)
					id = get_idcard()
					if(id)
						perpname = id.registered_name
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields69"name"69 == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields69"id"69 == E.fields69"id"69)
							if(hasHUD(usr,"medical"))
								var/t1 = sanitize(input("Add Comment:", "Med. records",69ull,69ull)  as69essage)
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"medical")) )
									return
								var/counter = 1
								while(R.fields69text("com_6969", counter)69)
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields69text("com_69counter69")69 = text("Made by 69U.get_authentification_name()69 (69U.get_assignment()69) on 69time2text(world.realtime, "DDD69MM DD hh:mm:ss")69, 69game_year69<BR>69t169")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields69text("com_69counter69")69 = text("Made by 69U.name69 (69U.modtype69 69U.braintype69) on 69time2text(world.realtime, "DDD69MM DD hh:mm:ss")69, 69game_year69<BR>69t169")

	if (href_list69"lookitem"69)
		var/obj/item/I = locate(href_list69"lookitem"69)
		src.examinate(I)

	if (href_list69"lookmob"69)
		var/mob/M = locate(href_list69"lookmob"69)
		src.examinate(M)

	..()
	return

///eyecheck()
///Returns a69umber between -1 to 2
/mob/living/carbon/human/eyecheck()
	if(!species.has_process69OP_EYES69) //No eyes, can't hurt them.
		return FLASH_PROTECTION_MAJOR

	var/eye_efficiency = get_organ_efficiency(OP_EYES)
	if(eye_efficiency <= 1)
		return FLASH_PROTECTION_MAJOR

	return flash_protection

//Used by69arious things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(var/target_zone,69ar/brain_tag = BP_BRAIN)
	if(!species.has_process69brain_tag69)
		return 0

	var/obj/item/organ/affecting = random_organ_by_process(brain_tag)

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is69ot guaranteed
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
		to_chat(src, SPAN_WARNING("You don't have the dexterity to use that!"))
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
		visible_message("\red \The 69src69 begins playing \his ribcage like a xylophone. It's quite spooky.","\blue You begin to play a spooky refrain on your ribcage.","\red You hear a spooky xylophone69elody.")
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

/mob/living/carbon/human/vomit()

	if(!check_has_mouth())
		return
	if(stat == DEAD)
		return
	if(!lastpuke)
		lastpuke = 1
		to_chat(src, SPAN_WARNING("You feel69auseous..."))
		spawn(150)	//15 seconds until second warning
			to_chat(src, SPAN_WARNING("You feel like you are about to throw up!"))
			spawn(100)	//and you have 1069ore for69ad dash to the bucket
				Stun(5)

				src.visible_message(SPAN_WARNING("69src69 throws up!"),SPAN_WARNING("You throw up!"))
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

				var/turf/location = loc
				if (istype(location, /turf/simulated))
					location.add_vomit_floor(src, 1)

				adjustNutrition(-40)
				adjustToxLoss(-3)
				regen_slickness(-1)
				dodge_time = get_game_time()
				confidence = FALSE
				spawn(350)	//wait 35 seconds before69ext69olley
					lastpuke = 0

/mob/living/carbon/human/proc/morph()
	set69ame = "Morph"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target =69ull
		return

	if(!(mMorph in69utations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation",facial_color) as color
	if(new_facial)
		facial_color =69ew_facial

	var/new_hair = input("Please select hair color.", "Character Generation",hair_color) as color
	if(new_hair)
		hair_color =69ew_hair

	var/new_eyes = input("Please select eye color.", "Character Generation",eyes_color) as color
	if(new_eyes)
		eyes_color =69ew_eyes
		update_eyes()

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", "6935-s_tone69")  as text

	if (!new_tone)
		new_tone = 35
	s_tone =69ax(min(round(text2num(new_tone)), 220), 1)
	s_tone =  -s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H =69ew x // create69ew hair datum based on type x
		hairs.Add(H.name) // add hair69ame to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as69ull|anything in hairs

	// if69ew style selected (not cancel)
	if (new_style)
		h_style =69ew_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H =69ew x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as69ull|anything in fhairs

	if(new_style)
		f_style =69ew_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			gender =69ALE
		else
			gender = FEMALE
	regenerate_icons()
	check_dna()

	visible_message("\blue \The 69src6969orphs and changes 69get_visible_gender() ==69ALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"69 appearance!", "\blue You change your appearance!", "\red Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!")

/mob/living/carbon/human/proc/remotesay()
	set69ame = "Project69ind"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target =69ull
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in world)
		creatures += h
	var/mob/target = input("Who do you want to project your69ind to ?") as69ull|anything in creatures
	if (isnull(target))
		return

	var/say = sanitize(input("What do you wish to say"))
	if(mRemotetalk in target.mutations)
		target.show_message("\blue You hear 69src.real_name69's69oice: 69say69")
	else
		target.show_message("\blue You hear a69oice that seems to echo around the room: 69say69")
	usr.show_message("\blue You project your69ind into 69target.real_name69: 69say69")
	log_say("69key_name(usr)69 sent a telepathic69essage to 69key_name(target)69: 69say69")
	for(var/mob/observer/ghost/G in world)
		G.show_message("<i>Telepathic69essage from <b>69src69</b> to <b>69target69</b>: 69say69</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set69ame = "Remote69iew"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target =69ull
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target =69ull
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target =69ull
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in world)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat!=CONSCIOUS) //Not on69ining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your69ind to ?") as69ob in creatures

	if (target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target =69ull
		reset_view(0)

/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return69EUTER
	return gender

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level +=69
	else
		germ_level +=69

/mob/living/carbon/human/revive()

	if(species && !(species.flags &69O_BLOOD))
		vessel.add_reagent("blood",species.blood_volume-vessel.total_volume)
		fixblood()

	// Fix up all organs.
	// This will ignore any prosthetics in the prefs currently.
	rebuild_organs()

	if(!client || !key) //Don't boot out anyone already in the69ob.
		for(var/obj/item/organ/internal/brain/H in world)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)


	for (var/ID in69irus2)
		var/datum/disease2/disease/V =69irus269ID69
		V.cure(src)

	losebreath = 0

	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/obj/item/organ/internal/lungs/L = random_organ_by_process(OP_LUNGS)
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/obj/item/organ/internal/lungs/L = random_organ_by_process(OP_LUNGS)

	if(L && !L.is_bruised())
		src.custom_pain("You feel a stabbing pain in your chest!", 1)
		L.bruise()

/*
/mob/living/carbon/human/verb/simulate()
	set69ame = "sim"
	set background = 1

	var/damage = input("Wound damage","Wound damage") as69um

	var/germs = 0
	var/tdamage = 0
	var/ticks = 0
	while (germs < 2501 && ticks < 100000 && round(damage/10)*20)
		log_misc("VIRUS TESTING: 69ticks69 : germs 69germs69 tdamage 69tdamage69 prob 69round(damage/10)*2069")
		ticks++
		if (prob(round(damage/10)*20))
			germs++
		if (germs == 100)
			to_chat(world, "Reached stage 1 in 69ticks69 ticks")
		if (germs > 100)
			if (prob(10))
				damage++
				germs++
		if (germs == 1000)
			to_chat(world, "Reached stage 2 in 69ticks69 ticks")
		if (germs > 1000)
			damage++
			germs++
		if (germs == 2500)
			to_chat(world, "Reached stage 3 in 69ticks69 ticks")
	to_chat(world, "Mob took 69tdamage69 tox damage")
*/
//returns 1 if69ade bloody, returns 0 otherwise

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as69ob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA69M.dna.unique_enzymes69)
			blood_DNA69M.dna.unique_enzymes69 =69.dna.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/proc/get_full_print()
	if(!dna ||!dna.uni_identity)
		return
	if(chem_effects69CE_DYNAMICFINGERS69)
		return69d5(chem_effects69CE_DYNAMICFINGERS69)
	return69d5(dna.uni_identity)

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

	gunshot_residue =69ull

	if(clean_feet)
		if(shoes)
			if(shoes.clean_blood())
				update_inv_shoes()
		else
			if(feet_blood_DNA && feet_blood_DNA.len)
				feet_blood_color =69ull
				feet_blood_DNA.Cut()
				update_inv_shoes()

	return

/mob/living/carbon/human/get_visible_implants()
	var/list/visible_implants = list()

	for(var/obj/item/organ/external/organ in organs)
		for(var/obj/item/I in (organ.implants & organ.embedded))
			visible_implants += I

	return69isible_implants

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in organs)
		for(var/obj/item/O in organ.implants)
			if(is_sharp(O))	// Only sharp items can cause issues
				return TRUE
	return FALSE

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/obj/item/organ/external/organ in organs)
		if(organ.status & ORGAN_SPLINTED) //Splints prevent69ovement.
			continue

		for(var/obj/item/O in organ.implants)
			var/mob/living/carbon/human/H = organ.owner
			// Shrapnel hurts when you69ove, and implanting knives is a bad idea
			if(prob(5) && is_sharp(O) && !MOVING_DELIBERATELY(H))
				if(!organ.can_feel_pain())
					to_chat(src, SPAN_WARNING("You feel 69O6969oving inside your 69organ.name69."))
				else
					var/msg = pick( \
						SPAN_WARNING("A spike of pain jolts your 69organ.name69 as you bump 69O69 inside."), \
						SPAN_WARNING("Your hasty69ovement jostles 69O69 in your 69organ.name69 painfully."))
					to_chat(src,69sg)
				organ.take_damage(rand(1,3), 0, 0)
				if(organ.setBleeding())
					src.adjustToxLoss(rand(1,3))

/mob/living/carbon/human/verb/browse_sanity()
	set69ame		= "Show sanity"
	set desc		= "Browse your character sanity."
	set category	= "IC"
	set src			= usr
	ui_interact(src)

/mob/living/carbon/human/ui_data()
	var/list/data = list()

	data69"style"69 = get_total_style()
	data69"min_style"69 =69IN_HUMAN_STYLE
	data69"max_style"69 =69AX_HUMAN_STYLE
	data69"sanity"69 = sanity.level
	data69"sanity_max_level"69 = sanity.max_level
	data69"insight"69 = sanity.insight
	data69"desires"69 = sanity.desires
	data69"rest"69 = sanity.resting
	data69"insight_rest"69 = sanity.insight_rest

	var/obj/item/implant/core_implant/cruciform/C = get_core_implant(/obj/item/implant/core_implant/cruciform)
	if(C)
		data69"cruciform"69 = TRUE
		data69"righteous_life"69 = C.righteous_life

	return data

/mob/living/carbon/human/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open = 1, state = GLOB.default_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, user, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, "sanity.tmpl",69ame, 650, 550, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set69ame = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in69iew(1)
	var/self = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message(SPAN_NOTICE("69usr69 kneels down, puts \his hand on 69src69's wrist and begins counting their pulse."),\
		"You begin counting 69src69's pulse")
	else
		usr.visible_message(SPAN_NOTICE("69usr69 begins counting their pulse."),\
		"You begin counting your pulse.")

	if(pulse())
		to_chat(usr, "<span class='notice'>69self ? "You have a" : "69src69 has a"69 pulse! Counting...</span>")
	else
		to_chat(usr, SPAN_DANGER("69src69 has69o pulse!")	) //it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	to_chat(usr, "You69ust69self ? "" : " both"69 remain still until counting is finished.")
	if(do_mob(usr, src, 60))
		to_chat(usr, "<span class='notice'>69self ? "Your" : "69src69's"69 pulse is 69src.get_pulse(GETPULSE_HAND)69.</span>")
	else
		to_chat(usr, SPAN_WARNING("You failed to check the pulse. Try again."))

/mob/living/carbon/human/proc/set_species(var/new_species,69ar/default_colour)
	if(!dna)
		if(!new_species)
			new_species = SPECIES_HUMAN
	else
		if(!new_species)
			new_species = dna.species
		else
			dna.species =69ew_species

	//69o69ore invisible screaming wheelchairs because of set_species() typos.
	if(!all_species69new_species69)
		new_species = SPECIES_HUMAN

	if(species)

		if(species.name && species.name ==69ew_species)
			return
		if(species.language)
			remove_language(species.language)
		if(species.default_language)
			remove_language(species.default_language)
		// Clear out their species abilities.
		species.remove_inherent_verbs(src)
		holder_type =69ull

	species = all_species69new_species69

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
			internal_organs_by_efficiency69process69 = list()

	rebuild_organs()
	src.sync_organ_dna()
	species.handle_post_spawn(src)

	maxHealth = species.total_health

	update_client_colour(0)

	spawn(0)
		regenerate_icons()
		if(vessel.total_volume < species.blood_volume)
			vessel.maximum_volume = species.blood_volume
			vessel.add_reagent("blood", species.blood_volume -69essel.total_volume)
		else if(vessel.total_volume > species.blood_volume)
			vessel.remove_reagent("blood",69essel.total_volume - species.blood_volume)
			vessel.maximum_volume = species.blood_volume
		fixblood()


	// Rebuild the HUD. If they aren't logged in then login() should reinstantiate it for them.
	check_HUD()
	/*
	if(client && client.screen)//HUD HERE!!!!!!!!!!
		client.screen.Cut()
		if(hud_used)
			qdel(hud_used)
		hud_used =69ew /datum/hud(src)
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
			var/datum/organ_description/OD = species.has_limbs69tag69
//			var/datum/body_modification/PBM = Pref.get_modification(OD.parent_organ_base)
//			if(PBM && (PBM.nature ==69ODIFICATION_SILICON || PBM.nature ==69ODIFICATION_REMOVED))
//				BM = PBM
			if(BM.is_allowed(tag, Pref, src))
				BM.create_organ(src, OD, Pref.modifications_colors69tag69)
			else
				OD.create_organ(src)

		for(var/tag in species.has_process)
			BM = Pref.get_modification(tag)
			if(BM.is_allowed(tag, Pref, src))
				BM.create_organ(src, species.has_process69tag69, Pref.modifications_colors69tag69)
			else
				var/organ_type = species.has_process69tag69
				new organ_type(src)

		var/datum/category_item/setup_option/core_implant/I = Pref.get_option("Core implant")
		if(I.implant_type && (!mind ||69ind.assigned_role != "Robot"))
			var/obj/item/implant/core_implant/C =69ew I.implant_type
			C.install(src)
			C.activate()
			if(mind)
				C.install_default_modules_by_job(mind.assigned_job)
				C.access.Add(mind.assigned_job.cruciform_access)
				C.security_clearance =69ind.assigned_job.security_clearance

	else
		var/organ_type

		for(var/limb_tag in species.has_limbs)
			var/datum/organ_description/OD = species.has_limbs69limb_tag69
			var/obj/item/I = organs_by_name69limb_tag69
			if(I && I.type == OD.default_type)
				continue
			else if(I)
				qdel(I)
			OD.create_organ(src)

		for(var/organ_tag in species.has_process)
			organ_type = species.has_process69organ_tag69
			var/obj/item/I = random_organ_by_process(organ_tag)
			if(I && I.type == organ_type)
				continue
			else if(I)
				qdel(I)
			new organ_type(src)

		if(checkprefcruciform)
			var/datum/category_item/setup_option/core_implant/I = client.prefs.get_option("Core implant")
			if(I.implant_type)
				var/obj/item/implant/core_implant/C =69ew I.implant_type
				C.install(src)
				C.activate()
				C.install_default_modules_by_job(mind.assigned_job)
				C.access.Add(mind.assigned_job.cruciform_access)
				C.security_clearance =69ind.assigned_job.security_clearance

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
		C.access |=69ind.assigned_job.cruciform_access
		C.security_clearance =69ind.assigned_job.security_clearance

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set69ame = "Write in blood"
	set desc = "Use blood on your hands to write a short69essage on the floor or a wall,69urder69ystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		to_chat(src, SPAN_WARNING("Your 69src.gloves69 are getting in the way."))
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of69echs and lockers
		to_chat(src, SPAN_WARNING("You cannot reach the floor."))
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		to_chat(src, SPAN_WARNING("You cannot doodle there."))
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, SPAN_WARNING("There is69o space to write on!"))
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(input("Write a69essage. It cannot be longer than 69max_length69 characters.","Blood writing", ""))

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands =69ax(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) >69ax_length)
			message += "-"
			to_chat(src, SPAN_WARNING("You ran out of blood to write with!"))

		var/obj/effect/decal/cleanable/blood/writing/W =69ew(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message =69essage
		W.add_fingerprint(src)

/mob/living/carbon/human/can_inject(var/mob/user,69ar/error_msg,69ar/target_zone)
	. = 1
	if(!target_zone)
		if(user)
			target_zone = user.targeted_organ
		else
			// Pick an existing69on-robotic limb, if possible.
			for(target_zone in BP_ALL_LIMBS)
				var/obj/item/organ/external/affecting = get_organ(target_zone)
				if(affecting && BP_IS_ORGANIC(affecting) || BP_IS_ASSISTED(affecting))
					break


	var/obj/item/organ/external/affecting = get_organ(target_zone)
	var/fail_msg
	if(!affecting)
		. = 0
		fail_msg = "They are69issing that limb."
	else if (BP_IS_ROBOTIC(affecting))
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
			fail_msg = "There is69o exposed flesh or thin69aterial 69target_zone == BP_HEAD ? "on their head" : "on their body"69 to inject into."
		to_chat(user, SPAN_WARNING(fail_msg))

/mob/living/carbon/human/print_flavor_text(var/shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & FACE)
			// Do69ot show flavor if face is hidden
			return

	if(client)
		flavor_text = client.prefs.flavor_text

	if (flavor_text && flavor_text != "" && !shrink)
		var/msg = trim(replacetext(flavor_text, "\n", " "))
		if(!msg) return ""
		if(length(msg) <= 40)
			return "<font color='blue'>69msg69</font>"
		else
			return "<font color='blue'>69copytext_preserve_html(msg, 1, 37)69... <a href='byond://?src=\ref69src69;flavor_more=1'>More...</a></font>"
	return ..()

/mob/living/carbon/human/getDNA()
	if(species.flags &69O_SCAN)
		return69ull
	..()

/mob/living/carbon/human/setDNA()
	if(species.flags &69O_SCAN)
		return
	..()

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

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	if((species.flags &69O_SLIP) || (shoes && (shoes.item_flags &69OSLIP)))
		return 0
	..(slipped_on,stun_duration)
	regen_slickness(-1)
	dodge_time = get_game_time()
	confidence = FALSE

/mob/living/carbon/human/trip(tripped_on, stun_duration)
	if(buckled)
		return FALSE
	if(lying)
		return FALSE //69o tripping while crawling
	stop_pulling()
	if (tripped_on)
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		to_chat(src, SPAN_WARNING("You tripped over!"))
	Weaken(stun_duration)
	return TRUE

/mob/living/carbon/human/proc/undislocate()
	set category = "Object"
	set69ame = "Undislocate Joint"
	set desc = "Pop a joint back into place. Extremely painful."
	set src in69iew(1)

	if(!isliving(usr) || !usr.can_click())
		return

	usr.setClickCooldown(20)

	if(usr.stat > 0)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/self
	if(S == U)
		self = 1 // Removing object from yourself.

	var/list/limbs = list()
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/current_limb = organs_by_name69limb69
		if(current_limb && current_limb.dislocated == 2)
			limbs |= limb
	var/choice = input(usr,"Which joint do you wish to relocate?") as69ull|anything in limbs

	if(!choice)
		return

	var/obj/item/organ/external/current_limb = organs_by_name69choice69

	if(self)
		to_chat(src, SPAN_WARNING("You brace yourself to relocate your 69current_limb.joint69..."))
	else
		to_chat(U, SPAN_WARNING("You begin to relocate 69S69's 69current_limb.joint69..."))

	if(!do_after(U, 30, src))
		return
	if(!choice || !current_limb || !S || !U)
		return

	if(self)
		to_chat(src, SPAN_DANGER("You pop your 69current_limb.joint69 back in!"))
	else
		to_chat(U, SPAN_DANGER("You pop 69S69's 69current_limb.joint69 back in!"))
		to_chat(S, SPAN_DANGER("69U69 pops your 69current_limb.joint69 back in!"))
	current_limb.undislocate()

/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()


/mob/living/carbon/human/can_stand_overridden()
	if(wearing_rig && wearing_rig.ai_can_move_suit(check_for_ai = 1))
		// Actually69issing a leg will screw you up. Everything else can be compensated for.
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
	set69ame = "Pull Punches"
	set desc = "Try69ot to hurt them."
	set category = "IC"

	if(stat) return
	pulling_punches = !pulling_punches
	to_chat(src, "<span class='notice'>You are69ow 69pulling_punches ? "pulling your punches" : "not pulling your punches"69.</span>")
	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/human/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for69achines,69ore accurate
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
			return69ethod ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
	return "69method ? temp : temp + rand(-10, 10)69"
//			output for69achines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/human/proc/pulse()
	if(!(organ_list_by_process(OP_HEART).len))
		return PULSE_NONE
	else
		return pulse

/mob/living/carbon/human/verb/lookup()
	set69ame = "Look up"
	set desc = "If you want to know what's above."
	set category = "IC"

	if(!is_physically_disabled())
		var/turf/above = GetAbove(src)
		if(shadow)
			if(client.eye == shadow)
				reset_view(0)
				return
			if(above.is_hole)
				to_chat(src, SPAN_NOTICE("You look up."))
				if(client)
					reset_view(shadow)
				return
		to_chat(src, SPAN_NOTICE("You can see 69above69."))
	else
		to_chat(src, SPAN_NOTICE("You can't do it right69ow."))
	return

/mob/living/carbon/human/should_have_process(var/organ_check)

	var/obj/item/organ/external/affecting
	if(organ_check in list(OP_HEART, OP_LUNGS, OP_STOMACH))
		affecting = organs_by_name69BP_CHEST69
	else if(organ_check in list(OP_LIVER, OP_KIDNEYS, OP_KIDNEY_LEFT, OP_KIDNEY_RIGHT))
		affecting = organs_by_name69BP_GROIN69

	if(affecting && (BP_IS_ROBOTIC(affecting)))
		return FALSE
	return (species && species.has_process69organ_check69)

/mob/living/carbon/human/proc/check_self_for_injuries()
	if(stat)
		return

	to_chat(src, SPAN_NOTICE("You check yourself for injuries."))

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
		if(org.dislocated == 2)
			status += "dislocated"
		if(org.status & ORGAN_BROKEN)
			status += "hurts when touched"
		if(org.status & ORGAN_DEAD)
			status += "is bruised and69ecrotic"
		if(!org.is_usable())
			status += "dangling uselessly"

		var/status_text = SPAN_NOTICE("OK")
		if(status.len)
			status_text = SPAN_WARNING(english_list(status))

		src.show_message("My 69org.name69 is 69status_text69.",1)

/mob/living/carbon/human/need_breathe()
	if(!(mNobreath in69utations))
		return TRUE
	else
		return FALSE

/mob/living/carbon/human/proc/set_remoteview(var/atom/A)
	remoteview_target = A
	reset_view(A)

/mob/living/carbon/human/proc/resuscitate()
	var/obj/item/organ/internal/heart_organ = random_organ_by_process(OP_HEART)
	var/obj/item/organ/internal/brain_organ = random_organ_by_process(BP_BRAIN)

	if(!is_asystole() && !(heart_organ && brain_organ) || (heart_organ.is_broken() || brain_organ.is_broken()))
		return 0

	if(world.time >= (timeofdeath +69ECROZTIME))
		return 0

	var/oxyLoss = getOxyLoss()
	if(oxyLoss > 20)
		setOxyLoss(20)

	if(health <= (HEALTH_THRESHOLD_DEAD - oxyLoss))
		visible_message(SPAN_WARNING("\The 69src69 twitches a bit, but their body is too damaged to sustain life!"))
		timeofdeath = 0
		return 0

	visible_message(SPAN_NOTICE("\The 69src69 twitches a bit as their heart restarts!"))
	pulse = PULSE_NORM
	handle_pulse()
	timeofdeath = 0
	stat = UNCONSCIOUS
	jitteriness += 3 SECONDS
	updatehealth()
	switch_from_dead_to_living_mob_list()
	if(mind)
		for(var/mob/observer/ghost/G in GLOB.player_list)
			if(G.can_reenter_corpse && G.mind ==69ind)
				if(alert("Do you want to enter your body?","Resuscitate","OH YES","No, I'm autist") == "OH YES")
					G.reenter_corpse()
					break
				else
					break
	return 1
