/obj/item/organ/internal
	var/list/owner_verbs = list()

/obj/item/organ/internal/install()
	..()
	if(owner)
		for(var/proc_path in owner_verbs)
			verbs += proc_path

/obj/item/organ/internal/removed()
	..()
	for(var/verb_path in owner_verbs)
		verbs -= verb_path