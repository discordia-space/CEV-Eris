/datum/computer_file/program/dna
	filename = "dnaapp"
	filedesc = "Bla bla bla dna bla bla"
	program_icon_state = "generic"
	extended_desc = "Lorem Ipsum"
	size = 20
	available_on_ntnet = 1
	usage_flags = PROGRAM_LAPTOP
	nanomodule_path = /datum/nano_module/program/dna


/datum/nano_module/program/dna
	name = "Domino 2: Wraith of the Reere"


/datum/nano_module/program/dna/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
