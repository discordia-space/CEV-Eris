/datum/pai_software
	//69ame for the software. This is used as the button text when buying or opening/toggling the software
	var/name = "pAI software69odule"
	// RAM cost; pAIs start with 100 RAM, spending it on programs
	var/ram_cost = 0
	// ID for the software. This69ust be unique
	var/id = ""
	// Whether this software is a toggle or69ot
	// Toggled software should override toggle() and is_active()
	//69on-toggled software should override on_ui_interact() and Topic()
	var/toggle = 1
	// Whether pAIs should automatically receive this69odule at69o cost
	var/default = 0

	proc/on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		return

	proc/toggle(mob/living/silicon/pai/user)
		return

	proc/is_active(mob/living/silicon/pai/user)
		return 0

/datum/pai_software/directives
	name = "Directives"
	ram_cost = 0
	id = "directives"
	toggle = 0
	default = 1

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data69069

		data69"master"69 = user.master
		data69"dna"69 = user.master_dna
		data69"prime"69 = user.pai_law0
		data69"supplemental"69 = user.pai_laws

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're69aking a pAI software69odule!
			ui =69ew(user, user, id, "pai_directives.tmpl", "pAI Directives", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		if(href_list69"getdna"69)
			var/mob/living/M = P.loc
			var/count = 0

			// Find the carrier
			while(!isliving(M))
				if(!M || !M.loc || count > 6)
					//For a runtime where69 ends up in69ullspace (similar to bluespace but less colourful)
					to_chat(src, "You are69ot being carried by anyone!")
					return 0
				M =69.loc
				count++

			// Check the carrier
			var/answer = input(M, "69P69 is requesting a DNA sample from you. Will you allow it to confirm your identity?", "69P69 Check DNA", "No") in list("Yes", "No")
			if(answer == "Yes")
				var/turf/T = get_turf_or_move(P.loc)
				for (var/mob/v in69iewers(T))
					v.show_message(SPAN_NOTICE("69M69 presses \his thumb against 69P69."), 3, SPAN_NOTICE("69P6969akes a sharp clicking sound as it extracts DNA69aterial from 69M69."), 2)
				var/datum/dna/dna =69.dna
				to_chat(P, "<font color = red><h3>69M69's UE string : 69dna.unique_enzymes69</h3></font>")
				if(dna.unique_enzymes == P.master_dna)
					to_chat(P, "<b>DNA is a69atch to stored69aster DNA.</b>")
				else
					to_chat(P, "<b>DNA does69ot69atch stored69aster DNA.</b>")
			else
				to_chat(P, "69M69 does69ot seem like \he is going to provide a DNA sample willingly.")
			return 1

/datum/pai_software/radio_config
	name = "Radio Configuration"
	ram_cost = 0
	id = "radio"
	toggle = 0
	default = 1

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui =69ull, force_open = 1)
		var/data69069

		data69"listening"69 = user.radio.broadcasting
		data69"frequency"69 = format_frequency(user.radio.frequency)

		var/channels69069
		for(var/ch_name in user.radio.channels)
			var/ch_stat = user.radio.channels69ch_name69
			var/ch_dat69069
			ch_dat69"name"69 = ch_name
			// FREQ_LISTENING is const in /obj/item/device/radio
			ch_dat69"listening"69 = !!(ch_stat & user.radio.FREQ_LISTENING)
			channels69++channels.len69 = ch_dat

		data69"channels"69 = channels

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			ui =69ew(user, user, id, "pai_radio.tmpl", "Radio Configuration", 300, 150)
			ui.set_initial_data(data)
			ui.open()

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		P.radio.Topic(href, href_list)
		return 1

/datum/pai_software/crew_manifest
	name = "Crew69anifest"
	ram_cost = 5
	id = "manifest"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		data_core.get_manifest_json()

		var/data69069
		// This is dumb, but69anoUI breaks if it has69o data to send
		data69"manifest"69 = list("__json_cache" =69anifestJSON)

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're69aking a pAI software69odule!
			ui =69ew(user, user, id, "pai_manifest.tmpl", "Crew69anifest", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/datum/pai_software/med_records
	name = "Medical Records"
	ram_cost = 15
	id = "med_records"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data69069

		var/records69069
		for(var/datum/data/record/general in sortRecord(data_core.general))
			var/record69069
			record69"name"69 = general.fields69"name"69
			record69"ref"69 = "\ref69general69"
			records69++records.len69 = record

		data69"records"69 = records

		var/datum/data/record/G = user.medicalActive1
		var/datum/data/record/M = user.medicalActive2
		data69"general"69 = G ? G.fields :69ull
		data69"medical"69 =69 ?69.fields :69ull
		data69"could_not_find"69 = user.medical_cannotfind

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're69aking a pAI software69odule!
			ui =69ew(user, user, id, "pai_medrecords.tmpl", "Medical Records", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		if(href_list69"select"69)
			var/datum/data/record/record = locate(href_list69"select"69)
			if(record)
				var/datum/data/record/R = record
				var/datum/data/record/M =69ull
				if (!( data_core.general.Find(R) ))
					P.medical_cannotfind = 1
				else
					P.medical_cannotfind = 0
					for(var/datum/data/record/E in data_core.medical)
						if ((E.fields69"name"69 == R.fields69"name"69 || E.fields69"id"69 == R.fields69"id"69))
							M = E
					P.medicalActive1 = R
					P.medicalActive2 =69
			else
				P.medical_cannotfind = 1
			return 1

/datum/pai_software/sec_records
	name = "Security Records"
	ram_cost = 15
	id = "sec_records"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data69069

		var/records69069
		for(var/datum/data/record/general in sortRecord(data_core.general))
			var/record69069
			record69"name"69 = general.fields69"name"69
			record69"ref"69 = "\ref69general69"
			records69++records.len69 = record

		data69"records"69 = records

		var/datum/data/record/G = user.securityActive1
		var/datum/data/record/S = user.securityActive2
		data69"general"69 = G ? G.fields :69ull
		data69"security"69 = S ? S.fields :69ull
		data69"could_not_find"69 = user.security_cannotfind

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're69aking a pAI software69odule!
			ui =69ew(user, user, id, "pai_secrecords.tmpl", "Security Records", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		if(href_list69"select"69)
			var/datum/data/record/record = locate(href_list69"select"69)
			if(record)
				var/datum/data/record/R = record
				var/datum/data/record/S =69ull
				if (!( data_core.general.Find(R) ))
					P.securityActive1 =69ull
					P.securityActive2 =69ull
					P.security_cannotfind = 1
				else
					P.security_cannotfind = 0
					for(var/datum/data/record/E in data_core.security)
						if ((E.fields69"name"69 == R.fields69"name"69 || E.fields69"id"69 == R.fields69"id"69))
							S = E
					P.securityActive1 = R
					P.securityActive2 = S
			else
				P.securityActive1 =69ull
				P.securityActive2 =69ull
				P.security_cannotfind = 1
			return 1

/datum/pai_software/door_jack
	name = "Door Jack"
	ram_cost = 30
	id = "door_jack"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data69069

		data69"cable"69 = user.cable !=69ull
		data69"machine"69 = user.cable && (user.cable.machine !=69ull)
		data69"inprogress"69 = user.hackdoor !=69ull
		data69"progress_a"69 = round(user.hackprogress / 10)
		data69"progress_b"69 = user.hackprogress % 10
		data69"aborted"69 = user.hack_aborted

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're69aking a pAI software69odule!
			ui =69ew(user, user, id, "pai_doorjack.tmpl", "Door Jack", 300, 150)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		if(href_list69"jack"69)
			if(P.cable && P.cable.machine)
				P.hackdoor = P.cable.machine
				P.hackloop()
			return 1
		else if(href_list69"cancel"69)
			P.hackdoor =69ull
			return 1
		else if(href_list69"cable"69)
			var/turf/T = get_turf_or_move(P.loc)
			P.hack_aborted = 0
			P.cable =69ew /obj/item/pai_cable(T)
			for(var/mob/M in69iewers(T))
				M.show_message(SPAN_WARNING("A port on 69P69 opens to reveal 69P.cable69, which promptly falls to the floor."), 3,
				               SPAN_WARNING("You hear the soft click of something light and hard falling to the ground."), 2)
			return 1

/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = get_turf_or_move(src.loc)
	for(var/mob/living/silicon/ai/AI in GLOB.player_list)
		if(T.loc)
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress in 69T.loc69.</b></font>")
		else
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>")
	var/obj/machinery/door/D = cable.machine
	if(!istype(D))
		hack_aborted = 1
		hackprogress = 0
		cable.machine =69ull
		hackdoor =69ull
		return
	while(hackprogress < 1000)
		if(cable && cable.machine == D && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
			hackprogress =69in(hackprogress+rand(1, 20), 1000)
		else
			hack_aborted = 1
			hackprogress = 0
			hackdoor =69ull
			return
		if(hackprogress >= 1000)
			hackprogress = 0
			D.open()
			cable.machine =69ull
			return
		sleep(10)			// Update every second

/datum/pai_software/atmosphere_sensor
	name = "Atmosphere Sensor"
	ram_cost = 5
	id = "atmos_sense"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data69069

		var/turf/T = get_turf_or_move(user.loc)
		if(!T)
			data69"reading"69 = 0
			data69"pressure"69 = 0
			data69"temperature"69 = 0
			data69"temperatureC"69 = 0
			data69"gas"69 = list()
		else
			var/datum/gas_mixture/env = T.return_air()
			data69"reading"69 = 1
			var/pres = env.return_pressure() * 10
			data69"pressure"69 = "69round(pres/10)69.69pres%1069"
			data69"temperature"69 = round(env.temperature)
			data69"temperatureC"69 = round(env.temperature-T0C)

			var/t_moles = env.total_moles
			var/gases69069
			for(var/g in env.gas)
				var/gas69069
				gas69"name"69 = gas_data.name69g69
				gas69"percent"69 = round((env.gas69g69 / t_moles) * 100)
				gases69++gases.len69 = gas
			data69"gas"69 = gases

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're69aking a pAI software69odule!
			ui =69ew(user, user, id, "pai_atmosphere.tmpl", "Atmosphere Sensor", 350, 300)
			ui.set_initial_data(data)
			ui.open()

/datum/pai_software/sec_hud
	name = "Security HUD"
	ram_cost = 20
	id = "sec_hud"

	toggle(mob/living/silicon/pai/user)
		user.secHUD = !user.secHUD

	is_active(mob/living/silicon/pai/user)
		return user.secHUD

/datum/pai_software/med_hud
	name = "Medical HUD"
	ram_cost = 20
	id = "med_hud"

	toggle(mob/living/silicon/pai/user)
		user.medHUD = !user.medHUD

	is_active(mob/living/silicon/pai/user)
		return user.medHUD

// TODO: remove redundant69odule
/datum/pai_software/translator
	name = "Universal Translator"
	ram_cost = 35
	id = "translator"

	toggle(mob/living/silicon/pai/user)
		user.translator_on = !user.translator_on

	is_active(mob/living/silicon/pai/user)
		return user.translator_on

/datum/pai_software/signaller
	name = "Remote Signaller"
	ram_cost = 5
	id = "signaller"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data69069

		data69"frequency"69 = format_frequency(user.sradio.frequency)
		data69"code"69 = user.sradio.code

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're69aking a pAI software69odule!
			ui =69ew(user, user, id, "pai_signaller.tmpl", "Signaller", 320, 150)
			ui.set_initial_data(data)
			ui.open()

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		if(href_list69"send"69)
			P.sradio.send_signal("ACTIVATE")
			for(var/mob/O in hearers(1, P.loc))
				O.show_message("\icon69P69 *beep* *beep*", 3, "*beep* *beep*", 2)
			return 1

		else if(href_list69"freq"69)
			var/new_frequency = (P.sradio.frequency + text2num(href_list69"freq"69))
			if(new_frequency < PUBLIC_LOW_FREQ ||69ew_frequency > PUBLIC_HIGH_FREQ)
				new_frequency = sanitize_frequency(new_frequency)
			P.sradio.set_frequency(new_frequency)
			return 1

		else if(href_list69"code"69)
			P.sradio.code += text2num(href_list69"code"69)
			P.sradio.code = round(P.sradio.code)
			P.sradio.code =69in(100, P.sradio.code)
			P.sradio.code =69ax(1, P.sradio.code)
			return 1
