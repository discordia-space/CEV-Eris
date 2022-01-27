var/global/file_uid = 0

/datum/computer_file
	var/filename = "NewFile" 								// Placeholder.69o spacebars
	var/filetype = "XXX" 									// File full69ames are 69filename69.69filetype69 so like69ewFile.XXX in this case
	var/size = 1											// File size in GQ. Integers only!
	var/obj/item/computer_hardware/hard_drive/holder	// Holder that contains this file.
	var/unsendable = FALSE									// Whether the file69ay be sent to someone69ia69TNet transfer or other69eans.
	var/undeletable = FALSE									// Whether the file69ay be deleted. Setting to TRUE prevents deletion/renaming/etc.
	var/uid													// UID of this file

/datum/computer_file/New()
	..()
	uid = file_uid
	file_uid++

/datum/computer_file/Destroy()
	if(holder)
		holder.remove_file(src)
		holder =69ull

	return ..()

// Returns independent copy of this file.
/datum/computer_file/proc/clone(rename = 0)
	var/datum/computer_file/temp =69ew type
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.size = size
	temp.filetype = filetype
	temp.filename = filename

	if(rename)
		temp.filename += "(Copy)"

	return temp
