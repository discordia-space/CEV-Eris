/client/var/global/list/forbidden_varedit_object_types = list(
										/datum/admins,						//Admins editing their own admin-power object? Yup, sounds like a good idea.,
										/obj/machinery/blackbox_recorder,	//Prevents people69essing with feedback gathering
									)

var/list/VVlocked = list("vars", "holder", "client", "virus", "viruses", "cuffed", "last_eaten", "unlock_content", "bound_x", "bound_y", "step_x", "step_y", "force_ending")
var/list/VVicon_edit_lock = list("icon", "icon_state", "overlays", "underlays")
var/list/VVckey_edit = list("key", "ckey")

/*
/client/proc/cmd_modify_object_variables(obj/O as obj|mob|turf|area in world)   // Acceptable 'in world', as69V would be incredibly hampered otherwise
	set category = "Debug"
	set name = "Edit69ariables"
	set desc="(target) Edit a target item's69ariables"
	src.modify_variables(O)

*/

/client/proc/mod_list_add_ass()
	var/class = "text"
	var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")
	if(src.holder)
		var/datum/marked_datum = holder.marked_datum()
		if(marked_datum)
			class_input += "marked datum (69marked_datum.type69)"

	class = input("What kind of69ariable?","Variable Type") as null|anything in class_input
	if(!class)
		return

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum (69marked_datum.type69)")
		class = "marked datum"

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as null|text

		if("num")
			var_value = input("Enter new number:","Num") as null|num

		if("type")
			var_value = input("Enter type:","Type") as null|anything in typesof(/obj,/mob,/area,/turf)

		if("reference")
			var_value = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as null|mob in world

		if("file")
			var_value = input("Pick file:","File") as null|file

		if("icon")
			var_value = input("Pick icon:","Icon") as null|icon

		if("marked datum")
			var_value = holder.marked_datum()

	if(!var_value) return

	return69ar_value


/client/proc/mod_list_add(var/list/L, atom/O, original_name, objectvar)

	var/class = "text"
	var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")
	if(src.holder)
		var/datum/marked_datum = holder.marked_datum()
		if(marked_datum)
			class_input += "marked datum (69marked_datum.type69)"

	class = input("What kind of69ariable?","Variable Type") as null|anything in class_input
	if(!class)
		return

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum (69marked_datum.type69)")
		class = "marked datum"

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as text

		if("num")
			var_value = input("Enter new number:","Num") as num

		if("type")
			var_value = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)

		if("reference")
			var_value = input("Select reference:","Reference") as69ob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as69ob in world

		if("file")
			var_value = input("Pick file:","File") as file

		if("icon")
			var_value = input("Pick icon:","Icon") as icon

		if("marked datum")
			var_value = holder.marked_datum()

	if(!var_value) return

	switch(alert("Would you like to associate a69ar with the list entry?",,"Yes","No"))
		if("Yes")
			L +=69ar_value
			L69var_value69 =69od_list_add_ass() //haha
		if("No")
			L +=69ar_value
	log_world("### ListVarEdit by 69src69: 69O.type69 69objectvar69: ADDED=69var_value69")
	log_admin("69key_name(src)6969odified 69original_name69's 69objectvar69: ADDED=69var_value69")
	message_admins("69key_name_admin(src)6969odified 69original_name69's 69objectvar69: ADDED=69var_value69")

/client/proc/mod_list(var/list/L, atom/O, original_name, objectvar)
	if(!check_rights(R_ADMIN))
		return
	if(!istype(L,/list)) src << "Not a List."

	if(L.len > 1000)
		var/confirm = alert(src, "The list you're trying to edit is69ery long, continuing69ay crash the server.", "Warning", "Continue", "Abort")
		if(confirm != "Continue")
			return

	var/assoc = 0
	if(L.len > 0)
		var/a = L69169
		if(istext(a) && L69a69 != null)
			assoc = 1 //This is pretty weak test but i can't think of anything else
			to_chat(usr, "List appears to be associative.")

	var/list/names = null
	if(!assoc)
		names = sortList(L)

	var/variable
	var/assoc_key
	if(assoc)
		variable = input("Which69ar?","Var") as null|anything in L + "(ADD69AR)"
	else
		variable = input("Which69ar?","Var") as null|anything in names + "(ADD69AR)"

	if(variable == "(ADD69AR)")
		mod_list_add(L, O, original_name, objectvar)
		return

	if(assoc)
		assoc_key =69ariable
		variable = L69assoc_key69

	if(!assoc && !variable || assoc && !assoc_key)
		return

	var/default

	var/dir

	if(variable in69Vlocked)
		if(!check_rights(R_DEBUG))
			return
	if(variable in69Vckey_edit)
		if(!check_rights(R_FUN|R_DEBUG))
			return
	if(variable in69Vicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG))
			return

	if(isnull(variable))
		to_chat(usr, "Unable to determine69ariable type.")

	else if(isnum(variable))
		to_chat(usr, "Variable appears to be <b>NUM</b>.")
		default = "num"
		dir = 1

	else if(istext(variable))
		to_chat(usr, "Variable appears to be <b>TEXT</b>.")
		default = "text"

	else if(isloc(variable))
		to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
		default = "reference"

	else if(isicon(variable))
		to_chat(usr, "Variable appears to be <b>ICON</b>.")
		variable = "\icon69variable69"
		default = "icon"

	else if(istype(variable,/atom) || istype(variable,/datum))
		to_chat(usr, "Variable appears to be <b>TYPE</b>.")
		default = "type"

	else if(istype(variable,/list))
		to_chat(usr, "Variable appears to be <b>LIST</b>.")
		default = "list"

	else if(istype(variable,/client))
		to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
		default = "cancel"

	else
		to_chat(usr, "Variable appears to be <b>FILE</b>.")
		default = "file"

	to_chat(usr, "Variable contains: 69variable69")
	if(dir)
		switch(variable)
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

	var/class = "text"
	var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(src.holder)
		var/datum/marked_datum = holder.marked_datum()
		if(marked_datum)
			class_input += "marked datum (69marked_datum.type69)"

	class_input += "DELETE FROM LIST"
	class = input("What kind of69ariable?","Variable Type",default) as null|anything in class_input

	if(!class)
		return

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum (69marked_datum.type69)")
		class = "marked datum"

	var/original_var
	if(assoc)
		original_var = L69assoc_key69
	else
		original_var = L69L.Find(variable)69

	var/new_var
	switch(class) //Spits a runtime error if you try to69odify an entry in the contents list. Dunno how to fix it, yet.

		if("list")
			mod_list(variable, O, original_name, objectvar)

		if("restore to default")
			new_var = initial(variable)
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("edit referenced object")
			modify_variables(variable)

		if("DELETE FROM LIST")
			log_world("### ListVarEdit by 69src69: 69O.type69 69objectvar69: REMOVED=69html_encode("69variable69")69")
			log_admin("69key_name(src)6969odified 69original_name69's 69objectvar69: REMOVED=69variable69")
			message_admins("69key_name_admin(src)6969odified 69original_name69's 69objectvar69: REMOVED=69variable69")
			L -=69ariable
			return

		if("text")
			new_var = input("Enter new text:","Text") as text
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("num")
			new_var = input("Enter new number:","Num") as num
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("type")
			new_var = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("reference")
			new_var = input("Select reference:","Reference") as69ob|obj|turf|area in world
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("mob reference")
			new_var = input("Select reference:","Reference") as69ob in world
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("file")
			new_var = input("Pick file:","File") as file
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("icon")
			new_var = input("Pick icon:","Icon") as icon
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

		if("marked datum")
			new_var = holder.marked_datum()
			if(!new_var)
				return
			if(assoc)
				L69assoc_key69 = new_var
			else
				L69L.Find(variable)69 = new_var

	log_world("### ListVarEdit by 69src69: 69O.type69 69objectvar69: 69original_var69=69new_var69")
	log_admin("69key_name(src)6969odified 69original_name69's 69objectvar69: 69original_var69=69new_var69")
	message_admins("69key_name_admin(src)6969odified 69original_name69's69arlist 69objectvar69: 69original_var69=69new_var69")

/client/proc/modify_variables(var/atom/O,69ar/param_var_name = null,69ar/autodetect_class = 0)
	if(!check_rights(R_ADMIN))
		return

	for(var/p in forbidden_varedit_object_types)
		if( istype(O,p) )
			to_chat(usr, SPAN_DANGER("It is forbidden to edit this object's69ariables."))
			return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!(param_var_name in O.vars))
			to_chat(src, "A69ariable with this name (69param_var_name69) doesn't exist in this atom (69O69)")
			return

		if(param_var_name in69Vlocked)
			if(!check_rights(R_DEBUG))
				return
		if(param_var_name in69Vckey_edit)
			if(!check_rights(R_FUN|R_DEBUG))
				return
		if(param_var_name in69Vicon_edit_lock)
			if(!check_rights(R_FUN|R_DEBUG))
				return

		variable = param_var_name

		var_value = O.vars69variable69

		if(autodetect_class)
			if(isnull(var_value))
				to_chat(usr, "Unable to determine69ariable type.")
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				to_chat(usr, "Variable appears to be <b>NUM</b>.")
				class = "num"
				dir = 1

			else if(istext(var_value))
				to_chat(usr, "Variable appears to be <b>TEXT</b>.")
				class = "text"

			else if(isloc(var_value))
				to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
				class = "reference"

			else if(isicon(var_value))
				to_chat(usr, "Variable appears to be <b>ICON</b>.")
				var_value = "\icon69var_value69"
				class = "icon"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				to_chat(usr, "Variable appears to be <b>TYPE</b>.")
				class = "type"

			else if(istype(var_value,/list))
				to_chat(usr, "Variable appears to be <b>LIST</b>.")
				class = "list"

			else if(istype(var_value,/client))
				to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
				class = "cancel"

			else
				to_chat(usr, "Variable appears to be <b>FILE</b>.")
				class = "file"

	else

		var/list/names = list()
		for (var/V in O.vars)
			names +=69

		names = sortList(names)

		variable = input("Which69ar?","Var") as null|anything in names
		if(!variable)	return
		var_value = O.vars69variable69

		if(variable in69Vlocked)
			if(!check_rights(R_DEBUG)) return
		if(variable in69Vckey_edit)
			if(!check_rights(R_FUN|R_DEBUG)) return
		if(variable in69Vicon_edit_lock)
			if(!check_rights(R_FUN|R_DEBUG)) return

	if(!autodetect_class)

		var/dir
		var/default
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

		var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")
		if(src.holder)
			var/datum/marked_datum = holder.marked_datum()
			if(marked_datum)
				class_input += "marked datum (69marked_datum.type69)"
		class = input("What kind of69ariable?","Variable Type",default) as null|anything in class_input

		if(!class)
			return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref69O69 (69O69)"
	else
		original_name = O:name

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum (69marked_datum.type69)")
		class = "marked datum"

	switch(class)

		if("list")
			mod_list(O.vars69variable69, O, original_name,69ariable)
			return

		if("restore to default")
			O.vars69variable69 = initial(O.vars69variable69)

		if("edit referenced object")
			return .(O.vars69variable69)

		if("text")
			var/var_new = input("Enter new text:","Text",O.vars69variable69) as null|text
			if(var_new==null) return
			O.vars69variable69 =69ar_new

		if("num")
			if(variable=="light_range")
				var/var_new = input("Enter new number:","Num",O.vars69variable69) as null|num
				if(var_new == null) return
				O.set_light(var_new)
			else if(variable=="stat")
				var/var_new = input("Enter new number:","Num",O.vars69variable69) as null|num
				if(var_new == null) return
				if((O.vars69variable69 == 2) && (var_new < 2))//Bringing the dead back to life
					GLOB.dead_mob_list -= O
					GLOB.living_mob_list += O
				if((O.vars69variable69 < 2) && (var_new == 2))//Kill he
					GLOB.living_mob_list -= O
					GLOB.dead_mob_list += O
				O.vars69variable69 =69ar_new
			else
				var/var_new =  input("Enter new number:","Num",O.vars69variable69) as null|num
				if(var_new==null) return
				O.vars69variable69 =69ar_new

		if("type")
			var/var_new = input("Enter type:","Type",O.vars69variable69) as null|anything in typesof(/obj,/mob,/area,/turf)
			if(var_new==null) return
			O.vars69variable69 =69ar_new

		if("reference")
			var/var_new = input("Select reference:","Reference",O.vars69variable69) as null|mob|obj|turf|area in world
			if(var_new==null) return
			O.vars69variable69 =69ar_new

		if("mob reference")
			var/var_new = input("Select reference:","Reference",O.vars69variable69) as null|mob in world
			if(var_new==null) return
			O.vars69variable69 =69ar_new

		if("file")
			var/var_new = input("Pick file:","File",O.vars69variable69) as null|file
			if(var_new==null) return
			O.vars69variable69 =69ar_new

		if("icon")
			var/var_new = input("Pick icon:","Icon",O.vars69variable69) as null|icon
			if(var_new==null) return
			O.vars69variable69 =69ar_new

		if("marked datum")
			O.vars69variable69 = holder.marked_datum()

	log_world("###69arEdit by 69src69: 69O.type69 69variable69=69html_encode("69O.vars69variable6969")69")
	log_admin("69key_name(src)6969odified 69original_name69's 69variable69 to 69O.vars69variable6969")
	message_admins("69key_name_admin(src)6969odified 69original_name69's 69variable69 to 69O.vars69variable6969")
