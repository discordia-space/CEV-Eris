// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data
	var/stored_data = "" 			// Stored data in string format.
	filetype = "DAT"
	var/block_size = 250
	var/read_only = FALSE			// Whether the user will be reminded that the file probably shouldn't be edited.

/datum/computer_file/data/clone()
	var/datum/computer_file/data/F = ..()
	F.stored_data = stored_data
	return F

// Calculates file size from amount of characters in saved string
/datum/computer_file/data/proc/calculate_size()
	size = max(1, round(length(stored_data) / block_size))

/datum/computer_file/data/logfile
	filetype = "LOG"

/datum/computer_file/data/text
	filetype = "TXT"

/datum/computer_file/data/audio
	filetype = "AUD"
	var/transcribed = FALSE
	var/max_capacity = 600
	var/used_capacity = 0
	var/list/storedinfo = list()
	var/list/timestamp = list()

/datum/computer_file/data/audio/clone()
	var/datum/computer_file/data/audio/A = ..()
	A.max_capacity = max_capacity
	A.used_capacity = used_capacity
	A.storedinfo = storedinfo
	A.timestamp = timestamp
	A.transcribed = transcribed
	return A
