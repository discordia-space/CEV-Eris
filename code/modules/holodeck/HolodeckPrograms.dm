var/global/list/holodeck_programs = list(

	"texas" 			= new/datum/holodeck_program(/area/holodeck/source/texas),
	"spacebar" 		= new/datum/holodeck_program(/area/holodeck/source/spacebar),
	"turnoff" 			= new/datum/holodeck_program(/area/holodeck/source/off)
	)

/datum/holodeck_program
	var/target
	var/list/ambience = null

/datum/holodeck_program/New(var/target, var/list/ambience = null)
	src.target = target
	src.ambience = ambience
