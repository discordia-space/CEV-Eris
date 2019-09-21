/obj/effect/statclick/perk
	var/datum/perk/target_perk

/obj/effect/statclick/perk/Initialize(_, datum/perk/perk)
	target_perk = perk
	return ..(_, perk.name, perk)

/obj/effect/statclick/perk/update()
	name = target_perk.name
	desc = target_perk.desc
	icon = target_perk.icon
	icon_state = target_perk.icon_state + (target_perk.is_active() ? "-on" : "-off")

/obj/effect/statclick/perk/Click()
	target_perk.on_click()

/datum/perk
	var/name = "Perk"
	var/desc = ""
	var/icon
	var/icon_state = ""
	var/datum/stat_holder/holder
	var/active = TRUE
	var/toggleable = FALSE
	var/obj/effect/statclick/perk/statclick

/datum/perk/proc/update_stat()
	statclick.update()

/datum/perk/New()
	..()
	statclick = new(null, src)

/datum/perk/Destroy()
	holder?.perk_stat -= statclick
	holder?.perks -= src
	qdel(statclick)
	. = ..()

/datum/perk/proc/on_click()
	if(toggleable)
		toggle(usr)

/datum/perk/proc/toggle()
	if(is_active() && deactivate(holder))
		to_chat(usr, "You deactivate [src]")
	else if(activate(holder))
		to_chat(usr, "You activate [src]")

/datum/perk/proc/teach(datum/stat_holder/S)
	if(S.getPerk(type))
		return
	holder = S
	holder.perks += src
	holder.perk_stat += statclick
	update_stat()
	return TRUE

/datum/perk/proc/remove()
	on_remove()
	qdel(src)

/datum/perk/proc/on_remove()
	if(is_active())
		deactivate()

/datum/perk/proc/activate()
	if(is_active())
		return FALSE
	active = TRUE
	update_stat()
	return TRUE

/datum/perk/proc/deactivate()
	if(!is_active())
		return FALSE
	active = FALSE
	update_stat()
	return TRUE

/datum/perk/proc/is_active()
	return active
