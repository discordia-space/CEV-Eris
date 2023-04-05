/// Manages overlays based off a key
// IT USES ONLY STRING KEYS!

/datum/component/overlay_manager
	var/atom/owner
	var/list/keyToOverlay

/datum/component/overlay_manager/Initialize(...)
	. = ..()
	if(!isatom(parent))
		message_admins("[parent] marked as incompatible")
		return COMPONENT_INCOMPATIBLE
	owner = parent
	keyToOverlay = list()

/datum/component/overlay_manager/proc/addOverlay(key, mutable_appearance/appearanceCopy, override = FALSE)
	if(keyToOverlay[key])
		if(override)
			updateOverlay(key, appearanceCopy, FALSE)
			return
		else
			CRASH("Tried to assign a overlay to a key which is already in use, the key being [key]")
	if(!appearanceCopy)
		CRASH("Tried to add an overlay without a appearance")
	keyToOverlay[key] = appearanceCopy
	// assignment changes a internal mutable appearance reference , hence we only use this one
	owner.overlays += keyToOverlay[key]

/datum/component/overlay_manager/proc/removeOverlay(key)
	if(!key)
		CRASH("Tried to remove a overlay without a key")
	if(!keyToOverlay[key])
		return
	owner.overlays -= keyToOverlay[key]
	keyToOverlay[key] = null

/datum/component/overlay_manager/proc/updateOverlay(key, mutable_appearance/appearanceCopy)
	removeOverlay(key)
	addOverlay(key, appearanceCopy)

