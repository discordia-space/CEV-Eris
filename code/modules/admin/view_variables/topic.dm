
/client/proc/view_var_Topic(href, href_list, hsrc)
	if( (usr.client != src) || !src.holder || !holder.CheckAdminHref(href, href_list))
		return
	var/target = GET_VV_TARGET
	vv_do_basic(target, href_list, href)
	if(isdatum(target))
		var/datum/D = target
		D.vv_do_topic(href_list)
	else if(islist(target))
		vv_do_list(target, href_list)
	if(href_list["Vars"])
		var/datum/vars_target = locate(href_list["Vars"])
		if(href_list["special_varname"]) // Some special vars can't be located even if you have their ref, you have to use this instead
			vars_target = vars_target.vars[href_list["special_varname"]]
		debug_variables(vars_target)
	else if(href_list["adjustDamage"] && href_list["mobToDamage"])
		if(!check_rights(NONE))
			return

		var/mob/living/L = locate(href_list["mobToDamage"]) in GLOB.mob_list
		if(!istype(L))
			return

		var/Text = href_list["adjustDamage"]

		var/amount = input("Deal how much damage to mob? (Negative values here heal)","Adjust [Text]loss",0) as num|null

		if (isnull(amount))
			return

		if(!L)
			to_chat(usr, "Mob doesn't exist anymore", confidential = TRUE)
			return

		var/newamt
		switch(Text)
			if("brute")
				L.adjustBruteLoss(amount)
				newamt = L.getBruteLoss()
			if("fire")
				L.adjustFireLoss(amount)
				newamt = L.getFireLoss()
			if("toxin")
				L.adjustToxLoss(amount)
				newamt = L.getToxLoss()
			if("oxygen")
				L.adjustOxyLoss(amount)
				newamt = L.getOxyLoss()
			if("brain")
				L.adjustBrainLoss(amount)
				newamt = L.getBrainLoss()
			if("clone")
				L.adjustCloneLoss(amount)
				newamt = L.getCloneLoss()
			if("hallu")
				L.adjustHalLoss(amount)
				newamt = L.getHalLoss()
			else
				to_chat(usr, "You caused an error. DEBUG: Text:[Text] Mob:[L]", confidential = TRUE)
				return

		if(amount != 0)
			var/log_msg = "[key_name(usr)] dealt [amount] amount of [Text] damage to [key_name(L)]"
			message_admins("[key_name(usr)] dealt [amount] amount of [Text] damage to [ADMIN_LOOKUPFLW(L)]")
			log_admin(log_msg)
			// admin_ticket_log(L, log_msg)
			vv_update_display(L, Text, "[newamt]")
	//Finally, refresh if something modified the list.
	if(href_list["datumrefresh"])
		var/datum/DAT = locate(href_list["datumrefresh"])
		if(isdatum(DAT) || istype(DAT, /client) || islist(DAT))
			debug_variables(DAT)
