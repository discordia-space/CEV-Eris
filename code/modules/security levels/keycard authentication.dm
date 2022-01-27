/obj/machinery/keycard_auth
	name = "Keycard Authentication Device"
	desc = "This device is used to trigger ship functions, which re69uire69ore than one ID card to authenticate."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	use_power =69O_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	interact_offline = TRUE
	re69_access = list(access_keycard_auth)
	var/static/const/countdown = 369INUTES
	var/static/const/cooldown = 1069INUTES
	var/static/list/ongoing_countdowns = list()
	var/static/list/initiator_card = list()
	var/static/next_countdown
	var/static/list/event_names = list(
		redalert = "red alert",
		pods = "spacecraft abandonment"
	)
	var/static/datum/announcement/priority/kcad_announcement =69ew(do_log = 1,69ew_sound = sound('sound/misc/notice1.ogg'), do_newscast = 1)

/obj/machinery/keycard_auth/attack_ai(mob/user as69ob)
	return

/obj/machinery/keycard_auth/inoperable(var/additional_flags = 0)
	return (stat & (BROKEN|additional_flags))

/obj/machinery/keycard_auth/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/keycard_auth/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/data69069
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)

	data69"seclevel"69 = security_state.current_security_level.name
	data69"emergencymaint"69 =69aint_all_access
	data69"events"69 = ongoing_countdowns
	data69"oncooldown"69 =69ext_countdown > world.time
	data69"maint_all_access"69 =69aint_all_access

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, "keycard authentication.tmpl", "Keycard Authentication Device", 440, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/keycard_auth/Topic(href, href_list)
	if(..())
		return TRUE

	if(!allowed(usr))
		return TRUE

	if(href_list69"start"69)
		if(next_countdown > world.time)
			return TRUE
		var/event = href_list69"start"69
		if(ongoing_countdowns69event69)
			return
		kcad_announcement.Announce("69usr69 has initiated 69event_names69event6969 countdown.")
		ongoing_countdowns69event69 = addtimer(CALLBACK(src, .proc/countdown_finished, event), countdown, TIMER_UNI69UE | TIMER_STOPPABLE)
		next_countdown = world.time + cooldown
		var/obj/item/card/id/id = usr.GetIdCard()
		initiator_card69event69 = id
	if(href_list69"cancel"69)
		var/event = href_list69"cancel"69
		if(!ongoing_countdowns69event69)
			return
		kcad_announcement.Announce("69usr69 has cancelled 69event_names69event6969 countdown.")
		deltimer(ongoing_countdowns69event69)
		ongoing_countdowns -= event
		initiator_card -= event
	if(href_list69"proceed"69)
		var/event = href_list69"proceed"69
		if(!ongoing_countdowns69event69)
			return
		var/obj/item/card/id/id = usr.GetIdCard()
		if(initiator_card69event69 == id)
			return
		kcad_announcement.Announce("69usr69 has proceeded 69event_names69event6969 countdown.")
		countdown_finished(event)
	if(href_list69"emergencymaint"69)
		var/event = href_list69"emergencymaint"69
		switch(event)
			if("grant")
				make_maint_all_access()
			if("revoke")
				revoke_maint_all_access()
	playsound(usr.loc, 'sound/machines/button.ogg', 100, 1)
	return

/obj/machinery/keycard_auth/proc/countdown_finished(event)
	switch(event)
		if("redalert")
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
			security_state.set_security_level(security_state.high_security_level)
		if("pods")
			evacuation_controller.call_evacuation(null, TRUE)
	if(event)
		deltimer(ongoing_countdowns69event69)
		ongoing_countdowns -= event
		initiator_card -= event

var/global/maint_all_access = 0

/proc/make_maint_all_access()
	maint_all_access = 1
	to_chat(world, "<font size=4 color='red'>Attention!</font>")
	to_chat(world, "<font color='red'>The69aintenance access re69uirement has been revoked on all airlocks.</font>")

/proc/revoke_maint_all_access()
	maint_all_access = 0
	to_chat(world, "<font size=4 color='red'>Attention!</font>")
	to_chat(world, "<font color='red'>The69aintenance access re69uirement has been readded on all69aintenance airlocks.</font>")

/obj/machinery/door/airlock/allowed(mob/M)
	if(maint_all_access && src.check_access_list(list(access_maint_tunnels)))
		return 1
	return ..(M)
