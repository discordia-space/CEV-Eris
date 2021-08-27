GLOBAL_VAR_INIT(file_uid, 0)
/datum/computer_file
	var/filename = "NewFile" 								// Placeholder. No spacebars
	var/filetype = "XXX" 									// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/size = 1											// File size in GQ. Integers only!
	var/obj/item/computer_hardware/hard_drive/holder	// Holder that contains this file.
	var/unsendable = FALSE									// Whether the file may be sent to someone via NTNet transfer or other means.
	var/undeletable = FALSE									// Whether the file may be deleted. Setting to TRUE prevents deletion/renaming/etc.
	var/Clonable = TRUE
	var/uid													// UID of this file

	var/static/list/VARS_BLACKLIST_FOR_CLONE = list("holder", "uid") // put here all variables that use referenses, you should set vars with references by yourself

/datum/computer_file/New()
	. = ..()
	uid = GLOB.file_uid
	GLOB.file_uid++

/datum/computer_file/Destroy()
	if(holder)
		holder.remove_file(src)
		holder = null

	return ..()

// Returns independent copy of this file.
/datum/computer_file/proc/clone(rename = 0, force = FALSE)
	if(!(Clonable || force))
		return FALSE
	var/datum/computer_file/clone_file = new type()
	// clone_file.unsendable = unsendable
	// clone_file.undeletable = undeletable
	// clone_file.size = size
	// clone_file.filetype = filetype
	// clone_file.filename = filename
	for(var/i in vars)
		if(!VARS_BLACKLIST_FOR_CLONE.Find(i))
			clone_file.vars[i] = vars[i]

	if(istext(rename))
		clone_file.filename = rename
	else if(rename)
		clone_file.filename += "(Copy)"

	return clone_file
