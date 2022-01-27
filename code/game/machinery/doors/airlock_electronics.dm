/obj/item/electronics/airlock
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEM_SIZE_SMALL //It should be tiny! -A69ouri

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 3)

	re69_access = list(access_en69ine)

	var/secure = FALSE //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = list()
	var/one_access = FALSE //if set to 1, door would receive re69_one_access instead of re69_access
	var/last_confi69urator = null
	var/locked = TRUE
	var/lockable = TRUE

/obj/item/electronics/airlock/attack_self(mob/user)
	if (!ishuman(user) && !istype(user,/mob/livin69/silicon/robot))
		return ..(user)

	ui_interact(user)


/obj/item/electronics/airlock/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = 69LOB.hands_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics.tmpl", src.name, 1000, 500, null, null, state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/electronics/airlock/ui_data()
	var/list/data = list()
	var/list/re69ions = list()

	for(var/i in ACCESS_RE69ION_MIN to ACCESS_RE69ION_MAX) //code/69ame/jobs/_access_defs.dm
		var/list/re69ion = list()
		var/list/accesses = list()
		for(var/j in 69et_re69ion_accesses(i))
			var/list/access = list()
			access69"name"69 = 69et_access_desc(j)
			access69"id"69 = j
			access69"re69"69 = (j in src.conf_access)
			accesses69++accesses.len69 = access
		re69ion69"name"69 = 69et_re69ion_accesses_name(i)
		re69ion69"accesses"69 = accesses
		re69ions69++re69ions.len69 = re69ion
	data69"re69ions"69 = re69ions
	data69"oneAccess"69 = one_access
	data69"locked"69 = locked
	data69"lockable"69 = lockable
	//data69"autoset"69 = autoset

	return data

/obj/item/electronics/airlock/OnTopic(mob/user, list/href_list, state)
	if(lockable)
		if(href_list69"unlock"69)
			if(!re69_access || istype(user, /mob/livin69/silicon))
				locked = FALSE
				last_confi69urator = user.name
			else
				var/obj/item/card/id/I = user.69et_active_hand()
				I = I ? I.69etIdCard() : null
				if(!istype(I, /obj/item/card/id))
					to_chat(user, SPAN_WARNIN69("69\src69 flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?"))
					return TOPIC_HANDLED
				if (check_access(I))
					locked = FALSE
					last_confi69urator = I.re69istered_name
				else
					to_chat(user, SPAN_WARNIN69("69\src69 flashes a red LED near the ID scanner, indicatin69 your access has been denied."))
					return TOPIC_HANDLED
			return TOPIC_REFRESH
		else if(href_list69"lock"69)
			locked = TRUE
			return TOPIC_REFRESH

	if(href_list69"clear"69)
		conf_access = list()
		one_access = FALSE
		return TOPIC_REFRESH
	if(href_list69"one_access"69)
		one_access = !one_access
		return TOPIC_REFRESH
	/* Baystation's "autoset" feature: draws access levels from area
	if(href_list69"autoset"69)
		autoset = !autoset
		return TOPIC_REFRESH
	*/
	if(href_list69"access"69)
		to6969le_access(text2num(href_list69"access"69))
		return TOPIC_REFRESH


/obj/item/electronics/airlock/proc/to6969le_access(var/acc)
	if (acc == "all")
		conf_access = null
	else
		var/re69 = text2num(acc)

		if (conf_access == null)
			conf_access = list()

		if (!(re69 in conf_access))
			conf_access += re69
		else
			conf_access -= re69
			if (!conf_access.len)
				conf_access = null




/obj/item/electronics/airlock/secure
	name = "secure airlock electronics"
	desc = "desi69ned to be somewhat69ore resistant to hackin69 than standard electronics."
	ori69in_tech = list(TECH_DATA = 2)
	secure = 1
