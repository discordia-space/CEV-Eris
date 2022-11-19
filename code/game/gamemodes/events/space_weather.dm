/datum/storyevent/bluespace_storm
	id = "bluespace storm"
	name = "Bluespace storm"
	weight = 0.8
	parallel = FALSE
	tags = list(TAG_SCARY, TAG_NEGATIVE)

	var/duration = 9000 //In deciseconds, how long the weather lasts once it begins
	var/weather_duration_upper = 15000 //Highest possible duration
	var/weather_overlay //the thing that will be put as an overlay on our parallax
	
	//example - image("icon"='icons/mob/misc_overlays.dmi', "icon_state"="block", "layer"=BLOCKING_LAYER)

/datum/storyevent/bluespace_storm/announce()
	command_announcement.Announce("The scanners have detected a bluespace storm near the ship. Bluespace distortions are likely to happen while it lasts.", "Weather Alert")

/datum/storyevent/bluespace_storm/end()
	command_announcement.Announce("The bluespace storm has ended.", "Bluespace Storm")

/datum/event/bluespace_storm/tick()
	if(prob(2))
		var/area/A = random_ship_area(filter_maintenance = TRUE, filter_critical = TRUE)
		bluespace_distorsion(A.random_space())
