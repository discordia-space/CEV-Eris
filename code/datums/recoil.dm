
#define RECOILID "recoil-[recoil_buildup]-[brace_penalty]-[one_hand_penalty]"

#define RECOIL_BASE "recoil_buildup"
#define RECOIL_TWOHAND "brace_penalty"
#define RECOIL_ONEHAND "one_hand_penalty"
#define RECOIL_ONEHAND_LEVEL "one_hand_penalty_level"

/proc/getRecoil(recoil_buildup = 0, brace_penalty = 0, one_hand_penalty = 0)
	. = locate(RECOILID)
	if(!.)
		. = new /datum/recoil(recoil_buildup, brace_penalty, one_hand_penalty)

/datum/recoil
	var/recoil_buildup
	var/brace_penalty
	var/one_hand_penalty

	var/one_hand_penalty_level = 0

/datum/recoil/New(_recoil_buildup = 0, _brace_penalty = 0, _one_hand_penalty = 0)
	recoil_buildup = _recoil_buildup
	brace_penalty = _brace_penalty
	one_hand_penalty = _one_hand_penalty
	if(recoil_buildup)
		one_hand_penalty_level = one_hand_penalty / (recoil_buildup + brace_penalty)
	tag = RECOILID

/datum/recoil/proc/setRating(_recoil_buildup = 0, _brace_penalty = 0, _one_hand_penalty = 0)
  return getRecoil(	(isnull(_recoil_buildup)	? recoil_buildup	: _recoil_buildup)	,\
					(isnull(_brace_penalty)		? brace_penalty		: _brace_penalty)	,\
					(isnull(_one_hand_penalty)	? one_hand_penalty	: _one_hand_penalty))

/datum/recoil/proc/modifyRating(_recoil_buildup = 0, _brace_penalty = 0, _one_hand_penalty = 0)
	return getRecoil(recoil_buildup * _recoil_buildup, brace_penalty * _brace_penalty, one_hand_penalty * _one_hand_penalty)

/datum/recoil/proc/modifyAllRatings(modifier = 1)
	return getRecoil(recoil_buildup * modifier, one_hand_penalty * modifier) // Set to multiply due to nature of recoil

/datum/recoil/proc/getRating(rating)
	return vars[rating]

// Readable via recoil datum
/datum/recoil/proc/getList()
	return list(RECOIL_BASE = recoil_buildup, RECOIL_TWOHAND = brace_penalty, RECOIL_ONEHAND = one_hand_penalty)

// Better for nanoUI data
/datum/recoil/proc/getFancyList()
	return list("Recoil Buildup" = recoil_buildup, "Movement Penalty" = brace_penalty, "Onehanded Penalty" = one_hand_penalty)

/datum/recoil/proc/attachRecoil(datum/recoil/AA)
	return getRecoil(recoil_buildup+AA.recoil_buildup, brace_penalty+AA.brace_penalty, one_hand_penalty+AA.one_hand_penalty)

/datum/recoil/proc/detachRecoil(datum/recoil/AA)
	return getRecoil(recoil_buildup-AA.recoil_buildup, brace_penalty-AA.brace_penalty, one_hand_penalty-AA.one_hand_penalty)

#undef RECOILID
