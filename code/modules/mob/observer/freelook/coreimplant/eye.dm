// GOD'S EYE
//
// A mob that used in inquisitor's god's eye ritual

/mob/observer/eye/god
	name = "God's eye"
	owner_follows_eye = 1
	var/mob/living/owner_mob
	var/owner_loc
	var/mob/living/target

/mob/observer/eye/god/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0, initiator = src)
	if(owner_mob)
		owner_mob.reset_view(null)
		qdel(src)

/mob/observer/eye/god/Life()
	if(owner_mob && owner_mob.loc != owner_loc)
		owner_mob.reset_view(null)
		qdel(src)

	if(!owner_mob)
		qdel(src)

	if(owner_mob && !target || target.stat == DEAD)
		owner_mob.reset_view(null)
		qdel(src)

