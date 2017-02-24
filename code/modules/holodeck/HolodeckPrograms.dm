var/global/list/holodeck_programs = list(
	"emptycourt" 		= new/datum/holodeck_program(/area/holodeck/source_emptycourt),
	"boxingcourt" 		= new/datum/holodeck_program(/area/holodeck/source_boxingcourt),
	"basketball" 		= new/datum/holodeck_program(/area/holodeck/source_basketball),
	"thunderdomecourt"	= new/datum/holodeck_program(/area/holodeck/source_thunderdomecourt),
	"beach" 			= new/datum/holodeck_program(/area/holodeck/source_beach),
	"desert" 			= new/datum/holodeck_program(/area/holodeck/source_desert,
													list(
														'sound/effects/wind/wind_2_1.ogg',
											 			'sound/effects/wind/wind_2_2.ogg',
											 			'sound/effects/wind/wind_3_1.ogg',
											 			'sound/effects/wind/wind_4_1.ogg',
											 			'sound/effects/wind/wind_4_2.ogg',
											 			'sound/effects/wind/wind_5_1.ogg'
												 		)
		 											),
	"snowfield" 		= new/datum/holodeck_program(/area/holodeck/source_snowfield,
													list(
														'sound/effects/wind/wind_2_1.ogg',
											 			'sound/effects/wind/wind_2_2.ogg',
											 			'sound/effects/wind/wind_3_1.ogg',
											 			'sound/effects/wind/wind_4_1.ogg',
											 			'sound/effects/wind/wind_4_2.ogg',
											 			'sound/effects/wind/wind_5_1.ogg'
												 		)
		 											),
	"space" 			= new/datum/holodeck_program(/area/holodeck/source_space,
													list(
														'sound/ambience/ambispace.ogg',
														)
													),
	"picnicarea" 		= new/datum/holodeck_program(/area/holodeck/source_picnicarea),
	"theatre" 			= new/datum/holodeck_program(/area/holodeck/source_theatre),
	"meetinghall" 		= new/datum/holodeck_program(/area/holodeck/source_meetinghall),
	"courtroom" 		= new/datum/holodeck_program(/area/holodeck/source_courtroom),
	"burntest" 			= new/datum/holodeck_program(/area/holodeck/source_burntest),
	"wildlifecarp" 		= new/datum/holodeck_program(/area/holodeck/source_wildlife),
	"turnoff" 			= new/datum/holodeck_program(/area/holodeck/source_plating)
	)

/datum/holodeck_program
	var/target
	var/list/ambience = null

/datum/holodeck_program/New(var/target, var/list/ambience = null)
	src.target = target
	src.ambience = ambience
