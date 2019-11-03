// R&D tech file
/datum/computer_file/binary/tech
	filetype = "RDF"
	size = 8
	var/datum/technology/node = null

/datum/computer_file/binary/tech/proc/set_tech(datum/technology/new_tech)
	node = new_tech
	filename = sanitizeFileName(lowertext(node.name))
