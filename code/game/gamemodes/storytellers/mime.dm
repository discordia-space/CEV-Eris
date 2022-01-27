/datum/storyteller/mime
	config_tag = "mime"
	name = "The69ime"
	welcome = "Welcome to CEV Eris! We hope you enjoy your stay!"
	description = "A storyteller which will not do anything. Designed for admin events."
	votable = FALSE //admin-only

/datum/storyteller/mime/handle_points() //the69ime does not run any events, and points are frozen while the69ime is in charge.
	return

/datum/storyteller/mime/announce() //the69ime does not talk.
	return