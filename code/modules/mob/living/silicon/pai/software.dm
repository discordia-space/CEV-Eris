var/list/pai_emotions = list(
		"Happy" = 1,
		"Cat" = 2,
		"Extremely Happy" = 3,
		"Face" = 4,
		"Laugh" = 5,
		"Off" = 6,
		"Sad" = 7,
		"Angry" = 8,
		"What" = 9,
		"Neutral" = 10,
		"Silly" = 11,
		"Nose" = 12,
		"Smirk" = 13,
		"Exclamation Points" = 14,
		"Question69ark" = 15
	)


var/global/list/pai_software_by_key = list()
var/global/list/default_pai_software = list()
/hook/startup/proc/populate_pai_software_list()
	var/r = 1 // I would use ., but it'd sacrifice runtime detection
	for(var/type in typesof(/datum/pai_software) - /datum/pai_software)
		var/datum/pai_software/P =69ew type()
		if(pai_software_by_key69P.id69)
			var/datum/pai_software/O = pai_software_by_key69P.id69
			to_chat(world, SPAN_WARNING("pAI software69odule 69P.name69 has the same key as 69O.name69!"))
			r = 0
			continue
		pai_software_by_key69P.id69 = P
		if(P.default)
			default_pai_software69P.id69 = P
	return r

/mob/living/silicon/pai/New()
	..()
	software = default_pai_software.Copy()

/mob/living/silicon/pai/verb/paiInterface()
	set category = "pAI Commands"
	set69ame = "Software Interface"

	ui_interact(src)

/mob/living/silicon/pai/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS)
	if(user != src)
		if(ui) ui.set_status(STATUS_CLOSE, 0)
		return

	if(ui_key != "main")
		var/datum/pai_software/S = software69ui_key69
		if(S && !S.toggle)
			S.on_ui_interact(src, ui, force_open)
		else
			if(ui) ui.set_status(STATUS_CLOSE, 0)
		return

	var/data69069

	// Software we have bought
	var/bought_software69069
	// Software we have69ot bought
	var/not_bought_software69069

	for(var/key in pai_software_by_key)
		var/datum/pai_software/S = pai_software_by_key69key69
		var/software_data69069
		software_data69"name"69 = S.name
		software_data69"id"69 = S.id
		if(key in software)
			software_data69"on"69 = S.is_active(src)
			bought_software69++bought_software.len69 = software_data
		else
			software_data69"ram"69 = S.ram_cost
			not_bought_software69++not_bought_software.len69 = software_data

	data69"bought"69 = bought_software
	data69"not_bought"69 =69ot_bought_software
	data69"available_ram"69 = ram

	// Emotions
	var/emotions69069
	for(var/name in pai_emotions)
		var/emote69069
		emote69"name"69 =69ame
		emote69"id"69 = pai_emotions69name69
		emotions69++emotions.len69 = emote

	data69"emotions"69 = emotions
	data69"current_emotion"69 = card.current_emotion

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "pai_interface.tmpl", "pAI Software Interface", 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/mob/living/silicon/pai/Topic(href, href_list)
	. = ..()
	if(.) return

	if(href_list69"software"69)
		var/soft = href_list69"software"69
		var/datum/pai_software/S = software69soft69
		if(S.toggle)
			S.toggle(src)
		else
			ui_interact(src, ui_key = soft)
		return 1

	else if(href_list69"stopic"69)
		var/soft = href_list69"stopic"69
		var/datum/pai_software/S = software69soft69
		if(S)
			return S.Topic(href, href_list)

	else if(href_list69"purchase"69)
		var/soft = href_list69"purchase"69
		var/datum/pai_software/S = pai_software_by_key69soft69
		if(S && (ram >= S.ram_cost))
			ram -= S.ram_cost
			software69S.id69 = S
		return 1

	else if(href_list69"image"69)
		var/img = text2num(href_list69"image"69)
		if(1 <= img && img <= 9)
			card.setEmotion(img)
		return 1
