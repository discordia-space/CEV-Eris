/obj/item/weapon/storage/bsdm
	name = "\improper BSDM unit"
	desc = "A Blue Space Direct Mail unit."
	icon_state = "box_of_doom" // placeholder
	max_storage_space = DEFAULT_NORMAL_STORAGE
	var/datum/mind/owner

/obj/item/weapon/storage/bsdm/attack_self(mob/user)
	if(owner == user.mind)
		return
	owner = user.mind
	to_chat(user, "You claim \the [src].")

/obj/item/weapon/storage/bsdm/verb/activate()
	set name = "Launch"
	set category = "Object"
	set src in oview(1)
	if(usr.incapacitated())
		return
	if(!(locate(/area/space) in oview(src)))
		to_chat(usr, "\The [src.name] must be placed near space.")
		return
	for(var/datum/antag_contract/item/C in GLOB.all_antag_contracts)
		if(C.completed)
			continue
		C.on_container(src)
	qdel(src)
