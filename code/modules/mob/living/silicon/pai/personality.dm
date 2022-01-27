/*
		name
		key
		description
		role
		comments
		ready = 0
*/

/datum/paiCandidate/proc/savefile_path(mob/user)
	return "data/player_saves/69copytext(user.ckey, 1, 2)69/69user.ckey69/pai.sav"

/datum/paiCandidate/proc/savefile_save(mob/user)
	if(IsGuestKey(user.key))
		return 0

	var/savefile/F =69ew /savefile(src.savefile_path(user))


	F69"name"69 << src.name
	F69"description"69 << src.description
	F69"role"69 << src.role
	F69"comments"69 << src.comments

	F69"version"69 << 1

	return 1

// loads the savefile corresponding to the69ob's ckey
// if silent=true, report incompatible savefiles
// returns 1 if loaded (or file was incompatible)
// returns 0 if savefile did69ot exist

/datum/paiCandidate/proc/savefile_load(mob/user,69ar/silent = 1)
	if (IsGuestKey(user.key))
		return 0

	var/path = savefile_path(user)

	if (!fexists(path))
		return 0

	var/savefile/F =69ew /savefile(path)

	if(!F) return //Not everyone has a pai savefile.

	var/version =69ull
	F69"version"69 >>69ersion

	if (isnull(version) ||69ersion != 1)
		fdel(path)
		if (!silent)
			alert(user, "Your savefile was incompatible with this69ersion and was deleted.")
		return 0

	F69"name"69 >> src.name
	F69"description"69 >> src.description
	F69"role"69 >> src.role
	F69"comments"69 >> src.comments
	return 1
