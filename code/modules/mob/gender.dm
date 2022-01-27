
/var/list/datum/gender/gender_datums = list()

/hook/startup/proc/populate_gender_datum_list()
	for(var/type in typesof(/datum/gender))
		var/datum/gender/G =69ew type
		gender_datums69G.key69 = G
	return 1

/datum/gender
	var/key  = "plural"

	var/He   = "They"
	var/he   = "they"
	var/His  = "Their"
	var/his  = "their"
	var/him  = "them"
	var/has  = "have"
	var/is   = "are"
	var/does = "do"

/datum/gender/male
	key  = "male"

	He   = "He"
	he   = "he"
	His  = "His"
	his  = "his"
	him  = "him"
	has  = "has"
	is   = "is"
	does = "does"

/datum/gender/female
	key  = "female"

	He   = "She"
	he   = "she"
	His  = "Her"
	his  = "her"
	him  = "her"
	has  = "has"
	is   = "is"
	does = "does"

/datum/gender/neuter
	key = "neuter"

	He   = "It"
	he   = "it"
	His  = "Its"
	his  = "its"
	him  = "it"
	has  = "has"
	is   = "is"
	does = "does"
