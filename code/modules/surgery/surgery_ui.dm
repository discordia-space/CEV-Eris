/obj/item/organ/external/CanUseTopic(mob/user)
	if(!is_open())
		return STATUS_CLOSE

	if(owner)
		return owner.CanUseTopic(user)

	return ..()


/obj/item/organ/external/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS)
	if(is_open() && !diagnosed)
		try_autodiagnose(user)

	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "surgery_organ.tmpl",69ame, 550, 400)
		ui.set_initial_data(data)
		ui.open()


/obj/item/organ/external/ui_data(mob/user)
	var/list/data = list()

	data69"status"69 = get_status_data()

	data69"max_damage"69 =69ax_damage
	data69"brute_dam"69 = brute_dam
	data69"burn_dam"69 = burn_dam

	data69"limb_efficiency"69 = limb_efficiency
	data69"occupied_volume"69 = get_total_occupied_volume()
	data69"max_volume"69 =69ax_volume

	data69"conditions"69 = get_conditions()
	data69"diagnosed"69 = diagnosed
	data69"shrapnel"69 = shrapnel_check()

	if(owner)
		data69"owner_oxyloss"69 = owner.getOxyLoss()
		data69"owner_oxymax"69 = 100 - owner.total_oxygen_re69
		if(!cannot_amputate)
			data69"amputate_step"69 = BP_IS_ROBOTIC(src) ? /datum/surgery_step/robotic/amputate : /datum/surgery_step/amputate

	data69"insert_step"69 = BP_IS_ROBOTIC(src) ? /datum/surgery_step/insert_item/robotic : /datum/surgery_step/insert_item

	var/list/contents_list = list()

	for(var/obj/item/organ/internal/organ in internal_organs)
		var/list/organ_data = list()

		organ_data69"name"69 = organ.name
		organ_data69"ref"69 = "\ref69organ69"
		organ_data69"open"69 = organ.is_open()

		var/icon/ic =69ew(organ.icon, organ.icon_state)
		usr << browse_rsc(ic, "69organ.icon_state69.png")	//Contvers the icon to a PNG so it can be used in the UI
		organ_data69"icon_data"69 = "69organ.icon_state69.png"

		organ_data69"damage"69 = organ.damage
		organ_data69"max_damage"69 = organ.max_damage
		organ_data69"status"69 = organ.get_status_data()
		organ_data69"conditions"69 = organ.get_conditions()

		organ_data69"stored_blood"69 = organ.current_blood
		organ_data69"max_blood"69 = organ.max_blood_storage
		if(BP_BRAIN in organ.organ_efficiency)
			organ_data69"show_oxy"69 = TRUE
		organ_data69"processes"69 = organ.get_process_data()

		var/list/actions_list = list()
		if(can_remove_item(organ))
			actions_list.Add(list(list(
					"name" = "Extract",
					"target" = "\ref69organ69",
					"step" = BP_IS_ROBOTIC(organ) ? /datum/surgery_step/robotic/remove_item : /datum/surgery_step/remove_item
				)))
		actions_list.Add(organ.get_actions())
		organ_data69"actions"69 = actions_list

		contents_list.Add(list(organ_data))

	for(var/i in implants)
		var/atom/movable/implant = i
		if(69DELETED(implant))
			implants -= implant
			continue

		var/list/implant_data = list()

		implant_data69"name"69 = implant.name
		implant_data69"ref"69 = "\ref69implant69"
		implant_data69"open"69 = TRUE
		var/icon/ic =69ew(implant.icon, implant.icon_state)
		usr << browse_rsc(ic, "69implant.icon_state69.png")	//Contvers the icon to a PNG so it can be used in the UI
		implant_data69"icon_data"69 = "69implant.icon_state69.png"
		implant_data69"processes"69 = list()

		var/list/actions_list = list()
		if(can_remove_item(implant))
			var/list/remove_action = list(
				"name" = "Extract",
				"target" = "\ref69implant69",
				"step" = BP_IS_ROBOTIC(src) ? /datum/surgery_step/robotic/remove_item : /datum/surgery_step/remove_item
			)

			actions_list.Add(list(remove_action))

		implant_data69"actions"69 = actions_list

		contents_list.Add(list(implant_data))

	data69"contents"69 = contents_list
	return data


/obj/item/organ/external/Topic(href, href_list)
	if(..())
		return

	switch(href_list69"command"69)
		if("diagnose")
			if(diagnosed || try_autodiagnose(usr))
				return TRUE

			if(istype(usr, /mob/living))
				var/mob/living/user = usr
				var/target_stat = BP_IS_ROBOTIC(src) ? STAT_MEC : STAT_BIO
				var/diag_time = 70 * usr.stats.getMult(target_stat, STAT_LEVEL_EXPERT)
				var/target = get_surgery_target()

				to_chat(user, SPAN_NOTICE("You start examining 69get_surgery_name()69 for issues."))

				var/wait
				if(ismob(target))
					wait = do_mob(user, target, diag_time)
				else
					wait = do_after(user, diag_time, target,69eedhand = FALSE)

				if(wait)
					if(prob(100 - FAILCHANCE_VERY_EASY + usr.stats.getStat(target_stat)))
						diagnosed = TRUE
					else
						to_chat(user, SPAN_WARNING("You failed to diagnose 69get_surgery_name()69!"))

			return TRUE

		if("step")
			var/step_path = text2path(href_list69"step"69)
			if(ispath(step_path, /datum/surgery_step))
				var/obj/item/organ/target_organ = locate(href_list69"organ"69)

				if(!target_organ)
					target_organ = src

				target_organ.try_surgery_step(step_path, usr, target = locate(href_list69"target"69))

			return TRUE

		if("remove_shrapnel")
			if(istype(usr, /mob/living))
				var/mob/living/user = usr
				var/target_stat = BP_IS_ROBOTIC(src) ? STAT_MEC : STAT_BIO
				var/removal_time = 70 * usr.stats.getMult(target_stat, STAT_LEVEL_PROF)
				var/target = get_surgery_target()
				var/obj/item/I = user.get_active_hand()

				if(!(69UALITY_CLAMPING in I.tool_69ualities))
					to_chat(user, SPAN_WARNING("You69eed a tool with 6969UALITY_CLAMPING69 69uality"))
					return FALSE

				to_chat(user, SPAN_NOTICE("You start removing shrapnel from 69get_surgery_name()69."))

				var/wait
				if(ismob(target))
					wait = do_mob(user, target, removal_time)
				else
					wait = do_after(user, removal_time, target,69eedhand = FALSE)

				if(wait)
					if(prob(100 - FAILCHANCE_NORMAL + usr.stats.getStat(target_stat)))
						for(var/obj/item/material/shard/shrapnel/shrapnel in src.implants)
							implants -= shrapnel
							shrapnel.loc = get_turf(src)
						to_chat(user, SPAN_WARNING("You have removed shrapnel from 69get_surgery_name()69."))
					else
						to_chat(user, SPAN_WARNING("You failed to remove any shrapnel from 69get_surgery_name()69!"))

			return TRUE
