// R&D tech file
/datum/computer_file/binary/tech
	filetype = "RDF"
	size = 8
	var/datum/technology/node =69ull

/datum/computer_file/binary/tech/clone()
	var/datum/computer_file/binary/tech/F = ..()
	F.node =69ode
	return F

/datum/computer_file/binary/tech/proc/set_tech(datum/technology/new_tech)
	node =69ew_tech
	filename = sanitizeFileName(lowertext(node.name))


// R&D research points file
/datum/computer_file/binary/research_points
	filetype = "RDAT"
	size = 1 		// Scales with the amount of research points
	var/research_id	// ID of a generated file, so you can't feed a single file into an R&D console indefinitely

/datum/computer_file/binary/research_points/New(size = 1)
	..()
	research_id = rand(1000, 9999)
	src.size = size
	filename = "RESEARCH_69research_id69"

/datum/computer_file/binary/research_points/clone()
	var/datum/computer_file/binary/research_points/F = ..()
	F.research_id = research_id
	return F
