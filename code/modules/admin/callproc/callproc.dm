ADMIN_VERB_ADD(/client/proc/callproc, R_DEBUG, FALSE)
/client/proc/callproc()
	set category = "Debug"
	set name = "Advanced ProcCall"

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	var/target = null
	var/targetselected = 0

	switch(alert("Proc owned by something?",, "Yes", "No", "Cancel"))
		if("Yes")
			targetselected=1
			switch(input("Proc owned by...", "Owner", null) as null|anything in list("Obj", "Mob", "Area or Turf", "Client"))
				if("Obj")
					target = input("Select target:", "Target") as null|obj in world
				if("Mob")
					target = input("Select target:", "Target", usr) as null|mob in world
				if("Area or Turf")
					target = input("Select target:", "Target", get_turf(usr)) as null|area|turf in world
				if("Client")
					target = input("Select target:", "Target", usr.client) as null|anything in clients
				else
					return
			if(!target)
				to_chat(usr, "Proc call cancelled.")
				return
		if("Cancel")
			return
		if("No")
			; // do nothing

	callproc_targetpicked(targetselected, target)


ADMIN_VERB_ADD(/client/proc/callproc_target, R_DEBUG, FALSE)
/client/proc/callproc_target(atom/A in range(world.view))
	set category = "Debug"
	set name = "Advanced ProcCall Target"

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	callproc_targetpicked(1, A)

/client/proc/callproc_targetpicked(hastarget, datum/target)

	// this needs checking again here because69V's 'Call Proc' option directly calls this proc with the target datum
	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	var/returnval

	var/procname = input("Proc name", "Proc") as null|text
	if(!procname) return

	if(hastarget)
		if(!target)
			to_chat(usr, "Your callproc target no longer exists.")
			return
		if(!hascall(target, procname))
			to_chat(usr, "\The 69target69 has no call 69procname69()")
			return

	var/list/arguments = list()
	var/done = 0
	var/current

	while(!done)
		if(hastarget && !target)
			to_chat(usr, "Your callproc target no longer exists.")
			return
		switch(input("Type of 69arguments.len+169\th69ariable", "argument 69arguments.len+169") as null|anything in list(
				"finished", "null", "text", "num", "type", "obj reference", "mob reference",
				"area/turf reference", "icon", "file", "client", "mob's area", "marked datum"))
			if(null)
				return

			if("finished")
				done = 1

			if("null")
				current = null

			if("text")
				current = input("Enter text for 69arguments.len+169\th argument") as null|text
				if(isnull(current)) return

			if("num")
				current = input("Enter number for 69arguments.len+169\th argument") as null|num
				if(isnull(current)) return

			if("type")
				current = input("Select type for 69arguments.len+169\th argument") as null|anything in typesof(/obj, /mob, /area, /turf)
				if(isnull(current)) return

			if("obj reference")
				current = input("Select object for 69arguments.len+169\th argument") as null|obj in world
				if(isnull(current)) return

			if("mob reference")
				current = input("Select69ob for 69arguments.len+169\th argument") as null|mob in world
				if(isnull(current)) return

			if("area/turf reference")
				current = input("Select area/turf for 69arguments.len+169\th argument") as null|area|turf in world
				if(isnull(current)) return

			if("icon")
				current = input("Provide icon for 69arguments.len+169\th argument") as null|icon
				if(isnull(current)) return

			if("client")
				current = input("Select client for 69arguments.len+169\th argument") as null|anything in clients
				if(isnull(current)) return

			if("mob's area")
				var/mob/M = input("Select69ob to take area for 69arguments.len+169\th argument") as null|mob in world
				if(!M) return
				current = get_area(M)
				if(!current)
					switch(alert("\The 69M69 appears to not have an area; do you want to pass null instead?",, "Yes", "Cancel"))
						if("Yes")
							; // do nothing
						if("Cancel")
							return

			if("marked datum")
				current = holder.marked_datum()
				if(!current)
					switch(alert("You do not currently have a69arked datum; do you want to pass null instead?",, "Yes", "Cancel"))
						if("Yes")
							; // do nothing
						if("Cancel")
							return
		if(!done)
			arguments += current

	if(hastarget)
		if(!target)
			to_chat(usr, "Your callproc target no longer exists.")
			return
		log_admin("69key_name(src)69 called 69target69's 69procname69() with 69arguments.len ? "the arguments 69list2params(arguments)69" : "no arguments"69.")
		if(arguments.len)
			returnval = call(target, procname)(arglist(arguments))
		else
			returnval = call(target, procname)()
	else
		log_admin("69key_name(src)69 called 69procname69() with 69arguments.len ? "the arguments 69list2params(arguments)69" : "no arguments"69.")
		returnval = call(procname)(arglist(arguments))

	to_chat(usr, "<span class='info'>69procname69() returned: 69isnull(returnval) ? "null" : returnval69</span>")

