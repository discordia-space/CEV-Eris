/datum/debuginfo
	var/one = 1
	var/test = "text"

/datum/debuginfo1
	var/one = 213
	var/test = "asdadsa"
GLOBAL_VAR_INIT(global_vdebug, 99)
GLOBAL_DATUM_INIT(global_Ddebug, /datum/debuginfo1, new)
GLOBAL_LIST_EMPTY(global_ldebug)
GLOBAL_VAR(fuc)