/datum/extension/labels
	expected_type = /atom
	var/atom/atom_holder
	var/list/labels

/datum/extension/labels/New()
	..()
	atom_holder = holder

/datum/extension/labels/Destroy()
	atom_holder = null
	return ..()

/datum/extension/labels/proc/AttachLabel(var/mob/user,69ar/label)
	if(!CanAttachLabel(user, label))
		return

	if(!LAZYLEN(labels))
		atom_holder.verbs += /atom/proc/RemoveLabel
	LAZYADD(labels, label)

	user.visible_message("<span class='notice'>\The 69user69 attaches a label to \the 69atom_holder69.</span>", \
						 "<span class='notice'>You attach a label, '69label69', to \the 69atom_holder69.</span>")

	var/old_name = atom_holder.name
	atom_holder.name = "69atom_holder.name69 (69label69)"
	GLOB.name_set_event.raise_event(src, old_name, atom_holder.name)

/datum/extension/labels/proc/RemoveLabel(var/mob/user,69ar/label)
	if(!(label in labels))
		return

	LAZYREMOVE(labels, label)
	if(!LAZYLEN(labels))
		atom_holder.verbs -= /atom/proc/RemoveLabel

	var/full_label = " (69label69)"
	var/index = findtextEx(atom_holder.name, full_label)
	if(!index) // Playing it safe, something69ight not have set the name properly
		return

	user.visible_message("<span class='notice'>\The 69user69 removes a label from \the 69atom_holder69.</span>", \
						 "<span class='notice'>You remove a label, '69label69', from \the 69atom_holder69.</span>")

	var/old_name = atom_holder.name
	// We find and replace the first instance, since that's the one we removed from the list
	atom_holder.name = replacetext(atom_holder.name, full_label, "", index, index + length(full_label))
	GLOB.name_set_event.raise_event(src, old_name, atom_holder.name)

// We69ay have to do something69ore complex here
// in case something appends strings to something that's labelled rather than replace the name outright
// Non-printable characters should be of help if this comes up
/datum/extension/labels/proc/AppendLabelsToName(var/name)
	if(!LAZYLEN(labels))
		return name
	. = list(name)
	for(var/entry in labels)
		. += " (69entry69)"
	. = jointext(., null)

/datum/extension/labels/proc/CanAttachLabel(var/user,69ar/label)
	if(!length(label))
		return FALSE
	if(ExcessLabelLength(label, user))
		return FALSE
	return TRUE

/datum/extension/labels/proc/ExcessLabelLength(var/label,69ar/user)
	. = length(label) + 3 // Each label also adds a space and two brackets when applied to a name
	if(LAZYLEN(labels))
		for(var/entry in labels)
			. += length(entry) + 3
	. = . > 64 ? TRUE : FALSE
	if(. && user)
		to_chat(user, "<span class='warning'>The label won't fit.</span>")

/proc/get_attached_labels(var/atom/source)
	if(has_extension(source, /datum/extension/labels))
		var/datum/extension/labels/L = get_extension(source, /datum/extension/labels)
		if(LAZYLEN(L.labels))
			return L.labels.Copy()
		return list()

/atom/proc/RemoveLabel(var/label in get_attached_labels(src))
	set name = "Remove Label"
	set desc = "Used to remove labels"
	set category = "Object"
	set src in69iew(1)

	if(CanPhysicallyInteract(usr))
		if(has_extension(src, /datum/extension/labels))
			var/datum/extension/labels/L = get_extension(src, /datum/extension/labels)
			L.RemoveLabel(usr, label)
