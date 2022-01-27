/client/proc/cmd_mass_modify_object_variables(atom/A,69ar/var_name)
	set category = "Debug"
	set name = "Mass Edit69ariables"
	set desc="(target) Edit all instances of a target item's69ariables"

	var/method = 0	//069eans strict type detection while 169eans this type and all subtypes (IE: /obj/item with this set to 1 will set it to ALL itms)

	if(!check_rights(R_ADMIN))
		return

	if(A && A.type)
		if(typesof(A.type))
			switch(input("Strict object type detection?") as null|anything in list("Strictly this type","This type and subtypes", "Cancel"))
				if("Strictly this type")
					method = 0
				if("This type and subtypes")
					method = 1
				if("Cancel")
					return
				if(null)
					return

	src.massmodify_variables(A,69ar_name,69ethod)



/client/proc/massmodify_variables(var/atom/O,69ar/var_name = "",69ar/method = 0)
	if(!check_rights(R_ADMIN))
		return

	var/list/locked = list("vars", "key", "ckey", "client")

	for(var/p in forbidden_varedit_object_types)
		if( istype(O,p) )
			to_chat(usr, "\red It is forbidden to edit this object's69ariables.")
			return

	var/list/names = list()
	for (var/V in O.vars)
		names +=69

	names = sortList(names)

	var/variable = ""

	if(!var_name)
		variable = input("Which69ar?","Var") as null|anything in names
	else
		variable =69ar_name

	if(!variable)	return
	var/default
	var/var_value = O.vars69variable69
	var/dir

	if(variable == "holder" || (variable in locked))
		if(!check_rights(R_DEBUG))	return

	if(isnull(var_value))
		to_chat(usr, "Unable to determine69ariable type.")

	else if(isnum(var_value))
		to_chat(usr, "Variable appears to be <b>NUM</b>.")
		default = "num"
		dir = 1

	else if(istext(var_value))
		to_chat(usr, "Variable appears to be <b>TEXT</b>.")
		default = "text"

	else if(isloc(var_value))
		to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
		default = "reference"

	else if(isicon(var_value))
		to_chat(usr, "Variable appears to be <b>ICON</b>.")
		var_value = "\icon69var_value69"
		default = "icon"

	else if(istype(var_value,/atom) || istype(var_value,/datum))
		to_chat(usr, "Variable appears to be <b>TYPE</b>.")
		default = "type"

	else if(istype(var_value,/list))
		to_chat(usr, "Variable appears to be <b>LIST</b>.")
		default = "list"

	else if(istype(var_value,/client))
		to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
		default = "cancel"

	else
		to_chat(usr, "Variable appears to be <b>FILE</b>.")
		default = "file"

	to_chat(usr, "Variable contains: 69var_value69")
	if(dir)
		switch(var_value)
			if(1)
				dir = "NORTH"
			if(2)
				dir = "SOUTH"
			if(4)
				dir = "EAST"
			if(8)
				dir = "WEST"
			if(5)
				dir = "NORTHEAST"
			if(6)
				dir = "SOUTHEAST"
			if(9)
				dir = "NORTHWEST"
			if(10)
				dir = "SOUTHWEST"
			else
				dir = null
		if(dir)
			to_chat(usr, "If a direction, direction is: 69dir69")

	var/class = input("What kind of69ariable?","Variable Type",default) as null|anything in list("text",
		"num","type","icon","file","edit referenced object","restore to default")

	if(!class)
		return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref69O69 (69O69)"
	else
		original_name = O:name

	switch(class)

		if("restore to default")
			O.vars69variable69 = initial(O.vars69variable69)
			if(method)
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if ( istype(M , O.type) )
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69

			else
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if (M.type == O.type)
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

		if("edit referenced object")
			return .(O.vars69variable69)

		if("text")
			var/new_value = input("Enter new text:","Text",O.vars69variable69) as text|null//todo: sanitize ???
			if(new_value == null) return
			O.vars69variable69 = new_value

			if(method)
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if ( istype(M , O.type) )
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69
			else
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if (M.type == O.type)
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

		if("num")
			var/new_value = input("Enter new number:","Num",\
					O.vars69variable69) as num|null
			if(new_value == null) return

			if(variable=="light_range")
				O.set_light(new_value)
			else
				O.vars69variable69 = new_value

			if(method)
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if ( istype(M , O.type) )
							if(variable=="light_range")
								M.set_light(new_value)
							else
								M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if ( istype(A , O.type) )
							if(variable=="light_range")
								A.set_light(new_value)
							else
								A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if ( istype(A , O.type) )
							if(variable=="light_range")
								A.set_light(new_value)
							else
								A.vars69variable69 = O.vars69variable69

			else
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if (M.type == O.type)
							if(variable=="light_range")
								M.set_light(new_value)
							else
								M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if (A.type == O.type)
							if(variable=="light_range")
								A.set_light(new_value)
							else
								A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if (A.type == O.type)
							if(variable=="light_range")
								A.set_light(new_value)
							else
								A.vars69variable69 = O.vars69variable69

		if("type")
			var/new_value
			new_value = input("Enter type:","Type",O.vars69variable69) as null|anything in typesof(/obj,/mob,/area,/turf)
			if(new_value == null) return
			O.vars69variable69 = new_value
			if(method)
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if ( istype(M , O.type) )
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69
			else
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if (M.type == O.type)
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

		if("file")
			var/new_value = input("Pick file:","File",O.vars69variable69) as null|file
			if(new_value == null) return
			O.vars69variable69 = new_value

			if(method)
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if ( istype(M , O.type) )
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69
			else
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if (M.type == O.type)
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

		if("icon")
			var/new_value = input("Pick icon:","Icon",O.vars69variable69) as null|icon
			if(new_value == null) return
			O.vars69variable69 = new_value
			if(method)
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if ( istype(M , O.type) )
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if ( istype(A , O.type) )
							A.vars69variable69 = O.vars69variable69

			else
				if(ismob(O))
					for(var/mob/M in SSmobs.mob_list)
						if (M.type == O.type)
							M.vars69variable69 = O.vars69variable69

				else if(isobj(O))
					for(var/obj/A in world)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

				else if(istype(O, /turf))
					for(var/turf/A in turfs)
						if (A.type == O.type)
							A.vars69variable69 = O.vars69variable69

	log_admin("69key_name(src)6969ass69odified 69original_name69's 69variable69 to 69O.vars69variable6969")
	message_admins("69key_name_admin(src)6969ass69odified 69original_name69's 69variable69 to 69O.vars69variable6969", 1)
