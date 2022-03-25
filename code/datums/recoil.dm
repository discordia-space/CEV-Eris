
#define RECOILID "recoil-[recoil_buildup]-[brace_penalty]-[one_hand_penalty]"

#define RECOIL_BASE "recoil_buildup"
#define RECOIL_TWOHAND "brace_penalty"
#define RECOIL_ONEHAND "one_hand_penalty"


/proc/getRecoil(recoil_buildup = 0, brace_penalty = 0, one_hand_penalty = 0)
	. = locate(RECOILID)
	if(!.)
		. = new /datum/recoil(recoil_buildup, brace_penalty, one_hand_penalty)

/datum/recoil
	var/recoil_buildup
	var/brace_penalty
	var/one_hand_penalty

/datum/recoil/New(recoil_buildup = 0, brace_penalty = 0, one_hand_penalty = 0)
	src.recoil_buildup = recoil_buildup
	src.brace_penalty = brace_penalty
	src.one_hand_penalty = one_hand_penalty
	tag = RECOILID

/datum/recoil/proc/modifyRating(recoil_buildup = 0, brace_penalty = 0, one_hand_penalty = 0)
	return getRecoil(src.recoil_buildup*recoil_buildup, src.brace_penalty*brace_penalty, src.one_hand_penalty*one_hand_penalty)

/datum/recoil/proc/modifyAllRatings(modifier = 0)
	return getRecoil(recoil_buildup*modifier, brace_penalty*modifier, one_hand_penalty*modifier) // Set to multiply due to nature of recoil

/datum/recoil/proc/setRating(recoil_buildup, brace_penalty, one_hand_penalty)
  return getRecoil((isnull(recoil_buildup) ? src.recoil_buildup : recoil_buildup),\
				  (isnull(brace_penalty) ? src.brace_penalty : brace_penalty),\
				  (isnull(one_hand_penalty) ? src.one_hand_penalty : one_hand_penalty))

/datum/recoil/proc/getRating(rating)
	return vars[rating]

/datum/recoil/proc/getList()
	return list(RECOIL_BASE = recoil_buildup, RECOIL_TWOHAND = brace_penalty, RECOIL_ONEHAND = one_hand_penalty)

/datum/recoil/proc/setList(list/varList)
	recoil_buildup = varList[1]
	brace_penalty = varList[2]
	one_hand_penalty = varList[3]

/datum/recoil/proc/attachRecoil(datum/recoil/AA)
	return getRecoil(recoil_buildup+AA.recoil_buildup, brace_penalty+AA.brace_penalty, one_hand_penalty+AA.one_hand_penalty)

/datum/recoil/proc/detachRecoil(datum/recoil/AA)
	return getRecoil(recoil_buildup-AA.recoil_buildup, brace_penalty-AA.brace_penalty, one_hand_penalty-AA.one_hand_penalty)

#undef RECOILID
