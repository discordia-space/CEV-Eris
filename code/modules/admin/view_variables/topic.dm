
/client/proc/view_var_Topic(href, href_list, hsrc)
	//This should all be69oved over to datum/admins/Topic() or something ~Carn
	if( (usr.client != src) || !src.holder )
		return
	if(href_list69"Vars"69)
		debug_variables(locate(href_list69"Vars"69))

	//~CARN: for renaming69obs (updates their name, real_name,69ind.name, their ID/PDA and datacore records).
	else if(href_list69"rename"69)
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list69"rename"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/new_name = sanitize(input(usr,"What would you like to name this69ob?","Input a name",M.real_name) as text|null,69AX_NAME_LEN)
		if(!new_name || !M)
			return

		message_admins("Admin 69key_name_admin(usr)69 renamed 69key_name_admin(M)69 to 69new_name69.")
		M.fully_replace_character_name(M.real_name,new_name)
		href_list69"datumrefresh"69 = href_list69"rename"69

	else if(href_list69"varnameedit"69 && href_list69"datumedit"69)
		if(!check_rights(R_ADMIN))
			return

		var/D = locate(href_list69"datumedit"69)
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list69"varnameedit"69, 1)

	else if(href_list69"varnamechange"69 && href_list69"datumchange"69)
		if(!check_rights(R_ADMIN))
			return

		var/D = locate(href_list69"datumchange"69)
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list69"varnamechange"69, 0)

	else if(href_list69"varnamemass"69 && href_list69"datummass"69)
		if(!check_rights(R_ADMIN))
			return

		var/atom/A = locate(href_list69"datummass"69)
		if(!istype(A))
			to_chat(usr, "This can only be used on instances of type /atom")
			return

		cmd_mass_modify_object_variables(A, href_list69"varnamemass"69)

	else if(href_list69"mob_player_panel"69)
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list69"mob_player_panel"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.holder.show_player_panel(M)
		href_list69"datumrefresh"69 = href_list69"mob_player_panel"69

	else if(href_list69"give_disease2"69)
		if(!check_rights(R_ADMIN|R_FUN))
			return

		var/mob/M = locate(href_list69"give_disease2"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.give_disease2(M)
		href_list69"datumrefresh"69 = href_list69"give_spell"69

	else if(href_list69"godmode"69)
		if(!check_rights(R_FUN))
			return

		var/mob/M = locate(href_list69"godmode"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_godmode(M)
		href_list69"datumrefresh"69 = href_list69"godmode"69

	else if(href_list69"gib"69)
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list69"gib"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_gib(M)

	else if(href_list69"build_mode"69)
		if(!check_rights(R_FUN))
			return

		var/mob/M = locate(href_list69"build_mode"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		togglebuildmode(M)
		href_list69"datumrefresh"69 = href_list69"build_mode"69

	else if(href_list69"drop_everything"69)
		if(!check_rights(R_DEBUG|R_ADMIN))
			return

		var/mob/M = locate(href_list69"drop_everything"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_admin_drop_everything(M)

	else if(href_list69"direct_control"69)
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list69"direct_control"69)
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_assume_direct_control(M)

	else if(href_list69"make_skeleton"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list69"make_skeleton"69)
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		H.ChangeToSkeleton()
		href_list69"datumrefresh"69 = href_list69"make_skeleton"69

	else if(href_list69"delall"69)
		if(!check_rights(R_DEBUG|R_SERVER))
			return

		var/atom/movable/O = locate(href_list69"delall"69)
		if(!istype(O))
			to_chat(usr, "This can only be used on instances of type /atom/movable")
			return

		var/action_type = alert("Strict type (69O.type69) or type and all subtypes?",,"Strict type","Type and subtypes","Cancel")
		if(action_type == "Cancel" || !action_type)
			return

		if(alert("Are you really sure you want to delete all objects of type 69O.type69?",,"Yes","No") != "Yes")
			return

		if(alert("Second confirmation required. Delete?",,"Yes","No") != "Yes")
			return

		var/O_type = O.type
		switch(action_type)
			if("Strict type")
				var/i = 0
				for(var/atom/movable/Obj in world)
					if(Obj.type == O_type)
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("69key_name(usr)69 deleted all objects of type 69O_type69 (69i69 objects deleted)")
				message_admins(SPAN_NOTICE("69key_name(usr)69 deleted all objects of type 69O_type69 (69i69 objects deleted)"))
			if("Type and subtypes")
				var/i = 0
				for(var/atom/movable/Obj in world)
					if(istype(Obj,O_type))
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("69key_name(usr)69 deleted all objects of type or subtype of 69O_type69 (69i69 objects deleted)")
				message_admins(SPAN_NOTICE("69key_name(usr)69 deleted all objects of type or subtype of 69O_type69 (69i69 objects deleted)"))

	else if(href_list69"explode"69)
		if(!check_rights(R_DEBUG|R_FUN))	return

		var/atom/A = locate(href_list69"explode"69)
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		src.cmd_admin_explosion(A)
		href_list69"datumrefresh"69 = href_list69"explode"69

	else if(href_list69"emp"69)
		if(!check_rights(R_DEBUG|R_FUN))	return

		var/atom/A = locate(href_list69"emp"69)
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		src.cmd_admin_emp(A)
		href_list69"datumrefresh"69 = href_list69"emp"69

	else if(href_list69"mark_object"69)
		if(!check_rights(0))	return

		var/datum/D = locate(href_list69"mark_object"69)
		if(!istype(D))
			to_chat(usr, "This can only be done to instances of type /datum")
			return

		src.holder.marked_datum_weak = weakref(D)
		href_list69"datumrefresh"69 = href_list69"mark_object"69

	else if(href_list69"rotatedatum"69)
		if(!check_rights(0))	return

		var/atom/A = locate(href_list69"rotatedatum"69)
		if(!istype(A))
			to_chat(usr, "This can only be done to instances of type /atom")
			return

		switch(href_list69"rotatedir"69)
			if("right")	A.set_dir(turn(A.dir, -45))
			if("left")	A.set_dir(turn(A.dir, 45))
		href_list69"datumrefresh"69 = href_list69"rotatedatum"69

	else if(href_list69"makemonkey"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list69"makemonkey"69)
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm69ob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("monkeyone"=href_list69"makemonkey"69))

	else if(href_list69"makerobot"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list69"makerobot"69)
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm69ob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makerobot"=href_list69"makerobot"69))

	else if(href_list69"makeslime"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list69"makeslime"69)
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm69ob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makeslime"=href_list69"makeslime"69))

	else if(href_list69"makeai"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list69"makeai"69)
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm69ob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makeai"=href_list69"makeai"69))

	else if(href_list69"setspecies"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list69"setspecies"69)
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/new_species = input("Please choose a new species.","Species",null) as null|anything in all_species

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.set_species(new_species))
			to_chat(usr, "Set species of 69H69 to 69H.species69.")
		else
			to_chat(usr, "Failed! Something went wrong.")

	else if(href_list69"addlanguage"69)
		if(!check_rights(R_FUN))
			return

		var/mob/H = locate(href_list69"addlanguage"69)
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		var/new_language = input("Please choose a language to add.","Language",null) as null|anything in all_languages

		if(!new_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.add_language(new_language))
			to_chat(usr, "Added 69new_language69 to 69H69.")
		else
			to_chat(usr, "Mob already knows that language.")

	else if(href_list69"remlanguage"69)
		if(!check_rights(R_FUN))
			return

		var/mob/H = locate(href_list69"remlanguage"69)
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		if(!H.languages.len)
			to_chat(usr, "This69ob knows no languages.")
			return

		var/datum/language/rem_language = input("Please choose a language to remove.","Language",null) as null|anything in H.languages

		if(!rem_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.remove_language(rem_language.name))
			to_chat(usr, "Removed 69rem_language69 from 69H69.")
		else
			to_chat(usr, "Mob doesn't know that language.")

	else if(href_list69"addverb"69)
		if(!check_rights(R_DEBUG))
			return

		var/mob/living/H = locate(href_list69"addverb"69)

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return
		var/list/possibleverbs = list()
		possibleverbs += "Cancel" 								// One for the top...
		possibleverbs += typesof(/mob/proc,/mob/verb,/mob/living/proc,/mob/living/verb)
		switch(H.type)
			if(/mob/living/carbon/human)
				possibleverbs += typesof(/mob/living/carbon/proc,/mob/living/carbon/verb,/mob/living/carbon/human/verb,/mob/living/carbon/human/proc)
			if(/mob/living/silicon/robot)
				possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/robot/proc,/mob/living/silicon/robot/verb)
			if(/mob/living/silicon/ai)
				possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/ai/proc,/mob/living/silicon/ai/verb)
		possibleverbs -= H.verbs
		possibleverbs += "Cancel" 								// ...And one for the bottom

		var/verb = input("Select a69erb!", "Verbs",null) as anything in possibleverbs
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb ||69erb == "Cancel")
			return
		else
			H.verbs +=69erb

	else if(href_list69"remverb"69)
		if(!check_rights(R_DEBUG))      return

		var/mob/H = locate(href_list69"remverb"69)

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		var/verb = input("Please choose a69erb to remove.","Verbs",null) as null|anything in H.verbs
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb)
			return
		else
			H.verbs -=69erb

	else if(href_list69"addorgan"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/M = locate(href_list69"addorgan"69)
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/new_organ = input("Please choose an organ to add.","Organ",null) as null|anything in typesof(/obj/item/organ)-/obj/item/organ
		if(!new_organ) return

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(locate(new_organ) in69.internal_organs)
			to_chat(usr, "Mob already has that organ.")
			return

		new new_organ(M)


	else if(href_list69"remorgan"69)
		if(!check_rights(R_FUN))
			return

		var/mob/living/carbon/M = locate(href_list69"remorgan"69)
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/obj/item/organ/rem_organ = input("Please choose an organ to remove.","Organ",null) as null|anything in69.internal_organs

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(!(locate(rem_organ) in69.internal_organs))
			to_chat(usr, "Mob does not have that organ.")
			return

		to_chat(usr, "Removed 69rem_organ69 from 69M69.")
		rem_organ.removed()
		qdel(rem_organ)

	else if(href_list69"fix_nano"69)
		if(!check_rights(R_DEBUG)) return

		var/mob/H = locate(href_list69"fix_nano"69)

		if(!istype(H) || !H.client)
			to_chat(usr, "This can only be done on69obs with clients")
			return

		SSnano.close_uis(H)
		H.client.cache.Cut()
		var/datum/asset/assets = get_asset_datum(/datum/asset/directories/nanoui)
		assets.send(H)

		to_chat(usr, "Resource files sent")
		to_chat(H, "Your NanoUI Resource files have been refreshed")

		log_admin("69key_name(usr)69 resent the NanoUI resource files to 69key_name(H)69 ")

	else if(href_list69"regenerateicons"69)
		if(!check_rights(0))	return

		var/mob/M = locate(href_list69"regenerateicons"69)
		if(!ismob(M))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		M.regenerate_icons()

	else if(href_list69"adjustDamage"69 && href_list69"mobToDamage"69)
		if(!check_rights(R_DEBUG|R_ADMIN|R_FUN))	return

		var/mob/living/L = locate(href_list69"mobToDamage"69)
		if(!istype(L)) return

		var/Text = href_list69"adjustDamage"69

		var/amount =  input("Deal how69uch damage to69ob? (Negative69alues here heal)","Adjust 69Text69loss",0) as num

		if(!L)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		switch(Text)
			if("brute")	L.adjustBruteLoss(amount)
			if("fire")	L.adjustFireLoss(amount)
			if("toxin")	L.adjustToxLoss(amount)
			if("oxygen")L.adjustOxyLoss(amount)
			if("brain")	L.adjustBrainLoss(amount)
			if("clone")	L.adjustCloneLoss(amount)
			else
				to_chat(usr, "You caused an error. DEBUG: Text:69Text6969ob:69L69")
				return

		if(amount != 0)
			log_admin("69key_name(usr)69 dealt 69amount69 amount of 69Text69 damage to 69L69")
			message_admins(SPAN_NOTICE("69key_name(usr)69 dealt 69amount69 amount of 69Text69 damage to 69L69"))
			href_list69"datumrefresh"69 = href_list69"mobToDamage"69

	else if(href_list69"call_proc"69)
		var/datum/D = locate(href_list69"call_proc"69)
		if(istype(D) || istype(D, /client)) // can call on clients too, not just datums
			callproc_targetpicked(1, D)

	else if(href_list69"teleport_here"69)
		if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
			return

		var/atom/movable/A = locate(href_list69"teleport_here"69)
		if(!istype(A))
			to_chat(usr, "This can only be done to instances of69ovable atoms.")
			return

		var/turf/T = get_turf(usr)
		A.forceMove(T)

	else if(href_list69"teleport_to"69)
		if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
			return

		var/atom/A = locate(href_list69"teleport_to"69)
		if(!istype(A))
			to_chat(usr, "This can only be done to instances of atoms.")
			return

		usr.forceMove(get_turf(A))

	if(href_list69"datumrefresh"69)
		var/datum/DAT = locate(href_list69"datumrefresh"69)
		if(istype(DAT, /datum) || istype(DAT, /client))
			debug_variables(DAT)

	if(href_list69"addreagent"69)
		if(!check_rights(NONE))
			return

		var/atom/A = locate(href_list69"addreagent"69)

		if(!A.reagents)
			var/amount = input(usr, "Specify the reagent size of 69A69", "Set Reagent Size", 50) as num
			if(amount)
				A.create_reagents(amount)

		if(A.reagents)
			var/chosen_id
			var/list/reagent_options = sortList(GLOB.chemical_reagents_list)
			switch(alert(usr, "Choose a69ethod.", "Add Reagents", "Enter ID", "Choose ID"))
				if("Enter ID")
					var/valid_id
					while(!valid_id)
						chosen_id = stripped_input(usr, "Enter the ID of the reagent you want to add.")
						if(!chosen_id) //Get69e out of here!
							break
						for(var/ID in reagent_options)
							if(ID == chosen_id)
								valid_id = 1
						if(!valid_id)
							to_chat(usr, "<span class='warning'>A reagent with that ID doesn't exist!</span>")
				if("Choose ID")
					chosen_id = input(usr, "Choose a reagent to add.", "Choose a reagent.") as null|anything in reagent_options
			if(chosen_id)
				var/amount = input(usr, "Choose the amount to add.", "Choose the amount.", A.reagents.get_free_space()) as num
				if(amount)
					A.reagents.add_reagent(chosen_id, amount)
					log_admin("69key_name(usr)69 has added 69amount69 units of 69chosen_id69 to \the 69A69")
					message_admins("<span class='notice'>69key_name(usr)69 has added 69amount69 units of 69chosen_id69 to \the 69A69</span>")

	return