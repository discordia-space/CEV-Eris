/datum/storyteller/mime
	config_tag = "mime"
	name = "The Mime"
	welcome = "Welcome to CEV Eris! We hope you enjoy your stay!"
	description = "A storyteller which will not do anything. Designed for admin events."
	votable = FALSE //admin-only

/datum/storyteller/mime/handle_points() //the mime does not run any events, and points are frozen while the mime is in charge.
	return

/datum/storyteller/mime/announce() //the mime does not talk.
	return